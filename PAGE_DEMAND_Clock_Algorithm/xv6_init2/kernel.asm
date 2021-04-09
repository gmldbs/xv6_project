
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 36 10 80       	mov    $0x801036f0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 c0 79 10 80       	push   $0x801079c0
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 65 4a 00 00       	call   80104ac0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 c7 79 10 80       	push   $0x801079c7
80100097:	50                   	push   %eax
80100098:	e8 f3 48 00 00       	call   80104990 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 17 4b 00 00       	call   80104c00 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 59 4b 00 00       	call   80104cc0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 48 00 00       	call   801049d0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 21 00 00       	call   801022f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ce 79 10 80       	push   $0x801079ce
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 bd 48 00 00       	call   80104a70 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 27 21 00 00       	jmp    801022f0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 79 10 80       	push   $0x801079df
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 7c 48 00 00       	call   80104a70 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 2c 48 00 00       	call   80104a30 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 f0 49 00 00       	call   80104c00 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 5f 4a 00 00       	jmp    80104cc0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 79 10 80       	push   $0x801079e6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 6f 49 00 00       	call   80104c00 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 46 43 00 00       	call   80104610 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 50 3d 00 00       	call   80104030 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 cc 49 00 00       	call   80104cc0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 6e 49 00 00       	call   80104cc0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 d2 2b 00 00       	call   80102f80 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ed 79 10 80       	push   $0x801079ed
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 8b 84 10 80 	movl   $0x8010848b,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 03 47 00 00       	call   80104ae0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 01 7a 10 80       	push   $0x80107a01
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 91 60 00 00       	call   801064d0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 df 5f 00 00       	call   801064d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 5f 00 00       	call   801064d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 5f 00 00       	call   801064d0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 a7 48 00 00       	call   80104dd0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 da 47 00 00       	call   80104d20 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 05 7a 10 80       	push   $0x80107a05
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 30 7a 10 80 	movzbl -0x7fef85d0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 e0 45 00 00       	call   80104c00 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 74 46 00 00       	call   80104cc0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 9c 45 00 00       	call   80104cc0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 18 7a 10 80       	mov    $0x80107a18,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 0b 44 00 00       	call   80104c00 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 1f 7a 10 80       	push   $0x80107a1f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 d8 43 00 00       	call   80104c00 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 33 44 00 00       	call   80104cc0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 a5 3e 00 00       	call   801047c0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 34 3f 00 00       	jmp    801048d0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 28 7a 10 80       	push   $0x80107a28
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 eb 40 00 00       	call   80104ac0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 a2 1a 00 00       	call   801024a0 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 0f 36 00 00       	call   80104030 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 c4 29 00 00       	call   801033f0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 ec 29 00 00       	call   80103460 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 27 6c 00 00       	call   801076c0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 b5 69 00 00       	call   801074b0 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 c3 68 00 00       	call   801073f0 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 c9 6a 00 00       	call   80107640 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 c1 28 00 00       	call   80103460 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 01 69 00 00       	call   801074b0 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 7a 6a 00 00       	call   80107640 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 88 28 00 00       	call   80103460 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 41 7a 10 80       	push   $0x80107a41
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 55 6b 00 00       	call   80107760 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 02 43 00 00       	call   80104f40 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 ef 42 00 00       	call   80104f40 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 6c 00 00       	call   80107920 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 54 6c 00 00       	call   80107920 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 f1 41 00 00       	call   80104f00 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 e7 64 00 00       	call   80107220 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 ff 68 00 00       	call   80107640 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 4d 7a 10 80       	push   $0x80107a4d
80100d6b:	68 c0 0f 11 80       	push   $0x80110fc0
80100d70:	e8 4b 3d 00 00       	call   80104ac0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 0f 11 80       	push   $0x80110fc0
80100d91:	e8 6a 3e 00 00       	call   80104c00 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 0f 11 80       	push   $0x80110fc0
80100dc1:	e8 fa 3e 00 00       	call   80104cc0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 0f 11 80       	push   $0x80110fc0
80100dda:	e8 e1 3e 00 00       	call   80104cc0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 0f 11 80       	push   $0x80110fc0
80100dff:	e8 fc 3d 00 00       	call   80104c00 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 0f 11 80       	push   $0x80110fc0
80100e1c:	e8 9f 3e 00 00       	call   80104cc0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 54 7a 10 80       	push   $0x80107a54
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e51:	e8 aa 3d 00 00       	call   80104c00 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 3f 3e 00 00       	jmp    80104cc0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 13 3e 00 00       	call   80104cc0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 ca 2c 00 00       	call   80103ba0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 0b 25 00 00       	call   801033f0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 61 25 00 00       	jmp    80103460 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 5c 7a 10 80       	push   $0x80107a5c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 7e 2d 00 00       	jmp    80103d50 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 66 7a 10 80       	push   $0x80107a66
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 12 24 00 00       	call   80103460 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 75 23 00 00       	call   801033f0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 ae 23 00 00       	call   80103460 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 4e 2b 00 00       	jmp    80103c40 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 6f 7a 10 80       	push   $0x80107a6f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 75 7a 10 80       	push   $0x80107a75
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c4 19 11 80    	mov    0x801119c4,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 dc 19 11 80    	add    0x801119dc,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c4 19 11 80       	mov    0x801119c4,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c4 19 11 80    	cmp    %eax,0x801119c4
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 7f 7a 10 80       	push   $0x80107a7f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 ee 23 00 00       	call   801035c0 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 26 3b 00 00       	call   80104d20 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 be 23 00 00       	call   801035c0 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 34 1a 11 80       	mov    $0x80111a34,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 00 1a 11 80       	push   $0x80111a00
8010123a:	e8 c1 39 00 00       	call   80104c00 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 54 36 11 80    	cmp    $0x80113654,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 00 1a 11 80       	push   $0x80111a00
8010129f:	e8 1c 3a 00 00       	call   80104cc0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 00 1a 11 80       	push   $0x80111a00
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 ee 39 00 00       	call   80104cc0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 95 7a 10 80       	push   $0x80107a95
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 5d 22 00 00       	call   801035c0 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 a5 7a 10 80       	push   $0x80107aa5
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 da 39 00 00       	call   80104dd0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c4 19 11 80       	push   $0x801119c4
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 dc 19 11 80    	add    0x801119dc,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 51 21 00 00       	call   801035c0 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 b8 7a 10 80       	push   $0x80107ab8
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 40 1a 11 80       	mov    $0x80111a40,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 cb 7a 10 80       	push   $0x80107acb
801014a1:	68 00 1a 11 80       	push   $0x80111a00
801014a6:	e8 15 36 00 00       	call   80104ac0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 d2 7a 10 80       	push   $0x80107ad2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 cc 34 00 00       	call   80104990 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 60 36 11 80    	cmp    $0x80113660,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c4 19 11 80       	push   $0x801119c4
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 dc 19 11 80    	pushl  0x801119dc
801014e5:	ff 35 d8 19 11 80    	pushl  0x801119d8
801014eb:	ff 35 d4 19 11 80    	pushl  0x801119d4
801014f1:	ff 35 d0 19 11 80    	pushl  0x801119d0
801014f7:	ff 35 cc 19 11 80    	pushl  0x801119cc
801014fd:	ff 35 c8 19 11 80    	pushl  0x801119c8
80101503:	ff 35 c4 19 11 80    	pushl  0x801119c4
80101509:	68 54 7b 10 80       	push   $0x80107b54
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d cc 19 11 80 01 	cmpl   $0x1,0x801119cc
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d cc 19 11 80    	cmp    %ebx,0x801119cc
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 7d 37 00 00       	call   80104d20 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 0b 20 00 00       	call   801035c0 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 d8 7a 10 80       	push   $0x80107ad8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 8a 37 00 00       	call   80104dd0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 72 1f 00 00       	call   801035c0 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 00 1a 11 80       	push   $0x80111a00
8010166f:	e8 8c 35 00 00       	call   80104c00 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010167f:	e8 3c 36 00 00       	call   80104cc0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 19 33 00 00       	call   801049d0 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 a3 36 00 00       	call   80104dd0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 f0 7a 10 80       	push   $0x80107af0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ea 7a 10 80       	push   $0x80107aea
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 e8 32 00 00       	call   80104a70 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 8c 32 00 00       	jmp    80104a30 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 ff 7a 10 80       	push   $0x80107aff
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 fb 31 00 00       	call   801049d0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 41 32 00 00       	call   80104a30 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
801017f6:	e8 05 34 00 00       	call   80104c00 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 00 1a 11 80 	movl   $0x80111a00,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 ab 34 00 00       	jmp    80104cc0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 00 1a 11 80       	push   $0x80111a00
80101820:	e8 db 33 00 00       	call   80104c00 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
8010182f:	e8 8c 34 00 00       	call   80104cc0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 b4 33 00 00       	call   80104dd0 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 b8 32 00 00       	call   80104dd0 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 a0 1a 00 00       	call   801035c0 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 8d 32 00 00       	call   80104e40 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 2e 32 00 00       	call   80104e40 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 19 7b 10 80       	push   $0x80107b19
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 07 7b 10 80       	push   $0x80107b07
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 a2 23 00 00       	call   80104030 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 00 1a 11 80       	push   $0x80111a00
80101c99:	e8 62 2f 00 00       	call   80104c00 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 00 1a 11 80 	movl   $0x80111a00,(%esp)
80101ca9:	e8 12 30 00 00       	call   80104cc0 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 c6 30 00 00       	call   80104dd0 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 33 30 00 00       	call   80104dd0 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 0e 30 00 00       	call   80104ea0 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 28 7b 10 80       	push   $0x80107b28
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 2a 82 10 80       	push   $0x8010822a
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f30 <swapread>:

void swapread(char* ptr, int blkno)
{
80101f30:	55                   	push   %ebp
80101f31:	89 e5                	mov    %esp,%ebp
80101f33:	57                   	push   %edi
80101f34:	56                   	push   %esi
80101f35:	53                   	push   %ebx
80101f36:	83 ec 1c             	sub    $0x1c,%esp
80101f39:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX/8 )
80101f3c:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80101f42:	77 63                	ja     80101fa7 <swapread+0x77>
        panic("swapread: blkno exceed range");
	for ( i=0; i < 8; ++i ) {
		nr_sectors_read++;
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80101f44:	c1 e7 03             	shl    $0x3,%edi
80101f47:	8b 75 08             	mov    0x8(%ebp),%esi
80101f4a:	8d 87 fc 01 00 00    	lea    0x1fc(%edi),%eax
80101f50:	8d 9f f4 01 00 00    	lea    0x1f4(%edi),%ebx
80101f56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f60:	83 ec 08             	sub    $0x8,%esp
		nr_sectors_read++;
80101f63:	83 05 c0 19 11 80 01 	addl   $0x1,0x801119c0
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80101f6a:	53                   	push   %ebx
80101f6b:	6a 00                	push   $0x0
80101f6d:	83 c3 01             	add    $0x1,%ebx
80101f70:	e8 5b e1 ff ff       	call   801000d0 <bread>
80101f75:	89 c7                	mov    %eax,%edi
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
80101f77:	8d 40 5c             	lea    0x5c(%eax),%eax
80101f7a:	83 c4 0c             	add    $0xc,%esp
80101f7d:	68 00 02 00 00       	push   $0x200
80101f82:	50                   	push   %eax
80101f83:	56                   	push   %esi
80101f84:	81 c6 00 02 00 00    	add    $0x200,%esi
80101f8a:	e8 41 2e 00 00       	call   80104dd0 <memmove>
		brelse(bp);
80101f8f:	89 3c 24             	mov    %edi,(%esp)
80101f92:	e8 49 e2 ff ff       	call   801001e0 <brelse>
	for ( i=0; i < 8; ++i ) {
80101f97:	83 c4 10             	add    $0x10,%esp
80101f9a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80101f9d:	75 c1                	jne    80101f60 <swapread+0x30>
	}
}
80101f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fa2:	5b                   	pop    %ebx
80101fa3:	5e                   	pop    %esi
80101fa4:	5f                   	pop    %edi
80101fa5:	5d                   	pop    %ebp
80101fa6:	c3                   	ret    
        panic("swapread: blkno exceed range");
80101fa7:	83 ec 0c             	sub    $0xc,%esp
80101faa:	68 35 7b 10 80       	push   $0x80107b35
80101faf:	e8 dc e3 ff ff       	call   80100390 <panic>
80101fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fc0 <swapwrite>:

void swapwrite(char* ptr, int blkno)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
80101fc6:	83 ec 1c             	sub    $0x1c,%esp
80101fc9:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX/8 )
80101fcc:	81 ff 94 30 00 00    	cmp    $0x3094,%edi
80101fd2:	77 6b                	ja     8010203f <swapwrite+0x7f>
        panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		nr_sectors_write++;
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80101fd4:	c1 e7 03             	shl    $0x3,%edi
80101fd7:	8b 75 08             	mov    0x8(%ebp),%esi
80101fda:	8d 87 fc 01 00 00    	lea    0x1fc(%edi),%eax
80101fe0:	8d 9f f4 01 00 00    	lea    0x1f4(%edi),%ebx
80101fe6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ff0:	83 ec 08             	sub    $0x8,%esp
		nr_sectors_write++;
80101ff3:	83 05 e0 19 11 80 01 	addl   $0x1,0x801119e0
		bp = bread(0, blkno * 8 + SWAPBASE + i);
80101ffa:	53                   	push   %ebx
80101ffb:	6a 00                	push   $0x0
80101ffd:	83 c3 01             	add    $0x1,%ebx
80102000:	e8 cb e0 ff ff       	call   801000d0 <bread>
80102005:	89 c7                	mov    %eax,%edi
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
80102007:	8d 40 5c             	lea    0x5c(%eax),%eax
8010200a:	83 c4 0c             	add    $0xc,%esp
8010200d:	68 00 02 00 00       	push   $0x200
80102012:	56                   	push   %esi
80102013:	81 c6 00 02 00 00    	add    $0x200,%esi
80102019:	50                   	push   %eax
8010201a:	e8 b1 2d 00 00       	call   80104dd0 <memmove>
		bwrite(bp);
8010201f:	89 3c 24             	mov    %edi,(%esp)
80102022:	e8 79 e1 ff ff       	call   801001a0 <bwrite>
		brelse(bp);
80102027:	89 3c 24             	mov    %edi,(%esp)
8010202a:	e8 b1 e1 ff ff       	call   801001e0 <brelse>
	for ( i=0; i < 8; ++i ) {
8010202f:	83 c4 10             	add    $0x10,%esp
80102032:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80102035:	75 b9                	jne    80101ff0 <swapwrite+0x30>
	}
}
80102037:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010203a:	5b                   	pop    %ebx
8010203b:	5e                   	pop    %esi
8010203c:	5f                   	pop    %edi
8010203d:	5d                   	pop    %ebp
8010203e:	c3                   	ret    
        panic("swapread: blkno exceed range");
8010203f:	83 ec 0c             	sub    $0xc,%esp
80102042:	68 35 7b 10 80       	push   $0x80107b35
80102047:	e8 44 e3 ff ff       	call   80100390 <panic>
8010204c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102050 <copy_swap_data>:

void copy_swap_data(int oldoff, int newoff)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 1c             	sub    $0x1c,%esp
80102059:	8b 45 0c             	mov    0xc(%ebp),%eax
    struct buf* new;
    struct buf* old;
    if( newoff < 0 || newoff >= SWAPMAX/8)
8010205c:	3d 94 30 00 00       	cmp    $0x3094,%eax
80102061:	0f 87 87 00 00 00    	ja     801020ee <copy_swap_data+0x9e>
        panic("copy_swap : blkno exceed range");

    for(int i=0;i<8;i++)
    {
        new = bread(0, newoff*8+SWAPBASE+i);
        old = bread(0, oldoff*8+SWAPBASE+i);
80102067:	8b 55 08             	mov    0x8(%ebp),%edx
        new = bread(0, newoff*8+SWAPBASE+i);
8010206a:	c1 e0 03             	shl    $0x3,%eax
8010206d:	8d 88 fc 01 00 00    	lea    0x1fc(%eax),%ecx
80102073:	8d b8 f4 01 00 00    	lea    0x1f4(%eax),%edi
        old = bread(0, oldoff*8+SWAPBASE+i);
80102079:	8d 34 d5 00 00 00 00 	lea    0x0(,%edx,8),%esi
80102080:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102083:	29 c6                	sub    %eax,%esi
80102085:	89 75 e0             	mov    %esi,-0x20(%ebp)
80102088:	90                   	nop
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        new = bread(0, newoff*8+SWAPBASE+i);
80102090:	83 ec 08             	sub    $0x8,%esp
80102093:	57                   	push   %edi
80102094:	6a 00                	push   $0x0
80102096:	e8 35 e0 ff ff       	call   801000d0 <bread>
8010209b:	89 c3                	mov    %eax,%ebx
        old = bread(0, oldoff*8+SWAPBASE+i);
8010209d:	58                   	pop    %eax
8010209e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801020a1:	5a                   	pop    %edx
801020a2:	01 f8                	add    %edi,%eax
801020a4:	83 c7 01             	add    $0x1,%edi
801020a7:	50                   	push   %eax
801020a8:	6a 00                	push   $0x0
801020aa:	e8 21 e0 ff ff       	call   801000d0 <bread>
801020af:	89 c6                	mov    %eax,%esi
        memmove(new->data, old->data, BSIZE);
801020b1:	8d 40 5c             	lea    0x5c(%eax),%eax
801020b4:	83 c4 0c             	add    $0xc,%esp
801020b7:	68 00 02 00 00       	push   $0x200
801020bc:	50                   	push   %eax
801020bd:	8d 43 5c             	lea    0x5c(%ebx),%eax
801020c0:	50                   	push   %eax
801020c1:	e8 0a 2d 00 00       	call   80104dd0 <memmove>
        bwrite(new);
801020c6:	89 1c 24             	mov    %ebx,(%esp)
801020c9:	e8 d2 e0 ff ff       	call   801001a0 <bwrite>
        brelse(old);
801020ce:	89 34 24             	mov    %esi,(%esp)
801020d1:	e8 0a e1 ff ff       	call   801001e0 <brelse>
        brelse(new);
801020d6:	89 1c 24             	mov    %ebx,(%esp)
801020d9:	e8 02 e1 ff ff       	call   801001e0 <brelse>
    for(int i=0;i<8;i++)
801020de:	83 c4 10             	add    $0x10,%esp
801020e1:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801020e4:	75 aa                	jne    80102090 <copy_swap_data+0x40>
    }
}
801020e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020e9:	5b                   	pop    %ebx
801020ea:	5e                   	pop    %esi
801020eb:	5f                   	pop    %edi
801020ec:	5d                   	pop    %ebp
801020ed:	c3                   	ret    
        panic("copy_swap : blkno exceed range");
801020ee:	83 ec 0c             	sub    $0xc,%esp
801020f1:	68 a8 7b 10 80       	push   $0x80107ba8
801020f6:	e8 95 e2 ff ff       	call   80100390 <panic>
801020fb:	66 90                	xchg   %ax,%ax
801020fd:	66 90                	xchg   %ax,%ax
801020ff:	90                   	nop

80102100 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102100:	55                   	push   %ebp
  if(b == 0)
80102101:	85 c0                	test   %eax,%eax
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	56                   	push   %esi
80102106:	53                   	push   %ebx
  if(b == 0)
80102107:	0f 84 af 00 00 00    	je     801021bc <idestart+0xbc>
    panic("idestart");
  if(b->blockno >= FSSIZE)
8010210d:	8b 58 08             	mov    0x8(%eax),%ebx
80102110:	89 c6                	mov    %eax,%esi
80102112:	81 fb 9f 86 01 00    	cmp    $0x1869f,%ebx
80102118:	0f 87 91 00 00 00    	ja     801021af <idestart+0xaf>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010211e:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102123:	90                   	nop
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102128:	89 ca                	mov    %ecx,%edx
8010212a:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010212b:	83 e0 c0             	and    $0xffffffc0,%eax
8010212e:	3c 40                	cmp    $0x40,%al
80102130:	75 f6                	jne    80102128 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102132:	31 c0                	xor    %eax,%eax
80102134:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102139:	ee                   	out    %al,(%dx)
8010213a:	b8 01 00 00 00       	mov    $0x1,%eax
8010213f:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102144:	ee                   	out    %al,(%dx)
80102145:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010214a:	89 d8                	mov    %ebx,%eax
8010214c:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
8010214d:	89 d8                	mov    %ebx,%eax
8010214f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102154:	c1 f8 08             	sar    $0x8,%eax
80102157:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80102158:	89 d8                	mov    %ebx,%eax
8010215a:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010215f:	c1 f8 10             	sar    $0x10,%eax
80102162:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102163:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80102167:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010216c:	c1 e0 04             	shl    $0x4,%eax
8010216f:	83 e0 10             	and    $0x10,%eax
80102172:	83 c8 e0             	or     $0xffffffe0,%eax
80102175:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102176:	f6 06 04             	testb  $0x4,(%esi)
80102179:	75 15                	jne    80102190 <idestart+0x90>
8010217b:	b8 20 00 00 00       	mov    $0x20,%eax
80102180:	89 ca                	mov    %ecx,%edx
80102182:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102183:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102186:	5b                   	pop    %ebx
80102187:	5e                   	pop    %esi
80102188:	5d                   	pop    %ebp
80102189:	c3                   	ret    
8010218a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102190:	b8 30 00 00 00       	mov    $0x30,%eax
80102195:	89 ca                	mov    %ecx,%edx
80102197:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102198:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
8010219d:	83 c6 5c             	add    $0x5c,%esi
801021a0:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021a5:	fc                   	cld    
801021a6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801021ab:	5b                   	pop    %ebx
801021ac:	5e                   	pop    %esi
801021ad:	5d                   	pop    %ebp
801021ae:	c3                   	ret    
    panic("incorrect blockno");
801021af:	83 ec 0c             	sub    $0xc,%esp
801021b2:	68 d0 7b 10 80       	push   $0x80107bd0
801021b7:	e8 d4 e1 ff ff       	call   80100390 <panic>
    panic("idestart");
801021bc:	83 ec 0c             	sub    $0xc,%esp
801021bf:	68 c7 7b 10 80       	push   $0x80107bc7
801021c4:	e8 c7 e1 ff ff       	call   80100390 <panic>
801021c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021d0 <ideinit>:
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021d6:	68 e2 7b 10 80       	push   $0x80107be2
801021db:	68 80 b5 10 80       	push   $0x8010b580
801021e0:	e8 db 28 00 00       	call   80104ac0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021e5:	58                   	pop    %eax
801021e6:	a1 c0 bd 22 80       	mov    0x8022bdc0,%eax
801021eb:	5a                   	pop    %edx
801021ec:	83 e8 01             	sub    $0x1,%eax
801021ef:	50                   	push   %eax
801021f0:	6a 0e                	push   $0xe
801021f2:	e8 a9 02 00 00       	call   801024a0 <ioapicenable>
801021f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021ff:	90                   	nop
80102200:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102201:	83 e0 c0             	and    $0xffffffc0,%eax
80102204:	3c 40                	cmp    $0x40,%al
80102206:	75 f8                	jne    80102200 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102208:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010220d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102212:	ee                   	out    %al,(%dx)
80102213:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102218:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221d:	eb 06                	jmp    80102225 <ideinit+0x55>
8010221f:	90                   	nop
  for(i=0; i<1000; i++){
80102220:	83 e9 01             	sub    $0x1,%ecx
80102223:	74 0f                	je     80102234 <ideinit+0x64>
80102225:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102226:	84 c0                	test   %al,%al
80102228:	74 f6                	je     80102220 <ideinit+0x50>
      havedisk1 = 1;
8010222a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102231:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102234:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102239:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010223e:	ee                   	out    %al,(%dx)
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    
80102241:	eb 0d                	jmp    80102250 <ideintr>
80102243:	90                   	nop
80102244:	90                   	nop
80102245:	90                   	nop
80102246:	90                   	nop
80102247:	90                   	nop
80102248:	90                   	nop
80102249:	90                   	nop
8010224a:	90                   	nop
8010224b:	90                   	nop
8010224c:	90                   	nop
8010224d:	90                   	nop
8010224e:	90                   	nop
8010224f:	90                   	nop

80102250 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102250:	55                   	push   %ebp
80102251:	89 e5                	mov    %esp,%ebp
80102253:	57                   	push   %edi
80102254:	56                   	push   %esi
80102255:	53                   	push   %ebx
80102256:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102259:	68 80 b5 10 80       	push   $0x8010b580
8010225e:	e8 9d 29 00 00       	call   80104c00 <acquire>

  if((b = idequeue) == 0){
80102263:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102269:	83 c4 10             	add    $0x10,%esp
8010226c:	85 db                	test   %ebx,%ebx
8010226e:	74 67                	je     801022d7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102270:	8b 43 58             	mov    0x58(%ebx),%eax
80102273:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102278:	8b 3b                	mov    (%ebx),%edi
8010227a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102280:	75 31                	jne    801022b3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102282:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102287:	89 f6                	mov    %esi,%esi
80102289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102290:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102291:	89 c6                	mov    %eax,%esi
80102293:	83 e6 c0             	and    $0xffffffc0,%esi
80102296:	89 f1                	mov    %esi,%ecx
80102298:	80 f9 40             	cmp    $0x40,%cl
8010229b:	75 f3                	jne    80102290 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010229d:	a8 21                	test   $0x21,%al
8010229f:	75 12                	jne    801022b3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801022a1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022a4:	b9 80 00 00 00       	mov    $0x80,%ecx
801022a9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022ae:	fc                   	cld    
801022af:	f3 6d                	rep insl (%dx),%es:(%edi)
801022b1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022b3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801022b6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022b9:	89 f9                	mov    %edi,%ecx
801022bb:	83 c9 02             	or     $0x2,%ecx
801022be:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801022c0:	53                   	push   %ebx
801022c1:	e8 fa 24 00 00       	call   801047c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022c6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022cb:	83 c4 10             	add    $0x10,%esp
801022ce:	85 c0                	test   %eax,%eax
801022d0:	74 05                	je     801022d7 <ideintr+0x87>
    idestart(idequeue);
801022d2:	e8 29 fe ff ff       	call   80102100 <idestart>
    release(&idelock);
801022d7:	83 ec 0c             	sub    $0xc,%esp
801022da:	68 80 b5 10 80       	push   $0x8010b580
801022df:	e8 dc 29 00 00       	call   80104cc0 <release>

  release(&idelock);
}
801022e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022e7:	5b                   	pop    %ebx
801022e8:	5e                   	pop    %esi
801022e9:	5f                   	pop    %edi
801022ea:	5d                   	pop    %ebp
801022eb:	c3                   	ret    
801022ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	53                   	push   %ebx
801022f4:	83 ec 10             	sub    $0x10,%esp
801022f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801022fd:	50                   	push   %eax
801022fe:	e8 6d 27 00 00       	call   80104a70 <holdingsleep>
80102303:	83 c4 10             	add    $0x10,%esp
80102306:	85 c0                	test   %eax,%eax
80102308:	0f 84 c6 00 00 00    	je     801023d4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	0f 84 ab 00 00 00    	je     801023c7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010231c:	8b 53 04             	mov    0x4(%ebx),%edx
8010231f:	85 d2                	test   %edx,%edx
80102321:	74 0d                	je     80102330 <iderw+0x40>
80102323:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102328:	85 c0                	test   %eax,%eax
8010232a:	0f 84 b1 00 00 00    	je     801023e1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 80 b5 10 80       	push   $0x8010b580
80102338:	e8 c3 28 00 00       	call   80104c00 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102343:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102346:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010234d:	85 d2                	test   %edx,%edx
8010234f:	75 09                	jne    8010235a <iderw+0x6a>
80102351:	eb 6d                	jmp    801023c0 <iderw+0xd0>
80102353:	90                   	nop
80102354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102358:	89 c2                	mov    %eax,%edx
8010235a:	8b 42 58             	mov    0x58(%edx),%eax
8010235d:	85 c0                	test   %eax,%eax
8010235f:	75 f7                	jne    80102358 <iderw+0x68>
80102361:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102364:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102366:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010236c:	74 42                	je     801023b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 e0 06             	and    $0x6,%eax
80102373:	83 f8 02             	cmp    $0x2,%eax
80102376:	74 23                	je     8010239b <iderw+0xab>
80102378:	90                   	nop
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102380:	83 ec 08             	sub    $0x8,%esp
80102383:	68 80 b5 10 80       	push   $0x8010b580
80102388:	53                   	push   %ebx
80102389:	e8 82 22 00 00       	call   80104610 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010238e:	8b 03                	mov    (%ebx),%eax
80102390:	83 c4 10             	add    $0x10,%esp
80102393:	83 e0 06             	and    $0x6,%eax
80102396:	83 f8 02             	cmp    $0x2,%eax
80102399:	75 e5                	jne    80102380 <iderw+0x90>
  }


  release(&idelock);
8010239b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
801023a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023a5:	c9                   	leave  
  release(&idelock);
801023a6:	e9 15 29 00 00       	jmp    80104cc0 <release>
801023ab:	90                   	nop
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801023b0:	89 d8                	mov    %ebx,%eax
801023b2:	e8 49 fd ff ff       	call   80102100 <idestart>
801023b7:	eb b5                	jmp    8010236e <iderw+0x7e>
801023b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023c0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801023c5:	eb 9d                	jmp    80102364 <iderw+0x74>
    panic("iderw: nothing to do");
801023c7:	83 ec 0c             	sub    $0xc,%esp
801023ca:	68 fc 7b 10 80       	push   $0x80107bfc
801023cf:	e8 bc df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023d4:	83 ec 0c             	sub    $0xc,%esp
801023d7:	68 e6 7b 10 80       	push   $0x80107be6
801023dc:	e8 af df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801023e1:	83 ec 0c             	sub    $0xc,%esp
801023e4:	68 11 7c 10 80       	push   $0x80107c11
801023e9:	e8 a2 df ff ff       	call   80100390 <panic>
801023ee:	66 90                	xchg   %ax,%ax

801023f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023f1:	c7 05 54 36 11 80 00 	movl   $0xfec00000,0x80113654
801023f8:	00 c0 fe 
{
801023fb:	89 e5                	mov    %esp,%ebp
801023fd:	56                   	push   %esi
801023fe:	53                   	push   %ebx
  ioapic->reg = reg;
801023ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102406:	00 00 00 
  return ioapic->data;
80102409:	a1 54 36 11 80       	mov    0x80113654,%eax
8010240e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102411:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102417:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010241d:	0f b6 15 20 b8 22 80 	movzbl 0x8022b820,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102424:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102427:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010242a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010242d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102430:	39 c2                	cmp    %eax,%edx
80102432:	74 16                	je     8010244a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102434:	83 ec 0c             	sub    $0xc,%esp
80102437:	68 30 7c 10 80       	push   $0x80107c30
8010243c:	e8 1f e2 ff ff       	call   80100660 <cprintf>
80102441:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102447:	83 c4 10             	add    $0x10,%esp
8010244a:	83 c3 21             	add    $0x21,%ebx
{
8010244d:	ba 10 00 00 00       	mov    $0x10,%edx
80102452:	b8 20 00 00 00       	mov    $0x20,%eax
80102457:	89 f6                	mov    %esi,%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102460:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102462:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102468:	89 c6                	mov    %eax,%esi
8010246a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102470:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102473:	89 71 10             	mov    %esi,0x10(%ecx)
80102476:	8d 72 01             	lea    0x1(%edx),%esi
80102479:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010247c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010247e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102480:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
80102486:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010248d:	75 d1                	jne    80102460 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010248f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102492:	5b                   	pop    %ebx
80102493:	5e                   	pop    %esi
80102494:	5d                   	pop    %ebp
80102495:	c3                   	ret    
80102496:	8d 76 00             	lea    0x0(%esi),%esi
80102499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801024a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024a0:	55                   	push   %ebp
  ioapic->reg = reg;
801024a1:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
{
801024a7:	89 e5                	mov    %esp,%ebp
801024a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ac:	8d 50 20             	lea    0x20(%eax),%edx
801024af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024b5:	8b 0d 54 36 11 80    	mov    0x80113654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024c6:	a1 54 36 11 80       	mov    0x80113654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801024d1:	5d                   	pop    %ebp
801024d2:	c3                   	ret    
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	53                   	push   %ebx
801024e4:	83 ec 04             	sub    $0x4,%esp
801024e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;
  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024f0:	0f 85 7c 00 00 00    	jne    80102572 <kfree+0x92>
801024f6:	81 fb 68 e5 22 80    	cmp    $0x8022e568,%ebx
801024fc:	72 74                	jb     80102572 <kfree+0x92>
801024fe:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102504:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102509:	77 67                	ja     80102572 <kfree+0x92>
      panic("kfree");
      // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010250b:	83 ec 04             	sub    $0x4,%esp
8010250e:	68 00 10 00 00       	push   $0x1000
80102513:	6a 01                	push   $0x1
80102515:	53                   	push   %ebx
80102516:	e8 05 28 00 00       	call   80104d20 <memset>

  if(kmem.use_lock)
8010251b:	8b 15 94 36 11 80    	mov    0x80113694,%edx
80102521:	83 c4 10             	add    $0x10,%esp
80102524:	85 d2                	test   %edx,%edx
80102526:	75 38                	jne    80102560 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102528:	a1 98 36 11 80       	mov    0x80113698,%eax
8010252d:	89 03                	mov    %eax,(%ebx)
  num_free_pages++;
  kmem.freelist = r;
  if(kmem.use_lock)
8010252f:	a1 94 36 11 80       	mov    0x80113694,%eax
  num_free_pages++;
80102534:	83 05 1c b7 14 80 01 	addl   $0x1,0x8014b71c
  kmem.freelist = r;
8010253b:	89 1d 98 36 11 80    	mov    %ebx,0x80113698
  if(kmem.use_lock)
80102541:	85 c0                	test   %eax,%eax
80102543:	75 0b                	jne    80102550 <kfree+0x70>
    release(&kmem.lock);
}
80102545:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102548:	c9                   	leave  
80102549:	c3                   	ret    
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102550:	c7 45 08 60 36 11 80 	movl   $0x80113660,0x8(%ebp)
}
80102557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010255a:	c9                   	leave  
    release(&kmem.lock);
8010255b:	e9 60 27 00 00       	jmp    80104cc0 <release>
    acquire(&kmem.lock);
80102560:	83 ec 0c             	sub    $0xc,%esp
80102563:	68 60 36 11 80       	push   $0x80113660
80102568:	e8 93 26 00 00       	call   80104c00 <acquire>
8010256d:	83 c4 10             	add    $0x10,%esp
80102570:	eb b6                	jmp    80102528 <kfree+0x48>
      panic("kfree");
80102572:	83 ec 0c             	sub    $0xc,%esp
80102575:	68 62 7c 10 80       	push   $0x80107c62
8010257a:	e8 11 de ff ff       	call   80100390 <panic>
8010257f:	90                   	nop

80102580 <freerange>:
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	56                   	push   %esi
80102584:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102585:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102588:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010258b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102591:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102597:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010259d:	39 de                	cmp    %ebx,%esi
8010259f:	72 23                	jb     801025c4 <freerange+0x44>
801025a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025ae:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 23 ff ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 f3                	cmp    %esi,%ebx
801025c2:	76 e4                	jbe    801025a8 <freerange+0x28>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	90                   	nop
801025cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025d0 <kinit1>:
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	56                   	push   %esi
801025d4:	53                   	push   %ebx
801025d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025d8:	83 ec 08             	sub    $0x8,%esp
801025db:	68 68 7c 10 80       	push   $0x80107c68
801025e0:	68 60 36 11 80       	push   $0x80113660
801025e5:	e8 d6 24 00 00       	call   80104ac0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025f0:	c7 05 94 36 11 80 00 	movl   $0x0,0x80113694
801025f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102600:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102606:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010260c:	39 de                	cmp    %ebx,%esi
8010260e:	72 1c                	jb     8010262c <kinit1+0x5c>
    kfree(p);
80102610:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102616:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102619:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010261f:	50                   	push   %eax
80102620:	e8 bb fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102625:	83 c4 10             	add    $0x10,%esp
80102628:	39 de                	cmp    %ebx,%esi
8010262a:	73 e4                	jae    80102610 <kinit1+0x40>
}
8010262c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010262f:	5b                   	pop    %ebx
80102630:	5e                   	pop    %esi
80102631:	5d                   	pop    %ebp
80102632:	c3                   	ret    
80102633:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102640 <kinit2>:
{
80102640:	55                   	push   %ebp
80102641:	89 e5                	mov    %esp,%ebp
80102643:	56                   	push   %esi
80102644:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102645:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102648:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010264b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102651:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102657:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010265d:	39 de                	cmp    %ebx,%esi
8010265f:	72 23                	jb     80102684 <kinit2+0x44>
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102668:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010266e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102671:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102677:	50                   	push   %eax
80102678:	e8 63 fe ff ff       	call   801024e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
80102680:	39 de                	cmp    %ebx,%esi
80102682:	73 e4                	jae    80102668 <kinit2+0x28>
  kmem.use_lock = 1;
80102684:	c7 05 94 36 11 80 01 	movl   $0x1,0x80113694
8010268b:	00 00 00 
}
8010268e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102691:	5b                   	pop    %ebx
80102692:	5e                   	pop    %esi
80102693:	5d                   	pop    %ebp
80102694:	c3                   	ret    
80102695:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <swap_out>:
    }
    //release(&pagelock);
    return 0;
}
void swap_out(struct page* n)
{  
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	57                   	push   %edi
801026a4:	56                   	push   %esi
801026a5:	53                   	push   %ebx
    acquire(&pagelock);
    pte_t* pte = walkpgdir(n->pgdir,(void*)n->vaddr,0);
    int offset=0;
    for(int i=1;i<PHYSTOP/PGSIZE;i++)
801026a6:	bb 01 00 00 00       	mov    $0x1,%ebx
{  
801026ab:	83 ec 28             	sub    $0x28,%esp
801026ae:	8b 75 08             	mov    0x8(%ebp),%esi
    acquire(&pagelock);
801026b1:	68 a0 36 11 80       	push   $0x801136a0
801026b6:	e8 45 25 00 00       	call   80104c00 <acquire>
    pte_t* pte = walkpgdir(n->pgdir,(void*)n->vaddr,0);
801026bb:	83 c4 0c             	add    $0xc,%esp
801026be:	6a 00                	push   $0x0
801026c0:	ff 76 0c             	pushl  0xc(%esi)
801026c3:	ff 76 08             	pushl  0x8(%esi)
801026c6:	e8 55 49 00 00       	call   80107020 <walkpgdir>
801026cb:	83 c4 10             	add    $0x10,%esp
801026ce:	eb 0f                	jmp    801026df <swap_out+0x3f>
    for(int i=1;i<PHYSTOP/PGSIZE;i++)
801026d0:	83 c3 01             	add    $0x1,%ebx
801026d3:	81 fb 00 e0 00 00    	cmp    $0xe000,%ebx
801026d9:	0f 84 a9 00 00 00    	je     80102788 <swap_out+0xe8>
    {
        if(valid[i]==0)
801026df:	8b 0c 9d e0 36 11 80 	mov    -0x7feec920(,%ebx,4),%ecx
801026e6:	85 c9                	test   %ecx,%ecx
801026e8:	75 e6                	jne    801026d0 <swap_out+0x30>
801026ea:	89 da                	mov    %ebx,%edx
801026ec:	c1 e2 0c             	shl    $0xc,%edx
801026ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            offset=i;
            break;
        }
    }
 
    uint origin_addr = PTE_ADDR(*pte);
801026f2:	8b 38                	mov    (%eax),%edi
    int flags = *pte%4096-1;
    valid[offset]=1;
801026f4:	c7 04 9d e0 36 11 80 	movl   $0x1,-0x7feec920(,%ebx,4)
801026fb:	01 00 00 00 
    n->next=0;
    n->pgdir=0;
    n->vaddr=0;
    num_lru_pages--;
    *pte = (offset*4096)|PTE_SWAP|flags;
    release(&pagelock);
801026ff:	83 ec 0c             	sub    $0xc,%esp
    page_lru_head=n->next;
80102702:	8b 0e                	mov    (%esi),%ecx
80102704:	89 0d 18 b7 14 80    	mov    %ecx,0x8014b718
    n->prev->next=n->next;
8010270a:	8b 4e 04             	mov    0x4(%esi),%ecx
8010270d:	8b 16                	mov    (%esi),%edx
8010270f:	89 11                	mov    %edx,(%ecx)
    n->next->prev=n->prev;
80102711:	8b 0e                	mov    (%esi),%ecx
80102713:	8b 56 04             	mov    0x4(%esi),%edx
80102716:	89 51 04             	mov    %edx,0x4(%ecx)
    int flags = *pte%4096-1;
80102719:	89 f9                	mov    %edi,%ecx
    *pte = (offset*4096)|PTE_SWAP|flags;
8010271b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    int flags = *pte%4096-1;
8010271e:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
    n->next=0;
80102724:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
    n->prev=0;
8010272a:	c7 46 04 00 00 00 00 	movl   $0x0,0x4(%esi)
    int flags = *pte%4096-1;
80102731:	83 e9 01             	sub    $0x1,%ecx
    n->pgdir=0;
80102734:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
    n->vaddr=0;
8010273b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    *pte = (offset*4096)|PTE_SWAP|flags;
80102742:	80 cd 01             	or     $0x1,%ch
    num_lru_pages--;
80102745:	83 2d 14 b7 14 80 01 	subl   $0x1,0x8014b714
    uint origin_addr = PTE_ADDR(*pte);
8010274c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    *pte = (offset*4096)|PTE_SWAP|flags;
80102752:	09 ca                	or     %ecx,%edx
    swapwrite((char*)P2V(origin_addr),offset);
80102754:	81 c7 00 00 00 80    	add    $0x80000000,%edi
    *pte = (offset*4096)|PTE_SWAP|flags;
8010275a:	89 10                	mov    %edx,(%eax)
    release(&pagelock);
8010275c:	68 a0 36 11 80       	push   $0x801136a0
80102761:	e8 5a 25 00 00       	call   80104cc0 <release>
    swapwrite((char*)P2V(origin_addr),offset);
80102766:	58                   	pop    %eax
80102767:	5a                   	pop    %edx
80102768:	53                   	push   %ebx
80102769:	57                   	push   %edi
8010276a:	e8 51 f8 ff ff       	call   80101fc0 <swapwrite>
    kfree((char*)P2V(origin_addr));
8010276f:	89 7d 08             	mov    %edi,0x8(%ebp)
80102772:	83 c4 10             	add    $0x10,%esp
    return;
}
80102775:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102778:	5b                   	pop    %ebx
80102779:	5e                   	pop    %esi
8010277a:	5f                   	pop    %edi
8010277b:	5d                   	pop    %ebp
    kfree((char*)P2V(origin_addr));
8010277c:	e9 5f fd ff ff       	jmp    801024e0 <kfree>
80102781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102788:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    int offset=0;
8010278f:	31 db                	xor    %ebx,%ebx
80102791:	e9 5c ff ff ff       	jmp    801026f2 <swap_out+0x52>
80102796:	8d 76 00             	lea    0x0(%esi),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <reclaim.part.0>:
int reclaim()
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	56                   	push   %esi
801027a4:	53                   	push   %ebx
    struct page* n = page_lru_head;
801027a5:	8b 1d 18 b7 14 80    	mov    0x8014b718,%ebx
801027ab:	eb 0d                	jmp    801027ba <reclaim.part.0+0x1a>
801027ad:	8d 76 00             	lea    0x0(%esi),%esi
        if(n->next==page_lru_head) break;
801027b0:	8b 1b                	mov    (%ebx),%ebx
801027b2:	3b 1d 18 b7 14 80    	cmp    0x8014b718,%ebx
801027b8:	74 36                	je     801027f0 <reclaim.part.0+0x50>
        pte_t* pte = walkpgdir(n->pgdir,(void*)n->vaddr,0);
801027ba:	83 ec 04             	sub    $0x4,%esp
801027bd:	6a 00                	push   $0x0
801027bf:	ff 73 0c             	pushl  0xc(%ebx)
801027c2:	ff 73 08             	pushl  0x8(%ebx)
801027c5:	e8 56 48 00 00       	call   80107020 <walkpgdir>
        if(((*pte&PTE_U)!=0)&&((*pte&PTE_A)==0)) 
801027ca:	8b 00                	mov    (%eax),%eax
801027cc:	83 c4 10             	add    $0x10,%esp
801027cf:	83 e0 24             	and    $0x24,%eax
801027d2:	83 f8 04             	cmp    $0x4,%eax
801027d5:	75 d9                	jne    801027b0 <reclaim.part.0+0x10>
        swap_out(n);
801027d7:	83 ec 0c             	sub    $0xc,%esp
801027da:	53                   	push   %ebx
801027db:	e8 c0 fe ff ff       	call   801026a0 <swap_out>
801027e0:	83 c4 10             	add    $0x10,%esp
}
801027e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 1;
801027e6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801027eb:	5b                   	pop    %ebx
801027ec:	5e                   	pop    %esi
801027ed:	5d                   	pop    %ebp
801027ee:	c3                   	ret    
801027ef:	90                   	nop
    for(int i=0;i<num_lru_pages;i++)
801027f0:	a1 14 b7 14 80       	mov    0x8014b714,%eax
801027f5:	85 c0                	test   %eax,%eax
801027f7:	7e 37                	jle    80102830 <reclaim.part.0+0x90>
801027f9:	31 f6                	xor    %esi,%esi
801027fb:	eb 10                	jmp    8010280d <reclaim.part.0+0x6d>
801027fd:	8d 76 00             	lea    0x0(%esi),%esi
80102800:	83 c6 01             	add    $0x1,%esi
80102803:	3b 35 14 b7 14 80    	cmp    0x8014b714,%esi
        n=n->next;
80102809:	8b 1b                	mov    (%ebx),%ebx
    for(int i=0;i<num_lru_pages;i++)
8010280b:	7d 23                	jge    80102830 <reclaim.part.0+0x90>
        pte_t* pte = walkpgdir(n->pgdir,(void*)n->vaddr,0);
8010280d:	83 ec 04             	sub    $0x4,%esp
80102810:	6a 00                	push   $0x0
80102812:	ff 73 0c             	pushl  0xc(%ebx)
80102815:	ff 73 08             	pushl  0x8(%ebx)
80102818:	e8 03 48 00 00       	call   80107020 <walkpgdir>
        if((*pte&PTE_U)!=0) {
8010281d:	83 c4 10             	add    $0x10,%esp
80102820:	f6 00 04             	testb  $0x4,(%eax)
80102823:	74 db                	je     80102800 <reclaim.part.0+0x60>
80102825:	eb b0                	jmp    801027d7 <reclaim.part.0+0x37>
80102827:	89 f6                	mov    %esi,%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80102830:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80102833:	31 c0                	xor    %eax,%eax
}
80102835:	5b                   	pop    %ebx
80102836:	5e                   	pop    %esi
80102837:	5d                   	pop    %ebp
80102838:	c3                   	ret    
80102839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102840 <reclaim>:
    if(num_lru_pages<=0) {
80102840:	a1 14 b7 14 80       	mov    0x8014b714,%eax
{
80102845:	55                   	push   %ebp
80102846:	89 e5                	mov    %esp,%ebp
    if(num_lru_pages<=0) {
80102848:	85 c0                	test   %eax,%eax
8010284a:	7e 0c                	jle    80102858 <reclaim+0x18>
}
8010284c:	5d                   	pop    %ebp
8010284d:	e9 4e ff ff ff       	jmp    801027a0 <reclaim.part.0>
80102852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102858:	31 c0                	xor    %eax,%eax
8010285a:	5d                   	pop    %ebp
8010285b:	c3                   	ret    
8010285c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102860 <kalloc>:
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	83 ec 18             	sub    $0x18,%esp
80102866:	eb 24                	jmp    8010288c <kalloc+0x2c>
80102868:	90                   	nop
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  r = kmem.freelist;
80102870:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(!r)
80102875:	85 c0                	test   %eax,%eax
80102877:	75 77                	jne    801028f0 <kalloc+0x90>
    if(num_lru_pages<=0) {
80102879:	8b 0d 14 b7 14 80    	mov    0x8014b714,%ecx
8010287f:	85 c9                	test   %ecx,%ecx
80102881:	7e 55                	jle    801028d8 <kalloc+0x78>
80102883:	e8 18 ff ff ff       	call   801027a0 <reclaim.part.0>
      if(!reclaim()) 
80102888:	85 c0                	test   %eax,%eax
8010288a:	74 4c                	je     801028d8 <kalloc+0x78>
  if(kmem.use_lock)
8010288c:	a1 94 36 11 80       	mov    0x80113694,%eax
80102891:	85 c0                	test   %eax,%eax
80102893:	74 db                	je     80102870 <kalloc+0x10>
    acquire(&kmem.lock);
80102895:	83 ec 0c             	sub    $0xc,%esp
80102898:	68 60 36 11 80       	push   $0x80113660
8010289d:	e8 5e 23 00 00       	call   80104c00 <acquire>
  r = kmem.freelist;
801028a2:	a1 98 36 11 80       	mov    0x80113698,%eax
  if(!r)
801028a7:	83 c4 10             	add    $0x10,%esp
801028aa:	85 c0                	test   %eax,%eax
801028ac:	75 5a                	jne    80102908 <kalloc+0xa8>
      if(kmem.use_lock) release(&kmem.lock);
801028ae:	a1 94 36 11 80       	mov    0x80113694,%eax
801028b3:	85 c0                	test   %eax,%eax
801028b5:	74 c2                	je     80102879 <kalloc+0x19>
801028b7:	83 ec 0c             	sub    $0xc,%esp
801028ba:	68 60 36 11 80       	push   $0x80113660
801028bf:	e8 fc 23 00 00       	call   80104cc0 <release>
    if(num_lru_pages<=0) {
801028c4:	8b 0d 14 b7 14 80    	mov    0x8014b714,%ecx
      if(kmem.use_lock) release(&kmem.lock);
801028ca:	83 c4 10             	add    $0x10,%esp
    if(num_lru_pages<=0) {
801028cd:	85 c9                	test   %ecx,%ecx
801028cf:	7f b2                	jg     80102883 <kalloc+0x23>
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          cprintf("fault reclaim() : Out Of Memory\n");
801028d8:	83 ec 0c             	sub    $0xc,%esp
801028db:	68 b4 7c 10 80       	push   $0x80107cb4
801028e0:	e8 7b dd ff ff       	call   80100660 <cprintf>
          return 0;
801028e5:	83 c4 10             	add    $0x10,%esp
801028e8:	31 c0                	xor    %eax,%eax
}
801028ea:	c9                   	leave  
801028eb:	c3                   	ret    
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kmem.freelist = r->next;
801028f0:	8b 10                	mov    (%eax),%edx
      num_free_pages--;
801028f2:	83 2d 1c b7 14 80 01 	subl   $0x1,0x8014b71c
      kmem.freelist = r->next;
801028f9:	89 15 98 36 11 80    	mov    %edx,0x80113698
}
801028ff:	c9                   	leave  
80102900:	c3                   	ret    
80102901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kmem.freelist = r->next;
80102908:	8b 10                	mov    (%eax),%edx
      num_free_pages--;
8010290a:	83 2d 1c b7 14 80 01 	subl   $0x1,0x8014b71c
      kmem.freelist = r->next;
80102911:	89 15 98 36 11 80    	mov    %edx,0x80113698
  if(kmem.use_lock)
80102917:	8b 15 94 36 11 80    	mov    0x80113694,%edx
8010291d:	85 d2                	test   %edx,%edx
8010291f:	74 c9                	je     801028ea <kalloc+0x8a>
    release(&kmem.lock);
80102921:	83 ec 0c             	sub    $0xc,%esp
80102924:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102927:	68 60 36 11 80       	push   $0x80113660
8010292c:	e8 8f 23 00 00       	call   80104cc0 <release>
80102931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102934:	83 c4 10             	add    $0x10,%esp
}
80102937:	c9                   	leave  
80102938:	c3                   	ret    
80102939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102940 <find_page>:
struct page* find_page()
{
80102940:	55                   	push   %ebp
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
80102941:	31 d2                	xor    %edx,%edx
{
80102943:	89 e5                	mov    %esp,%ebp
80102945:	eb 14                	jmp    8010295b <find_page+0x1b>
80102947:	89 f6                	mov    %esi,%esi
80102949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
80102950:	83 c2 01             	add    $0x1,%edx
80102953:	81 fa 00 e0 00 00    	cmp    $0xe000,%edx
80102959:	74 1d                	je     80102978 <find_page+0x38>
8010295b:	89 d0                	mov    %edx,%eax
8010295d:	c1 e0 04             	shl    $0x4,%eax
        if(pages[i].pgdir==0) return &pages[i];
80102960:	8b 88 28 b7 14 80    	mov    -0x7feb48d8(%eax),%ecx
80102966:	85 c9                	test   %ecx,%ecx
80102968:	75 e6                	jne    80102950 <find_page+0x10>
8010296a:	05 20 b7 14 80       	add    $0x8014b720,%eax
    return 0;
}
8010296f:	5d                   	pop    %ebp
80102970:	c3                   	ret    
80102971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102978:	31 c0                	xor    %eax,%eax
}
8010297a:	5d                   	pop    %ebp
8010297b:	c3                   	ret    
8010297c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102980 <add_pglist>:
void add_pglist(char* va, pde_t *pgdir)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
80102983:	56                   	push   %esi
80102984:	53                   	push   %ebx
80102985:	8b 75 08             	mov    0x8(%ebp),%esi
80102988:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    acquire(&lrulock);
8010298b:	83 ec 0c             	sub    $0xc,%esp
8010298e:	68 e0 b6 14 80       	push   $0x8014b6e0
80102993:	e8 68 22 00 00       	call   80104c00 <acquire>
80102998:	83 c4 10             	add    $0x10,%esp
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
8010299b:	31 c0                	xor    %eax,%eax
8010299d:	eb 0f                	jmp    801029ae <add_pglist+0x2e>
8010299f:	90                   	nop
801029a0:	83 c0 01             	add    $0x1,%eax
801029a3:	3d 00 e0 00 00       	cmp    $0xe000,%eax
801029a8:	0f 84 92 00 00 00    	je     80102a40 <add_pglist+0xc0>
801029ae:	89 c2                	mov    %eax,%edx
801029b0:	c1 e2 04             	shl    $0x4,%edx
        if(pages[i].pgdir==0) return &pages[i];
801029b3:	8b 8a 28 b7 14 80    	mov    -0x7feb48d8(%edx),%ecx
801029b9:	85 c9                	test   %ecx,%ecx
801029bb:	75 e3                	jne    801029a0 <add_pglist+0x20>
    struct page* n = find_page();
    if(n==0) panic("Full pages array");
    num_lru_pages++;
801029bd:	8b 0d 14 b7 14 80    	mov    0x8014b714,%ecx
        if(pages[i].pgdir==0) return &pages[i];
801029c3:	8d 82 20 b7 14 80    	lea    -0x7feb48e0(%edx),%eax
    
    n->vaddr=va;
801029c9:	89 70 0c             	mov    %esi,0xc(%eax)
    n->pgdir=pgdir;
801029cc:	89 58 08             	mov    %ebx,0x8(%eax)
    num_lru_pages++;
801029cf:	83 c1 01             	add    $0x1,%ecx
    
    if(num_lru_pages==1) 
801029d2:	83 f9 01             	cmp    $0x1,%ecx
    num_lru_pages++;
801029d5:	89 0d 14 b7 14 80    	mov    %ecx,0x8014b714
    if(num_lru_pages==1) 
801029db:	74 53                	je     80102a30 <add_pglist+0xb0>
    {
        page_lru_head=n;
        page_lru_head->prev=page_lru_head;
        page_lru_head->next=page_lru_head;
    }
    else if(num_lru_pages==2)
801029dd:	83 f9 02             	cmp    $0x2,%ecx
801029e0:	8b 1d 18 b7 14 80    	mov    0x8014b718,%ebx
801029e6:	74 30                	je     80102a18 <add_pglist+0x98>
        page_lru_head->next=n;
        page_lru_head->prev=n;
    }
    else
    {
        n->prev = page_lru_head->prev;
801029e8:	8b 4b 04             	mov    0x4(%ebx),%ecx
        n->next = page_lru_head;
801029eb:	89 9a 20 b7 14 80    	mov    %ebx,-0x7feb48e0(%edx)
        n->prev = page_lru_head->prev;
801029f1:	89 48 04             	mov    %ecx,0x4(%eax)
        page_lru_head->prev->next=n;
801029f4:	8b 53 04             	mov    0x4(%ebx),%edx
801029f7:	89 02                	mov    %eax,(%edx)
        page_lru_head->prev = n;
801029f9:	8b 15 18 b7 14 80    	mov    0x8014b718,%edx
801029ff:	89 42 04             	mov    %eax,0x4(%edx)
    }
    release(&lrulock);
80102a02:	c7 45 08 e0 b6 14 80 	movl   $0x8014b6e0,0x8(%ebp)
}
80102a09:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102a0c:	5b                   	pop    %ebx
80102a0d:	5e                   	pop    %esi
80102a0e:	5d                   	pop    %ebp
    release(&lrulock);
80102a0f:	e9 ac 22 00 00       	jmp    80104cc0 <release>
80102a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n->next=page_lru_head;
80102a18:	89 9a 20 b7 14 80    	mov    %ebx,-0x7feb48e0(%edx)
        n->prev=page_lru_head;
80102a1e:	89 58 04             	mov    %ebx,0x4(%eax)
        page_lru_head->next=n;
80102a21:	89 03                	mov    %eax,(%ebx)
        page_lru_head->prev=n;
80102a23:	8b 15 18 b7 14 80    	mov    0x8014b718,%edx
80102a29:	89 42 04             	mov    %eax,0x4(%edx)
80102a2c:	eb d4                	jmp    80102a02 <add_pglist+0x82>
80102a2e:	66 90                	xchg   %ax,%ax
        page_lru_head=n;
80102a30:	a3 18 b7 14 80       	mov    %eax,0x8014b718
        page_lru_head->prev=page_lru_head;
80102a35:	89 40 04             	mov    %eax,0x4(%eax)
        page_lru_head->next=page_lru_head;
80102a38:	89 82 20 b7 14 80    	mov    %eax,-0x7feb48e0(%edx)
80102a3e:	eb c2                	jmp    80102a02 <add_pglist+0x82>
    if(n==0) panic("Full pages array");
80102a40:	83 ec 0c             	sub    $0xc,%esp
80102a43:	68 6d 7c 10 80       	push   $0x80107c6d
80102a48:	e8 43 d9 ff ff       	call   80100390 <panic>
80102a4d:	8d 76 00             	lea    0x0(%esi),%esi

80102a50 <print_lru_list>:
void print_lru_list(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	56                   	push   %esi
80102a54:	53                   	push   %ebx
    cprintf("------------lru page list----num_lru_pages=%d, num_free_pages=%d--\n",num_lru_pages,num_free_pages);
    int i=0;
80102a55:	31 f6                	xor    %esi,%esi
    cprintf("------------lru page list----num_lru_pages=%d, num_free_pages=%d--\n",num_lru_pages,num_free_pages);
80102a57:	83 ec 04             	sub    $0x4,%esp
80102a5a:	ff 35 1c b7 14 80    	pushl  0x8014b71c
80102a60:	ff 35 14 b7 14 80    	pushl  0x8014b714
80102a66:	68 d8 7c 10 80       	push   $0x80107cd8
80102a6b:	e8 f0 db ff ff       	call   80100660 <cprintf>
    struct page* n = page_lru_head;
80102a70:	8b 1d 18 b7 14 80    	mov    0x8014b718,%ebx
80102a76:	83 c4 10             	add    $0x10,%esp
80102a79:	eb 08                	jmp    80102a83 <print_lru_list+0x33>
80102a7b:	90                   	nop
80102a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(1)
    {
        cprintf("%dth *pte = %x\n",i,*walkpgdir(n->pgdir,(void*)n->vaddr,0));
        if(n->next==page_lru_head) break;
        i++;
80102a80:	83 c6 01             	add    $0x1,%esi
        cprintf("%dth *pte = %x\n",i,*walkpgdir(n->pgdir,(void*)n->vaddr,0));
80102a83:	83 ec 04             	sub    $0x4,%esp
80102a86:	6a 00                	push   $0x0
80102a88:	ff 73 0c             	pushl  0xc(%ebx)
80102a8b:	ff 73 08             	pushl  0x8(%ebx)
80102a8e:	e8 8d 45 00 00       	call   80107020 <walkpgdir>
80102a93:	83 c4 0c             	add    $0xc,%esp
80102a96:	ff 30                	pushl  (%eax)
80102a98:	56                   	push   %esi
80102a99:	68 7e 7c 10 80       	push   $0x80107c7e
80102a9e:	e8 bd db ff ff       	call   80100660 <cprintf>
        if(n->next==page_lru_head) break;
80102aa3:	8b 1b                	mov    (%ebx),%ebx
80102aa5:	83 c4 10             	add    $0x10,%esp
80102aa8:	3b 1d 18 b7 14 80    	cmp    0x8014b718,%ebx
80102aae:	75 d0                	jne    80102a80 <print_lru_list+0x30>
        n=n->next;
    }

}
80102ab0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ab3:	5b                   	pop    %ebx
80102ab4:	5e                   	pop    %esi
80102ab5:	5d                   	pop    %ebp
80102ab6:	c3                   	ret    
80102ab7:	89 f6                	mov    %esi,%esi
80102ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ac0 <delete_pages>:
int delete_pages(char* va, pde_t* pgdir)
{
80102ac0:	55                   	push   %ebp
80102ac1:	89 e5                	mov    %esp,%ebp
80102ac3:	56                   	push   %esi
80102ac4:	53                   	push   %ebx
80102ac5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ac8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    acquire(&lrulock);
80102acb:	83 ec 0c             	sub    $0xc,%esp
80102ace:	68 e0 b6 14 80       	push   $0x8014b6e0
80102ad3:	e8 28 21 00 00       	call   80104c00 <acquire>
    pte_t* pte= walkpgdir(pgdir,va,0);
80102ad8:	83 c4 0c             	add    $0xc,%esp
80102adb:	6a 00                	push   $0x0
80102add:	56                   	push   %esi
80102ade:	53                   	push   %ebx
80102adf:	e8 3c 45 00 00       	call   80107020 <walkpgdir>
    if(num_lru_pages==0) {
80102ae4:	8b 15 14 b7 14 80    	mov    0x8014b714,%edx
80102aea:	83 c4 10             	add    $0x10,%esp
80102aed:	85 d2                	test   %edx,%edx
80102aef:	0f 84 8b 00 00 00    	je     80102b80 <delete_pages+0xc0>
        release(&lrulock);
        return 0;
    }
    int index=*pte/4096;
80102af5:	8b 08                	mov    (%eax),%ecx
        release(&lrulock);
        return 2;
    }
    else
    {
        struct page* n = page_lru_head;
80102af7:	8b 15 18 b7 14 80    	mov    0x8014b718,%edx
    if((*pte)&PTE_SWAP)
80102afd:	f6 c5 01             	test   $0x1,%ch
        struct page* n = page_lru_head;
80102b00:	89 d0                	mov    %edx,%eax
    if((*pte)&PTE_SWAP)
80102b02:	74 12                	je     80102b16 <delete_pages+0x56>
80102b04:	e9 97 00 00 00       	jmp    80102ba0 <delete_pages+0xe0>
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                n->vaddr=0;
                num_lru_pages--;
                release(&lrulock);
                return 1;
            }
            n=n->next;
80102b10:	8b 00                	mov    (%eax),%eax
            if(n==page_lru_head) break;
80102b12:	39 c2                	cmp    %eax,%edx
80102b14:	74 6a                	je     80102b80 <delete_pages+0xc0>
            if(n->pgdir == pgdir && n->vaddr == va)
80102b16:	39 58 08             	cmp    %ebx,0x8(%eax)
80102b19:	75 f5                	jne    80102b10 <delete_pages+0x50>
80102b1b:	39 70 0c             	cmp    %esi,0xc(%eax)
80102b1e:	75 f0                	jne    80102b10 <delete_pages+0x50>
                if(n==page_lru_head) page_lru_head=n->next;
80102b20:	39 d0                	cmp    %edx,%eax
80102b22:	8b 08                	mov    (%eax),%ecx
80102b24:	75 08                	jne    80102b2e <delete_pages+0x6e>
80102b26:	89 0d 18 b7 14 80    	mov    %ecx,0x8014b718
80102b2c:	8b 08                	mov    (%eax),%ecx
                n->prev->next=n->next;
80102b2e:	8b 50 04             	mov    0x4(%eax),%edx
                release(&lrulock);
80102b31:	83 ec 0c             	sub    $0xc,%esp
                n->prev->next=n->next;
80102b34:	89 0a                	mov    %ecx,(%edx)
                n->next->prev=n->prev;
80102b36:	8b 10                	mov    (%eax),%edx
80102b38:	8b 48 04             	mov    0x4(%eax),%ecx
80102b3b:	89 4a 04             	mov    %ecx,0x4(%edx)
                n->next=0;
80102b3e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
                n->prev=0;
80102b44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
                n->pgdir=0;
80102b4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                n->vaddr=0;
80102b52:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                release(&lrulock);
80102b59:	68 e0 b6 14 80       	push   $0x8014b6e0
                num_lru_pages--;
80102b5e:	83 2d 14 b7 14 80 01 	subl   $0x1,0x8014b714
                release(&lrulock);
80102b65:	e8 56 21 00 00       	call   80104cc0 <release>
                return 1;
80102b6a:	83 c4 10             	add    $0x10,%esp
        }
    }
    release(&lrulock);
    return 0;
}
80102b6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
                return 1;
80102b70:	b8 01 00 00 00       	mov    $0x1,%eax
}
80102b75:	5b                   	pop    %ebx
80102b76:	5e                   	pop    %esi
80102b77:	5d                   	pop    %ebp
80102b78:	c3                   	ret    
80102b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        release(&lrulock);
80102b80:	83 ec 0c             	sub    $0xc,%esp
80102b83:	68 e0 b6 14 80       	push   $0x8014b6e0
80102b88:	e8 33 21 00 00       	call   80104cc0 <release>
        return 0;
80102b8d:	83 c4 10             	add    $0x10,%esp
}
80102b90:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 0;
80102b93:	31 c0                	xor    %eax,%eax
}
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5d                   	pop    %ebp
80102b98:	c3                   	ret    
80102b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        release(&lrulock);
80102ba0:	83 ec 0c             	sub    $0xc,%esp
    int index=*pte/4096;
80102ba3:	c1 e9 0c             	shr    $0xc,%ecx
        release(&lrulock);
80102ba6:	68 e0 b6 14 80       	push   $0x8014b6e0
        valid[index]=0;
80102bab:	c7 04 8d e0 36 11 80 	movl   $0x0,-0x7feec920(,%ecx,4)
80102bb2:	00 00 00 00 
        release(&lrulock);
80102bb6:	e8 05 21 00 00       	call   80104cc0 <release>
        return 2;
80102bbb:	83 c4 10             	add    $0x10,%esp
}
80102bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
        return 2;
80102bc1:	b8 02 00 00 00       	mov    $0x2,%eax
}
80102bc6:	5b                   	pop    %ebx
80102bc7:	5e                   	pop    %esi
80102bc8:	5d                   	pop    %ebp
80102bc9:	c3                   	ret    
80102bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102bd0 <PGFLT_proc>:

void PGFLT_proc(uint fault_addr, pde_t *pgdir)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
80102bd3:	57                   	push   %edi
80102bd4:	56                   	push   %esi
80102bd5:	53                   	push   %ebx
80102bd6:	83 ec 20             	sub    $0x20,%esp
80102bd9:	8b 45 08             	mov    0x8(%ebp),%eax
80102bdc:	8b 7d 0c             	mov    0xc(%ebp),%edi

    pte_t* pte_fault = walkpgdir(pgdir,(void*)fault_addr,0);
80102bdf:	6a 00                	push   $0x0
80102be1:	50                   	push   %eax
80102be2:	57                   	push   %edi
{
80102be3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pte_t* pte_fault = walkpgdir(pgdir,(void*)fault_addr,0);
80102be6:	e8 35 44 00 00       	call   80107020 <walkpgdir>
    int swap_index = *pte_fault/4096;
80102beb:	8b 18                	mov    (%eax),%ebx
    if((*pte_fault&PTE_SWAP)==0) return;
80102bed:	83 c4 10             	add    $0x10,%esp
80102bf0:	f6 c7 01             	test   $0x1,%bh
80102bf3:	0f 84 9f 00 00 00    	je     80102c98 <PGFLT_proc+0xc8>
80102bf9:	89 c6                	mov    %eax,%esi
    if(num_free_pages==0&&reclaim()==0) 
80102bfb:	a1 1c b7 14 80       	mov    0x8014b71c,%eax
80102c00:	85 c0                	test   %eax,%eax
80102c02:	75 28                	jne    80102c2c <PGFLT_proc+0x5c>
    if(num_lru_pages<=0) {
80102c04:	8b 0d 14 b7 14 80    	mov    0x8014b714,%ecx
80102c0a:	85 c9                	test   %ecx,%ecx
80102c0c:	7e 09                	jle    80102c17 <PGFLT_proc+0x47>
80102c0e:	e8 8d fb ff ff       	call   801027a0 <reclaim.part.0>
    if(num_free_pages==0&&reclaim()==0) 
80102c13:	85 c0                	test   %eax,%eax
80102c15:	75 15                	jne    80102c2c <PGFLT_proc+0x5c>
    {
        cprintf("reclaim fault\n");
80102c17:	83 ec 0c             	sub    $0xc,%esp
80102c1a:	68 8e 7c 10 80       	push   $0x80107c8e
80102c1f:	e8 3c da ff ff       	call   80100660 <cprintf>
        exit();
80102c24:	e8 67 18 00 00       	call   80104490 <exit>
80102c29:	83 c4 10             	add    $0x10,%esp
    }
    char* mem = kalloc();
80102c2c:	e8 2f fc ff ff       	call   80102860 <kalloc>
    if(mem==0) return;
80102c31:	85 c0                	test   %eax,%eax
80102c33:	74 63                	je     80102c98 <PGFLT_proc+0xc8>
    valid[swap_index]=0;
    memset(mem,0,PGSIZE);
80102c35:	83 ec 04             	sub    $0x4,%esp
    int swap_index = *pte_fault/4096;
80102c38:	c1 eb 0c             	shr    $0xc,%ebx
    memset(mem,0,PGSIZE);
80102c3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c3e:	68 00 10 00 00       	push   $0x1000
80102c43:	6a 00                	push   $0x0
80102c45:	50                   	push   %eax
    valid[swap_index]=0;
80102c46:	c7 04 9d e0 36 11 80 	movl   $0x0,-0x7feec920(,%ebx,4)
80102c4d:	00 00 00 00 
    memset(mem,0,PGSIZE);
80102c51:	e8 ca 20 00 00       	call   80104d20 <memset>
    *pte_fault=V2P(mem)|(*pte_fault%4096+1-0x100);
80102c56:	8b 06                	mov    (%esi),%eax
80102c58:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102c5b:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c60:	8d 90 01 ff ff ff    	lea    -0xff(%eax),%edx
80102c66:	8d 81 00 00 00 80    	lea    -0x80000000(%ecx),%eax
80102c6c:	09 d0                	or     %edx,%eax
80102c6e:	89 06                	mov    %eax,(%esi)
    add_pglist((char*)fault_addr,pgdir);
80102c70:	58                   	pop    %eax
80102c71:	5a                   	pop    %edx
80102c72:	57                   	push   %edi
80102c73:	ff 75 e4             	pushl  -0x1c(%ebp)
80102c76:	e8 05 fd ff ff       	call   80102980 <add_pglist>
    swapread(mem,swap_index);
80102c7b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80102c7e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102c81:	83 c4 10             	add    $0x10,%esp
80102c84:	89 4d 08             	mov    %ecx,0x8(%ebp)
}
80102c87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c8a:	5b                   	pop    %ebx
80102c8b:	5e                   	pop    %esi
80102c8c:	5f                   	pop    %edi
80102c8d:	5d                   	pop    %ebp
    swapread(mem,swap_index);
80102c8e:	e9 9d f2 ff ff       	jmp    80101f30 <swapread>
80102c93:	90                   	nop
80102c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80102c98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c9b:	5b                   	pop    %ebx
80102c9c:	5e                   	pop    %esi
80102c9d:	5f                   	pop    %edi
80102c9e:	5d                   	pop    %ebp
80102c9f:	c3                   	ret    

80102ca0 <print_swap_list>:

void print_swap_list(void)
{
80102ca0:	55                   	push   %ebp
80102ca1:	89 e5                	mov    %esp,%ebp
80102ca3:	53                   	push   %ebx
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
80102ca4:	31 db                	xor    %ebx,%ebx
{
80102ca6:	83 ec 04             	sub    $0x4,%esp
80102ca9:	eb 10                	jmp    80102cbb <print_swap_list+0x1b>
80102cab:	90                   	nop
80102cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
80102cb0:	83 c3 01             	add    $0x1,%ebx
80102cb3:	81 fb 00 e0 00 00    	cmp    $0xe000,%ebx
80102cb9:	74 26                	je     80102ce1 <print_swap_list+0x41>
    {
        if(valid[i]==1) cprintf("%dth swap is valid\n",i);
80102cbb:	83 3c 9d e0 36 11 80 	cmpl   $0x1,-0x7feec920(,%ebx,4)
80102cc2:	01 
80102cc3:	75 eb                	jne    80102cb0 <print_swap_list+0x10>
80102cc5:	83 ec 08             	sub    $0x8,%esp
80102cc8:	53                   	push   %ebx
80102cc9:	68 9d 7c 10 80       	push   $0x80107c9d
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
80102cce:	83 c3 01             	add    $0x1,%ebx
        if(valid[i]==1) cprintf("%dth swap is valid\n",i);
80102cd1:	e8 8a d9 ff ff       	call   80100660 <cprintf>
80102cd6:	83 c4 10             	add    $0x10,%esp
    for(int i=0;i<PHYSTOP/PGSIZE;i++)
80102cd9:	81 fb 00 e0 00 00    	cmp    $0xe000,%ebx
80102cdf:	75 da                	jne    80102cbb <print_swap_list+0x1b>
    }
}
80102ce1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce4:	c9                   	leave  
80102ce5:	c3                   	ret    
80102ce6:	8d 76 00             	lea    0x0(%esi),%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cf0 <copy_swap>:
void copy_swap(pde_t* pgdir, pde_t* new_pgdir, int i)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	57                   	push   %edi
80102cf4:	56                   	push   %esi
80102cf5:	53                   	push   %ebx
80102cf6:	83 ec 10             	sub    $0x10,%esp
80102cf9:	8b 75 10             	mov    0x10(%ebp),%esi
    pte_t* pte = walkpgdir(pgdir,(void*)i,0);
80102cfc:	6a 00                	push   $0x0
80102cfe:	56                   	push   %esi
80102cff:	ff 75 08             	pushl  0x8(%ebp)
80102d02:	e8 19 43 00 00       	call   80107020 <walkpgdir>
    int oldoff=*pte/4096;
80102d07:	8b 10                	mov    (%eax),%edx
    pte_t* pte = walkpgdir(pgdir,(void*)i,0);
80102d09:	89 c7                	mov    %eax,%edi
    int oldoff=*pte/4096;
80102d0b:	83 c4 10             	add    $0x10,%esp
    int newoff=0;
    for(int i=1;i<PHYSTOP/PGSIZE;i++)
80102d0e:	b8 01 00 00 00       	mov    $0x1,%eax
    int oldoff=*pte/4096;
80102d13:	c1 ea 0c             	shr    $0xc,%edx
80102d16:	eb 12                	jmp    80102d2a <copy_swap+0x3a>
80102d18:	90                   	nop
80102d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(int i=1;i<PHYSTOP/PGSIZE;i++)
80102d20:	83 c0 01             	add    $0x1,%eax
80102d23:	3d 00 e0 00 00       	cmp    $0xe000,%eax
80102d28:	74 46                	je     80102d70 <copy_swap+0x80>
    {
        if(valid[i]==0)
80102d2a:	8b 0c 85 e0 36 11 80 	mov    -0x7feec920(,%eax,4),%ecx
80102d31:	85 c9                	test   %ecx,%ecx
80102d33:	75 eb                	jne    80102d20 <copy_swap+0x30>
80102d35:	89 c3                	mov    %eax,%ebx
80102d37:	c1 e3 0c             	shl    $0xc,%ebx
        {
            newoff=i;
            break;
        }
    }
    copy_swap_data(oldoff,newoff);
80102d3a:	83 ec 08             	sub    $0x8,%esp
80102d3d:	50                   	push   %eax
80102d3e:	52                   	push   %edx
80102d3f:	e8 0c f3 ff ff       	call   80102050 <copy_swap_data>
    pte_t* new_pte=walkpgdir(new_pgdir,(void*)i,0);
80102d44:	83 c4 0c             	add    $0xc,%esp
80102d47:	6a 00                	push   $0x0
80102d49:	56                   	push   %esi
80102d4a:	ff 75 0c             	pushl  0xc(%ebp)
80102d4d:	e8 ce 42 00 00       	call   80107020 <walkpgdir>
    *new_pte=(newoff*4096)+(*pte%4096);
80102d52:	8b 17                	mov    (%edi),%edx
}
80102d54:	83 c4 10             	add    $0x10,%esp
    *new_pte=(newoff*4096)+(*pte%4096);
80102d57:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
80102d5d:	01 da                	add    %ebx,%edx
80102d5f:	89 10                	mov    %edx,(%eax)
}
80102d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d64:	5b                   	pop    %ebx
80102d65:	5e                   	pop    %esi
80102d66:	5f                   	pop    %edi
80102d67:	5d                   	pop    %ebp
80102d68:	c3                   	ret    
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d70:	31 db                	xor    %ebx,%ebx
    int newoff=0;
80102d72:	31 c0                	xor    %eax,%eax
80102d74:	eb c4                	jmp    80102d3a <copy_swap+0x4a>
80102d76:	66 90                	xchg   %ax,%ax
80102d78:	66 90                	xchg   %ax,%ax
80102d7a:	66 90                	xchg   %ax,%ax
80102d7c:	66 90                	xchg   %ax,%ax
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d80:	ba 64 00 00 00       	mov    $0x64,%edx
80102d85:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102d86:	a8 01                	test   $0x1,%al
80102d88:	0f 84 c2 00 00 00    	je     80102e50 <kbdgetc+0xd0>
80102d8e:	ba 60 00 00 00       	mov    $0x60,%edx
80102d93:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102d94:	0f b6 d0             	movzbl %al,%edx
80102d97:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
80102d9d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102da3:	0f 84 7f 00 00 00    	je     80102e28 <kbdgetc+0xa8>
{
80102da9:	55                   	push   %ebp
80102daa:	89 e5                	mov    %esp,%ebp
80102dac:	53                   	push   %ebx
80102dad:	89 cb                	mov    %ecx,%ebx
80102daf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102db2:	84 c0                	test   %al,%al
80102db4:	78 4a                	js     80102e00 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102db6:	85 db                	test   %ebx,%ebx
80102db8:	74 09                	je     80102dc3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dba:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102dbd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102dc0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102dc3:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
80102dca:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
80102dcc:	0f b6 82 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%eax
80102dd3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102dd5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102dd7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102ddd:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102de0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102de3:	8b 04 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%eax
80102dea:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102dee:	74 31                	je     80102e21 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102df0:	8d 50 9f             	lea    -0x61(%eax),%edx
80102df3:	83 fa 19             	cmp    $0x19,%edx
80102df6:	77 40                	ja     80102e38 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102df8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102dfb:	5b                   	pop    %ebx
80102dfc:	5d                   	pop    %ebp
80102dfd:	c3                   	ret    
80102dfe:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102e00:	83 e0 7f             	and    $0x7f,%eax
80102e03:	85 db                	test   %ebx,%ebx
80102e05:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102e08:	0f b6 82 40 7e 10 80 	movzbl -0x7fef81c0(%edx),%eax
80102e0f:	83 c8 40             	or     $0x40,%eax
80102e12:	0f b6 c0             	movzbl %al,%eax
80102e15:	f7 d0                	not    %eax
80102e17:	21 c1                	and    %eax,%ecx
    return 0;
80102e19:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102e1b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102e21:	5b                   	pop    %ebx
80102e22:	5d                   	pop    %ebp
80102e23:	c3                   	ret    
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102e28:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102e2b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102e2d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102e38:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102e3b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102e3e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102e3f:	83 f9 1a             	cmp    $0x1a,%ecx
80102e42:	0f 42 c2             	cmovb  %edx,%eax
}
80102e45:	5d                   	pop    %ebp
80102e46:	c3                   	ret    
80102e47:	89 f6                	mov    %esi,%esi
80102e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e55:	c3                   	ret    
80102e56:	8d 76 00             	lea    0x0(%esi),%esi
80102e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102e60 <kbdintr>:

void
kbdintr(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102e66:	68 80 2d 10 80       	push   $0x80102d80
80102e6b:	e8 a0 d9 ff ff       	call   80100810 <consoleintr>
}
80102e70:	83 c4 10             	add    $0x10,%esp
80102e73:	c9                   	leave  
80102e74:	c3                   	ret    
80102e75:	66 90                	xchg   %ax,%ax
80102e77:	66 90                	xchg   %ax,%ax
80102e79:	66 90                	xchg   %ax,%ax
80102e7b:	66 90                	xchg   %ax,%ax
80102e7d:	66 90                	xchg   %ax,%ax
80102e7f:	90                   	nop

80102e80 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102e80:	a1 20 b7 22 80       	mov    0x8022b720,%eax
{
80102e85:	55                   	push   %ebp
80102e86:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102e88:	85 c0                	test   %eax,%eax
80102e8a:	0f 84 c8 00 00 00    	je     80102f58 <lapicinit+0xd8>
  lapic[index] = value;
80102e90:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102e97:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102e9a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102e9d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ea4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ea7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eaa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102eb1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102eb4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102eb7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ebe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ec1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ec4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102ecb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ece:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ed1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ed8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102edb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102ede:	8b 50 30             	mov    0x30(%eax),%edx
80102ee1:	c1 ea 10             	shr    $0x10,%edx
80102ee4:	80 fa 03             	cmp    $0x3,%dl
80102ee7:	77 77                	ja     80102f60 <lapicinit+0xe0>
  lapic[index] = value;
80102ee9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102ef0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ef3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ef6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102efd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f00:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f03:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102f0a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f0d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f10:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102f17:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f1a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f1d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102f24:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f27:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102f2a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102f31:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102f34:	8b 50 20             	mov    0x20(%eax),%edx
80102f37:	89 f6                	mov    %esi,%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102f40:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102f46:	80 e6 10             	and    $0x10,%dh
80102f49:	75 f5                	jne    80102f40 <lapicinit+0xc0>
  lapic[index] = value;
80102f4b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102f52:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102f55:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102f58:	5d                   	pop    %ebp
80102f59:	c3                   	ret    
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102f60:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102f67:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102f6a:	8b 50 20             	mov    0x20(%eax),%edx
80102f6d:	e9 77 ff ff ff       	jmp    80102ee9 <lapicinit+0x69>
80102f72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f80 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102f80:	8b 15 20 b7 22 80    	mov    0x8022b720,%edx
{
80102f86:	55                   	push   %ebp
80102f87:	31 c0                	xor    %eax,%eax
80102f89:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f8b:	85 d2                	test   %edx,%edx
80102f8d:	74 06                	je     80102f95 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102f8f:	8b 42 20             	mov    0x20(%edx),%eax
80102f92:	c1 e8 18             	shr    $0x18,%eax
}
80102f95:	5d                   	pop    %ebp
80102f96:	c3                   	ret    
80102f97:	89 f6                	mov    %esi,%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102fa0:	a1 20 b7 22 80       	mov    0x8022b720,%eax
{
80102fa5:	55                   	push   %ebp
80102fa6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102fa8:	85 c0                	test   %eax,%eax
80102faa:	74 0d                	je     80102fb9 <lapiceoi+0x19>
  lapic[index] = value;
80102fac:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102fb3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102fb6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102fb9:	5d                   	pop    %ebp
80102fba:	c3                   	ret    
80102fbb:	90                   	nop
80102fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102fc0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
}
80102fc3:	5d                   	pop    %ebp
80102fc4:	c3                   	ret    
80102fc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fd0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102fd0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102fd1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102fd6:	ba 70 00 00 00       	mov    $0x70,%edx
80102fdb:	89 e5                	mov    %esp,%ebp
80102fdd:	53                   	push   %ebx
80102fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102fe1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102fe4:	ee                   	out    %al,(%dx)
80102fe5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102fea:	ba 71 00 00 00       	mov    $0x71,%edx
80102fef:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ff0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ff2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ff5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102ffb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ffd:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80103000:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80103003:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80103005:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80103008:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010300e:	a1 20 b7 22 80       	mov    0x8022b720,%eax
80103013:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103019:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010301c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80103023:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103026:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103029:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80103030:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103033:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103036:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010303c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010303f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103045:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103048:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010304e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103051:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103057:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
8010305a:	5b                   	pop    %ebx
8010305b:	5d                   	pop    %ebp
8010305c:	c3                   	ret    
8010305d:	8d 76 00             	lea    0x0(%esi),%esi

80103060 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103060:	55                   	push   %ebp
80103061:	b8 0b 00 00 00       	mov    $0xb,%eax
80103066:	ba 70 00 00 00       	mov    $0x70,%edx
8010306b:	89 e5                	mov    %esp,%ebp
8010306d:	57                   	push   %edi
8010306e:	56                   	push   %esi
8010306f:	53                   	push   %ebx
80103070:	83 ec 4c             	sub    $0x4c,%esp
80103073:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103074:	ba 71 00 00 00       	mov    $0x71,%edx
80103079:	ec                   	in     (%dx),%al
8010307a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010307d:	bb 70 00 00 00       	mov    $0x70,%ebx
80103082:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103085:	8d 76 00             	lea    0x0(%esi),%esi
80103088:	31 c0                	xor    %eax,%eax
8010308a:	89 da                	mov    %ebx,%edx
8010308c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010308d:	b9 71 00 00 00       	mov    $0x71,%ecx
80103092:	89 ca                	mov    %ecx,%edx
80103094:	ec                   	in     (%dx),%al
80103095:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103098:	89 da                	mov    %ebx,%edx
8010309a:	b8 02 00 00 00       	mov    $0x2,%eax
8010309f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030a0:	89 ca                	mov    %ecx,%edx
801030a2:	ec                   	in     (%dx),%al
801030a3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030a6:	89 da                	mov    %ebx,%edx
801030a8:	b8 04 00 00 00       	mov    $0x4,%eax
801030ad:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ae:	89 ca                	mov    %ecx,%edx
801030b0:	ec                   	in     (%dx),%al
801030b1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030b4:	89 da                	mov    %ebx,%edx
801030b6:	b8 07 00 00 00       	mov    $0x7,%eax
801030bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030bc:	89 ca                	mov    %ecx,%edx
801030be:	ec                   	in     (%dx),%al
801030bf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030c2:	89 da                	mov    %ebx,%edx
801030c4:	b8 08 00 00 00       	mov    $0x8,%eax
801030c9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030ca:	89 ca                	mov    %ecx,%edx
801030cc:	ec                   	in     (%dx),%al
801030cd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030cf:	89 da                	mov    %ebx,%edx
801030d1:	b8 09 00 00 00       	mov    $0x9,%eax
801030d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030d7:	89 ca                	mov    %ecx,%edx
801030d9:	ec                   	in     (%dx),%al
801030da:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030dc:	89 da                	mov    %ebx,%edx
801030de:	b8 0a 00 00 00       	mov    $0xa,%eax
801030e3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e4:	89 ca                	mov    %ecx,%edx
801030e6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801030e7:	84 c0                	test   %al,%al
801030e9:	78 9d                	js     80103088 <cmostime+0x28>
  return inb(CMOS_RETURN);
801030eb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801030ef:	89 fa                	mov    %edi,%edx
801030f1:	0f b6 fa             	movzbl %dl,%edi
801030f4:	89 f2                	mov    %esi,%edx
801030f6:	0f b6 f2             	movzbl %dl,%esi
801030f9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030fc:	89 da                	mov    %ebx,%edx
801030fe:	89 75 cc             	mov    %esi,-0x34(%ebp)
80103101:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103104:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80103108:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010310b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010310f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80103112:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80103116:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80103119:	31 c0                	xor    %eax,%eax
8010311b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010311c:	89 ca                	mov    %ecx,%edx
8010311e:	ec                   	in     (%dx),%al
8010311f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103122:	89 da                	mov    %ebx,%edx
80103124:	89 45 d0             	mov    %eax,-0x30(%ebp)
80103127:	b8 02 00 00 00       	mov    $0x2,%eax
8010312c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010312d:	89 ca                	mov    %ecx,%edx
8010312f:	ec                   	in     (%dx),%al
80103130:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103133:	89 da                	mov    %ebx,%edx
80103135:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103138:	b8 04 00 00 00       	mov    $0x4,%eax
8010313d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010313e:	89 ca                	mov    %ecx,%edx
80103140:	ec                   	in     (%dx),%al
80103141:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103144:	89 da                	mov    %ebx,%edx
80103146:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103149:	b8 07 00 00 00       	mov    $0x7,%eax
8010314e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010314f:	89 ca                	mov    %ecx,%edx
80103151:	ec                   	in     (%dx),%al
80103152:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103155:	89 da                	mov    %ebx,%edx
80103157:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010315a:	b8 08 00 00 00       	mov    $0x8,%eax
8010315f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103160:	89 ca                	mov    %ecx,%edx
80103162:	ec                   	in     (%dx),%al
80103163:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103166:	89 da                	mov    %ebx,%edx
80103168:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010316b:	b8 09 00 00 00       	mov    $0x9,%eax
80103170:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103171:	89 ca                	mov    %ecx,%edx
80103173:	ec                   	in     (%dx),%al
80103174:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103177:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
8010317a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010317d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103180:	6a 18                	push   $0x18
80103182:	50                   	push   %eax
80103183:	8d 45 b8             	lea    -0x48(%ebp),%eax
80103186:	50                   	push   %eax
80103187:	e8 e4 1b 00 00       	call   80104d70 <memcmp>
8010318c:	83 c4 10             	add    $0x10,%esp
8010318f:	85 c0                	test   %eax,%eax
80103191:	0f 85 f1 fe ff ff    	jne    80103088 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80103197:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
8010319b:	75 78                	jne    80103215 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010319d:	8b 45 b8             	mov    -0x48(%ebp),%eax
801031a0:	89 c2                	mov    %eax,%edx
801031a2:	83 e0 0f             	and    $0xf,%eax
801031a5:	c1 ea 04             	shr    $0x4,%edx
801031a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ae:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801031b1:	8b 45 bc             	mov    -0x44(%ebp),%eax
801031b4:	89 c2                	mov    %eax,%edx
801031b6:	83 e0 0f             	and    $0xf,%eax
801031b9:	c1 ea 04             	shr    $0x4,%edx
801031bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031c2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801031c5:	8b 45 c0             	mov    -0x40(%ebp),%eax
801031c8:	89 c2                	mov    %eax,%edx
801031ca:	83 e0 0f             	and    $0xf,%eax
801031cd:	c1 ea 04             	shr    $0x4,%edx
801031d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801031d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801031dc:	89 c2                	mov    %eax,%edx
801031de:	83 e0 0f             	and    $0xf,%eax
801031e1:	c1 ea 04             	shr    $0x4,%edx
801031e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031ea:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801031ed:	8b 45 c8             	mov    -0x38(%ebp),%eax
801031f0:	89 c2                	mov    %eax,%edx
801031f2:	83 e0 0f             	and    $0xf,%eax
801031f5:	c1 ea 04             	shr    $0x4,%edx
801031f8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801031fb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801031fe:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80103201:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103204:	89 c2                	mov    %eax,%edx
80103206:	83 e0 0f             	and    $0xf,%eax
80103209:	c1 ea 04             	shr    $0x4,%edx
8010320c:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010320f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103212:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80103215:	8b 75 08             	mov    0x8(%ebp),%esi
80103218:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010321b:	89 06                	mov    %eax,(%esi)
8010321d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103220:	89 46 04             	mov    %eax,0x4(%esi)
80103223:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103226:	89 46 08             	mov    %eax,0x8(%esi)
80103229:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010322c:	89 46 0c             	mov    %eax,0xc(%esi)
8010322f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80103232:	89 46 10             	mov    %eax,0x10(%esi)
80103235:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103238:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
8010323b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80103242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103245:	5b                   	pop    %ebx
80103246:	5e                   	pop    %esi
80103247:	5f                   	pop    %edi
80103248:	5d                   	pop    %ebp
80103249:	c3                   	ret    
8010324a:	66 90                	xchg   %ax,%ax
8010324c:	66 90                	xchg   %ax,%ax
8010324e:	66 90                	xchg   %ax,%ax

80103250 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103250:	8b 0d 88 b7 22 80    	mov    0x8022b788,%ecx
80103256:	85 c9                	test   %ecx,%ecx
80103258:	0f 8e 8a 00 00 00    	jle    801032e8 <install_trans+0x98>
{
8010325e:	55                   	push   %ebp
8010325f:	89 e5                	mov    %esp,%ebp
80103261:	57                   	push   %edi
80103262:	56                   	push   %esi
80103263:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80103264:	31 db                	xor    %ebx,%ebx
{
80103266:	83 ec 0c             	sub    $0xc,%esp
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103270:	a1 74 b7 22 80       	mov    0x8022b774,%eax
80103275:	83 ec 08             	sub    $0x8,%esp
80103278:	01 d8                	add    %ebx,%eax
8010327a:	83 c0 01             	add    $0x1,%eax
8010327d:	50                   	push   %eax
8010327e:	ff 35 84 b7 22 80    	pushl  0x8022b784
80103284:	e8 47 ce ff ff       	call   801000d0 <bread>
80103289:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010328b:	58                   	pop    %eax
8010328c:	5a                   	pop    %edx
8010328d:	ff 34 9d 8c b7 22 80 	pushl  -0x7fdd4874(,%ebx,4)
80103294:	ff 35 84 b7 22 80    	pushl  0x8022b784
  for (tail = 0; tail < log.lh.n; tail++) {
8010329a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010329d:	e8 2e ce ff ff       	call   801000d0 <bread>
801032a2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032a4:	8d 47 5c             	lea    0x5c(%edi),%eax
801032a7:	83 c4 0c             	add    $0xc,%esp
801032aa:	68 00 02 00 00       	push   $0x200
801032af:	50                   	push   %eax
801032b0:	8d 46 5c             	lea    0x5c(%esi),%eax
801032b3:	50                   	push   %eax
801032b4:	e8 17 1b 00 00       	call   80104dd0 <memmove>
    bwrite(dbuf);  // write dst to disk
801032b9:	89 34 24             	mov    %esi,(%esp)
801032bc:	e8 df ce ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801032c1:	89 3c 24             	mov    %edi,(%esp)
801032c4:	e8 17 cf ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801032c9:	89 34 24             	mov    %esi,(%esp)
801032cc:	e8 0f cf ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801032d1:	83 c4 10             	add    $0x10,%esp
801032d4:	39 1d 88 b7 22 80    	cmp    %ebx,0x8022b788
801032da:	7f 94                	jg     80103270 <install_trans+0x20>
  }
}
801032dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032df:	5b                   	pop    %ebx
801032e0:	5e                   	pop    %esi
801032e1:	5f                   	pop    %edi
801032e2:	5d                   	pop    %ebp
801032e3:	c3                   	ret    
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032e8:	f3 c3                	repz ret 
801032ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801032f0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	56                   	push   %esi
801032f4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
801032f5:	83 ec 08             	sub    $0x8,%esp
801032f8:	ff 35 74 b7 22 80    	pushl  0x8022b774
801032fe:	ff 35 84 b7 22 80    	pushl  0x8022b784
80103304:	e8 c7 cd ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80103309:	8b 1d 88 b7 22 80    	mov    0x8022b788,%ebx
  for (i = 0; i < log.lh.n; i++) {
8010330f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80103312:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80103314:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80103316:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103319:	7e 16                	jle    80103331 <write_head+0x41>
8010331b:	c1 e3 02             	shl    $0x2,%ebx
8010331e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80103320:	8b 8a 8c b7 22 80    	mov    -0x7fdd4874(%edx),%ecx
80103326:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
8010332a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
8010332d:	39 da                	cmp    %ebx,%edx
8010332f:	75 ef                	jne    80103320 <write_head+0x30>
  }
  bwrite(buf);
80103331:	83 ec 0c             	sub    $0xc,%esp
80103334:	56                   	push   %esi
80103335:	e8 66 ce ff ff       	call   801001a0 <bwrite>
  brelse(buf);
8010333a:	89 34 24             	mov    %esi,(%esp)
8010333d:	e8 9e ce ff ff       	call   801001e0 <brelse>
}
80103342:	83 c4 10             	add    $0x10,%esp
80103345:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103348:	5b                   	pop    %ebx
80103349:	5e                   	pop    %esi
8010334a:	5d                   	pop    %ebp
8010334b:	c3                   	ret    
8010334c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103350 <initlog>:
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	53                   	push   %ebx
80103354:	83 ec 2c             	sub    $0x2c,%esp
80103357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010335a:	68 40 7f 10 80       	push   $0x80107f40
8010335f:	68 40 b7 22 80       	push   $0x8022b740
80103364:	e8 57 17 00 00       	call   80104ac0 <initlock>
  readsb(dev, &sb);
80103369:	58                   	pop    %eax
8010336a:	8d 45 dc             	lea    -0x24(%ebp),%eax
8010336d:	5a                   	pop    %edx
8010336e:	50                   	push   %eax
8010336f:	53                   	push   %ebx
80103370:	e8 5b e0 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80103375:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010337b:	59                   	pop    %ecx
  log.dev = dev;
8010337c:	89 1d 84 b7 22 80    	mov    %ebx,0x8022b784
  log.size = sb.nlog;
80103382:	89 15 78 b7 22 80    	mov    %edx,0x8022b778
  log.start = sb.logstart;
80103388:	a3 74 b7 22 80       	mov    %eax,0x8022b774
  struct buf *buf = bread(log.dev, log.start);
8010338d:	5a                   	pop    %edx
8010338e:	50                   	push   %eax
8010338f:	53                   	push   %ebx
80103390:	e8 3b cd ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80103395:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80103398:	83 c4 10             	add    $0x10,%esp
8010339b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
8010339d:	89 1d 88 b7 22 80    	mov    %ebx,0x8022b788
  for (i = 0; i < log.lh.n; i++) {
801033a3:	7e 1c                	jle    801033c1 <initlog+0x71>
801033a5:	c1 e3 02             	shl    $0x2,%ebx
801033a8:	31 d2                	xor    %edx,%edx
801033aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
801033b0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
801033b4:	83 c2 04             	add    $0x4,%edx
801033b7:	89 8a 88 b7 22 80    	mov    %ecx,-0x7fdd4878(%edx)
  for (i = 0; i < log.lh.n; i++) {
801033bd:	39 d3                	cmp    %edx,%ebx
801033bf:	75 ef                	jne    801033b0 <initlog+0x60>
  brelse(buf);
801033c1:	83 ec 0c             	sub    $0xc,%esp
801033c4:	50                   	push   %eax
801033c5:	e8 16 ce ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801033ca:	e8 81 fe ff ff       	call   80103250 <install_trans>
  log.lh.n = 0;
801033cf:	c7 05 88 b7 22 80 00 	movl   $0x0,0x8022b788
801033d6:	00 00 00 
  write_head(); // clear the log
801033d9:	e8 12 ff ff ff       	call   801032f0 <write_head>
}
801033de:	83 c4 10             	add    $0x10,%esp
801033e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033e4:	c9                   	leave  
801033e5:	c3                   	ret    
801033e6:	8d 76 00             	lea    0x0(%esi),%esi
801033e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801033f0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801033f6:	68 40 b7 22 80       	push   $0x8022b740
801033fb:	e8 00 18 00 00       	call   80104c00 <acquire>
80103400:	83 c4 10             	add    $0x10,%esp
80103403:	eb 18                	jmp    8010341d <begin_op+0x2d>
80103405:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103408:	83 ec 08             	sub    $0x8,%esp
8010340b:	68 40 b7 22 80       	push   $0x8022b740
80103410:	68 40 b7 22 80       	push   $0x8022b740
80103415:	e8 f6 11 00 00       	call   80104610 <sleep>
8010341a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010341d:	a1 80 b7 22 80       	mov    0x8022b780,%eax
80103422:	85 c0                	test   %eax,%eax
80103424:	75 e2                	jne    80103408 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103426:	a1 7c b7 22 80       	mov    0x8022b77c,%eax
8010342b:	8b 15 88 b7 22 80    	mov    0x8022b788,%edx
80103431:	83 c0 01             	add    $0x1,%eax
80103434:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103437:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010343a:	83 fa 1e             	cmp    $0x1e,%edx
8010343d:	7f c9                	jg     80103408 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010343f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103442:	a3 7c b7 22 80       	mov    %eax,0x8022b77c
      release(&log.lock);
80103447:	68 40 b7 22 80       	push   $0x8022b740
8010344c:	e8 6f 18 00 00       	call   80104cc0 <release>
      break;
    }
  }
}
80103451:	83 c4 10             	add    $0x10,%esp
80103454:	c9                   	leave  
80103455:	c3                   	ret    
80103456:	8d 76 00             	lea    0x0(%esi),%esi
80103459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103460 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103469:	68 40 b7 22 80       	push   $0x8022b740
8010346e:	e8 8d 17 00 00       	call   80104c00 <acquire>
  log.outstanding -= 1;
80103473:	a1 7c b7 22 80       	mov    0x8022b77c,%eax
  if(log.committing)
80103478:	8b 35 80 b7 22 80    	mov    0x8022b780,%esi
8010347e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103481:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103484:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103486:	89 1d 7c b7 22 80    	mov    %ebx,0x8022b77c
  if(log.committing)
8010348c:	0f 85 1a 01 00 00    	jne    801035ac <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103492:	85 db                	test   %ebx,%ebx
80103494:	0f 85 ee 00 00 00    	jne    80103588 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010349a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010349d:	c7 05 80 b7 22 80 01 	movl   $0x1,0x8022b780
801034a4:	00 00 00 
  release(&log.lock);
801034a7:	68 40 b7 22 80       	push   $0x8022b740
801034ac:	e8 0f 18 00 00       	call   80104cc0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801034b1:	8b 0d 88 b7 22 80    	mov    0x8022b788,%ecx
801034b7:	83 c4 10             	add    $0x10,%esp
801034ba:	85 c9                	test   %ecx,%ecx
801034bc:	0f 8e 85 00 00 00    	jle    80103547 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801034c2:	a1 74 b7 22 80       	mov    0x8022b774,%eax
801034c7:	83 ec 08             	sub    $0x8,%esp
801034ca:	01 d8                	add    %ebx,%eax
801034cc:	83 c0 01             	add    $0x1,%eax
801034cf:	50                   	push   %eax
801034d0:	ff 35 84 b7 22 80    	pushl  0x8022b784
801034d6:	e8 f5 cb ff ff       	call   801000d0 <bread>
801034db:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034dd:	58                   	pop    %eax
801034de:	5a                   	pop    %edx
801034df:	ff 34 9d 8c b7 22 80 	pushl  -0x7fdd4874(,%ebx,4)
801034e6:	ff 35 84 b7 22 80    	pushl  0x8022b784
  for (tail = 0; tail < log.lh.n; tail++) {
801034ec:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801034ef:	e8 dc cb ff ff       	call   801000d0 <bread>
801034f4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801034f6:	8d 40 5c             	lea    0x5c(%eax),%eax
801034f9:	83 c4 0c             	add    $0xc,%esp
801034fc:	68 00 02 00 00       	push   $0x200
80103501:	50                   	push   %eax
80103502:	8d 46 5c             	lea    0x5c(%esi),%eax
80103505:	50                   	push   %eax
80103506:	e8 c5 18 00 00       	call   80104dd0 <memmove>
    bwrite(to);  // write the log
8010350b:	89 34 24             	mov    %esi,(%esp)
8010350e:	e8 8d cc ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103513:	89 3c 24             	mov    %edi,(%esp)
80103516:	e8 c5 cc ff ff       	call   801001e0 <brelse>
    brelse(to);
8010351b:	89 34 24             	mov    %esi,(%esp)
8010351e:	e8 bd cc ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103523:	83 c4 10             	add    $0x10,%esp
80103526:	3b 1d 88 b7 22 80    	cmp    0x8022b788,%ebx
8010352c:	7c 94                	jl     801034c2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010352e:	e8 bd fd ff ff       	call   801032f0 <write_head>
    install_trans(); // Now install writes to home locations
80103533:	e8 18 fd ff ff       	call   80103250 <install_trans>
    log.lh.n = 0;
80103538:	c7 05 88 b7 22 80 00 	movl   $0x0,0x8022b788
8010353f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103542:	e8 a9 fd ff ff       	call   801032f0 <write_head>
    acquire(&log.lock);
80103547:	83 ec 0c             	sub    $0xc,%esp
8010354a:	68 40 b7 22 80       	push   $0x8022b740
8010354f:	e8 ac 16 00 00       	call   80104c00 <acquire>
    wakeup(&log);
80103554:	c7 04 24 40 b7 22 80 	movl   $0x8022b740,(%esp)
    log.committing = 0;
8010355b:	c7 05 80 b7 22 80 00 	movl   $0x0,0x8022b780
80103562:	00 00 00 
    wakeup(&log);
80103565:	e8 56 12 00 00       	call   801047c0 <wakeup>
    release(&log.lock);
8010356a:	c7 04 24 40 b7 22 80 	movl   $0x8022b740,(%esp)
80103571:	e8 4a 17 00 00       	call   80104cc0 <release>
80103576:	83 c4 10             	add    $0x10,%esp
}
80103579:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010357c:	5b                   	pop    %ebx
8010357d:	5e                   	pop    %esi
8010357e:	5f                   	pop    %edi
8010357f:	5d                   	pop    %ebp
80103580:	c3                   	ret    
80103581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103588:	83 ec 0c             	sub    $0xc,%esp
8010358b:	68 40 b7 22 80       	push   $0x8022b740
80103590:	e8 2b 12 00 00       	call   801047c0 <wakeup>
  release(&log.lock);
80103595:	c7 04 24 40 b7 22 80 	movl   $0x8022b740,(%esp)
8010359c:	e8 1f 17 00 00       	call   80104cc0 <release>
801035a1:	83 c4 10             	add    $0x10,%esp
}
801035a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035a7:	5b                   	pop    %ebx
801035a8:	5e                   	pop    %esi
801035a9:	5f                   	pop    %edi
801035aa:	5d                   	pop    %ebp
801035ab:	c3                   	ret    
    panic("log.committing");
801035ac:	83 ec 0c             	sub    $0xc,%esp
801035af:	68 44 7f 10 80       	push   $0x80107f44
801035b4:	e8 d7 cd ff ff       	call   80100390 <panic>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	53                   	push   %ebx
801035c4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035c7:	8b 15 88 b7 22 80    	mov    0x8022b788,%edx
{
801035cd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801035d0:	83 fa 1d             	cmp    $0x1d,%edx
801035d3:	0f 8f 9d 00 00 00    	jg     80103676 <log_write+0xb6>
801035d9:	a1 78 b7 22 80       	mov    0x8022b778,%eax
801035de:	83 e8 01             	sub    $0x1,%eax
801035e1:	39 c2                	cmp    %eax,%edx
801035e3:	0f 8d 8d 00 00 00    	jge    80103676 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801035e9:	a1 7c b7 22 80       	mov    0x8022b77c,%eax
801035ee:	85 c0                	test   %eax,%eax
801035f0:	0f 8e 8d 00 00 00    	jle    80103683 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801035f6:	83 ec 0c             	sub    $0xc,%esp
801035f9:	68 40 b7 22 80       	push   $0x8022b740
801035fe:	e8 fd 15 00 00       	call   80104c00 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103603:	8b 0d 88 b7 22 80    	mov    0x8022b788,%ecx
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	83 f9 00             	cmp    $0x0,%ecx
8010360f:	7e 57                	jle    80103668 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103611:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103614:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103616:	3b 15 8c b7 22 80    	cmp    0x8022b78c,%edx
8010361c:	75 0b                	jne    80103629 <log_write+0x69>
8010361e:	eb 38                	jmp    80103658 <log_write+0x98>
80103620:	39 14 85 8c b7 22 80 	cmp    %edx,-0x7fdd4874(,%eax,4)
80103627:	74 2f                	je     80103658 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103629:	83 c0 01             	add    $0x1,%eax
8010362c:	39 c1                	cmp    %eax,%ecx
8010362e:	75 f0                	jne    80103620 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103630:	89 14 85 8c b7 22 80 	mov    %edx,-0x7fdd4874(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103637:	83 c0 01             	add    $0x1,%eax
8010363a:	a3 88 b7 22 80       	mov    %eax,0x8022b788
  b->flags |= B_DIRTY; // prevent eviction
8010363f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103642:	c7 45 08 40 b7 22 80 	movl   $0x8022b740,0x8(%ebp)
}
80103649:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010364c:	c9                   	leave  
  release(&log.lock);
8010364d:	e9 6e 16 00 00       	jmp    80104cc0 <release>
80103652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103658:	89 14 85 8c b7 22 80 	mov    %edx,-0x7fdd4874(,%eax,4)
8010365f:	eb de                	jmp    8010363f <log_write+0x7f>
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103668:	8b 43 08             	mov    0x8(%ebx),%eax
8010366b:	a3 8c b7 22 80       	mov    %eax,0x8022b78c
  if (i == log.lh.n)
80103670:	75 cd                	jne    8010363f <log_write+0x7f>
80103672:	31 c0                	xor    %eax,%eax
80103674:	eb c1                	jmp    80103637 <log_write+0x77>
    panic("too big a transaction");
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	68 53 7f 10 80       	push   $0x80107f53
8010367e:	e8 0d cd ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103683:	83 ec 0c             	sub    $0xc,%esp
80103686:	68 69 7f 10 80       	push   $0x80107f69
8010368b:	e8 00 cd ff ff       	call   80100390 <panic>

80103690 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	53                   	push   %ebx
80103694:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103697:	e8 74 09 00 00       	call   80104010 <cpuid>
8010369c:	89 c3                	mov    %eax,%ebx
8010369e:	e8 6d 09 00 00       	call   80104010 <cpuid>
801036a3:	83 ec 04             	sub    $0x4,%esp
801036a6:	53                   	push   %ebx
801036a7:	50                   	push   %eax
801036a8:	68 84 7f 10 80       	push   $0x80107f84
801036ad:	e8 ae cf ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
801036b2:	e8 39 2a 00 00       	call   801060f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801036b7:	e8 d4 08 00 00       	call   80103f90 <mycpu>
801036bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801036be:	b8 01 00 00 00       	mov    $0x1,%eax
801036c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801036ca:	e8 61 0c 00 00       	call   80104330 <scheduler>
801036cf:	90                   	nop

801036d0 <mpenter>:
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801036d6:	e8 25 3b 00 00       	call   80107200 <switchkvm>
  seginit();
801036db:	e8 b0 38 00 00       	call   80106f90 <seginit>
  lapicinit();
801036e0:	e8 9b f7 ff ff       	call   80102e80 <lapicinit>
  mpmain();
801036e5:	e8 a6 ff ff ff       	call   80103690 <mpmain>
801036ea:	66 90                	xchg   %ax,%ax
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <main>:
{ // origin 1024*1024*4, PHYSTOP
801036f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801036f4:	83 e4 f0             	and    $0xfffffff0,%esp
801036f7:	ff 71 fc             	pushl  -0x4(%ecx)
801036fa:	55                   	push   %ebp
801036fb:	89 e5                	mov    %esp,%ebp
801036fd:	53                   	push   %ebx
801036fe:	51                   	push   %ecx
  kinit1(end, P2V(1024*1024*4)); // phys page allocator
801036ff:	83 ec 08             	sub    $0x8,%esp
80103702:	68 00 00 40 80       	push   $0x80400000
80103707:	68 68 e5 22 80       	push   $0x8022e568
8010370c:	e8 bf ee ff ff       	call   801025d0 <kinit1>
  kvmalloc();      // kernel page table
80103711:	e8 2a 40 00 00       	call   80107740 <kvmalloc>
  mpinit();        // detect other processors
80103716:	e8 75 01 00 00       	call   80103890 <mpinit>
  lapicinit();     // interrupt controller
8010371b:	e8 60 f7 ff ff       	call   80102e80 <lapicinit>
  seginit();       // segment descriptors
80103720:	e8 6b 38 00 00       	call   80106f90 <seginit>
  picinit();       // disable pic
80103725:	e8 46 03 00 00       	call   80103a70 <picinit>
  ioapicinit();    // another interrupt controller
8010372a:	e8 c1 ec ff ff       	call   801023f0 <ioapicinit>
  consoleinit();   // console hardware
8010372f:	e8 8c d2 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103734:	e8 d7 2c 00 00       	call   80106410 <uartinit>
  pinit();         // process table
80103739:	e8 32 08 00 00       	call   80103f70 <pinit>
  tvinit();        // trap vectors
8010373e:	e8 2d 29 00 00       	call   80106070 <tvinit>
  binit();         // buffer cache
80103743:	e8 f8 c8 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103748:	e8 13 d6 ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010374d:	e8 7e ea ff ff       	call   801021d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103752:	83 c4 0c             	add    $0xc,%esp
80103755:	68 8a 00 00 00       	push   $0x8a
8010375a:	68 8c b4 10 80       	push   $0x8010b48c
8010375f:	68 00 70 00 80       	push   $0x80007000
80103764:	e8 67 16 00 00       	call   80104dd0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103769:	69 05 c0 bd 22 80 b0 	imul   $0xb0,0x8022bdc0,%eax
80103770:	00 00 00 
80103773:	83 c4 10             	add    $0x10,%esp
80103776:	05 40 b8 22 80       	add    $0x8022b840,%eax
8010377b:	3d 40 b8 22 80       	cmp    $0x8022b840,%eax
80103780:	76 71                	jbe    801037f3 <main+0x103>
80103782:	bb 40 b8 22 80       	mov    $0x8022b840,%ebx
80103787:	89 f6                	mov    %esi,%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103790:	e8 fb 07 00 00       	call   80103f90 <mycpu>
80103795:	39 d8                	cmp    %ebx,%eax
80103797:	74 41                	je     801037da <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103799:	e8 c2 f0 ff ff       	call   80102860 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010379e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
801037a3:	c7 05 f8 6f 00 80 d0 	movl   $0x801036d0,0x80006ff8
801037aa:	36 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801037ad:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801037b4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801037b7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801037bc:	0f b6 03             	movzbl (%ebx),%eax
801037bf:	83 ec 08             	sub    $0x8,%esp
801037c2:	68 00 70 00 00       	push   $0x7000
801037c7:	50                   	push   %eax
801037c8:	e8 03 f8 ff ff       	call   80102fd0 <lapicstartap>
801037cd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801037d0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801037d6:	85 c0                	test   %eax,%eax
801037d8:	74 f6                	je     801037d0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801037da:	69 05 c0 bd 22 80 b0 	imul   $0xb0,0x8022bdc0,%eax
801037e1:	00 00 00 
801037e4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801037ea:	05 40 b8 22 80       	add    $0x8022b840,%eax
801037ef:	39 c3                	cmp    %eax,%ebx
801037f1:	72 9d                	jb     80103790 <main+0xa0>
  kinit2(P2V(1024*1024*4), P2V(PHYSTOP)); // must come after startothers()
801037f3:	83 ec 08             	sub    $0x8,%esp
801037f6:	68 00 00 00 8e       	push   $0x8e000000
801037fb:	68 00 00 40 80       	push   $0x80400000
80103800:	e8 3b ee ff ff       	call   80102640 <kinit2>
  userinit();      // first user process
80103805:	e8 56 08 00 00       	call   80104060 <userinit>
  mpmain();        // finish this processor's setup
8010380a:	e8 81 fe ff ff       	call   80103690 <mpmain>
8010380f:	90                   	nop

80103810 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	57                   	push   %edi
80103814:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103815:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010381b:	53                   	push   %ebx
  e = addr+len;
8010381c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010381f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103822:	39 de                	cmp    %ebx,%esi
80103824:	72 10                	jb     80103836 <mpsearch1+0x26>
80103826:	eb 50                	jmp    80103878 <mpsearch1+0x68>
80103828:	90                   	nop
80103829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103830:	39 fb                	cmp    %edi,%ebx
80103832:	89 fe                	mov    %edi,%esi
80103834:	76 42                	jbe    80103878 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103836:	83 ec 04             	sub    $0x4,%esp
80103839:	8d 7e 10             	lea    0x10(%esi),%edi
8010383c:	6a 04                	push   $0x4
8010383e:	68 98 7f 10 80       	push   $0x80107f98
80103843:	56                   	push   %esi
80103844:	e8 27 15 00 00       	call   80104d70 <memcmp>
80103849:	83 c4 10             	add    $0x10,%esp
8010384c:	85 c0                	test   %eax,%eax
8010384e:	75 e0                	jne    80103830 <mpsearch1+0x20>
80103850:	89 f1                	mov    %esi,%ecx
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103858:	0f b6 11             	movzbl (%ecx),%edx
8010385b:	83 c1 01             	add    $0x1,%ecx
8010385e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103860:	39 f9                	cmp    %edi,%ecx
80103862:	75 f4                	jne    80103858 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103864:	84 c0                	test   %al,%al
80103866:	75 c8                	jne    80103830 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103868:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010386b:	89 f0                	mov    %esi,%eax
8010386d:	5b                   	pop    %ebx
8010386e:	5e                   	pop    %esi
8010386f:	5f                   	pop    %edi
80103870:	5d                   	pop    %ebp
80103871:	c3                   	ret    
80103872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103878:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010387b:	31 f6                	xor    %esi,%esi
}
8010387d:	89 f0                	mov    %esi,%eax
8010387f:	5b                   	pop    %ebx
80103880:	5e                   	pop    %esi
80103881:	5f                   	pop    %edi
80103882:	5d                   	pop    %ebp
80103883:	c3                   	ret    
80103884:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010388a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103890 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103899:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801038a0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801038a7:	c1 e0 08             	shl    $0x8,%eax
801038aa:	09 d0                	or     %edx,%eax
801038ac:	c1 e0 04             	shl    $0x4,%eax
801038af:	85 c0                	test   %eax,%eax
801038b1:	75 1b                	jne    801038ce <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801038b3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801038ba:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801038c1:	c1 e0 08             	shl    $0x8,%eax
801038c4:	09 d0                	or     %edx,%eax
801038c6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801038c9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801038ce:	ba 00 04 00 00       	mov    $0x400,%edx
801038d3:	e8 38 ff ff ff       	call   80103810 <mpsearch1>
801038d8:	85 c0                	test   %eax,%eax
801038da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038dd:	0f 84 3d 01 00 00    	je     80103a20 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801038e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801038e6:	8b 58 04             	mov    0x4(%eax),%ebx
801038e9:	85 db                	test   %ebx,%ebx
801038eb:	0f 84 4f 01 00 00    	je     80103a40 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801038f1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801038f7:	83 ec 04             	sub    $0x4,%esp
801038fa:	6a 04                	push   $0x4
801038fc:	68 b5 7f 10 80       	push   $0x80107fb5
80103901:	56                   	push   %esi
80103902:	e8 69 14 00 00       	call   80104d70 <memcmp>
80103907:	83 c4 10             	add    $0x10,%esp
8010390a:	85 c0                	test   %eax,%eax
8010390c:	0f 85 2e 01 00 00    	jne    80103a40 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103912:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103919:	3c 01                	cmp    $0x1,%al
8010391b:	0f 95 c2             	setne  %dl
8010391e:	3c 04                	cmp    $0x4,%al
80103920:	0f 95 c0             	setne  %al
80103923:	20 c2                	and    %al,%dl
80103925:	0f 85 15 01 00 00    	jne    80103a40 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010392b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103932:	66 85 ff             	test   %di,%di
80103935:	74 1a                	je     80103951 <mpinit+0xc1>
80103937:	89 f0                	mov    %esi,%eax
80103939:	01 f7                	add    %esi,%edi
  sum = 0;
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103940:	0f b6 08             	movzbl (%eax),%ecx
80103943:	83 c0 01             	add    $0x1,%eax
80103946:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103948:	39 c7                	cmp    %eax,%edi
8010394a:	75 f4                	jne    80103940 <mpinit+0xb0>
8010394c:	84 d2                	test   %dl,%dl
8010394e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103951:	85 f6                	test   %esi,%esi
80103953:	0f 84 e7 00 00 00    	je     80103a40 <mpinit+0x1b0>
80103959:	84 d2                	test   %dl,%dl
8010395b:	0f 85 df 00 00 00    	jne    80103a40 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103961:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103967:	a3 20 b7 22 80       	mov    %eax,0x8022b720
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010396c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103973:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103979:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010397e:	01 d6                	add    %edx,%esi
80103980:	39 c6                	cmp    %eax,%esi
80103982:	76 23                	jbe    801039a7 <mpinit+0x117>
    switch(*p){
80103984:	0f b6 10             	movzbl (%eax),%edx
80103987:	80 fa 04             	cmp    $0x4,%dl
8010398a:	0f 87 ca 00 00 00    	ja     80103a5a <mpinit+0x1ca>
80103990:	ff 24 95 dc 7f 10 80 	jmp    *-0x7fef8024(,%edx,4)
80103997:	89 f6                	mov    %esi,%esi
80103999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039a0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039a3:	39 c6                	cmp    %eax,%esi
801039a5:	77 dd                	ja     80103984 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801039a7:	85 db                	test   %ebx,%ebx
801039a9:	0f 84 9e 00 00 00    	je     80103a4d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801039af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039b2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801039b6:	74 15                	je     801039cd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039b8:	b8 70 00 00 00       	mov    $0x70,%eax
801039bd:	ba 22 00 00 00       	mov    $0x22,%edx
801039c2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801039c3:	ba 23 00 00 00       	mov    $0x23,%edx
801039c8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801039c9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801039cc:	ee                   	out    %al,(%dx)
  }
}
801039cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d0:	5b                   	pop    %ebx
801039d1:	5e                   	pop    %esi
801039d2:	5f                   	pop    %edi
801039d3:	5d                   	pop    %ebp
801039d4:	c3                   	ret    
801039d5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801039d8:	8b 0d c0 bd 22 80    	mov    0x8022bdc0,%ecx
801039de:	83 f9 07             	cmp    $0x7,%ecx
801039e1:	7f 19                	jg     801039fc <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039e3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801039e7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801039ed:	83 c1 01             	add    $0x1,%ecx
801039f0:	89 0d c0 bd 22 80    	mov    %ecx,0x8022bdc0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801039f6:	88 97 40 b8 22 80    	mov    %dl,-0x7fdd47c0(%edi)
      p += sizeof(struct mpproc);
801039fc:	83 c0 14             	add    $0x14,%eax
      continue;
801039ff:	e9 7c ff ff ff       	jmp    80103980 <mpinit+0xf0>
80103a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103a08:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103a0c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103a0f:	88 15 20 b8 22 80    	mov    %dl,0x8022b820
      continue;
80103a15:	e9 66 ff ff ff       	jmp    80103980 <mpinit+0xf0>
80103a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103a20:	ba 00 00 01 00       	mov    $0x10000,%edx
80103a25:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103a2a:	e8 e1 fd ff ff       	call   80103810 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a2f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103a34:	0f 85 a9 fe ff ff    	jne    801038e3 <mpinit+0x53>
80103a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103a40:	83 ec 0c             	sub    $0xc,%esp
80103a43:	68 9d 7f 10 80       	push   $0x80107f9d
80103a48:	e8 43 c9 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 bc 7f 10 80       	push   $0x80107fbc
80103a55:	e8 36 c9 ff ff       	call   80100390 <panic>
      ismp = 0;
80103a5a:	31 db                	xor    %ebx,%ebx
80103a5c:	e9 26 ff ff ff       	jmp    80103987 <mpinit+0xf7>
80103a61:	66 90                	xchg   %ax,%ax
80103a63:	66 90                	xchg   %ax,%ax
80103a65:	66 90                	xchg   %ax,%ax
80103a67:	66 90                	xchg   %ax,%ax
80103a69:	66 90                	xchg   %ax,%ax
80103a6b:	66 90                	xchg   %ax,%ax
80103a6d:	66 90                	xchg   %ax,%ax
80103a6f:	90                   	nop

80103a70 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103a70:	55                   	push   %ebp
80103a71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a76:	ba 21 00 00 00       	mov    $0x21,%edx
80103a7b:	89 e5                	mov    %esp,%ebp
80103a7d:	ee                   	out    %al,(%dx)
80103a7e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103a83:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103a84:	5d                   	pop    %ebp
80103a85:	c3                   	ret    
80103a86:	66 90                	xchg   %ax,%ax
80103a88:	66 90                	xchg   %ax,%ax
80103a8a:	66 90                	xchg   %ax,%ax
80103a8c:	66 90                	xchg   %ax,%ax
80103a8e:	66 90                	xchg   %ax,%ax

80103a90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	57                   	push   %edi
80103a94:	56                   	push   %esi
80103a95:	53                   	push   %ebx
80103a96:	83 ec 0c             	sub    $0xc,%esp
80103a99:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103a9f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103aa5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103aab:	e8 d0 d2 ff ff       	call   80100d80 <filealloc>
80103ab0:	85 c0                	test   %eax,%eax
80103ab2:	89 03                	mov    %eax,(%ebx)
80103ab4:	74 22                	je     80103ad8 <pipealloc+0x48>
80103ab6:	e8 c5 d2 ff ff       	call   80100d80 <filealloc>
80103abb:	85 c0                	test   %eax,%eax
80103abd:	89 06                	mov    %eax,(%esi)
80103abf:	74 3f                	je     80103b00 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ac1:	e8 9a ed ff ff       	call   80102860 <kalloc>
80103ac6:	85 c0                	test   %eax,%eax
80103ac8:	89 c7                	mov    %eax,%edi
80103aca:	75 54                	jne    80103b20 <pipealloc+0x90>
  return 0;

 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103acc:	8b 03                	mov    (%ebx),%eax
80103ace:	85 c0                	test   %eax,%eax
80103ad0:	75 34                	jne    80103b06 <pipealloc+0x76>
80103ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103ad8:	8b 06                	mov    (%esi),%eax
80103ada:	85 c0                	test   %eax,%eax
80103adc:	74 0c                	je     80103aea <pipealloc+0x5a>
    fileclose(*f1);
80103ade:	83 ec 0c             	sub    $0xc,%esp
80103ae1:	50                   	push   %eax
80103ae2:	e8 59 d3 ff ff       	call   80100e40 <fileclose>
80103ae7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103aea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103aed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103af2:	5b                   	pop    %ebx
80103af3:	5e                   	pop    %esi
80103af4:	5f                   	pop    %edi
80103af5:	5d                   	pop    %ebp
80103af6:	c3                   	ret    
80103af7:	89 f6                	mov    %esi,%esi
80103af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103b00:	8b 03                	mov    (%ebx),%eax
80103b02:	85 c0                	test   %eax,%eax
80103b04:	74 e4                	je     80103aea <pipealloc+0x5a>
    fileclose(*f0);
80103b06:	83 ec 0c             	sub    $0xc,%esp
80103b09:	50                   	push   %eax
80103b0a:	e8 31 d3 ff ff       	call   80100e40 <fileclose>
  if(*f1)
80103b0f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103b11:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103b14:	85 c0                	test   %eax,%eax
80103b16:	75 c6                	jne    80103ade <pipealloc+0x4e>
80103b18:	eb d0                	jmp    80103aea <pipealloc+0x5a>
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103b20:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103b23:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103b2a:	00 00 00 
  p->writeopen = 1;
80103b2d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103b34:	00 00 00 
  p->nwrite = 0;
80103b37:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103b3e:	00 00 00 
  p->nread = 0;
80103b41:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103b48:	00 00 00 
  initlock(&p->lock, "pipe");
80103b4b:	68 f0 7f 10 80       	push   $0x80107ff0
80103b50:	50                   	push   %eax
80103b51:	e8 6a 0f 00 00       	call   80104ac0 <initlock>
  (*f0)->type = FD_PIPE;
80103b56:	8b 03                	mov    (%ebx),%eax
  return 0;
80103b58:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103b5b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103b61:	8b 03                	mov    (%ebx),%eax
80103b63:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103b67:	8b 03                	mov    (%ebx),%eax
80103b69:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103b6d:	8b 03                	mov    (%ebx),%eax
80103b6f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103b72:	8b 06                	mov    (%esi),%eax
80103b74:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103b7a:	8b 06                	mov    (%esi),%eax
80103b7c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103b80:	8b 06                	mov    (%esi),%eax
80103b82:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103b86:	8b 06                	mov    (%esi),%eax
80103b88:	89 78 0c             	mov    %edi,0xc(%eax)
}
80103b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103b8e:	31 c0                	xor    %eax,%eax
}
80103b90:	5b                   	pop    %ebx
80103b91:	5e                   	pop    %esi
80103b92:	5f                   	pop    %edi
80103b93:	5d                   	pop    %ebp
80103b94:	c3                   	ret    
80103b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ba0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
80103ba5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103bab:	83 ec 0c             	sub    $0xc,%esp
80103bae:	53                   	push   %ebx
80103baf:	e8 4c 10 00 00       	call   80104c00 <acquire>
  if(writable){
80103bb4:	83 c4 10             	add    $0x10,%esp
80103bb7:	85 f6                	test   %esi,%esi
80103bb9:	74 45                	je     80103c00 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103bbb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103bc1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103bc4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103bcb:	00 00 00 
    wakeup(&p->nread);
80103bce:	50                   	push   %eax
80103bcf:	e8 ec 0b 00 00       	call   801047c0 <wakeup>
80103bd4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103bd7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103bdd:	85 d2                	test   %edx,%edx
80103bdf:	75 0a                	jne    80103beb <pipeclose+0x4b>
80103be1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103be7:	85 c0                	test   %eax,%eax
80103be9:	74 35                	je     80103c20 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103beb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103bee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf1:	5b                   	pop    %ebx
80103bf2:	5e                   	pop    %esi
80103bf3:	5d                   	pop    %ebp
    release(&p->lock);
80103bf4:	e9 c7 10 00 00       	jmp    80104cc0 <release>
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103c00:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103c06:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103c09:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103c10:	00 00 00 
    wakeup(&p->nwrite);
80103c13:	50                   	push   %eax
80103c14:	e8 a7 0b 00 00       	call   801047c0 <wakeup>
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	eb b9                	jmp    80103bd7 <pipeclose+0x37>
80103c1e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103c20:	83 ec 0c             	sub    $0xc,%esp
80103c23:	53                   	push   %ebx
80103c24:	e8 97 10 00 00       	call   80104cc0 <release>
    kfree((char*)p);
80103c29:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103c2c:	83 c4 10             	add    $0x10,%esp
}
80103c2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c32:	5b                   	pop    %ebx
80103c33:	5e                   	pop    %esi
80103c34:	5d                   	pop    %ebp
    kfree((char*)p);
80103c35:	e9 a6 e8 ff ff       	jmp    801024e0 <kfree>
80103c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c40 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	57                   	push   %edi
80103c44:	56                   	push   %esi
80103c45:	53                   	push   %ebx
80103c46:	83 ec 28             	sub    $0x28,%esp
80103c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103c4c:	53                   	push   %ebx
80103c4d:	e8 ae 0f 00 00       	call   80104c00 <acquire>
  for(i = 0; i < n; i++){
80103c52:	8b 45 10             	mov    0x10(%ebp),%eax
80103c55:	83 c4 10             	add    $0x10,%esp
80103c58:	85 c0                	test   %eax,%eax
80103c5a:	0f 8e c9 00 00 00    	jle    80103d29 <pipewrite+0xe9>
80103c60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103c63:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103c69:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103c6f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103c72:	03 4d 10             	add    0x10(%ebp),%ecx
80103c75:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103c78:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103c7e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103c84:	39 d0                	cmp    %edx,%eax
80103c86:	75 71                	jne    80103cf9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103c88:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103c8e:	85 c0                	test   %eax,%eax
80103c90:	74 4e                	je     80103ce0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103c92:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103c98:	eb 3a                	jmp    80103cd4 <pipewrite+0x94>
80103c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103ca0:	83 ec 0c             	sub    $0xc,%esp
80103ca3:	57                   	push   %edi
80103ca4:	e8 17 0b 00 00       	call   801047c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103ca9:	5a                   	pop    %edx
80103caa:	59                   	pop    %ecx
80103cab:	53                   	push   %ebx
80103cac:	56                   	push   %esi
80103cad:	e8 5e 09 00 00       	call   80104610 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cb2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103cb8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103cbe:	83 c4 10             	add    $0x10,%esp
80103cc1:	05 00 02 00 00       	add    $0x200,%eax
80103cc6:	39 c2                	cmp    %eax,%edx
80103cc8:	75 36                	jne    80103d00 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
80103cca:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103cd0:	85 c0                	test   %eax,%eax
80103cd2:	74 0c                	je     80103ce0 <pipewrite+0xa0>
80103cd4:	e8 57 03 00 00       	call   80104030 <myproc>
80103cd9:	8b 40 24             	mov    0x24(%eax),%eax
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	74 c0                	je     80103ca0 <pipewrite+0x60>
        release(&p->lock);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
80103ce3:	53                   	push   %ebx
80103ce4:	e8 d7 0f 00 00       	call   80104cc0 <release>
        return -1;
80103ce9:	83 c4 10             	add    $0x10,%esp
80103cec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cf4:	5b                   	pop    %ebx
80103cf5:	5e                   	pop    %esi
80103cf6:	5f                   	pop    %edi
80103cf7:	5d                   	pop    %ebp
80103cf8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103cf9:	89 c2                	mov    %eax,%edx
80103cfb:	90                   	nop
80103cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d00:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103d03:	8d 42 01             	lea    0x1(%edx),%eax
80103d06:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103d0c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103d12:	83 c6 01             	add    $0x1,%esi
80103d15:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103d19:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80103d1c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103d1f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103d23:	0f 85 4f ff ff ff    	jne    80103c78 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103d29:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103d2f:	83 ec 0c             	sub    $0xc,%esp
80103d32:	50                   	push   %eax
80103d33:	e8 88 0a 00 00       	call   801047c0 <wakeup>
  release(&p->lock);
80103d38:	89 1c 24             	mov    %ebx,(%esp)
80103d3b:	e8 80 0f 00 00       	call   80104cc0 <release>
  return n;
80103d40:	83 c4 10             	add    $0x10,%esp
80103d43:	8b 45 10             	mov    0x10(%ebp),%eax
80103d46:	eb a9                	jmp    80103cf1 <pipewrite+0xb1>
80103d48:	90                   	nop
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d50 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 18             	sub    $0x18,%esp
80103d59:	8b 75 08             	mov    0x8(%ebp),%esi
80103d5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103d5f:	56                   	push   %esi
80103d60:	e8 9b 0e 00 00       	call   80104c00 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d65:	83 c4 10             	add    $0x10,%esp
80103d68:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103d6e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103d74:	75 6a                	jne    80103de0 <piperead+0x90>
80103d76:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
80103d7c:	85 db                	test   %ebx,%ebx
80103d7e:	0f 84 c4 00 00 00    	je     80103e48 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103d84:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103d8a:	eb 2d                	jmp    80103db9 <piperead+0x69>
80103d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d90:	83 ec 08             	sub    $0x8,%esp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
80103d95:	e8 76 08 00 00       	call   80104610 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103d9a:	83 c4 10             	add    $0x10,%esp
80103d9d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103da3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103da9:	75 35                	jne    80103de0 <piperead+0x90>
80103dab:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103db1:	85 d2                	test   %edx,%edx
80103db3:	0f 84 8f 00 00 00    	je     80103e48 <piperead+0xf8>
    if(myproc()->killed){
80103db9:	e8 72 02 00 00       	call   80104030 <myproc>
80103dbe:	8b 48 24             	mov    0x24(%eax),%ecx
80103dc1:	85 c9                	test   %ecx,%ecx
80103dc3:	74 cb                	je     80103d90 <piperead+0x40>
      release(&p->lock);
80103dc5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103dc8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103dcd:	56                   	push   %esi
80103dce:	e8 ed 0e 00 00       	call   80104cc0 <release>
      return -1;
80103dd3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dd9:	89 d8                	mov    %ebx,%eax
80103ddb:	5b                   	pop    %ebx
80103ddc:	5e                   	pop    %esi
80103ddd:	5f                   	pop    %edi
80103dde:	5d                   	pop    %ebp
80103ddf:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103de0:	8b 45 10             	mov    0x10(%ebp),%eax
80103de3:	85 c0                	test   %eax,%eax
80103de5:	7e 61                	jle    80103e48 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103de7:	31 db                	xor    %ebx,%ebx
80103de9:	eb 13                	jmp    80103dfe <piperead+0xae>
80103deb:	90                   	nop
80103dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103df6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103dfc:	74 1f                	je     80103e1d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103dfe:	8d 41 01             	lea    0x1(%ecx),%eax
80103e01:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103e07:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103e0d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103e12:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103e15:	83 c3 01             	add    $0x1,%ebx
80103e18:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103e1b:	75 d3                	jne    80103df0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103e1d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103e23:	83 ec 0c             	sub    $0xc,%esp
80103e26:	50                   	push   %eax
80103e27:	e8 94 09 00 00       	call   801047c0 <wakeup>
  release(&p->lock);
80103e2c:	89 34 24             	mov    %esi,(%esp)
80103e2f:	e8 8c 0e 00 00       	call   80104cc0 <release>
  return i;
80103e34:	83 c4 10             	add    $0x10,%esp
}
80103e37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e3a:	89 d8                	mov    %ebx,%eax
80103e3c:	5b                   	pop    %ebx
80103e3d:	5e                   	pop    %esi
80103e3e:	5f                   	pop    %edi
80103e3f:	5d                   	pop    %ebp
80103e40:	c3                   	ret    
80103e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e48:	31 db                	xor    %ebx,%ebx
80103e4a:	eb d1                	jmp    80103e1d <piperead+0xcd>
80103e4c:	66 90                	xchg   %ax,%ax
80103e4e:	66 90                	xchg   %ax,%ax

80103e50 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e54:	bb 14 be 22 80       	mov    $0x8022be14,%ebx
{
80103e59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103e5c:	68 e0 bd 22 80       	push   $0x8022bde0
80103e61:	e8 9a 0d 00 00       	call   80104c00 <acquire>
80103e66:	83 c4 10             	add    $0x10,%esp
80103e69:	eb 10                	jmp    80103e7b <allocproc+0x2b>
80103e6b:	90                   	nop
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e70:	83 c3 7c             	add    $0x7c,%ebx
80103e73:	81 fb 14 dd 22 80    	cmp    $0x8022dd14,%ebx
80103e79:	73 75                	jae    80103ef0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103e7b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103e7e:	85 c0                	test   %eax,%eax
80103e80:	75 ee                	jne    80103e70 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103e82:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103e87:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103e8a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103e91:	8d 50 01             	lea    0x1(%eax),%edx
80103e94:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103e97:	68 e0 bd 22 80       	push   $0x8022bde0
  p->pid = nextpid++;
80103e9c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103ea2:	e8 19 0e 00 00       	call   80104cc0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103ea7:	e8 b4 e9 ff ff       	call   80102860 <kalloc>
80103eac:	83 c4 10             	add    $0x10,%esp
80103eaf:	85 c0                	test   %eax,%eax
80103eb1:	89 43 08             	mov    %eax,0x8(%ebx)
80103eb4:	74 53                	je     80103f09 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103eb6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103ebc:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103ebf:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ec4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ec7:	c7 40 14 32 60 10 80 	movl   $0x80106032,0x14(%eax)
  p->context = (struct context*)sp;
80103ece:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ed1:	6a 14                	push   $0x14
80103ed3:	6a 00                	push   $0x0
80103ed5:	50                   	push   %eax
80103ed6:	e8 45 0e 00 00       	call   80104d20 <memset>
  p->context->eip = (uint)forkret;
80103edb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103ede:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103ee1:	c7 40 10 20 3f 10 80 	movl   $0x80103f20,0x10(%eax)
}
80103ee8:	89 d8                	mov    %ebx,%eax
80103eea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103eed:	c9                   	leave  
80103eee:	c3                   	ret    
80103eef:	90                   	nop
  release(&ptable.lock);
80103ef0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103ef3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103ef5:	68 e0 bd 22 80       	push   $0x8022bde0
80103efa:	e8 c1 0d 00 00       	call   80104cc0 <release>
}
80103eff:	89 d8                	mov    %ebx,%eax
  return 0;
80103f01:	83 c4 10             	add    $0x10,%esp
}
80103f04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f07:	c9                   	leave  
80103f08:	c3                   	ret    
    p->state = UNUSED;
80103f09:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103f10:	31 db                	xor    %ebx,%ebx
80103f12:	eb d4                	jmp    80103ee8 <allocproc+0x98>
80103f14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103f1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103f20 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103f26:	68 e0 bd 22 80       	push   $0x8022bde0
80103f2b:	e8 90 0d 00 00       	call   80104cc0 <release>

  if (first) {
80103f30:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103f35:	83 c4 10             	add    $0x10,%esp
80103f38:	85 c0                	test   %eax,%eax
80103f3a:	75 04                	jne    80103f40 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103f3c:	c9                   	leave  
80103f3d:	c3                   	ret    
80103f3e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103f40:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103f43:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103f4a:	00 00 00 
    iinit(ROOTDEV);
80103f4d:	6a 01                	push   $0x1
80103f4f:	e8 3c d5 ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103f54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103f5b:	e8 f0 f3 ff ff       	call   80103350 <initlog>
80103f60:	83 c4 10             	add    $0x10,%esp
}
80103f63:	c9                   	leave  
80103f64:	c3                   	ret    
80103f65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f70 <pinit>:
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103f76:	68 f5 7f 10 80       	push   $0x80107ff5
80103f7b:	68 e0 bd 22 80       	push   $0x8022bde0
80103f80:	e8 3b 0b 00 00       	call   80104ac0 <initlock>
}
80103f85:	83 c4 10             	add    $0x10,%esp
80103f88:	c9                   	leave  
80103f89:	c3                   	ret    
80103f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f90 <mycpu>:
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	56                   	push   %esi
80103f94:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f95:	9c                   	pushf  
80103f96:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f97:	f6 c4 02             	test   $0x2,%ah
80103f9a:	75 5e                	jne    80103ffa <mycpu+0x6a>
  apicid = lapicid();
80103f9c:	e8 df ef ff ff       	call   80102f80 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103fa1:	8b 35 c0 bd 22 80    	mov    0x8022bdc0,%esi
80103fa7:	85 f6                	test   %esi,%esi
80103fa9:	7e 42                	jle    80103fed <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103fab:	0f b6 15 40 b8 22 80 	movzbl 0x8022b840,%edx
80103fb2:	39 d0                	cmp    %edx,%eax
80103fb4:	74 30                	je     80103fe6 <mycpu+0x56>
80103fb6:	b9 f0 b8 22 80       	mov    $0x8022b8f0,%ecx
  for (i = 0; i < ncpu; ++i) {
80103fbb:	31 d2                	xor    %edx,%edx
80103fbd:	8d 76 00             	lea    0x0(%esi),%esi
80103fc0:	83 c2 01             	add    $0x1,%edx
80103fc3:	39 f2                	cmp    %esi,%edx
80103fc5:	74 26                	je     80103fed <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103fc7:	0f b6 19             	movzbl (%ecx),%ebx
80103fca:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103fd0:	39 c3                	cmp    %eax,%ebx
80103fd2:	75 ec                	jne    80103fc0 <mycpu+0x30>
80103fd4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103fda:	05 40 b8 22 80       	add    $0x8022b840,%eax
}
80103fdf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fe2:	5b                   	pop    %ebx
80103fe3:	5e                   	pop    %esi
80103fe4:	5d                   	pop    %ebp
80103fe5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103fe6:	b8 40 b8 22 80       	mov    $0x8022b840,%eax
      return &cpus[i];
80103feb:	eb f2                	jmp    80103fdf <mycpu+0x4f>
  panic("unknown apicid\n");
80103fed:	83 ec 0c             	sub    $0xc,%esp
80103ff0:	68 fc 7f 10 80       	push   $0x80107ffc
80103ff5:	e8 96 c3 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 e4 80 10 80       	push   $0x801080e4
80104002:	e8 89 c3 ff ff       	call   80100390 <panic>
80104007:	89 f6                	mov    %esi,%esi
80104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104010 <cpuid>:
cpuid() {
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80104016:	e8 75 ff ff ff       	call   80103f90 <mycpu>
8010401b:	2d 40 b8 22 80       	sub    $0x8022b840,%eax
}
80104020:	c9                   	leave  
  return mycpu()-cpus;
80104021:	c1 f8 04             	sar    $0x4,%eax
80104024:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010402a:	c3                   	ret    
8010402b:	90                   	nop
8010402c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104030 <myproc>:
myproc(void) {
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	53                   	push   %ebx
80104034:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80104037:	e8 f4 0a 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010403c:	e8 4f ff ff ff       	call   80103f90 <mycpu>
  p = c->proc;
80104041:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104047:	e8 24 0b 00 00       	call   80104b70 <popcli>
}
8010404c:	83 c4 04             	add    $0x4,%esp
8010404f:	89 d8                	mov    %ebx,%eax
80104051:	5b                   	pop    %ebx
80104052:	5d                   	pop    %ebp
80104053:	c3                   	ret    
80104054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010405a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104060 <userinit>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80104067:	e8 e4 fd ff ff       	call   80103e50 <allocproc>
8010406c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010406e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80104073:	e8 48 36 00 00       	call   801076c0 <setupkvm>
80104078:	85 c0                	test   %eax,%eax
8010407a:	89 43 04             	mov    %eax,0x4(%ebx)
8010407d:	0f 84 f8 00 00 00    	je     8010417b <userinit+0x11b>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80104083:	83 ec 04             	sub    $0x4,%esp
80104086:	68 2c 00 00 00       	push   $0x2c
8010408b:	68 60 b4 10 80       	push   $0x8010b460
80104090:	68 25 80 10 80       	push   $0x80108025
80104095:	e8 c6 c5 ff ff       	call   80100660 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010409a:	83 c4 0c             	add    $0xc,%esp
8010409d:	68 2c 00 00 00       	push   $0x2c
801040a2:	68 60 b4 10 80       	push   $0x8010b460
801040a7:	ff 73 04             	pushl  0x4(%ebx)
801040aa:	e8 81 32 00 00       	call   80107330 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801040af:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801040b2:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801040b8:	6a 4c                	push   $0x4c
801040ba:	6a 00                	push   $0x0
801040bc:	ff 73 18             	pushl  0x18(%ebx)
801040bf:	e8 5c 0c 00 00       	call   80104d20 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040c4:	8b 43 18             	mov    0x18(%ebx),%eax
801040c7:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040cc:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
801040d1:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801040d4:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801040d8:	8b 43 18             	mov    0x18(%ebx),%eax
801040db:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801040df:	8b 43 18             	mov    0x18(%ebx),%eax
801040e2:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040e6:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801040ea:	8b 43 18             	mov    0x18(%ebx),%eax
801040ed:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801040f1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801040f5:	8b 43 18             	mov    0x18(%ebx),%eax
801040f8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801040ff:	8b 43 18             	mov    0x18(%ebx),%eax
80104102:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104109:	8b 43 18             	mov    0x18(%ebx),%eax
8010410c:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104113:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104116:	6a 10                	push   $0x10
80104118:	68 2c 80 10 80       	push   $0x8010802c
8010411d:	50                   	push   %eax
8010411e:	e8 dd 0d 00 00       	call   80104f00 <safestrcpy>
  p->cwd = namei("/");
80104123:	c7 04 24 35 80 10 80 	movl   $0x80108035,(%esp)
8010412a:	e8 c1 dd ff ff       	call   80101ef0 <namei>
8010412f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80104132:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
80104139:	e8 c2 0a 00 00       	call   80104c00 <acquire>
  initlock(&pagelock,"page");
8010413e:	58                   	pop    %eax
8010413f:	5a                   	pop    %edx
80104140:	68 36 84 10 80       	push   $0x80108436
80104145:	68 a0 36 11 80       	push   $0x801136a0
8010414a:	e8 71 09 00 00       	call   80104ac0 <initlock>
  initlock(&lrulock,"lru");
8010414f:	59                   	pop    %ecx
80104150:	58                   	pop    %eax
80104151:	68 37 80 10 80       	push   $0x80108037
80104156:	68 e0 b6 14 80       	push   $0x8014b6e0
8010415b:	e8 60 09 00 00       	call   80104ac0 <initlock>
  p->state = RUNNABLE;
80104160:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104167:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
8010416e:	e8 4d 0b 00 00       	call   80104cc0 <release>
}
80104173:	83 c4 10             	add    $0x10,%esp
80104176:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104179:	c9                   	leave  
8010417a:	c3                   	ret    
    panic("userinit: out of memory?");
8010417b:	83 ec 0c             	sub    $0xc,%esp
8010417e:	68 0c 80 10 80       	push   $0x8010800c
80104183:	e8 08 c2 ff ff       	call   80100390 <panic>
80104188:	90                   	nop
80104189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104190 <growproc>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
80104195:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80104198:	e8 93 09 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010419d:	e8 ee fd ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801041a2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041a8:	e8 c3 09 00 00       	call   80104b70 <popcli>
  if(n > 0){
801041ad:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801041b0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801041b2:	7f 1c                	jg     801041d0 <growproc+0x40>
  } else if(n < 0){
801041b4:	75 3a                	jne    801041f0 <growproc+0x60>
  switchuvm(curproc);
801041b6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801041b9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801041bb:	53                   	push   %ebx
801041bc:	e8 5f 30 00 00       	call   80107220 <switchuvm>
  return 0;
801041c1:	83 c4 10             	add    $0x10,%esp
801041c4:	31 c0                	xor    %eax,%eax
}
801041c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041c9:	5b                   	pop    %ebx
801041ca:	5e                   	pop    %esi
801041cb:	5d                   	pop    %ebp
801041cc:	c3                   	ret    
801041cd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041d0:	83 ec 04             	sub    $0x4,%esp
801041d3:	01 c6                	add    %eax,%esi
801041d5:	56                   	push   %esi
801041d6:	50                   	push   %eax
801041d7:	ff 73 04             	pushl  0x4(%ebx)
801041da:	e8 d1 32 00 00       	call   801074b0 <allocuvm>
801041df:	83 c4 10             	add    $0x10,%esp
801041e2:	85 c0                	test   %eax,%eax
801041e4:	75 d0                	jne    801041b6 <growproc+0x26>
      return -1;
801041e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801041eb:	eb d9                	jmp    801041c6 <growproc+0x36>
801041ed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801041f0:	83 ec 04             	sub    $0x4,%esp
801041f3:	01 c6                	add    %eax,%esi
801041f5:	56                   	push   %esi
801041f6:	50                   	push   %eax
801041f7:	ff 73 04             	pushl  0x4(%ebx)
801041fa:	e8 11 34 00 00       	call   80107610 <deallocuvm>
801041ff:	83 c4 10             	add    $0x10,%esp
80104202:	85 c0                	test   %eax,%eax
80104204:	75 b0                	jne    801041b6 <growproc+0x26>
80104206:	eb de                	jmp    801041e6 <growproc+0x56>
80104208:	90                   	nop
80104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104210 <fork>:
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	57                   	push   %edi
80104214:	56                   	push   %esi
80104215:	53                   	push   %ebx
80104216:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80104219:	e8 12 09 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010421e:	e8 6d fd ff ff       	call   80103f90 <mycpu>
  p = c->proc;
80104223:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104229:	e8 42 09 00 00       	call   80104b70 <popcli>
  if((np = allocproc()) == 0){
8010422e:	e8 1d fc ff ff       	call   80103e50 <allocproc>
80104233:	85 c0                	test   %eax,%eax
80104235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104238:	0f 84 b7 00 00 00    	je     801042f5 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
8010423e:	83 ec 08             	sub    $0x8,%esp
80104241:	ff 33                	pushl  (%ebx)
80104243:	ff 73 04             	pushl  0x4(%ebx)
80104246:	89 c7                	mov    %eax,%edi
80104248:	e8 43 35 00 00       	call   80107790 <copyuvm>
8010424d:	83 c4 10             	add    $0x10,%esp
80104250:	85 c0                	test   %eax,%eax
80104252:	89 47 04             	mov    %eax,0x4(%edi)
80104255:	0f 84 a1 00 00 00    	je     801042fc <fork+0xec>
  np->sz = curproc->sz;
8010425b:	8b 03                	mov    (%ebx),%eax
8010425d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104260:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80104262:	89 59 14             	mov    %ebx,0x14(%ecx)
80104265:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80104267:	8b 79 18             	mov    0x18(%ecx),%edi
8010426a:	8b 73 18             	mov    0x18(%ebx),%esi
8010426d:	b9 13 00 00 00       	mov    $0x13,%ecx
80104272:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104274:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80104276:	8b 40 18             	mov    0x18(%eax),%eax
80104279:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80104280:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104284:	85 c0                	test   %eax,%eax
80104286:	74 13                	je     8010429b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104288:	83 ec 0c             	sub    $0xc,%esp
8010428b:	50                   	push   %eax
8010428c:	e8 5f cb ff ff       	call   80100df0 <filedup>
80104291:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104294:	83 c4 10             	add    $0x10,%esp
80104297:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010429b:	83 c6 01             	add    $0x1,%esi
8010429e:	83 fe 10             	cmp    $0x10,%esi
801042a1:	75 dd                	jne    80104280 <fork+0x70>
  np->cwd = idup(curproc->cwd);
801042a3:	83 ec 0c             	sub    $0xc,%esp
801042a6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042a9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
801042ac:	e8 af d3 ff ff       	call   80101660 <idup>
801042b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042b4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
801042b7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801042ba:	8d 47 6c             	lea    0x6c(%edi),%eax
801042bd:	6a 10                	push   $0x10
801042bf:	53                   	push   %ebx
801042c0:	50                   	push   %eax
801042c1:	e8 3a 0c 00 00       	call   80104f00 <safestrcpy>
  pid = np->pid;
801042c6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
801042c9:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
801042d0:	e8 2b 09 00 00       	call   80104c00 <acquire>
  np->state = RUNNABLE;
801042d5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
801042dc:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
801042e3:	e8 d8 09 00 00       	call   80104cc0 <release>
  return pid;
801042e8:	83 c4 10             	add    $0x10,%esp
}
801042eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ee:	89 d8                	mov    %ebx,%eax
801042f0:	5b                   	pop    %ebx
801042f1:	5e                   	pop    %esi
801042f2:	5f                   	pop    %edi
801042f3:	5d                   	pop    %ebp
801042f4:	c3                   	ret    
      return -1;
801042f5:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801042fa:	eb ef                	jmp    801042eb <fork+0xdb>
    kfree(np->kstack);
801042fc:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801042ff:	83 ec 0c             	sub    $0xc,%esp
80104302:	ff 73 08             	pushl  0x8(%ebx)
80104305:	e8 d6 e1 ff ff       	call   801024e0 <kfree>
    np->kstack = 0;
8010430a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80104311:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104318:	83 c4 10             	add    $0x10,%esp
8010431b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104320:	eb c9                	jmp    801042eb <fork+0xdb>
80104322:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <scheduler>:
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	57                   	push   %edi
80104334:	56                   	push   %esi
80104335:	53                   	push   %ebx
80104336:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104339:	e8 52 fc ff ff       	call   80103f90 <mycpu>
8010433e:	8d 78 04             	lea    0x4(%eax),%edi
80104341:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104343:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010434a:	00 00 00 
8010434d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104350:	fb                   	sti    
    acquire(&ptable.lock);
80104351:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104354:	bb 14 be 22 80       	mov    $0x8022be14,%ebx
    acquire(&ptable.lock);
80104359:	68 e0 bd 22 80       	push   $0x8022bde0
8010435e:	e8 9d 08 00 00       	call   80104c00 <acquire>
80104363:	83 c4 10             	add    $0x10,%esp
80104366:	8d 76 00             	lea    0x0(%esi),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104370:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104374:	75 33                	jne    801043a9 <scheduler+0x79>
      switchuvm(p);
80104376:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104379:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010437f:	53                   	push   %ebx
80104380:	e8 9b 2e 00 00       	call   80107220 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104385:	58                   	pop    %eax
80104386:	5a                   	pop    %edx
80104387:	ff 73 1c             	pushl  0x1c(%ebx)
8010438a:	57                   	push   %edi
      p->state = RUNNING;
8010438b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104392:	e8 c4 0b 00 00       	call   80104f5b <swtch>
      switchkvm();
80104397:	e8 64 2e 00 00       	call   80107200 <switchkvm>
      c->proc = 0;
8010439c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801043a3:	00 00 00 
801043a6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043a9:	83 c3 7c             	add    $0x7c,%ebx
801043ac:	81 fb 14 dd 22 80    	cmp    $0x8022dd14,%ebx
801043b2:	72 bc                	jb     80104370 <scheduler+0x40>
    release(&ptable.lock);
801043b4:	83 ec 0c             	sub    $0xc,%esp
801043b7:	68 e0 bd 22 80       	push   $0x8022bde0
801043bc:	e8 ff 08 00 00       	call   80104cc0 <release>
    sti();
801043c1:	83 c4 10             	add    $0x10,%esp
801043c4:	eb 8a                	jmp    80104350 <scheduler+0x20>
801043c6:	8d 76 00             	lea    0x0(%esi),%esi
801043c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043d0 <sched>:
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	56                   	push   %esi
801043d4:	53                   	push   %ebx
  pushcli();
801043d5:	e8 56 07 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801043da:	e8 b1 fb ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801043df:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043e5:	e8 86 07 00 00       	call   80104b70 <popcli>
  if(!holding(&ptable.lock))
801043ea:	83 ec 0c             	sub    $0xc,%esp
801043ed:	68 e0 bd 22 80       	push   $0x8022bde0
801043f2:	e8 d9 07 00 00       	call   80104bd0 <holding>
801043f7:	83 c4 10             	add    $0x10,%esp
801043fa:	85 c0                	test   %eax,%eax
801043fc:	74 4f                	je     8010444d <sched+0x7d>
  if(mycpu()->ncli != 1)
801043fe:	e8 8d fb ff ff       	call   80103f90 <mycpu>
80104403:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010440a:	75 68                	jne    80104474 <sched+0xa4>
  if(p->state == RUNNING)
8010440c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104410:	74 55                	je     80104467 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104412:	9c                   	pushf  
80104413:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104414:	f6 c4 02             	test   $0x2,%ah
80104417:	75 41                	jne    8010445a <sched+0x8a>
  intena = mycpu()->intena;
80104419:	e8 72 fb ff ff       	call   80103f90 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010441e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104421:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104427:	e8 64 fb ff ff       	call   80103f90 <mycpu>
8010442c:	83 ec 08             	sub    $0x8,%esp
8010442f:	ff 70 04             	pushl  0x4(%eax)
80104432:	53                   	push   %ebx
80104433:	e8 23 0b 00 00       	call   80104f5b <swtch>
  mycpu()->intena = intena;
80104438:	e8 53 fb ff ff       	call   80103f90 <mycpu>
}
8010443d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104440:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104446:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104449:	5b                   	pop    %ebx
8010444a:	5e                   	pop    %esi
8010444b:	5d                   	pop    %ebp
8010444c:	c3                   	ret    
    panic("sched ptable.lock");
8010444d:	83 ec 0c             	sub    $0xc,%esp
80104450:	68 3b 80 10 80       	push   $0x8010803b
80104455:	e8 36 bf ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010445a:	83 ec 0c             	sub    $0xc,%esp
8010445d:	68 67 80 10 80       	push   $0x80108067
80104462:	e8 29 bf ff ff       	call   80100390 <panic>
    panic("sched running");
80104467:	83 ec 0c             	sub    $0xc,%esp
8010446a:	68 59 80 10 80       	push   $0x80108059
8010446f:	e8 1c bf ff ff       	call   80100390 <panic>
    panic("sched locks");
80104474:	83 ec 0c             	sub    $0xc,%esp
80104477:	68 4d 80 10 80       	push   $0x8010804d
8010447c:	e8 0f bf ff ff       	call   80100390 <panic>
80104481:	eb 0d                	jmp    80104490 <exit>
80104483:	90                   	nop
80104484:	90                   	nop
80104485:	90                   	nop
80104486:	90                   	nop
80104487:	90                   	nop
80104488:	90                   	nop
80104489:	90                   	nop
8010448a:	90                   	nop
8010448b:	90                   	nop
8010448c:	90                   	nop
8010448d:	90                   	nop
8010448e:	90                   	nop
8010448f:	90                   	nop

80104490 <exit>:
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	57                   	push   %edi
80104494:	56                   	push   %esi
80104495:	53                   	push   %ebx
80104496:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104499:	e8 92 06 00 00       	call   80104b30 <pushcli>
  c = mycpu();
8010449e:	e8 ed fa ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801044a3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801044a9:	e8 c2 06 00 00       	call   80104b70 <popcli>
  if(curproc == initproc)
801044ae:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801044b4:	8d 5e 28             	lea    0x28(%esi),%ebx
801044b7:	8d 7e 68             	lea    0x68(%esi),%edi
801044ba:	0f 84 e7 00 00 00    	je     801045a7 <exit+0x117>
    if(curproc->ofile[fd]){
801044c0:	8b 03                	mov    (%ebx),%eax
801044c2:	85 c0                	test   %eax,%eax
801044c4:	74 12                	je     801044d8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801044c6:	83 ec 0c             	sub    $0xc,%esp
801044c9:	50                   	push   %eax
801044ca:	e8 71 c9 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
801044cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801044d5:	83 c4 10             	add    $0x10,%esp
801044d8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801044db:	39 fb                	cmp    %edi,%ebx
801044dd:	75 e1                	jne    801044c0 <exit+0x30>
  begin_op();
801044df:	e8 0c ef ff ff       	call   801033f0 <begin_op>
  iput(curproc->cwd);
801044e4:	83 ec 0c             	sub    $0xc,%esp
801044e7:	ff 76 68             	pushl  0x68(%esi)
801044ea:	e8 d1 d2 ff ff       	call   801017c0 <iput>
  end_op();
801044ef:	e8 6c ef ff ff       	call   80103460 <end_op>
  curproc->cwd = 0;
801044f4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801044fb:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
80104502:	e8 f9 06 00 00       	call   80104c00 <acquire>
  wakeup1(curproc->parent);
80104507:	8b 56 14             	mov    0x14(%esi),%edx
8010450a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010450d:	b8 14 be 22 80       	mov    $0x8022be14,%eax
80104512:	eb 0e                	jmp    80104522 <exit+0x92>
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104518:	83 c0 7c             	add    $0x7c,%eax
8010451b:	3d 14 dd 22 80       	cmp    $0x8022dd14,%eax
80104520:	73 1c                	jae    8010453e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80104522:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104526:	75 f0                	jne    80104518 <exit+0x88>
80104528:	3b 50 20             	cmp    0x20(%eax),%edx
8010452b:	75 eb                	jne    80104518 <exit+0x88>
      p->state = RUNNABLE;
8010452d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104534:	83 c0 7c             	add    $0x7c,%eax
80104537:	3d 14 dd 22 80       	cmp    $0x8022dd14,%eax
8010453c:	72 e4                	jb     80104522 <exit+0x92>
      p->parent = initproc;
8010453e:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104544:	ba 14 be 22 80       	mov    $0x8022be14,%edx
80104549:	eb 10                	jmp    8010455b <exit+0xcb>
8010454b:	90                   	nop
8010454c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104550:	83 c2 7c             	add    $0x7c,%edx
80104553:	81 fa 14 dd 22 80    	cmp    $0x8022dd14,%edx
80104559:	73 33                	jae    8010458e <exit+0xfe>
    if(p->parent == curproc){
8010455b:	39 72 14             	cmp    %esi,0x14(%edx)
8010455e:	75 f0                	jne    80104550 <exit+0xc0>
      if(p->state == ZOMBIE)
80104560:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104564:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80104567:	75 e7                	jne    80104550 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104569:	b8 14 be 22 80       	mov    $0x8022be14,%eax
8010456e:	eb 0a                	jmp    8010457a <exit+0xea>
80104570:	83 c0 7c             	add    $0x7c,%eax
80104573:	3d 14 dd 22 80       	cmp    $0x8022dd14,%eax
80104578:	73 d6                	jae    80104550 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010457a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010457e:	75 f0                	jne    80104570 <exit+0xe0>
80104580:	3b 48 20             	cmp    0x20(%eax),%ecx
80104583:	75 eb                	jne    80104570 <exit+0xe0>
      p->state = RUNNABLE;
80104585:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010458c:	eb e2                	jmp    80104570 <exit+0xe0>
  curproc->state = ZOMBIE;
8010458e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104595:	e8 36 fe ff ff       	call   801043d0 <sched>
  panic("zombie exit");
8010459a:	83 ec 0c             	sub    $0xc,%esp
8010459d:	68 88 80 10 80       	push   $0x80108088
801045a2:	e8 e9 bd ff ff       	call   80100390 <panic>
    panic("init exiting");
801045a7:	83 ec 0c             	sub    $0xc,%esp
801045aa:	68 7b 80 10 80       	push   $0x8010807b
801045af:	e8 dc bd ff ff       	call   80100390 <panic>
801045b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801045c0 <yield>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	53                   	push   %ebx
801045c4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801045c7:	68 e0 bd 22 80       	push   $0x8022bde0
801045cc:	e8 2f 06 00 00       	call   80104c00 <acquire>
  pushcli();
801045d1:	e8 5a 05 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801045d6:	e8 b5 f9 ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801045db:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045e1:	e8 8a 05 00 00       	call   80104b70 <popcli>
  myproc()->state = RUNNABLE;
801045e6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801045ed:	e8 de fd ff ff       	call   801043d0 <sched>
  release(&ptable.lock);
801045f2:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
801045f9:	e8 c2 06 00 00       	call   80104cc0 <release>
}
801045fe:	83 c4 10             	add    $0x10,%esp
80104601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104604:	c9                   	leave  
80104605:	c3                   	ret    
80104606:	8d 76 00             	lea    0x0(%esi),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <sleep>:
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	53                   	push   %ebx
80104616:	83 ec 0c             	sub    $0xc,%esp
80104619:	8b 7d 08             	mov    0x8(%ebp),%edi
8010461c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010461f:	e8 0c 05 00 00       	call   80104b30 <pushcli>
  c = mycpu();
80104624:	e8 67 f9 ff ff       	call   80103f90 <mycpu>
  p = c->proc;
80104629:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010462f:	e8 3c 05 00 00       	call   80104b70 <popcli>
  if(p == 0)
80104634:	85 db                	test   %ebx,%ebx
80104636:	0f 84 87 00 00 00    	je     801046c3 <sleep+0xb3>
  if(lk == 0)
8010463c:	85 f6                	test   %esi,%esi
8010463e:	74 76                	je     801046b6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104640:	81 fe e0 bd 22 80    	cmp    $0x8022bde0,%esi
80104646:	74 50                	je     80104698 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104648:	83 ec 0c             	sub    $0xc,%esp
8010464b:	68 e0 bd 22 80       	push   $0x8022bde0
80104650:	e8 ab 05 00 00       	call   80104c00 <acquire>
    release(lk);
80104655:	89 34 24             	mov    %esi,(%esp)
80104658:	e8 63 06 00 00       	call   80104cc0 <release>
  p->chan = chan;
8010465d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104660:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104667:	e8 64 fd ff ff       	call   801043d0 <sched>
  p->chan = 0;
8010466c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104673:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
8010467a:	e8 41 06 00 00       	call   80104cc0 <release>
    acquire(lk);
8010467f:	89 75 08             	mov    %esi,0x8(%ebp)
80104682:	83 c4 10             	add    $0x10,%esp
}
80104685:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104688:	5b                   	pop    %ebx
80104689:	5e                   	pop    %esi
8010468a:	5f                   	pop    %edi
8010468b:	5d                   	pop    %ebp
    acquire(lk);
8010468c:	e9 6f 05 00 00       	jmp    80104c00 <acquire>
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104698:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010469b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801046a2:	e8 29 fd ff ff       	call   801043d0 <sched>
  p->chan = 0;
801046a7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801046ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046b1:	5b                   	pop    %ebx
801046b2:	5e                   	pop    %esi
801046b3:	5f                   	pop    %edi
801046b4:	5d                   	pop    %ebp
801046b5:	c3                   	ret    
    panic("sleep without lk");
801046b6:	83 ec 0c             	sub    $0xc,%esp
801046b9:	68 9a 80 10 80       	push   $0x8010809a
801046be:	e8 cd bc ff ff       	call   80100390 <panic>
    panic("sleep");
801046c3:	83 ec 0c             	sub    $0xc,%esp
801046c6:	68 94 80 10 80       	push   $0x80108094
801046cb:	e8 c0 bc ff ff       	call   80100390 <panic>

801046d0 <wait>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
801046d4:	53                   	push   %ebx
  pushcli();
801046d5:	e8 56 04 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801046da:	e8 b1 f8 ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801046df:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801046e5:	e8 86 04 00 00       	call   80104b70 <popcli>
  acquire(&ptable.lock);
801046ea:	83 ec 0c             	sub    $0xc,%esp
801046ed:	68 e0 bd 22 80       	push   $0x8022bde0
801046f2:	e8 09 05 00 00       	call   80104c00 <acquire>
801046f7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801046fa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046fc:	bb 14 be 22 80       	mov    $0x8022be14,%ebx
80104701:	eb 10                	jmp    80104713 <wait+0x43>
80104703:	90                   	nop
80104704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104708:	83 c3 7c             	add    $0x7c,%ebx
8010470b:	81 fb 14 dd 22 80    	cmp    $0x8022dd14,%ebx
80104711:	73 1b                	jae    8010472e <wait+0x5e>
      if(p->parent != curproc)
80104713:	39 73 14             	cmp    %esi,0x14(%ebx)
80104716:	75 f0                	jne    80104708 <wait+0x38>
      if(p->state == ZOMBIE){
80104718:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010471c:	74 32                	je     80104750 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010471e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104721:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104726:	81 fb 14 dd 22 80    	cmp    $0x8022dd14,%ebx
8010472c:	72 e5                	jb     80104713 <wait+0x43>
    if(!havekids || curproc->killed){
8010472e:	85 c0                	test   %eax,%eax
80104730:	74 74                	je     801047a6 <wait+0xd6>
80104732:	8b 46 24             	mov    0x24(%esi),%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	75 6d                	jne    801047a6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104739:	83 ec 08             	sub    $0x8,%esp
8010473c:	68 e0 bd 22 80       	push   $0x8022bde0
80104741:	56                   	push   %esi
80104742:	e8 c9 fe ff ff       	call   80104610 <sleep>
    havekids = 0;
80104747:	83 c4 10             	add    $0x10,%esp
8010474a:	eb ae                	jmp    801046fa <wait+0x2a>
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104756:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104759:	e8 82 dd ff ff       	call   801024e0 <kfree>
        freevm(p->pgdir);
8010475e:	5a                   	pop    %edx
8010475f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104762:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104769:	e8 d2 2e 00 00       	call   80107640 <freevm>
        release(&ptable.lock);
8010476e:	c7 04 24 e0 bd 22 80 	movl   $0x8022bde0,(%esp)
        p->pid = 0;
80104775:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010477c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104783:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104787:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010478e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104795:	e8 26 05 00 00       	call   80104cc0 <release>
        return pid;
8010479a:	83 c4 10             	add    $0x10,%esp
}
8010479d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047a0:	89 f0                	mov    %esi,%eax
801047a2:	5b                   	pop    %ebx
801047a3:	5e                   	pop    %esi
801047a4:	5d                   	pop    %ebp
801047a5:	c3                   	ret    
      release(&ptable.lock);
801047a6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801047a9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801047ae:	68 e0 bd 22 80       	push   $0x8022bde0
801047b3:	e8 08 05 00 00       	call   80104cc0 <release>
      return -1;
801047b8:	83 c4 10             	add    $0x10,%esp
801047bb:	eb e0                	jmp    8010479d <wait+0xcd>
801047bd:	8d 76 00             	lea    0x0(%esi),%esi

801047c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 10             	sub    $0x10,%esp
801047c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801047ca:	68 e0 bd 22 80       	push   $0x8022bde0
801047cf:	e8 2c 04 00 00       	call   80104c00 <acquire>
801047d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047d7:	b8 14 be 22 80       	mov    $0x8022be14,%eax
801047dc:	eb 0c                	jmp    801047ea <wakeup+0x2a>
801047de:	66 90                	xchg   %ax,%ax
801047e0:	83 c0 7c             	add    $0x7c,%eax
801047e3:	3d 14 dd 22 80       	cmp    $0x8022dd14,%eax
801047e8:	73 1c                	jae    80104806 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801047ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047ee:	75 f0                	jne    801047e0 <wakeup+0x20>
801047f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801047f3:	75 eb                	jne    801047e0 <wakeup+0x20>
      p->state = RUNNABLE;
801047f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047fc:	83 c0 7c             	add    $0x7c,%eax
801047ff:	3d 14 dd 22 80       	cmp    $0x8022dd14,%eax
80104804:	72 e4                	jb     801047ea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104806:	c7 45 08 e0 bd 22 80 	movl   $0x8022bde0,0x8(%ebp)
}
8010480d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104810:	c9                   	leave  
  release(&ptable.lock);
80104811:	e9 aa 04 00 00       	jmp    80104cc0 <release>
80104816:	8d 76 00             	lea    0x0(%esi),%esi
80104819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104820 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 10             	sub    $0x10,%esp
80104827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010482a:	68 e0 bd 22 80       	push   $0x8022bde0
8010482f:	e8 cc 03 00 00       	call   80104c00 <acquire>
80104834:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104837:	b8 14 be 22 80       	mov    $0x8022be14,%eax
8010483c:	eb 0c                	jmp    8010484a <kill+0x2a>
8010483e:	66 90                	xchg   %ax,%ax
80104840:	83 c0 7c             	add    $0x7c,%eax
80104843:	3d 14 dd 22 80       	cmp    $0x8022dd14,%eax
80104848:	73 36                	jae    80104880 <kill+0x60>
    if(p->pid == pid){
8010484a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010484d:	75 f1                	jne    80104840 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010484f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104853:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010485a:	75 07                	jne    80104863 <kill+0x43>
        p->state = RUNNABLE;
8010485c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104863:	83 ec 0c             	sub    $0xc,%esp
80104866:	68 e0 bd 22 80       	push   $0x8022bde0
8010486b:	e8 50 04 00 00       	call   80104cc0 <release>
      return 0;
80104870:	83 c4 10             	add    $0x10,%esp
80104873:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104875:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104878:	c9                   	leave  
80104879:	c3                   	ret    
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	68 e0 bd 22 80       	push   $0x8022bde0
80104888:	e8 33 04 00 00       	call   80104cc0 <release>
  return -1;
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104895:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104898:	c9                   	leave  
80104899:	c3                   	ret    
8010489a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801048a0 <getpid>:
int getpid()
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801048a7:	e8 84 02 00 00       	call   80104b30 <pushcli>
  c = mycpu();
801048ac:	e8 df f6 ff ff       	call   80103f90 <mycpu>
  p = c->proc;
801048b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801048b7:	e8 b4 02 00 00       	call   80104b70 <popcli>
    return myproc()->pid;
801048bc:	8b 43 10             	mov    0x10(%ebx),%eax
}
801048bf:	83 c4 04             	add    $0x4,%esp
801048c2:	5b                   	pop    %ebx
801048c3:	5d                   	pop    %ebp
801048c4:	c3                   	ret    
801048c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	56                   	push   %esi
801048d5:	53                   	push   %ebx
801048d6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048d9:	bb 14 be 22 80       	mov    $0x8022be14,%ebx
{
801048de:	83 ec 3c             	sub    $0x3c,%esp
801048e1:	eb 24                	jmp    80104907 <procdump+0x37>
801048e3:	90                   	nop
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801048e8:	83 ec 0c             	sub    $0xc,%esp
801048eb:	68 8b 84 10 80       	push   $0x8010848b
801048f0:	e8 6b bd ff ff       	call   80100660 <cprintf>
801048f5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048f8:	83 c3 7c             	add    $0x7c,%ebx
801048fb:	81 fb 14 dd 22 80    	cmp    $0x8022dd14,%ebx
80104901:	0f 83 81 00 00 00    	jae    80104988 <procdump+0xb8>
    if(p->state == UNUSED)
80104907:	8b 43 0c             	mov    0xc(%ebx),%eax
8010490a:	85 c0                	test   %eax,%eax
8010490c:	74 ea                	je     801048f8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010490e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104911:	ba ab 80 10 80       	mov    $0x801080ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104916:	77 11                	ja     80104929 <procdump+0x59>
80104918:	8b 14 85 0c 81 10 80 	mov    -0x7fef7ef4(,%eax,4),%edx
      state = "???";
8010491f:	b8 ab 80 10 80       	mov    $0x801080ab,%eax
80104924:	85 d2                	test   %edx,%edx
80104926:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104929:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010492c:	50                   	push   %eax
8010492d:	52                   	push   %edx
8010492e:	ff 73 10             	pushl  0x10(%ebx)
80104931:	68 af 80 10 80       	push   $0x801080af
80104936:	e8 25 bd ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010493b:	83 c4 10             	add    $0x10,%esp
8010493e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104942:	75 a4                	jne    801048e8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104944:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104947:	83 ec 08             	sub    $0x8,%esp
8010494a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010494d:	50                   	push   %eax
8010494e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104951:	8b 40 0c             	mov    0xc(%eax),%eax
80104954:	83 c0 08             	add    $0x8,%eax
80104957:	50                   	push   %eax
80104958:	e8 83 01 00 00       	call   80104ae0 <getcallerpcs>
8010495d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104960:	8b 17                	mov    (%edi),%edx
80104962:	85 d2                	test   %edx,%edx
80104964:	74 82                	je     801048e8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104966:	83 ec 08             	sub    $0x8,%esp
80104969:	83 c7 04             	add    $0x4,%edi
8010496c:	52                   	push   %edx
8010496d:	68 01 7a 10 80       	push   $0x80107a01
80104972:	e8 e9 bc ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104977:	83 c4 10             	add    $0x10,%esp
8010497a:	39 fe                	cmp    %edi,%esi
8010497c:	75 e2                	jne    80104960 <procdump+0x90>
8010497e:	e9 65 ff ff ff       	jmp    801048e8 <procdump+0x18>
80104983:	90                   	nop
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104988:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010498b:	5b                   	pop    %ebx
8010498c:	5e                   	pop    %esi
8010498d:	5f                   	pop    %edi
8010498e:	5d                   	pop    %ebp
8010498f:	c3                   	ret    

80104990 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	53                   	push   %ebx
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010499a:	68 24 81 10 80       	push   $0x80108124
8010499f:	8d 43 04             	lea    0x4(%ebx),%eax
801049a2:	50                   	push   %eax
801049a3:	e8 18 01 00 00       	call   80104ac0 <initlock>
  lk->name = name;
801049a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801049ab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801049b1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801049b4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801049bb:	89 43 38             	mov    %eax,0x38(%ebx)
}
801049be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c1:	c9                   	leave  
801049c2:	c3                   	ret    
801049c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049d0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	56                   	push   %esi
801049d4:	53                   	push   %ebx
801049d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801049d8:	83 ec 0c             	sub    $0xc,%esp
801049db:	8d 73 04             	lea    0x4(%ebx),%esi
801049de:	56                   	push   %esi
801049df:	e8 1c 02 00 00       	call   80104c00 <acquire>
  while (lk->locked) {
801049e4:	8b 13                	mov    (%ebx),%edx
801049e6:	83 c4 10             	add    $0x10,%esp
801049e9:	85 d2                	test   %edx,%edx
801049eb:	74 16                	je     80104a03 <acquiresleep+0x33>
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801049f0:	83 ec 08             	sub    $0x8,%esp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	e8 16 fc ff ff       	call   80104610 <sleep>
  while (lk->locked) {
801049fa:	8b 03                	mov    (%ebx),%eax
801049fc:	83 c4 10             	add    $0x10,%esp
801049ff:	85 c0                	test   %eax,%eax
80104a01:	75 ed                	jne    801049f0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104a03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104a09:	e8 22 f6 ff ff       	call   80104030 <myproc>
80104a0e:	8b 40 10             	mov    0x10(%eax),%eax
80104a11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104a14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104a17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a1a:	5b                   	pop    %ebx
80104a1b:	5e                   	pop    %esi
80104a1c:	5d                   	pop    %ebp
  release(&lk->lk);
80104a1d:	e9 9e 02 00 00       	jmp    80104cc0 <release>
80104a22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
80104a35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104a38:	83 ec 0c             	sub    $0xc,%esp
80104a3b:	8d 73 04             	lea    0x4(%ebx),%esi
80104a3e:	56                   	push   %esi
80104a3f:	e8 bc 01 00 00       	call   80104c00 <acquire>
  lk->locked = 0;
80104a44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104a4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104a51:	89 1c 24             	mov    %ebx,(%esp)
80104a54:	e8 67 fd ff ff       	call   801047c0 <wakeup>
  release(&lk->lk);
80104a59:	89 75 08             	mov    %esi,0x8(%ebp)
80104a5c:	83 c4 10             	add    $0x10,%esp
}
80104a5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a62:	5b                   	pop    %ebx
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
  release(&lk->lk);
80104a65:	e9 56 02 00 00       	jmp    80104cc0 <release>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	56                   	push   %esi
80104a75:	53                   	push   %ebx
80104a76:	31 ff                	xor    %edi,%edi
80104a78:	83 ec 18             	sub    $0x18,%esp
80104a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104a7e:	8d 73 04             	lea    0x4(%ebx),%esi
80104a81:	56                   	push   %esi
80104a82:	e8 79 01 00 00       	call   80104c00 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104a87:	8b 03                	mov    (%ebx),%eax
80104a89:	83 c4 10             	add    $0x10,%esp
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	74 13                	je     80104aa3 <holdingsleep+0x33>
80104a90:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104a93:	e8 98 f5 ff ff       	call   80104030 <myproc>
80104a98:	39 58 10             	cmp    %ebx,0x10(%eax)
80104a9b:	0f 94 c0             	sete   %al
80104a9e:	0f b6 c0             	movzbl %al,%eax
80104aa1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104aa3:	83 ec 0c             	sub    $0xc,%esp
80104aa6:	56                   	push   %esi
80104aa7:	e8 14 02 00 00       	call   80104cc0 <release>
  return r;
}
80104aac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104aaf:	89 f8                	mov    %edi,%eax
80104ab1:	5b                   	pop    %ebx
80104ab2:	5e                   	pop    %esi
80104ab3:	5f                   	pop    %edi
80104ab4:	5d                   	pop    %ebp
80104ab5:	c3                   	ret    
80104ab6:	66 90                	xchg   %ax,%ax
80104ab8:	66 90                	xchg   %ax,%ax
80104aba:	66 90                	xchg   %ax,%ax
80104abc:	66 90                	xchg   %ax,%ax
80104abe:	66 90                	xchg   %ax,%ax

80104ac0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104acf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ad2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ad9:	5d                   	pop    %ebp
80104ada:	c3                   	ret    
80104adb:	90                   	nop
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ae0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ae1:	31 d2                	xor    %edx,%edx
{
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104ae6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ae9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104aec:	83 e8 08             	sub    $0x8,%eax
80104aef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104af0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104af6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104afc:	77 1a                	ja     80104b18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104afe:	8b 58 04             	mov    0x4(%eax),%ebx
80104b01:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104b04:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104b07:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104b09:	83 fa 0a             	cmp    $0xa,%edx
80104b0c:	75 e2                	jne    80104af0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104b0e:	5b                   	pop    %ebx
80104b0f:	5d                   	pop    %ebp
80104b10:	c3                   	ret    
80104b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b18:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104b1b:	83 c1 28             	add    $0x28,%ecx
80104b1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104b20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104b26:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104b29:	39 c1                	cmp    %eax,%ecx
80104b2b:	75 f3                	jne    80104b20 <getcallerpcs+0x40>
}
80104b2d:	5b                   	pop    %ebx
80104b2e:	5d                   	pop    %ebp
80104b2f:	c3                   	ret    

80104b30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	53                   	push   %ebx
80104b34:	83 ec 04             	sub    $0x4,%esp
80104b37:	9c                   	pushf  
80104b38:	5b                   	pop    %ebx
  asm volatile("cli");
80104b39:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104b3a:	e8 51 f4 ff ff       	call   80103f90 <mycpu>
80104b3f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104b45:	85 c0                	test   %eax,%eax
80104b47:	75 11                	jne    80104b5a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104b49:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104b4f:	e8 3c f4 ff ff       	call   80103f90 <mycpu>
80104b54:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80104b5a:	e8 31 f4 ff ff       	call   80103f90 <mycpu>
80104b5f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104b66:	83 c4 04             	add    $0x4,%esp
80104b69:	5b                   	pop    %ebx
80104b6a:	5d                   	pop    %ebp
80104b6b:	c3                   	ret    
80104b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b70 <popcli>:

void
popcli(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104b76:	9c                   	pushf  
80104b77:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104b78:	f6 c4 02             	test   $0x2,%ah
80104b7b:	75 35                	jne    80104bb2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104b7d:	e8 0e f4 ff ff       	call   80103f90 <mycpu>
80104b82:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104b89:	78 34                	js     80104bbf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104b8b:	e8 00 f4 ff ff       	call   80103f90 <mycpu>
80104b90:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104b96:	85 d2                	test   %edx,%edx
80104b98:	74 06                	je     80104ba0 <popcli+0x30>
    sti();
}
80104b9a:	c9                   	leave  
80104b9b:	c3                   	ret    
80104b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104ba0:	e8 eb f3 ff ff       	call   80103f90 <mycpu>
80104ba5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104bab:	85 c0                	test   %eax,%eax
80104bad:	74 eb                	je     80104b9a <popcli+0x2a>
  asm volatile("sti");
80104baf:	fb                   	sti    
}
80104bb0:	c9                   	leave  
80104bb1:	c3                   	ret    
    panic("popcli - interruptible");
80104bb2:	83 ec 0c             	sub    $0xc,%esp
80104bb5:	68 2f 81 10 80       	push   $0x8010812f
80104bba:	e8 d1 b7 ff ff       	call   80100390 <panic>
    panic("popcli");
80104bbf:	83 ec 0c             	sub    $0xc,%esp
80104bc2:	68 46 81 10 80       	push   $0x80108146
80104bc7:	e8 c4 b7 ff ff       	call   80100390 <panic>
80104bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bd0 <holding>:
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
80104bd5:	8b 75 08             	mov    0x8(%ebp),%esi
80104bd8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104bda:	e8 51 ff ff ff       	call   80104b30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104bdf:	8b 06                	mov    (%esi),%eax
80104be1:	85 c0                	test   %eax,%eax
80104be3:	74 10                	je     80104bf5 <holding+0x25>
80104be5:	8b 5e 08             	mov    0x8(%esi),%ebx
80104be8:	e8 a3 f3 ff ff       	call   80103f90 <mycpu>
80104bed:	39 c3                	cmp    %eax,%ebx
80104bef:	0f 94 c3             	sete   %bl
80104bf2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104bf5:	e8 76 ff ff ff       	call   80104b70 <popcli>
}
80104bfa:	89 d8                	mov    %ebx,%eax
80104bfc:	5b                   	pop    %ebx
80104bfd:	5e                   	pop    %esi
80104bfe:	5d                   	pop    %ebp
80104bff:	c3                   	ret    

80104c00 <acquire>:
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	56                   	push   %esi
80104c04:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104c05:	e8 26 ff ff ff       	call   80104b30 <pushcli>
  if(holding(lk))
80104c0a:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c0d:	83 ec 0c             	sub    $0xc,%esp
80104c10:	53                   	push   %ebx
80104c11:	e8 ba ff ff ff       	call   80104bd0 <holding>
80104c16:	83 c4 10             	add    $0x10,%esp
80104c19:	85 c0                	test   %eax,%eax
80104c1b:	0f 85 83 00 00 00    	jne    80104ca4 <acquire+0xa4>
80104c21:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104c23:	ba 01 00 00 00       	mov    $0x1,%edx
80104c28:	eb 09                	jmp    80104c33 <acquire+0x33>
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c30:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c33:	89 d0                	mov    %edx,%eax
80104c35:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104c38:	85 c0                	test   %eax,%eax
80104c3a:	75 f4                	jne    80104c30 <acquire+0x30>
  __sync_synchronize();
80104c3c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104c41:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104c44:	e8 47 f3 ff ff       	call   80103f90 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104c49:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
80104c4c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104c4f:	89 e8                	mov    %ebp,%eax
80104c51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104c58:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80104c5e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104c64:	77 1a                	ja     80104c80 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104c66:	8b 48 04             	mov    0x4(%eax),%ecx
80104c69:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
80104c6c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104c6f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c71:	83 fe 0a             	cmp    $0xa,%esi
80104c74:	75 e2                	jne    80104c58 <acquire+0x58>
}
80104c76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c79:	5b                   	pop    %ebx
80104c7a:	5e                   	pop    %esi
80104c7b:	5d                   	pop    %ebp
80104c7c:	c3                   	ret    
80104c7d:	8d 76 00             	lea    0x0(%esi),%esi
80104c80:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104c83:	83 c2 28             	add    $0x28,%edx
80104c86:	8d 76 00             	lea    0x0(%esi),%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104c90:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104c96:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104c99:	39 d0                	cmp    %edx,%eax
80104c9b:	75 f3                	jne    80104c90 <acquire+0x90>
}
80104c9d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ca0:	5b                   	pop    %ebx
80104ca1:	5e                   	pop    %esi
80104ca2:	5d                   	pop    %ebp
80104ca3:	c3                   	ret    
      cprintf("lk-->name : %s\n",lk->name);
80104ca4:	50                   	push   %eax
80104ca5:	50                   	push   %eax
80104ca6:	ff 73 04             	pushl  0x4(%ebx)
80104ca9:	68 4d 81 10 80       	push   $0x8010814d
80104cae:	e8 ad b9 ff ff       	call   80100660 <cprintf>
      panic("acquire");
80104cb3:	c7 04 24 5d 81 10 80 	movl   $0x8010815d,(%esp)
80104cba:	e8 d1 b6 ff ff       	call   80100390 <panic>
80104cbf:	90                   	nop

80104cc0 <release>:
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 10             	sub    $0x10,%esp
80104cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104cca:	53                   	push   %ebx
80104ccb:	e8 00 ff ff ff       	call   80104bd0 <holding>
80104cd0:	83 c4 10             	add    $0x10,%esp
80104cd3:	85 c0                	test   %eax,%eax
80104cd5:	74 22                	je     80104cf9 <release+0x39>
  lk->pcs[0] = 0;
80104cd7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104cde:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104ce5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104cea:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104cf0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf3:	c9                   	leave  
  popcli();
80104cf4:	e9 77 fe ff ff       	jmp    80104b70 <popcli>
      cprintf("release name -> %s\n",lk->name);
80104cf9:	50                   	push   %eax
80104cfa:	50                   	push   %eax
80104cfb:	ff 73 04             	pushl  0x4(%ebx)
80104cfe:	68 65 81 10 80       	push   $0x80108165
80104d03:	e8 58 b9 ff ff       	call   80100660 <cprintf>
      panic("release");
80104d08:	c7 04 24 79 81 10 80 	movl   $0x80108179,(%esp)
80104d0f:	e8 7c b6 ff ff       	call   80100390 <panic>
80104d14:	66 90                	xchg   %ax,%ax
80104d16:	66 90                	xchg   %ax,%ax
80104d18:	66 90                	xchg   %ax,%ax
80104d1a:	66 90                	xchg   %ax,%ax
80104d1c:	66 90                	xchg   %ax,%ax
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	53                   	push   %ebx
80104d25:	8b 55 08             	mov    0x8(%ebp),%edx
80104d28:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104d2b:	f6 c2 03             	test   $0x3,%dl
80104d2e:	75 05                	jne    80104d35 <memset+0x15>
80104d30:	f6 c1 03             	test   $0x3,%cl
80104d33:	74 13                	je     80104d48 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104d35:	89 d7                	mov    %edx,%edi
80104d37:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d3a:	fc                   	cld    
80104d3b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104d3d:	5b                   	pop    %ebx
80104d3e:	89 d0                	mov    %edx,%eax
80104d40:	5f                   	pop    %edi
80104d41:	5d                   	pop    %ebp
80104d42:	c3                   	ret    
80104d43:	90                   	nop
80104d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104d48:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104d4c:	c1 e9 02             	shr    $0x2,%ecx
80104d4f:	89 f8                	mov    %edi,%eax
80104d51:	89 fb                	mov    %edi,%ebx
80104d53:	c1 e0 18             	shl    $0x18,%eax
80104d56:	c1 e3 10             	shl    $0x10,%ebx
80104d59:	09 d8                	or     %ebx,%eax
80104d5b:	09 f8                	or     %edi,%eax
80104d5d:	c1 e7 08             	shl    $0x8,%edi
80104d60:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104d62:	89 d7                	mov    %edx,%edi
80104d64:	fc                   	cld    
80104d65:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104d67:	5b                   	pop    %ebx
80104d68:	89 d0                	mov    %edx,%eax
80104d6a:	5f                   	pop    %edi
80104d6b:	5d                   	pop    %ebp
80104d6c:	c3                   	ret    
80104d6d:	8d 76 00             	lea    0x0(%esi),%esi

80104d70 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	57                   	push   %edi
80104d74:	56                   	push   %esi
80104d75:	53                   	push   %ebx
80104d76:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d79:	8b 75 08             	mov    0x8(%ebp),%esi
80104d7c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104d7f:	85 db                	test   %ebx,%ebx
80104d81:	74 29                	je     80104dac <memcmp+0x3c>
    if(*s1 != *s2)
80104d83:	0f b6 16             	movzbl (%esi),%edx
80104d86:	0f b6 0f             	movzbl (%edi),%ecx
80104d89:	38 d1                	cmp    %dl,%cl
80104d8b:	75 2b                	jne    80104db8 <memcmp+0x48>
80104d8d:	b8 01 00 00 00       	mov    $0x1,%eax
80104d92:	eb 14                	jmp    80104da8 <memcmp+0x38>
80104d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d98:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104d9c:	83 c0 01             	add    $0x1,%eax
80104d9f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104da4:	38 ca                	cmp    %cl,%dl
80104da6:	75 10                	jne    80104db8 <memcmp+0x48>
  while(n-- > 0){
80104da8:	39 d8                	cmp    %ebx,%eax
80104daa:	75 ec                	jne    80104d98 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104dac:	5b                   	pop    %ebx
  return 0;
80104dad:	31 c0                	xor    %eax,%eax
}
80104daf:	5e                   	pop    %esi
80104db0:	5f                   	pop    %edi
80104db1:	5d                   	pop    %ebp
80104db2:	c3                   	ret    
80104db3:	90                   	nop
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104db8:	0f b6 c2             	movzbl %dl,%eax
}
80104dbb:	5b                   	pop    %ebx
      return *s1 - *s2;
80104dbc:	29 c8                	sub    %ecx,%eax
}
80104dbe:	5e                   	pop    %esi
80104dbf:	5f                   	pop    %edi
80104dc0:	5d                   	pop    %ebp
80104dc1:	c3                   	ret    
80104dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dd0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104dd0:	55                   	push   %ebp
80104dd1:	89 e5                	mov    %esp,%ebp
80104dd3:	56                   	push   %esi
80104dd4:	53                   	push   %ebx
80104dd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104dd8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104ddb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104dde:	39 c3                	cmp    %eax,%ebx
80104de0:	73 26                	jae    80104e08 <memmove+0x38>
80104de2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104de5:	39 c8                	cmp    %ecx,%eax
80104de7:	73 1f                	jae    80104e08 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104de9:	85 f6                	test   %esi,%esi
80104deb:	8d 56 ff             	lea    -0x1(%esi),%edx
80104dee:	74 0f                	je     80104dff <memmove+0x2f>
      *--d = *--s;
80104df0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104df4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104df7:	83 ea 01             	sub    $0x1,%edx
80104dfa:	83 fa ff             	cmp    $0xffffffff,%edx
80104dfd:	75 f1                	jne    80104df0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104dff:	5b                   	pop    %ebx
80104e00:	5e                   	pop    %esi
80104e01:	5d                   	pop    %ebp
80104e02:	c3                   	ret    
80104e03:	90                   	nop
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104e08:	31 d2                	xor    %edx,%edx
80104e0a:	85 f6                	test   %esi,%esi
80104e0c:	74 f1                	je     80104dff <memmove+0x2f>
80104e0e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104e10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104e14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104e17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104e1a:	39 d6                	cmp    %edx,%esi
80104e1c:	75 f2                	jne    80104e10 <memmove+0x40>
}
80104e1e:	5b                   	pop    %ebx
80104e1f:	5e                   	pop    %esi
80104e20:	5d                   	pop    %ebp
80104e21:	c3                   	ret    
80104e22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e30 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104e33:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104e34:	eb 9a                	jmp    80104dd0 <memmove>
80104e36:	8d 76 00             	lea    0x0(%esi),%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e40 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104e40:	55                   	push   %ebp
80104e41:	89 e5                	mov    %esp,%ebp
80104e43:	57                   	push   %edi
80104e44:	56                   	push   %esi
80104e45:	8b 7d 10             	mov    0x10(%ebp),%edi
80104e48:	53                   	push   %ebx
80104e49:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104e4f:	85 ff                	test   %edi,%edi
80104e51:	74 2f                	je     80104e82 <strncmp+0x42>
80104e53:	0f b6 01             	movzbl (%ecx),%eax
80104e56:	0f b6 1e             	movzbl (%esi),%ebx
80104e59:	84 c0                	test   %al,%al
80104e5b:	74 37                	je     80104e94 <strncmp+0x54>
80104e5d:	38 c3                	cmp    %al,%bl
80104e5f:	75 33                	jne    80104e94 <strncmp+0x54>
80104e61:	01 f7                	add    %esi,%edi
80104e63:	eb 13                	jmp    80104e78 <strncmp+0x38>
80104e65:	8d 76 00             	lea    0x0(%esi),%esi
80104e68:	0f b6 01             	movzbl (%ecx),%eax
80104e6b:	84 c0                	test   %al,%al
80104e6d:	74 21                	je     80104e90 <strncmp+0x50>
80104e6f:	0f b6 1a             	movzbl (%edx),%ebx
80104e72:	89 d6                	mov    %edx,%esi
80104e74:	38 d8                	cmp    %bl,%al
80104e76:	75 1c                	jne    80104e94 <strncmp+0x54>
    n--, p++, q++;
80104e78:	8d 56 01             	lea    0x1(%esi),%edx
80104e7b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104e7e:	39 fa                	cmp    %edi,%edx
80104e80:	75 e6                	jne    80104e68 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104e82:	5b                   	pop    %ebx
    return 0;
80104e83:	31 c0                	xor    %eax,%eax
}
80104e85:	5e                   	pop    %esi
80104e86:	5f                   	pop    %edi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e90:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104e94:	29 d8                	sub    %ebx,%eax
}
80104e96:	5b                   	pop    %ebx
80104e97:	5e                   	pop    %esi
80104e98:	5f                   	pop    %edi
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret    
80104e9b:	90                   	nop
80104e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ea0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	53                   	push   %ebx
80104ea5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ea8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104eab:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104eae:	89 c2                	mov    %eax,%edx
80104eb0:	eb 19                	jmp    80104ecb <strncpy+0x2b>
80104eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104eb8:	83 c3 01             	add    $0x1,%ebx
80104ebb:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104ebf:	83 c2 01             	add    $0x1,%edx
80104ec2:	84 c9                	test   %cl,%cl
80104ec4:	88 4a ff             	mov    %cl,-0x1(%edx)
80104ec7:	74 09                	je     80104ed2 <strncpy+0x32>
80104ec9:	89 f1                	mov    %esi,%ecx
80104ecb:	85 c9                	test   %ecx,%ecx
80104ecd:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104ed0:	7f e6                	jg     80104eb8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104ed2:	31 c9                	xor    %ecx,%ecx
80104ed4:	85 f6                	test   %esi,%esi
80104ed6:	7e 17                	jle    80104eef <strncpy+0x4f>
80104ed8:	90                   	nop
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104ee0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104ee4:	89 f3                	mov    %esi,%ebx
80104ee6:	83 c1 01             	add    $0x1,%ecx
80104ee9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104eeb:	85 db                	test   %ebx,%ebx
80104eed:	7f f1                	jg     80104ee0 <strncpy+0x40>
  return os;
}
80104eef:	5b                   	pop    %ebx
80104ef0:	5e                   	pop    %esi
80104ef1:	5d                   	pop    %ebp
80104ef2:	c3                   	ret    
80104ef3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f00 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	56                   	push   %esi
80104f04:	53                   	push   %ebx
80104f05:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f08:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104f0e:	85 c9                	test   %ecx,%ecx
80104f10:	7e 26                	jle    80104f38 <safestrcpy+0x38>
80104f12:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104f16:	89 c1                	mov    %eax,%ecx
80104f18:	eb 17                	jmp    80104f31 <safestrcpy+0x31>
80104f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104f20:	83 c2 01             	add    $0x1,%edx
80104f23:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104f27:	83 c1 01             	add    $0x1,%ecx
80104f2a:	84 db                	test   %bl,%bl
80104f2c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104f2f:	74 04                	je     80104f35 <safestrcpy+0x35>
80104f31:	39 f2                	cmp    %esi,%edx
80104f33:	75 eb                	jne    80104f20 <safestrcpy+0x20>
    ;
  *s = 0;
80104f35:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104f38:	5b                   	pop    %ebx
80104f39:	5e                   	pop    %esi
80104f3a:	5d                   	pop    %ebp
80104f3b:	c3                   	ret    
80104f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f40 <strlen>:

int
strlen(const char *s)
{
80104f40:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104f41:	31 c0                	xor    %eax,%eax
{
80104f43:	89 e5                	mov    %esp,%ebp
80104f45:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104f48:	80 3a 00             	cmpb   $0x0,(%edx)
80104f4b:	74 0c                	je     80104f59 <strlen+0x19>
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
80104f50:	83 c0 01             	add    $0x1,%eax
80104f53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104f57:	75 f7                	jne    80104f50 <strlen+0x10>
    ;
  return n;
}
80104f59:	5d                   	pop    %ebp
80104f5a:	c3                   	ret    

80104f5b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104f5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104f5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104f63:	55                   	push   %ebp
  pushl %ebx
80104f64:	53                   	push   %ebx
  pushl %esi
80104f65:	56                   	push   %esi
  pushl %edi
80104f66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104f67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104f69:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104f6b:	5f                   	pop    %edi
  popl %esi
80104f6c:	5e                   	pop    %esi
  popl %ebx
80104f6d:	5b                   	pop    %ebx
  popl %ebp
80104f6e:	5d                   	pop    %ebp
  ret
80104f6f:	c3                   	ret    

80104f70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104f70:	55                   	push   %ebp
80104f71:	89 e5                	mov    %esp,%ebp
80104f73:	53                   	push   %ebx
80104f74:	83 ec 04             	sub    $0x4,%esp
80104f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104f7a:	e8 b1 f0 ff ff       	call   80104030 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104f7f:	8b 00                	mov    (%eax),%eax
80104f81:	39 d8                	cmp    %ebx,%eax
80104f83:	76 1b                	jbe    80104fa0 <fetchint+0x30>
80104f85:	8d 53 04             	lea    0x4(%ebx),%edx
80104f88:	39 d0                	cmp    %edx,%eax
80104f8a:	72 14                	jb     80104fa0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f8f:	8b 13                	mov    (%ebx),%edx
80104f91:	89 10                	mov    %edx,(%eax)
  return 0;
80104f93:	31 c0                	xor    %eax,%eax
}
80104f95:	83 c4 04             	add    $0x4,%esp
80104f98:	5b                   	pop    %ebx
80104f99:	5d                   	pop    %ebp
80104f9a:	c3                   	ret    
80104f9b:	90                   	nop
80104f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa5:	eb ee                	jmp    80104f95 <fetchint+0x25>
80104fa7:	89 f6                	mov    %esi,%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	53                   	push   %ebx
80104fb4:	83 ec 04             	sub    $0x4,%esp
80104fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104fba:	e8 71 f0 ff ff       	call   80104030 <myproc>

  if(addr >= curproc->sz)
80104fbf:	39 18                	cmp    %ebx,(%eax)
80104fc1:	76 29                	jbe    80104fec <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104fc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104fc6:	89 da                	mov    %ebx,%edx
80104fc8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104fca:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104fcc:	39 c3                	cmp    %eax,%ebx
80104fce:	73 1c                	jae    80104fec <fetchstr+0x3c>
    if(*s == 0)
80104fd0:	80 3b 00             	cmpb   $0x0,(%ebx)
80104fd3:	75 10                	jne    80104fe5 <fetchstr+0x35>
80104fd5:	eb 39                	jmp    80105010 <fetchstr+0x60>
80104fd7:	89 f6                	mov    %esi,%esi
80104fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104fe0:	80 3a 00             	cmpb   $0x0,(%edx)
80104fe3:	74 1b                	je     80105000 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104fe5:	83 c2 01             	add    $0x1,%edx
80104fe8:	39 d0                	cmp    %edx,%eax
80104fea:	77 f4                	ja     80104fe0 <fetchstr+0x30>
    return -1;
80104fec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104ff1:	83 c4 04             	add    $0x4,%esp
80104ff4:	5b                   	pop    %ebx
80104ff5:	5d                   	pop    %ebp
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105000:	83 c4 04             	add    $0x4,%esp
80105003:	89 d0                	mov    %edx,%eax
80105005:	29 d8                	sub    %ebx,%eax
80105007:	5b                   	pop    %ebx
80105008:	5d                   	pop    %ebp
80105009:	c3                   	ret    
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80105010:	31 c0                	xor    %eax,%eax
      return s - *pp;
80105012:	eb dd                	jmp    80104ff1 <fetchstr+0x41>
80105014:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010501a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105020 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	56                   	push   %esi
80105024:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105025:	e8 06 f0 ff ff       	call   80104030 <myproc>
8010502a:	8b 40 18             	mov    0x18(%eax),%eax
8010502d:	8b 55 08             	mov    0x8(%ebp),%edx
80105030:	8b 40 44             	mov    0x44(%eax),%eax
80105033:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105036:	e8 f5 ef ff ff       	call   80104030 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010503b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010503d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105040:	39 c6                	cmp    %eax,%esi
80105042:	73 1c                	jae    80105060 <argint+0x40>
80105044:	8d 53 08             	lea    0x8(%ebx),%edx
80105047:	39 d0                	cmp    %edx,%eax
80105049:	72 15                	jb     80105060 <argint+0x40>
  *ip = *(int*)(addr);
8010504b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504e:	8b 53 04             	mov    0x4(%ebx),%edx
80105051:	89 10                	mov    %edx,(%eax)
  return 0;
80105053:	31 c0                	xor    %eax,%eax
}
80105055:	5b                   	pop    %ebx
80105056:	5e                   	pop    %esi
80105057:	5d                   	pop    %ebp
80105058:	c3                   	ret    
80105059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105065:	eb ee                	jmp    80105055 <argint+0x35>
80105067:	89 f6                	mov    %esi,%esi
80105069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105070 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	56                   	push   %esi
80105074:	53                   	push   %ebx
80105075:	83 ec 10             	sub    $0x10,%esp
80105078:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010507b:	e8 b0 ef ff ff       	call   80104030 <myproc>
80105080:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80105082:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105085:	83 ec 08             	sub    $0x8,%esp
80105088:	50                   	push   %eax
80105089:	ff 75 08             	pushl  0x8(%ebp)
8010508c:	e8 8f ff ff ff       	call   80105020 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105091:	83 c4 10             	add    $0x10,%esp
80105094:	85 c0                	test   %eax,%eax
80105096:	78 28                	js     801050c0 <argptr+0x50>
80105098:	85 db                	test   %ebx,%ebx
8010509a:	78 24                	js     801050c0 <argptr+0x50>
8010509c:	8b 16                	mov    (%esi),%edx
8010509e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a1:	39 c2                	cmp    %eax,%edx
801050a3:	76 1b                	jbe    801050c0 <argptr+0x50>
801050a5:	01 c3                	add    %eax,%ebx
801050a7:	39 da                	cmp    %ebx,%edx
801050a9:	72 15                	jb     801050c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801050ab:	8b 55 0c             	mov    0xc(%ebp),%edx
801050ae:	89 02                	mov    %eax,(%edx)
  return 0;
801050b0:	31 c0                	xor    %eax,%eax
}
801050b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050b5:	5b                   	pop    %ebx
801050b6:	5e                   	pop    %esi
801050b7:	5d                   	pop    %ebp
801050b8:	c3                   	ret    
801050b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c5:	eb eb                	jmp    801050b2 <argptr+0x42>
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801050d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050d9:	50                   	push   %eax
801050da:	ff 75 08             	pushl  0x8(%ebp)
801050dd:	e8 3e ff ff ff       	call   80105020 <argint>
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	85 c0                	test   %eax,%eax
801050e7:	78 17                	js     80105100 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801050e9:	83 ec 08             	sub    $0x8,%esp
801050ec:	ff 75 0c             	pushl  0xc(%ebp)
801050ef:	ff 75 f4             	pushl  -0xc(%ebp)
801050f2:	e8 b9 fe ff ff       	call   80104fb0 <fetchstr>
801050f7:	83 c4 10             	add    $0x10,%esp
}
801050fa:	c9                   	leave  
801050fb:	c3                   	ret    
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105105:	c9                   	leave  
80105106:	c3                   	ret    
80105107:	89 f6                	mov    %esi,%esi
80105109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105110 <syscall>:
[SYS_swapstat] sys_swapstat,
};

void
syscall(void)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	53                   	push   %ebx
80105114:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105117:	e8 14 ef ff ff       	call   80104030 <myproc>
8010511c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010511e:	8b 40 18             	mov    0x18(%eax),%eax
80105121:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105124:	8d 50 ff             	lea    -0x1(%eax),%edx
80105127:	83 fa 17             	cmp    $0x17,%edx
8010512a:	77 1c                	ja     80105148 <syscall+0x38>
8010512c:	8b 14 85 a0 81 10 80 	mov    -0x7fef7e60(,%eax,4),%edx
80105133:	85 d2                	test   %edx,%edx
80105135:	74 11                	je     80105148 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80105137:	ff d2                	call   *%edx
80105139:	8b 53 18             	mov    0x18(%ebx),%edx
8010513c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010513f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105142:	c9                   	leave  
80105143:	c3                   	ret    
80105144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105148:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105149:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010514c:	50                   	push   %eax
8010514d:	ff 73 10             	pushl  0x10(%ebx)
80105150:	68 81 81 10 80       	push   $0x80108181
80105155:	e8 06 b5 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010515a:	8b 43 18             	mov    0x18(%ebx),%eax
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80105167:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    
8010516c:	66 90                	xchg   %ax,%ax
8010516e:	66 90                	xchg   %ax,%ax

80105170 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	57                   	push   %edi
80105174:	56                   	push   %esi
80105175:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105176:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105179:	83 ec 44             	sub    $0x44,%esp
8010517c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010517f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105182:	56                   	push   %esi
80105183:	50                   	push   %eax
{
80105184:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80105187:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010518a:	e8 81 cd ff ff       	call   80101f10 <nameiparent>
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	85 c0                	test   %eax,%eax
80105194:	0f 84 46 01 00 00    	je     801052e0 <create+0x170>
    return 0;
  ilock(dp);
8010519a:	83 ec 0c             	sub    $0xc,%esp
8010519d:	89 c3                	mov    %eax,%ebx
8010519f:	50                   	push   %eax
801051a0:	e8 eb c4 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801051a5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801051a8:	83 c4 0c             	add    $0xc,%esp
801051ab:	50                   	push   %eax
801051ac:	56                   	push   %esi
801051ad:	53                   	push   %ebx
801051ae:	e8 0d ca ff ff       	call   80101bc0 <dirlookup>
801051b3:	83 c4 10             	add    $0x10,%esp
801051b6:	85 c0                	test   %eax,%eax
801051b8:	89 c7                	mov    %eax,%edi
801051ba:	74 34                	je     801051f0 <create+0x80>
    iunlockput(dp);
801051bc:	83 ec 0c             	sub    $0xc,%esp
801051bf:	53                   	push   %ebx
801051c0:	e8 5b c7 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
801051c5:	89 3c 24             	mov    %edi,(%esp)
801051c8:	e8 c3 c4 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801051cd:	83 c4 10             	add    $0x10,%esp
801051d0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801051d5:	0f 85 95 00 00 00    	jne    80105270 <create+0x100>
801051db:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801051e0:	0f 85 8a 00 00 00    	jne    80105270 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801051e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051e9:	89 f8                	mov    %edi,%eax
801051eb:	5b                   	pop    %ebx
801051ec:	5e                   	pop    %esi
801051ed:	5f                   	pop    %edi
801051ee:	5d                   	pop    %ebp
801051ef:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801051f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801051f4:	83 ec 08             	sub    $0x8,%esp
801051f7:	50                   	push   %eax
801051f8:	ff 33                	pushl  (%ebx)
801051fa:	e8 21 c3 ff ff       	call   80101520 <ialloc>
801051ff:	83 c4 10             	add    $0x10,%esp
80105202:	85 c0                	test   %eax,%eax
80105204:	89 c7                	mov    %eax,%edi
80105206:	0f 84 e8 00 00 00    	je     801052f4 <create+0x184>
  ilock(ip);
8010520c:	83 ec 0c             	sub    $0xc,%esp
8010520f:	50                   	push   %eax
80105210:	e8 7b c4 ff ff       	call   80101690 <ilock>
  ip->major = major;
80105215:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105219:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010521d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105221:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105225:	b8 01 00 00 00       	mov    $0x1,%eax
8010522a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010522e:	89 3c 24             	mov    %edi,(%esp)
80105231:	e8 aa c3 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105236:	83 c4 10             	add    $0x10,%esp
80105239:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010523e:	74 50                	je     80105290 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105240:	83 ec 04             	sub    $0x4,%esp
80105243:	ff 77 04             	pushl  0x4(%edi)
80105246:	56                   	push   %esi
80105247:	53                   	push   %ebx
80105248:	e8 e3 cb ff ff       	call   80101e30 <dirlink>
8010524d:	83 c4 10             	add    $0x10,%esp
80105250:	85 c0                	test   %eax,%eax
80105252:	0f 88 8f 00 00 00    	js     801052e7 <create+0x177>
  iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	53                   	push   %ebx
8010525c:	e8 bf c6 ff ff       	call   80101920 <iunlockput>
  return ip;
80105261:	83 c4 10             	add    $0x10,%esp
}
80105264:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105267:	89 f8                	mov    %edi,%eax
80105269:	5b                   	pop    %ebx
8010526a:	5e                   	pop    %esi
8010526b:	5f                   	pop    %edi
8010526c:	5d                   	pop    %ebp
8010526d:	c3                   	ret    
8010526e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	57                   	push   %edi
    return 0;
80105274:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80105276:	e8 a5 c6 ff ff       	call   80101920 <iunlockput>
    return 0;
8010527b:	83 c4 10             	add    $0x10,%esp
}
8010527e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105281:	89 f8                	mov    %edi,%eax
80105283:	5b                   	pop    %ebx
80105284:	5e                   	pop    %esi
80105285:	5f                   	pop    %edi
80105286:	5d                   	pop    %ebp
80105287:	c3                   	ret    
80105288:	90                   	nop
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80105290:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105295:	83 ec 0c             	sub    $0xc,%esp
80105298:	53                   	push   %ebx
80105299:	e8 42 c3 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010529e:	83 c4 0c             	add    $0xc,%esp
801052a1:	ff 77 04             	pushl  0x4(%edi)
801052a4:	68 20 82 10 80       	push   $0x80108220
801052a9:	57                   	push   %edi
801052aa:	e8 81 cb ff ff       	call   80101e30 <dirlink>
801052af:	83 c4 10             	add    $0x10,%esp
801052b2:	85 c0                	test   %eax,%eax
801052b4:	78 1c                	js     801052d2 <create+0x162>
801052b6:	83 ec 04             	sub    $0x4,%esp
801052b9:	ff 73 04             	pushl  0x4(%ebx)
801052bc:	68 1f 82 10 80       	push   $0x8010821f
801052c1:	57                   	push   %edi
801052c2:	e8 69 cb ff ff       	call   80101e30 <dirlink>
801052c7:	83 c4 10             	add    $0x10,%esp
801052ca:	85 c0                	test   %eax,%eax
801052cc:	0f 89 6e ff ff ff    	jns    80105240 <create+0xd0>
      panic("create dots");
801052d2:	83 ec 0c             	sub    $0xc,%esp
801052d5:	68 13 82 10 80       	push   $0x80108213
801052da:	e8 b1 b0 ff ff       	call   80100390 <panic>
801052df:	90                   	nop
    return 0;
801052e0:	31 ff                	xor    %edi,%edi
801052e2:	e9 ff fe ff ff       	jmp    801051e6 <create+0x76>
    panic("create: dirlink");
801052e7:	83 ec 0c             	sub    $0xc,%esp
801052ea:	68 22 82 10 80       	push   $0x80108222
801052ef:	e8 9c b0 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801052f4:	83 ec 0c             	sub    $0xc,%esp
801052f7:	68 04 82 10 80       	push   $0x80108204
801052fc:	e8 8f b0 ff ff       	call   80100390 <panic>
80105301:	eb 0d                	jmp    80105310 <argfd.constprop.0>
80105303:	90                   	nop
80105304:	90                   	nop
80105305:	90                   	nop
80105306:	90                   	nop
80105307:	90                   	nop
80105308:	90                   	nop
80105309:	90                   	nop
8010530a:	90                   	nop
8010530b:	90                   	nop
8010530c:	90                   	nop
8010530d:	90                   	nop
8010530e:	90                   	nop
8010530f:	90                   	nop

80105310 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	56                   	push   %esi
80105314:	53                   	push   %ebx
80105315:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105317:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010531a:	89 d6                	mov    %edx,%esi
8010531c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010531f:	50                   	push   %eax
80105320:	6a 00                	push   $0x0
80105322:	e8 f9 fc ff ff       	call   80105020 <argint>
80105327:	83 c4 10             	add    $0x10,%esp
8010532a:	85 c0                	test   %eax,%eax
8010532c:	78 2a                	js     80105358 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010532e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105332:	77 24                	ja     80105358 <argfd.constprop.0+0x48>
80105334:	e8 f7 ec ff ff       	call   80104030 <myproc>
80105339:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010533c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105340:	85 c0                	test   %eax,%eax
80105342:	74 14                	je     80105358 <argfd.constprop.0+0x48>
  if(pfd)
80105344:	85 db                	test   %ebx,%ebx
80105346:	74 02                	je     8010534a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105348:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010534a:	89 06                	mov    %eax,(%esi)
  return 0;
8010534c:	31 c0                	xor    %eax,%eax
}
8010534e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105351:	5b                   	pop    %ebx
80105352:	5e                   	pop    %esi
80105353:	5d                   	pop    %ebp
80105354:	c3                   	ret    
80105355:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010535d:	eb ef                	jmp    8010534e <argfd.constprop.0+0x3e>
8010535f:	90                   	nop

80105360 <sys_dup>:
{
80105360:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105361:	31 c0                	xor    %eax,%eax
{
80105363:	89 e5                	mov    %esp,%ebp
80105365:	56                   	push   %esi
80105366:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80105367:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010536a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
8010536d:	e8 9e ff ff ff       	call   80105310 <argfd.constprop.0>
80105372:	85 c0                	test   %eax,%eax
80105374:	78 42                	js     801053b8 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80105376:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105379:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010537b:	e8 b0 ec ff ff       	call   80104030 <myproc>
80105380:	eb 0e                	jmp    80105390 <sys_dup+0x30>
80105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105388:	83 c3 01             	add    $0x1,%ebx
8010538b:	83 fb 10             	cmp    $0x10,%ebx
8010538e:	74 28                	je     801053b8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80105390:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105394:	85 d2                	test   %edx,%edx
80105396:	75 f0                	jne    80105388 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80105398:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
8010539c:	83 ec 0c             	sub    $0xc,%esp
8010539f:	ff 75 f4             	pushl  -0xc(%ebp)
801053a2:	e8 49 ba ff ff       	call   80100df0 <filedup>
  return fd;
801053a7:	83 c4 10             	add    $0x10,%esp
}
801053aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801053ad:	89 d8                	mov    %ebx,%eax
801053af:	5b                   	pop    %ebx
801053b0:	5e                   	pop    %esi
801053b1:	5d                   	pop    %ebp
801053b2:	c3                   	ret    
801053b3:	90                   	nop
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801053bb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801053c0:	89 d8                	mov    %ebx,%eax
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5d                   	pop    %ebp
801053c5:	c3                   	ret    
801053c6:	8d 76 00             	lea    0x0(%esi),%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <sys_read>:
{
801053d0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053d1:	31 c0                	xor    %eax,%eax
{
801053d3:	89 e5                	mov    %esp,%ebp
801053d5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801053d8:	8d 55 ec             	lea    -0x14(%ebp),%edx
801053db:	e8 30 ff ff ff       	call   80105310 <argfd.constprop.0>
801053e0:	85 c0                	test   %eax,%eax
801053e2:	78 4c                	js     80105430 <sys_read+0x60>
801053e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053e7:	83 ec 08             	sub    $0x8,%esp
801053ea:	50                   	push   %eax
801053eb:	6a 02                	push   $0x2
801053ed:	e8 2e fc ff ff       	call   80105020 <argint>
801053f2:	83 c4 10             	add    $0x10,%esp
801053f5:	85 c0                	test   %eax,%eax
801053f7:	78 37                	js     80105430 <sys_read+0x60>
801053f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053fc:	83 ec 04             	sub    $0x4,%esp
801053ff:	ff 75 f0             	pushl  -0x10(%ebp)
80105402:	50                   	push   %eax
80105403:	6a 01                	push   $0x1
80105405:	e8 66 fc ff ff       	call   80105070 <argptr>
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	85 c0                	test   %eax,%eax
8010540f:	78 1f                	js     80105430 <sys_read+0x60>
  return fileread(f, p, n);
80105411:	83 ec 04             	sub    $0x4,%esp
80105414:	ff 75 f0             	pushl  -0x10(%ebp)
80105417:	ff 75 f4             	pushl  -0xc(%ebp)
8010541a:	ff 75 ec             	pushl  -0x14(%ebp)
8010541d:	e8 3e bb ff ff       	call   80100f60 <fileread>
80105422:	83 c4 10             	add    $0x10,%esp
}
80105425:	c9                   	leave  
80105426:	c3                   	ret    
80105427:	89 f6                	mov    %esi,%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105435:	c9                   	leave  
80105436:	c3                   	ret    
80105437:	89 f6                	mov    %esi,%esi
80105439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105440 <sys_write>:
{
80105440:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105441:	31 c0                	xor    %eax,%eax
{
80105443:	89 e5                	mov    %esp,%ebp
80105445:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105448:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010544b:	e8 c0 fe ff ff       	call   80105310 <argfd.constprop.0>
80105450:	85 c0                	test   %eax,%eax
80105452:	78 4c                	js     801054a0 <sys_write+0x60>
80105454:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105457:	83 ec 08             	sub    $0x8,%esp
8010545a:	50                   	push   %eax
8010545b:	6a 02                	push   $0x2
8010545d:	e8 be fb ff ff       	call   80105020 <argint>
80105462:	83 c4 10             	add    $0x10,%esp
80105465:	85 c0                	test   %eax,%eax
80105467:	78 37                	js     801054a0 <sys_write+0x60>
80105469:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010546c:	83 ec 04             	sub    $0x4,%esp
8010546f:	ff 75 f0             	pushl  -0x10(%ebp)
80105472:	50                   	push   %eax
80105473:	6a 01                	push   $0x1
80105475:	e8 f6 fb ff ff       	call   80105070 <argptr>
8010547a:	83 c4 10             	add    $0x10,%esp
8010547d:	85 c0                	test   %eax,%eax
8010547f:	78 1f                	js     801054a0 <sys_write+0x60>
  return filewrite(f, p, n);
80105481:	83 ec 04             	sub    $0x4,%esp
80105484:	ff 75 f0             	pushl  -0x10(%ebp)
80105487:	ff 75 f4             	pushl  -0xc(%ebp)
8010548a:	ff 75 ec             	pushl  -0x14(%ebp)
8010548d:	e8 5e bb ff ff       	call   80100ff0 <filewrite>
80105492:	83 c4 10             	add    $0x10,%esp
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    
80105497:	89 f6                	mov    %esi,%esi
80105499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_close>:
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801054b6:	8d 55 f4             	lea    -0xc(%ebp),%edx
801054b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054bc:	e8 4f fe ff ff       	call   80105310 <argfd.constprop.0>
801054c1:	85 c0                	test   %eax,%eax
801054c3:	78 2b                	js     801054f0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801054c5:	e8 66 eb ff ff       	call   80104030 <myproc>
801054ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801054cd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801054d0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801054d7:	00 
  fileclose(f);
801054d8:	ff 75 f4             	pushl  -0xc(%ebp)
801054db:	e8 60 b9 ff ff       	call   80100e40 <fileclose>
  return 0;
801054e0:	83 c4 10             	add    $0x10,%esp
801054e3:	31 c0                	xor    %eax,%eax
}
801054e5:	c9                   	leave  
801054e6:	c3                   	ret    
801054e7:	89 f6                	mov    %esi,%esi
801054e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801054f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054f5:	c9                   	leave  
801054f6:	c3                   	ret    
801054f7:	89 f6                	mov    %esi,%esi
801054f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105500 <sys_fstat>:
{
80105500:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105501:	31 c0                	xor    %eax,%eax
{
80105503:	89 e5                	mov    %esp,%ebp
80105505:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105508:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010550b:	e8 00 fe ff ff       	call   80105310 <argfd.constprop.0>
80105510:	85 c0                	test   %eax,%eax
80105512:	78 2c                	js     80105540 <sys_fstat+0x40>
80105514:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105517:	83 ec 04             	sub    $0x4,%esp
8010551a:	6a 14                	push   $0x14
8010551c:	50                   	push   %eax
8010551d:	6a 01                	push   $0x1
8010551f:	e8 4c fb ff ff       	call   80105070 <argptr>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	85 c0                	test   %eax,%eax
80105529:	78 15                	js     80105540 <sys_fstat+0x40>
  return filestat(f, st);
8010552b:	83 ec 08             	sub    $0x8,%esp
8010552e:	ff 75 f4             	pushl  -0xc(%ebp)
80105531:	ff 75 f0             	pushl  -0x10(%ebp)
80105534:	e8 d7 b9 ff ff       	call   80100f10 <filestat>
80105539:	83 c4 10             	add    $0x10,%esp
}
8010553c:	c9                   	leave  
8010553d:	c3                   	ret    
8010553e:	66 90                	xchg   %ax,%ax
    return -1;
80105540:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105545:	c9                   	leave  
80105546:	c3                   	ret    
80105547:	89 f6                	mov    %esi,%esi
80105549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105550 <sys_link>:
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
80105555:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105556:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105559:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010555c:	50                   	push   %eax
8010555d:	6a 00                	push   $0x0
8010555f:	e8 6c fb ff ff       	call   801050d0 <argstr>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	0f 88 fb 00 00 00    	js     8010566a <sys_link+0x11a>
8010556f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105572:	83 ec 08             	sub    $0x8,%esp
80105575:	50                   	push   %eax
80105576:	6a 01                	push   $0x1
80105578:	e8 53 fb ff ff       	call   801050d0 <argstr>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	0f 88 e2 00 00 00    	js     8010566a <sys_link+0x11a>
  begin_op();
80105588:	e8 63 de ff ff       	call   801033f0 <begin_op>
  if((ip = namei(old)) == 0){
8010558d:	83 ec 0c             	sub    $0xc,%esp
80105590:	ff 75 d4             	pushl  -0x2c(%ebp)
80105593:	e8 58 c9 ff ff       	call   80101ef0 <namei>
80105598:	83 c4 10             	add    $0x10,%esp
8010559b:	85 c0                	test   %eax,%eax
8010559d:	89 c3                	mov    %eax,%ebx
8010559f:	0f 84 ea 00 00 00    	je     8010568f <sys_link+0x13f>
  ilock(ip);
801055a5:	83 ec 0c             	sub    $0xc,%esp
801055a8:	50                   	push   %eax
801055a9:	e8 e2 c0 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
801055ae:	83 c4 10             	add    $0x10,%esp
801055b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801055b6:	0f 84 bb 00 00 00    	je     80105677 <sys_link+0x127>
  ip->nlink++;
801055bc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801055c1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
801055c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801055c7:	53                   	push   %ebx
801055c8:	e8 13 c0 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
801055cd:	89 1c 24             	mov    %ebx,(%esp)
801055d0:	e8 9b c1 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801055d5:	58                   	pop    %eax
801055d6:	5a                   	pop    %edx
801055d7:	57                   	push   %edi
801055d8:	ff 75 d0             	pushl  -0x30(%ebp)
801055db:	e8 30 c9 ff ff       	call   80101f10 <nameiparent>
801055e0:	83 c4 10             	add    $0x10,%esp
801055e3:	85 c0                	test   %eax,%eax
801055e5:	89 c6                	mov    %eax,%esi
801055e7:	74 5b                	je     80105644 <sys_link+0xf4>
  ilock(dp);
801055e9:	83 ec 0c             	sub    $0xc,%esp
801055ec:	50                   	push   %eax
801055ed:	e8 9e c0 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	8b 03                	mov    (%ebx),%eax
801055f7:	39 06                	cmp    %eax,(%esi)
801055f9:	75 3d                	jne    80105638 <sys_link+0xe8>
801055fb:	83 ec 04             	sub    $0x4,%esp
801055fe:	ff 73 04             	pushl  0x4(%ebx)
80105601:	57                   	push   %edi
80105602:	56                   	push   %esi
80105603:	e8 28 c8 ff ff       	call   80101e30 <dirlink>
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	85 c0                	test   %eax,%eax
8010560d:	78 29                	js     80105638 <sys_link+0xe8>
  iunlockput(dp);
8010560f:	83 ec 0c             	sub    $0xc,%esp
80105612:	56                   	push   %esi
80105613:	e8 08 c3 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105618:	89 1c 24             	mov    %ebx,(%esp)
8010561b:	e8 a0 c1 ff ff       	call   801017c0 <iput>
  end_op();
80105620:	e8 3b de ff ff       	call   80103460 <end_op>
  return 0;
80105625:	83 c4 10             	add    $0x10,%esp
80105628:	31 c0                	xor    %eax,%eax
}
8010562a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010562d:	5b                   	pop    %ebx
8010562e:	5e                   	pop    %esi
8010562f:	5f                   	pop    %edi
80105630:	5d                   	pop    %ebp
80105631:	c3                   	ret    
80105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	56                   	push   %esi
8010563c:	e8 df c2 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105641:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105644:	83 ec 0c             	sub    $0xc,%esp
80105647:	53                   	push   %ebx
80105648:	e8 43 c0 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010564d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105652:	89 1c 24             	mov    %ebx,(%esp)
80105655:	e8 86 bf ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010565a:	89 1c 24             	mov    %ebx,(%esp)
8010565d:	e8 be c2 ff ff       	call   80101920 <iunlockput>
  end_op();
80105662:	e8 f9 dd ff ff       	call   80103460 <end_op>
  return -1;
80105667:	83 c4 10             	add    $0x10,%esp
}
8010566a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010566d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105672:	5b                   	pop    %ebx
80105673:	5e                   	pop    %esi
80105674:	5f                   	pop    %edi
80105675:	5d                   	pop    %ebp
80105676:	c3                   	ret    
    iunlockput(ip);
80105677:	83 ec 0c             	sub    $0xc,%esp
8010567a:	53                   	push   %ebx
8010567b:	e8 a0 c2 ff ff       	call   80101920 <iunlockput>
    end_op();
80105680:	e8 db dd ff ff       	call   80103460 <end_op>
    return -1;
80105685:	83 c4 10             	add    $0x10,%esp
80105688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568d:	eb 9b                	jmp    8010562a <sys_link+0xda>
    end_op();
8010568f:	e8 cc dd ff ff       	call   80103460 <end_op>
    return -1;
80105694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105699:	eb 8f                	jmp    8010562a <sys_link+0xda>
8010569b:	90                   	nop
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_unlink>:
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
801056a5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801056a6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801056a9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801056ac:	50                   	push   %eax
801056ad:	6a 00                	push   $0x0
801056af:	e8 1c fa ff ff       	call   801050d0 <argstr>
801056b4:	83 c4 10             	add    $0x10,%esp
801056b7:	85 c0                	test   %eax,%eax
801056b9:	0f 88 77 01 00 00    	js     80105836 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
801056bf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
801056c2:	e8 29 dd ff ff       	call   801033f0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801056c7:	83 ec 08             	sub    $0x8,%esp
801056ca:	53                   	push   %ebx
801056cb:	ff 75 c0             	pushl  -0x40(%ebp)
801056ce:	e8 3d c8 ff ff       	call   80101f10 <nameiparent>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	89 c6                	mov    %eax,%esi
801056da:	0f 84 60 01 00 00    	je     80105840 <sys_unlink+0x1a0>
  ilock(dp);
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	50                   	push   %eax
801056e4:	e8 a7 bf ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801056e9:	58                   	pop    %eax
801056ea:	5a                   	pop    %edx
801056eb:	68 20 82 10 80       	push   $0x80108220
801056f0:	53                   	push   %ebx
801056f1:	e8 aa c4 ff ff       	call   80101ba0 <namecmp>
801056f6:	83 c4 10             	add    $0x10,%esp
801056f9:	85 c0                	test   %eax,%eax
801056fb:	0f 84 03 01 00 00    	je     80105804 <sys_unlink+0x164>
80105701:	83 ec 08             	sub    $0x8,%esp
80105704:	68 1f 82 10 80       	push   $0x8010821f
80105709:	53                   	push   %ebx
8010570a:	e8 91 c4 ff ff       	call   80101ba0 <namecmp>
8010570f:	83 c4 10             	add    $0x10,%esp
80105712:	85 c0                	test   %eax,%eax
80105714:	0f 84 ea 00 00 00    	je     80105804 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010571a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010571d:	83 ec 04             	sub    $0x4,%esp
80105720:	50                   	push   %eax
80105721:	53                   	push   %ebx
80105722:	56                   	push   %esi
80105723:	e8 98 c4 ff ff       	call   80101bc0 <dirlookup>
80105728:	83 c4 10             	add    $0x10,%esp
8010572b:	85 c0                	test   %eax,%eax
8010572d:	89 c3                	mov    %eax,%ebx
8010572f:	0f 84 cf 00 00 00    	je     80105804 <sys_unlink+0x164>
  ilock(ip);
80105735:	83 ec 0c             	sub    $0xc,%esp
80105738:	50                   	push   %eax
80105739:	e8 52 bf ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
8010573e:	83 c4 10             	add    $0x10,%esp
80105741:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105746:	0f 8e 10 01 00 00    	jle    8010585c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010574c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105751:	74 6d                	je     801057c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105753:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105756:	83 ec 04             	sub    $0x4,%esp
80105759:	6a 10                	push   $0x10
8010575b:	6a 00                	push   $0x0
8010575d:	50                   	push   %eax
8010575e:	e8 bd f5 ff ff       	call   80104d20 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105763:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105766:	6a 10                	push   $0x10
80105768:	ff 75 c4             	pushl  -0x3c(%ebp)
8010576b:	50                   	push   %eax
8010576c:	56                   	push   %esi
8010576d:	e8 fe c2 ff ff       	call   80101a70 <writei>
80105772:	83 c4 20             	add    $0x20,%esp
80105775:	83 f8 10             	cmp    $0x10,%eax
80105778:	0f 85 eb 00 00 00    	jne    80105869 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
8010577e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105783:	0f 84 97 00 00 00    	je     80105820 <sys_unlink+0x180>
  iunlockput(dp);
80105789:	83 ec 0c             	sub    $0xc,%esp
8010578c:	56                   	push   %esi
8010578d:	e8 8e c1 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105792:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105797:	89 1c 24             	mov    %ebx,(%esp)
8010579a:	e8 41 be ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010579f:	89 1c 24             	mov    %ebx,(%esp)
801057a2:	e8 79 c1 ff ff       	call   80101920 <iunlockput>
  end_op();
801057a7:	e8 b4 dc ff ff       	call   80103460 <end_op>
  return 0;
801057ac:	83 c4 10             	add    $0x10,%esp
801057af:	31 c0                	xor    %eax,%eax
}
801057b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b4:	5b                   	pop    %ebx
801057b5:	5e                   	pop    %esi
801057b6:	5f                   	pop    %edi
801057b7:	5d                   	pop    %ebp
801057b8:	c3                   	ret    
801057b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801057c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801057c4:	76 8d                	jbe    80105753 <sys_unlink+0xb3>
801057c6:	bf 20 00 00 00       	mov    $0x20,%edi
801057cb:	eb 0f                	jmp    801057dc <sys_unlink+0x13c>
801057cd:	8d 76 00             	lea    0x0(%esi),%esi
801057d0:	83 c7 10             	add    $0x10,%edi
801057d3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801057d6:	0f 83 77 ff ff ff    	jae    80105753 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801057dc:	8d 45 d8             	lea    -0x28(%ebp),%eax
801057df:	6a 10                	push   $0x10
801057e1:	57                   	push   %edi
801057e2:	50                   	push   %eax
801057e3:	53                   	push   %ebx
801057e4:	e8 87 c1 ff ff       	call   80101970 <readi>
801057e9:	83 c4 10             	add    $0x10,%esp
801057ec:	83 f8 10             	cmp    $0x10,%eax
801057ef:	75 5e                	jne    8010584f <sys_unlink+0x1af>
    if(de.inum != 0)
801057f1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801057f6:	74 d8                	je     801057d0 <sys_unlink+0x130>
    iunlockput(ip);
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	53                   	push   %ebx
801057fc:	e8 1f c1 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105801:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105804:	83 ec 0c             	sub    $0xc,%esp
80105807:	56                   	push   %esi
80105808:	e8 13 c1 ff ff       	call   80101920 <iunlockput>
  end_op();
8010580d:	e8 4e dc ff ff       	call   80103460 <end_op>
  return -1;
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010581a:	eb 95                	jmp    801057b1 <sys_unlink+0x111>
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105820:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105825:	83 ec 0c             	sub    $0xc,%esp
80105828:	56                   	push   %esi
80105829:	e8 b2 bd ff ff       	call   801015e0 <iupdate>
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	e9 53 ff ff ff       	jmp    80105789 <sys_unlink+0xe9>
    return -1;
80105836:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583b:	e9 71 ff ff ff       	jmp    801057b1 <sys_unlink+0x111>
    end_op();
80105840:	e8 1b dc ff ff       	call   80103460 <end_op>
    return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584a:	e9 62 ff ff ff       	jmp    801057b1 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010584f:	83 ec 0c             	sub    $0xc,%esp
80105852:	68 44 82 10 80       	push   $0x80108244
80105857:	e8 34 ab ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010585c:	83 ec 0c             	sub    $0xc,%esp
8010585f:	68 32 82 10 80       	push   $0x80108232
80105864:	e8 27 ab ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105869:	83 ec 0c             	sub    $0xc,%esp
8010586c:	68 56 82 10 80       	push   $0x80108256
80105871:	e8 1a ab ff ff       	call   80100390 <panic>
80105876:	8d 76 00             	lea    0x0(%esi),%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105880 <sys_open>:

int
sys_open(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	57                   	push   %edi
80105884:	56                   	push   %esi
80105885:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105886:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105889:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010588c:	50                   	push   %eax
8010588d:	6a 00                	push   $0x0
8010588f:	e8 3c f8 ff ff       	call   801050d0 <argstr>
80105894:	83 c4 10             	add    $0x10,%esp
80105897:	85 c0                	test   %eax,%eax
80105899:	0f 88 1d 01 00 00    	js     801059bc <sys_open+0x13c>
8010589f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801058a2:	83 ec 08             	sub    $0x8,%esp
801058a5:	50                   	push   %eax
801058a6:	6a 01                	push   $0x1
801058a8:	e8 73 f7 ff ff       	call   80105020 <argint>
801058ad:	83 c4 10             	add    $0x10,%esp
801058b0:	85 c0                	test   %eax,%eax
801058b2:	0f 88 04 01 00 00    	js     801059bc <sys_open+0x13c>
    return -1;

  begin_op();
801058b8:	e8 33 db ff ff       	call   801033f0 <begin_op>

  if(omode & O_CREATE){
801058bd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801058c1:	0f 85 a9 00 00 00    	jne    80105970 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801058c7:	83 ec 0c             	sub    $0xc,%esp
801058ca:	ff 75 e0             	pushl  -0x20(%ebp)
801058cd:	e8 1e c6 ff ff       	call   80101ef0 <namei>
801058d2:	83 c4 10             	add    $0x10,%esp
801058d5:	85 c0                	test   %eax,%eax
801058d7:	89 c6                	mov    %eax,%esi
801058d9:	0f 84 b2 00 00 00    	je     80105991 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
801058df:	83 ec 0c             	sub    $0xc,%esp
801058e2:	50                   	push   %eax
801058e3:	e8 a8 bd ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801058f0:	0f 84 aa 00 00 00    	je     801059a0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801058f6:	e8 85 b4 ff ff       	call   80100d80 <filealloc>
801058fb:	85 c0                	test   %eax,%eax
801058fd:	89 c7                	mov    %eax,%edi
801058ff:	0f 84 a6 00 00 00    	je     801059ab <sys_open+0x12b>
  struct proc *curproc = myproc();
80105905:	e8 26 e7 ff ff       	call   80104030 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010590a:	31 db                	xor    %ebx,%ebx
8010590c:	eb 0e                	jmp    8010591c <sys_open+0x9c>
8010590e:	66 90                	xchg   %ax,%ax
80105910:	83 c3 01             	add    $0x1,%ebx
80105913:	83 fb 10             	cmp    $0x10,%ebx
80105916:	0f 84 ac 00 00 00    	je     801059c8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010591c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105920:	85 d2                	test   %edx,%edx
80105922:	75 ec                	jne    80105910 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105924:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105927:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010592b:	56                   	push   %esi
8010592c:	e8 3f be ff ff       	call   80101770 <iunlock>
  end_op();
80105931:	e8 2a db ff ff       	call   80103460 <end_op>

  f->type = FD_INODE;
80105936:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010593c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010593f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105942:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105945:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010594c:	89 d0                	mov    %edx,%eax
8010594e:	f7 d0                	not    %eax
80105950:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105953:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105956:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105959:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010595d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105960:	89 d8                	mov    %ebx,%eax
80105962:	5b                   	pop    %ebx
80105963:	5e                   	pop    %esi
80105964:	5f                   	pop    %edi
80105965:	5d                   	pop    %ebp
80105966:	c3                   	ret    
80105967:	89 f6                	mov    %esi,%esi
80105969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105970:	83 ec 0c             	sub    $0xc,%esp
80105973:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105976:	31 c9                	xor    %ecx,%ecx
80105978:	6a 00                	push   $0x0
8010597a:	ba 02 00 00 00       	mov    $0x2,%edx
8010597f:	e8 ec f7 ff ff       	call   80105170 <create>
    if(ip == 0){
80105984:	83 c4 10             	add    $0x10,%esp
80105987:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105989:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010598b:	0f 85 65 ff ff ff    	jne    801058f6 <sys_open+0x76>
      end_op();
80105991:	e8 ca da ff ff       	call   80103460 <end_op>
      return -1;
80105996:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010599b:	eb c0                	jmp    8010595d <sys_open+0xdd>
8010599d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801059a0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801059a3:	85 c9                	test   %ecx,%ecx
801059a5:	0f 84 4b ff ff ff    	je     801058f6 <sys_open+0x76>
    iunlockput(ip);
801059ab:	83 ec 0c             	sub    $0xc,%esp
801059ae:	56                   	push   %esi
801059af:	e8 6c bf ff ff       	call   80101920 <iunlockput>
    end_op();
801059b4:	e8 a7 da ff ff       	call   80103460 <end_op>
    return -1;
801059b9:	83 c4 10             	add    $0x10,%esp
801059bc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801059c1:	eb 9a                	jmp    8010595d <sys_open+0xdd>
801059c3:	90                   	nop
801059c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801059c8:	83 ec 0c             	sub    $0xc,%esp
801059cb:	57                   	push   %edi
801059cc:	e8 6f b4 ff ff       	call   80100e40 <fileclose>
801059d1:	83 c4 10             	add    $0x10,%esp
801059d4:	eb d5                	jmp    801059ab <sys_open+0x12b>
801059d6:	8d 76 00             	lea    0x0(%esi),%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801059e6:	e8 05 da ff ff       	call   801033f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801059eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ee:	83 ec 08             	sub    $0x8,%esp
801059f1:	50                   	push   %eax
801059f2:	6a 00                	push   $0x0
801059f4:	e8 d7 f6 ff ff       	call   801050d0 <argstr>
801059f9:	83 c4 10             	add    $0x10,%esp
801059fc:	85 c0                	test   %eax,%eax
801059fe:	78 30                	js     80105a30 <sys_mkdir+0x50>
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a06:	31 c9                	xor    %ecx,%ecx
80105a08:	6a 00                	push   $0x0
80105a0a:	ba 01 00 00 00       	mov    $0x1,%edx
80105a0f:	e8 5c f7 ff ff       	call   80105170 <create>
80105a14:	83 c4 10             	add    $0x10,%esp
80105a17:	85 c0                	test   %eax,%eax
80105a19:	74 15                	je     80105a30 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105a1b:	83 ec 0c             	sub    $0xc,%esp
80105a1e:	50                   	push   %eax
80105a1f:	e8 fc be ff ff       	call   80101920 <iunlockput>
  end_op();
80105a24:	e8 37 da ff ff       	call   80103460 <end_op>
  return 0;
80105a29:	83 c4 10             	add    $0x10,%esp
80105a2c:	31 c0                	xor    %eax,%eax
}
80105a2e:	c9                   	leave  
80105a2f:	c3                   	ret    
    end_op();
80105a30:	e8 2b da ff ff       	call   80103460 <end_op>
    return -1;
80105a35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a3a:	c9                   	leave  
80105a3b:	c3                   	ret    
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_mknod>:

int
sys_mknod(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
80105a43:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105a46:	e8 a5 d9 ff ff       	call   801033f0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105a4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105a4e:	83 ec 08             	sub    $0x8,%esp
80105a51:	50                   	push   %eax
80105a52:	6a 00                	push   $0x0
80105a54:	e8 77 f6 ff ff       	call   801050d0 <argstr>
80105a59:	83 c4 10             	add    $0x10,%esp
80105a5c:	85 c0                	test   %eax,%eax
80105a5e:	78 60                	js     80105ac0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105a60:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a63:	83 ec 08             	sub    $0x8,%esp
80105a66:	50                   	push   %eax
80105a67:	6a 01                	push   $0x1
80105a69:	e8 b2 f5 ff ff       	call   80105020 <argint>
  if((argstr(0, &path)) < 0 ||
80105a6e:	83 c4 10             	add    $0x10,%esp
80105a71:	85 c0                	test   %eax,%eax
80105a73:	78 4b                	js     80105ac0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105a75:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a78:	83 ec 08             	sub    $0x8,%esp
80105a7b:	50                   	push   %eax
80105a7c:	6a 02                	push   $0x2
80105a7e:	e8 9d f5 ff ff       	call   80105020 <argint>
     argint(1, &major) < 0 ||
80105a83:	83 c4 10             	add    $0x10,%esp
80105a86:	85 c0                	test   %eax,%eax
80105a88:	78 36                	js     80105ac0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a8a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105a8e:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80105a91:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80105a95:	ba 03 00 00 00       	mov    $0x3,%edx
80105a9a:	50                   	push   %eax
80105a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105a9e:	e8 cd f6 ff ff       	call   80105170 <create>
80105aa3:	83 c4 10             	add    $0x10,%esp
80105aa6:	85 c0                	test   %eax,%eax
80105aa8:	74 16                	je     80105ac0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105aaa:	83 ec 0c             	sub    $0xc,%esp
80105aad:	50                   	push   %eax
80105aae:	e8 6d be ff ff       	call   80101920 <iunlockput>
  end_op();
80105ab3:	e8 a8 d9 ff ff       	call   80103460 <end_op>
  return 0;
80105ab8:	83 c4 10             	add    $0x10,%esp
80105abb:	31 c0                	xor    %eax,%eax
}
80105abd:	c9                   	leave  
80105abe:	c3                   	ret    
80105abf:	90                   	nop
    end_op();
80105ac0:	e8 9b d9 ff ff       	call   80103460 <end_op>
    return -1;
80105ac5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105aca:	c9                   	leave  
80105acb:	c3                   	ret    
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_chdir>:

int
sys_chdir(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	56                   	push   %esi
80105ad4:	53                   	push   %ebx
80105ad5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ad8:	e8 53 e5 ff ff       	call   80104030 <myproc>
80105add:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105adf:	e8 0c d9 ff ff       	call   801033f0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae7:	83 ec 08             	sub    $0x8,%esp
80105aea:	50                   	push   %eax
80105aeb:	6a 00                	push   $0x0
80105aed:	e8 de f5 ff ff       	call   801050d0 <argstr>
80105af2:	83 c4 10             	add    $0x10,%esp
80105af5:	85 c0                	test   %eax,%eax
80105af7:	78 77                	js     80105b70 <sys_chdir+0xa0>
80105af9:	83 ec 0c             	sub    $0xc,%esp
80105afc:	ff 75 f4             	pushl  -0xc(%ebp)
80105aff:	e8 ec c3 ff ff       	call   80101ef0 <namei>
80105b04:	83 c4 10             	add    $0x10,%esp
80105b07:	85 c0                	test   %eax,%eax
80105b09:	89 c3                	mov    %eax,%ebx
80105b0b:	74 63                	je     80105b70 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	50                   	push   %eax
80105b11:	e8 7a bb ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105b16:	83 c4 10             	add    $0x10,%esp
80105b19:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b1e:	75 30                	jne    80105b50 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105b20:	83 ec 0c             	sub    $0xc,%esp
80105b23:	53                   	push   %ebx
80105b24:	e8 47 bc ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105b29:	58                   	pop    %eax
80105b2a:	ff 76 68             	pushl  0x68(%esi)
80105b2d:	e8 8e bc ff ff       	call   801017c0 <iput>
  end_op();
80105b32:	e8 29 d9 ff ff       	call   80103460 <end_op>
  curproc->cwd = ip;
80105b37:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	31 c0                	xor    %eax,%eax
}
80105b3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105b42:	5b                   	pop    %ebx
80105b43:	5e                   	pop    %esi
80105b44:	5d                   	pop    %ebp
80105b45:	c3                   	ret    
80105b46:	8d 76 00             	lea    0x0(%esi),%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105b50:	83 ec 0c             	sub    $0xc,%esp
80105b53:	53                   	push   %ebx
80105b54:	e8 c7 bd ff ff       	call   80101920 <iunlockput>
    end_op();
80105b59:	e8 02 d9 ff ff       	call   80103460 <end_op>
    return -1;
80105b5e:	83 c4 10             	add    $0x10,%esp
80105b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b66:	eb d7                	jmp    80105b3f <sys_chdir+0x6f>
80105b68:	90                   	nop
80105b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b70:	e8 eb d8 ff ff       	call   80103460 <end_op>
    return -1;
80105b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b7a:	eb c3                	jmp    80105b3f <sys_chdir+0x6f>
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b80 <sys_exec>:

int
sys_exec(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b86:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105b8c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105b92:	50                   	push   %eax
80105b93:	6a 00                	push   $0x0
80105b95:	e8 36 f5 ff ff       	call   801050d0 <argstr>
80105b9a:	83 c4 10             	add    $0x10,%esp
80105b9d:	85 c0                	test   %eax,%eax
80105b9f:	0f 88 87 00 00 00    	js     80105c2c <sys_exec+0xac>
80105ba5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105bab:	83 ec 08             	sub    $0x8,%esp
80105bae:	50                   	push   %eax
80105baf:	6a 01                	push   $0x1
80105bb1:	e8 6a f4 ff ff       	call   80105020 <argint>
80105bb6:	83 c4 10             	add    $0x10,%esp
80105bb9:	85 c0                	test   %eax,%eax
80105bbb:	78 6f                	js     80105c2c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105bbd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105bc3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105bc6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105bc8:	68 80 00 00 00       	push   $0x80
80105bcd:	6a 00                	push   $0x0
80105bcf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105bd5:	50                   	push   %eax
80105bd6:	e8 45 f1 ff ff       	call   80104d20 <memset>
80105bdb:	83 c4 10             	add    $0x10,%esp
80105bde:	eb 2c                	jmp    80105c0c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105be0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105be6:	85 c0                	test   %eax,%eax
80105be8:	74 56                	je     80105c40 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105bea:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105bf0:	83 ec 08             	sub    $0x8,%esp
80105bf3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105bf6:	52                   	push   %edx
80105bf7:	50                   	push   %eax
80105bf8:	e8 b3 f3 ff ff       	call   80104fb0 <fetchstr>
80105bfd:	83 c4 10             	add    $0x10,%esp
80105c00:	85 c0                	test   %eax,%eax
80105c02:	78 28                	js     80105c2c <sys_exec+0xac>
  for(i=0;; i++){
80105c04:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105c07:	83 fb 20             	cmp    $0x20,%ebx
80105c0a:	74 20                	je     80105c2c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105c0c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105c12:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105c19:	83 ec 08             	sub    $0x8,%esp
80105c1c:	57                   	push   %edi
80105c1d:	01 f0                	add    %esi,%eax
80105c1f:	50                   	push   %eax
80105c20:	e8 4b f3 ff ff       	call   80104f70 <fetchint>
80105c25:	83 c4 10             	add    $0x10,%esp
80105c28:	85 c0                	test   %eax,%eax
80105c2a:	79 b4                	jns    80105be0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c34:	5b                   	pop    %ebx
80105c35:	5e                   	pop    %esi
80105c36:	5f                   	pop    %edi
80105c37:	5d                   	pop    %ebp
80105c38:	c3                   	ret    
80105c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105c40:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105c46:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105c49:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105c50:	00 00 00 00 
  return exec(path, argv);
80105c54:	50                   	push   %eax
80105c55:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105c5b:	e8 b0 ad ff ff       	call   80100a10 <exec>
80105c60:	83 c4 10             	add    $0x10,%esp
}
80105c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c66:	5b                   	pop    %ebx
80105c67:	5e                   	pop    %esi
80105c68:	5f                   	pop    %edi
80105c69:	5d                   	pop    %ebp
80105c6a:	c3                   	ret    
80105c6b:	90                   	nop
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c70 <sys_pipe>:

int
sys_pipe(void)
{
80105c70:	55                   	push   %ebp
80105c71:	89 e5                	mov    %esp,%ebp
80105c73:	57                   	push   %edi
80105c74:	56                   	push   %esi
80105c75:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c76:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105c79:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105c7c:	6a 08                	push   $0x8
80105c7e:	50                   	push   %eax
80105c7f:	6a 00                	push   $0x0
80105c81:	e8 ea f3 ff ff       	call   80105070 <argptr>
80105c86:	83 c4 10             	add    $0x10,%esp
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	0f 88 ae 00 00 00    	js     80105d3f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105c91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c94:	83 ec 08             	sub    $0x8,%esp
80105c97:	50                   	push   %eax
80105c98:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c9b:	50                   	push   %eax
80105c9c:	e8 ef dd ff ff       	call   80103a90 <pipealloc>
80105ca1:	83 c4 10             	add    $0x10,%esp
80105ca4:	85 c0                	test   %eax,%eax
80105ca6:	0f 88 93 00 00 00    	js     80105d3f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cac:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105caf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105cb1:	e8 7a e3 ff ff       	call   80104030 <myproc>
80105cb6:	eb 10                	jmp    80105cc8 <sys_pipe+0x58>
80105cb8:	90                   	nop
80105cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105cc0:	83 c3 01             	add    $0x1,%ebx
80105cc3:	83 fb 10             	cmp    $0x10,%ebx
80105cc6:	74 60                	je     80105d28 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105cc8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ccc:	85 f6                	test   %esi,%esi
80105cce:	75 f0                	jne    80105cc0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105cd0:	8d 73 08             	lea    0x8(%ebx),%esi
80105cd3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105cd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105cda:	e8 51 e3 ff ff       	call   80104030 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cdf:	31 d2                	xor    %edx,%edx
80105ce1:	eb 0d                	jmp    80105cf0 <sys_pipe+0x80>
80105ce3:	90                   	nop
80105ce4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ce8:	83 c2 01             	add    $0x1,%edx
80105ceb:	83 fa 10             	cmp    $0x10,%edx
80105cee:	74 28                	je     80105d18 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105cf0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105cf4:	85 c9                	test   %ecx,%ecx
80105cf6:	75 f0                	jne    80105ce8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105cf8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105cfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105cff:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105d01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105d04:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105d07:	31 c0                	xor    %eax,%eax
}
80105d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d0c:	5b                   	pop    %ebx
80105d0d:	5e                   	pop    %esi
80105d0e:	5f                   	pop    %edi
80105d0f:	5d                   	pop    %ebp
80105d10:	c3                   	ret    
80105d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105d18:	e8 13 e3 ff ff       	call   80104030 <myproc>
80105d1d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105d24:	00 
80105d25:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105d28:	83 ec 0c             	sub    $0xc,%esp
80105d2b:	ff 75 e0             	pushl  -0x20(%ebp)
80105d2e:	e8 0d b1 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105d33:	58                   	pop    %eax
80105d34:	ff 75 e4             	pushl  -0x1c(%ebp)
80105d37:	e8 04 b1 ff ff       	call   80100e40 <fileclose>
    return -1;
80105d3c:	83 c4 10             	add    $0x10,%esp
80105d3f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d44:	eb c3                	jmp    80105d09 <sys_pipe+0x99>
80105d46:	8d 76 00             	lea    0x0(%esi),%esi
80105d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105d50 <sys_swapread>:

int sys_swapread(void)
{
80105d50:	55                   	push   %ebp
80105d51:	89 e5                	mov    %esp,%ebp
80105d53:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105d56:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d59:	68 00 10 00 00       	push   $0x1000
80105d5e:	50                   	push   %eax
80105d5f:	6a 00                	push   $0x0
80105d61:	e8 0a f3 ff ff       	call   80105070 <argptr>
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	85 c0                	test   %eax,%eax
80105d6b:	78 33                	js     80105da0 <sys_swapread+0x50>
80105d6d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d70:	83 ec 08             	sub    $0x8,%esp
80105d73:	50                   	push   %eax
80105d74:	6a 01                	push   $0x1
80105d76:	e8 a5 f2 ff ff       	call   80105020 <argint>
80105d7b:	83 c4 10             	add    $0x10,%esp
80105d7e:	85 c0                	test   %eax,%eax
80105d80:	78 1e                	js     80105da0 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
80105d82:	83 ec 08             	sub    $0x8,%esp
80105d85:	ff 75 f4             	pushl  -0xc(%ebp)
80105d88:	ff 75 f0             	pushl  -0x10(%ebp)
80105d8b:	e8 a0 c1 ff ff       	call   80101f30 <swapread>
	return 0;
80105d90:	83 c4 10             	add    $0x10,%esp
80105d93:	31 c0                	xor    %eax,%eax
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		return -1;
80105da0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105da5:	c9                   	leave  
80105da6:	c3                   	ret    
80105da7:	89 f6                	mov    %esi,%esi
80105da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105db0 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105db6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105db9:	68 00 10 00 00       	push   $0x1000
80105dbe:	50                   	push   %eax
80105dbf:	6a 00                	push   $0x0
80105dc1:	e8 aa f2 ff ff       	call   80105070 <argptr>
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	78 33                	js     80105e00 <sys_swapwrite+0x50>
80105dcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dd0:	83 ec 08             	sub    $0x8,%esp
80105dd3:	50                   	push   %eax
80105dd4:	6a 01                	push   $0x1
80105dd6:	e8 45 f2 ff ff       	call   80105020 <argint>
80105ddb:	83 c4 10             	add    $0x10,%esp
80105dde:	85 c0                	test   %eax,%eax
80105de0:	78 1e                	js     80105e00 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105de2:	83 ec 08             	sub    $0x8,%esp
80105de5:	ff 75 f4             	pushl  -0xc(%ebp)
80105de8:	ff 75 f0             	pushl  -0x10(%ebp)
80105deb:	e8 d0 c1 ff ff       	call   80101fc0 <swapwrite>
	return 0;
80105df0:	83 c4 10             	add    $0x10,%esp
80105df3:	31 c0                	xor    %eax,%eax
}
80105df5:	c9                   	leave  
80105df6:	c3                   	ret    
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		return -1;
80105e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e05:	c9                   	leave  
80105e06:	c3                   	ret    
80105e07:	89 f6                	mov    %esi,%esi
80105e09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e10 <sys_swapstat>:

int sys_swapstat(void)
{
80105e10:	55                   	push   %ebp
80105e11:	89 e5                	mov    %esp,%ebp
80105e13:	53                   	push   %ebx
	int* nr_read;
	int* nr_write;
	
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105e14:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80105e17:	83 ec 18             	sub    $0x18,%esp
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105e1a:	6a 04                	push   $0x4
80105e1c:	50                   	push   %eax
80105e1d:	6a 00                	push   $0x0
80105e1f:	e8 4c f2 ff ff       	call   80105070 <argptr>
80105e24:	83 c4 10             	add    $0x10,%esp
80105e27:	85 c0                	test   %eax,%eax
80105e29:	75 3d                	jne    80105e68 <sys_swapstat+0x58>
80105e2b:	89 c3                	mov    %eax,%ebx
			argptr(1, (void*)&nr_write, sizeof(*nr_write)) < 0)
80105e2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e30:	83 ec 04             	sub    $0x4,%esp
80105e33:	6a 04                	push   $0x4
80105e35:	50                   	push   %eax
80105e36:	6a 01                	push   $0x1
80105e38:	e8 33 f2 ff ff       	call   80105070 <argptr>
	if(argptr(0, (void*)&nr_read, sizeof(*nr_read)) ||
80105e3d:	83 c4 10             	add    $0x10,%esp
80105e40:	85 c0                	test   %eax,%eax
80105e42:	78 24                	js     80105e68 <sys_swapstat+0x58>
		return -1;

	*nr_read = nr_sectors_read;
80105e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e47:	8b 15 c0 19 11 80    	mov    0x801119c0,%edx
80105e4d:	89 10                	mov    %edx,(%eax)
	*nr_write = nr_sectors_write;
80105e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e52:	8b 15 e0 19 11 80    	mov    0x801119e0,%edx
80105e58:	89 10                	mov    %edx,(%eax)
	return 0;
}
80105e5a:	89 d8                	mov    %ebx,%eax
80105e5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105e5f:	c9                   	leave  
80105e60:	c3                   	ret    
80105e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return -1;
80105e68:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105e6d:	eb eb                	jmp    80105e5a <sys_swapstat+0x4a>
80105e6f:	90                   	nop

80105e70 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105e70:	55                   	push   %ebp
80105e71:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105e73:	5d                   	pop    %ebp
  return fork();
80105e74:	e9 97 e3 ff ff       	jmp    80104210 <fork>
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e80 <sys_exit>:

int
sys_exit(void)
{
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e86:	e8 05 e6 ff ff       	call   80104490 <exit>
  return 0;  // not reached
}
80105e8b:	31 c0                	xor    %eax,%eax
80105e8d:	c9                   	leave  
80105e8e:	c3                   	ret    
80105e8f:	90                   	nop

80105e90 <sys_wait>:

int
sys_wait(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105e93:	5d                   	pop    %ebp
  return wait();
80105e94:	e9 37 e8 ff ff       	jmp    801046d0 <wait>
80105e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ea0 <sys_kill>:

int
sys_kill(void)
{
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea9:	50                   	push   %eax
80105eaa:	6a 00                	push   $0x0
80105eac:	e8 6f f1 ff ff       	call   80105020 <argint>
80105eb1:	83 c4 10             	add    $0x10,%esp
80105eb4:	85 c0                	test   %eax,%eax
80105eb6:	78 18                	js     80105ed0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105eb8:	83 ec 0c             	sub    $0xc,%esp
80105ebb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ebe:	e8 5d e9 ff ff       	call   80104820 <kill>
80105ec3:	83 c4 10             	add    $0x10,%esp
}
80105ec6:	c9                   	leave  
80105ec7:	c3                   	ret    
80105ec8:	90                   	nop
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ed5:	c9                   	leave  
80105ed6:	c3                   	ret    
80105ed7:	89 f6                	mov    %esi,%esi
80105ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105ee0 <sys_getpid>:

int
sys_getpid(void)
{
80105ee0:	55                   	push   %ebp
80105ee1:	89 e5                	mov    %esp,%ebp
80105ee3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ee6:	e8 45 e1 ff ff       	call   80104030 <myproc>
80105eeb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105eee:	c9                   	leave  
80105eef:	c3                   	ret    

80105ef0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ef4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ef7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105efa:	50                   	push   %eax
80105efb:	6a 00                	push   $0x0
80105efd:	e8 1e f1 ff ff       	call   80105020 <argint>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	78 27                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f09:	e8 22 e1 ff ff       	call   80104030 <myproc>
  if(growproc(n) < 0)
80105f0e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f11:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f13:	ff 75 f4             	pushl  -0xc(%ebp)
80105f16:	e8 75 e2 ff ff       	call   80104190 <growproc>
80105f1b:	83 c4 10             	add    $0x10,%esp
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	78 0e                	js     80105f30 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f22:	89 d8                	mov    %ebx,%eax
80105f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f27:	c9                   	leave  
80105f28:	c3                   	ret    
80105f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f30:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f35:	eb eb                	jmp    80105f22 <sys_sbrk+0x32>
80105f37:	89 f6                	mov    %esi,%esi
80105f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105f40 <sys_sleep>:

int
sys_sleep(void)
{
80105f40:	55                   	push   %ebp
80105f41:	89 e5                	mov    %esp,%ebp
80105f43:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f4a:	50                   	push   %eax
80105f4b:	6a 00                	push   $0x0
80105f4d:	e8 ce f0 ff ff       	call   80105020 <argint>
80105f52:	83 c4 10             	add    $0x10,%esp
80105f55:	85 c0                	test   %eax,%eax
80105f57:	0f 88 8a 00 00 00    	js     80105fe7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f5d:	83 ec 0c             	sub    $0xc,%esp
80105f60:	68 20 dd 22 80       	push   $0x8022dd20
80105f65:	e8 96 ec ff ff       	call   80104c00 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105f6d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105f70:	8b 1d 60 e5 22 80    	mov    0x8022e560,%ebx
  while(ticks - ticks0 < n){
80105f76:	85 d2                	test   %edx,%edx
80105f78:	75 27                	jne    80105fa1 <sys_sleep+0x61>
80105f7a:	eb 54                	jmp    80105fd0 <sys_sleep+0x90>
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f80:	83 ec 08             	sub    $0x8,%esp
80105f83:	68 20 dd 22 80       	push   $0x8022dd20
80105f88:	68 60 e5 22 80       	push   $0x8022e560
80105f8d:	e8 7e e6 ff ff       	call   80104610 <sleep>
  while(ticks - ticks0 < n){
80105f92:	a1 60 e5 22 80       	mov    0x8022e560,%eax
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	29 d8                	sub    %ebx,%eax
80105f9c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105f9f:	73 2f                	jae    80105fd0 <sys_sleep+0x90>
    if(myproc()->killed){
80105fa1:	e8 8a e0 ff ff       	call   80104030 <myproc>
80105fa6:	8b 40 24             	mov    0x24(%eax),%eax
80105fa9:	85 c0                	test   %eax,%eax
80105fab:	74 d3                	je     80105f80 <sys_sleep+0x40>
      release(&tickslock);
80105fad:	83 ec 0c             	sub    $0xc,%esp
80105fb0:	68 20 dd 22 80       	push   $0x8022dd20
80105fb5:	e8 06 ed ff ff       	call   80104cc0 <release>
      return -1;
80105fba:	83 c4 10             	add    $0x10,%esp
80105fbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105fc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fc5:	c9                   	leave  
80105fc6:	c3                   	ret    
80105fc7:	89 f6                	mov    %esi,%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105fd0:	83 ec 0c             	sub    $0xc,%esp
80105fd3:	68 20 dd 22 80       	push   $0x8022dd20
80105fd8:	e8 e3 ec ff ff       	call   80104cc0 <release>
  return 0;
80105fdd:	83 c4 10             	add    $0x10,%esp
80105fe0:	31 c0                	xor    %eax,%eax
}
80105fe2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
    return -1;
80105fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fec:	eb f4                	jmp    80105fe2 <sys_sleep+0xa2>
80105fee:	66 90                	xchg   %ax,%ax

80105ff0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ff0:	55                   	push   %ebp
80105ff1:	89 e5                	mov    %esp,%ebp
80105ff3:	53                   	push   %ebx
80105ff4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ff7:	68 20 dd 22 80       	push   $0x8022dd20
80105ffc:	e8 ff eb ff ff       	call   80104c00 <acquire>
  xticks = ticks;
80106001:	8b 1d 60 e5 22 80    	mov    0x8022e560,%ebx
  release(&tickslock);
80106007:	c7 04 24 20 dd 22 80 	movl   $0x8022dd20,(%esp)
8010600e:	e8 ad ec ff ff       	call   80104cc0 <release>
  return xticks;
}
80106013:	89 d8                	mov    %ebx,%eax
80106015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106018:	c9                   	leave  
80106019:	c3                   	ret    

8010601a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010601a:	1e                   	push   %ds
  pushl %es
8010601b:	06                   	push   %es
  pushl %fs
8010601c:	0f a0                	push   %fs
  pushl %gs
8010601e:	0f a8                	push   %gs
  pushal
80106020:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106021:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106025:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106027:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106029:	54                   	push   %esp
  call trap
8010602a:	e8 f1 00 00 00       	call   80106120 <trap>
  addl $4, %esp
8010602f:	83 c4 04             	add    $0x4,%esp

80106032 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106032:	61                   	popa   
  popl %gs
80106033:	0f a9                	pop    %gs
  popl %fs
80106035:	0f a1                	pop    %fs
  popl %es
80106037:	07                   	pop    %es
  popl %ds
80106038:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106039:	83 c4 08             	add    $0x8,%esp
  iret
8010603c:	cf                   	iret   
8010603d:	66 90                	xchg   %ax,%ax
8010603f:	90                   	nop

80106040 <PGFLT_HANDLER>:
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void PGFLT_HANDLER(void)
{
80106040:	55                   	push   %ebp
80106041:	89 e5                	mov    %esp,%ebp
80106043:	53                   	push   %ebx
80106044:	83 ec 04             	sub    $0x4,%esp

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106047:	0f 20 d3             	mov    %cr2,%ebx
    uint fault_addr=rcr2();
    fault_addr = PGROUNDDOWN(fault_addr);
    PGFLT_proc(fault_addr, myproc()->pgdir);
8010604a:	e8 e1 df ff ff       	call   80104030 <myproc>
    fault_addr = PGROUNDDOWN(fault_addr);
8010604f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    PGFLT_proc(fault_addr, myproc()->pgdir);
80106055:	83 ec 08             	sub    $0x8,%esp
80106058:	ff 70 04             	pushl  0x4(%eax)
8010605b:	53                   	push   %ebx
8010605c:	e8 6f cb ff ff       	call   80102bd0 <PGFLT_proc>
}
80106061:	83 c4 10             	add    $0x10,%esp
80106064:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106067:	c9                   	leave  
80106068:	c3                   	ret    
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <tvinit>:
void
tvinit(void)
{
80106070:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106071:	31 c0                	xor    %eax,%eax
{
80106073:	89 e5                	mov    %esp,%ebp
80106075:	83 ec 08             	sub    $0x8,%esp
80106078:	90                   	nop
80106079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106080:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106087:	c7 04 c5 62 dd 22 80 	movl   $0x8e000008,-0x7fdd229e(,%eax,8)
8010608e:	08 00 00 8e 
80106092:	66 89 14 c5 60 dd 22 	mov    %dx,-0x7fdd22a0(,%eax,8)
80106099:	80 
8010609a:	c1 ea 10             	shr    $0x10,%edx
8010609d:	66 89 14 c5 66 dd 22 	mov    %dx,-0x7fdd229a(,%eax,8)
801060a4:	80 
  for(i = 0; i < 256; i++)
801060a5:	83 c0 01             	add    $0x1,%eax
801060a8:	3d 00 01 00 00       	cmp    $0x100,%eax
801060ad:	75 d1                	jne    80106080 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060af:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
801060b4:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060b7:	c7 05 62 df 22 80 08 	movl   $0xef000008,0x8022df62
801060be:	00 00 ef 
  initlock(&tickslock, "time");
801060c1:	68 65 82 10 80       	push   $0x80108265
801060c6:	68 20 dd 22 80       	push   $0x8022dd20
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801060cb:	66 a3 60 df 22 80    	mov    %ax,0x8022df60
801060d1:	c1 e8 10             	shr    $0x10,%eax
801060d4:	66 a3 66 df 22 80    	mov    %ax,0x8022df66
  initlock(&tickslock, "time");
801060da:	e8 e1 e9 ff ff       	call   80104ac0 <initlock>
}
801060df:	83 c4 10             	add    $0x10,%esp
801060e2:	c9                   	leave  
801060e3:	c3                   	ret    
801060e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801060ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801060f0 <idtinit>:

void
idtinit(void)
{
801060f0:	55                   	push   %ebp
  pd[0] = size-1;
801060f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801060f6:	89 e5                	mov    %esp,%ebp
801060f8:	83 ec 10             	sub    $0x10,%esp
801060fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801060ff:	b8 60 dd 22 80       	mov    $0x8022dd60,%eax
80106104:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106108:	c1 e8 10             	shr    $0x10,%eax
8010610b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010610f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106112:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106115:	c9                   	leave  
80106116:	c3                   	ret    
80106117:	89 f6                	mov    %esi,%esi
80106119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106120 <trap>:

void
trap(struct trapframe *tf)
{
80106120:	55                   	push   %ebp
80106121:	89 e5                	mov    %esp,%ebp
80106123:	57                   	push   %edi
80106124:	56                   	push   %esi
80106125:	53                   	push   %ebx
80106126:	83 ec 1c             	sub    $0x1c,%esp
80106129:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010612c:	8b 47 30             	mov    0x30(%edi),%eax
8010612f:	83 f8 40             	cmp    $0x40,%eax
80106132:	0f 84 f0 00 00 00    	je     80106228 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106138:	83 e8 0e             	sub    $0xe,%eax
8010613b:	83 f8 31             	cmp    $0x31,%eax
8010613e:	77 10                	ja     80106150 <trap+0x30>
80106140:	ff 24 85 0c 83 10 80 	jmp    *-0x7fef7cf4(,%eax,4)
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_PGFLT:
    PGFLT_HANDLER();
    break;

  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106150:	e8 db de ff ff       	call   80104030 <myproc>
80106155:	85 c0                	test   %eax,%eax
80106157:	8b 5f 38             	mov    0x38(%edi),%ebx
8010615a:	0f 84 04 02 00 00    	je     80106364 <trap+0x244>
80106160:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80106164:	0f 84 fa 01 00 00    	je     80106364 <trap+0x244>
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010616a:	0f 20 d1             	mov    %cr2,%ecx
8010616d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106170:	e8 9b de ff ff       	call   80104010 <cpuid>
80106175:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106178:	8b 47 34             	mov    0x34(%edi),%eax
8010617b:	8b 77 30             	mov    0x30(%edi),%esi
8010617e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106181:	e8 aa de ff ff       	call   80104030 <myproc>
80106186:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106189:	e8 a2 de ff ff       	call   80104030 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010618e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106191:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106194:	51                   	push   %ecx
80106195:	53                   	push   %ebx
80106196:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80106197:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010619a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010619d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010619e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801061a1:	52                   	push   %edx
801061a2:	ff 70 10             	pushl  0x10(%eax)
801061a5:	68 c8 82 10 80       	push   $0x801082c8
801061aa:	e8 b1 a4 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801061af:	83 c4 20             	add    $0x20,%esp
801061b2:	e8 79 de ff ff       	call   80104030 <myproc>
801061b7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801061be:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061c0:	e8 6b de ff ff       	call   80104030 <myproc>
801061c5:	85 c0                	test   %eax,%eax
801061c7:	74 1d                	je     801061e6 <trap+0xc6>
801061c9:	e8 62 de ff ff       	call   80104030 <myproc>
801061ce:	8b 50 24             	mov    0x24(%eax),%edx
801061d1:	85 d2                	test   %edx,%edx
801061d3:	74 11                	je     801061e6 <trap+0xc6>
801061d5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801061d9:	83 e0 03             	and    $0x3,%eax
801061dc:	66 83 f8 03          	cmp    $0x3,%ax
801061e0:	0f 84 3a 01 00 00    	je     80106320 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801061e6:	e8 45 de ff ff       	call   80104030 <myproc>
801061eb:	85 c0                	test   %eax,%eax
801061ed:	74 0b                	je     801061fa <trap+0xda>
801061ef:	e8 3c de ff ff       	call   80104030 <myproc>
801061f4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801061f8:	74 66                	je     80106260 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
      yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061fa:	e8 31 de ff ff       	call   80104030 <myproc>
801061ff:	85 c0                	test   %eax,%eax
80106201:	74 19                	je     8010621c <trap+0xfc>
80106203:	e8 28 de ff ff       	call   80104030 <myproc>
80106208:	8b 40 24             	mov    0x24(%eax),%eax
8010620b:	85 c0                	test   %eax,%eax
8010620d:	74 0d                	je     8010621c <trap+0xfc>
8010620f:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80106213:	83 e0 03             	and    $0x3,%eax
80106216:	66 83 f8 03          	cmp    $0x3,%ax
8010621a:	74 35                	je     80106251 <trap+0x131>
    exit();
}
8010621c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010621f:	5b                   	pop    %ebx
80106220:	5e                   	pop    %esi
80106221:	5f                   	pop    %edi
80106222:	5d                   	pop    %ebp
80106223:	c3                   	ret    
80106224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80106228:	e8 03 de ff ff       	call   80104030 <myproc>
8010622d:	8b 58 24             	mov    0x24(%eax),%ebx
80106230:	85 db                	test   %ebx,%ebx
80106232:	0f 85 d8 00 00 00    	jne    80106310 <trap+0x1f0>
    myproc()->tf = tf;
80106238:	e8 f3 dd ff ff       	call   80104030 <myproc>
8010623d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80106240:	e8 cb ee ff ff       	call   80105110 <syscall>
    if(myproc()->killed)
80106245:	e8 e6 dd ff ff       	call   80104030 <myproc>
8010624a:	8b 48 24             	mov    0x24(%eax),%ecx
8010624d:	85 c9                	test   %ecx,%ecx
8010624f:	74 cb                	je     8010621c <trap+0xfc>
}
80106251:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106254:	5b                   	pop    %ebx
80106255:	5e                   	pop    %esi
80106256:	5f                   	pop    %edi
80106257:	5d                   	pop    %ebp
      exit();
80106258:	e9 33 e2 ff ff       	jmp    80104490 <exit>
8010625d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80106260:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80106264:	75 94                	jne    801061fa <trap+0xda>
      yield();
80106266:	e8 55 e3 ff ff       	call   801045c0 <yield>
8010626b:	eb 8d                	jmp    801061fa <trap+0xda>
8010626d:	8d 76 00             	lea    0x0(%esi),%esi
    PGFLT_HANDLER();
80106270:	e8 cb fd ff ff       	call   80106040 <PGFLT_HANDLER>
    break;
80106275:	e9 46 ff ff ff       	jmp    801061c0 <trap+0xa0>
8010627a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80106280:	e8 8b dd ff ff       	call   80104010 <cpuid>
80106285:	85 c0                	test   %eax,%eax
80106287:	0f 84 a3 00 00 00    	je     80106330 <trap+0x210>
    lapiceoi();
8010628d:	e8 0e cd ff ff       	call   80102fa0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106292:	e8 99 dd ff ff       	call   80104030 <myproc>
80106297:	85 c0                	test   %eax,%eax
80106299:	0f 85 2a ff ff ff    	jne    801061c9 <trap+0xa9>
8010629f:	e9 42 ff ff ff       	jmp    801061e6 <trap+0xc6>
801062a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
801062a8:	e8 b3 cb ff ff       	call   80102e60 <kbdintr>
    lapiceoi();
801062ad:	e8 ee cc ff ff       	call   80102fa0 <lapiceoi>
    break;
801062b2:	e9 09 ff ff ff       	jmp    801061c0 <trap+0xa0>
801062b7:	89 f6                	mov    %esi,%esi
801062b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
801062c0:	e8 3b 02 00 00       	call   80106500 <uartintr>
    lapiceoi();
801062c5:	e8 d6 cc ff ff       	call   80102fa0 <lapiceoi>
    break;
801062ca:	e9 f1 fe ff ff       	jmp    801061c0 <trap+0xa0>
801062cf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801062d0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801062d4:	8b 77 38             	mov    0x38(%edi),%esi
801062d7:	e8 34 dd ff ff       	call   80104010 <cpuid>
801062dc:	56                   	push   %esi
801062dd:	53                   	push   %ebx
801062de:	50                   	push   %eax
801062df:	68 70 82 10 80       	push   $0x80108270
801062e4:	e8 77 a3 ff ff       	call   80100660 <cprintf>
    lapiceoi();
801062e9:	e8 b2 cc ff ff       	call   80102fa0 <lapiceoi>
    break;
801062ee:	83 c4 10             	add    $0x10,%esp
801062f1:	e9 ca fe ff ff       	jmp    801061c0 <trap+0xa0>
801062f6:	8d 76 00             	lea    0x0(%esi),%esi
801062f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106300:	e8 4b bf ff ff       	call   80102250 <ideintr>
80106305:	eb 86                	jmp    8010628d <trap+0x16d>
80106307:	89 f6                	mov    %esi,%esi
80106309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106310:	e8 7b e1 ff ff       	call   80104490 <exit>
80106315:	e9 1e ff ff ff       	jmp    80106238 <trap+0x118>
8010631a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106320:	e8 6b e1 ff ff       	call   80104490 <exit>
80106325:	e9 bc fe ff ff       	jmp    801061e6 <trap+0xc6>
8010632a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106330:	83 ec 0c             	sub    $0xc,%esp
80106333:	68 20 dd 22 80       	push   $0x8022dd20
80106338:	e8 c3 e8 ff ff       	call   80104c00 <acquire>
      wakeup(&ticks);
8010633d:	c7 04 24 60 e5 22 80 	movl   $0x8022e560,(%esp)
      ticks++;
80106344:	83 05 60 e5 22 80 01 	addl   $0x1,0x8022e560
      wakeup(&ticks);
8010634b:	e8 70 e4 ff ff       	call   801047c0 <wakeup>
      release(&tickslock);
80106350:	c7 04 24 20 dd 22 80 	movl   $0x8022dd20,(%esp)
80106357:	e8 64 e9 ff ff       	call   80104cc0 <release>
8010635c:	83 c4 10             	add    $0x10,%esp
8010635f:	e9 29 ff ff ff       	jmp    8010628d <trap+0x16d>
80106364:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106367:	e8 a4 dc ff ff       	call   80104010 <cpuid>
8010636c:	83 ec 0c             	sub    $0xc,%esp
8010636f:	56                   	push   %esi
80106370:	53                   	push   %ebx
80106371:	50                   	push   %eax
80106372:	ff 77 30             	pushl  0x30(%edi)
80106375:	68 94 82 10 80       	push   $0x80108294
8010637a:	e8 e1 a2 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010637f:	83 c4 14             	add    $0x14,%esp
80106382:	68 6a 82 10 80       	push   $0x8010826a
80106387:	e8 04 a0 ff ff       	call   80100390 <panic>
8010638c:	66 90                	xchg   %ax,%ax
8010638e:	66 90                	xchg   %ax,%ax

80106390 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106390:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106395:	55                   	push   %ebp
80106396:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106398:	85 c0                	test   %eax,%eax
8010639a:	74 1c                	je     801063b8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010639c:	ba fd 03 00 00       	mov    $0x3fd,%edx
801063a1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801063a2:	a8 01                	test   $0x1,%al
801063a4:	74 12                	je     801063b8 <uartgetc+0x28>
801063a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063ab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801063ac:	0f b6 c0             	movzbl %al,%eax
}
801063af:	5d                   	pop    %ebp
801063b0:	c3                   	ret    
801063b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801063b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063bd:	5d                   	pop    %ebp
801063be:	c3                   	ret    
801063bf:	90                   	nop

801063c0 <uartputc.part.0>:
uartputc(int c)
801063c0:	55                   	push   %ebp
801063c1:	89 e5                	mov    %esp,%ebp
801063c3:	57                   	push   %edi
801063c4:	56                   	push   %esi
801063c5:	53                   	push   %ebx
801063c6:	89 c7                	mov    %eax,%edi
801063c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801063cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801063d2:	83 ec 0c             	sub    $0xc,%esp
801063d5:	eb 1b                	jmp    801063f2 <uartputc.part.0+0x32>
801063d7:	89 f6                	mov    %esi,%esi
801063d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801063e0:	83 ec 0c             	sub    $0xc,%esp
801063e3:	6a 0a                	push   $0xa
801063e5:	e8 d6 cb ff ff       	call   80102fc0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063ea:	83 c4 10             	add    $0x10,%esp
801063ed:	83 eb 01             	sub    $0x1,%ebx
801063f0:	74 07                	je     801063f9 <uartputc.part.0+0x39>
801063f2:	89 f2                	mov    %esi,%edx
801063f4:	ec                   	in     (%dx),%al
801063f5:	a8 20                	test   $0x20,%al
801063f7:	74 e7                	je     801063e0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063fe:	89 f8                	mov    %edi,%eax
80106400:	ee                   	out    %al,(%dx)
}
80106401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106404:	5b                   	pop    %ebx
80106405:	5e                   	pop    %esi
80106406:	5f                   	pop    %edi
80106407:	5d                   	pop    %ebp
80106408:	c3                   	ret    
80106409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106410 <uartinit>:
{
80106410:	55                   	push   %ebp
80106411:	31 c9                	xor    %ecx,%ecx
80106413:	89 c8                	mov    %ecx,%eax
80106415:	89 e5                	mov    %esp,%ebp
80106417:	57                   	push   %edi
80106418:	56                   	push   %esi
80106419:	53                   	push   %ebx
8010641a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010641f:	89 da                	mov    %ebx,%edx
80106421:	83 ec 0c             	sub    $0xc,%esp
80106424:	ee                   	out    %al,(%dx)
80106425:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010642a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010642f:	89 fa                	mov    %edi,%edx
80106431:	ee                   	out    %al,(%dx)
80106432:	b8 0c 00 00 00       	mov    $0xc,%eax
80106437:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010643c:	ee                   	out    %al,(%dx)
8010643d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106442:	89 c8                	mov    %ecx,%eax
80106444:	89 f2                	mov    %esi,%edx
80106446:	ee                   	out    %al,(%dx)
80106447:	b8 03 00 00 00       	mov    $0x3,%eax
8010644c:	89 fa                	mov    %edi,%edx
8010644e:	ee                   	out    %al,(%dx)
8010644f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106454:	89 c8                	mov    %ecx,%eax
80106456:	ee                   	out    %al,(%dx)
80106457:	b8 01 00 00 00       	mov    $0x1,%eax
8010645c:	89 f2                	mov    %esi,%edx
8010645e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010645f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106464:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106465:	3c ff                	cmp    $0xff,%al
80106467:	74 5a                	je     801064c3 <uartinit+0xb3>
  uart = 1;
80106469:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106470:	00 00 00 
80106473:	89 da                	mov    %ebx,%edx
80106475:	ec                   	in     (%dx),%al
80106476:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010647b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010647c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010647f:	bb d4 83 10 80       	mov    $0x801083d4,%ebx
  ioapicenable(IRQ_COM1, 0);
80106484:	6a 00                	push   $0x0
80106486:	6a 04                	push   $0x4
80106488:	e8 13 c0 ff ff       	call   801024a0 <ioapicenable>
8010648d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106490:	b8 78 00 00 00       	mov    $0x78,%eax
80106495:	eb 13                	jmp    801064aa <uartinit+0x9a>
80106497:	89 f6                	mov    %esi,%esi
80106499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801064a0:	83 c3 01             	add    $0x1,%ebx
801064a3:	0f be 03             	movsbl (%ebx),%eax
801064a6:	84 c0                	test   %al,%al
801064a8:	74 19                	je     801064c3 <uartinit+0xb3>
  if(!uart)
801064aa:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801064b0:	85 d2                	test   %edx,%edx
801064b2:	74 ec                	je     801064a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801064b4:	83 c3 01             	add    $0x1,%ebx
801064b7:	e8 04 ff ff ff       	call   801063c0 <uartputc.part.0>
801064bc:	0f be 03             	movsbl (%ebx),%eax
801064bf:	84 c0                	test   %al,%al
801064c1:	75 e7                	jne    801064aa <uartinit+0x9a>
}
801064c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064c6:	5b                   	pop    %ebx
801064c7:	5e                   	pop    %esi
801064c8:	5f                   	pop    %edi
801064c9:	5d                   	pop    %ebp
801064ca:	c3                   	ret    
801064cb:	90                   	nop
801064cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801064d0 <uartputc>:
  if(!uart)
801064d0:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801064d6:	55                   	push   %ebp
801064d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801064d9:	85 d2                	test   %edx,%edx
{
801064db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801064de:	74 10                	je     801064f0 <uartputc+0x20>
}
801064e0:	5d                   	pop    %ebp
801064e1:	e9 da fe ff ff       	jmp    801063c0 <uartputc.part.0>
801064e6:	8d 76 00             	lea    0x0(%esi),%esi
801064e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801064f0:	5d                   	pop    %ebp
801064f1:	c3                   	ret    
801064f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106500 <uartintr>:

void
uartintr(void)
{
80106500:	55                   	push   %ebp
80106501:	89 e5                	mov    %esp,%ebp
80106503:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106506:	68 90 63 10 80       	push   $0x80106390
8010650b:	e8 00 a3 ff ff       	call   80100810 <consoleintr>
}
80106510:	83 c4 10             	add    $0x10,%esp
80106513:	c9                   	leave  
80106514:	c3                   	ret    

80106515 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106515:	6a 00                	push   $0x0
  pushl $0
80106517:	6a 00                	push   $0x0
  jmp alltraps
80106519:	e9 fc fa ff ff       	jmp    8010601a <alltraps>

8010651e <vector1>:
.globl vector1
vector1:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $1
80106520:	6a 01                	push   $0x1
  jmp alltraps
80106522:	e9 f3 fa ff ff       	jmp    8010601a <alltraps>

80106527 <vector2>:
.globl vector2
vector2:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $2
80106529:	6a 02                	push   $0x2
  jmp alltraps
8010652b:	e9 ea fa ff ff       	jmp    8010601a <alltraps>

80106530 <vector3>:
.globl vector3
vector3:
  pushl $0
80106530:	6a 00                	push   $0x0
  pushl $3
80106532:	6a 03                	push   $0x3
  jmp alltraps
80106534:	e9 e1 fa ff ff       	jmp    8010601a <alltraps>

80106539 <vector4>:
.globl vector4
vector4:
  pushl $0
80106539:	6a 00                	push   $0x0
  pushl $4
8010653b:	6a 04                	push   $0x4
  jmp alltraps
8010653d:	e9 d8 fa ff ff       	jmp    8010601a <alltraps>

80106542 <vector5>:
.globl vector5
vector5:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $5
80106544:	6a 05                	push   $0x5
  jmp alltraps
80106546:	e9 cf fa ff ff       	jmp    8010601a <alltraps>

8010654b <vector6>:
.globl vector6
vector6:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $6
8010654d:	6a 06                	push   $0x6
  jmp alltraps
8010654f:	e9 c6 fa ff ff       	jmp    8010601a <alltraps>

80106554 <vector7>:
.globl vector7
vector7:
  pushl $0
80106554:	6a 00                	push   $0x0
  pushl $7
80106556:	6a 07                	push   $0x7
  jmp alltraps
80106558:	e9 bd fa ff ff       	jmp    8010601a <alltraps>

8010655d <vector8>:
.globl vector8
vector8:
  pushl $8
8010655d:	6a 08                	push   $0x8
  jmp alltraps
8010655f:	e9 b6 fa ff ff       	jmp    8010601a <alltraps>

80106564 <vector9>:
.globl vector9
vector9:
  pushl $0
80106564:	6a 00                	push   $0x0
  pushl $9
80106566:	6a 09                	push   $0x9
  jmp alltraps
80106568:	e9 ad fa ff ff       	jmp    8010601a <alltraps>

8010656d <vector10>:
.globl vector10
vector10:
  pushl $10
8010656d:	6a 0a                	push   $0xa
  jmp alltraps
8010656f:	e9 a6 fa ff ff       	jmp    8010601a <alltraps>

80106574 <vector11>:
.globl vector11
vector11:
  pushl $11
80106574:	6a 0b                	push   $0xb
  jmp alltraps
80106576:	e9 9f fa ff ff       	jmp    8010601a <alltraps>

8010657b <vector12>:
.globl vector12
vector12:
  pushl $12
8010657b:	6a 0c                	push   $0xc
  jmp alltraps
8010657d:	e9 98 fa ff ff       	jmp    8010601a <alltraps>

80106582 <vector13>:
.globl vector13
vector13:
  pushl $13
80106582:	6a 0d                	push   $0xd
  jmp alltraps
80106584:	e9 91 fa ff ff       	jmp    8010601a <alltraps>

80106589 <vector14>:
.globl vector14
vector14:
  pushl $14
80106589:	6a 0e                	push   $0xe
  jmp alltraps
8010658b:	e9 8a fa ff ff       	jmp    8010601a <alltraps>

80106590 <vector15>:
.globl vector15
vector15:
  pushl $0
80106590:	6a 00                	push   $0x0
  pushl $15
80106592:	6a 0f                	push   $0xf
  jmp alltraps
80106594:	e9 81 fa ff ff       	jmp    8010601a <alltraps>

80106599 <vector16>:
.globl vector16
vector16:
  pushl $0
80106599:	6a 00                	push   $0x0
  pushl $16
8010659b:	6a 10                	push   $0x10
  jmp alltraps
8010659d:	e9 78 fa ff ff       	jmp    8010601a <alltraps>

801065a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801065a2:	6a 11                	push   $0x11
  jmp alltraps
801065a4:	e9 71 fa ff ff       	jmp    8010601a <alltraps>

801065a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801065a9:	6a 00                	push   $0x0
  pushl $18
801065ab:	6a 12                	push   $0x12
  jmp alltraps
801065ad:	e9 68 fa ff ff       	jmp    8010601a <alltraps>

801065b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801065b2:	6a 00                	push   $0x0
  pushl $19
801065b4:	6a 13                	push   $0x13
  jmp alltraps
801065b6:	e9 5f fa ff ff       	jmp    8010601a <alltraps>

801065bb <vector20>:
.globl vector20
vector20:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $20
801065bd:	6a 14                	push   $0x14
  jmp alltraps
801065bf:	e9 56 fa ff ff       	jmp    8010601a <alltraps>

801065c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801065c4:	6a 00                	push   $0x0
  pushl $21
801065c6:	6a 15                	push   $0x15
  jmp alltraps
801065c8:	e9 4d fa ff ff       	jmp    8010601a <alltraps>

801065cd <vector22>:
.globl vector22
vector22:
  pushl $0
801065cd:	6a 00                	push   $0x0
  pushl $22
801065cf:	6a 16                	push   $0x16
  jmp alltraps
801065d1:	e9 44 fa ff ff       	jmp    8010601a <alltraps>

801065d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801065d6:	6a 00                	push   $0x0
  pushl $23
801065d8:	6a 17                	push   $0x17
  jmp alltraps
801065da:	e9 3b fa ff ff       	jmp    8010601a <alltraps>

801065df <vector24>:
.globl vector24
vector24:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $24
801065e1:	6a 18                	push   $0x18
  jmp alltraps
801065e3:	e9 32 fa ff ff       	jmp    8010601a <alltraps>

801065e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801065e8:	6a 00                	push   $0x0
  pushl $25
801065ea:	6a 19                	push   $0x19
  jmp alltraps
801065ec:	e9 29 fa ff ff       	jmp    8010601a <alltraps>

801065f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801065f1:	6a 00                	push   $0x0
  pushl $26
801065f3:	6a 1a                	push   $0x1a
  jmp alltraps
801065f5:	e9 20 fa ff ff       	jmp    8010601a <alltraps>

801065fa <vector27>:
.globl vector27
vector27:
  pushl $0
801065fa:	6a 00                	push   $0x0
  pushl $27
801065fc:	6a 1b                	push   $0x1b
  jmp alltraps
801065fe:	e9 17 fa ff ff       	jmp    8010601a <alltraps>

80106603 <vector28>:
.globl vector28
vector28:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $28
80106605:	6a 1c                	push   $0x1c
  jmp alltraps
80106607:	e9 0e fa ff ff       	jmp    8010601a <alltraps>

8010660c <vector29>:
.globl vector29
vector29:
  pushl $0
8010660c:	6a 00                	push   $0x0
  pushl $29
8010660e:	6a 1d                	push   $0x1d
  jmp alltraps
80106610:	e9 05 fa ff ff       	jmp    8010601a <alltraps>

80106615 <vector30>:
.globl vector30
vector30:
  pushl $0
80106615:	6a 00                	push   $0x0
  pushl $30
80106617:	6a 1e                	push   $0x1e
  jmp alltraps
80106619:	e9 fc f9 ff ff       	jmp    8010601a <alltraps>

8010661e <vector31>:
.globl vector31
vector31:
  pushl $0
8010661e:	6a 00                	push   $0x0
  pushl $31
80106620:	6a 1f                	push   $0x1f
  jmp alltraps
80106622:	e9 f3 f9 ff ff       	jmp    8010601a <alltraps>

80106627 <vector32>:
.globl vector32
vector32:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $32
80106629:	6a 20                	push   $0x20
  jmp alltraps
8010662b:	e9 ea f9 ff ff       	jmp    8010601a <alltraps>

80106630 <vector33>:
.globl vector33
vector33:
  pushl $0
80106630:	6a 00                	push   $0x0
  pushl $33
80106632:	6a 21                	push   $0x21
  jmp alltraps
80106634:	e9 e1 f9 ff ff       	jmp    8010601a <alltraps>

80106639 <vector34>:
.globl vector34
vector34:
  pushl $0
80106639:	6a 00                	push   $0x0
  pushl $34
8010663b:	6a 22                	push   $0x22
  jmp alltraps
8010663d:	e9 d8 f9 ff ff       	jmp    8010601a <alltraps>

80106642 <vector35>:
.globl vector35
vector35:
  pushl $0
80106642:	6a 00                	push   $0x0
  pushl $35
80106644:	6a 23                	push   $0x23
  jmp alltraps
80106646:	e9 cf f9 ff ff       	jmp    8010601a <alltraps>

8010664b <vector36>:
.globl vector36
vector36:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $36
8010664d:	6a 24                	push   $0x24
  jmp alltraps
8010664f:	e9 c6 f9 ff ff       	jmp    8010601a <alltraps>

80106654 <vector37>:
.globl vector37
vector37:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $37
80106656:	6a 25                	push   $0x25
  jmp alltraps
80106658:	e9 bd f9 ff ff       	jmp    8010601a <alltraps>

8010665d <vector38>:
.globl vector38
vector38:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $38
8010665f:	6a 26                	push   $0x26
  jmp alltraps
80106661:	e9 b4 f9 ff ff       	jmp    8010601a <alltraps>

80106666 <vector39>:
.globl vector39
vector39:
  pushl $0
80106666:	6a 00                	push   $0x0
  pushl $39
80106668:	6a 27                	push   $0x27
  jmp alltraps
8010666a:	e9 ab f9 ff ff       	jmp    8010601a <alltraps>

8010666f <vector40>:
.globl vector40
vector40:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $40
80106671:	6a 28                	push   $0x28
  jmp alltraps
80106673:	e9 a2 f9 ff ff       	jmp    8010601a <alltraps>

80106678 <vector41>:
.globl vector41
vector41:
  pushl $0
80106678:	6a 00                	push   $0x0
  pushl $41
8010667a:	6a 29                	push   $0x29
  jmp alltraps
8010667c:	e9 99 f9 ff ff       	jmp    8010601a <alltraps>

80106681 <vector42>:
.globl vector42
vector42:
  pushl $0
80106681:	6a 00                	push   $0x0
  pushl $42
80106683:	6a 2a                	push   $0x2a
  jmp alltraps
80106685:	e9 90 f9 ff ff       	jmp    8010601a <alltraps>

8010668a <vector43>:
.globl vector43
vector43:
  pushl $0
8010668a:	6a 00                	push   $0x0
  pushl $43
8010668c:	6a 2b                	push   $0x2b
  jmp alltraps
8010668e:	e9 87 f9 ff ff       	jmp    8010601a <alltraps>

80106693 <vector44>:
.globl vector44
vector44:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $44
80106695:	6a 2c                	push   $0x2c
  jmp alltraps
80106697:	e9 7e f9 ff ff       	jmp    8010601a <alltraps>

8010669c <vector45>:
.globl vector45
vector45:
  pushl $0
8010669c:	6a 00                	push   $0x0
  pushl $45
8010669e:	6a 2d                	push   $0x2d
  jmp alltraps
801066a0:	e9 75 f9 ff ff       	jmp    8010601a <alltraps>

801066a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801066a5:	6a 00                	push   $0x0
  pushl $46
801066a7:	6a 2e                	push   $0x2e
  jmp alltraps
801066a9:	e9 6c f9 ff ff       	jmp    8010601a <alltraps>

801066ae <vector47>:
.globl vector47
vector47:
  pushl $0
801066ae:	6a 00                	push   $0x0
  pushl $47
801066b0:	6a 2f                	push   $0x2f
  jmp alltraps
801066b2:	e9 63 f9 ff ff       	jmp    8010601a <alltraps>

801066b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $48
801066b9:	6a 30                	push   $0x30
  jmp alltraps
801066bb:	e9 5a f9 ff ff       	jmp    8010601a <alltraps>

801066c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801066c0:	6a 00                	push   $0x0
  pushl $49
801066c2:	6a 31                	push   $0x31
  jmp alltraps
801066c4:	e9 51 f9 ff ff       	jmp    8010601a <alltraps>

801066c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801066c9:	6a 00                	push   $0x0
  pushl $50
801066cb:	6a 32                	push   $0x32
  jmp alltraps
801066cd:	e9 48 f9 ff ff       	jmp    8010601a <alltraps>

801066d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801066d2:	6a 00                	push   $0x0
  pushl $51
801066d4:	6a 33                	push   $0x33
  jmp alltraps
801066d6:	e9 3f f9 ff ff       	jmp    8010601a <alltraps>

801066db <vector52>:
.globl vector52
vector52:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $52
801066dd:	6a 34                	push   $0x34
  jmp alltraps
801066df:	e9 36 f9 ff ff       	jmp    8010601a <alltraps>

801066e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801066e4:	6a 00                	push   $0x0
  pushl $53
801066e6:	6a 35                	push   $0x35
  jmp alltraps
801066e8:	e9 2d f9 ff ff       	jmp    8010601a <alltraps>

801066ed <vector54>:
.globl vector54
vector54:
  pushl $0
801066ed:	6a 00                	push   $0x0
  pushl $54
801066ef:	6a 36                	push   $0x36
  jmp alltraps
801066f1:	e9 24 f9 ff ff       	jmp    8010601a <alltraps>

801066f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801066f6:	6a 00                	push   $0x0
  pushl $55
801066f8:	6a 37                	push   $0x37
  jmp alltraps
801066fa:	e9 1b f9 ff ff       	jmp    8010601a <alltraps>

801066ff <vector56>:
.globl vector56
vector56:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $56
80106701:	6a 38                	push   $0x38
  jmp alltraps
80106703:	e9 12 f9 ff ff       	jmp    8010601a <alltraps>

80106708 <vector57>:
.globl vector57
vector57:
  pushl $0
80106708:	6a 00                	push   $0x0
  pushl $57
8010670a:	6a 39                	push   $0x39
  jmp alltraps
8010670c:	e9 09 f9 ff ff       	jmp    8010601a <alltraps>

80106711 <vector58>:
.globl vector58
vector58:
  pushl $0
80106711:	6a 00                	push   $0x0
  pushl $58
80106713:	6a 3a                	push   $0x3a
  jmp alltraps
80106715:	e9 00 f9 ff ff       	jmp    8010601a <alltraps>

8010671a <vector59>:
.globl vector59
vector59:
  pushl $0
8010671a:	6a 00                	push   $0x0
  pushl $59
8010671c:	6a 3b                	push   $0x3b
  jmp alltraps
8010671e:	e9 f7 f8 ff ff       	jmp    8010601a <alltraps>

80106723 <vector60>:
.globl vector60
vector60:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $60
80106725:	6a 3c                	push   $0x3c
  jmp alltraps
80106727:	e9 ee f8 ff ff       	jmp    8010601a <alltraps>

8010672c <vector61>:
.globl vector61
vector61:
  pushl $0
8010672c:	6a 00                	push   $0x0
  pushl $61
8010672e:	6a 3d                	push   $0x3d
  jmp alltraps
80106730:	e9 e5 f8 ff ff       	jmp    8010601a <alltraps>

80106735 <vector62>:
.globl vector62
vector62:
  pushl $0
80106735:	6a 00                	push   $0x0
  pushl $62
80106737:	6a 3e                	push   $0x3e
  jmp alltraps
80106739:	e9 dc f8 ff ff       	jmp    8010601a <alltraps>

8010673e <vector63>:
.globl vector63
vector63:
  pushl $0
8010673e:	6a 00                	push   $0x0
  pushl $63
80106740:	6a 3f                	push   $0x3f
  jmp alltraps
80106742:	e9 d3 f8 ff ff       	jmp    8010601a <alltraps>

80106747 <vector64>:
.globl vector64
vector64:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $64
80106749:	6a 40                	push   $0x40
  jmp alltraps
8010674b:	e9 ca f8 ff ff       	jmp    8010601a <alltraps>

80106750 <vector65>:
.globl vector65
vector65:
  pushl $0
80106750:	6a 00                	push   $0x0
  pushl $65
80106752:	6a 41                	push   $0x41
  jmp alltraps
80106754:	e9 c1 f8 ff ff       	jmp    8010601a <alltraps>

80106759 <vector66>:
.globl vector66
vector66:
  pushl $0
80106759:	6a 00                	push   $0x0
  pushl $66
8010675b:	6a 42                	push   $0x42
  jmp alltraps
8010675d:	e9 b8 f8 ff ff       	jmp    8010601a <alltraps>

80106762 <vector67>:
.globl vector67
vector67:
  pushl $0
80106762:	6a 00                	push   $0x0
  pushl $67
80106764:	6a 43                	push   $0x43
  jmp alltraps
80106766:	e9 af f8 ff ff       	jmp    8010601a <alltraps>

8010676b <vector68>:
.globl vector68
vector68:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $68
8010676d:	6a 44                	push   $0x44
  jmp alltraps
8010676f:	e9 a6 f8 ff ff       	jmp    8010601a <alltraps>

80106774 <vector69>:
.globl vector69
vector69:
  pushl $0
80106774:	6a 00                	push   $0x0
  pushl $69
80106776:	6a 45                	push   $0x45
  jmp alltraps
80106778:	e9 9d f8 ff ff       	jmp    8010601a <alltraps>

8010677d <vector70>:
.globl vector70
vector70:
  pushl $0
8010677d:	6a 00                	push   $0x0
  pushl $70
8010677f:	6a 46                	push   $0x46
  jmp alltraps
80106781:	e9 94 f8 ff ff       	jmp    8010601a <alltraps>

80106786 <vector71>:
.globl vector71
vector71:
  pushl $0
80106786:	6a 00                	push   $0x0
  pushl $71
80106788:	6a 47                	push   $0x47
  jmp alltraps
8010678a:	e9 8b f8 ff ff       	jmp    8010601a <alltraps>

8010678f <vector72>:
.globl vector72
vector72:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $72
80106791:	6a 48                	push   $0x48
  jmp alltraps
80106793:	e9 82 f8 ff ff       	jmp    8010601a <alltraps>

80106798 <vector73>:
.globl vector73
vector73:
  pushl $0
80106798:	6a 00                	push   $0x0
  pushl $73
8010679a:	6a 49                	push   $0x49
  jmp alltraps
8010679c:	e9 79 f8 ff ff       	jmp    8010601a <alltraps>

801067a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801067a1:	6a 00                	push   $0x0
  pushl $74
801067a3:	6a 4a                	push   $0x4a
  jmp alltraps
801067a5:	e9 70 f8 ff ff       	jmp    8010601a <alltraps>

801067aa <vector75>:
.globl vector75
vector75:
  pushl $0
801067aa:	6a 00                	push   $0x0
  pushl $75
801067ac:	6a 4b                	push   $0x4b
  jmp alltraps
801067ae:	e9 67 f8 ff ff       	jmp    8010601a <alltraps>

801067b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $76
801067b5:	6a 4c                	push   $0x4c
  jmp alltraps
801067b7:	e9 5e f8 ff ff       	jmp    8010601a <alltraps>

801067bc <vector77>:
.globl vector77
vector77:
  pushl $0
801067bc:	6a 00                	push   $0x0
  pushl $77
801067be:	6a 4d                	push   $0x4d
  jmp alltraps
801067c0:	e9 55 f8 ff ff       	jmp    8010601a <alltraps>

801067c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801067c5:	6a 00                	push   $0x0
  pushl $78
801067c7:	6a 4e                	push   $0x4e
  jmp alltraps
801067c9:	e9 4c f8 ff ff       	jmp    8010601a <alltraps>

801067ce <vector79>:
.globl vector79
vector79:
  pushl $0
801067ce:	6a 00                	push   $0x0
  pushl $79
801067d0:	6a 4f                	push   $0x4f
  jmp alltraps
801067d2:	e9 43 f8 ff ff       	jmp    8010601a <alltraps>

801067d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $80
801067d9:	6a 50                	push   $0x50
  jmp alltraps
801067db:	e9 3a f8 ff ff       	jmp    8010601a <alltraps>

801067e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801067e0:	6a 00                	push   $0x0
  pushl $81
801067e2:	6a 51                	push   $0x51
  jmp alltraps
801067e4:	e9 31 f8 ff ff       	jmp    8010601a <alltraps>

801067e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801067e9:	6a 00                	push   $0x0
  pushl $82
801067eb:	6a 52                	push   $0x52
  jmp alltraps
801067ed:	e9 28 f8 ff ff       	jmp    8010601a <alltraps>

801067f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801067f2:	6a 00                	push   $0x0
  pushl $83
801067f4:	6a 53                	push   $0x53
  jmp alltraps
801067f6:	e9 1f f8 ff ff       	jmp    8010601a <alltraps>

801067fb <vector84>:
.globl vector84
vector84:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $84
801067fd:	6a 54                	push   $0x54
  jmp alltraps
801067ff:	e9 16 f8 ff ff       	jmp    8010601a <alltraps>

80106804 <vector85>:
.globl vector85
vector85:
  pushl $0
80106804:	6a 00                	push   $0x0
  pushl $85
80106806:	6a 55                	push   $0x55
  jmp alltraps
80106808:	e9 0d f8 ff ff       	jmp    8010601a <alltraps>

8010680d <vector86>:
.globl vector86
vector86:
  pushl $0
8010680d:	6a 00                	push   $0x0
  pushl $86
8010680f:	6a 56                	push   $0x56
  jmp alltraps
80106811:	e9 04 f8 ff ff       	jmp    8010601a <alltraps>

80106816 <vector87>:
.globl vector87
vector87:
  pushl $0
80106816:	6a 00                	push   $0x0
  pushl $87
80106818:	6a 57                	push   $0x57
  jmp alltraps
8010681a:	e9 fb f7 ff ff       	jmp    8010601a <alltraps>

8010681f <vector88>:
.globl vector88
vector88:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $88
80106821:	6a 58                	push   $0x58
  jmp alltraps
80106823:	e9 f2 f7 ff ff       	jmp    8010601a <alltraps>

80106828 <vector89>:
.globl vector89
vector89:
  pushl $0
80106828:	6a 00                	push   $0x0
  pushl $89
8010682a:	6a 59                	push   $0x59
  jmp alltraps
8010682c:	e9 e9 f7 ff ff       	jmp    8010601a <alltraps>

80106831 <vector90>:
.globl vector90
vector90:
  pushl $0
80106831:	6a 00                	push   $0x0
  pushl $90
80106833:	6a 5a                	push   $0x5a
  jmp alltraps
80106835:	e9 e0 f7 ff ff       	jmp    8010601a <alltraps>

8010683a <vector91>:
.globl vector91
vector91:
  pushl $0
8010683a:	6a 00                	push   $0x0
  pushl $91
8010683c:	6a 5b                	push   $0x5b
  jmp alltraps
8010683e:	e9 d7 f7 ff ff       	jmp    8010601a <alltraps>

80106843 <vector92>:
.globl vector92
vector92:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $92
80106845:	6a 5c                	push   $0x5c
  jmp alltraps
80106847:	e9 ce f7 ff ff       	jmp    8010601a <alltraps>

8010684c <vector93>:
.globl vector93
vector93:
  pushl $0
8010684c:	6a 00                	push   $0x0
  pushl $93
8010684e:	6a 5d                	push   $0x5d
  jmp alltraps
80106850:	e9 c5 f7 ff ff       	jmp    8010601a <alltraps>

80106855 <vector94>:
.globl vector94
vector94:
  pushl $0
80106855:	6a 00                	push   $0x0
  pushl $94
80106857:	6a 5e                	push   $0x5e
  jmp alltraps
80106859:	e9 bc f7 ff ff       	jmp    8010601a <alltraps>

8010685e <vector95>:
.globl vector95
vector95:
  pushl $0
8010685e:	6a 00                	push   $0x0
  pushl $95
80106860:	6a 5f                	push   $0x5f
  jmp alltraps
80106862:	e9 b3 f7 ff ff       	jmp    8010601a <alltraps>

80106867 <vector96>:
.globl vector96
vector96:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $96
80106869:	6a 60                	push   $0x60
  jmp alltraps
8010686b:	e9 aa f7 ff ff       	jmp    8010601a <alltraps>

80106870 <vector97>:
.globl vector97
vector97:
  pushl $0
80106870:	6a 00                	push   $0x0
  pushl $97
80106872:	6a 61                	push   $0x61
  jmp alltraps
80106874:	e9 a1 f7 ff ff       	jmp    8010601a <alltraps>

80106879 <vector98>:
.globl vector98
vector98:
  pushl $0
80106879:	6a 00                	push   $0x0
  pushl $98
8010687b:	6a 62                	push   $0x62
  jmp alltraps
8010687d:	e9 98 f7 ff ff       	jmp    8010601a <alltraps>

80106882 <vector99>:
.globl vector99
vector99:
  pushl $0
80106882:	6a 00                	push   $0x0
  pushl $99
80106884:	6a 63                	push   $0x63
  jmp alltraps
80106886:	e9 8f f7 ff ff       	jmp    8010601a <alltraps>

8010688b <vector100>:
.globl vector100
vector100:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $100
8010688d:	6a 64                	push   $0x64
  jmp alltraps
8010688f:	e9 86 f7 ff ff       	jmp    8010601a <alltraps>

80106894 <vector101>:
.globl vector101
vector101:
  pushl $0
80106894:	6a 00                	push   $0x0
  pushl $101
80106896:	6a 65                	push   $0x65
  jmp alltraps
80106898:	e9 7d f7 ff ff       	jmp    8010601a <alltraps>

8010689d <vector102>:
.globl vector102
vector102:
  pushl $0
8010689d:	6a 00                	push   $0x0
  pushl $102
8010689f:	6a 66                	push   $0x66
  jmp alltraps
801068a1:	e9 74 f7 ff ff       	jmp    8010601a <alltraps>

801068a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801068a6:	6a 00                	push   $0x0
  pushl $103
801068a8:	6a 67                	push   $0x67
  jmp alltraps
801068aa:	e9 6b f7 ff ff       	jmp    8010601a <alltraps>

801068af <vector104>:
.globl vector104
vector104:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $104
801068b1:	6a 68                	push   $0x68
  jmp alltraps
801068b3:	e9 62 f7 ff ff       	jmp    8010601a <alltraps>

801068b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801068b8:	6a 00                	push   $0x0
  pushl $105
801068ba:	6a 69                	push   $0x69
  jmp alltraps
801068bc:	e9 59 f7 ff ff       	jmp    8010601a <alltraps>

801068c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801068c1:	6a 00                	push   $0x0
  pushl $106
801068c3:	6a 6a                	push   $0x6a
  jmp alltraps
801068c5:	e9 50 f7 ff ff       	jmp    8010601a <alltraps>

801068ca <vector107>:
.globl vector107
vector107:
  pushl $0
801068ca:	6a 00                	push   $0x0
  pushl $107
801068cc:	6a 6b                	push   $0x6b
  jmp alltraps
801068ce:	e9 47 f7 ff ff       	jmp    8010601a <alltraps>

801068d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $108
801068d5:	6a 6c                	push   $0x6c
  jmp alltraps
801068d7:	e9 3e f7 ff ff       	jmp    8010601a <alltraps>

801068dc <vector109>:
.globl vector109
vector109:
  pushl $0
801068dc:	6a 00                	push   $0x0
  pushl $109
801068de:	6a 6d                	push   $0x6d
  jmp alltraps
801068e0:	e9 35 f7 ff ff       	jmp    8010601a <alltraps>

801068e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801068e5:	6a 00                	push   $0x0
  pushl $110
801068e7:	6a 6e                	push   $0x6e
  jmp alltraps
801068e9:	e9 2c f7 ff ff       	jmp    8010601a <alltraps>

801068ee <vector111>:
.globl vector111
vector111:
  pushl $0
801068ee:	6a 00                	push   $0x0
  pushl $111
801068f0:	6a 6f                	push   $0x6f
  jmp alltraps
801068f2:	e9 23 f7 ff ff       	jmp    8010601a <alltraps>

801068f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $112
801068f9:	6a 70                	push   $0x70
  jmp alltraps
801068fb:	e9 1a f7 ff ff       	jmp    8010601a <alltraps>

80106900 <vector113>:
.globl vector113
vector113:
  pushl $0
80106900:	6a 00                	push   $0x0
  pushl $113
80106902:	6a 71                	push   $0x71
  jmp alltraps
80106904:	e9 11 f7 ff ff       	jmp    8010601a <alltraps>

80106909 <vector114>:
.globl vector114
vector114:
  pushl $0
80106909:	6a 00                	push   $0x0
  pushl $114
8010690b:	6a 72                	push   $0x72
  jmp alltraps
8010690d:	e9 08 f7 ff ff       	jmp    8010601a <alltraps>

80106912 <vector115>:
.globl vector115
vector115:
  pushl $0
80106912:	6a 00                	push   $0x0
  pushl $115
80106914:	6a 73                	push   $0x73
  jmp alltraps
80106916:	e9 ff f6 ff ff       	jmp    8010601a <alltraps>

8010691b <vector116>:
.globl vector116
vector116:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $116
8010691d:	6a 74                	push   $0x74
  jmp alltraps
8010691f:	e9 f6 f6 ff ff       	jmp    8010601a <alltraps>

80106924 <vector117>:
.globl vector117
vector117:
  pushl $0
80106924:	6a 00                	push   $0x0
  pushl $117
80106926:	6a 75                	push   $0x75
  jmp alltraps
80106928:	e9 ed f6 ff ff       	jmp    8010601a <alltraps>

8010692d <vector118>:
.globl vector118
vector118:
  pushl $0
8010692d:	6a 00                	push   $0x0
  pushl $118
8010692f:	6a 76                	push   $0x76
  jmp alltraps
80106931:	e9 e4 f6 ff ff       	jmp    8010601a <alltraps>

80106936 <vector119>:
.globl vector119
vector119:
  pushl $0
80106936:	6a 00                	push   $0x0
  pushl $119
80106938:	6a 77                	push   $0x77
  jmp alltraps
8010693a:	e9 db f6 ff ff       	jmp    8010601a <alltraps>

8010693f <vector120>:
.globl vector120
vector120:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $120
80106941:	6a 78                	push   $0x78
  jmp alltraps
80106943:	e9 d2 f6 ff ff       	jmp    8010601a <alltraps>

80106948 <vector121>:
.globl vector121
vector121:
  pushl $0
80106948:	6a 00                	push   $0x0
  pushl $121
8010694a:	6a 79                	push   $0x79
  jmp alltraps
8010694c:	e9 c9 f6 ff ff       	jmp    8010601a <alltraps>

80106951 <vector122>:
.globl vector122
vector122:
  pushl $0
80106951:	6a 00                	push   $0x0
  pushl $122
80106953:	6a 7a                	push   $0x7a
  jmp alltraps
80106955:	e9 c0 f6 ff ff       	jmp    8010601a <alltraps>

8010695a <vector123>:
.globl vector123
vector123:
  pushl $0
8010695a:	6a 00                	push   $0x0
  pushl $123
8010695c:	6a 7b                	push   $0x7b
  jmp alltraps
8010695e:	e9 b7 f6 ff ff       	jmp    8010601a <alltraps>

80106963 <vector124>:
.globl vector124
vector124:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $124
80106965:	6a 7c                	push   $0x7c
  jmp alltraps
80106967:	e9 ae f6 ff ff       	jmp    8010601a <alltraps>

8010696c <vector125>:
.globl vector125
vector125:
  pushl $0
8010696c:	6a 00                	push   $0x0
  pushl $125
8010696e:	6a 7d                	push   $0x7d
  jmp alltraps
80106970:	e9 a5 f6 ff ff       	jmp    8010601a <alltraps>

80106975 <vector126>:
.globl vector126
vector126:
  pushl $0
80106975:	6a 00                	push   $0x0
  pushl $126
80106977:	6a 7e                	push   $0x7e
  jmp alltraps
80106979:	e9 9c f6 ff ff       	jmp    8010601a <alltraps>

8010697e <vector127>:
.globl vector127
vector127:
  pushl $0
8010697e:	6a 00                	push   $0x0
  pushl $127
80106980:	6a 7f                	push   $0x7f
  jmp alltraps
80106982:	e9 93 f6 ff ff       	jmp    8010601a <alltraps>

80106987 <vector128>:
.globl vector128
vector128:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $128
80106989:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010698e:	e9 87 f6 ff ff       	jmp    8010601a <alltraps>

80106993 <vector129>:
.globl vector129
vector129:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $129
80106995:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010699a:	e9 7b f6 ff ff       	jmp    8010601a <alltraps>

8010699f <vector130>:
.globl vector130
vector130:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $130
801069a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801069a6:	e9 6f f6 ff ff       	jmp    8010601a <alltraps>

801069ab <vector131>:
.globl vector131
vector131:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $131
801069ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801069b2:	e9 63 f6 ff ff       	jmp    8010601a <alltraps>

801069b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $132
801069b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801069be:	e9 57 f6 ff ff       	jmp    8010601a <alltraps>

801069c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $133
801069c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801069ca:	e9 4b f6 ff ff       	jmp    8010601a <alltraps>

801069cf <vector134>:
.globl vector134
vector134:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $134
801069d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801069d6:	e9 3f f6 ff ff       	jmp    8010601a <alltraps>

801069db <vector135>:
.globl vector135
vector135:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $135
801069dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801069e2:	e9 33 f6 ff ff       	jmp    8010601a <alltraps>

801069e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $136
801069e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801069ee:	e9 27 f6 ff ff       	jmp    8010601a <alltraps>

801069f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $137
801069f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801069fa:	e9 1b f6 ff ff       	jmp    8010601a <alltraps>

801069ff <vector138>:
.globl vector138
vector138:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $138
80106a01:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106a06:	e9 0f f6 ff ff       	jmp    8010601a <alltraps>

80106a0b <vector139>:
.globl vector139
vector139:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $139
80106a0d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106a12:	e9 03 f6 ff ff       	jmp    8010601a <alltraps>

80106a17 <vector140>:
.globl vector140
vector140:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $140
80106a19:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106a1e:	e9 f7 f5 ff ff       	jmp    8010601a <alltraps>

80106a23 <vector141>:
.globl vector141
vector141:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $141
80106a25:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106a2a:	e9 eb f5 ff ff       	jmp    8010601a <alltraps>

80106a2f <vector142>:
.globl vector142
vector142:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $142
80106a31:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106a36:	e9 df f5 ff ff       	jmp    8010601a <alltraps>

80106a3b <vector143>:
.globl vector143
vector143:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $143
80106a3d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106a42:	e9 d3 f5 ff ff       	jmp    8010601a <alltraps>

80106a47 <vector144>:
.globl vector144
vector144:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $144
80106a49:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106a4e:	e9 c7 f5 ff ff       	jmp    8010601a <alltraps>

80106a53 <vector145>:
.globl vector145
vector145:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $145
80106a55:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106a5a:	e9 bb f5 ff ff       	jmp    8010601a <alltraps>

80106a5f <vector146>:
.globl vector146
vector146:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $146
80106a61:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106a66:	e9 af f5 ff ff       	jmp    8010601a <alltraps>

80106a6b <vector147>:
.globl vector147
vector147:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $147
80106a6d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106a72:	e9 a3 f5 ff ff       	jmp    8010601a <alltraps>

80106a77 <vector148>:
.globl vector148
vector148:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $148
80106a79:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106a7e:	e9 97 f5 ff ff       	jmp    8010601a <alltraps>

80106a83 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $149
80106a85:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a8a:	e9 8b f5 ff ff       	jmp    8010601a <alltraps>

80106a8f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $150
80106a91:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a96:	e9 7f f5 ff ff       	jmp    8010601a <alltraps>

80106a9b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $151
80106a9d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106aa2:	e9 73 f5 ff ff       	jmp    8010601a <alltraps>

80106aa7 <vector152>:
.globl vector152
vector152:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $152
80106aa9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106aae:	e9 67 f5 ff ff       	jmp    8010601a <alltraps>

80106ab3 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $153
80106ab5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106aba:	e9 5b f5 ff ff       	jmp    8010601a <alltraps>

80106abf <vector154>:
.globl vector154
vector154:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $154
80106ac1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106ac6:	e9 4f f5 ff ff       	jmp    8010601a <alltraps>

80106acb <vector155>:
.globl vector155
vector155:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $155
80106acd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106ad2:	e9 43 f5 ff ff       	jmp    8010601a <alltraps>

80106ad7 <vector156>:
.globl vector156
vector156:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $156
80106ad9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ade:	e9 37 f5 ff ff       	jmp    8010601a <alltraps>

80106ae3 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $157
80106ae5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106aea:	e9 2b f5 ff ff       	jmp    8010601a <alltraps>

80106aef <vector158>:
.globl vector158
vector158:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $158
80106af1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106af6:	e9 1f f5 ff ff       	jmp    8010601a <alltraps>

80106afb <vector159>:
.globl vector159
vector159:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $159
80106afd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106b02:	e9 13 f5 ff ff       	jmp    8010601a <alltraps>

80106b07 <vector160>:
.globl vector160
vector160:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $160
80106b09:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106b0e:	e9 07 f5 ff ff       	jmp    8010601a <alltraps>

80106b13 <vector161>:
.globl vector161
vector161:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $161
80106b15:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106b1a:	e9 fb f4 ff ff       	jmp    8010601a <alltraps>

80106b1f <vector162>:
.globl vector162
vector162:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $162
80106b21:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106b26:	e9 ef f4 ff ff       	jmp    8010601a <alltraps>

80106b2b <vector163>:
.globl vector163
vector163:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $163
80106b2d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106b32:	e9 e3 f4 ff ff       	jmp    8010601a <alltraps>

80106b37 <vector164>:
.globl vector164
vector164:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $164
80106b39:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106b3e:	e9 d7 f4 ff ff       	jmp    8010601a <alltraps>

80106b43 <vector165>:
.globl vector165
vector165:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $165
80106b45:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106b4a:	e9 cb f4 ff ff       	jmp    8010601a <alltraps>

80106b4f <vector166>:
.globl vector166
vector166:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $166
80106b51:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106b56:	e9 bf f4 ff ff       	jmp    8010601a <alltraps>

80106b5b <vector167>:
.globl vector167
vector167:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $167
80106b5d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106b62:	e9 b3 f4 ff ff       	jmp    8010601a <alltraps>

80106b67 <vector168>:
.globl vector168
vector168:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $168
80106b69:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106b6e:	e9 a7 f4 ff ff       	jmp    8010601a <alltraps>

80106b73 <vector169>:
.globl vector169
vector169:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $169
80106b75:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106b7a:	e9 9b f4 ff ff       	jmp    8010601a <alltraps>

80106b7f <vector170>:
.globl vector170
vector170:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $170
80106b81:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b86:	e9 8f f4 ff ff       	jmp    8010601a <alltraps>

80106b8b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $171
80106b8d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b92:	e9 83 f4 ff ff       	jmp    8010601a <alltraps>

80106b97 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $172
80106b99:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b9e:	e9 77 f4 ff ff       	jmp    8010601a <alltraps>

80106ba3 <vector173>:
.globl vector173
vector173:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $173
80106ba5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106baa:	e9 6b f4 ff ff       	jmp    8010601a <alltraps>

80106baf <vector174>:
.globl vector174
vector174:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $174
80106bb1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106bb6:	e9 5f f4 ff ff       	jmp    8010601a <alltraps>

80106bbb <vector175>:
.globl vector175
vector175:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $175
80106bbd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106bc2:	e9 53 f4 ff ff       	jmp    8010601a <alltraps>

80106bc7 <vector176>:
.globl vector176
vector176:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $176
80106bc9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106bce:	e9 47 f4 ff ff       	jmp    8010601a <alltraps>

80106bd3 <vector177>:
.globl vector177
vector177:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $177
80106bd5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106bda:	e9 3b f4 ff ff       	jmp    8010601a <alltraps>

80106bdf <vector178>:
.globl vector178
vector178:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $178
80106be1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106be6:	e9 2f f4 ff ff       	jmp    8010601a <alltraps>

80106beb <vector179>:
.globl vector179
vector179:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $179
80106bed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106bf2:	e9 23 f4 ff ff       	jmp    8010601a <alltraps>

80106bf7 <vector180>:
.globl vector180
vector180:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $180
80106bf9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106bfe:	e9 17 f4 ff ff       	jmp    8010601a <alltraps>

80106c03 <vector181>:
.globl vector181
vector181:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $181
80106c05:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106c0a:	e9 0b f4 ff ff       	jmp    8010601a <alltraps>

80106c0f <vector182>:
.globl vector182
vector182:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $182
80106c11:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106c16:	e9 ff f3 ff ff       	jmp    8010601a <alltraps>

80106c1b <vector183>:
.globl vector183
vector183:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $183
80106c1d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106c22:	e9 f3 f3 ff ff       	jmp    8010601a <alltraps>

80106c27 <vector184>:
.globl vector184
vector184:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $184
80106c29:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106c2e:	e9 e7 f3 ff ff       	jmp    8010601a <alltraps>

80106c33 <vector185>:
.globl vector185
vector185:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $185
80106c35:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106c3a:	e9 db f3 ff ff       	jmp    8010601a <alltraps>

80106c3f <vector186>:
.globl vector186
vector186:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $186
80106c41:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106c46:	e9 cf f3 ff ff       	jmp    8010601a <alltraps>

80106c4b <vector187>:
.globl vector187
vector187:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $187
80106c4d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106c52:	e9 c3 f3 ff ff       	jmp    8010601a <alltraps>

80106c57 <vector188>:
.globl vector188
vector188:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $188
80106c59:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106c5e:	e9 b7 f3 ff ff       	jmp    8010601a <alltraps>

80106c63 <vector189>:
.globl vector189
vector189:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $189
80106c65:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106c6a:	e9 ab f3 ff ff       	jmp    8010601a <alltraps>

80106c6f <vector190>:
.globl vector190
vector190:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $190
80106c71:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106c76:	e9 9f f3 ff ff       	jmp    8010601a <alltraps>

80106c7b <vector191>:
.globl vector191
vector191:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $191
80106c7d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c82:	e9 93 f3 ff ff       	jmp    8010601a <alltraps>

80106c87 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $192
80106c89:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c8e:	e9 87 f3 ff ff       	jmp    8010601a <alltraps>

80106c93 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $193
80106c95:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c9a:	e9 7b f3 ff ff       	jmp    8010601a <alltraps>

80106c9f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $194
80106ca1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106ca6:	e9 6f f3 ff ff       	jmp    8010601a <alltraps>

80106cab <vector195>:
.globl vector195
vector195:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $195
80106cad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106cb2:	e9 63 f3 ff ff       	jmp    8010601a <alltraps>

80106cb7 <vector196>:
.globl vector196
vector196:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $196
80106cb9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106cbe:	e9 57 f3 ff ff       	jmp    8010601a <alltraps>

80106cc3 <vector197>:
.globl vector197
vector197:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $197
80106cc5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106cca:	e9 4b f3 ff ff       	jmp    8010601a <alltraps>

80106ccf <vector198>:
.globl vector198
vector198:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $198
80106cd1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106cd6:	e9 3f f3 ff ff       	jmp    8010601a <alltraps>

80106cdb <vector199>:
.globl vector199
vector199:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $199
80106cdd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ce2:	e9 33 f3 ff ff       	jmp    8010601a <alltraps>

80106ce7 <vector200>:
.globl vector200
vector200:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $200
80106ce9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106cee:	e9 27 f3 ff ff       	jmp    8010601a <alltraps>

80106cf3 <vector201>:
.globl vector201
vector201:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $201
80106cf5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106cfa:	e9 1b f3 ff ff       	jmp    8010601a <alltraps>

80106cff <vector202>:
.globl vector202
vector202:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $202
80106d01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106d06:	e9 0f f3 ff ff       	jmp    8010601a <alltraps>

80106d0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $203
80106d0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106d12:	e9 03 f3 ff ff       	jmp    8010601a <alltraps>

80106d17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106d17:	6a 00                	push   $0x0
  pushl $204
80106d19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106d1e:	e9 f7 f2 ff ff       	jmp    8010601a <alltraps>

80106d23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106d23:	6a 00                	push   $0x0
  pushl $205
80106d25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106d2a:	e9 eb f2 ff ff       	jmp    8010601a <alltraps>

80106d2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106d2f:	6a 00                	push   $0x0
  pushl $206
80106d31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106d36:	e9 df f2 ff ff       	jmp    8010601a <alltraps>

80106d3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106d3b:	6a 00                	push   $0x0
  pushl $207
80106d3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106d42:	e9 d3 f2 ff ff       	jmp    8010601a <alltraps>

80106d47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106d47:	6a 00                	push   $0x0
  pushl $208
80106d49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106d4e:	e9 c7 f2 ff ff       	jmp    8010601a <alltraps>

80106d53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $209
80106d55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106d5a:	e9 bb f2 ff ff       	jmp    8010601a <alltraps>

80106d5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106d5f:	6a 00                	push   $0x0
  pushl $210
80106d61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106d66:	e9 af f2 ff ff       	jmp    8010601a <alltraps>

80106d6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106d6b:	6a 00                	push   $0x0
  pushl $211
80106d6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106d72:	e9 a3 f2 ff ff       	jmp    8010601a <alltraps>

80106d77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $212
80106d79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106d7e:	e9 97 f2 ff ff       	jmp    8010601a <alltraps>

80106d83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d83:	6a 00                	push   $0x0
  pushl $213
80106d85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d8a:	e9 8b f2 ff ff       	jmp    8010601a <alltraps>

80106d8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d8f:	6a 00                	push   $0x0
  pushl $214
80106d91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d96:	e9 7f f2 ff ff       	jmp    8010601a <alltraps>

80106d9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d9b:	6a 00                	push   $0x0
  pushl $215
80106d9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106da2:	e9 73 f2 ff ff       	jmp    8010601a <alltraps>

80106da7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $216
80106da9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106dae:	e9 67 f2 ff ff       	jmp    8010601a <alltraps>

80106db3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $217
80106db5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106dba:	e9 5b f2 ff ff       	jmp    8010601a <alltraps>

80106dbf <vector218>:
.globl vector218
vector218:
  pushl $0
80106dbf:	6a 00                	push   $0x0
  pushl $218
80106dc1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106dc6:	e9 4f f2 ff ff       	jmp    8010601a <alltraps>

80106dcb <vector219>:
.globl vector219
vector219:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $219
80106dcd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106dd2:	e9 43 f2 ff ff       	jmp    8010601a <alltraps>

80106dd7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106dd7:	6a 00                	push   $0x0
  pushl $220
80106dd9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106dde:	e9 37 f2 ff ff       	jmp    8010601a <alltraps>

80106de3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106de3:	6a 00                	push   $0x0
  pushl $221
80106de5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106dea:	e9 2b f2 ff ff       	jmp    8010601a <alltraps>

80106def <vector222>:
.globl vector222
vector222:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $222
80106df1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106df6:	e9 1f f2 ff ff       	jmp    8010601a <alltraps>

80106dfb <vector223>:
.globl vector223
vector223:
  pushl $0
80106dfb:	6a 00                	push   $0x0
  pushl $223
80106dfd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106e02:	e9 13 f2 ff ff       	jmp    8010601a <alltraps>

80106e07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106e07:	6a 00                	push   $0x0
  pushl $224
80106e09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106e0e:	e9 07 f2 ff ff       	jmp    8010601a <alltraps>

80106e13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $225
80106e15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106e1a:	e9 fb f1 ff ff       	jmp    8010601a <alltraps>

80106e1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106e1f:	6a 00                	push   $0x0
  pushl $226
80106e21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106e26:	e9 ef f1 ff ff       	jmp    8010601a <alltraps>

80106e2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106e2b:	6a 00                	push   $0x0
  pushl $227
80106e2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106e32:	e9 e3 f1 ff ff       	jmp    8010601a <alltraps>

80106e37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $228
80106e39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106e3e:	e9 d7 f1 ff ff       	jmp    8010601a <alltraps>

80106e43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106e43:	6a 00                	push   $0x0
  pushl $229
80106e45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106e4a:	e9 cb f1 ff ff       	jmp    8010601a <alltraps>

80106e4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106e4f:	6a 00                	push   $0x0
  pushl $230
80106e51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106e56:	e9 bf f1 ff ff       	jmp    8010601a <alltraps>

80106e5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $231
80106e5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106e62:	e9 b3 f1 ff ff       	jmp    8010601a <alltraps>

80106e67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106e67:	6a 00                	push   $0x0
  pushl $232
80106e69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106e6e:	e9 a7 f1 ff ff       	jmp    8010601a <alltraps>

80106e73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106e73:	6a 00                	push   $0x0
  pushl $233
80106e75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106e7a:	e9 9b f1 ff ff       	jmp    8010601a <alltraps>

80106e7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $234
80106e81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e86:	e9 8f f1 ff ff       	jmp    8010601a <alltraps>

80106e8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e8b:	6a 00                	push   $0x0
  pushl $235
80106e8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e92:	e9 83 f1 ff ff       	jmp    8010601a <alltraps>

80106e97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e97:	6a 00                	push   $0x0
  pushl $236
80106e99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e9e:	e9 77 f1 ff ff       	jmp    8010601a <alltraps>

80106ea3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $237
80106ea5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106eaa:	e9 6b f1 ff ff       	jmp    8010601a <alltraps>

80106eaf <vector238>:
.globl vector238
vector238:
  pushl $0
80106eaf:	6a 00                	push   $0x0
  pushl $238
80106eb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106eb6:	e9 5f f1 ff ff       	jmp    8010601a <alltraps>

80106ebb <vector239>:
.globl vector239
vector239:
  pushl $0
80106ebb:	6a 00                	push   $0x0
  pushl $239
80106ebd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106ec2:	e9 53 f1 ff ff       	jmp    8010601a <alltraps>

80106ec7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $240
80106ec9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106ece:	e9 47 f1 ff ff       	jmp    8010601a <alltraps>

80106ed3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106ed3:	6a 00                	push   $0x0
  pushl $241
80106ed5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106eda:	e9 3b f1 ff ff       	jmp    8010601a <alltraps>

80106edf <vector242>:
.globl vector242
vector242:
  pushl $0
80106edf:	6a 00                	push   $0x0
  pushl $242
80106ee1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106ee6:	e9 2f f1 ff ff       	jmp    8010601a <alltraps>

80106eeb <vector243>:
.globl vector243
vector243:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $243
80106eed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ef2:	e9 23 f1 ff ff       	jmp    8010601a <alltraps>

80106ef7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ef7:	6a 00                	push   $0x0
  pushl $244
80106ef9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106efe:	e9 17 f1 ff ff       	jmp    8010601a <alltraps>

80106f03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106f03:	6a 00                	push   $0x0
  pushl $245
80106f05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106f0a:	e9 0b f1 ff ff       	jmp    8010601a <alltraps>

80106f0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $246
80106f11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106f16:	e9 ff f0 ff ff       	jmp    8010601a <alltraps>

80106f1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106f1b:	6a 00                	push   $0x0
  pushl $247
80106f1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106f22:	e9 f3 f0 ff ff       	jmp    8010601a <alltraps>

80106f27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106f27:	6a 00                	push   $0x0
  pushl $248
80106f29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106f2e:	e9 e7 f0 ff ff       	jmp    8010601a <alltraps>

80106f33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $249
80106f35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106f3a:	e9 db f0 ff ff       	jmp    8010601a <alltraps>

80106f3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106f3f:	6a 00                	push   $0x0
  pushl $250
80106f41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106f46:	e9 cf f0 ff ff       	jmp    8010601a <alltraps>

80106f4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106f4b:	6a 00                	push   $0x0
  pushl $251
80106f4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106f52:	e9 c3 f0 ff ff       	jmp    8010601a <alltraps>

80106f57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $252
80106f59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106f5e:	e9 b7 f0 ff ff       	jmp    8010601a <alltraps>

80106f63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106f63:	6a 00                	push   $0x0
  pushl $253
80106f65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106f6a:	e9 ab f0 ff ff       	jmp    8010601a <alltraps>

80106f6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106f6f:	6a 00                	push   $0x0
  pushl $254
80106f71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106f76:	e9 9f f0 ff ff       	jmp    8010601a <alltraps>

80106f7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $255
80106f7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f82:	e9 93 f0 ff ff       	jmp    8010601a <alltraps>
80106f87:	66 90                	xchg   %ax,%ax
80106f89:	66 90                	xchg   %ax,%ax
80106f8b:	66 90                	xchg   %ax,%ax
80106f8d:	66 90                	xchg   %ax,%ax
80106f8f:	90                   	nop

80106f90 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106f96:	e8 75 d0 ff ff       	call   80104010 <cpuid>
80106f9b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106fa1:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106fa6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106faa:	c7 80 b8 b8 22 80 ff 	movl   $0xffff,-0x7fdd4748(%eax)
80106fb1:	ff 00 00 
80106fb4:	c7 80 bc b8 22 80 00 	movl   $0xcf9a00,-0x7fdd4744(%eax)
80106fbb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106fbe:	c7 80 c0 b8 22 80 ff 	movl   $0xffff,-0x7fdd4740(%eax)
80106fc5:	ff 00 00 
80106fc8:	c7 80 c4 b8 22 80 00 	movl   $0xcf9200,-0x7fdd473c(%eax)
80106fcf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106fd2:	c7 80 c8 b8 22 80 ff 	movl   $0xffff,-0x7fdd4738(%eax)
80106fd9:	ff 00 00 
80106fdc:	c7 80 cc b8 22 80 00 	movl   $0xcffa00,-0x7fdd4734(%eax)
80106fe3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106fe6:	c7 80 d0 b8 22 80 ff 	movl   $0xffff,-0x7fdd4730(%eax)
80106fed:	ff 00 00 
80106ff0:	c7 80 d4 b8 22 80 00 	movl   $0xcff200,-0x7fdd472c(%eax)
80106ff7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106ffa:	05 b0 b8 22 80       	add    $0x8022b8b0,%eax
  pd[1] = (uint)p;
80106fff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107003:	c1 e8 10             	shr    $0x10,%eax
80107006:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010700a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010700d:	0f 01 10             	lgdtl  (%eax)
}
80107010:	c9                   	leave  
80107011:	c3                   	ret    
80107012:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107020 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107020:	55                   	push   %ebp
80107021:	89 e5                	mov    %esp,%ebp
80107023:	57                   	push   %edi
80107024:	56                   	push   %esi
80107025:	53                   	push   %ebx
80107026:	83 ec 0c             	sub    $0xc,%esp
80107029:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010702c:	8b 55 08             	mov    0x8(%ebp),%edx
8010702f:	89 fe                	mov    %edi,%esi
80107031:	c1 ee 16             	shr    $0x16,%esi
80107034:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80107037:	8b 1e                	mov    (%esi),%ebx
80107039:	f6 c3 01             	test   $0x1,%bl
8010703c:	74 22                	je     80107060 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010703e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107044:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010704a:	89 f8                	mov    %edi,%eax
}
8010704c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010704f:	c1 e8 0a             	shr    $0xa,%eax
80107052:	25 fc 0f 00 00       	and    $0xffc,%eax
80107057:	01 d8                	add    %ebx,%eax
}
80107059:	5b                   	pop    %ebx
8010705a:	5e                   	pop    %esi
8010705b:	5f                   	pop    %edi
8010705c:	5d                   	pop    %ebp
8010705d:	c3                   	ret    
8010705e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107060:	8b 45 10             	mov    0x10(%ebp),%eax
80107063:	85 c0                	test   %eax,%eax
80107065:	74 31                	je     80107098 <walkpgdir+0x78>
80107067:	e8 f4 b7 ff ff       	call   80102860 <kalloc>
8010706c:	85 c0                	test   %eax,%eax
8010706e:	89 c3                	mov    %eax,%ebx
80107070:	74 26                	je     80107098 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80107072:	83 ec 04             	sub    $0x4,%esp
80107075:	68 00 10 00 00       	push   $0x1000
8010707a:	6a 00                	push   $0x0
8010707c:	50                   	push   %eax
8010707d:	e8 9e dc ff ff       	call   80104d20 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107082:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107088:	83 c4 10             	add    $0x10,%esp
8010708b:	83 c8 07             	or     $0x7,%eax
8010708e:	89 06                	mov    %eax,(%esi)
80107090:	eb b8                	jmp    8010704a <walkpgdir+0x2a>
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80107098:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
8010709b:	31 c0                	xor    %eax,%eax
}
8010709d:	5b                   	pop    %ebx
8010709e:	5e                   	pop    %esi
8010709f:	5f                   	pop    %edi
801070a0:	5d                   	pop    %ebp
801070a1:	c3                   	ret    
801070a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070b0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070b6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801070ba:	56                   	push   %esi
801070bb:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801070bc:	89 d6                	mov    %edx,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
{
801070c3:	83 ec 1c             	sub    $0x1c,%esp
  a = (char*)PGROUNDDOWN((uint)va);
801070c6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070cf:	8b 45 08             	mov    0x8(%ebp),%eax
801070d2:	29 f0                	sub    %esi,%eax
801070d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801070d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801070da:	83 c8 01             	or     $0x1,%eax
801070dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801070e0:	eb 1b                	jmp    801070fd <mappages+0x4d>
801070e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
801070e8:	f6 00 01             	testb  $0x1,(%eax)
801070eb:	75 45                	jne    80107132 <mappages+0x82>
    *pte = pa | perm | PTE_P;
801070ed:	0b 5d dc             	or     -0x24(%ebp),%ebx
    if(a == last)
801070f0:	3b 75 e0             	cmp    -0x20(%ebp),%esi
    *pte = pa | perm | PTE_P;
801070f3:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801070f5:	74 31                	je     80107128 <mappages+0x78>
      break;
    a += PGSIZE;
801070f7:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801070fd:	83 ec 04             	sub    $0x4,%esp
80107100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107103:	6a 01                	push   $0x1
80107105:	56                   	push   %esi
80107106:	57                   	push   %edi
80107107:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
8010710a:	e8 11 ff ff ff       	call   80107020 <walkpgdir>
8010710f:	83 c4 10             	add    $0x10,%esp
80107112:	85 c0                	test   %eax,%eax
80107114:	75 d2                	jne    801070e8 <mappages+0x38>
    pa += PGSIZE;
  }
  return 0;
}
80107116:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107119:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010711e:	5b                   	pop    %ebx
8010711f:	5e                   	pop    %esi
80107120:	5f                   	pop    %edi
80107121:	5d                   	pop    %ebp
80107122:	c3                   	ret    
80107123:	90                   	nop
80107124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107128:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010712b:	31 c0                	xor    %eax,%eax
}
8010712d:	5b                   	pop    %ebx
8010712e:	5e                   	pop    %esi
8010712f:	5f                   	pop    %edi
80107130:	5d                   	pop    %ebp
80107131:	c3                   	ret    
      panic("remap");
80107132:	83 ec 0c             	sub    $0xc,%esp
80107135:	68 dc 83 10 80       	push   $0x801083dc
8010713a:	e8 51 92 ff ff       	call   80100390 <panic>
8010713f:	90                   	nop

80107140 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	89 d3                	mov    %edx,%ebx
80107148:	89 c6                	mov    %eax,%esi
8010714a:	83 ec 1c             	sub    $0x1c,%esp
8010714d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80107150:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107156:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  a = PGROUNDUP(newsz);
80107159:	89 d7                	mov    %edx,%edi
8010715b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(; a  < oldsz; a += PGSIZE){
80107161:	39 df                	cmp    %ebx,%edi
80107163:	72 55                	jb     801071ba <deallocuvm.part.0+0x7a>
80107165:	eb 7f                	jmp    801071e6 <deallocuvm.part.0+0xa6>
80107167:	89 f6                	mov    %esi,%esi
80107169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80107170:	8b 18                	mov    (%eax),%ebx
80107172:	f6 c3 01             	test   $0x1,%bl
80107175:	74 38                	je     801071af <deallocuvm.part.0+0x6f>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107177:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010717d:	74 72                	je     801071f1 <deallocuvm.part.0+0xb1>
        panic("kfree");
      int ck = delete_pages((char*)a,pgdir);
8010717f:	83 ec 08             	sub    $0x8,%esp
80107182:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107185:	56                   	push   %esi
80107186:	57                   	push   %edi
80107187:	e8 34 b9 ff ff       	call   80102ac0 <delete_pages>
      if(ck==2) continue; 
8010718c:	83 c4 10             	add    $0x10,%esp
8010718f:	83 f8 02             	cmp    $0x2,%eax
80107192:	74 1b                	je     801071af <deallocuvm.part.0+0x6f>
      char *v = P2V(pa);
      kfree(v);
80107194:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80107197:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
      kfree(v);
8010719d:	53                   	push   %ebx
8010719e:	e8 3d b3 ff ff       	call   801024e0 <kfree>
      *pte = 0;
801071a3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801071a6:	83 c4 10             	add    $0x10,%esp
801071a9:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  for(; a  < oldsz; a += PGSIZE){
801071af:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071b5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801071b8:	73 2c                	jae    801071e6 <deallocuvm.part.0+0xa6>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071ba:	83 ec 04             	sub    $0x4,%esp
801071bd:	6a 00                	push   $0x0
801071bf:	57                   	push   %edi
801071c0:	56                   	push   %esi
801071c1:	e8 5a fe ff ff       	call   80107020 <walkpgdir>
    if(!pte)
801071c6:	83 c4 10             	add    $0x10,%esp
801071c9:	85 c0                	test   %eax,%eax
801071cb:	75 a3                	jne    80107170 <deallocuvm.part.0+0x30>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071cd:	89 fa                	mov    %edi,%edx
801071cf:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801071d5:	8d ba 00 f0 3f 00    	lea    0x3ff000(%edx),%edi
  for(; a  < oldsz; a += PGSIZE){
801071db:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071e1:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801071e4:	72 d4                	jb     801071ba <deallocuvm.part.0+0x7a>
    }
  }
  return newsz;
}
801071e6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801071e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071ec:	5b                   	pop    %ebx
801071ed:	5e                   	pop    %esi
801071ee:	5f                   	pop    %edi
801071ef:	5d                   	pop    %ebp
801071f0:	c3                   	ret    
        panic("kfree");
801071f1:	83 ec 0c             	sub    $0xc,%esp
801071f4:	68 62 7c 10 80       	push   $0x80107c62
801071f9:	e8 92 91 ff ff       	call   80100390 <panic>
801071fe:	66 90                	xchg   %ax,%ax

80107200 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107200:	a1 64 e5 22 80       	mov    0x8022e564,%eax
{
80107205:	55                   	push   %ebp
80107206:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107208:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010720d:	0f 22 d8             	mov    %eax,%cr3
}
80107210:	5d                   	pop    %ebp
80107211:	c3                   	ret    
80107212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107220 <switchuvm>:
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
80107229:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010722c:	85 db                	test   %ebx,%ebx
8010722e:	0f 84 cb 00 00 00    	je     801072ff <switchuvm+0xdf>
  if(p->kstack == 0)
80107234:	8b 43 08             	mov    0x8(%ebx),%eax
80107237:	85 c0                	test   %eax,%eax
80107239:	0f 84 da 00 00 00    	je     80107319 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010723f:	8b 43 04             	mov    0x4(%ebx),%eax
80107242:	85 c0                	test   %eax,%eax
80107244:	0f 84 c2 00 00 00    	je     8010730c <switchuvm+0xec>
  pushcli();
8010724a:	e8 e1 d8 ff ff       	call   80104b30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010724f:	e8 3c cd ff ff       	call   80103f90 <mycpu>
80107254:	89 c6                	mov    %eax,%esi
80107256:	e8 35 cd ff ff       	call   80103f90 <mycpu>
8010725b:	89 c7                	mov    %eax,%edi
8010725d:	e8 2e cd ff ff       	call   80103f90 <mycpu>
80107262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107265:	83 c7 08             	add    $0x8,%edi
80107268:	e8 23 cd ff ff       	call   80103f90 <mycpu>
8010726d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107270:	83 c0 08             	add    $0x8,%eax
80107273:	ba 67 00 00 00       	mov    $0x67,%edx
80107278:	c1 e8 18             	shr    $0x18,%eax
8010727b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80107282:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80107289:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010728f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107294:	83 c1 08             	add    $0x8,%ecx
80107297:	c1 e9 10             	shr    $0x10,%ecx
8010729a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
801072a0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801072a5:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072ac:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801072b1:	e8 da cc ff ff       	call   80103f90 <mycpu>
801072b6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801072bd:	e8 ce cc ff ff       	call   80103f90 <mycpu>
801072c2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801072c6:	8b 73 08             	mov    0x8(%ebx),%esi
801072c9:	e8 c2 cc ff ff       	call   80103f90 <mycpu>
801072ce:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072d4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801072d7:	e8 b4 cc ff ff       	call   80103f90 <mycpu>
801072dc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801072e0:	b8 28 00 00 00       	mov    $0x28,%eax
801072e5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801072e8:	8b 43 04             	mov    0x4(%ebx),%eax
801072eb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072f0:	0f 22 d8             	mov    %eax,%cr3
}
801072f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072f6:	5b                   	pop    %ebx
801072f7:	5e                   	pop    %esi
801072f8:	5f                   	pop    %edi
801072f9:	5d                   	pop    %ebp
  popcli();
801072fa:	e9 71 d8 ff ff       	jmp    80104b70 <popcli>
    panic("switchuvm: no process");
801072ff:	83 ec 0c             	sub    $0xc,%esp
80107302:	68 e2 83 10 80       	push   $0x801083e2
80107307:	e8 84 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
8010730c:	83 ec 0c             	sub    $0xc,%esp
8010730f:	68 0d 84 10 80       	push   $0x8010840d
80107314:	e8 77 90 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	68 f8 83 10 80       	push   $0x801083f8
80107321:	e8 6a 90 ff ff       	call   80100390 <panic>
80107326:	8d 76 00             	lea    0x0(%esi),%esi
80107329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107330 <inituvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	8b 7d 10             	mov    0x10(%ebp),%edi
8010733c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010733f:	8b 75 08             	mov    0x8(%ebp),%esi
  if(sz >= PGSIZE)
80107342:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
{
80107348:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010734b:	0f 87 85 00 00 00    	ja     801073d6 <inituvm+0xa6>
  mem = kalloc();
80107351:	e8 0a b5 ff ff       	call   80102860 <kalloc>
  memset(mem, 0, PGSIZE);
80107356:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107359:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010735b:	68 00 10 00 00       	push   $0x1000
80107360:	6a 00                	push   $0x0
80107362:	50                   	push   %eax
80107363:	e8 b8 d9 ff ff       	call   80104d20 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107368:	58                   	pop    %eax
80107369:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010736f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107374:	5a                   	pop    %edx
80107375:	6a 06                	push   $0x6
80107377:	50                   	push   %eax
80107378:	31 d2                	xor    %edx,%edx
8010737a:	89 f0                	mov    %esi,%eax
8010737c:	e8 2f fd ff ff       	call   801070b0 <mappages>
  memmove(mem, init, sz);
80107381:	83 c4 0c             	add    $0xc,%esp
80107384:	57                   	push   %edi
80107385:	ff 75 e4             	pushl  -0x1c(%ebp)
80107388:	53                   	push   %ebx
80107389:	e8 42 da ff ff       	call   80104dd0 <memmove>
  if(*pde & PTE_P){
8010738e:	8b 06                	mov    (%esi),%eax
80107390:	83 c4 10             	add    $0x10,%esp
80107393:	a8 01                	test   $0x1,%al
80107395:	74 19                	je     801073b0 <inituvm+0x80>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107397:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if(*pte&PTE_U) add_pglist(0,pgdir);
8010739c:	f6 80 00 00 00 80 04 	testb  $0x4,-0x80000000(%eax)
801073a3:	75 1b                	jne    801073c0 <inituvm+0x90>
}
801073a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a8:	5b                   	pop    %ebx
801073a9:	5e                   	pop    %esi
801073aa:	5f                   	pop    %edi
801073ab:	5d                   	pop    %ebp
801073ac:	c3                   	ret    
801073ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pte&PTE_U) add_pglist(0,pgdir);
801073b0:	a1 00 00 00 00       	mov    0x0,%eax
801073b5:	0f 0b                	ud2    
801073b7:	89 f6                	mov    %esi,%esi
801073b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801073c0:	89 75 0c             	mov    %esi,0xc(%ebp)
801073c3:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
801073ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073cd:	5b                   	pop    %ebx
801073ce:	5e                   	pop    %esi
801073cf:	5f                   	pop    %edi
801073d0:	5d                   	pop    %ebp
  if(*pte&PTE_U) add_pglist(0,pgdir);
801073d1:	e9 aa b5 ff ff       	jmp    80102980 <add_pglist>
    panic("inituvm: more than a page");
801073d6:	83 ec 0c             	sub    $0xc,%esp
801073d9:	68 21 84 10 80       	push   $0x80108421
801073de:	e8 ad 8f ff ff       	call   80100390 <panic>
801073e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073f0 <loaduvm>:
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
801073f9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107400:	0f 85 99 00 00 00    	jne    8010749f <loaduvm+0xaf>
  for(i = 0; i < sz; i += PGSIZE){
80107406:	8b 5d 18             	mov    0x18(%ebp),%ebx
80107409:	31 ff                	xor    %edi,%edi
8010740b:	85 db                	test   %ebx,%ebx
8010740d:	75 1a                	jne    80107429 <loaduvm+0x39>
8010740f:	eb 77                	jmp    80107488 <loaduvm+0x98>
80107411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107418:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010741e:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107424:	39 7d 18             	cmp    %edi,0x18(%ebp)
80107427:	76 5f                	jbe    80107488 <loaduvm+0x98>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107429:	8b 45 0c             	mov    0xc(%ebp),%eax
8010742c:	83 ec 04             	sub    $0x4,%esp
8010742f:	6a 00                	push   $0x0
80107431:	01 f8                	add    %edi,%eax
80107433:	50                   	push   %eax
80107434:	ff 75 08             	pushl  0x8(%ebp)
80107437:	e8 e4 fb ff ff       	call   80107020 <walkpgdir>
8010743c:	83 c4 10             	add    $0x10,%esp
8010743f:	85 c0                	test   %eax,%eax
80107441:	74 4f                	je     80107492 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
80107443:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107445:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80107448:	be 00 10 00 00       	mov    $0x1000,%esi
    pa = PTE_ADDR(*pte);
8010744d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107452:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80107458:	0f 46 f3             	cmovbe %ebx,%esi
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010745b:	01 f9                	add    %edi,%ecx
8010745d:	05 00 00 00 80       	add    $0x80000000,%eax
80107462:	56                   	push   %esi
80107463:	51                   	push   %ecx
80107464:	50                   	push   %eax
80107465:	ff 75 10             	pushl  0x10(%ebp)
80107468:	e8 03 a5 ff ff       	call   80101970 <readi>
8010746d:	83 c4 10             	add    $0x10,%esp
80107470:	39 f0                	cmp    %esi,%eax
80107472:	74 a4                	je     80107418 <loaduvm+0x28>
}
80107474:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107477:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010747c:	5b                   	pop    %ebx
8010747d:	5e                   	pop    %esi
8010747e:	5f                   	pop    %edi
8010747f:	5d                   	pop    %ebp
80107480:	c3                   	ret    
80107481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107488:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010748b:	31 c0                	xor    %eax,%eax
}
8010748d:	5b                   	pop    %ebx
8010748e:	5e                   	pop    %esi
8010748f:	5f                   	pop    %edi
80107490:	5d                   	pop    %ebp
80107491:	c3                   	ret    
      panic("loaduvm: address should exist");
80107492:	83 ec 0c             	sub    $0xc,%esp
80107495:	68 3b 84 10 80       	push   $0x8010843b
8010749a:	e8 f1 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
8010749f:	83 ec 0c             	sub    $0xc,%esp
801074a2:	68 dc 84 10 80       	push   $0x801084dc
801074a7:	e8 e4 8e ff ff       	call   80100390 <panic>
801074ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074b0 <allocuvm>:
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801074b9:	8b 7d 10             	mov    0x10(%ebp),%edi
801074bc:	85 ff                	test   %edi,%edi
801074be:	0f 88 e4 00 00 00    	js     801075a8 <allocuvm+0xf8>
  if(newsz < oldsz)
801074c4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801074c7:	0f 82 b3 00 00 00    	jb     80107580 <allocuvm+0xd0>
  a = PGROUNDUP(oldsz);
801074cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801074d0:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801074d6:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801074dc:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801074df:	0f 86 9e 00 00 00    	jbe    80107583 <allocuvm+0xd3>
801074e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801074e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801074eb:	eb 0e                	jmp    801074fb <allocuvm+0x4b>
801074ed:	8d 76 00             	lea    0x0(%esi),%esi
801074f0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801074f6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801074f9:	76 70                	jbe    8010756b <allocuvm+0xbb>
    mem = kalloc();
801074fb:	e8 60 b3 ff ff       	call   80102860 <kalloc>
    if(mem == 0){
80107500:	85 c0                	test   %eax,%eax
    mem = kalloc();
80107502:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80107504:	0f 84 86 00 00 00    	je     80107590 <allocuvm+0xe0>
    memset(mem, 0, PGSIZE);
8010750a:	83 ec 04             	sub    $0x4,%esp
8010750d:	68 00 10 00 00       	push   $0x1000
80107512:	6a 00                	push   $0x0
80107514:	50                   	push   %eax
80107515:	e8 06 d8 ff ff       	call   80104d20 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010751a:	58                   	pop    %eax
8010751b:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107521:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107526:	5a                   	pop    %edx
80107527:	6a 06                	push   $0x6
80107529:	50                   	push   %eax
8010752a:	89 da                	mov    %ebx,%edx
8010752c:	89 f8                	mov    %edi,%eax
8010752e:	e8 7d fb ff ff       	call   801070b0 <mappages>
80107533:	83 c4 10             	add    $0x10,%esp
80107536:	85 c0                	test   %eax,%eax
80107538:	78 7e                	js     801075b8 <allocuvm+0x108>
    pte_t* pte = walkpgdir(pgdir,(char*)a,0);
8010753a:	83 ec 04             	sub    $0x4,%esp
8010753d:	6a 00                	push   $0x0
8010753f:	53                   	push   %ebx
80107540:	57                   	push   %edi
80107541:	e8 da fa ff ff       	call   80107020 <walkpgdir>
    if((*pte&PTE_U)&&(*pte&PTE_P)) add_pglist((char*)a,pgdir);
80107546:	8b 00                	mov    (%eax),%eax
80107548:	83 c4 10             	add    $0x10,%esp
8010754b:	83 e0 05             	and    $0x5,%eax
8010754e:	83 f8 05             	cmp    $0x5,%eax
80107551:	75 9d                	jne    801074f0 <allocuvm+0x40>
80107553:	83 ec 08             	sub    $0x8,%esp
80107556:	57                   	push   %edi
80107557:	53                   	push   %ebx
  for(; a < newsz; a += PGSIZE){
80107558:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((*pte&PTE_U)&&(*pte&PTE_P)) add_pglist((char*)a,pgdir);
8010755e:	e8 1d b4 ff ff       	call   80102980 <add_pglist>
80107563:	83 c4 10             	add    $0x10,%esp
  for(; a < newsz; a += PGSIZE){
80107566:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80107569:	77 90                	ja     801074fb <allocuvm+0x4b>
8010756b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
}
8010756e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107571:	5b                   	pop    %ebx
80107572:	89 f8                	mov    %edi,%eax
80107574:	5e                   	pop    %esi
80107575:	5f                   	pop    %edi
80107576:	5d                   	pop    %ebp
80107577:	c3                   	ret    
80107578:	90                   	nop
80107579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107580:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80107583:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107586:	89 f8                	mov    %edi,%eax
80107588:	5b                   	pop    %ebx
80107589:	5e                   	pop    %esi
8010758a:	5f                   	pop    %edi
8010758b:	5d                   	pop    %ebp
8010758c:	c3                   	ret    
8010758d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory\n");
80107590:	83 ec 0c             	sub    $0xc,%esp
80107593:	68 59 84 10 80       	push   $0x80108459
80107598:	e8 c3 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010759d:	83 c4 10             	add    $0x10,%esp
801075a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801075a3:	39 45 10             	cmp    %eax,0x10(%ebp)
801075a6:	77 50                	ja     801075f8 <allocuvm+0x148>
}
801075a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801075ab:	31 ff                	xor    %edi,%edi
}
801075ad:	89 f8                	mov    %edi,%eax
801075af:	5b                   	pop    %ebx
801075b0:	5e                   	pop    %esi
801075b1:	5f                   	pop    %edi
801075b2:	5d                   	pop    %ebp
801075b3:	c3                   	ret    
801075b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	68 71 84 10 80       	push   $0x80108471
801075c0:	e8 9b 90 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801075c5:	83 c4 10             	add    $0x10,%esp
801075c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801075cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ce:	76 0d                	jbe    801075dd <allocuvm+0x12d>
801075d0:	89 c1                	mov    %eax,%ecx
801075d2:	8b 55 10             	mov    0x10(%ebp),%edx
801075d5:	8b 45 08             	mov    0x8(%ebp),%eax
801075d8:	e8 63 fb ff ff       	call   80107140 <deallocuvm.part.0>
      kfree(mem);
801075dd:	83 ec 0c             	sub    $0xc,%esp
      return 0;
801075e0:	31 ff                	xor    %edi,%edi
      kfree(mem);
801075e2:	56                   	push   %esi
801075e3:	e8 f8 ae ff ff       	call   801024e0 <kfree>
      return 0;
801075e8:	83 c4 10             	add    $0x10,%esp
}
801075eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ee:	89 f8                	mov    %edi,%eax
801075f0:	5b                   	pop    %ebx
801075f1:	5e                   	pop    %esi
801075f2:	5f                   	pop    %edi
801075f3:	5d                   	pop    %ebp
801075f4:	c3                   	ret    
801075f5:	8d 76 00             	lea    0x0(%esi),%esi
801075f8:	89 c1                	mov    %eax,%ecx
801075fa:	8b 55 10             	mov    0x10(%ebp),%edx
801075fd:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107600:	31 ff                	xor    %edi,%edi
80107602:	e8 39 fb ff ff       	call   80107140 <deallocuvm.part.0>
80107607:	e9 77 ff ff ff       	jmp    80107583 <allocuvm+0xd3>
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107610 <deallocuvm>:
{
80107610:	55                   	push   %ebp
80107611:	89 e5                	mov    %esp,%ebp
80107613:	8b 55 0c             	mov    0xc(%ebp),%edx
80107616:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107619:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010761c:	39 d1                	cmp    %edx,%ecx
8010761e:	73 10                	jae    80107630 <deallocuvm+0x20>
}
80107620:	5d                   	pop    %ebp
80107621:	e9 1a fb ff ff       	jmp    80107140 <deallocuvm.part.0>
80107626:	8d 76 00             	lea    0x0(%esi),%esi
80107629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107630:	89 d0                	mov    %edx,%eax
80107632:	5d                   	pop    %ebp
80107633:	c3                   	ret    
80107634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010763a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107640 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107640:	55                   	push   %ebp
80107641:	89 e5                	mov    %esp,%ebp
80107643:	57                   	push   %edi
80107644:	56                   	push   %esi
80107645:	53                   	push   %ebx
80107646:	83 ec 0c             	sub    $0xc,%esp
80107649:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010764c:	85 f6                	test   %esi,%esi
8010764e:	74 59                	je     801076a9 <freevm+0x69>
80107650:	31 c9                	xor    %ecx,%ecx
80107652:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107657:	89 f0                	mov    %esi,%eax
80107659:	e8 e2 fa ff ff       	call   80107140 <deallocuvm.part.0>
8010765e:	89 f3                	mov    %esi,%ebx
80107660:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107666:	eb 0f                	jmp    80107677 <freevm+0x37>
80107668:	90                   	nop
80107669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107670:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107673:	39 fb                	cmp    %edi,%ebx
80107675:	74 23                	je     8010769a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107677:	8b 03                	mov    (%ebx),%eax
80107679:	a8 01                	test   $0x1,%al
8010767b:	74 f3                	je     80107670 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010767d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107682:	83 ec 0c             	sub    $0xc,%esp
80107685:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107688:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010768d:	50                   	push   %eax
8010768e:	e8 4d ae ff ff       	call   801024e0 <kfree>
80107693:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107696:	39 fb                	cmp    %edi,%ebx
80107698:	75 dd                	jne    80107677 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010769a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010769d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076a0:	5b                   	pop    %ebx
801076a1:	5e                   	pop    %esi
801076a2:	5f                   	pop    %edi
801076a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076a4:	e9 37 ae ff ff       	jmp    801024e0 <kfree>
    panic("freevm: no pgdir");
801076a9:	83 ec 0c             	sub    $0xc,%esp
801076ac:	68 8d 84 10 80       	push   $0x8010848d
801076b1:	e8 da 8c ff ff       	call   80100390 <panic>
801076b6:	8d 76 00             	lea    0x0(%esi),%esi
801076b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801076c0 <setupkvm>:
{
801076c0:	55                   	push   %ebp
801076c1:	89 e5                	mov    %esp,%ebp
801076c3:	56                   	push   %esi
801076c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801076c5:	e8 96 b1 ff ff       	call   80102860 <kalloc>
801076ca:	85 c0                	test   %eax,%eax
801076cc:	89 c6                	mov    %eax,%esi
801076ce:	74 42                	je     80107712 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801076d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801076d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801076d8:	68 00 10 00 00       	push   $0x1000
801076dd:	6a 00                	push   $0x0
801076df:	50                   	push   %eax
801076e0:	e8 3b d6 ff ff       	call   80104d20 <memset>
801076e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801076e8:	8b 43 04             	mov    0x4(%ebx),%eax
   if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801076eb:	8b 4b 08             	mov    0x8(%ebx),%ecx
801076ee:	83 ec 08             	sub    $0x8,%esp
801076f1:	8b 13                	mov    (%ebx),%edx
801076f3:	ff 73 0c             	pushl  0xc(%ebx)
801076f6:	50                   	push   %eax
801076f7:	29 c1                	sub    %eax,%ecx
801076f9:	89 f0                	mov    %esi,%eax
801076fb:	e8 b0 f9 ff ff       	call   801070b0 <mappages>
80107700:	83 c4 10             	add    $0x10,%esp
80107703:	85 c0                	test   %eax,%eax
80107705:	78 19                	js     80107720 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107707:	83 c3 10             	add    $0x10,%ebx
8010770a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107710:	75 d6                	jne    801076e8 <setupkvm+0x28>
}
80107712:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107715:	89 f0                	mov    %esi,%eax
80107717:	5b                   	pop    %ebx
80107718:	5e                   	pop    %esi
80107719:	5d                   	pop    %ebp
8010771a:	c3                   	ret    
8010771b:	90                   	nop
8010771c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107720:	83 ec 0c             	sub    $0xc,%esp
80107723:	56                   	push   %esi
      return 0;
80107724:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107726:	e8 15 ff ff ff       	call   80107640 <freevm>
      return 0;
8010772b:	83 c4 10             	add    $0x10,%esp
}
8010772e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107731:	89 f0                	mov    %esi,%eax
80107733:	5b                   	pop    %ebx
80107734:	5e                   	pop    %esi
80107735:	5d                   	pop    %ebp
80107736:	c3                   	ret    
80107737:	89 f6                	mov    %esi,%esi
80107739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107740 <kvmalloc>:
{
80107740:	55                   	push   %ebp
80107741:	89 e5                	mov    %esp,%ebp
80107743:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107746:	e8 75 ff ff ff       	call   801076c0 <setupkvm>
8010774b:	a3 64 e5 22 80       	mov    %eax,0x8022e564
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107750:	05 00 00 00 80       	add    $0x80000000,%eax
80107755:	0f 22 d8             	mov    %eax,%cr3
}
80107758:	c9                   	leave  
80107759:	c3                   	ret    
8010775a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107760 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107760:	55                   	push   %ebp
80107761:	89 e5                	mov    %esp,%ebp
80107763:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107766:	6a 00                	push   $0x0
80107768:	ff 75 0c             	pushl  0xc(%ebp)
8010776b:	ff 75 08             	pushl  0x8(%ebp)
8010776e:	e8 ad f8 ff ff       	call   80107020 <walkpgdir>
  if(pte == 0)
80107773:	83 c4 10             	add    $0x10,%esp
80107776:	85 c0                	test   %eax,%eax
80107778:	74 05                	je     8010777f <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010777a:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010777d:	c9                   	leave  
8010777e:	c3                   	ret    
    panic("clearpteu");
8010777f:	83 ec 0c             	sub    $0xc,%esp
80107782:	68 9e 84 10 80       	push   $0x8010849e
80107787:	e8 04 8c ff ff       	call   80100390 <panic>
8010778c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107790 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	57                   	push   %edi
80107794:	56                   	push   %esi
80107795:	53                   	push   %ebx
80107796:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  if((d = setupkvm()) == 0)
80107799:	e8 22 ff ff ff       	call   801076c0 <setupkvm>
8010779e:	85 c0                	test   %eax,%eax
801077a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801077a3:	0f 84 f1 00 00 00    	je     8010789a <copyuvm+0x10a>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077ac:	85 c9                	test   %ecx,%ecx
801077ae:	0f 84 e6 00 00 00    	je     8010789a <copyuvm+0x10a>
801077b4:	31 ff                	xor    %edi,%edi
801077b6:	8b 75 08             	mov    0x8(%ebp),%esi
801077b9:	eb 3b                	jmp    801077f6 <copyuvm+0x66>
801077bb:	90                   	nop
801077bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
    {
        if((*pte&PTE_SWAP)!=0) copy_swap(pgdir,d,i);
801077c0:	f6 c4 01             	test   $0x1,%ah
801077c3:	0f 84 00 01 00 00    	je     801078c9 <copyuvm+0x139>
801077c9:	83 ec 04             	sub    $0x4,%esp
801077cc:	57                   	push   %edi
801077cd:	ff 75 e4             	pushl  -0x1c(%ebp)
801077d0:	56                   	push   %esi
801077d1:	e8 1a b5 ff ff       	call   80102cf0 <copy_swap>
801077d6:	83 c4 10             	add    $0x10,%esp
        if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
        kfree(mem);
        goto bad;
        }
    }
    if((*pte&PTE_U) && (*pte&PTE_P)) add_pglist((char*)i,d);
801077d9:	8b 03                	mov    (%ebx),%eax
801077db:	83 e0 05             	and    $0x5,%eax
801077de:	83 f8 05             	cmp    $0x5,%eax
801077e1:	0f 84 c1 00 00 00    	je     801078a8 <copyuvm+0x118>
  for(i = 0; i < sz; i += PGSIZE){
801077e7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801077ed:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801077f0:	0f 86 a4 00 00 00    	jbe    8010789a <copyuvm+0x10a>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801077f6:	83 ec 04             	sub    $0x4,%esp
801077f9:	6a 00                	push   $0x0
801077fb:	57                   	push   %edi
801077fc:	56                   	push   %esi
801077fd:	e8 1e f8 ff ff       	call   80107020 <walkpgdir>
80107802:	83 c4 10             	add    $0x10,%esp
80107805:	85 c0                	test   %eax,%eax
80107807:	89 c3                	mov    %eax,%ebx
80107809:	0f 84 ad 00 00 00    	je     801078bc <copyuvm+0x12c>
    if(!(*pte & PTE_P))
8010780f:	8b 00                	mov    (%eax),%eax
80107811:	a8 01                	test   $0x1,%al
80107813:	74 ab                	je     801077c0 <copyuvm+0x30>
        pa = PTE_ADDR(*pte);
80107815:	89 c1                	mov    %eax,%ecx
        flags = PTE_FLAGS(*pte);
80107817:	25 ff 0f 00 00       	and    $0xfff,%eax
        pa = PTE_ADDR(*pte);
8010781c:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
        flags = PTE_FLAGS(*pte);
80107822:	89 45 d8             	mov    %eax,-0x28(%ebp)
        pa = PTE_ADDR(*pte);
80107825:	89 4d dc             	mov    %ecx,-0x24(%ebp)
        if((mem = kalloc()) == 0)
80107828:	e8 33 b0 ff ff       	call   80102860 <kalloc>
8010782d:	85 c0                	test   %eax,%eax
8010782f:	89 c2                	mov    %eax,%edx
80107831:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107834:	74 4f                	je     80107885 <copyuvm+0xf5>
        memmove(mem, (char*)P2V(pa), PGSIZE);
80107836:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107839:	83 ec 04             	sub    $0x4,%esp
8010783c:	68 00 10 00 00       	push   $0x1000
80107841:	05 00 00 00 80       	add    $0x80000000,%eax
80107846:	50                   	push   %eax
80107847:	52                   	push   %edx
80107848:	e8 83 d5 ff ff       	call   80104dd0 <memmove>
        if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010784d:	58                   	pop    %eax
8010784e:	5a                   	pop    %edx
8010784f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80107852:	ff 75 d8             	pushl  -0x28(%ebp)
80107855:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010785a:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107860:	89 fa                	mov    %edi,%edx
80107862:	50                   	push   %eax
80107863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107866:	e8 45 f8 ff ff       	call   801070b0 <mappages>
8010786b:	83 c4 10             	add    $0x10,%esp
8010786e:	85 c0                	test   %eax,%eax
80107870:	0f 89 63 ff ff ff    	jns    801077d9 <copyuvm+0x49>
80107876:	8b 75 e0             	mov    -0x20(%ebp),%esi
        kfree(mem);
80107879:	83 ec 0c             	sub    $0xc,%esp
8010787c:	56                   	push   %esi
8010787d:	e8 5e ac ff ff       	call   801024e0 <kfree>
        goto bad;
80107882:	83 c4 10             	add    $0x10,%esp
  }
  return d;

bad:
  freevm(d);
80107885:	83 ec 0c             	sub    $0xc,%esp
80107888:	ff 75 e4             	pushl  -0x1c(%ebp)
8010788b:	e8 b0 fd ff ff       	call   80107640 <freevm>
  return 0;
80107890:	83 c4 10             	add    $0x10,%esp
80107893:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010789a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010789d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078a0:	5b                   	pop    %ebx
801078a1:	5e                   	pop    %esi
801078a2:	5f                   	pop    %edi
801078a3:	5d                   	pop    %ebp
801078a4:	c3                   	ret    
801078a5:	8d 76 00             	lea    0x0(%esi),%esi
    if((*pte&PTE_U) && (*pte&PTE_P)) add_pglist((char*)i,d);
801078a8:	83 ec 08             	sub    $0x8,%esp
801078ab:	ff 75 e4             	pushl  -0x1c(%ebp)
801078ae:	57                   	push   %edi
801078af:	e8 cc b0 ff ff       	call   80102980 <add_pglist>
801078b4:	83 c4 10             	add    $0x10,%esp
801078b7:	e9 2b ff ff ff       	jmp    801077e7 <copyuvm+0x57>
      panic("copyuvm: pte should exist");
801078bc:	83 ec 0c             	sub    $0xc,%esp
801078bf:	68 a8 84 10 80       	push   $0x801084a8
801078c4:	e8 c7 8a ff ff       	call   80100390 <panic>
        else panic("copyuvm: page not present");
801078c9:	83 ec 0c             	sub    $0xc,%esp
801078cc:	68 c2 84 10 80       	push   $0x801084c2
801078d1:	e8 ba 8a ff ff       	call   80100390 <panic>
801078d6:	8d 76 00             	lea    0x0(%esi),%esi
801078d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801078e0 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078e0:	55                   	push   %ebp
801078e1:	89 e5                	mov    %esp,%ebp
801078e3:	83 ec 0c             	sub    $0xc,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078e6:	6a 00                	push   $0x0
801078e8:	ff 75 0c             	pushl  0xc(%ebp)
801078eb:	ff 75 08             	pushl  0x8(%ebp)
801078ee:	e8 2d f7 ff ff       	call   80107020 <walkpgdir>
  if((*pte & PTE_P) == 0)
801078f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
801078f5:	83 c4 10             	add    $0x10,%esp
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078f8:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801078f9:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107900:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107903:	05 00 00 00 80       	add    $0x80000000,%eax
80107908:	83 fa 05             	cmp    $0x5,%edx
8010790b:	ba 00 00 00 00       	mov    $0x0,%edx
80107910:	0f 45 c2             	cmovne %edx,%eax
}
80107913:	c3                   	ret    
80107914:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010791a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107920 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107920:	55                   	push   %ebp
80107921:	89 e5                	mov    %esp,%ebp
80107923:	57                   	push   %edi
80107924:	56                   	push   %esi
80107925:	53                   	push   %ebx
80107926:	83 ec 1c             	sub    $0x1c,%esp
80107929:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010792c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010792f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107932:	85 db                	test   %ebx,%ebx
80107934:	75 40                	jne    80107976 <copyout+0x56>
80107936:	eb 70                	jmp    801079a8 <copyout+0x88>
80107938:	90                   	nop
80107939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107940:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107943:	89 f1                	mov    %esi,%ecx
80107945:	29 d1                	sub    %edx,%ecx
80107947:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010794d:	39 d9                	cmp    %ebx,%ecx
8010794f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107952:	29 f2                	sub    %esi,%edx
80107954:	83 ec 04             	sub    $0x4,%esp
80107957:	01 d0                	add    %edx,%eax
80107959:	51                   	push   %ecx
8010795a:	57                   	push   %edi
8010795b:	50                   	push   %eax
8010795c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010795f:	e8 6c d4 ff ff       	call   80104dd0 <memmove>
    len -= n;
    buf += n;
80107964:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107967:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010796a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107970:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107972:	29 cb                	sub    %ecx,%ebx
80107974:	74 32                	je     801079a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107976:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107978:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010797b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010797e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107984:	56                   	push   %esi
80107985:	ff 75 08             	pushl  0x8(%ebp)
80107988:	e8 53 ff ff ff       	call   801078e0 <uva2ka>
    if(pa0 == 0)
8010798d:	83 c4 10             	add    $0x10,%esp
80107990:	85 c0                	test   %eax,%eax
80107992:	75 ac                	jne    80107940 <copyout+0x20>
  }
  return 0;
}
80107994:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107997:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010799c:	5b                   	pop    %ebx
8010799d:	5e                   	pop    %esi
8010799e:	5f                   	pop    %edi
8010799f:	5d                   	pop    %ebp
801079a0:	c3                   	ret    
801079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079ab:	31 c0                	xor    %eax,%eax
}
801079ad:	5b                   	pop    %ebx
801079ae:	5e                   	pop    %esi
801079af:	5f                   	pop    %edi
801079b0:	5d                   	pop    %ebp
801079b1:	c3                   	ret    
