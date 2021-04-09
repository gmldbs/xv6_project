#include "types.h"
#include "x86.h"
#include "defs.h"
#include "mmap.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

#define MMAPBASE 0x40000000
int cur_area=0;
int freemem_count=0;
int check=0;
int fork_check=0;
struct mmap_area areas[64];
uint mmap(uint addr, int length, int prot, int flags, int fd, int offset)
{
    struct proc *p = myproc();
    if((flags&MAP_PRIVATE)==0) return 0;

    areas[cur_area].f = p->ofile[fd];
    areas[cur_area].length = length;
    areas[cur_area].flags = flags;
    areas[cur_area].offset = offset;
    areas[cur_area].prot = prot;
    areas[cur_area].p = p;
    file_init_offset(p->ofile[fd],offset);
    uint allo_pos=0;

    if((flags&MAP_FIXED)!=0)
    {
        if(addr==0) return 0;
        for(int i=0;i<cur_area;i++)
        {
            int addr_area = areas[i].addr-MMAPBASE;
            if(areas[i].p->pid==p->pid&&((addr_area==addr)||(addr_area<addr&&(addr_area+areas[i].length>addr)))) return 0;
        }
        allo_pos=addr+MMAPBASE;
    }
    else 
    {
        int ck=1;
        int ck_cnt=0;
        int ck_arr[64];
        uint addr_ck;
        for(int i=0;i<cur_area;i++)
        {
            if(areas[i].p->pid==p->pid)
            {
                ck_arr[ck_cnt]=i;
                ck_cnt++;
            }
        }
        for(int i=0;i<ck_cnt;i++)
        {
            addr_ck=areas[ck_arr[i]].addr+areas[ck_arr[i]].length;
            for(int j=0;j<ck_cnt;j++)
            {
                uint addr2 = areas[ck_arr[j]].addr;
                if((addr_ck==addr2)||((addr_ck>addr2)&&(addr_ck<addr2+areas[ck_arr[j]].length))) {
                    ck=0;
                    break;
                }
            }
            if(ck==1) {
                allo_pos=addr_ck;
                break;
            }
        }
        if(ck==0) return 0;
        if(ck_cnt==0) allo_pos=MMAPBASE;
    }

    areas[cur_area].addr=allo_pos;
    
    if((flags&MAP_POPULATE)!=0)
    {
        for(int i=0;i<length/PGSIZE;i++)
        {
            char* mem;
            mem = kalloc();
            if(mem==0) return 0;
            memset(mem, 0, PGSIZE);
            if((flags&MAP_ANONYMOUS)==0) fileread(areas[cur_area].f,mem,PGSIZE);
               
            int loc=i*PGSIZE+areas[cur_area].addr;
            if(mappages(p->pgdir,(void*)loc, PGSIZE, V2P(mem), PTE_W|PTE_U)<0)
            {
                kfree(mem);
                cprintf("fault mappages\n");
                return 0;
            }
            if(p->sz<=loc+PGSIZE) growproc(PGSIZE);
        }

    }
    cur_area++;
    p->map_count++;
    return areas[cur_area-1].addr;
}

int munmap(uint addr)
{
    struct proc *p = myproc();
    int de_length=0;
    for(int i=0;i<cur_area;i++)
    {
        if(areas[i].p->pid==p->pid&&areas[i].addr==addr)
        {
            de_length=areas[i].length;
            for(int j=0;j<areas[i].length/PGSIZE;j++)
            {
                uint* pte_addr = walkpgdir(p->pgdir,(void*)(addr+j*PGSIZE),0);
                if(*pte_addr==0) break;
                if(*pte_addr!=0) 
                {
                    kfree((char*)(P2V(PTE_ADDR(*pte_addr))));
                    *pte_addr=0;
                }
            }
            for(int j=i;j<cur_area-1;j++)
            {
                areas[j].f=areas[j+1].f;
                areas[j].addr=areas[j+1].addr;
                areas[j].length=areas[j+1].length;
                areas[j].offset = areas[j+1].offset;
                areas[j].prot=areas[j+1].prot;
                areas[j].flags=areas[j+1].flags;
                areas[j].p=areas[j+1].p;
            }
            areas[cur_area].f=0;
            areas[cur_area].addr=0;
            areas[cur_area].length=0;
            areas[cur_area].offset=0;
            areas[cur_area].prot=0;
            areas[cur_area].flags=0;
            areas[cur_area].p=0;
            areas[cur_area].f=0;
            
            cur_area--;
            break;
        }
    }
    growproc(-1*de_length);
    
    return 1;
}
void mmap_fork(struct proc* parent, struct proc* child)
{
    for(int i=0;i<cur_area;i++)
    {
        if(areas[i].p->pid == parent->pid)
        {
            fork_check++;
            areas[cur_area].addr=areas[i].addr;
            areas[cur_area].f=areas[i].f;
            areas[cur_area].length=areas[i].length;
            areas[cur_area].offset=areas[i].offset;
            areas[cur_area].prot=areas[i].prot;
            areas[cur_area].flags=areas[i].flags;
            areas[cur_area].p=child;
            cur_area++;
        }
    }
}
int fork_ck()
{
    return fork_check;
}
int freemem()
{
    return freemem_count;
}
void inc_fm()
{
    freemem_count++;
}
void dec_fm()
{
    freemem_count--;
}
struct mmap_area find_area(struct proc *p, uint addr)
{
    struct mmap_area ck;
    for(int i=0;i<cur_area;i++)
    {
        if(p->pid==areas[i].p->pid&&(areas[i].addr<=addr)&&(areas[i].addr+areas[i].length>addr))
        {
           check=1;
           return areas[i]; 
        }
    }
    return ck;
}
int fill_read(struct proc *p, uint fault_addr)
{
    struct mmap_area ck;
    check=0;
    ck=find_area(p,fault_addr);
    if(check==0)
    {
        return -1;
    }
    file_init_offset(ck.f,ck.offset);
    for(int i=0;i<ck.length/PGSIZE;i++)
    {
        char* mem;
        mem = kalloc();
        if(mem==0) return 0;
        memset(mem, 0, PGSIZE);
        if((ck.flags&MAP_ANONYMOUS)==0) fileread(ck.f,mem,PGSIZE);
        int loc=i*PGSIZE+ck.addr;
        if(mappages(p->pgdir,(void*)loc, PGSIZE, V2P(mem), PTE_W|PTE_U)<0)
        {
            kfree(mem);
            cprintf("fault mappages\n");
            return -1;
        }
        if(p->sz<=loc+PGSIZE) growproc(PGSIZE);
    }
    return 1;

}
