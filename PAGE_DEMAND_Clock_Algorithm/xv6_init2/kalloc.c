// Physical memory allocator, intended to allocate
// memory for user processes, kernel stacks, page table pages,
// and pipe buffers. Allocates 4096-byte pages.

#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "spinlock.h"

void freerange(void *vstart, void *vend);
extern char end[]; // first address after kernel loaded from ELF file
                   // defined by the kernel linker script in kernel.ld
int reclaim(void);
void swap_out(struct page*);
void print_lru_list(void);
void print_swap_list(void);
struct spinlock pagelock;
struct spinlock lrulock;
struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  int use_lock;
  struct run *freelist;
} kmem;

struct page pages[PHYSTOP/PGSIZE];
struct page *page_lru_head;
int valid[PHYSTOP/PGSIZE];
int num_free_pages;
int num_lru_pages;


// Initialization happens in two phases.
// 1. main() calls kinit1() while still using entrypgdir to place just
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
    kfree(p);
}
// Free the page of physical memory pointed at by v,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
  struct run *r;
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
      panic("kfree");
      // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  num_free_pages++;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
  struct run *r;
try_again:
  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = kmem.freelist;
  if(!r)
  {
      if(kmem.use_lock) release(&kmem.lock);
      if(!reclaim()) 
      {
          cprintf("fault reclaim() : Out Of Memory\n");
          return 0;
      }
      goto try_again;
  }
  if(r)
  {
      kmem.freelist = r->next;
      num_free_pages--;
  }
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
int reclaim()
{
   // acquire(&pagelock);
    if(num_lru_pages<=0) {
     //   release(&pagelock);
        return 0;
    }

    struct page* n = page_lru_head;
    while(1)
    {
        pte_t* pte = walkpgdir(n->pgdir,(void*)n->vaddr,0);
        if(((*pte&PTE_U)!=0)&&((*pte&PTE_A)==0)) 
        {
            swap_out(n);
            return 1;
        }
        if(n->next==page_lru_head) break;
        n=n->next;
    }
    int ck=0;
    n=page_lru_head;
    for(int i=0;i<num_lru_pages;i++)
    {
        pte_t* pte = walkpgdir(n->pgdir,(void*)n->vaddr,0);
        if((*pte&PTE_U)!=0) {
            ck=1;
            break;
        }
        n=n->next;
    }
    if(ck) 
    {
        swap_out(n);
        return 1;
    }
    //release(&pagelock);
    return 0;
}
void swap_out(struct page* n)
{  
    acquire(&pagelock);
    pte_t* pte = walkpgdir(n->pgdir,(void*)n->vaddr,0);
    int offset=0;
    for(int i=1;i<PHYSTOP/PGSIZE;i++)
    {
        if(valid[i]==0)
        {
            offset=i;
            break;
        }
    }
 
    uint origin_addr = PTE_ADDR(*pte);
    int flags = *pte%4096-1;
    valid[offset]=1;
    page_lru_head=n->next;
    n->prev->next=n->next;
    n->next->prev=n->prev;
    n->prev=0;
    n->next=0;
    n->pgdir=0;
    n->vaddr=0;
    num_lru_pages--;
    *pte = (offset*4096)|PTE_SWAP|flags;
    release(&pagelock);
    swapwrite((char*)P2V(origin_addr),offset);
    kfree((char*)P2V(origin_addr));
    return;
}
struct page* find_page()
{
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
        if(pages[i].pgdir==0) return &pages[i];
    return 0;
}
void add_pglist(char* va, pde_t *pgdir)
{
    acquire(&lrulock);
    struct page* n = find_page();
    if(n==0) panic("Full pages array");
    num_lru_pages++;
    
    n->vaddr=va;
    n->pgdir=pgdir;
    
    if(num_lru_pages==1) 
    {
        page_lru_head=n;
        page_lru_head->prev=page_lru_head;
        page_lru_head->next=page_lru_head;
    }
    else if(num_lru_pages==2)
    {
        n->prev=page_lru_head;
        n->next=page_lru_head;
        page_lru_head->next=n;
        page_lru_head->prev=n;
    }
    else
    {
        n->prev = page_lru_head->prev;
        n->next = page_lru_head;
        page_lru_head->prev->next=n;
        page_lru_head->prev = n;
    }
    release(&lrulock);
}
void print_lru_list(void)
{
    cprintf("------------lru page list----num_lru_pages=%d, num_free_pages=%d--\n",num_lru_pages,num_free_pages);
    int i=0;
    struct page* n = page_lru_head;
    while(1)
    {
        cprintf("%dth *pte = %x\n",i,*walkpgdir(n->pgdir,(void*)n->vaddr,0));
        if(n->next==page_lru_head) break;
        i++;
        n=n->next;
    }

}
int delete_pages(char* va, pde_t* pgdir)
{
    acquire(&lrulock);
    pte_t* pte= walkpgdir(pgdir,va,0);
    if(num_lru_pages==0) {
        release(&lrulock);
        return 0;
    }
    int index=*pte/4096;
    if((*pte)&PTE_SWAP)
    {
        valid[index]=0;
        release(&lrulock);
        return 2;
    }
    else
    {
        struct page* n = page_lru_head;
        for(;;)
        {
            if(n->pgdir == pgdir && n->vaddr == va)
            {
                if(n==page_lru_head) page_lru_head=n->next;
                n->prev->next=n->next;
                n->next->prev=n->prev;
                n->prev=0;
                n->next=0;
                n->pgdir=0;
                n->vaddr=0;
                num_lru_pages--;
                release(&lrulock);
                return 1;
            }
            n=n->next;
            if(n==page_lru_head) break;
        }
    }
    release(&lrulock);
    return 0;
}

void PGFLT_proc(uint fault_addr, pde_t *pgdir)
{

    pte_t* pte_fault = walkpgdir(pgdir,(void*)fault_addr,0);
    int swap_index = *pte_fault/4096;
    if((*pte_fault&PTE_SWAP)==0) return;
    if(num_free_pages==0&&reclaim()==0) 
    {
        cprintf("reclaim fault\n");
        exit();
    }
    char* mem = kalloc();
    if(mem==0) return;
    valid[swap_index]=0;
    memset(mem,0,PGSIZE);
    *pte_fault=V2P(mem)|(*pte_fault%4096+1-0x100);
    add_pglist((char*)fault_addr,pgdir);
    swapread(mem,swap_index);
}

void print_swap_list(void)
{
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
    {
        if(valid[i]==1) cprintf("%dth swap is valid\n",i);
    }
}
void copy_swap(pde_t* pgdir, pde_t* new_pgdir, int i)
{
    pte_t* pte = walkpgdir(pgdir,(void*)i,0);
    int oldoff=*pte/4096;
    int newoff=0;
    for(int i=1;i<PHYSTOP/PGSIZE;i++)
    {
        if(valid[i]==0)
        {
            newoff=i;
            break;
        }
    }
    copy_swap_data(oldoff,newoff);
    pte_t* new_pte=walkpgdir(new_pgdir,(void*)i,0);
    *new_pte=(newoff*4096)+(*pte%4096);
}
