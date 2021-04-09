
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 32 10 80       	mov    $0x801032a0,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 73 10 80       	push   $0x801073a0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 c5 45 00 00       	call   80104620 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 73 10 80       	push   $0x801073a7
80100097:	50                   	push   %eax
80100098:	e8 53 44 00 00       	call   801044f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 77 46 00 00       	call   80104760 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 b9 46 00 00       	call   80104820 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 43 00 00       	call   80104530 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 9d 23 00 00       	call   80102520 <iderw>
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
80100193:	68 ae 73 10 80       	push   $0x801073ae
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
801001ae:	e8 1d 44 00 00       	call   801045d0 <holdingsleep>
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
801001c4:	e9 57 23 00 00       	jmp    80102520 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 73 10 80       	push   $0x801073bf
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
801001ef:	e8 dc 43 00 00       	call   801045d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 43 00 00       	call   80104590 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 50 45 00 00       	call   80104760 <acquire>
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 bf 45 00 00       	jmp    80104820 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 73 10 80       	push   $0x801073c6
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
80100280:	e8 1b 17 00 00       	call   801019a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 cf 44 00 00       	call   80104760 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
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
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 d6 3e 00 00       	call   801041a0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 00 39 00 00       	call   80103be0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 2c 45 00 00       	call   80104820 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 b4 15 00 00       	call   801018b0 <ilock>
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
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
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
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 ce 44 00 00       	call   80104820 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 56 15 00 00       	call   801018b0 <ilock>
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
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
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
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 82 27 00 00       	call   80102b30 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 73 10 80       	push   $0x801073cd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 df 7e 10 80 	movl   $0x80107edf,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 42 00 00       	call   80104640 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 73 10 80       	push   $0x801073e1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010043a:	e8 61 5b 00 00       	call   80105fa0 <uartputc>
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
801004ec:	e8 af 5a 00 00       	call   80105fa0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 a3 5a 00 00       	call   80105fa0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 97 5a 00 00       	call   80105fa0 <uartputc>
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
80100524:	e8 f7 43 00 00       	call   80104920 <memmove>
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
80100541:	e8 2a 43 00 00       	call   80104870 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 73 10 80       	push   $0x801073e5
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
801005b1:	0f b6 92 10 74 10 80 	movzbl -0x7fef8bf0(%edx),%edx
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
8010060f:	e8 8c 13 00 00       	call   801019a0 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 40 41 00 00       	call   80104760 <acquire>
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
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 d4 41 00 00       	call   80104820 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 5b 12 00 00       	call   801018b0 <ilock>

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
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 fc 40 00 00       	call   80104820 <release>
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
801007d0:	ba f8 73 10 80       	mov    $0x801073f8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 6b 3f 00 00       	call   80104760 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 73 10 80       	push   $0x801073ff
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
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 38 3f 00 00       	call   80104760 <acquire>
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
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
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
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 93 3f 00 00       	call   80104820 <release>
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
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 35 3a 00 00       	call   80104350 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
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
80100997:	e9 94 3a 00 00       	jmp    80104430 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
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
801009c6:	68 08 74 10 80       	push   $0x80107408
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 4b 3c 00 00       	call   80104620 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 d2 1c 00 00       	call   801026d0 <ioapicenable>
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
80100a1c:	e8 bf 31 00 00       	call   80103be0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 74 25 00 00       	call   80102fa0 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 99 17 00 00       	call   801021d0 <namei>
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
80100a48:	e8 63 0e 00 00       	call   801018b0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 f2 11 00 00       	call   80101c50 <readi>
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
80100a6a:	e8 91 11 00 00       	call   80101c00 <iunlockput>
    end_op();
80100a6f:	e8 9c 25 00 00       	call   80103010 <end_op>
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
80100a94:	e8 57 66 00 00       	call   801070f0 <setupkvm>
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
80100af6:	e8 15 64 00 00       	call   80106f10 <allocuvm>
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
80100b28:	e8 23 63 00 00       	call   80106e50 <loaduvm>
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
80100b58:	e8 f3 10 00 00       	call   80101c50 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 f9 64 00 00       	call   80107070 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 66 10 00 00       	call   80101c00 <iunlockput>
  end_op();
80100b9a:	e8 71 24 00 00       	call   80103010 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 61 63 00 00       	call   80106f10 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 aa 64 00 00       	call   80107070 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 38 24 00 00       	call   80103010 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 74 10 80       	push   $0x80107421
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
80100c06:	e8 85 65 00 00       	call   80107190 <clearpteu>
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
80100c39:	e8 52 3e 00 00       	call   80104a90 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 3e 00 00       	call   80104a90 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 8e 66 00 00       	call   801072f0 <copyout>
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
80100cc7:	e8 24 66 00 00       	call   801072f0 <copyout>
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
80100d0a:	e8 41 3d 00 00       	call   80104a50 <safestrcpy>
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
80100d34:	e8 87 5f 00 00       	call   80106cc0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 2f 63 00 00       	call   80107070 <freevm>
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
80100d66:	68 2d 74 10 80       	push   $0x8010742d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 ab 38 00 00       	call   80104620 <initlock>
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
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 ca 39 00 00       	call   80104760 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
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
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 5a 3a 00 00       	call   80104820 <release>
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
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 41 3a 00 00       	call   80104820 <release>
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
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 5c 39 00 00       	call   80104760 <acquire>
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
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 ff 39 00 00       	call   80104820 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 34 74 10 80       	push   $0x80107434
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
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 0a 39 00 00       	call   80104760 <acquire>
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
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
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
80100e7c:	e9 9f 39 00 00       	jmp    80104820 <release>
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
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 73 39 00 00       	call   80104820 <release>
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
80100ed1:	e8 7a 28 00 00       	call   80103750 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 bb 20 00 00       	call   80102fa0 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 00 0b 00 00       	call   801019f0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 11 21 00 00       	jmp    80103010 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 3c 74 10 80       	push   $0x8010743c
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
80100f25:	e8 86 09 00 00       	call   801018b0 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 e9 0c 00 00       	call   80101c20 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 60 0a 00 00       	call   801019a0 <iunlock>
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
80100f8a:	e8 21 09 00 00       	call   801018b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 b4 0c 00 00       	call   80101c50 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ed 09 00 00       	call   801019a0 <iunlock>
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
80100fcd:	e9 2e 29 00 00       	jmp    80103900 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 46 74 10 80       	push   $0x80107446
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
80101044:	e8 57 09 00 00       	call   801019a0 <iunlock>
      end_op();
80101049:	e8 c2 1f 00 00       	call   80103010 <end_op>
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
80101076:	e8 25 1f 00 00       	call   80102fa0 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 2a 08 00 00       	call   801018b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 b8 0c 00 00       	call   80101d50 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 f3 08 00 00       	call   801019a0 <iunlock>
      end_op();
801010ad:	e8 5e 1f 00 00       	call   80103010 <end_op>
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
801010ed:	e9 fe 26 00 00       	jmp    801037f0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 4f 74 10 80       	push   $0x8010744f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 55 74 10 80       	push   $0x80107455
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
    }
    return 0;
}*/

static uint balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 3c             	sub    $0x3c,%esp
    int m;
    struct buf *bp;

    for(int i=0;i<sb.nBG;i++)
80101119:	8b 1d e0 09 11 80    	mov    0x801109e0,%ebx
{
8010111f:	89 45 cc             	mov    %eax,-0x34(%ebp)
    for(int i=0;i<sb.nBG;i++)
80101122:	85 db                	test   %ebx,%ebx
80101124:	0f 84 f7 00 00 00    	je     80101221 <balloc+0x111>
8010112a:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    {
        int firstblock = BBLOCKGROUPSTART(i,sb);
80101131:	8b 45 c4             	mov    -0x3c(%ebp),%eax
        
        for(int j=0;j<sb.nbmapBG;j++)
80101134:	8b 0d e4 09 11 80    	mov    0x801109e4,%ecx
        int firstblock = BBLOCKGROUPSTART(i,sb);
8010113a:	0f af 05 d4 09 11 80 	imul   0x801109d4,%eax
80101141:	03 05 d8 09 11 80    	add    0x801109d8,%eax
        for(int j=0;j<sb.nbmapBG;j++)
80101147:	85 c9                	test   %ecx,%ecx
        int firstblock = BBLOCKGROUPSTART(i,sb);
80101149:	89 45 c8             	mov    %eax,-0x38(%ebp)
        for(int j=0;j<sb.nbmapBG;j++)
8010114c:	0f 84 bc 00 00 00    	je     8010120e <balloc+0xfe>
80101152:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
        {
            bp=bread(dev,firstblock+sb.ninodeBG+j);
80101159:	8b 7d c8             	mov    -0x38(%ebp),%edi
8010115c:	a1 e8 09 11 80       	mov    0x801109e8,%eax
80101161:	83 ec 08             	sub    $0x8,%esp
80101164:	8b 5d d0             	mov    -0x30(%ebp),%ebx
80101167:	01 f8                	add    %edi,%eax
80101169:	01 d8                	add    %ebx,%eax
8010116b:	c1 e3 0c             	shl    $0xc,%ebx
8010116e:	50                   	push   %eax
8010116f:	ff 75 cc             	pushl  -0x34(%ebp)
80101172:	e8 59 ef ff ff       	call   801000d0 <bread>
80101177:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010117a:	8d 04 1f             	lea    (%edi,%ebx,1),%eax
                int alloc = firstblock+j*BPB+k;
                if((j*BPB)+k < sb.metaBG) {
                    k++;
                    continue;
                }
                if(alloc>=firstblock+sb.BGsize) break;
8010117d:	03 3d d4 09 11 80    	add    0x801109d4,%edi
80101183:	83 c4 10             	add    $0x10,%esp
80101186:	89 45 d4             	mov    %eax,-0x2c(%ebp)
                if((j*BPB)+k < sb.metaBG) {
80101189:	a1 ec 09 11 80       	mov    0x801109ec,%eax
                if(alloc>=firstblock+sb.BGsize) break;
8010118e:	89 7d d8             	mov    %edi,-0x28(%ebp)
                if((j*BPB)+k < sb.metaBG) {
80101191:	89 45 e0             	mov    %eax,-0x20(%ebp)
            for(int k=0;k<BPB;k++)
80101194:	31 c0                	xor    %eax,%eax
80101196:	eb 40                	jmp    801011d8 <balloc+0xc8>
80101198:	90                   	nop
80101199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                int alloc = firstblock+j*BPB+k;
801011a0:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801011a3:	8d 3c 30             	lea    (%eax,%esi,1),%edi
                if(alloc>=firstblock+sb.BGsize) break;
801011a6:	39 7d d8             	cmp    %edi,-0x28(%ebp)
801011a9:	76 42                	jbe    801011ed <balloc+0xdd>

                m = 1 <<(k%8);
801011ab:	89 c1                	mov    %eax,%ecx
801011ad:	be 01 00 00 00       	mov    $0x1,%esi
                if((bp->data[k/8] & m)==0) {
801011b2:	89 c2                	mov    %eax,%edx
                m = 1 <<(k%8);
801011b4:	83 e1 07             	and    $0x7,%ecx
                if((bp->data[k/8] & m)==0) {
801011b7:	c1 fa 03             	sar    $0x3,%edx
                m = 1 <<(k%8);
801011ba:	d3 e6                	shl    %cl,%esi
801011bc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
                if((bp->data[k/8] & m)==0) {
801011bf:	89 d6                	mov    %edx,%esi
801011c1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801011c4:	0f b6 54 32 5c       	movzbl 0x5c(%edx,%esi,1),%edx
801011c9:	85 55 e4             	test   %edx,-0x1c(%ebp)
801011cc:	74 62                	je     80101230 <balloc+0x120>
            for(int k=0;k<BPB;k++)
801011ce:	83 c0 01             	add    $0x1,%eax
801011d1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801011d6:	7f 15                	jg     801011ed <balloc+0xdd>
                if((j*BPB)+k < sb.metaBG) {
801011d8:	8d 14 18             	lea    (%eax,%ebx,1),%edx
801011db:	3b 55 e0             	cmp    -0x20(%ebp),%edx
801011de:	73 c0                	jae    801011a0 <balloc+0x90>
                    k++;
801011e0:	83 c0 01             	add    $0x1,%eax
            for(int k=0;k<BPB;k++)
801011e3:	83 c0 01             	add    $0x1,%eax
801011e6:	3d ff 0f 00 00       	cmp    $0xfff,%eax
801011eb:	7e eb                	jle    801011d8 <balloc+0xc8>
                    brelse(bp);
                    bzero(dev,alloc);
                    return alloc;
                }
            }
            brelse(bp);
801011ed:	83 ec 0c             	sub    $0xc,%esp
801011f0:	ff 75 dc             	pushl  -0x24(%ebp)
801011f3:	e8 e8 ef ff ff       	call   801001e0 <brelse>
        for(int j=0;j<sb.nbmapBG;j++)
801011f8:	83 45 d0 01          	addl   $0x1,-0x30(%ebp)
801011fc:	83 c4 10             	add    $0x10,%esp
801011ff:	8b 45 d0             	mov    -0x30(%ebp),%eax
80101202:	39 05 e4 09 11 80    	cmp    %eax,0x801109e4
80101208:	0f 87 4b ff ff ff    	ja     80101159 <balloc+0x49>
    for(int i=0;i<sb.nBG;i++)
8010120e:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
80101212:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80101215:	39 05 e0 09 11 80    	cmp    %eax,0x801109e0
8010121b:	0f 87 10 ff ff ff    	ja     80101131 <balloc+0x21>
        }
    }
    panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 5f 74 10 80       	push   $0x8010745f
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
                    bp->data[k/8] |=m;
80101230:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80101234:	89 f3                	mov    %esi,%ebx
80101236:	89 fe                	mov    %edi,%esi
80101238:	8b 7d dc             	mov    -0x24(%ebp),%edi
                    log_write(bp);
8010123b:	83 ec 0c             	sub    $0xc,%esp
                    bp->data[k/8] |=m;
8010123e:	09 d0                	or     %edx,%eax
80101240:	88 44 1f 5c          	mov    %al,0x5c(%edi,%ebx,1)
                    log_write(bp);
80101244:	57                   	push   %edi
80101245:	e8 26 1f 00 00       	call   80103170 <log_write>
                    brelse(bp);
8010124a:	89 3c 24             	mov    %edi,(%esp)
8010124d:	e8 8e ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101252:	58                   	pop    %eax
80101253:	5a                   	pop    %edx
80101254:	56                   	push   %esi
80101255:	ff 75 cc             	pushl  -0x34(%ebp)
80101258:	e8 73 ee ff ff       	call   801000d0 <bread>
8010125d:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010125f:	8d 40 5c             	lea    0x5c(%eax),%eax
80101262:	83 c4 0c             	add    $0xc,%esp
80101265:	68 00 02 00 00       	push   $0x200
8010126a:	6a 00                	push   $0x0
8010126c:	50                   	push   %eax
8010126d:	e8 fe 35 00 00       	call   80104870 <memset>
  log_write(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 f6 1e 00 00       	call   80103170 <log_write>
  brelse(bp);
8010127a:	89 1c 24             	mov    %ebx,(%esp)
8010127d:	e8 5e ef ff ff       	call   801001e0 <brelse>
}
80101282:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101285:	89 f0                	mov    %esi,%eax
80101287:	5b                   	pop    %ebx
80101288:	5e                   	pop    %esi
80101289:	5f                   	pop    %edi
8010128a:	5d                   	pop    %ebp
8010128b:	c3                   	ret    
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 34 0a 11 80       	mov    $0x80110a34,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 00 0a 11 80       	push   $0x80110a00
801012aa:	e8 b1 34 00 00       	call   80104760 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 54 26 11 80    	cmp    $0x80112654,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 00 0a 11 80       	push   $0x80110a00
8010130f:	e8 0c 35 00 00       	call   80104820 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 00 0a 11 80       	push   $0x80110a00
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 de 34 00 00       	call   80104820 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 75 74 10 80       	push   $0x80107475
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0a             	cmp    $0xa,%edx
8010136e:	77 20                	ja     80101390 <bmap+0x30>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	0f 84 fa 00 00 00    	je     80101478 <bmap+0x118>
	  brelse(bp);
	  return addr;
  }

  panic("BMAP : Out of Bound");
}
8010137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101381:	89 d8                	mov    %ebx,%eax
80101383:	5b                   	pop    %ebx
80101384:	5e                   	pop    %esi
80101385:	5f                   	pop    %edi
80101386:	5d                   	pop    %ebp
80101387:	c3                   	ret    
80101388:	90                   	nop
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101390:	8d 5a f5             	lea    -0xb(%edx),%ebx
  if(bn < NINDIRECT){
80101393:	83 fb 7f             	cmp    $0x7f,%ebx
80101396:	0f 86 84 00 00 00    	jbe    80101420 <bmap+0xc0>
  bn -= NINDIRECT;
8010139c:	8d 9a 75 ff ff ff    	lea    -0x8b(%edx),%ebx
  if(bn < N2INDIRECT){
801013a2:	81 fb ff 3f 00 00    	cmp    $0x3fff,%ebx
801013a8:	0f 87 3e 01 00 00    	ja     801014ec <bmap+0x18c>
	  if((addr = ip->addrs[NDIRECT+1]) == 0)
801013ae:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013b4:	8b 00                	mov    (%eax),%eax
801013b6:	85 d2                	test   %edx,%edx
801013b8:	0f 84 1a 01 00 00    	je     801014d8 <bmap+0x178>
	  bp = bread(ip->dev, addr);
801013be:	83 ec 08             	sub    $0x8,%esp
801013c1:	52                   	push   %edx
801013c2:	50                   	push   %eax
801013c3:	e8 08 ed ff ff       	call   801000d0 <bread>
801013c8:	89 c2                	mov    %eax,%edx
	  if((addr = a[bn/NINDIRECT]) == 0){
801013ca:	89 d8                	mov    %ebx,%eax
801013cc:	83 c4 10             	add    $0x10,%esp
801013cf:	c1 e8 07             	shr    $0x7,%eax
801013d2:	8d 4c 82 5c          	lea    0x5c(%edx,%eax,4),%ecx
801013d6:	8b 39                	mov    (%ecx),%edi
801013d8:	85 ff                	test   %edi,%edi
801013da:	0f 84 b0 00 00 00    	je     80101490 <bmap+0x130>
	  brelse(bp);
801013e0:	83 ec 0c             	sub    $0xc,%esp
	  if((addr = a[bn%NINDIRECT]) == 0){
801013e3:	83 e3 7f             	and    $0x7f,%ebx
	  brelse(bp);
801013e6:	52                   	push   %edx
801013e7:	e8 f4 ed ff ff       	call   801001e0 <brelse>
	  bp = bread(ip->dev, addr);
801013ec:	58                   	pop    %eax
801013ed:	5a                   	pop    %edx
801013ee:	57                   	push   %edi
801013ef:	ff 36                	pushl  (%esi)
801013f1:	e8 da ec ff ff       	call   801000d0 <bread>
	  if((addr = a[bn%NINDIRECT]) == 0){
801013f6:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013fa:	83 c4 10             	add    $0x10,%esp
	  bp = bread(ip->dev, addr);
801013fd:	89 c7                	mov    %eax,%edi
	  if((addr = a[bn%NINDIRECT]) == 0){
801013ff:	8b 1a                	mov    (%edx),%ebx
80101401:	85 db                	test   %ebx,%ebx
80101403:	74 44                	je     80101449 <bmap+0xe9>
	  brelse(bp);
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	57                   	push   %edi
80101409:	e8 d2 ed ff ff       	call   801001e0 <brelse>
8010140e:	83 c4 10             	add    $0x10,%esp
}
80101411:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101414:	89 d8                	mov    %ebx,%eax
80101416:	5b                   	pop    %ebx
80101417:	5e                   	pop    %esi
80101418:	5f                   	pop    %edi
80101419:	5d                   	pop    %ebp
8010141a:	c3                   	ret    
8010141b:	90                   	nop
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[NDIRECT]) == 0)
80101420:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80101426:	8b 00                	mov    (%eax),%eax
80101428:	85 d2                	test   %edx,%edx
8010142a:	0f 84 90 00 00 00    	je     801014c0 <bmap+0x160>
    bp = bread(ip->dev, addr);
80101430:	83 ec 08             	sub    $0x8,%esp
80101433:	52                   	push   %edx
80101434:	50                   	push   %eax
80101435:	e8 96 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010143a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010143e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101441:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101443:	8b 1a                	mov    (%edx),%ebx
80101445:	85 db                	test   %ebx,%ebx
80101447:	75 bc                	jne    80101405 <bmap+0xa5>
		  a[bn%NINDIRECT] = addr = balloc(ip->dev);
80101449:	8b 06                	mov    (%esi),%eax
8010144b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010144e:	e8 bd fc ff ff       	call   80101110 <balloc>
80101453:	8b 55 e4             	mov    -0x1c(%ebp),%edx
		  log_write(bp);
80101456:	83 ec 0c             	sub    $0xc,%esp
		  a[bn%NINDIRECT] = addr = balloc(ip->dev);
80101459:	89 c3                	mov    %eax,%ebx
8010145b:	89 02                	mov    %eax,(%edx)
		  log_write(bp);
8010145d:	57                   	push   %edi
8010145e:	e8 0d 1d 00 00       	call   80103170 <log_write>
80101463:	83 c4 10             	add    $0x10,%esp
	  brelse(bp);
80101466:	83 ec 0c             	sub    $0xc,%esp
80101469:	57                   	push   %edi
8010146a:	e8 71 ed ff ff       	call   801001e0 <brelse>
8010146f:	83 c4 10             	add    $0x10,%esp
80101472:	eb 9d                	jmp    80101411 <bmap+0xb1>
80101474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101478:	8b 00                	mov    (%eax),%eax
8010147a:	e8 91 fc ff ff       	call   80101110 <balloc>
8010147f:	89 47 5c             	mov    %eax,0x5c(%edi)
}
80101482:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
80101485:	89 c3                	mov    %eax,%ebx
}
80101487:	89 d8                	mov    %ebx,%eax
80101489:	5b                   	pop    %ebx
8010148a:	5e                   	pop    %esi
8010148b:	5f                   	pop    %edi
8010148c:	5d                   	pop    %ebp
8010148d:	c3                   	ret    
8010148e:	66 90                	xchg   %ax,%ax
		  a[bn/NINDIRECT] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101495:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101498:	e8 73 fc ff ff       	call   80101110 <balloc>
		  log_write(bp);
8010149d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
		  a[bn/NINDIRECT] = addr = balloc(ip->dev);
801014a0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
		  log_write(bp);
801014a3:	83 ec 0c             	sub    $0xc,%esp
		  a[bn/NINDIRECT] = addr = balloc(ip->dev);
801014a6:	89 c7                	mov    %eax,%edi
801014a8:	89 01                	mov    %eax,(%ecx)
		  log_write(bp);
801014aa:	52                   	push   %edx
801014ab:	e8 c0 1c 00 00       	call   80103170 <log_write>
801014b0:	83 c4 10             	add    $0x10,%esp
801014b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014b6:	e9 25 ff ff ff       	jmp    801013e0 <bmap+0x80>
801014bb:	90                   	nop
801014bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	e8 4b fc ff ff       	call   80101110 <balloc>
801014c5:	89 c2                	mov    %eax,%edx
801014c7:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
801014cd:	8b 06                	mov    (%esi),%eax
801014cf:	e9 5c ff ff ff       	jmp    80101430 <bmap+0xd0>
801014d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		ip->addrs[NDIRECT+1] = addr = balloc(ip->dev);
801014d8:	e8 33 fc ff ff       	call   80101110 <balloc>
801014dd:	89 c2                	mov    %eax,%edx
801014df:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014e5:	8b 06                	mov    (%esi),%eax
801014e7:	e9 d2 fe ff ff       	jmp    801013be <bmap+0x5e>
  panic("BMAP : Out of Bound");
801014ec:	83 ec 0c             	sub    $0xc,%esp
801014ef:	68 85 74 10 80       	push   $0x80107485
801014f4:	e8 97 ee ff ff       	call   80100390 <panic>
801014f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	56                   	push   %esi
80101504:	53                   	push   %ebx
80101505:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101508:	83 ec 08             	sub    $0x8,%esp
8010150b:	6a 01                	push   $0x1
8010150d:	ff 75 08             	pushl  0x8(%ebp)
80101510:	e8 bb eb ff ff       	call   801000d0 <bread>
80101515:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101517:	8d 40 5c             	lea    0x5c(%eax),%eax
8010151a:	83 c4 0c             	add    $0xc,%esp
8010151d:	6a 30                	push   $0x30
8010151f:	50                   	push   %eax
80101520:	56                   	push   %esi
80101521:	e8 fa 33 00 00       	call   80104920 <memmove>
  brelse(bp);
80101526:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101529:	83 c4 10             	add    $0x10,%esp
}
8010152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5d                   	pop    %ebp
  brelse(bp);
80101532:	e9 a9 ec ff ff       	jmp    801001e0 <brelse>
80101537:	89 f6                	mov    %esi,%esi
80101539:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101540 <bfree>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	57                   	push   %edi
80101544:	56                   	push   %esi
80101545:	53                   	push   %ebx
80101546:	89 d6                	mov    %edx,%esi
80101548:	89 c7                	mov    %eax,%edi
8010154a:	83 ec 14             	sub    $0x14,%esp
  readsb(dev, &sb);
8010154d:	68 c0 09 11 80       	push   $0x801109c0
80101552:	50                   	push   %eax
80101553:	e8 a8 ff ff ff       	call   80101500 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101558:	8b 0d d8 09 11 80    	mov    0x801109d8,%ecx
8010155e:	8b 1d d4 09 11 80    	mov    0x801109d4,%ebx
80101564:	89 f0                	mov    %esi,%eax
80101566:	31 d2                	xor    %edx,%edx
80101568:	83 c4 08             	add    $0x8,%esp
8010156b:	29 c8                	sub    %ecx,%eax
8010156d:	03 0d e8 09 11 80    	add    0x801109e8,%ecx
80101573:	f7 f3                	div    %ebx
80101575:	0f af c3             	imul   %ebx,%eax
80101578:	c1 ea 0c             	shr    $0xc,%edx
8010157b:	01 c1                	add    %eax,%ecx
8010157d:	01 ca                	add    %ecx,%edx
8010157f:	52                   	push   %edx
80101580:	57                   	push   %edi
80101581:	e8 4a eb ff ff       	call   801000d0 <bread>
80101586:	89 c3                	mov    %eax,%ebx
  bi = ((b-sb.nmeta)%sb.BGsize)%BPB;
80101588:	89 f0                	mov    %esi,%eax
8010158a:	2b 05 d8 09 11 80    	sub    0x801109d8,%eax
80101590:	31 d2                	xor    %edx,%edx
  if((bp->data[bi/8] & m) == 0) panic("freeing free block\n");
80101592:	83 c4 10             	add    $0x10,%esp
  bi = ((b-sb.nmeta)%sb.BGsize)%BPB;
80101595:	f7 35 d4 09 11 80    	divl   0x801109d4
  m = 1 <<(bi%8);
8010159b:	b8 01 00 00 00       	mov    $0x1,%eax
801015a0:	89 d1                	mov    %edx,%ecx
801015a2:	83 e1 07             	and    $0x7,%ecx
801015a5:	d3 e0                	shl    %cl,%eax
801015a7:	89 c1                	mov    %eax,%ecx
  if((bp->data[bi/8] & m) == 0) panic("freeing free block\n");
801015a9:	89 d0                	mov    %edx,%eax
801015ab:	c1 f8 03             	sar    $0x3,%eax
801015ae:	25 ff 01 00 00       	and    $0x1ff,%eax
801015b3:	0f b6 74 03 5c       	movzbl 0x5c(%ebx,%eax,1),%esi
801015b8:	85 ce                	test   %ecx,%esi
801015ba:	74 24                	je     801015e0 <bfree+0xa0>
  bp->data[bi/8] &= ~m;
801015bc:	f7 d1                	not    %ecx
  log_write(bp);
801015be:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801015c1:	21 f1                	and    %esi,%ecx
801015c3:	88 4c 03 5c          	mov    %cl,0x5c(%ebx,%eax,1)
  log_write(bp);
801015c7:	53                   	push   %ebx
801015c8:	e8 a3 1b 00 00       	call   80103170 <log_write>
  brelse(bp);
801015cd:	89 1c 24             	mov    %ebx,(%esp)
801015d0:	e8 0b ec ff ff       	call   801001e0 <brelse>
}
801015d5:	83 c4 10             	add    $0x10,%esp
801015d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015db:	5b                   	pop    %ebx
801015dc:	5e                   	pop    %esi
801015dd:	5f                   	pop    %edi
801015de:	5d                   	pop    %ebp
801015df:	c3                   	ret    
  if((bp->data[bi/8] & m) == 0) panic("freeing free block\n");
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	68 99 74 10 80       	push   $0x80107499
801015e8:	e8 a3 ed ff ff       	call   80100390 <panic>
801015ed:	8d 76 00             	lea    0x0(%esi),%esi

801015f0 <iinit>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	8b 75 08             	mov    0x8(%ebp),%esi
801015f8:	bb 40 0a 11 80       	mov    $0x80110a40,%ebx
  initlock(&icache.lock, "icache");
801015fd:	83 ec 08             	sub    $0x8,%esp
80101600:	68 ad 74 10 80       	push   $0x801074ad
80101605:	68 00 0a 11 80       	push   $0x80110a00
8010160a:	e8 11 30 00 00       	call   80104620 <initlock>
8010160f:	83 c4 10             	add    $0x10,%esp
80101612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101618:	83 ec 08             	sub    $0x8,%esp
8010161b:	68 b4 74 10 80       	push   $0x801074b4
80101620:	53                   	push   %ebx
80101621:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101627:	e8 c4 2e 00 00       	call   801044f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	81 fb 60 26 11 80    	cmp    $0x80112660,%ebx
80101635:	75 e1                	jne    80101618 <iinit+0x28>
  readsb(dev, &sb);
80101637:	83 ec 08             	sub    $0x8,%esp
8010163a:	68 c0 09 11 80       	push   $0x801109c0
8010163f:	56                   	push   %esi
80101640:	e8 bb fe ff ff       	call   80101500 <readsb>
  cprintf("=====================================================\n");
80101645:	c7 04 24 34 75 10 80 	movl   $0x80107534,(%esp)
8010164c:	e8 0f f0 ff ff       	call   80100660 <cprintf>
  cprintf("=======================Printed=======================\n");
80101651:	c7 04 24 6c 75 10 80 	movl   $0x8010756c,(%esp)
80101658:	e8 03 f0 ff ff       	call   80100660 <cprintf>
  cprintf("=====================================================\n");
8010165d:	c7 04 24 34 75 10 80 	movl   $0x80107534,(%esp)
80101664:	e8 f7 ef ff ff       	call   80100660 <cprintf>
  cprintf("sb==> FSsize : %d, nblocks(FSSIZE - nmeta) : %d, ninodes : %d\n",sb.size,sb.nblocks,sb.ninodes);
80101669:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010166f:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101675:	ff 35 c0 09 11 80    	pushl  0x801109c0
8010167b:	68 a4 75 10 80       	push   $0x801075a4
80101680:	e8 db ef ff ff       	call   80100660 <cprintf>
  cprintf("sb==> nlog : %d, nswap : %d, logstart : %d\n",sb.nlog,sb.nswap,sb.logstart);
80101685:	83 c4 20             	add    $0x20,%esp
80101688:	ff 35 d0 09 11 80    	pushl  0x801109d0
8010168e:	ff 35 dc 09 11 80    	pushl  0x801109dc
80101694:	ff 35 cc 09 11 80    	pushl  0x801109cc
8010169a:	68 e4 75 10 80       	push   $0x801075e4
8010169f:	e8 bc ef ff ff       	call   80100660 <cprintf>
  cprintf("sb==> Block Group size : %d, nmeta : %d, number of Block Group : %d\n",sb.BGsize, sb.nmeta, sb.nBG);
801016a4:	ff 35 e0 09 11 80    	pushl  0x801109e0
801016aa:	ff 35 d8 09 11 80    	pushl  0x801109d8
801016b0:	ff 35 d4 09 11 80    	pushl  0x801109d4
801016b6:	68 10 76 10 80       	push   $0x80107610
801016bb:	e8 a0 ef ff ff       	call   80100660 <cprintf>
  cprintf("sb==> bitmap block per Block Group : %d, inode block per Block Group : %d\n",sb.nbmapBG, sb.ninodeBG);
801016c0:	83 c4 1c             	add    $0x1c,%esp
801016c3:	ff 35 e8 09 11 80    	pushl  0x801109e8
801016c9:	ff 35 e4 09 11 80    	pushl  0x801109e4
801016cf:	68 58 76 10 80       	push   $0x80107658
801016d4:	e8 87 ef ff ff       	call   80100660 <cprintf>
  cprintf("sb==> meta blocks per Block Group : %d, data blocks per Block Group: %d\n",sb.metaBG,sb.BGsize-sb.metaBG);
801016d9:	8b 15 ec 09 11 80    	mov    0x801109ec,%edx
801016df:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801016e4:	83 c4 0c             	add    $0xc,%esp
801016e7:	29 d0                	sub    %edx,%eax
801016e9:	50                   	push   %eax
801016ea:	52                   	push   %edx
801016eb:	68 a4 76 10 80       	push   $0x801076a4
801016f0:	e8 6b ef ff ff       	call   80100660 <cprintf>
  cprintf("======================================================\n");
801016f5:	c7 04 24 f0 76 10 80 	movl   $0x801076f0,(%esp)
801016fc:	e8 5f ef ff ff       	call   80100660 <cprintf>
  cprintf("======================================================\n");
80101701:	c7 45 08 f0 76 10 80 	movl   $0x801076f0,0x8(%ebp)
80101708:	83 c4 10             	add    $0x10,%esp
}
8010170b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010170e:	5b                   	pop    %ebx
8010170f:	5e                   	pop    %esi
80101710:	5d                   	pop    %ebp
  cprintf("======================================================\n");
80101711:	e9 4a ef ff ff       	jmp    80100660 <cprintf>
80101716:	8d 76 00             	lea    0x0(%esi),%esi
80101719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101720 <ialloc>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101729:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101730:	8b 45 0c             	mov    0xc(%ebp),%eax
80101733:	8b 75 08             	mov    0x8(%ebp),%esi
80101736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101739:	0f 86 9f 00 00 00    	jbe    801017de <ialloc+0xbe>
8010173f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101744:	eb 21                	jmp    80101767 <ialloc+0x47>
80101746:	8d 76 00             	lea    0x0(%esi),%esi
80101749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101750:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101753:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101756:	57                   	push   %edi
80101757:	e8 84 ea ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010175c:	83 c4 10             	add    $0x10,%esp
8010175f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101765:	76 77                	jbe    801017de <ialloc+0xbe>
80101767:	31 d2                	xor    %edx,%edx
80101769:	89 d8                	mov    %ebx,%eax
    bp = bread(dev, IBLOCK(inum, sb));
8010176b:	83 ec 08             	sub    $0x8,%esp
8010176e:	f7 35 e8 09 11 80    	divl   0x801109e8
80101774:	0f af 05 d4 09 11 80 	imul   0x801109d4,%eax
8010177b:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101781:	01 d0                	add    %edx,%eax
80101783:	50                   	push   %eax
80101784:	56                   	push   %esi
80101785:	e8 46 e9 ff ff       	call   801000d0 <bread>
8010178a:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010178c:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){
8010178e:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101791:	83 e0 07             	and    $0x7,%eax
80101794:	c1 e0 06             	shl    $0x6,%eax
80101797:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){
8010179b:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010179f:	75 af                	jne    80101750 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801017a1:	83 ec 04             	sub    $0x4,%esp
801017a4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801017a7:	6a 40                	push   $0x40
801017a9:	6a 00                	push   $0x0
801017ab:	51                   	push   %ecx
801017ac:	e8 bf 30 00 00       	call   80104870 <memset>
      dip->type = type;
801017b1:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017b8:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);
801017bb:	89 3c 24             	mov    %edi,(%esp)
801017be:	e8 ad 19 00 00       	call   80103170 <log_write>
      brelse(bp);
801017c3:	89 3c 24             	mov    %edi,(%esp)
801017c6:	e8 15 ea ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801017cb:	83 c4 10             	add    $0x10,%esp
}
801017ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017d1:	89 da                	mov    %ebx,%edx
801017d3:	89 f0                	mov    %esi,%eax
}
801017d5:	5b                   	pop    %ebx
801017d6:	5e                   	pop    %esi
801017d7:	5f                   	pop    %edi
801017d8:	5d                   	pop    %ebp
      return iget(dev, inum);
801017d9:	e9 b2 fa ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801017de:	83 ec 0c             	sub    $0xc,%esp
801017e1:	68 ba 74 10 80       	push   $0x801074ba
801017e6:	e8 a5 eb ff ff       	call   80100390 <panic>
801017eb:	90                   	nop
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801017f0 <iupdate>:
{
801017f0:	55                   	push   %ebp
801017f1:	31 d2                	xor    %edx,%edx
801017f3:	89 e5                	mov    %esp,%ebp
801017f5:	56                   	push   %esi
801017f6:	53                   	push   %ebx
801017f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017fa:	83 ec 08             	sub    $0x8,%esp
801017fd:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101800:	83 c3 5c             	add    $0x5c,%ebx
80101803:	f7 35 e8 09 11 80    	divl   0x801109e8
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101809:	0f af 05 d4 09 11 80 	imul   0x801109d4,%eax
80101810:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101816:	01 d0                	add    %edx,%eax
80101818:	50                   	push   %eax
80101819:	ff 73 a4             	pushl  -0x5c(%ebx)
8010181c:	e8 af e8 ff ff       	call   801000d0 <bread>
80101821:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101823:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101826:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010182a:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010182d:	83 e0 07             	and    $0x7,%eax
80101830:	c1 e0 06             	shl    $0x6,%eax
80101833:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101837:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010183a:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183e:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101841:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101845:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
80101849:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010184d:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101851:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101855:	8b 53 fc             	mov    -0x4(%ebx),%edx
80101858:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010185b:	6a 34                	push   $0x34
8010185d:	53                   	push   %ebx
8010185e:	50                   	push   %eax
8010185f:	e8 bc 30 00 00       	call   80104920 <memmove>
  log_write(bp);
80101864:	89 34 24             	mov    %esi,(%esp)
80101867:	e8 04 19 00 00       	call   80103170 <log_write>
  brelse(bp);
8010186c:	89 75 08             	mov    %esi,0x8(%ebp)
8010186f:	83 c4 10             	add    $0x10,%esp
}
80101872:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101875:	5b                   	pop    %ebx
80101876:	5e                   	pop    %esi
80101877:	5d                   	pop    %ebp
  brelse(bp);
80101878:	e9 63 e9 ff ff       	jmp    801001e0 <brelse>
8010187d:	8d 76 00             	lea    0x0(%esi),%esi

80101880 <idup>:
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	53                   	push   %ebx
80101884:	83 ec 10             	sub    $0x10,%esp
80101887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010188a:	68 00 0a 11 80       	push   $0x80110a00
8010188f:	e8 cc 2e 00 00       	call   80104760 <acquire>
  ip->ref++;
80101894:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101898:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
8010189f:	e8 7c 2f 00 00       	call   80104820 <release>
}
801018a4:	89 d8                	mov    %ebx,%eax
801018a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018a9:	c9                   	leave  
801018aa:	c3                   	ret    
801018ab:	90                   	nop
801018ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018b0 <ilock>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	56                   	push   %esi
801018b4:	53                   	push   %ebx
801018b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801018b8:	85 db                	test   %ebx,%ebx
801018ba:	0f 84 c5 00 00 00    	je     80101985 <ilock+0xd5>
801018c0:	8b 53 08             	mov    0x8(%ebx),%edx
801018c3:	85 d2                	test   %edx,%edx
801018c5:	0f 8e ba 00 00 00    	jle    80101985 <ilock+0xd5>
  acquiresleep(&ip->lock);
801018cb:	8d 43 0c             	lea    0xc(%ebx),%eax
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	50                   	push   %eax
801018d2:	e8 59 2c 00 00       	call   80104530 <acquiresleep>
  if(ip->valid == 0){
801018d7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018da:	83 c4 10             	add    $0x10,%esp
801018dd:	85 c0                	test   %eax,%eax
801018df:	74 0f                	je     801018f0 <ilock+0x40>
}
801018e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018e4:	5b                   	pop    %ebx
801018e5:	5e                   	pop    %esi
801018e6:	5d                   	pop    %ebp
801018e7:	c3                   	ret    
801018e8:	90                   	nop
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018f0:	8b 43 04             	mov    0x4(%ebx),%eax
801018f3:	31 d2                	xor    %edx,%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018f5:	83 ec 08             	sub    $0x8,%esp
801018f8:	f7 35 e8 09 11 80    	divl   0x801109e8
801018fe:	0f af 05 d4 09 11 80 	imul   0x801109d4,%eax
80101905:	03 15 d8 09 11 80    	add    0x801109d8,%edx
8010190b:	01 d0                	add    %edx,%eax
8010190d:	50                   	push   %eax
8010190e:	ff 33                	pushl  (%ebx)
80101910:	e8 bb e7 ff ff       	call   801000d0 <bread>
80101915:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101917:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010191a:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010191d:	83 e0 07             	and    $0x7,%eax
80101920:	c1 e0 06             	shl    $0x6,%eax
80101923:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101927:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010192a:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010192d:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101931:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101935:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101939:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010193d:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101941:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101945:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101949:	8b 50 fc             	mov    -0x4(%eax),%edx
8010194c:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010194f:	6a 34                	push   $0x34
80101951:	50                   	push   %eax
80101952:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101955:	50                   	push   %eax
80101956:	e8 c5 2f 00 00       	call   80104920 <memmove>
    brelse(bp);
8010195b:	89 34 24             	mov    %esi,(%esp)
8010195e:	e8 7d e8 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101963:	83 c4 10             	add    $0x10,%esp
80101966:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010196b:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101972:	0f 85 69 ff ff ff    	jne    801018e1 <ilock+0x31>
      panic("ilock: no type");
80101978:	83 ec 0c             	sub    $0xc,%esp
8010197b:	68 d2 74 10 80       	push   $0x801074d2
80101980:	e8 0b ea ff ff       	call   80100390 <panic>
    panic("ilock");
80101985:	83 ec 0c             	sub    $0xc,%esp
80101988:	68 cc 74 10 80       	push   $0x801074cc
8010198d:	e8 fe e9 ff ff       	call   80100390 <panic>
80101992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801019a0 <iunlock>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	56                   	push   %esi
801019a4:	53                   	push   %ebx
801019a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801019a8:	85 db                	test   %ebx,%ebx
801019aa:	74 28                	je     801019d4 <iunlock+0x34>
801019ac:	8d 73 0c             	lea    0xc(%ebx),%esi
801019af:	83 ec 0c             	sub    $0xc,%esp
801019b2:	56                   	push   %esi
801019b3:	e8 18 2c 00 00       	call   801045d0 <holdingsleep>
801019b8:	83 c4 10             	add    $0x10,%esp
801019bb:	85 c0                	test   %eax,%eax
801019bd:	74 15                	je     801019d4 <iunlock+0x34>
801019bf:	8b 43 08             	mov    0x8(%ebx),%eax
801019c2:	85 c0                	test   %eax,%eax
801019c4:	7e 0e                	jle    801019d4 <iunlock+0x34>
  releasesleep(&ip->lock);
801019c6:	89 75 08             	mov    %esi,0x8(%ebp)
}
801019c9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801019cc:	5b                   	pop    %ebx
801019cd:	5e                   	pop    %esi
801019ce:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801019cf:	e9 bc 2b 00 00       	jmp    80104590 <releasesleep>
    panic("iunlock");
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	68 e1 74 10 80       	push   $0x801074e1
801019dc:	e8 af e9 ff ff       	call   80100390 <panic>
801019e1:	eb 0d                	jmp    801019f0 <iput>
801019e3:	90                   	nop
801019e4:	90                   	nop
801019e5:	90                   	nop
801019e6:	90                   	nop
801019e7:	90                   	nop
801019e8:	90                   	nop
801019e9:	90                   	nop
801019ea:	90                   	nop
801019eb:	90                   	nop
801019ec:	90                   	nop
801019ed:	90                   	nop
801019ee:	90                   	nop
801019ef:	90                   	nop

801019f0 <iput>:
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 38             	sub    $0x38,%esp
801019f9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801019fc:	8d 46 0c             	lea    0xc(%esi),%eax
801019ff:	50                   	push   %eax
80101a00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a03:	e8 28 2b 00 00       	call   80104530 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101a08:	8b 56 4c             	mov    0x4c(%esi),%edx
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	85 d2                	test   %edx,%edx
80101a10:	74 07                	je     80101a19 <iput+0x29>
80101a12:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101a17:	74 31                	je     80101a4a <iput+0x5a>
  releasesleep(&ip->lock);
80101a19:	83 ec 0c             	sub    $0xc,%esp
80101a1c:	ff 75 e0             	pushl  -0x20(%ebp)
80101a1f:	e8 6c 2b 00 00       	call   80104590 <releasesleep>
  acquire(&icache.lock);
80101a24:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101a2b:	e8 30 2d 00 00       	call   80104760 <acquire>
  ip->ref--;
80101a30:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	c7 45 08 00 0a 11 80 	movl   $0x80110a00,0x8(%ebp)
}
80101a3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a41:	5b                   	pop    %ebx
80101a42:	5e                   	pop    %esi
80101a43:	5f                   	pop    %edi
80101a44:	5d                   	pop    %ebp
  release(&icache.lock);
80101a45:	e9 d6 2d 00 00       	jmp    80104820 <release>
    acquire(&icache.lock);
80101a4a:	83 ec 0c             	sub    $0xc,%esp
80101a4d:	68 00 0a 11 80       	push   $0x80110a00
80101a52:	e8 09 2d 00 00       	call   80104760 <acquire>
    int r = ip->ref;
80101a57:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101a5a:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101a61:	e8 ba 2d 00 00       	call   80104820 <release>
    if(r == 1){
80101a66:	83 c4 10             	add    $0x10,%esp
80101a69:	83 fb 01             	cmp    $0x1,%ebx
80101a6c:	75 ab                	jne    80101a19 <iput+0x29>
80101a6e:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101a71:	8d be 88 00 00 00    	lea    0x88(%esi),%edi
80101a77:	eb 0e                	jmp    80101a87 <iput+0x97>
80101a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a80:	83 c3 04             	add    $0x4,%ebx
  struct buf *bp;
  struct buf *ck;
  uint *a;
  uint *b;

  for(i = 0; i < NDIRECT; i++){
80101a83:	39 fb                	cmp    %edi,%ebx
80101a85:	74 15                	je     80101a9c <iput+0xac>
    if(ip->addrs[i]){
80101a87:	8b 13                	mov    (%ebx),%edx
80101a89:	85 d2                	test   %edx,%edx
80101a8b:	74 f3                	je     80101a80 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a8d:	8b 06                	mov    (%esi),%eax
80101a8f:	e8 ac fa ff ff       	call   80101540 <bfree>
      ip->addrs[i] = 0;
80101a94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80101a9a:	eb e4                	jmp    80101a80 <iput+0x90>
    }
  }

  if(ip->addrs[NDIRECT]){
80101a9c:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80101aa2:	85 c0                	test   %eax,%eax
80101aa4:	0f 85 f7 00 00 00    	jne    80101ba1 <iput+0x1b1>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  
  if(ip->addrs[NDIRECT+1]){
80101aaa:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101ab0:	85 c0                	test   %eax,%eax
80101ab2:	75 2d                	jne    80101ae1 <iput+0xf1>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101ab4:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101ab7:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101abe:	56                   	push   %esi
80101abf:	e8 2c fd ff ff       	call   801017f0 <iupdate>
      ip->type = 0;
80101ac4:	31 c0                	xor    %eax,%eax
80101ac6:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101aca:	89 34 24             	mov    %esi,(%esp)
80101acd:	e8 1e fd ff ff       	call   801017f0 <iupdate>
      ip->valid = 0;
80101ad2:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101ad9:	83 c4 10             	add    $0x10,%esp
80101adc:	e9 38 ff ff ff       	jmp    80101a19 <iput+0x29>
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
80101ae1:	83 ec 08             	sub    $0x8,%esp
80101ae4:	50                   	push   %eax
80101ae5:	ff 36                	pushl  (%esi)
80101ae7:	e8 e4 e5 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
80101aec:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
80101aef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80101af2:	05 5c 02 00 00       	add    $0x25c,%eax
80101af7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101afa:	83 c4 10             	add    $0x10,%esp
    a = (uint*)bp->data;
80101afd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101b00:	eb 12                	jmp    80101b14 <iput+0x124>
80101b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101b08:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
80101b0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    for(j = 0; j < NINDIRECT; j++){
80101b0f:	39 45 dc             	cmp    %eax,-0x24(%ebp)
80101b12:	74 63                	je     80101b77 <iput+0x187>
      if(a[j]){
80101b14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b17:	8b 00                	mov    (%eax),%eax
80101b19:	85 c0                	test   %eax,%eax
80101b1b:	74 eb                	je     80101b08 <iput+0x118>
		  ck = bread(ip->dev,a[j]);
80101b1d:	83 ec 08             	sub    $0x8,%esp
80101b20:	50                   	push   %eax
80101b21:	ff 36                	pushl  (%esi)
80101b23:	e8 a8 e5 ff ff       	call   801000d0 <bread>
80101b28:	83 c4 10             	add    $0x10,%esp
80101b2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		  b = (uint*)ck->data;
80101b2e:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101b31:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
80101b37:	eb 0e                	jmp    80101b47 <iput+0x157>
80101b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b40:	83 c3 04             	add    $0x4,%ebx
		  for(i = 0; i< NINDIRECT; i++){
80101b43:	39 df                	cmp    %ebx,%edi
80101b45:	74 14                	je     80101b5b <iput+0x16b>
				if(b[i])
80101b47:	8b 13                	mov    (%ebx),%edx
80101b49:	85 d2                	test   %edx,%edx
80101b4b:	74 f3                	je     80101b40 <iput+0x150>
					bfree(ip->dev,b[i]);
80101b4d:	8b 06                	mov    (%esi),%eax
80101b4f:	83 c3 04             	add    $0x4,%ebx
80101b52:	e8 e9 f9 ff ff       	call   80101540 <bfree>
		  for(i = 0; i< NINDIRECT; i++){
80101b57:	39 df                	cmp    %ebx,%edi
80101b59:	75 ec                	jne    80101b47 <iput+0x157>
		  brelse(ck);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
80101b5e:	ff 75 d8             	pushl  -0x28(%ebp)
80101b61:	e8 7a e6 ff ff       	call   801001e0 <brelse>
	      bfree(ip->dev, a[j]);
80101b66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b69:	8b 10                	mov    (%eax),%edx
80101b6b:	8b 06                	mov    (%esi),%eax
80101b6d:	e8 ce f9 ff ff       	call   80101540 <bfree>
80101b72:	83 c4 10             	add    $0x10,%esp
80101b75:	eb 91                	jmp    80101b08 <iput+0x118>
	brelse(bp);
80101b77:	83 ec 0c             	sub    $0xc,%esp
80101b7a:	ff 75 d4             	pushl  -0x2c(%ebp)
80101b7d:	e8 5e e6 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
80101b82:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101b88:	8b 06                	mov    (%esi),%eax
80101b8a:	e8 b1 f9 ff ff       	call   80101540 <bfree>
    ip->addrs[NDIRECT+1] = 0;
80101b8f:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101b96:	00 00 00 
80101b99:	83 c4 10             	add    $0x10,%esp
80101b9c:	e9 13 ff ff ff       	jmp    80101ab4 <iput+0xc4>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101ba1:	83 ec 08             	sub    $0x8,%esp
80101ba4:	50                   	push   %eax
80101ba5:	ff 36                	pushl  (%esi)
80101ba7:	e8 24 e5 ff ff       	call   801000d0 <bread>
80101bac:	83 c4 10             	add    $0x10,%esp
80101baf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101bb2:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101bb5:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
80101bbb:	eb 0a                	jmp    80101bc7 <iput+0x1d7>
80101bbd:	8d 76 00             	lea    0x0(%esi),%esi
80101bc0:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101bc3:	39 fb                	cmp    %edi,%ebx
80101bc5:	74 0f                	je     80101bd6 <iput+0x1e6>
      if(a[j])
80101bc7:	8b 13                	mov    (%ebx),%edx
80101bc9:	85 d2                	test   %edx,%edx
80101bcb:	74 f3                	je     80101bc0 <iput+0x1d0>
        bfree(ip->dev, a[j]);
80101bcd:	8b 06                	mov    (%esi),%eax
80101bcf:	e8 6c f9 ff ff       	call   80101540 <bfree>
80101bd4:	eb ea                	jmp    80101bc0 <iput+0x1d0>
    brelse(bp);
80101bd6:	83 ec 0c             	sub    $0xc,%esp
80101bd9:	ff 75 e4             	pushl  -0x1c(%ebp)
80101bdc:	e8 ff e5 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101be1:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
80101be7:	8b 06                	mov    (%esi),%eax
80101be9:	e8 52 f9 ff ff       	call   80101540 <bfree>
    ip->addrs[NDIRECT] = 0;
80101bee:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80101bf5:	00 00 00 
80101bf8:	83 c4 10             	add    $0x10,%esp
80101bfb:	e9 aa fe ff ff       	jmp    80101aaa <iput+0xba>

80101c00 <iunlockput>:
{
80101c00:	55                   	push   %ebp
80101c01:	89 e5                	mov    %esp,%ebp
80101c03:	53                   	push   %ebx
80101c04:	83 ec 10             	sub    $0x10,%esp
80101c07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101c0a:	53                   	push   %ebx
80101c0b:	e8 90 fd ff ff       	call   801019a0 <iunlock>
  iput(ip);
80101c10:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101c13:	83 c4 10             	add    $0x10,%esp
}
80101c16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101c19:	c9                   	leave  
  iput(ip);
80101c1a:	e9 d1 fd ff ff       	jmp    801019f0 <iput>
80101c1f:	90                   	nop

80101c20 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	8b 55 08             	mov    0x8(%ebp),%edx
80101c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101c29:	8b 0a                	mov    (%edx),%ecx
80101c2b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101c2e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101c31:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101c34:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101c38:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101c3b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101c3f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101c43:	8b 52 58             	mov    0x58(%edx),%edx
80101c46:	89 50 10             	mov    %edx,0x10(%eax)
}
80101c49:	5d                   	pop    %ebp
80101c4a:	c3                   	ret    
80101c4b:	90                   	nop
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c50 <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 1c             	sub    $0x1c,%esp
80101c59:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c67:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c70:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101c73:	0f 84 a7 00 00 00    	je     80101d20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	8b 40 58             	mov    0x58(%eax),%eax
80101c7f:	39 c6                	cmp    %eax,%esi
80101c81:	0f 87 ba 00 00 00    	ja     80101d41 <readi+0xf1>
80101c87:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101c8a:	89 f9                	mov    %edi,%ecx
80101c8c:	01 f1                	add    %esi,%ecx
80101c8e:	0f 82 ad 00 00 00    	jb     80101d41 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101c94:	89 c2                	mov    %eax,%edx
80101c96:	29 f2                	sub    %esi,%edx
80101c98:	39 c8                	cmp    %ecx,%eax
80101c9a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c9d:	31 ff                	xor    %edi,%edi
80101c9f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101ca1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ca4:	74 6c                	je     80101d12 <readi+0xc2>
80101ca6:	8d 76 00             	lea    0x0(%esi),%esi
80101ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101cb3:	89 f2                	mov    %esi,%edx
80101cb5:	c1 ea 09             	shr    $0x9,%edx
80101cb8:	89 d8                	mov    %ebx,%eax
80101cba:	e8 a1 f6 ff ff       	call   80101360 <bmap>
80101cbf:	83 ec 08             	sub    $0x8,%esp
80101cc2:	50                   	push   %eax
80101cc3:	ff 33                	pushl  (%ebx)
80101cc5:	e8 06 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ccd:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ccf:	89 f0                	mov    %esi,%eax
80101cd1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cd6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cdb:	83 c4 0c             	add    $0xc,%esp
80101cde:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ce0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ce4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ce7:	29 fb                	sub    %edi,%ebx
80101ce9:	39 d9                	cmp    %ebx,%ecx
80101ceb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101cee:	53                   	push   %ebx
80101cef:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cf0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101cf2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101cf5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101cf7:	e8 24 2c 00 00       	call   80104920 <memmove>
    brelse(bp);
80101cfc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101cff:	89 14 24             	mov    %edx,(%esp)
80101d02:	e8 d9 e4 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101d07:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101d10:	77 9e                	ja     80101cb0 <readi+0x60>
  }
  return n;
80101d12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d18:	5b                   	pop    %ebx
80101d19:	5e                   	pop    %esi
80101d1a:	5f                   	pop    %edi
80101d1b:	5d                   	pop    %ebp
80101d1c:	c3                   	ret    
80101d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d24:	66 83 f8 09          	cmp    $0x9,%ax
80101d28:	77 17                	ja     80101d41 <readi+0xf1>
80101d2a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101d31:	85 c0                	test   %eax,%eax
80101d33:	74 0c                	je     80101d41 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101d35:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d3b:	5b                   	pop    %ebx
80101d3c:	5e                   	pop    %esi
80101d3d:	5f                   	pop    %edi
80101d3e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101d3f:	ff e0                	jmp    *%eax
      return -1;
80101d41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d46:	eb cd                	jmp    80101d15 <readi+0xc5>
80101d48:	90                   	nop
80101d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d50 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	57                   	push   %edi
80101d54:	56                   	push   %esi
80101d55:	53                   	push   %ebx
80101d56:	83 ec 1c             	sub    $0x1c,%esp
80101d59:	8b 45 08             	mov    0x8(%ebp),%eax
80101d5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101d5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101d67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101d6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101d6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101d70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101d73:	0f 84 b7 00 00 00    	je     80101e30 <writei+0xe0>
      return -1;
	}
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off){
80101d79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101d7f:	0f 82 eb 00 00 00    	jb     80101e70 <writei+0x120>
80101d85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101d88:	31 d2                	xor    %edx,%edx
80101d8a:	89 f8                	mov    %edi,%eax
80101d8c:	01 f0                	add    %esi,%eax
80101d8e:	0f 92 c2             	setb   %dl
    return -1;
  }
  if(off + n > MAXFILE*BSIZE){
80101d91:	3d 00 16 81 00       	cmp    $0x811600,%eax
80101d96:	0f 87 d4 00 00 00    	ja     80101e70 <writei+0x120>
80101d9c:	85 d2                	test   %edx,%edx
80101d9e:	0f 85 cc 00 00 00    	jne    80101e70 <writei+0x120>
	return -1;
  }

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101da4:	85 ff                	test   %edi,%edi
80101da6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101dad:	74 72                	je     80101e21 <writei+0xd1>
80101daf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101db0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101db3:	89 f2                	mov    %esi,%edx
80101db5:	c1 ea 09             	shr    $0x9,%edx
80101db8:	89 f8                	mov    %edi,%eax
80101dba:	e8 a1 f5 ff ff       	call   80101360 <bmap>
80101dbf:	83 ec 08             	sub    $0x8,%esp
80101dc2:	50                   	push   %eax
80101dc3:	ff 37                	pushl  (%edi)
80101dc5:	e8 06 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101dca:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101dcd:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101dd0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101dd2:	89 f0                	mov    %esi,%eax
80101dd4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101dd9:	83 c4 0c             	add    $0xc,%esp
80101ddc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101de1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101de3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101de7:	39 d9                	cmp    %ebx,%ecx
80101de9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101dec:	53                   	push   %ebx
80101ded:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101df0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101df2:	50                   	push   %eax
80101df3:	e8 28 2b 00 00       	call   80104920 <memmove>
    log_write(bp);
80101df8:	89 3c 24             	mov    %edi,(%esp)
80101dfb:	e8 70 13 00 00       	call   80103170 <log_write>
    brelse(bp);
80101e00:	89 3c 24             	mov    %edi,(%esp)
80101e03:	e8 d8 e3 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101e08:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101e0b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101e0e:	83 c4 10             	add    $0x10,%esp
80101e11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e14:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101e17:	77 97                	ja     80101db0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101e19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101e1c:	3b 70 58             	cmp    0x58(%eax),%esi
80101e1f:	77 37                	ja     80101e58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101e21:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e27:	5b                   	pop    %ebx
80101e28:	5e                   	pop    %esi
80101e29:	5f                   	pop    %edi
80101e2a:	5d                   	pop    %ebp
80101e2b:	c3                   	ret    
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write){
80101e30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101e34:	66 83 f8 09          	cmp    $0x9,%ax
80101e38:	77 36                	ja     80101e70 <writei+0x120>
80101e3a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101e41:	85 c0                	test   %eax,%eax
80101e43:	74 2b                	je     80101e70 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101e45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101e48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e4b:	5b                   	pop    %ebx
80101e4c:	5e                   	pop    %esi
80101e4d:	5f                   	pop    %edi
80101e4e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101e4f:	ff e0                	jmp    *%eax
80101e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101e58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101e5b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101e5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101e61:	50                   	push   %eax
80101e62:	e8 89 f9 ff ff       	call   801017f0 <iupdate>
80101e67:	83 c4 10             	add    $0x10,%esp
80101e6a:	eb b5                	jmp    80101e21 <writei+0xd1>
80101e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101e70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e75:	eb ad                	jmp    80101e24 <writei+0xd4>
80101e77:	89 f6                	mov    %esi,%esi
80101e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e80 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80101e80:	55                   	push   %ebp
80101e81:	89 e5                	mov    %esp,%ebp
80101e83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101e86:	6a 0e                	push   $0xe
80101e88:	ff 75 0c             	pushl  0xc(%ebp)
80101e8b:	ff 75 08             	pushl  0x8(%ebp)
80101e8e:	e8 fd 2a 00 00       	call   80104990 <strncmp>
}
80101e93:	c9                   	leave  
80101e94:	c3                   	ret    
80101e95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ea0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	83 ec 1c             	sub    $0x1c,%esp
80101ea9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101eac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101eb1:	0f 85 85 00 00 00    	jne    80101f3c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101eb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101eba:	31 ff                	xor    %edi,%edi
80101ebc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ebf:	85 d2                	test   %edx,%edx
80101ec1:	74 3e                	je     80101f01 <dirlookup+0x61>
80101ec3:	90                   	nop
80101ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ec8:	6a 10                	push   $0x10
80101eca:	57                   	push   %edi
80101ecb:	56                   	push   %esi
80101ecc:	53                   	push   %ebx
80101ecd:	e8 7e fd ff ff       	call   80101c50 <readi>
80101ed2:	83 c4 10             	add    $0x10,%esp
80101ed5:	83 f8 10             	cmp    $0x10,%eax
80101ed8:	75 55                	jne    80101f2f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101eda:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101edf:	74 18                	je     80101ef9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101ee1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ee4:	83 ec 04             	sub    $0x4,%esp
80101ee7:	6a 0e                	push   $0xe
80101ee9:	50                   	push   %eax
80101eea:	ff 75 0c             	pushl  0xc(%ebp)
80101eed:	e8 9e 2a 00 00       	call   80104990 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101ef2:	83 c4 10             	add    $0x10,%esp
80101ef5:	85 c0                	test   %eax,%eax
80101ef7:	74 17                	je     80101f10 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ef9:	83 c7 10             	add    $0x10,%edi
80101efc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101eff:	72 c7                	jb     80101ec8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101f01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101f04:	31 c0                	xor    %eax,%eax
}
80101f06:	5b                   	pop    %ebx
80101f07:	5e                   	pop    %esi
80101f08:	5f                   	pop    %edi
80101f09:	5d                   	pop    %ebp
80101f0a:	c3                   	ret    
80101f0b:	90                   	nop
80101f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101f10:	8b 45 10             	mov    0x10(%ebp),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	74 05                	je     80101f1c <dirlookup+0x7c>
        *poff = off;
80101f17:	8b 45 10             	mov    0x10(%ebp),%eax
80101f1a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101f1c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101f20:	8b 03                	mov    (%ebx),%eax
80101f22:	e8 69 f3 ff ff       	call   80101290 <iget>
}
80101f27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2a:	5b                   	pop    %ebx
80101f2b:	5e                   	pop    %esi
80101f2c:	5f                   	pop    %edi
80101f2d:	5d                   	pop    %ebp
80101f2e:	c3                   	ret    
      panic("dirlookup read");
80101f2f:	83 ec 0c             	sub    $0xc,%esp
80101f32:	68 fb 74 10 80       	push   $0x801074fb
80101f37:	e8 54 e4 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101f3c:	83 ec 0c             	sub    $0xc,%esp
80101f3f:	68 e9 74 10 80       	push   $0x801074e9
80101f44:	e8 47 e4 ff ff       	call   80100390 <panic>
80101f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101f50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	57                   	push   %edi
80101f54:	56                   	push   %esi
80101f55:	53                   	push   %ebx
80101f56:	89 cf                	mov    %ecx,%edi
80101f58:	89 c3                	mov    %eax,%ebx
80101f5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101f5d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101f60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101f63:	0f 84 67 01 00 00    	je     801020d0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101f69:	e8 72 1c 00 00       	call   80103be0 <myproc>
  acquire(&icache.lock);
80101f6e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101f71:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101f74:	68 00 0a 11 80       	push   $0x80110a00
80101f79:	e8 e2 27 00 00       	call   80104760 <acquire>
  ip->ref++;
80101f7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101f82:	c7 04 24 00 0a 11 80 	movl   $0x80110a00,(%esp)
80101f89:	e8 92 28 00 00       	call   80104820 <release>
80101f8e:	83 c4 10             	add    $0x10,%esp
80101f91:	eb 08                	jmp    80101f9b <namex+0x4b>
80101f93:	90                   	nop
80101f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f98:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f9b:	0f b6 03             	movzbl (%ebx),%eax
80101f9e:	3c 2f                	cmp    $0x2f,%al
80101fa0:	74 f6                	je     80101f98 <namex+0x48>
  if(*path == 0)
80101fa2:	84 c0                	test   %al,%al
80101fa4:	0f 84 ee 00 00 00    	je     80102098 <namex+0x148>
  while(*path != '/' && *path != 0)
80101faa:	0f b6 03             	movzbl (%ebx),%eax
80101fad:	3c 2f                	cmp    $0x2f,%al
80101faf:	0f 84 b3 00 00 00    	je     80102068 <namex+0x118>
80101fb5:	84 c0                	test   %al,%al
80101fb7:	89 da                	mov    %ebx,%edx
80101fb9:	75 09                	jne    80101fc4 <namex+0x74>
80101fbb:	e9 a8 00 00 00       	jmp    80102068 <namex+0x118>
80101fc0:	84 c0                	test   %al,%al
80101fc2:	74 0a                	je     80101fce <namex+0x7e>
    path++;
80101fc4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101fc7:	0f b6 02             	movzbl (%edx),%eax
80101fca:	3c 2f                	cmp    $0x2f,%al
80101fcc:	75 f2                	jne    80101fc0 <namex+0x70>
80101fce:	89 d1                	mov    %edx,%ecx
80101fd0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101fd2:	83 f9 0d             	cmp    $0xd,%ecx
80101fd5:	0f 8e 91 00 00 00    	jle    8010206c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101fdb:	83 ec 04             	sub    $0x4,%esp
80101fde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101fe1:	6a 0e                	push   $0xe
80101fe3:	53                   	push   %ebx
80101fe4:	57                   	push   %edi
80101fe5:	e8 36 29 00 00       	call   80104920 <memmove>
    path++;
80101fea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101fed:	83 c4 10             	add    $0x10,%esp
    path++;
80101ff0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101ff2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101ff5:	75 11                	jne    80102008 <namex+0xb8>
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80102000:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80102003:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80102006:	74 f8                	je     80102000 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	56                   	push   %esi
8010200c:	e8 9f f8 ff ff       	call   801018b0 <ilock>
    if(ip->type != T_DIR){
80102011:	83 c4 10             	add    $0x10,%esp
80102014:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80102019:	0f 85 91 00 00 00    	jne    801020b0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
8010201f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102022:	85 d2                	test   %edx,%edx
80102024:	74 09                	je     8010202f <namex+0xdf>
80102026:	80 3b 00             	cmpb   $0x0,(%ebx)
80102029:	0f 84 b7 00 00 00    	je     801020e6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
8010202f:	83 ec 04             	sub    $0x4,%esp
80102032:	6a 00                	push   $0x0
80102034:	57                   	push   %edi
80102035:	56                   	push   %esi
80102036:	e8 65 fe ff ff       	call   80101ea0 <dirlookup>
8010203b:	83 c4 10             	add    $0x10,%esp
8010203e:	85 c0                	test   %eax,%eax
80102040:	74 6e                	je     801020b0 <namex+0x160>
  iunlock(ip);
80102042:	83 ec 0c             	sub    $0xc,%esp
80102045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102048:	56                   	push   %esi
80102049:	e8 52 f9 ff ff       	call   801019a0 <iunlock>
  iput(ip);
8010204e:	89 34 24             	mov    %esi,(%esp)
80102051:	e8 9a f9 ff ff       	call   801019f0 <iput>
80102056:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102059:	83 c4 10             	add    $0x10,%esp
8010205c:	89 c6                	mov    %eax,%esi
8010205e:	e9 38 ff ff ff       	jmp    80101f9b <namex+0x4b>
80102063:	90                   	nop
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80102068:	89 da                	mov    %ebx,%edx
8010206a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
8010206c:	83 ec 04             	sub    $0x4,%esp
8010206f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80102072:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80102075:	51                   	push   %ecx
80102076:	53                   	push   %ebx
80102077:	57                   	push   %edi
80102078:	e8 a3 28 00 00       	call   80104920 <memmove>
    name[len] = 0;
8010207d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102080:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102083:	83 c4 10             	add    $0x10,%esp
80102086:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
8010208a:	89 d3                	mov    %edx,%ebx
8010208c:	e9 61 ff ff ff       	jmp    80101ff2 <namex+0xa2>
80102091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102098:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010209b:	85 c0                	test   %eax,%eax
8010209d:	75 5d                	jne    801020fc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
8010209f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a2:	89 f0                	mov    %esi,%eax
801020a4:	5b                   	pop    %ebx
801020a5:	5e                   	pop    %esi
801020a6:	5f                   	pop    %edi
801020a7:	5d                   	pop    %ebp
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801020b0:	83 ec 0c             	sub    $0xc,%esp
801020b3:	56                   	push   %esi
801020b4:	e8 e7 f8 ff ff       	call   801019a0 <iunlock>
  iput(ip);
801020b9:	89 34 24             	mov    %esi,(%esp)
      return 0;
801020bc:	31 f6                	xor    %esi,%esi
  iput(ip);
801020be:	e8 2d f9 ff ff       	call   801019f0 <iput>
      return 0;
801020c3:	83 c4 10             	add    $0x10,%esp
}
801020c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c9:	89 f0                	mov    %esi,%eax
801020cb:	5b                   	pop    %ebx
801020cc:	5e                   	pop    %esi
801020cd:	5f                   	pop    %edi
801020ce:	5d                   	pop    %ebp
801020cf:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
801020d0:	ba 01 00 00 00       	mov    $0x1,%edx
801020d5:	b8 01 00 00 00       	mov    $0x1,%eax
801020da:	e8 b1 f1 ff ff       	call   80101290 <iget>
801020df:	89 c6                	mov    %eax,%esi
801020e1:	e9 b5 fe ff ff       	jmp    80101f9b <namex+0x4b>
      iunlock(ip);
801020e6:	83 ec 0c             	sub    $0xc,%esp
801020e9:	56                   	push   %esi
801020ea:	e8 b1 f8 ff ff       	call   801019a0 <iunlock>
      return ip;
801020ef:	83 c4 10             	add    $0x10,%esp
}
801020f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020f5:	89 f0                	mov    %esi,%eax
801020f7:	5b                   	pop    %ebx
801020f8:	5e                   	pop    %esi
801020f9:	5f                   	pop    %edi
801020fa:	5d                   	pop    %ebp
801020fb:	c3                   	ret    
    iput(ip);
801020fc:	83 ec 0c             	sub    $0xc,%esp
801020ff:	56                   	push   %esi
    return 0;
80102100:	31 f6                	xor    %esi,%esi
    iput(ip);
80102102:	e8 e9 f8 ff ff       	call   801019f0 <iput>
    return 0;
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	eb 93                	jmp    8010209f <namex+0x14f>
8010210c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102110 <dirlink>:
{ 
80102110:	55                   	push   %ebp
80102111:	89 e5                	mov    %esp,%ebp
80102113:	57                   	push   %edi
80102114:	56                   	push   %esi
80102115:	53                   	push   %ebx
80102116:	83 ec 20             	sub    $0x20,%esp
80102119:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010211c:	6a 00                	push   $0x0
8010211e:	ff 75 0c             	pushl  0xc(%ebp)
80102121:	53                   	push   %ebx
80102122:	e8 79 fd ff ff       	call   80101ea0 <dirlookup>
80102127:	83 c4 10             	add    $0x10,%esp
8010212a:	85 c0                	test   %eax,%eax
8010212c:	75 67                	jne    80102195 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010212e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102131:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102134:	85 ff                	test   %edi,%edi
80102136:	74 29                	je     80102161 <dirlink+0x51>
80102138:	31 ff                	xor    %edi,%edi
8010213a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010213d:	eb 09                	jmp    80102148 <dirlink+0x38>
8010213f:	90                   	nop
80102140:	83 c7 10             	add    $0x10,%edi
80102143:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102146:	73 19                	jae    80102161 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102148:	6a 10                	push   $0x10
8010214a:	57                   	push   %edi
8010214b:	56                   	push   %esi
8010214c:	53                   	push   %ebx
8010214d:	e8 fe fa ff ff       	call   80101c50 <readi>
80102152:	83 c4 10             	add    $0x10,%esp
80102155:	83 f8 10             	cmp    $0x10,%eax
80102158:	75 4e                	jne    801021a8 <dirlink+0x98>
    if(de.inum == 0)
8010215a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010215f:	75 df                	jne    80102140 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102161:	8d 45 da             	lea    -0x26(%ebp),%eax
80102164:	83 ec 04             	sub    $0x4,%esp
80102167:	6a 0e                	push   $0xe
80102169:	ff 75 0c             	pushl  0xc(%ebp)
8010216c:	50                   	push   %eax
8010216d:	e8 7e 28 00 00       	call   801049f0 <strncpy>
  de.inum = inum;
80102172:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102175:	6a 10                	push   $0x10
80102177:	57                   	push   %edi
80102178:	56                   	push   %esi
80102179:	53                   	push   %ebx
  de.inum = inum;
8010217a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010217e:	e8 cd fb ff ff       	call   80101d50 <writei>
80102183:	83 c4 20             	add    $0x20,%esp
80102186:	83 f8 10             	cmp    $0x10,%eax
80102189:	75 2a                	jne    801021b5 <dirlink+0xa5>
  return 0;
8010218b:	31 c0                	xor    %eax,%eax
}
8010218d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102190:	5b                   	pop    %ebx
80102191:	5e                   	pop    %esi
80102192:	5f                   	pop    %edi
80102193:	5d                   	pop    %ebp
80102194:	c3                   	ret    
    iput(ip);
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	50                   	push   %eax
80102199:	e8 52 f8 ff ff       	call   801019f0 <iput>
    return -1;
8010219e:	83 c4 10             	add    $0x10,%esp
801021a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021a6:	eb e5                	jmp    8010218d <dirlink+0x7d>
      panic("dirlink read");
801021a8:	83 ec 0c             	sub    $0xc,%esp
801021ab:	68 0a 75 10 80       	push   $0x8010750a
801021b0:	e8 db e1 ff ff       	call   80100390 <panic>
    panic("dirlink");
801021b5:	83 ec 0c             	sub    $0xc,%esp
801021b8:	68 c6 7c 10 80       	push   $0x80107cc6
801021bd:	e8 ce e1 ff ff       	call   80100390 <panic>
801021c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021d0 <namei>:

struct inode*
namei(char *path)
{
801021d0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021d1:	31 d2                	xor    %edx,%edx
{
801021d3:	89 e5                	mov    %esp,%ebp
801021d5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021d8:	8b 45 08             	mov    0x8(%ebp),%eax
801021db:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021de:	e8 6d fd ff ff       	call   80101f50 <namex>
}
801021e3:	c9                   	leave  
801021e4:	c3                   	ret    
801021e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021f0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021f0:	55                   	push   %ebp
  return namex(path, 1, name);
801021f1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021f6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021fb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021fe:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021ff:	e9 4c fd ff ff       	jmp    80101f50 <namex>
80102204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010220a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102210 <swapread>:

#define SWAPBASE	500
#define SWAPMAX		(100000 - SWAPBASE)

void swapread(char* ptr, int blkno)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	57                   	push   %edi
80102214:	56                   	push   %esi
80102215:	53                   	push   %ebx
80102216:	83 ec 1c             	sub    $0x1c,%esp
80102219:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX )
8010221c:	81 ff ab 84 01 00    	cmp    $0x184ab,%edi
80102222:	77 5c                	ja     80102280 <swapread+0x70>
80102224:	8d 87 fc 01 00 00    	lea    0x1fc(%edi),%eax
8010222a:	8b 75 08             	mov    0x8(%ebp),%esi
8010222d:	8d 9f f4 01 00 00    	lea    0x1f4(%edi),%ebx
80102233:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102236:	8d 76 00             	lea    0x0(%esi),%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		bp = bread(0, blkno + SWAPBASE + i);
80102240:	83 ec 08             	sub    $0x8,%esp
80102243:	53                   	push   %ebx
80102244:	6a 00                	push   $0x0
80102246:	83 c3 01             	add    $0x1,%ebx
80102249:	e8 82 de ff ff       	call   801000d0 <bread>
8010224e:	89 c7                	mov    %eax,%edi
		memmove(ptr + i * BSIZE, bp->data, BSIZE);
80102250:	8d 40 5c             	lea    0x5c(%eax),%eax
80102253:	83 c4 0c             	add    $0xc,%esp
80102256:	68 00 02 00 00       	push   $0x200
8010225b:	50                   	push   %eax
8010225c:	56                   	push   %esi
8010225d:	81 c6 00 02 00 00    	add    $0x200,%esi
80102263:	e8 b8 26 00 00       	call   80104920 <memmove>
		brelse(bp);
80102268:	89 3c 24             	mov    %edi,(%esp)
8010226b:	e8 70 df ff ff       	call   801001e0 <brelse>
	for ( i=0; i < 8; ++i ) {
80102270:	83 c4 10             	add    $0x10,%esp
80102273:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80102276:	75 c8                	jne    80102240 <swapread+0x30>
	}
}
80102278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227b:	5b                   	pop    %ebx
8010227c:	5e                   	pop    %esi
8010227d:	5f                   	pop    %edi
8010227e:	5d                   	pop    %ebp
8010227f:	c3                   	ret    
		panic("swapread: blkno exceed range");
80102280:	83 ec 0c             	sub    $0xc,%esp
80102283:	68 17 75 10 80       	push   $0x80107517
80102288:	e8 03 e1 ff ff       	call   80100390 <panic>
8010228d:	8d 76 00             	lea    0x0(%esi),%esi

80102290 <swapwrite>:

void swapwrite(char* ptr, int blkno)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	57                   	push   %edi
80102294:	56                   	push   %esi
80102295:	53                   	push   %ebx
80102296:	83 ec 1c             	sub    $0x1c,%esp
80102299:	8b 7d 0c             	mov    0xc(%ebp),%edi
	struct buf* bp;
	int i;

	if ( blkno < 0 || blkno >= SWAPMAX )
8010229c:	81 ff ab 84 01 00    	cmp    $0x184ab,%edi
801022a2:	77 64                	ja     80102308 <swapwrite+0x78>
801022a4:	8d 87 fc 01 00 00    	lea    0x1fc(%edi),%eax
801022aa:	8b 75 08             	mov    0x8(%ebp),%esi
801022ad:	8d 9f f4 01 00 00    	lea    0x1f4(%edi),%ebx
801022b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801022b6:	8d 76 00             	lea    0x0(%esi),%esi
801022b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		panic("swapread: blkno exceed range");

	for ( i=0; i < 8; ++i ) {
		bp = bread(0, blkno + SWAPBASE + i);
801022c0:	83 ec 08             	sub    $0x8,%esp
801022c3:	53                   	push   %ebx
801022c4:	6a 00                	push   $0x0
801022c6:	83 c3 01             	add    $0x1,%ebx
801022c9:	e8 02 de ff ff       	call   801000d0 <bread>
801022ce:	89 c7                	mov    %eax,%edi
		memmove(bp->data, ptr + i * BSIZE, BSIZE);
801022d0:	8d 40 5c             	lea    0x5c(%eax),%eax
801022d3:	83 c4 0c             	add    $0xc,%esp
801022d6:	68 00 02 00 00       	push   $0x200
801022db:	56                   	push   %esi
801022dc:	81 c6 00 02 00 00    	add    $0x200,%esi
801022e2:	50                   	push   %eax
801022e3:	e8 38 26 00 00       	call   80104920 <memmove>
		bwrite(bp);
801022e8:	89 3c 24             	mov    %edi,(%esp)
801022eb:	e8 b0 de ff ff       	call   801001a0 <bwrite>
		brelse(bp);
801022f0:	89 3c 24             	mov    %edi,(%esp)
801022f3:	e8 e8 de ff ff       	call   801001e0 <brelse>
	for ( i=0; i < 8; ++i ) {
801022f8:	83 c4 10             	add    $0x10,%esp
801022fb:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801022fe:	75 c0                	jne    801022c0 <swapwrite+0x30>
	}
}
80102300:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102303:	5b                   	pop    %ebx
80102304:	5e                   	pop    %esi
80102305:	5f                   	pop    %edi
80102306:	5d                   	pop    %ebp
80102307:	c3                   	ret    
		panic("swapread: blkno exceed range");
80102308:	83 ec 0c             	sub    $0xc,%esp
8010230b:	68 17 75 10 80       	push   $0x80107517
80102310:	e8 7b e0 ff ff       	call   80100390 <panic>
80102315:	66 90                	xchg   %ax,%ax
80102317:	66 90                	xchg   %ax,%ax
80102319:	66 90                	xchg   %ax,%ax
8010231b:	66 90                	xchg   %ax,%ax
8010231d:	66 90                	xchg   %ax,%ax
8010231f:	90                   	nop

80102320 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	57                   	push   %edi
80102324:	56                   	push   %esi
80102325:	53                   	push   %ebx
80102326:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102329:	85 c0                	test   %eax,%eax
8010232b:	0f 84 b4 00 00 00    	je     801023e5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102331:	8b 58 08             	mov    0x8(%eax),%ebx
80102334:	89 c6                	mov    %eax,%esi
80102336:	81 fb a7 61 00 00    	cmp    $0x61a7,%ebx
8010233c:	0f 87 96 00 00 00    	ja     801023d8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102342:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102347:	89 f6                	mov    %esi,%esi
80102349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102350:	89 ca                	mov    %ecx,%edx
80102352:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102353:	83 e0 c0             	and    $0xffffffc0,%eax
80102356:	3c 40                	cmp    $0x40,%al
80102358:	75 f6                	jne    80102350 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010235a:	31 ff                	xor    %edi,%edi
8010235c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102361:	89 f8                	mov    %edi,%eax
80102363:	ee                   	out    %al,(%dx)
80102364:	b8 01 00 00 00       	mov    $0x1,%eax
80102369:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010236e:	ee                   	out    %al,(%dx)
8010236f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102374:	89 d8                	mov    %ebx,%eax
80102376:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102377:	89 d8                	mov    %ebx,%eax
80102379:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010237e:	c1 f8 08             	sar    $0x8,%eax
80102381:	ee                   	out    %al,(%dx)
80102382:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102387:	89 f8                	mov    %edi,%eax
80102389:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010238a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010238e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102393:	c1 e0 04             	shl    $0x4,%eax
80102396:	83 e0 10             	and    $0x10,%eax
80102399:	83 c8 e0             	or     $0xffffffe0,%eax
8010239c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010239d:	f6 06 04             	testb  $0x4,(%esi)
801023a0:	75 16                	jne    801023b8 <idestart+0x98>
801023a2:	b8 20 00 00 00       	mov    $0x20,%eax
801023a7:	89 ca                	mov    %ecx,%edx
801023a9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801023aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023ad:	5b                   	pop    %ebx
801023ae:	5e                   	pop    %esi
801023af:	5f                   	pop    %edi
801023b0:	5d                   	pop    %ebp
801023b1:	c3                   	ret    
801023b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023b8:	b8 30 00 00 00       	mov    $0x30,%eax
801023bd:	89 ca                	mov    %ecx,%edx
801023bf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801023c0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801023c5:	83 c6 5c             	add    $0x5c,%esi
801023c8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023cd:	fc                   	cld    
801023ce:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801023d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023d3:	5b                   	pop    %ebx
801023d4:	5e                   	pop    %esi
801023d5:	5f                   	pop    %edi
801023d6:	5d                   	pop    %ebp
801023d7:	c3                   	ret    
    panic("incorrect blockno");
801023d8:	83 ec 0c             	sub    $0xc,%esp
801023db:	68 31 77 10 80       	push   $0x80107731
801023e0:	e8 ab df ff ff       	call   80100390 <panic>
    panic("idestart");
801023e5:	83 ec 0c             	sub    $0xc,%esp
801023e8:	68 28 77 10 80       	push   $0x80107728
801023ed:	e8 9e df ff ff       	call   80100390 <panic>
801023f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102400 <ideinit>:
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102406:	68 43 77 10 80       	push   $0x80107743
8010240b:	68 80 a5 10 80       	push   $0x8010a580
80102410:	e8 0b 22 00 00       	call   80104620 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102415:	58                   	pop    %eax
80102416:	a1 20 2d 11 80       	mov    0x80112d20,%eax
8010241b:	5a                   	pop    %edx
8010241c:	83 e8 01             	sub    $0x1,%eax
8010241f:	50                   	push   %eax
80102420:	6a 0e                	push   $0xe
80102422:	e8 a9 02 00 00       	call   801026d0 <ioapicenable>
80102427:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010242a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010242f:	90                   	nop
80102430:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102431:	83 e0 c0             	and    $0xffffffc0,%eax
80102434:	3c 40                	cmp    $0x40,%al
80102436:	75 f8                	jne    80102430 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102438:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010243d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102442:	ee                   	out    %al,(%dx)
80102443:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102448:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010244d:	eb 06                	jmp    80102455 <ideinit+0x55>
8010244f:	90                   	nop
  for(i=0; i<1000; i++){
80102450:	83 e9 01             	sub    $0x1,%ecx
80102453:	74 0f                	je     80102464 <ideinit+0x64>
80102455:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102456:	84 c0                	test   %al,%al
80102458:	74 f6                	je     80102450 <ideinit+0x50>
      havedisk1 = 1;
8010245a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102461:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102464:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102469:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010246e:	ee                   	out    %al,(%dx)
}
8010246f:	c9                   	leave  
80102470:	c3                   	ret    
80102471:	eb 0d                	jmp    80102480 <ideintr>
80102473:	90                   	nop
80102474:	90                   	nop
80102475:	90                   	nop
80102476:	90                   	nop
80102477:	90                   	nop
80102478:	90                   	nop
80102479:	90                   	nop
8010247a:	90                   	nop
8010247b:	90                   	nop
8010247c:	90                   	nop
8010247d:	90                   	nop
8010247e:	90                   	nop
8010247f:	90                   	nop

80102480 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	57                   	push   %edi
80102484:	56                   	push   %esi
80102485:	53                   	push   %ebx
80102486:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102489:	68 80 a5 10 80       	push   $0x8010a580
8010248e:	e8 cd 22 00 00       	call   80104760 <acquire>

  if((b = idequeue) == 0){
80102493:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102499:	83 c4 10             	add    $0x10,%esp
8010249c:	85 db                	test   %ebx,%ebx
8010249e:	74 67                	je     80102507 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801024a0:	8b 43 58             	mov    0x58(%ebx),%eax
801024a3:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801024a8:	8b 3b                	mov    (%ebx),%edi
801024aa:	f7 c7 04 00 00 00    	test   $0x4,%edi
801024b0:	75 31                	jne    801024e3 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024b2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024b7:	89 f6                	mov    %esi,%esi
801024b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801024c0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801024c1:	89 c6                	mov    %eax,%esi
801024c3:	83 e6 c0             	and    $0xffffffc0,%esi
801024c6:	89 f1                	mov    %esi,%ecx
801024c8:	80 f9 40             	cmp    $0x40,%cl
801024cb:	75 f3                	jne    801024c0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801024cd:	a8 21                	test   $0x21,%al
801024cf:	75 12                	jne    801024e3 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
801024d1:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801024d4:	b9 80 00 00 00       	mov    $0x80,%ecx
801024d9:	ba f0 01 00 00       	mov    $0x1f0,%edx
801024de:	fc                   	cld    
801024df:	f3 6d                	rep insl (%dx),%es:(%edi)
801024e1:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801024e3:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
801024e6:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801024e9:	89 f9                	mov    %edi,%ecx
801024eb:	83 c9 02             	or     $0x2,%ecx
801024ee:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801024f0:	53                   	push   %ebx
801024f1:	e8 5a 1e 00 00       	call   80104350 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801024f6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801024fb:	83 c4 10             	add    $0x10,%esp
801024fe:	85 c0                	test   %eax,%eax
80102500:	74 05                	je     80102507 <ideintr+0x87>
    idestart(idequeue);
80102502:	e8 19 fe ff ff       	call   80102320 <idestart>
    release(&idelock);
80102507:	83 ec 0c             	sub    $0xc,%esp
8010250a:	68 80 a5 10 80       	push   $0x8010a580
8010250f:	e8 0c 23 00 00       	call   80104820 <release>

  release(&idelock);
}
80102514:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102517:	5b                   	pop    %ebx
80102518:	5e                   	pop    %esi
80102519:	5f                   	pop    %edi
8010251a:	5d                   	pop    %ebp
8010251b:	c3                   	ret    
8010251c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102520 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 10             	sub    $0x10,%esp
80102527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010252a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010252d:	50                   	push   %eax
8010252e:	e8 9d 20 00 00       	call   801045d0 <holdingsleep>
80102533:	83 c4 10             	add    $0x10,%esp
80102536:	85 c0                	test   %eax,%eax
80102538:	0f 84 c6 00 00 00    	je     80102604 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010253e:	8b 03                	mov    (%ebx),%eax
80102540:	83 e0 06             	and    $0x6,%eax
80102543:	83 f8 02             	cmp    $0x2,%eax
80102546:	0f 84 ab 00 00 00    	je     801025f7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010254c:	8b 53 04             	mov    0x4(%ebx),%edx
8010254f:	85 d2                	test   %edx,%edx
80102551:	74 0d                	je     80102560 <iderw+0x40>
80102553:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102558:	85 c0                	test   %eax,%eax
8010255a:	0f 84 b1 00 00 00    	je     80102611 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102560:	83 ec 0c             	sub    $0xc,%esp
80102563:	68 80 a5 10 80       	push   $0x8010a580
80102568:	e8 f3 21 00 00       	call   80104760 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010256d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102573:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102576:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010257d:	85 d2                	test   %edx,%edx
8010257f:	75 09                	jne    8010258a <iderw+0x6a>
80102581:	eb 6d                	jmp    801025f0 <iderw+0xd0>
80102583:	90                   	nop
80102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102588:	89 c2                	mov    %eax,%edx
8010258a:	8b 42 58             	mov    0x58(%edx),%eax
8010258d:	85 c0                	test   %eax,%eax
8010258f:	75 f7                	jne    80102588 <iderw+0x68>
80102591:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102594:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102596:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010259c:	74 42                	je     801025e0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010259e:	8b 03                	mov    (%ebx),%eax
801025a0:	83 e0 06             	and    $0x6,%eax
801025a3:	83 f8 02             	cmp    $0x2,%eax
801025a6:	74 23                	je     801025cb <iderw+0xab>
801025a8:	90                   	nop
801025a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
801025b0:	83 ec 08             	sub    $0x8,%esp
801025b3:	68 80 a5 10 80       	push   $0x8010a580
801025b8:	53                   	push   %ebx
801025b9:	e8 e2 1b 00 00       	call   801041a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025be:	8b 03                	mov    (%ebx),%eax
801025c0:	83 c4 10             	add    $0x10,%esp
801025c3:	83 e0 06             	and    $0x6,%eax
801025c6:	83 f8 02             	cmp    $0x2,%eax
801025c9:	75 e5                	jne    801025b0 <iderw+0x90>
  }


  release(&idelock);
801025cb:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801025d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025d5:	c9                   	leave  
  release(&idelock);
801025d6:	e9 45 22 00 00       	jmp    80104820 <release>
801025db:	90                   	nop
801025dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
801025e0:	89 d8                	mov    %ebx,%eax
801025e2:	e8 39 fd ff ff       	call   80102320 <idestart>
801025e7:	eb b5                	jmp    8010259e <iderw+0x7e>
801025e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025f0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801025f5:	eb 9d                	jmp    80102594 <iderw+0x74>
    panic("iderw: nothing to do");
801025f7:	83 ec 0c             	sub    $0xc,%esp
801025fa:	68 5d 77 10 80       	push   $0x8010775d
801025ff:	e8 8c dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102604:	83 ec 0c             	sub    $0xc,%esp
80102607:	68 47 77 10 80       	push   $0x80107747
8010260c:	e8 7f dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102611:	83 ec 0c             	sub    $0xc,%esp
80102614:	68 72 77 10 80       	push   $0x80107772
80102619:	e8 72 dd ff ff       	call   80100390 <panic>
8010261e:	66 90                	xchg   %ax,%ax

80102620 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102620:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102621:	c7 05 54 26 11 80 00 	movl   $0xfec00000,0x80112654
80102628:	00 c0 fe 
{
8010262b:	89 e5                	mov    %esp,%ebp
8010262d:	56                   	push   %esi
8010262e:	53                   	push   %ebx
  ioapic->reg = reg;
8010262f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102636:	00 00 00 
  return ioapic->data;
80102639:	a1 54 26 11 80       	mov    0x80112654,%eax
8010263e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
80102641:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80102647:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010264d:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102654:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102657:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010265a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010265d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102660:	39 c2                	cmp    %eax,%edx
80102662:	74 16                	je     8010267a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102664:	83 ec 0c             	sub    $0xc,%esp
80102667:	68 90 77 10 80       	push   $0x80107790
8010266c:	e8 ef df ff ff       	call   80100660 <cprintf>
80102671:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
80102677:	83 c4 10             	add    $0x10,%esp
8010267a:	83 c3 21             	add    $0x21,%ebx
{
8010267d:	ba 10 00 00 00       	mov    $0x10,%edx
80102682:	b8 20 00 00 00       	mov    $0x20,%eax
80102687:	89 f6                	mov    %esi,%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102690:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102692:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102698:	89 c6                	mov    %eax,%esi
8010269a:	81 ce 00 00 01 00    	or     $0x10000,%esi
801026a0:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026a3:	89 71 10             	mov    %esi,0x10(%ecx)
801026a6:	8d 72 01             	lea    0x1(%edx),%esi
801026a9:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
801026ac:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
801026ae:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
801026b0:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
801026b6:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801026bd:	75 d1                	jne    80102690 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801026bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026c2:	5b                   	pop    %ebx
801026c3:	5e                   	pop    %esi
801026c4:	5d                   	pop    %ebp
801026c5:	c3                   	ret    
801026c6:	8d 76 00             	lea    0x0(%esi),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801026d0:	55                   	push   %ebp
  ioapic->reg = reg;
801026d1:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
{
801026d7:	89 e5                	mov    %esp,%ebp
801026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801026dc:	8d 50 20             	lea    0x20(%eax),%edx
801026df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801026e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026e5:	8b 0d 54 26 11 80    	mov    0x80112654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801026ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801026f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801026f6:	a1 54 26 11 80       	mov    0x80112654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801026fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801026fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102701:	5d                   	pop    %ebp
80102702:	c3                   	ret    
80102703:	66 90                	xchg   %ax,%ax
80102705:	66 90                	xchg   %ax,%ax
80102707:	66 90                	xchg   %ax,%ax
80102709:	66 90                	xchg   %ax,%ax
8010270b:	66 90                	xchg   %ax,%ax
8010270d:	66 90                	xchg   %ax,%ax
8010270f:	90                   	nop

80102710 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102710:	55                   	push   %ebp
80102711:	89 e5                	mov    %esp,%ebp
80102713:	53                   	push   %ebx
80102714:	83 ec 04             	sub    $0x4,%esp
80102717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010271a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102720:	75 70                	jne    80102792 <kfree+0x82>
80102722:	81 fb c8 54 11 80    	cmp    $0x801154c8,%ebx
80102728:	72 68                	jb     80102792 <kfree+0x82>
8010272a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102730:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102735:	77 5b                	ja     80102792 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102737:	83 ec 04             	sub    $0x4,%esp
8010273a:	68 00 10 00 00       	push   $0x1000
8010273f:	6a 01                	push   $0x1
80102741:	53                   	push   %ebx
80102742:	e8 29 21 00 00       	call   80104870 <memset>

  if(kmem.use_lock)
80102747:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010274d:	83 c4 10             	add    $0x10,%esp
80102750:	85 d2                	test   %edx,%edx
80102752:	75 2c                	jne    80102780 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102754:	a1 98 26 11 80       	mov    0x80112698,%eax
80102759:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010275b:	a1 94 26 11 80       	mov    0x80112694,%eax
  kmem.freelist = r;
80102760:	89 1d 98 26 11 80    	mov    %ebx,0x80112698
  if(kmem.use_lock)
80102766:	85 c0                	test   %eax,%eax
80102768:	75 06                	jne    80102770 <kfree+0x60>
    release(&kmem.lock);
}
8010276a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010276d:	c9                   	leave  
8010276e:	c3                   	ret    
8010276f:	90                   	nop
    release(&kmem.lock);
80102770:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
80102777:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010277a:	c9                   	leave  
    release(&kmem.lock);
8010277b:	e9 a0 20 00 00       	jmp    80104820 <release>
    acquire(&kmem.lock);
80102780:	83 ec 0c             	sub    $0xc,%esp
80102783:	68 60 26 11 80       	push   $0x80112660
80102788:	e8 d3 1f 00 00       	call   80104760 <acquire>
8010278d:	83 c4 10             	add    $0x10,%esp
80102790:	eb c2                	jmp    80102754 <kfree+0x44>
    panic("kfree");
80102792:	83 ec 0c             	sub    $0xc,%esp
80102795:	68 c2 77 10 80       	push   $0x801077c2
8010279a:	e8 f1 db ff ff       	call   80100390 <panic>
8010279f:	90                   	nop

801027a0 <freerange>:
{
801027a0:	55                   	push   %ebp
801027a1:	89 e5                	mov    %esp,%ebp
801027a3:	56                   	push   %esi
801027a4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801027a5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801027a8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801027ab:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027b1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027b7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027bd:	39 de                	cmp    %ebx,%esi
801027bf:	72 23                	jb     801027e4 <freerange+0x44>
801027c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801027c8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027ce:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027d7:	50                   	push   %eax
801027d8:	e8 33 ff ff ff       	call   80102710 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027dd:	83 c4 10             	add    $0x10,%esp
801027e0:	39 f3                	cmp    %esi,%ebx
801027e2:	76 e4                	jbe    801027c8 <freerange+0x28>
}
801027e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027e7:	5b                   	pop    %ebx
801027e8:	5e                   	pop    %esi
801027e9:	5d                   	pop    %ebp
801027ea:	c3                   	ret    
801027eb:	90                   	nop
801027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027f0 <kinit1>:
{
801027f0:	55                   	push   %ebp
801027f1:	89 e5                	mov    %esp,%ebp
801027f3:	56                   	push   %esi
801027f4:	53                   	push   %ebx
801027f5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801027f8:	83 ec 08             	sub    $0x8,%esp
801027fb:	68 c8 77 10 80       	push   $0x801077c8
80102800:	68 60 26 11 80       	push   $0x80112660
80102805:	e8 16 1e 00 00       	call   80104620 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010280a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010280d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102810:	c7 05 94 26 11 80 00 	movl   $0x0,0x80112694
80102817:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010281a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102820:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102826:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010282c:	39 de                	cmp    %ebx,%esi
8010282e:	72 1c                	jb     8010284c <kinit1+0x5c>
    kfree(p);
80102830:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102836:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102839:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010283f:	50                   	push   %eax
80102840:	e8 cb fe ff ff       	call   80102710 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102845:	83 c4 10             	add    $0x10,%esp
80102848:	39 de                	cmp    %ebx,%esi
8010284a:	73 e4                	jae    80102830 <kinit1+0x40>
}
8010284c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010284f:	5b                   	pop    %ebx
80102850:	5e                   	pop    %esi
80102851:	5d                   	pop    %ebp
80102852:	c3                   	ret    
80102853:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <kinit2>:
{
80102860:	55                   	push   %ebp
80102861:	89 e5                	mov    %esp,%ebp
80102863:	56                   	push   %esi
80102864:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102865:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102868:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010286b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102871:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102877:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010287d:	39 de                	cmp    %ebx,%esi
8010287f:	72 23                	jb     801028a4 <kinit2+0x44>
80102881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102888:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010288e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102891:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102897:	50                   	push   %eax
80102898:	e8 73 fe ff ff       	call   80102710 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	39 de                	cmp    %ebx,%esi
801028a2:	73 e4                	jae    80102888 <kinit2+0x28>
  kmem.use_lock = 1;
801028a4:	c7 05 94 26 11 80 01 	movl   $0x1,0x80112694
801028ab:	00 00 00 
}
801028ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028b1:	5b                   	pop    %ebx
801028b2:	5e                   	pop    %esi
801028b3:	5d                   	pop    %ebp
801028b4:	c3                   	ret    
801028b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028c0 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
801028c0:	a1 94 26 11 80       	mov    0x80112694,%eax
801028c5:	85 c0                	test   %eax,%eax
801028c7:	75 1f                	jne    801028e8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801028c9:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
801028ce:	85 c0                	test   %eax,%eax
801028d0:	74 0e                	je     801028e0 <kalloc+0x20>
    kmem.freelist = r->next;
801028d2:	8b 10                	mov    (%eax),%edx
801028d4:	89 15 98 26 11 80    	mov    %edx,0x80112698
801028da:	c3                   	ret    
801028db:	90                   	nop
801028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801028e0:	f3 c3                	repz ret 
801028e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
801028e8:	55                   	push   %ebp
801028e9:	89 e5                	mov    %esp,%ebp
801028eb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801028ee:	68 60 26 11 80       	push   $0x80112660
801028f3:	e8 68 1e 00 00       	call   80104760 <acquire>
  r = kmem.freelist;
801028f8:	a1 98 26 11 80       	mov    0x80112698,%eax
  if(r)
801028fd:	83 c4 10             	add    $0x10,%esp
80102900:	8b 15 94 26 11 80    	mov    0x80112694,%edx
80102906:	85 c0                	test   %eax,%eax
80102908:	74 08                	je     80102912 <kalloc+0x52>
    kmem.freelist = r->next;
8010290a:	8b 08                	mov    (%eax),%ecx
8010290c:	89 0d 98 26 11 80    	mov    %ecx,0x80112698
  if(kmem.use_lock)
80102912:	85 d2                	test   %edx,%edx
80102914:	74 16                	je     8010292c <kalloc+0x6c>
    release(&kmem.lock);
80102916:	83 ec 0c             	sub    $0xc,%esp
80102919:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010291c:	68 60 26 11 80       	push   $0x80112660
80102921:	e8 fa 1e 00 00       	call   80104820 <release>
  return (char*)r;
80102926:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102929:	83 c4 10             	add    $0x10,%esp
}
8010292c:	c9                   	leave  
8010292d:	c3                   	ret    
8010292e:	66 90                	xchg   %ax,%ax

80102930 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102930:	ba 64 00 00 00       	mov    $0x64,%edx
80102935:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102936:	a8 01                	test   $0x1,%al
80102938:	0f 84 c2 00 00 00    	je     80102a00 <kbdgetc+0xd0>
8010293e:	ba 60 00 00 00       	mov    $0x60,%edx
80102943:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102944:	0f b6 d0             	movzbl %al,%edx
80102947:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
8010294d:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102953:	0f 84 7f 00 00 00    	je     801029d8 <kbdgetc+0xa8>
{
80102959:	55                   	push   %ebp
8010295a:	89 e5                	mov    %esp,%ebp
8010295c:	53                   	push   %ebx
8010295d:	89 cb                	mov    %ecx,%ebx
8010295f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102962:	84 c0                	test   %al,%al
80102964:	78 4a                	js     801029b0 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102966:	85 db                	test   %ebx,%ebx
80102968:	74 09                	je     80102973 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010296a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010296d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102970:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102973:	0f b6 82 00 79 10 80 	movzbl -0x7fef8700(%edx),%eax
8010297a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010297c:	0f b6 82 00 78 10 80 	movzbl -0x7fef8800(%edx),%eax
80102983:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102985:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102987:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010298d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102990:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102993:	8b 04 85 e0 77 10 80 	mov    -0x7fef8820(,%eax,4),%eax
8010299a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010299e:	74 31                	je     801029d1 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
801029a0:	8d 50 9f             	lea    -0x61(%eax),%edx
801029a3:	83 fa 19             	cmp    $0x19,%edx
801029a6:	77 40                	ja     801029e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801029a8:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801029ab:	5b                   	pop    %ebx
801029ac:	5d                   	pop    %ebp
801029ad:	c3                   	ret    
801029ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801029b0:	83 e0 7f             	and    $0x7f,%eax
801029b3:	85 db                	test   %ebx,%ebx
801029b5:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801029b8:	0f b6 82 00 79 10 80 	movzbl -0x7fef8700(%edx),%eax
801029bf:	83 c8 40             	or     $0x40,%eax
801029c2:	0f b6 c0             	movzbl %al,%eax
801029c5:	f7 d0                	not    %eax
801029c7:	21 c1                	and    %eax,%ecx
    return 0;
801029c9:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801029cb:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801029d1:	5b                   	pop    %ebx
801029d2:	5d                   	pop    %ebp
801029d3:	c3                   	ret    
801029d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801029d8:	83 c9 40             	or     $0x40,%ecx
    return 0;
801029db:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801029dd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
801029e3:	c3                   	ret    
801029e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801029e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801029eb:	8d 50 20             	lea    0x20(%eax),%edx
}
801029ee:	5b                   	pop    %ebx
      c += 'a' - 'A';
801029ef:	83 f9 1a             	cmp    $0x1a,%ecx
801029f2:	0f 42 c2             	cmovb  %edx,%eax
}
801029f5:	5d                   	pop    %ebp
801029f6:	c3                   	ret    
801029f7:	89 f6                	mov    %esi,%esi
801029f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102a00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a05:	c3                   	ret    
80102a06:	8d 76 00             	lea    0x0(%esi),%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <kbdintr>:

void
kbdintr(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a16:	68 30 29 10 80       	push   $0x80102930
80102a1b:	e8 f0 dd ff ff       	call   80100810 <consoleintr>
}
80102a20:	83 c4 10             	add    $0x10,%esp
80102a23:	c9                   	leave  
80102a24:	c3                   	ret    
80102a25:	66 90                	xchg   %ax,%ax
80102a27:	66 90                	xchg   %ax,%ax
80102a29:	66 90                	xchg   %ax,%ax
80102a2b:	66 90                	xchg   %ax,%ax
80102a2d:	66 90                	xchg   %ax,%ax
80102a2f:	90                   	nop

80102a30 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a30:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102a35:	55                   	push   %ebp
80102a36:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a38:	85 c0                	test   %eax,%eax
80102a3a:	0f 84 c8 00 00 00    	je     80102b08 <lapicinit+0xd8>
  lapic[index] = value;
80102a40:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102a47:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a4a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a4d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102a54:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a57:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a5a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a61:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a64:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a67:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a6e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a71:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a74:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a7b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a7e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a81:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a88:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a8b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a8e:	8b 50 30             	mov    0x30(%eax),%edx
80102a91:	c1 ea 10             	shr    $0x10,%edx
80102a94:	80 fa 03             	cmp    $0x3,%dl
80102a97:	77 77                	ja     80102b10 <lapicinit+0xe0>
  lapic[index] = value;
80102a99:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102aa0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aa6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aad:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ab3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102aba:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102abd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102ac7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102acd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102ad4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ada:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102ae1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102ae4:	8b 50 20             	mov    0x20(%eax),%edx
80102ae7:	89 f6                	mov    %esi,%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102af0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102af6:	80 e6 10             	and    $0x10,%dh
80102af9:	75 f5                	jne    80102af0 <lapicinit+0xc0>
  lapic[index] = value;
80102afb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b02:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b05:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b08:	5d                   	pop    %ebp
80102b09:	c3                   	ret    
80102b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102b10:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b17:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1a:	8b 50 20             	mov    0x20(%eax),%edx
80102b1d:	e9 77 ff ff ff       	jmp    80102a99 <lapicinit+0x69>
80102b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b30 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b30:	8b 15 9c 26 11 80    	mov    0x8011269c,%edx
{
80102b36:	55                   	push   %ebp
80102b37:	31 c0                	xor    %eax,%eax
80102b39:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b3b:	85 d2                	test   %edx,%edx
80102b3d:	74 06                	je     80102b45 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102b3f:	8b 42 20             	mov    0x20(%edx),%eax
80102b42:	c1 e8 18             	shr    $0x18,%eax
}
80102b45:	5d                   	pop    %ebp
80102b46:	c3                   	ret    
80102b47:	89 f6                	mov    %esi,%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102b50:	a1 9c 26 11 80       	mov    0x8011269c,%eax
{
80102b55:	55                   	push   %ebp
80102b56:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102b58:	85 c0                	test   %eax,%eax
80102b5a:	74 0d                	je     80102b69 <lapiceoi+0x19>
  lapic[index] = value;
80102b5c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b63:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b66:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b69:	5d                   	pop    %ebp
80102b6a:	c3                   	ret    
80102b6b:	90                   	nop
80102b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b70 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b70:	55                   	push   %ebp
80102b71:	89 e5                	mov    %esp,%ebp
}
80102b73:	5d                   	pop    %ebp
80102b74:	c3                   	ret    
80102b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b80:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b81:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b86:	ba 70 00 00 00       	mov    $0x70,%edx
80102b8b:	89 e5                	mov    %esp,%ebp
80102b8d:	53                   	push   %ebx
80102b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b94:	ee                   	out    %al,(%dx)
80102b95:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b9a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b9f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102ba0:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102ba2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102ba5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102bab:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bad:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102bb0:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102bb3:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102bb5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102bb8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102bbe:	a1 9c 26 11 80       	mov    0x8011269c,%eax
80102bc3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bc9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bcc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102bd3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bd6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bd9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102be0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102be3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102be6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bec:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bef:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bf5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102bf8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102bfe:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c01:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c07:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c0a:	5b                   	pop    %ebx
80102c0b:	5d                   	pop    %ebp
80102c0c:	c3                   	ret    
80102c0d:	8d 76 00             	lea    0x0(%esi),%esi

80102c10 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102c10:	55                   	push   %ebp
80102c11:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c16:	ba 70 00 00 00       	mov    $0x70,%edx
80102c1b:	89 e5                	mov    %esp,%ebp
80102c1d:	57                   	push   %edi
80102c1e:	56                   	push   %esi
80102c1f:	53                   	push   %ebx
80102c20:	83 ec 4c             	sub    $0x4c,%esp
80102c23:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c24:	ba 71 00 00 00       	mov    $0x71,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c32:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c35:	8d 76 00             	lea    0x0(%esi),%esi
80102c38:	31 c0                	xor    %eax,%eax
80102c3a:	89 da                	mov    %ebx,%edx
80102c3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c3d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102c42:	89 ca                	mov    %ecx,%edx
80102c44:	ec                   	in     (%dx),%al
80102c45:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c48:	89 da                	mov    %ebx,%edx
80102c4a:	b8 02 00 00 00       	mov    $0x2,%eax
80102c4f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c50:	89 ca                	mov    %ecx,%edx
80102c52:	ec                   	in     (%dx),%al
80102c53:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c56:	89 da                	mov    %ebx,%edx
80102c58:	b8 04 00 00 00       	mov    $0x4,%eax
80102c5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c5e:	89 ca                	mov    %ecx,%edx
80102c60:	ec                   	in     (%dx),%al
80102c61:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	89 da                	mov    %ebx,%edx
80102c66:	b8 07 00 00 00       	mov    $0x7,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	b8 08 00 00 00       	mov    $0x8,%eax
80102c79:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7a:	89 ca                	mov    %ecx,%edx
80102c7c:	ec                   	in     (%dx),%al
80102c7d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c7f:	89 da                	mov    %ebx,%edx
80102c81:	b8 09 00 00 00       	mov    $0x9,%eax
80102c86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c87:	89 ca                	mov    %ecx,%edx
80102c89:	ec                   	in     (%dx),%al
80102c8a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c8c:	89 da                	mov    %ebx,%edx
80102c8e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c94:	89 ca                	mov    %ecx,%edx
80102c96:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c97:	84 c0                	test   %al,%al
80102c99:	78 9d                	js     80102c38 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c9b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c9f:	89 fa                	mov    %edi,%edx
80102ca1:	0f b6 fa             	movzbl %dl,%edi
80102ca4:	89 f2                	mov    %esi,%edx
80102ca6:	0f b6 f2             	movzbl %dl,%esi
80102ca9:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cac:	89 da                	mov    %ebx,%edx
80102cae:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102cb1:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102cb4:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102cb8:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102cbb:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102cbf:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102cc2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102cc6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102cc9:	31 c0                	xor    %eax,%eax
80102ccb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccc:	89 ca                	mov    %ecx,%edx
80102cce:	ec                   	in     (%dx),%al
80102ccf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd2:	89 da                	mov    %ebx,%edx
80102cd4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102cd7:	b8 02 00 00 00       	mov    $0x2,%eax
80102cdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cdd:	89 ca                	mov    %ecx,%edx
80102cdf:	ec                   	in     (%dx),%al
80102ce0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ce3:	89 da                	mov    %ebx,%edx
80102ce5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ce8:	b8 04 00 00 00       	mov    $0x4,%eax
80102ced:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cee:	89 ca                	mov    %ecx,%edx
80102cf0:	ec                   	in     (%dx),%al
80102cf1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cf4:	89 da                	mov    %ebx,%edx
80102cf6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102cf9:	b8 07 00 00 00       	mov    $0x7,%eax
80102cfe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cff:	89 ca                	mov    %ecx,%edx
80102d01:	ec                   	in     (%dx),%al
80102d02:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d05:	89 da                	mov    %ebx,%edx
80102d07:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d0a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d0f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d10:	89 ca                	mov    %ecx,%edx
80102d12:	ec                   	in     (%dx),%al
80102d13:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d16:	89 da                	mov    %ebx,%edx
80102d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d1b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d20:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d21:	89 ca                	mov    %ecx,%edx
80102d23:	ec                   	in     (%dx),%al
80102d24:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d27:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d2d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d30:	6a 18                	push   $0x18
80102d32:	50                   	push   %eax
80102d33:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d36:	50                   	push   %eax
80102d37:	e8 84 1b 00 00       	call   801048c0 <memcmp>
80102d3c:	83 c4 10             	add    $0x10,%esp
80102d3f:	85 c0                	test   %eax,%eax
80102d41:	0f 85 f1 fe ff ff    	jne    80102c38 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102d47:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102d4b:	75 78                	jne    80102dc5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102d4d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d50:	89 c2                	mov    %eax,%edx
80102d52:	83 e0 0f             	and    $0xf,%eax
80102d55:	c1 ea 04             	shr    $0x4,%edx
80102d58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d5e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d61:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d64:	89 c2                	mov    %eax,%edx
80102d66:	83 e0 0f             	and    $0xf,%eax
80102d69:	c1 ea 04             	shr    $0x4,%edx
80102d6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d72:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d75:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d78:	89 c2                	mov    %eax,%edx
80102d7a:	83 e0 0f             	and    $0xf,%eax
80102d7d:	c1 ea 04             	shr    $0x4,%edx
80102d80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d86:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d8c:	89 c2                	mov    %eax,%edx
80102d8e:	83 e0 0f             	and    $0xf,%eax
80102d91:	c1 ea 04             	shr    $0x4,%edx
80102d94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d9a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d9d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102da0:	89 c2                	mov    %eax,%edx
80102da2:	83 e0 0f             	and    $0xf,%eax
80102da5:	c1 ea 04             	shr    $0x4,%edx
80102da8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dab:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dae:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102db1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102db4:	89 c2                	mov    %eax,%edx
80102db6:	83 e0 0f             	and    $0xf,%eax
80102db9:	c1 ea 04             	shr    $0x4,%edx
80102dbc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dbf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dc2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102dc5:	8b 75 08             	mov    0x8(%ebp),%esi
80102dc8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102dcb:	89 06                	mov    %eax,(%esi)
80102dcd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102dd0:	89 46 04             	mov    %eax,0x4(%esi)
80102dd3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dd6:	89 46 08             	mov    %eax,0x8(%esi)
80102dd9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102ddc:	89 46 0c             	mov    %eax,0xc(%esi)
80102ddf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102de2:	89 46 10             	mov    %eax,0x10(%esi)
80102de5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102de8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102deb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102df2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102df5:	5b                   	pop    %ebx
80102df6:	5e                   	pop    %esi
80102df7:	5f                   	pop    %edi
80102df8:	5d                   	pop    %ebp
80102df9:	c3                   	ret    
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e00:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102e06:	85 c9                	test   %ecx,%ecx
80102e08:	0f 8e 8a 00 00 00    	jle    80102e98 <install_trans+0x98>
{
80102e0e:	55                   	push   %ebp
80102e0f:	89 e5                	mov    %esp,%ebp
80102e11:	57                   	push   %edi
80102e12:	56                   	push   %esi
80102e13:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e14:	31 db                	xor    %ebx,%ebx
{
80102e16:	83 ec 0c             	sub    $0xc,%esp
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e20:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102e25:	83 ec 08             	sub    $0x8,%esp
80102e28:	01 d8                	add    %ebx,%eax
80102e2a:	83 c0 01             	add    $0x1,%eax
80102e2d:	50                   	push   %eax
80102e2e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102e34:	e8 97 d2 ff ff       	call   801000d0 <bread>
80102e39:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e3b:	58                   	pop    %eax
80102e3c:	5a                   	pop    %edx
80102e3d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102e44:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e4d:	e8 7e d2 ff ff       	call   801000d0 <bread>
80102e52:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102e54:	8d 47 5c             	lea    0x5c(%edi),%eax
80102e57:	83 c4 0c             	add    $0xc,%esp
80102e5a:	68 00 02 00 00       	push   $0x200
80102e5f:	50                   	push   %eax
80102e60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e63:	50                   	push   %eax
80102e64:	e8 b7 1a 00 00       	call   80104920 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e69:	89 34 24             	mov    %esi,(%esp)
80102e6c:	e8 2f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e71:	89 3c 24             	mov    %edi,(%esp)
80102e74:	e8 67 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e79:	89 34 24             	mov    %esi,(%esp)
80102e7c:	e8 5f d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e81:	83 c4 10             	add    $0x10,%esp
80102e84:	39 1d e8 26 11 80    	cmp    %ebx,0x801126e8
80102e8a:	7f 94                	jg     80102e20 <install_trans+0x20>
  }
}
80102e8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e8f:	5b                   	pop    %ebx
80102e90:	5e                   	pop    %esi
80102e91:	5f                   	pop    %edi
80102e92:	5d                   	pop    %ebp
80102e93:	c3                   	ret    
80102e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e98:	f3 c3                	repz ret 
80102e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ea0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	56                   	push   %esi
80102ea4:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102eae:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102eb9:	8b 1d e8 26 11 80    	mov    0x801126e8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ebf:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ec2:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102ec4:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102ec6:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102ec9:	7e 16                	jle    80102ee1 <write_head+0x41>
80102ecb:	c1 e3 02             	shl    $0x2,%ebx
80102ece:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102ed0:	8b 8a ec 26 11 80    	mov    -0x7feed914(%edx),%ecx
80102ed6:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102eda:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102edd:	39 da                	cmp    %ebx,%edx
80102edf:	75 ef                	jne    80102ed0 <write_head+0x30>
  }
  bwrite(buf);
80102ee1:	83 ec 0c             	sub    $0xc,%esp
80102ee4:	56                   	push   %esi
80102ee5:	e8 b6 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102eea:	89 34 24             	mov    %esi,(%esp)
80102eed:	e8 ee d2 ff ff       	call   801001e0 <brelse>
}
80102ef2:	83 c4 10             	add    $0x10,%esp
80102ef5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ef8:	5b                   	pop    %ebx
80102ef9:	5e                   	pop    %esi
80102efa:	5d                   	pop    %ebp
80102efb:	c3                   	ret    
80102efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f00 <initlog>:
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	53                   	push   %ebx
80102f04:	83 ec 3c             	sub    $0x3c,%esp
80102f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f0a:	68 00 7a 10 80       	push   $0x80107a00
80102f0f:	68 a0 26 11 80       	push   $0x801126a0
80102f14:	e8 07 17 00 00       	call   80104620 <initlock>
  readsb(dev, &sb);
80102f19:	58                   	pop    %eax
80102f1a:	8d 45 c8             	lea    -0x38(%ebp),%eax
80102f1d:	5a                   	pop    %edx
80102f1e:	50                   	push   %eax
80102f1f:	53                   	push   %ebx
80102f20:	e8 db e5 ff ff       	call   80101500 <readsb>
  log.size = sb.nlog;
80102f25:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  log.start = sb.logstart;
80102f28:	8b 45 d8             	mov    -0x28(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f2b:	59                   	pop    %ecx
  log.dev = dev;
80102f2c:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102f32:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  log.start = sb.logstart;
80102f38:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  struct buf *buf = bread(log.dev, log.start);
80102f3d:	5a                   	pop    %edx
80102f3e:	50                   	push   %eax
80102f3f:	53                   	push   %ebx
80102f40:	e8 8b d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102f45:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f48:	83 c4 10             	add    $0x10,%esp
80102f4b:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102f4d:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102f53:	7e 1c                	jle    80102f71 <initlog+0x71>
80102f55:	c1 e3 02             	shl    $0x2,%ebx
80102f58:	31 d2                	xor    %edx,%edx
80102f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f60:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f64:	83 c2 04             	add    $0x4,%edx
80102f67:	89 8a e8 26 11 80    	mov    %ecx,-0x7feed918(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f6d:	39 d3                	cmp    %edx,%ebx
80102f6f:	75 ef                	jne    80102f60 <initlog+0x60>
  brelse(buf);
80102f71:	83 ec 0c             	sub    $0xc,%esp
80102f74:	50                   	push   %eax
80102f75:	e8 66 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f7a:	e8 81 fe ff ff       	call   80102e00 <install_trans>
  log.lh.n = 0;
80102f7f:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102f86:	00 00 00 
  write_head(); // clear the log
80102f89:	e8 12 ff ff ff       	call   80102ea0 <write_head>
}
80102f8e:	83 c4 10             	add    $0x10,%esp
80102f91:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f94:	c9                   	leave  
80102f95:	c3                   	ret    
80102f96:	8d 76 00             	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102fa6:	68 a0 26 11 80       	push   $0x801126a0
80102fab:	e8 b0 17 00 00       	call   80104760 <acquire>
80102fb0:	83 c4 10             	add    $0x10,%esp
80102fb3:	eb 18                	jmp    80102fcd <begin_op+0x2d>
80102fb5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102fb8:	83 ec 08             	sub    $0x8,%esp
80102fbb:	68 a0 26 11 80       	push   $0x801126a0
80102fc0:	68 a0 26 11 80       	push   $0x801126a0
80102fc5:	e8 d6 11 00 00       	call   801041a0 <sleep>
80102fca:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102fcd:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102fd2:	85 c0                	test   %eax,%eax
80102fd4:	75 e2                	jne    80102fb8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102fd6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102fdb:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102fe1:	83 c0 01             	add    $0x1,%eax
80102fe4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102fe7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102fea:	83 fa 1e             	cmp    $0x1e,%edx
80102fed:	7f c9                	jg     80102fb8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102fef:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ff2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102ff7:	68 a0 26 11 80       	push   $0x801126a0
80102ffc:	e8 1f 18 00 00       	call   80104820 <release>
      break;
    }
  }
}
80103001:	83 c4 10             	add    $0x10,%esp
80103004:	c9                   	leave  
80103005:	c3                   	ret    
80103006:	8d 76 00             	lea    0x0(%esi),%esi
80103009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103010 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	57                   	push   %edi
80103014:	56                   	push   %esi
80103015:	53                   	push   %ebx
80103016:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103019:	68 a0 26 11 80       	push   $0x801126a0
8010301e:	e8 3d 17 00 00       	call   80104760 <acquire>
  log.outstanding -= 1;
80103023:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80103028:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
8010302e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103031:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103034:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103036:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
8010303c:	0f 85 1a 01 00 00    	jne    8010315c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80103042:	85 db                	test   %ebx,%ebx
80103044:	0f 85 ee 00 00 00    	jne    80103138 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010304a:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
8010304d:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80103054:	00 00 00 
  release(&log.lock);
80103057:	68 a0 26 11 80       	push   $0x801126a0
8010305c:	e8 bf 17 00 00       	call   80104820 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103061:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80103067:	83 c4 10             	add    $0x10,%esp
8010306a:	85 c9                	test   %ecx,%ecx
8010306c:	0f 8e 85 00 00 00    	jle    801030f7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103072:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80103077:	83 ec 08             	sub    $0x8,%esp
8010307a:	01 d8                	add    %ebx,%eax
8010307c:	83 c0 01             	add    $0x1,%eax
8010307f:	50                   	push   %eax
80103080:	ff 35 e4 26 11 80    	pushl  0x801126e4
80103086:	e8 45 d0 ff ff       	call   801000d0 <bread>
8010308b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010308d:	58                   	pop    %eax
8010308e:	5a                   	pop    %edx
8010308f:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80103096:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
8010309c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010309f:	e8 2c d0 ff ff       	call   801000d0 <bread>
801030a4:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
801030a6:	8d 40 5c             	lea    0x5c(%eax),%eax
801030a9:	83 c4 0c             	add    $0xc,%esp
801030ac:	68 00 02 00 00       	push   $0x200
801030b1:	50                   	push   %eax
801030b2:	8d 46 5c             	lea    0x5c(%esi),%eax
801030b5:	50                   	push   %eax
801030b6:	e8 65 18 00 00       	call   80104920 <memmove>
    bwrite(to);  // write the log
801030bb:	89 34 24             	mov    %esi,(%esp)
801030be:	e8 dd d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
801030c3:	89 3c 24             	mov    %edi,(%esp)
801030c6:	e8 15 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
801030cb:	89 34 24             	mov    %esi,(%esp)
801030ce:	e8 0d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801030d3:	83 c4 10             	add    $0x10,%esp
801030d6:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
801030dc:	7c 94                	jl     80103072 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801030de:	e8 bd fd ff ff       	call   80102ea0 <write_head>
    install_trans(); // Now install writes to home locations
801030e3:	e8 18 fd ff ff       	call   80102e00 <install_trans>
    log.lh.n = 0;
801030e8:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
801030ef:	00 00 00 
    write_head();    // Erase the transaction from the log
801030f2:	e8 a9 fd ff ff       	call   80102ea0 <write_head>
    acquire(&log.lock);
801030f7:	83 ec 0c             	sub    $0xc,%esp
801030fa:	68 a0 26 11 80       	push   $0x801126a0
801030ff:	e8 5c 16 00 00       	call   80104760 <acquire>
    wakeup(&log);
80103104:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
8010310b:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80103112:	00 00 00 
    wakeup(&log);
80103115:	e8 36 12 00 00       	call   80104350 <wakeup>
    release(&log.lock);
8010311a:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103121:	e8 fa 16 00 00       	call   80104820 <release>
80103126:	83 c4 10             	add    $0x10,%esp
}
80103129:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312c:	5b                   	pop    %ebx
8010312d:	5e                   	pop    %esi
8010312e:	5f                   	pop    %edi
8010312f:	5d                   	pop    %ebp
80103130:	c3                   	ret    
80103131:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103138:	83 ec 0c             	sub    $0xc,%esp
8010313b:	68 a0 26 11 80       	push   $0x801126a0
80103140:	e8 0b 12 00 00       	call   80104350 <wakeup>
  release(&log.lock);
80103145:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
8010314c:	e8 cf 16 00 00       	call   80104820 <release>
80103151:	83 c4 10             	add    $0x10,%esp
}
80103154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103157:	5b                   	pop    %ebx
80103158:	5e                   	pop    %esi
80103159:	5f                   	pop    %edi
8010315a:	5d                   	pop    %ebp
8010315b:	c3                   	ret    
    panic("log.committing");
8010315c:	83 ec 0c             	sub    $0xc,%esp
8010315f:	68 04 7a 10 80       	push   $0x80107a04
80103164:	e8 27 d2 ff ff       	call   80100390 <panic>
80103169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103170 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	53                   	push   %ebx
80103174:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103177:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010317d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103180:	83 fa 1d             	cmp    $0x1d,%edx
80103183:	0f 8f 9d 00 00 00    	jg     80103226 <log_write+0xb6>
80103189:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010318e:	83 e8 01             	sub    $0x1,%eax
80103191:	39 c2                	cmp    %eax,%edx
80103193:	0f 8d 8d 00 00 00    	jge    80103226 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103199:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010319e:	85 c0                	test   %eax,%eax
801031a0:	0f 8e 8d 00 00 00    	jle    80103233 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
801031a6:	83 ec 0c             	sub    $0xc,%esp
801031a9:	68 a0 26 11 80       	push   $0x801126a0
801031ae:	e8 ad 15 00 00       	call   80104760 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801031b3:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	83 f9 00             	cmp    $0x0,%ecx
801031bf:	7e 57                	jle    80103218 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c1:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
801031c4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801031c6:	3b 15 ec 26 11 80    	cmp    0x801126ec,%edx
801031cc:	75 0b                	jne    801031d9 <log_write+0x69>
801031ce:	eb 38                	jmp    80103208 <log_write+0x98>
801031d0:	39 14 85 ec 26 11 80 	cmp    %edx,-0x7feed914(,%eax,4)
801031d7:	74 2f                	je     80103208 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
801031d9:	83 c0 01             	add    $0x1,%eax
801031dc:	39 c1                	cmp    %eax,%ecx
801031de:	75 f0                	jne    801031d0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
801031e0:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
801031e7:	83 c0 01             	add    $0x1,%eax
801031ea:	a3 e8 26 11 80       	mov    %eax,0x801126e8
  b->flags |= B_DIRTY; // prevent eviction
801031ef:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801031f2:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
801031f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031fc:	c9                   	leave  
  release(&log.lock);
801031fd:	e9 1e 16 00 00       	jmp    80104820 <release>
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103208:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
8010320f:	eb de                	jmp    801031ef <log_write+0x7f>
80103211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103218:	8b 43 08             	mov    0x8(%ebx),%eax
8010321b:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
80103220:	75 cd                	jne    801031ef <log_write+0x7f>
80103222:	31 c0                	xor    %eax,%eax
80103224:	eb c1                	jmp    801031e7 <log_write+0x77>
    panic("too big a transaction");
80103226:	83 ec 0c             	sub    $0xc,%esp
80103229:	68 13 7a 10 80       	push   $0x80107a13
8010322e:	e8 5d d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103233:	83 ec 0c             	sub    $0xc,%esp
80103236:	68 29 7a 10 80       	push   $0x80107a29
8010323b:	e8 50 d1 ff ff       	call   80100390 <panic>

80103240 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	53                   	push   %ebx
80103244:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103247:	e8 74 09 00 00       	call   80103bc0 <cpuid>
8010324c:	89 c3                	mov    %eax,%ebx
8010324e:	e8 6d 09 00 00       	call   80103bc0 <cpuid>
80103253:	83 ec 04             	sub    $0x4,%esp
80103256:	53                   	push   %ebx
80103257:	50                   	push   %eax
80103258:	68 44 7a 10 80       	push   $0x80107a44
8010325d:	e8 fe d3 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103262:	e8 49 29 00 00       	call   80105bb0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103267:	e8 d4 08 00 00       	call   80103b40 <mycpu>
8010326c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010326e:	b8 01 00 00 00       	mov    $0x1,%eax
80103273:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010327a:	e8 41 0c 00 00       	call   80103ec0 <scheduler>
8010327f:	90                   	nop

80103280 <mpenter>:
{
80103280:	55                   	push   %ebp
80103281:	89 e5                	mov    %esp,%ebp
80103283:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103286:	e8 15 3a 00 00       	call   80106ca0 <switchkvm>
  seginit();
8010328b:	e8 80 39 00 00       	call   80106c10 <seginit>
  lapicinit();
80103290:	e8 9b f7 ff ff       	call   80102a30 <lapicinit>
  mpmain();
80103295:	e8 a6 ff ff ff       	call   80103240 <mpmain>
8010329a:	66 90                	xchg   %ax,%ax
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <main>:
{
801032a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801032a4:	83 e4 f0             	and    $0xfffffff0,%esp
801032a7:	ff 71 fc             	pushl  -0x4(%ecx)
801032aa:	55                   	push   %ebp
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	53                   	push   %ebx
801032ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801032af:	83 ec 08             	sub    $0x8,%esp
801032b2:	68 00 00 40 80       	push   $0x80400000
801032b7:	68 c8 54 11 80       	push   $0x801154c8
801032bc:	e8 2f f5 ff ff       	call   801027f0 <kinit1>
  kvmalloc();      // kernel page table
801032c1:	e8 aa 3e 00 00       	call   80107170 <kvmalloc>
  mpinit();        // detect other processors
801032c6:	e8 75 01 00 00       	call   80103440 <mpinit>
  lapicinit();     // interrupt controller
801032cb:	e8 60 f7 ff ff       	call   80102a30 <lapicinit>
  seginit();       // segment descriptors
801032d0:	e8 3b 39 00 00       	call   80106c10 <seginit>
  picinit();       // disable pic
801032d5:	e8 46 03 00 00       	call   80103620 <picinit>
  ioapicinit();    // another interrupt controller
801032da:	e8 41 f3 ff ff       	call   80102620 <ioapicinit>
  consoleinit();   // console hardware
801032df:	e8 dc d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
801032e4:	e8 f7 2b 00 00       	call   80105ee0 <uartinit>
  pinit();         // process table
801032e9:	e8 32 08 00 00       	call   80103b20 <pinit>
  tvinit();        // trap vectors
801032ee:	e8 3d 28 00 00       	call   80105b30 <tvinit>
  binit();         // buffer cache
801032f3:	e8 48 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
801032f8:	e8 63 da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
801032fd:	e8 fe f0 ff ff       	call   80102400 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103302:	83 c4 0c             	add    $0xc,%esp
80103305:	68 8a 00 00 00       	push   $0x8a
8010330a:	68 8c a4 10 80       	push   $0x8010a48c
8010330f:	68 00 70 00 80       	push   $0x80007000
80103314:	e8 07 16 00 00       	call   80104920 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103319:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80103320:	00 00 00 
80103323:	83 c4 10             	add    $0x10,%esp
80103326:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010332b:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103330:	76 71                	jbe    801033a3 <main+0x103>
80103332:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103337:	89 f6                	mov    %esi,%esi
80103339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80103340:	e8 fb 07 00 00       	call   80103b40 <mycpu>
80103345:	39 d8                	cmp    %ebx,%eax
80103347:	74 41                	je     8010338a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103349:	e8 72 f5 ff ff       	call   801028c0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
8010334e:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103353:	c7 05 f8 6f 00 80 80 	movl   $0x80103280,0x80006ff8
8010335a:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010335d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103364:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103367:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010336c:	0f b6 03             	movzbl (%ebx),%eax
8010336f:	83 ec 08             	sub    $0x8,%esp
80103372:	68 00 70 00 00       	push   $0x7000
80103377:	50                   	push   %eax
80103378:	e8 03 f8 ff ff       	call   80102b80 <lapicstartap>
8010337d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103380:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103386:	85 c0                	test   %eax,%eax
80103388:	74 f6                	je     80103380 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010338a:	69 05 20 2d 11 80 b0 	imul   $0xb0,0x80112d20,%eax
80103391:	00 00 00 
80103394:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010339a:	05 a0 27 11 80       	add    $0x801127a0,%eax
8010339f:	39 c3                	cmp    %eax,%ebx
801033a1:	72 9d                	jb     80103340 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801033a3:	83 ec 08             	sub    $0x8,%esp
801033a6:	68 00 00 00 8e       	push   $0x8e000000
801033ab:	68 00 00 40 80       	push   $0x80400000
801033b0:	e8 ab f4 ff ff       	call   80102860 <kinit2>
  userinit();      // first user process
801033b5:	e8 56 08 00 00       	call   80103c10 <userinit>
  mpmain();        // finish this processor's setup
801033ba:	e8 81 fe ff ff       	call   80103240 <mpmain>
801033bf:	90                   	nop

801033c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	57                   	push   %edi
801033c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801033c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801033cb:	53                   	push   %ebx
  e = addr+len;
801033cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801033cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801033d2:	39 de                	cmp    %ebx,%esi
801033d4:	72 10                	jb     801033e6 <mpsearch1+0x26>
801033d6:	eb 50                	jmp    80103428 <mpsearch1+0x68>
801033d8:	90                   	nop
801033d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033e0:	39 fb                	cmp    %edi,%ebx
801033e2:	89 fe                	mov    %edi,%esi
801033e4:	76 42                	jbe    80103428 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033e6:	83 ec 04             	sub    $0x4,%esp
801033e9:	8d 7e 10             	lea    0x10(%esi),%edi
801033ec:	6a 04                	push   $0x4
801033ee:	68 58 7a 10 80       	push   $0x80107a58
801033f3:	56                   	push   %esi
801033f4:	e8 c7 14 00 00       	call   801048c0 <memcmp>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	85 c0                	test   %eax,%eax
801033fe:	75 e0                	jne    801033e0 <mpsearch1+0x20>
80103400:	89 f1                	mov    %esi,%ecx
80103402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103408:	0f b6 11             	movzbl (%ecx),%edx
8010340b:	83 c1 01             	add    $0x1,%ecx
8010340e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103410:	39 f9                	cmp    %edi,%ecx
80103412:	75 f4                	jne    80103408 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103414:	84 c0                	test   %al,%al
80103416:	75 c8                	jne    801033e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103418:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010341b:	89 f0                	mov    %esi,%eax
8010341d:	5b                   	pop    %ebx
8010341e:	5e                   	pop    %esi
8010341f:	5f                   	pop    %edi
80103420:	5d                   	pop    %ebp
80103421:	c3                   	ret    
80103422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010342b:	31 f6                	xor    %esi,%esi
}
8010342d:	89 f0                	mov    %esi,%eax
8010342f:	5b                   	pop    %ebx
80103430:	5e                   	pop    %esi
80103431:	5f                   	pop    %edi
80103432:	5d                   	pop    %ebp
80103433:	c3                   	ret    
80103434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010343a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103440 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	57                   	push   %edi
80103444:	56                   	push   %esi
80103445:	53                   	push   %ebx
80103446:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103449:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103450:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103457:	c1 e0 08             	shl    $0x8,%eax
8010345a:	09 d0                	or     %edx,%eax
8010345c:	c1 e0 04             	shl    $0x4,%eax
8010345f:	85 c0                	test   %eax,%eax
80103461:	75 1b                	jne    8010347e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103463:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010346a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103471:	c1 e0 08             	shl    $0x8,%eax
80103474:	09 d0                	or     %edx,%eax
80103476:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103479:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010347e:	ba 00 04 00 00       	mov    $0x400,%edx
80103483:	e8 38 ff ff ff       	call   801033c0 <mpsearch1>
80103488:	85 c0                	test   %eax,%eax
8010348a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010348d:	0f 84 3d 01 00 00    	je     801035d0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103496:	8b 58 04             	mov    0x4(%eax),%ebx
80103499:	85 db                	test   %ebx,%ebx
8010349b:	0f 84 4f 01 00 00    	je     801035f0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801034a1:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
801034a7:	83 ec 04             	sub    $0x4,%esp
801034aa:	6a 04                	push   $0x4
801034ac:	68 75 7a 10 80       	push   $0x80107a75
801034b1:	56                   	push   %esi
801034b2:	e8 09 14 00 00       	call   801048c0 <memcmp>
801034b7:	83 c4 10             	add    $0x10,%esp
801034ba:	85 c0                	test   %eax,%eax
801034bc:	0f 85 2e 01 00 00    	jne    801035f0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
801034c2:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801034c9:	3c 01                	cmp    $0x1,%al
801034cb:	0f 95 c2             	setne  %dl
801034ce:	3c 04                	cmp    $0x4,%al
801034d0:	0f 95 c0             	setne  %al
801034d3:	20 c2                	and    %al,%dl
801034d5:	0f 85 15 01 00 00    	jne    801035f0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
801034db:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
801034e2:	66 85 ff             	test   %di,%di
801034e5:	74 1a                	je     80103501 <mpinit+0xc1>
801034e7:	89 f0                	mov    %esi,%eax
801034e9:	01 f7                	add    %esi,%edi
  sum = 0;
801034eb:	31 d2                	xor    %edx,%edx
801034ed:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801034f0:	0f b6 08             	movzbl (%eax),%ecx
801034f3:	83 c0 01             	add    $0x1,%eax
801034f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034f8:	39 c7                	cmp    %eax,%edi
801034fa:	75 f4                	jne    801034f0 <mpinit+0xb0>
801034fc:	84 d2                	test   %dl,%dl
801034fe:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103501:	85 f6                	test   %esi,%esi
80103503:	0f 84 e7 00 00 00    	je     801035f0 <mpinit+0x1b0>
80103509:	84 d2                	test   %dl,%dl
8010350b:	0f 85 df 00 00 00    	jne    801035f0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103511:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103517:	a3 9c 26 11 80       	mov    %eax,0x8011269c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010351c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103523:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103529:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010352e:	01 d6                	add    %edx,%esi
80103530:	39 c6                	cmp    %eax,%esi
80103532:	76 23                	jbe    80103557 <mpinit+0x117>
    switch(*p){
80103534:	0f b6 10             	movzbl (%eax),%edx
80103537:	80 fa 04             	cmp    $0x4,%dl
8010353a:	0f 87 ca 00 00 00    	ja     8010360a <mpinit+0x1ca>
80103540:	ff 24 95 9c 7a 10 80 	jmp    *-0x7fef8564(,%edx,4)
80103547:	89 f6                	mov    %esi,%esi
80103549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103550:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103553:	39 c6                	cmp    %eax,%esi
80103555:	77 dd                	ja     80103534 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103557:	85 db                	test   %ebx,%ebx
80103559:	0f 84 9e 00 00 00    	je     801035fd <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010355f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103562:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103566:	74 15                	je     8010357d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103568:	b8 70 00 00 00       	mov    $0x70,%eax
8010356d:	ba 22 00 00 00       	mov    $0x22,%edx
80103572:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103573:	ba 23 00 00 00       	mov    $0x23,%edx
80103578:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103579:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010357c:	ee                   	out    %al,(%dx)
  }
}
8010357d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103580:	5b                   	pop    %ebx
80103581:	5e                   	pop    %esi
80103582:	5f                   	pop    %edi
80103583:	5d                   	pop    %ebp
80103584:	c3                   	ret    
80103585:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103588:	8b 0d 20 2d 11 80    	mov    0x80112d20,%ecx
8010358e:	83 f9 07             	cmp    $0x7,%ecx
80103591:	7f 19                	jg     801035ac <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103593:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103597:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010359d:	83 c1 01             	add    $0x1,%ecx
801035a0:	89 0d 20 2d 11 80    	mov    %ecx,0x80112d20
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035a6:	88 97 a0 27 11 80    	mov    %dl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
801035ac:	83 c0 14             	add    $0x14,%eax
      continue;
801035af:	e9 7c ff ff ff       	jmp    80103530 <mpinit+0xf0>
801035b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801035b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801035bc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801035bf:	88 15 80 27 11 80    	mov    %dl,0x80112780
      continue;
801035c5:	e9 66 ff ff ff       	jmp    80103530 <mpinit+0xf0>
801035ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
801035d0:	ba 00 00 01 00       	mov    $0x10000,%edx
801035d5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801035da:	e8 e1 fd ff ff       	call   801033c0 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035df:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
801035e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801035e4:	0f 85 a9 fe ff ff    	jne    80103493 <mpinit+0x53>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	68 5d 7a 10 80       	push   $0x80107a5d
801035f8:	e8 93 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801035fd:	83 ec 0c             	sub    $0xc,%esp
80103600:	68 7c 7a 10 80       	push   $0x80107a7c
80103605:	e8 86 cd ff ff       	call   80100390 <panic>
      ismp = 0;
8010360a:	31 db                	xor    %ebx,%ebx
8010360c:	e9 26 ff ff ff       	jmp    80103537 <mpinit+0xf7>
80103611:	66 90                	xchg   %ax,%ax
80103613:	66 90                	xchg   %ax,%ax
80103615:	66 90                	xchg   %ax,%ax
80103617:	66 90                	xchg   %ax,%ax
80103619:	66 90                	xchg   %ax,%ax
8010361b:	66 90                	xchg   %ax,%ax
8010361d:	66 90                	xchg   %ax,%ax
8010361f:	90                   	nop

80103620 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103620:	55                   	push   %ebp
80103621:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103626:	ba 21 00 00 00       	mov    $0x21,%edx
8010362b:	89 e5                	mov    %esp,%ebp
8010362d:	ee                   	out    %al,(%dx)
8010362e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103633:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103634:	5d                   	pop    %ebp
80103635:	c3                   	ret    
80103636:	66 90                	xchg   %ax,%ax
80103638:	66 90                	xchg   %ax,%ax
8010363a:	66 90                	xchg   %ax,%ax
8010363c:	66 90                	xchg   %ax,%ax
8010363e:	66 90                	xchg   %ax,%ax

80103640 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	57                   	push   %edi
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010364c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010364f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103655:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010365b:	e8 20 d7 ff ff       	call   80100d80 <filealloc>
80103660:	85 c0                	test   %eax,%eax
80103662:	89 03                	mov    %eax,(%ebx)
80103664:	74 22                	je     80103688 <pipealloc+0x48>
80103666:	e8 15 d7 ff ff       	call   80100d80 <filealloc>
8010366b:	85 c0                	test   %eax,%eax
8010366d:	89 06                	mov    %eax,(%esi)
8010366f:	74 3f                	je     801036b0 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103671:	e8 4a f2 ff ff       	call   801028c0 <kalloc>
80103676:	85 c0                	test   %eax,%eax
80103678:	89 c7                	mov    %eax,%edi
8010367a:	75 54                	jne    801036d0 <pipealloc+0x90>
  return 0;

 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010367c:	8b 03                	mov    (%ebx),%eax
8010367e:	85 c0                	test   %eax,%eax
80103680:	75 34                	jne    801036b6 <pipealloc+0x76>
80103682:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103688:	8b 06                	mov    (%esi),%eax
8010368a:	85 c0                	test   %eax,%eax
8010368c:	74 0c                	je     8010369a <pipealloc+0x5a>
    fileclose(*f1);
8010368e:	83 ec 0c             	sub    $0xc,%esp
80103691:	50                   	push   %eax
80103692:	e8 a9 d7 ff ff       	call   80100e40 <fileclose>
80103697:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010369a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010369d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801036a2:	5b                   	pop    %ebx
801036a3:	5e                   	pop    %esi
801036a4:	5f                   	pop    %edi
801036a5:	5d                   	pop    %ebp
801036a6:	c3                   	ret    
801036a7:	89 f6                	mov    %esi,%esi
801036a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
801036b0:	8b 03                	mov    (%ebx),%eax
801036b2:	85 c0                	test   %eax,%eax
801036b4:	74 e4                	je     8010369a <pipealloc+0x5a>
    fileclose(*f0);
801036b6:	83 ec 0c             	sub    $0xc,%esp
801036b9:	50                   	push   %eax
801036ba:	e8 81 d7 ff ff       	call   80100e40 <fileclose>
  if(*f1)
801036bf:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
801036c1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801036c4:	85 c0                	test   %eax,%eax
801036c6:	75 c6                	jne    8010368e <pipealloc+0x4e>
801036c8:	eb d0                	jmp    8010369a <pipealloc+0x5a>
801036ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
801036d0:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
801036d3:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801036da:	00 00 00 
  p->writeopen = 1;
801036dd:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801036e4:	00 00 00 
  p->nwrite = 0;
801036e7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801036ee:	00 00 00 
  p->nread = 0;
801036f1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801036f8:	00 00 00 
  initlock(&p->lock, "pipe");
801036fb:	68 b0 7a 10 80       	push   $0x80107ab0
80103700:	50                   	push   %eax
80103701:	e8 1a 0f 00 00       	call   80104620 <initlock>
  (*f0)->type = FD_PIPE;
80103706:	8b 03                	mov    (%ebx),%eax
  return 0;
80103708:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010370b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103711:	8b 03                	mov    (%ebx),%eax
80103713:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103717:	8b 03                	mov    (%ebx),%eax
80103719:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010371d:	8b 03                	mov    (%ebx),%eax
8010371f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103722:	8b 06                	mov    (%esi),%eax
80103724:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010372a:	8b 06                	mov    (%esi),%eax
8010372c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103730:	8b 06                	mov    (%esi),%eax
80103732:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103736:	8b 06                	mov    (%esi),%eax
80103738:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010373b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010373e:	31 c0                	xor    %eax,%eax
}
80103740:	5b                   	pop    %ebx
80103741:	5e                   	pop    %esi
80103742:	5f                   	pop    %edi
80103743:	5d                   	pop    %ebp
80103744:	c3                   	ret    
80103745:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103750 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	56                   	push   %esi
80103754:	53                   	push   %ebx
80103755:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103758:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	53                   	push   %ebx
8010375f:	e8 fc 0f 00 00       	call   80104760 <acquire>
  if(writable){
80103764:	83 c4 10             	add    $0x10,%esp
80103767:	85 f6                	test   %esi,%esi
80103769:	74 45                	je     801037b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010376b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103771:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103774:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010377b:	00 00 00 
    wakeup(&p->nread);
8010377e:	50                   	push   %eax
8010377f:	e8 cc 0b 00 00       	call   80104350 <wakeup>
80103784:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103787:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010378d:	85 d2                	test   %edx,%edx
8010378f:	75 0a                	jne    8010379b <pipeclose+0x4b>
80103791:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103797:	85 c0                	test   %eax,%eax
80103799:	74 35                	je     801037d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010379b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010379e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037a1:	5b                   	pop    %ebx
801037a2:	5e                   	pop    %esi
801037a3:	5d                   	pop    %ebp
    release(&p->lock);
801037a4:	e9 77 10 00 00       	jmp    80104820 <release>
801037a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801037b0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801037b6:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
801037b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801037c0:	00 00 00 
    wakeup(&p->nwrite);
801037c3:	50                   	push   %eax
801037c4:	e8 87 0b 00 00       	call   80104350 <wakeup>
801037c9:	83 c4 10             	add    $0x10,%esp
801037cc:	eb b9                	jmp    80103787 <pipeclose+0x37>
801037ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
801037d3:	53                   	push   %ebx
801037d4:	e8 47 10 00 00       	call   80104820 <release>
    kfree((char*)p);
801037d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801037dc:	83 c4 10             	add    $0x10,%esp
}
801037df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037e2:	5b                   	pop    %ebx
801037e3:	5e                   	pop    %esi
801037e4:	5d                   	pop    %ebp
    kfree((char*)p);
801037e5:	e9 26 ef ff ff       	jmp    80102710 <kfree>
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	57                   	push   %edi
801037f4:	56                   	push   %esi
801037f5:	53                   	push   %ebx
801037f6:	83 ec 28             	sub    $0x28,%esp
801037f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801037fc:	53                   	push   %ebx
801037fd:	e8 5e 0f 00 00       	call   80104760 <acquire>
  for(i = 0; i < n; i++){
80103802:	8b 45 10             	mov    0x10(%ebp),%eax
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	85 c0                	test   %eax,%eax
8010380a:	0f 8e c9 00 00 00    	jle    801038d9 <pipewrite+0xe9>
80103810:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103813:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103819:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010381f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103822:	03 4d 10             	add    0x10(%ebp),%ecx
80103825:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103828:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010382e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103834:	39 d0                	cmp    %edx,%eax
80103836:	75 71                	jne    801038a9 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103838:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010383e:	85 c0                	test   %eax,%eax
80103840:	74 4e                	je     80103890 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103842:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103848:	eb 3a                	jmp    80103884 <pipewrite+0x94>
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	57                   	push   %edi
80103854:	e8 f7 0a 00 00       	call   80104350 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103859:	5a                   	pop    %edx
8010385a:	59                   	pop    %ecx
8010385b:	53                   	push   %ebx
8010385c:	56                   	push   %esi
8010385d:	e8 3e 09 00 00       	call   801041a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103862:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103868:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010386e:	83 c4 10             	add    $0x10,%esp
80103871:	05 00 02 00 00       	add    $0x200,%eax
80103876:	39 c2                	cmp    %eax,%edx
80103878:	75 36                	jne    801038b0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010387a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103880:	85 c0                	test   %eax,%eax
80103882:	74 0c                	je     80103890 <pipewrite+0xa0>
80103884:	e8 57 03 00 00       	call   80103be0 <myproc>
80103889:	8b 40 24             	mov    0x24(%eax),%eax
8010388c:	85 c0                	test   %eax,%eax
8010388e:	74 c0                	je     80103850 <pipewrite+0x60>
        release(&p->lock);
80103890:	83 ec 0c             	sub    $0xc,%esp
80103893:	53                   	push   %ebx
80103894:	e8 87 0f 00 00       	call   80104820 <release>
        return -1;
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801038a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038a4:	5b                   	pop    %ebx
801038a5:	5e                   	pop    %esi
801038a6:	5f                   	pop    %edi
801038a7:	5d                   	pop    %ebp
801038a8:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038a9:	89 c2                	mov    %eax,%edx
801038ab:	90                   	nop
801038ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038b0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801038b3:	8d 42 01             	lea    0x1(%edx),%eax
801038b6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801038bc:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801038c2:	83 c6 01             	add    $0x1,%esi
801038c5:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
801038c9:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801038cc:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801038cf:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801038d3:	0f 85 4f ff ff ff    	jne    80103828 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801038d9:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801038df:	83 ec 0c             	sub    $0xc,%esp
801038e2:	50                   	push   %eax
801038e3:	e8 68 0a 00 00       	call   80104350 <wakeup>
  release(&p->lock);
801038e8:	89 1c 24             	mov    %ebx,(%esp)
801038eb:	e8 30 0f 00 00       	call   80104820 <release>
  return n;
801038f0:	83 c4 10             	add    $0x10,%esp
801038f3:	8b 45 10             	mov    0x10(%ebp),%eax
801038f6:	eb a9                	jmp    801038a1 <pipewrite+0xb1>
801038f8:	90                   	nop
801038f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103900 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	57                   	push   %edi
80103904:	56                   	push   %esi
80103905:	53                   	push   %ebx
80103906:	83 ec 18             	sub    $0x18,%esp
80103909:	8b 75 08             	mov    0x8(%ebp),%esi
8010390c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010390f:	56                   	push   %esi
80103910:	e8 4b 0e 00 00       	call   80104760 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103915:	83 c4 10             	add    $0x10,%esp
80103918:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010391e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103924:	75 6a                	jne    80103990 <piperead+0x90>
80103926:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010392c:	85 db                	test   %ebx,%ebx
8010392e:	0f 84 c4 00 00 00    	je     801039f8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103934:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010393a:	eb 2d                	jmp    80103969 <piperead+0x69>
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103940:	83 ec 08             	sub    $0x8,%esp
80103943:	56                   	push   %esi
80103944:	53                   	push   %ebx
80103945:	e8 56 08 00 00       	call   801041a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010394a:	83 c4 10             	add    $0x10,%esp
8010394d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103953:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103959:	75 35                	jne    80103990 <piperead+0x90>
8010395b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103961:	85 d2                	test   %edx,%edx
80103963:	0f 84 8f 00 00 00    	je     801039f8 <piperead+0xf8>
    if(myproc()->killed){
80103969:	e8 72 02 00 00       	call   80103be0 <myproc>
8010396e:	8b 48 24             	mov    0x24(%eax),%ecx
80103971:	85 c9                	test   %ecx,%ecx
80103973:	74 cb                	je     80103940 <piperead+0x40>
      release(&p->lock);
80103975:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103978:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010397d:	56                   	push   %esi
8010397e:	e8 9d 0e 00 00       	call   80104820 <release>
      return -1;
80103983:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103986:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103989:	89 d8                	mov    %ebx,%eax
8010398b:	5b                   	pop    %ebx
8010398c:	5e                   	pop    %esi
8010398d:	5f                   	pop    %edi
8010398e:	5d                   	pop    %ebp
8010398f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103990:	8b 45 10             	mov    0x10(%ebp),%eax
80103993:	85 c0                	test   %eax,%eax
80103995:	7e 61                	jle    801039f8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103997:	31 db                	xor    %ebx,%ebx
80103999:	eb 13                	jmp    801039ae <piperead+0xae>
8010399b:	90                   	nop
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039a0:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039a6:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039ac:	74 1f                	je     801039cd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801039ae:	8d 41 01             	lea    0x1(%ecx),%eax
801039b1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801039b7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801039bd:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801039c2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039c5:	83 c3 01             	add    $0x1,%ebx
801039c8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801039cb:	75 d3                	jne    801039a0 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801039cd:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801039d3:	83 ec 0c             	sub    $0xc,%esp
801039d6:	50                   	push   %eax
801039d7:	e8 74 09 00 00       	call   80104350 <wakeup>
  release(&p->lock);
801039dc:	89 34 24             	mov    %esi,(%esp)
801039df:	e8 3c 0e 00 00       	call   80104820 <release>
  return i;
801039e4:	83 c4 10             	add    $0x10,%esp
}
801039e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039ea:	89 d8                	mov    %ebx,%eax
801039ec:	5b                   	pop    %ebx
801039ed:	5e                   	pop    %esi
801039ee:	5f                   	pop    %edi
801039ef:	5d                   	pop    %ebp
801039f0:	c3                   	ret    
801039f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039f8:	31 db                	xor    %ebx,%ebx
801039fa:	eb d1                	jmp    801039cd <piperead+0xcd>
801039fc:	66 90                	xchg   %ax,%ax
801039fe:	66 90                	xchg   %ax,%ax

80103a00 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a04:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
80103a09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103a0c:	68 40 2d 11 80       	push   $0x80112d40
80103a11:	e8 4a 0d 00 00       	call   80104760 <acquire>
80103a16:	83 c4 10             	add    $0x10,%esp
80103a19:	eb 10                	jmp    80103a2b <allocproc+0x2b>
80103a1b:	90                   	nop
80103a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a20:	83 c3 7c             	add    $0x7c,%ebx
80103a23:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103a29:	73 75                	jae    80103aa0 <allocproc+0xa0>
    if(p->state == UNUSED)
80103a2b:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a2e:	85 c0                	test   %eax,%eax
80103a30:	75 ee                	jne    80103a20 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a32:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103a37:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a3a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103a41:	8d 50 01             	lea    0x1(%eax),%edx
80103a44:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103a47:	68 40 2d 11 80       	push   $0x80112d40
  p->pid = nextpid++;
80103a4c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103a52:	e8 c9 0d 00 00       	call   80104820 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103a57:	e8 64 ee ff ff       	call   801028c0 <kalloc>
80103a5c:	83 c4 10             	add    $0x10,%esp
80103a5f:	85 c0                	test   %eax,%eax
80103a61:	89 43 08             	mov    %eax,0x8(%ebx)
80103a64:	74 53                	je     80103ab9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a66:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a6c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a6f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a74:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a77:	c7 40 14 22 5b 10 80 	movl   $0x80105b22,0x14(%eax)
  p->context = (struct context*)sp;
80103a7e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a81:	6a 14                	push   $0x14
80103a83:	6a 00                	push   $0x0
80103a85:	50                   	push   %eax
80103a86:	e8 e5 0d 00 00       	call   80104870 <memset>
  p->context->eip = (uint)forkret;
80103a8b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a8e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a91:	c7 40 10 d0 3a 10 80 	movl   $0x80103ad0,0x10(%eax)
}
80103a98:	89 d8                	mov    %ebx,%eax
80103a9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a9d:	c9                   	leave  
80103a9e:	c3                   	ret    
80103a9f:	90                   	nop
  release(&ptable.lock);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103aa3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103aa5:	68 40 2d 11 80       	push   $0x80112d40
80103aaa:	e8 71 0d 00 00       	call   80104820 <release>
}
80103aaf:	89 d8                	mov    %ebx,%eax
  return 0;
80103ab1:	83 c4 10             	add    $0x10,%esp
}
80103ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab7:	c9                   	leave  
80103ab8:	c3                   	ret    
    p->state = UNUSED;
80103ab9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103ac0:	31 db                	xor    %ebx,%ebx
80103ac2:	eb d4                	jmp    80103a98 <allocproc+0x98>
80103ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ad0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103ad6:	68 40 2d 11 80       	push   $0x80112d40
80103adb:	e8 40 0d 00 00       	call   80104820 <release>

  if (first) {
80103ae0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103ae5:	83 c4 10             	add    $0x10,%esp
80103ae8:	85 c0                	test   %eax,%eax
80103aea:	75 04                	jne    80103af0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103aec:	c9                   	leave  
80103aed:	c3                   	ret    
80103aee:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103af0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103af3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103afa:	00 00 00 
    iinit(ROOTDEV);
80103afd:	6a 01                	push   $0x1
80103aff:	e8 ec da ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80103b04:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b0b:	e8 f0 f3 ff ff       	call   80102f00 <initlog>
80103b10:	83 c4 10             	add    $0x10,%esp
}
80103b13:	c9                   	leave  
80103b14:	c3                   	ret    
80103b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b20 <pinit>:
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b26:	68 b5 7a 10 80       	push   $0x80107ab5
80103b2b:	68 40 2d 11 80       	push   $0x80112d40
80103b30:	e8 eb 0a 00 00       	call   80104620 <initlock>
}
80103b35:	83 c4 10             	add    $0x10,%esp
80103b38:	c9                   	leave  
80103b39:	c3                   	ret    
80103b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b40 <mycpu>:
{
80103b40:	55                   	push   %ebp
80103b41:	89 e5                	mov    %esp,%ebp
80103b43:	56                   	push   %esi
80103b44:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b45:	9c                   	pushf  
80103b46:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b47:	f6 c4 02             	test   $0x2,%ah
80103b4a:	75 5e                	jne    80103baa <mycpu+0x6a>
  apicid = lapicid();
80103b4c:	e8 df ef ff ff       	call   80102b30 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103b51:	8b 35 20 2d 11 80    	mov    0x80112d20,%esi
80103b57:	85 f6                	test   %esi,%esi
80103b59:	7e 42                	jle    80103b9d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b5b:	0f b6 15 a0 27 11 80 	movzbl 0x801127a0,%edx
80103b62:	39 d0                	cmp    %edx,%eax
80103b64:	74 30                	je     80103b96 <mycpu+0x56>
80103b66:	b9 50 28 11 80       	mov    $0x80112850,%ecx
  for (i = 0; i < ncpu; ++i) {
80103b6b:	31 d2                	xor    %edx,%edx
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
80103b70:	83 c2 01             	add    $0x1,%edx
80103b73:	39 f2                	cmp    %esi,%edx
80103b75:	74 26                	je     80103b9d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b77:	0f b6 19             	movzbl (%ecx),%ebx
80103b7a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b80:	39 c3                	cmp    %eax,%ebx
80103b82:	75 ec                	jne    80103b70 <mycpu+0x30>
80103b84:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103b8a:	05 a0 27 11 80       	add    $0x801127a0,%eax
}
80103b8f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b92:	5b                   	pop    %ebx
80103b93:	5e                   	pop    %esi
80103b94:	5d                   	pop    %ebp
80103b95:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b96:	b8 a0 27 11 80       	mov    $0x801127a0,%eax
      return &cpus[i];
80103b9b:	eb f2                	jmp    80103b8f <mycpu+0x4f>
  panic("unknown apicid\n");
80103b9d:	83 ec 0c             	sub    $0xc,%esp
80103ba0:	68 bc 7a 10 80       	push   $0x80107abc
80103ba5:	e8 e6 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103baa:	83 ec 0c             	sub    $0xc,%esp
80103bad:	68 a0 7b 10 80       	push   $0x80107ba0
80103bb2:	e8 d9 c7 ff ff       	call   80100390 <panic>
80103bb7:	89 f6                	mov    %esi,%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <cpuid>:
cpuid() {
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103bc6:	e8 75 ff ff ff       	call   80103b40 <mycpu>
80103bcb:	2d a0 27 11 80       	sub    $0x801127a0,%eax
}
80103bd0:	c9                   	leave  
  return mycpu()-cpus;
80103bd1:	c1 f8 04             	sar    $0x4,%eax
80103bd4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103bda:	c3                   	ret    
80103bdb:	90                   	nop
80103bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103be0 <myproc>:
myproc(void) {
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	53                   	push   %ebx
80103be4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103be7:	e8 a4 0a 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103bec:	e8 4f ff ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103bf1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf7:	e8 d4 0a 00 00       	call   801046d0 <popcli>
}
80103bfc:	83 c4 04             	add    $0x4,%esp
80103bff:	89 d8                	mov    %ebx,%eax
80103c01:	5b                   	pop    %ebx
80103c02:	5d                   	pop    %ebp
80103c03:	c3                   	ret    
80103c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c10 <userinit>:
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	53                   	push   %ebx
80103c14:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c17:	e8 e4 fd ff ff       	call   80103a00 <allocproc>
80103c1c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c1e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103c23:	e8 c8 34 00 00       	call   801070f0 <setupkvm>
80103c28:	85 c0                	test   %eax,%eax
80103c2a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c2d:	0f 84 d6 00 00 00    	je     80103d09 <userinit+0xf9>
  cprintf("%p %p\n", _binary_initcode_start, _binary_initcode_size);
80103c33:	83 ec 04             	sub    $0x4,%esp
80103c36:	68 2c 00 00 00       	push   $0x2c
80103c3b:	68 60 a4 10 80       	push   $0x8010a460
80103c40:	68 e5 7a 10 80       	push   $0x80107ae5
80103c45:	e8 16 ca ff ff       	call   80100660 <cprintf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c4a:	83 c4 0c             	add    $0xc,%esp
80103c4d:	68 2c 00 00 00       	push   $0x2c
80103c52:	68 60 a4 10 80       	push   $0x8010a460
80103c57:	ff 73 04             	pushl  0x4(%ebx)
80103c5a:	e8 71 31 00 00       	call   80106dd0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103c5f:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103c62:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103c68:	6a 4c                	push   $0x4c
80103c6a:	6a 00                	push   $0x0
80103c6c:	ff 73 18             	pushl  0x18(%ebx)
80103c6f:	e8 fc 0b 00 00       	call   80104870 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c74:	8b 43 18             	mov    0x18(%ebx),%eax
80103c77:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c7c:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c81:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c84:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c88:	8b 43 18             	mov    0x18(%ebx),%eax
80103c8b:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c8f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c92:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c96:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c9a:	8b 43 18             	mov    0x18(%ebx),%eax
80103c9d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ca1:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ca5:	8b 43 18             	mov    0x18(%ebx),%eax
80103ca8:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103caf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cb2:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103cb9:	8b 43 18             	mov    0x18(%ebx),%eax
80103cbc:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cc3:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103cc6:	6a 10                	push   $0x10
80103cc8:	68 ec 7a 10 80       	push   $0x80107aec
80103ccd:	50                   	push   %eax
80103cce:	e8 7d 0d 00 00       	call   80104a50 <safestrcpy>
  p->cwd = namei("/");
80103cd3:	c7 04 24 f5 7a 10 80 	movl   $0x80107af5,(%esp)
80103cda:	e8 f1 e4 ff ff       	call   801021d0 <namei>
80103cdf:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103ce2:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103ce9:	e8 72 0a 00 00       	call   80104760 <acquire>
  p->state = RUNNABLE;
80103cee:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103cf5:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103cfc:	e8 1f 0b 00 00       	call   80104820 <release>
}
80103d01:	83 c4 10             	add    $0x10,%esp
80103d04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d07:	c9                   	leave  
80103d08:	c3                   	ret    
    panic("userinit: out of memory?");
80103d09:	83 ec 0c             	sub    $0xc,%esp
80103d0c:	68 cc 7a 10 80       	push   $0x80107acc
80103d11:	e8 7a c6 ff ff       	call   80100390 <panic>
80103d16:	8d 76 00             	lea    0x0(%esi),%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d20 <growproc>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	56                   	push   %esi
80103d24:	53                   	push   %ebx
80103d25:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d28:	e8 63 09 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103d2d:	e8 0e fe ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103d32:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d38:	e8 93 09 00 00       	call   801046d0 <popcli>
  if(n > 0){
80103d3d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d40:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d42:	7f 1c                	jg     80103d60 <growproc+0x40>
  } else if(n < 0){
80103d44:	75 3a                	jne    80103d80 <growproc+0x60>
  switchuvm(curproc);
80103d46:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d49:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d4b:	53                   	push   %ebx
80103d4c:	e8 6f 2f 00 00       	call   80106cc0 <switchuvm>
  return 0;
80103d51:	83 c4 10             	add    $0x10,%esp
80103d54:	31 c0                	xor    %eax,%eax
}
80103d56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d59:	5b                   	pop    %ebx
80103d5a:	5e                   	pop    %esi
80103d5b:	5d                   	pop    %ebp
80103d5c:	c3                   	ret    
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d60:	83 ec 04             	sub    $0x4,%esp
80103d63:	01 c6                	add    %eax,%esi
80103d65:	56                   	push   %esi
80103d66:	50                   	push   %eax
80103d67:	ff 73 04             	pushl  0x4(%ebx)
80103d6a:	e8 a1 31 00 00       	call   80106f10 <allocuvm>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	85 c0                	test   %eax,%eax
80103d74:	75 d0                	jne    80103d46 <growproc+0x26>
      return -1;
80103d76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d7b:	eb d9                	jmp    80103d56 <growproc+0x36>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d80:	83 ec 04             	sub    $0x4,%esp
80103d83:	01 c6                	add    %eax,%esi
80103d85:	56                   	push   %esi
80103d86:	50                   	push   %eax
80103d87:	ff 73 04             	pushl  0x4(%ebx)
80103d8a:	e8 b1 32 00 00       	call   80107040 <deallocuvm>
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	85 c0                	test   %eax,%eax
80103d94:	75 b0                	jne    80103d46 <growproc+0x26>
80103d96:	eb de                	jmp    80103d76 <growproc+0x56>
80103d98:	90                   	nop
80103d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103da0 <fork>:
{
80103da0:	55                   	push   %ebp
80103da1:	89 e5                	mov    %esp,%ebp
80103da3:	57                   	push   %edi
80103da4:	56                   	push   %esi
80103da5:	53                   	push   %ebx
80103da6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103da9:	e8 e2 08 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103dae:	e8 8d fd ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103db3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103db9:	e8 12 09 00 00       	call   801046d0 <popcli>
  if((np = allocproc()) == 0){
80103dbe:	e8 3d fc ff ff       	call   80103a00 <allocproc>
80103dc3:	85 c0                	test   %eax,%eax
80103dc5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103dc8:	0f 84 b7 00 00 00    	je     80103e85 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103dce:	83 ec 08             	sub    $0x8,%esp
80103dd1:	ff 33                	pushl  (%ebx)
80103dd3:	ff 73 04             	pushl  0x4(%ebx)
80103dd6:	89 c7                	mov    %eax,%edi
80103dd8:	e8 e3 33 00 00       	call   801071c0 <copyuvm>
80103ddd:	83 c4 10             	add    $0x10,%esp
80103de0:	85 c0                	test   %eax,%eax
80103de2:	89 47 04             	mov    %eax,0x4(%edi)
80103de5:	0f 84 a1 00 00 00    	je     80103e8c <fork+0xec>
  np->sz = curproc->sz;
80103deb:	8b 03                	mov    (%ebx),%eax
80103ded:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103df0:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103df2:	89 59 14             	mov    %ebx,0x14(%ecx)
80103df5:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103df7:	8b 79 18             	mov    0x18(%ecx),%edi
80103dfa:	8b 73 18             	mov    0x18(%ebx),%esi
80103dfd:	b9 13 00 00 00       	mov    $0x13,%ecx
80103e02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e04:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e06:	8b 40 18             	mov    0x18(%eax),%eax
80103e09:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103e10:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	74 13                	je     80103e2b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e18:	83 ec 0c             	sub    $0xc,%esp
80103e1b:	50                   	push   %eax
80103e1c:	e8 cf cf ff ff       	call   80100df0 <filedup>
80103e21:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e24:	83 c4 10             	add    $0x10,%esp
80103e27:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e2b:	83 c6 01             	add    $0x1,%esi
80103e2e:	83 fe 10             	cmp    $0x10,%esi
80103e31:	75 dd                	jne    80103e10 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103e33:	83 ec 0c             	sub    $0xc,%esp
80103e36:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e39:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103e3c:	e8 3f da ff ff       	call   80101880 <idup>
80103e41:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e44:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e47:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e4a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e4d:	6a 10                	push   $0x10
80103e4f:	53                   	push   %ebx
80103e50:	50                   	push   %eax
80103e51:	e8 fa 0b 00 00       	call   80104a50 <safestrcpy>
  pid = np->pid;
80103e56:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103e59:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e60:	e8 fb 08 00 00       	call   80104760 <acquire>
  np->state = RUNNABLE;
80103e65:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103e6c:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80103e73:	e8 a8 09 00 00       	call   80104820 <release>
  return pid;
80103e78:	83 c4 10             	add    $0x10,%esp
}
80103e7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e7e:	89 d8                	mov    %ebx,%eax
80103e80:	5b                   	pop    %ebx
80103e81:	5e                   	pop    %esi
80103e82:	5f                   	pop    %edi
80103e83:	5d                   	pop    %ebp
80103e84:	c3                   	ret    
    return -1;
80103e85:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e8a:	eb ef                	jmp    80103e7b <fork+0xdb>
    kfree(np->kstack);
80103e8c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e8f:	83 ec 0c             	sub    $0xc,%esp
80103e92:	ff 73 08             	pushl  0x8(%ebx)
80103e95:	e8 76 e8 ff ff       	call   80102710 <kfree>
    np->kstack = 0;
80103e9a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103ea1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ea8:	83 c4 10             	add    $0x10,%esp
80103eab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103eb0:	eb c9                	jmp    80103e7b <fork+0xdb>
80103eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ec0 <scheduler>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ec9:	e8 72 fc ff ff       	call   80103b40 <mycpu>
80103ece:	8d 78 04             	lea    0x4(%eax),%edi
80103ed1:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103ed3:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103eda:	00 00 00 
80103edd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103ee0:	fb                   	sti    
    acquire(&ptable.lock);
80103ee1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ee4:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
    acquire(&ptable.lock);
80103ee9:	68 40 2d 11 80       	push   $0x80112d40
80103eee:	e8 6d 08 00 00       	call   80104760 <acquire>
80103ef3:	83 c4 10             	add    $0x10,%esp
80103ef6:	8d 76 00             	lea    0x0(%esi),%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103f00:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f04:	75 33                	jne    80103f39 <scheduler+0x79>
      switchuvm(p);
80103f06:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f09:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f0f:	53                   	push   %ebx
80103f10:	e8 ab 2d 00 00       	call   80106cc0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f15:	58                   	pop    %eax
80103f16:	5a                   	pop    %edx
80103f17:	ff 73 1c             	pushl  0x1c(%ebx)
80103f1a:	57                   	push   %edi
      p->state = RUNNING;
80103f1b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f22:	e8 84 0b 00 00       	call   80104aab <swtch>
      switchkvm();
80103f27:	e8 74 2d 00 00       	call   80106ca0 <switchkvm>
      c->proc = 0;
80103f2c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f33:	00 00 00 
80103f36:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f39:	83 c3 7c             	add    $0x7c,%ebx
80103f3c:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80103f42:	72 bc                	jb     80103f00 <scheduler+0x40>
    release(&ptable.lock);
80103f44:	83 ec 0c             	sub    $0xc,%esp
80103f47:	68 40 2d 11 80       	push   $0x80112d40
80103f4c:	e8 cf 08 00 00       	call   80104820 <release>
    sti();
80103f51:	83 c4 10             	add    $0x10,%esp
80103f54:	eb 8a                	jmp    80103ee0 <scheduler+0x20>
80103f56:	8d 76 00             	lea    0x0(%esi),%esi
80103f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f60 <sched>:
{
80103f60:	55                   	push   %ebp
80103f61:	89 e5                	mov    %esp,%ebp
80103f63:	56                   	push   %esi
80103f64:	53                   	push   %ebx
  pushcli();
80103f65:	e8 26 07 00 00       	call   80104690 <pushcli>
  c = mycpu();
80103f6a:	e8 d1 fb ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80103f6f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f75:	e8 56 07 00 00       	call   801046d0 <popcli>
  if(!holding(&ptable.lock))
80103f7a:	83 ec 0c             	sub    $0xc,%esp
80103f7d:	68 40 2d 11 80       	push   $0x80112d40
80103f82:	e8 a9 07 00 00       	call   80104730 <holding>
80103f87:	83 c4 10             	add    $0x10,%esp
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	74 4f                	je     80103fdd <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f8e:	e8 ad fb ff ff       	call   80103b40 <mycpu>
80103f93:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f9a:	75 68                	jne    80104004 <sched+0xa4>
  if(p->state == RUNNING)
80103f9c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fa0:	74 55                	je     80103ff7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fa2:	9c                   	pushf  
80103fa3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fa4:	f6 c4 02             	test   $0x2,%ah
80103fa7:	75 41                	jne    80103fea <sched+0x8a>
  intena = mycpu()->intena;
80103fa9:	e8 92 fb ff ff       	call   80103b40 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fae:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103fb1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103fb7:	e8 84 fb ff ff       	call   80103b40 <mycpu>
80103fbc:	83 ec 08             	sub    $0x8,%esp
80103fbf:	ff 70 04             	pushl  0x4(%eax)
80103fc2:	53                   	push   %ebx
80103fc3:	e8 e3 0a 00 00       	call   80104aab <swtch>
  mycpu()->intena = intena;
80103fc8:	e8 73 fb ff ff       	call   80103b40 <mycpu>
}
80103fcd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103fd0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fd9:	5b                   	pop    %ebx
80103fda:	5e                   	pop    %esi
80103fdb:	5d                   	pop    %ebp
80103fdc:	c3                   	ret    
    panic("sched ptable.lock");
80103fdd:	83 ec 0c             	sub    $0xc,%esp
80103fe0:	68 f7 7a 10 80       	push   $0x80107af7
80103fe5:	e8 a6 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103fea:	83 ec 0c             	sub    $0xc,%esp
80103fed:	68 23 7b 10 80       	push   $0x80107b23
80103ff2:	e8 99 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80103ff7:	83 ec 0c             	sub    $0xc,%esp
80103ffa:	68 15 7b 10 80       	push   $0x80107b15
80103fff:	e8 8c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104004:	83 ec 0c             	sub    $0xc,%esp
80104007:	68 09 7b 10 80       	push   $0x80107b09
8010400c:	e8 7f c3 ff ff       	call   80100390 <panic>
80104011:	eb 0d                	jmp    80104020 <exit>
80104013:	90                   	nop
80104014:	90                   	nop
80104015:	90                   	nop
80104016:	90                   	nop
80104017:	90                   	nop
80104018:	90                   	nop
80104019:	90                   	nop
8010401a:	90                   	nop
8010401b:	90                   	nop
8010401c:	90                   	nop
8010401d:	90                   	nop
8010401e:	90                   	nop
8010401f:	90                   	nop

80104020 <exit>:
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	57                   	push   %edi
80104024:	56                   	push   %esi
80104025:	53                   	push   %ebx
80104026:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104029:	e8 62 06 00 00       	call   80104690 <pushcli>
  c = mycpu();
8010402e:	e8 0d fb ff ff       	call   80103b40 <mycpu>
  p = c->proc;
80104033:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104039:	e8 92 06 00 00       	call   801046d0 <popcli>
  if(curproc == initproc)
8010403e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80104044:	8d 5e 28             	lea    0x28(%esi),%ebx
80104047:	8d 7e 68             	lea    0x68(%esi),%edi
8010404a:	0f 84 e7 00 00 00    	je     80104137 <exit+0x117>
    if(curproc->ofile[fd]){
80104050:	8b 03                	mov    (%ebx),%eax
80104052:	85 c0                	test   %eax,%eax
80104054:	74 12                	je     80104068 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104056:	83 ec 0c             	sub    $0xc,%esp
80104059:	50                   	push   %eax
8010405a:	e8 e1 cd ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010405f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104065:	83 c4 10             	add    $0x10,%esp
80104068:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010406b:	39 fb                	cmp    %edi,%ebx
8010406d:	75 e1                	jne    80104050 <exit+0x30>
  begin_op();
8010406f:	e8 2c ef ff ff       	call   80102fa0 <begin_op>
  iput(curproc->cwd);
80104074:	83 ec 0c             	sub    $0xc,%esp
80104077:	ff 76 68             	pushl  0x68(%esi)
8010407a:	e8 71 d9 ff ff       	call   801019f0 <iput>
  end_op();
8010407f:	e8 8c ef ff ff       	call   80103010 <end_op>
  curproc->cwd = 0;
80104084:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010408b:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104092:	e8 c9 06 00 00       	call   80104760 <acquire>
  wakeup1(curproc->parent);
80104097:	8b 56 14             	mov    0x14(%esi),%edx
8010409a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010409d:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040a2:	eb 0e                	jmp    801040b2 <exit+0x92>
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040a8:	83 c0 7c             	add    $0x7c,%eax
801040ab:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801040b0:	73 1c                	jae    801040ce <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
801040b2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040b6:	75 f0                	jne    801040a8 <exit+0x88>
801040b8:	3b 50 20             	cmp    0x20(%eax),%edx
801040bb:	75 eb                	jne    801040a8 <exit+0x88>
      p->state = RUNNABLE;
801040bd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c4:	83 c0 7c             	add    $0x7c,%eax
801040c7:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801040cc:	72 e4                	jb     801040b2 <exit+0x92>
      p->parent = initproc;
801040ce:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040d4:	ba 74 2d 11 80       	mov    $0x80112d74,%edx
801040d9:	eb 10                	jmp    801040eb <exit+0xcb>
801040db:	90                   	nop
801040dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e0:	83 c2 7c             	add    $0x7c,%edx
801040e3:	81 fa 74 4c 11 80    	cmp    $0x80114c74,%edx
801040e9:	73 33                	jae    8010411e <exit+0xfe>
    if(p->parent == curproc){
801040eb:	39 72 14             	cmp    %esi,0x14(%edx)
801040ee:	75 f0                	jne    801040e0 <exit+0xc0>
      if(p->state == ZOMBIE)
801040f0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801040f4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040f7:	75 e7                	jne    801040e0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040f9:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801040fe:	eb 0a                	jmp    8010410a <exit+0xea>
80104100:	83 c0 7c             	add    $0x7c,%eax
80104103:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104108:	73 d6                	jae    801040e0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
8010410a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010410e:	75 f0                	jne    80104100 <exit+0xe0>
80104110:	3b 48 20             	cmp    0x20(%eax),%ecx
80104113:	75 eb                	jne    80104100 <exit+0xe0>
      p->state = RUNNABLE;
80104115:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010411c:	eb e2                	jmp    80104100 <exit+0xe0>
  curproc->state = ZOMBIE;
8010411e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104125:	e8 36 fe ff ff       	call   80103f60 <sched>
  panic("zombie exit");
8010412a:	83 ec 0c             	sub    $0xc,%esp
8010412d:	68 44 7b 10 80       	push   $0x80107b44
80104132:	e8 59 c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104137:	83 ec 0c             	sub    $0xc,%esp
8010413a:	68 37 7b 10 80       	push   $0x80107b37
8010413f:	e8 4c c2 ff ff       	call   80100390 <panic>
80104144:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010414a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104150 <yield>:
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	53                   	push   %ebx
80104154:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104157:	68 40 2d 11 80       	push   $0x80112d40
8010415c:	e8 ff 05 00 00       	call   80104760 <acquire>
  pushcli();
80104161:	e8 2a 05 00 00       	call   80104690 <pushcli>
  c = mycpu();
80104166:	e8 d5 f9 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
8010416b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104171:	e8 5a 05 00 00       	call   801046d0 <popcli>
  myproc()->state = RUNNABLE;
80104176:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010417d:	e8 de fd ff ff       	call   80103f60 <sched>
  release(&ptable.lock);
80104182:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
80104189:	e8 92 06 00 00       	call   80104820 <release>
}
8010418e:	83 c4 10             	add    $0x10,%esp
80104191:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104194:	c9                   	leave  
80104195:	c3                   	ret    
80104196:	8d 76 00             	lea    0x0(%esi),%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <sleep>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041af:	e8 dc 04 00 00       	call   80104690 <pushcli>
  c = mycpu();
801041b4:	e8 87 f9 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
801041b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041bf:	e8 0c 05 00 00       	call   801046d0 <popcli>
  if(p == 0)
801041c4:	85 db                	test   %ebx,%ebx
801041c6:	0f 84 87 00 00 00    	je     80104253 <sleep+0xb3>
  if(lk == 0)
801041cc:	85 f6                	test   %esi,%esi
801041ce:	74 76                	je     80104246 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041d0:	81 fe 40 2d 11 80    	cmp    $0x80112d40,%esi
801041d6:	74 50                	je     80104228 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 40 2d 11 80       	push   $0x80112d40
801041e0:	e8 7b 05 00 00       	call   80104760 <acquire>
    release(lk);
801041e5:	89 34 24             	mov    %esi,(%esp)
801041e8:	e8 33 06 00 00       	call   80104820 <release>
  p->chan = chan;
801041ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f7:	e8 64 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
801041fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104203:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
8010420a:	e8 11 06 00 00       	call   80104820 <release>
    acquire(lk);
8010420f:	89 75 08             	mov    %esi,0x8(%ebp)
80104212:	83 c4 10             	add    $0x10,%esp
}
80104215:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104218:	5b                   	pop    %ebx
80104219:	5e                   	pop    %esi
8010421a:	5f                   	pop    %edi
8010421b:	5d                   	pop    %ebp
    acquire(lk);
8010421c:	e9 3f 05 00 00       	jmp    80104760 <acquire>
80104221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104228:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010422b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104232:	e8 29 fd ff ff       	call   80103f60 <sched>
  p->chan = 0;
80104237:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010423e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104241:	5b                   	pop    %ebx
80104242:	5e                   	pop    %esi
80104243:	5f                   	pop    %edi
80104244:	5d                   	pop    %ebp
80104245:	c3                   	ret    
    panic("sleep without lk");
80104246:	83 ec 0c             	sub    $0xc,%esp
80104249:	68 56 7b 10 80       	push   $0x80107b56
8010424e:	e8 3d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104253:	83 ec 0c             	sub    $0xc,%esp
80104256:	68 50 7b 10 80       	push   $0x80107b50
8010425b:	e8 30 c1 ff ff       	call   80100390 <panic>

80104260 <wait>:
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
  pushcli();
80104265:	e8 26 04 00 00       	call   80104690 <pushcli>
  c = mycpu();
8010426a:	e8 d1 f8 ff ff       	call   80103b40 <mycpu>
  p = c->proc;
8010426f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104275:	e8 56 04 00 00       	call   801046d0 <popcli>
  acquire(&ptable.lock);
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	68 40 2d 11 80       	push   $0x80112d40
80104282:	e8 d9 04 00 00       	call   80104760 <acquire>
80104287:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010428a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010428c:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
80104291:	eb 10                	jmp    801042a3 <wait+0x43>
80104293:	90                   	nop
80104294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104298:	83 c3 7c             	add    $0x7c,%ebx
8010429b:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
801042a1:	73 1b                	jae    801042be <wait+0x5e>
      if(p->parent != curproc)
801042a3:	39 73 14             	cmp    %esi,0x14(%ebx)
801042a6:	75 f0                	jne    80104298 <wait+0x38>
      if(p->state == ZOMBIE){
801042a8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042ac:	74 32                	je     801042e0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042ae:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
801042b1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b6:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
801042bc:	72 e5                	jb     801042a3 <wait+0x43>
    if(!havekids || curproc->killed){
801042be:	85 c0                	test   %eax,%eax
801042c0:	74 74                	je     80104336 <wait+0xd6>
801042c2:	8b 46 24             	mov    0x24(%esi),%eax
801042c5:	85 c0                	test   %eax,%eax
801042c7:	75 6d                	jne    80104336 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801042c9:	83 ec 08             	sub    $0x8,%esp
801042cc:	68 40 2d 11 80       	push   $0x80112d40
801042d1:	56                   	push   %esi
801042d2:	e8 c9 fe ff ff       	call   801041a0 <sleep>
    havekids = 0;
801042d7:	83 c4 10             	add    $0x10,%esp
801042da:	eb ae                	jmp    8010428a <wait+0x2a>
801042dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801042e6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042e9:	e8 22 e4 ff ff       	call   80102710 <kfree>
        freevm(p->pgdir);
801042ee:	5a                   	pop    %edx
801042ef:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801042f2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042f9:	e8 72 2d 00 00       	call   80107070 <freevm>
        release(&ptable.lock);
801042fe:	c7 04 24 40 2d 11 80 	movl   $0x80112d40,(%esp)
        p->pid = 0;
80104305:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010430c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104313:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104317:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010431e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104325:	e8 f6 04 00 00       	call   80104820 <release>
        return pid;
8010432a:	83 c4 10             	add    $0x10,%esp
}
8010432d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104330:	89 f0                	mov    %esi,%eax
80104332:	5b                   	pop    %ebx
80104333:	5e                   	pop    %esi
80104334:	5d                   	pop    %ebp
80104335:	c3                   	ret    
      release(&ptable.lock);
80104336:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104339:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010433e:	68 40 2d 11 80       	push   $0x80112d40
80104343:	e8 d8 04 00 00       	call   80104820 <release>
      return -1;
80104348:	83 c4 10             	add    $0x10,%esp
8010434b:	eb e0                	jmp    8010432d <wait+0xcd>
8010434d:	8d 76 00             	lea    0x0(%esi),%esi

80104350 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
80104357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010435a:	68 40 2d 11 80       	push   $0x80112d40
8010435f:	e8 fc 03 00 00       	call   80104760 <acquire>
80104364:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104367:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
8010436c:	eb 0c                	jmp    8010437a <wakeup+0x2a>
8010436e:	66 90                	xchg   %ax,%ax
80104370:	83 c0 7c             	add    $0x7c,%eax
80104373:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104378:	73 1c                	jae    80104396 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010437a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010437e:	75 f0                	jne    80104370 <wakeup+0x20>
80104380:	3b 58 20             	cmp    0x20(%eax),%ebx
80104383:	75 eb                	jne    80104370 <wakeup+0x20>
      p->state = RUNNABLE;
80104385:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010438c:	83 c0 7c             	add    $0x7c,%eax
8010438f:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
80104394:	72 e4                	jb     8010437a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104396:	c7 45 08 40 2d 11 80 	movl   $0x80112d40,0x8(%ebp)
}
8010439d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043a0:	c9                   	leave  
  release(&ptable.lock);
801043a1:	e9 7a 04 00 00       	jmp    80104820 <release>
801043a6:	8d 76 00             	lea    0x0(%esi),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 10             	sub    $0x10,%esp
801043b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801043ba:	68 40 2d 11 80       	push   $0x80112d40
801043bf:	e8 9c 03 00 00       	call   80104760 <acquire>
801043c4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043c7:	b8 74 2d 11 80       	mov    $0x80112d74,%eax
801043cc:	eb 0c                	jmp    801043da <kill+0x2a>
801043ce:	66 90                	xchg   %ax,%ax
801043d0:	83 c0 7c             	add    $0x7c,%eax
801043d3:	3d 74 4c 11 80       	cmp    $0x80114c74,%eax
801043d8:	73 36                	jae    80104410 <kill+0x60>
    if(p->pid == pid){
801043da:	39 58 10             	cmp    %ebx,0x10(%eax)
801043dd:	75 f1                	jne    801043d0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043df:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043e3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043ea:	75 07                	jne    801043f3 <kill+0x43>
        p->state = RUNNABLE;
801043ec:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043f3:	83 ec 0c             	sub    $0xc,%esp
801043f6:	68 40 2d 11 80       	push   $0x80112d40
801043fb:	e8 20 04 00 00       	call   80104820 <release>
      return 0;
80104400:	83 c4 10             	add    $0x10,%esp
80104403:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104405:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104408:	c9                   	leave  
80104409:	c3                   	ret    
8010440a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 40 2d 11 80       	push   $0x80112d40
80104418:	e8 03 04 00 00       	call   80104820 <release>
  return -1;
8010441d:	83 c4 10             	add    $0x10,%esp
80104420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104425:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104428:	c9                   	leave  
80104429:	c3                   	ret    
8010442a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104430 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	53                   	push   %ebx
80104436:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104439:	bb 74 2d 11 80       	mov    $0x80112d74,%ebx
{
8010443e:	83 ec 3c             	sub    $0x3c,%esp
80104441:	eb 24                	jmp    80104467 <procdump+0x37>
80104443:	90                   	nop
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104448:	83 ec 0c             	sub    $0xc,%esp
8010444b:	68 df 7e 10 80       	push   $0x80107edf
80104450:	e8 0b c2 ff ff       	call   80100660 <cprintf>
80104455:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104458:	83 c3 7c             	add    $0x7c,%ebx
8010445b:	81 fb 74 4c 11 80    	cmp    $0x80114c74,%ebx
80104461:	0f 83 81 00 00 00    	jae    801044e8 <procdump+0xb8>
    if(p->state == UNUSED)
80104467:	8b 43 0c             	mov    0xc(%ebx),%eax
8010446a:	85 c0                	test   %eax,%eax
8010446c:	74 ea                	je     80104458 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010446e:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104471:	ba 67 7b 10 80       	mov    $0x80107b67,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104476:	77 11                	ja     80104489 <procdump+0x59>
80104478:	8b 14 85 c8 7b 10 80 	mov    -0x7fef8438(,%eax,4),%edx
      state = "???";
8010447f:	b8 67 7b 10 80       	mov    $0x80107b67,%eax
80104484:	85 d2                	test   %edx,%edx
80104486:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104489:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010448c:	50                   	push   %eax
8010448d:	52                   	push   %edx
8010448e:	ff 73 10             	pushl  0x10(%ebx)
80104491:	68 6b 7b 10 80       	push   $0x80107b6b
80104496:	e8 c5 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010449b:	83 c4 10             	add    $0x10,%esp
8010449e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044a2:	75 a4                	jne    80104448 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044a4:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044a7:	83 ec 08             	sub    $0x8,%esp
801044aa:	8d 7d c0             	lea    -0x40(%ebp),%edi
801044ad:	50                   	push   %eax
801044ae:	8b 43 1c             	mov    0x1c(%ebx),%eax
801044b1:	8b 40 0c             	mov    0xc(%eax),%eax
801044b4:	83 c0 08             	add    $0x8,%eax
801044b7:	50                   	push   %eax
801044b8:	e8 83 01 00 00       	call   80104640 <getcallerpcs>
801044bd:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801044c0:	8b 17                	mov    (%edi),%edx
801044c2:	85 d2                	test   %edx,%edx
801044c4:	74 82                	je     80104448 <procdump+0x18>
        cprintf(" %p", pc[i]);
801044c6:	83 ec 08             	sub    $0x8,%esp
801044c9:	83 c7 04             	add    $0x4,%edi
801044cc:	52                   	push   %edx
801044cd:	68 e1 73 10 80       	push   $0x801073e1
801044d2:	e8 89 c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044d7:	83 c4 10             	add    $0x10,%esp
801044da:	39 fe                	cmp    %edi,%esi
801044dc:	75 e2                	jne    801044c0 <procdump+0x90>
801044de:	e9 65 ff ff ff       	jmp    80104448 <procdump+0x18>
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
801044e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044eb:	5b                   	pop    %ebx
801044ec:	5e                   	pop    %esi
801044ed:	5f                   	pop    %edi
801044ee:	5d                   	pop    %ebp
801044ef:	c3                   	ret    

801044f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	53                   	push   %ebx
801044f4:	83 ec 0c             	sub    $0xc,%esp
801044f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801044fa:	68 e0 7b 10 80       	push   $0x80107be0
801044ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104502:	50                   	push   %eax
80104503:	e8 18 01 00 00       	call   80104620 <initlock>
  lk->name = name;
80104508:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010450b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104511:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104514:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010451b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010451e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104521:	c9                   	leave  
80104522:	c3                   	ret    
80104523:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104530 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	56                   	push   %esi
80104534:	53                   	push   %ebx
80104535:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104538:	83 ec 0c             	sub    $0xc,%esp
8010453b:	8d 73 04             	lea    0x4(%ebx),%esi
8010453e:	56                   	push   %esi
8010453f:	e8 1c 02 00 00       	call   80104760 <acquire>
  while (lk->locked) {
80104544:	8b 13                	mov    (%ebx),%edx
80104546:	83 c4 10             	add    $0x10,%esp
80104549:	85 d2                	test   %edx,%edx
8010454b:	74 16                	je     80104563 <acquiresleep+0x33>
8010454d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104550:	83 ec 08             	sub    $0x8,%esp
80104553:	56                   	push   %esi
80104554:	53                   	push   %ebx
80104555:	e8 46 fc ff ff       	call   801041a0 <sleep>
  while (lk->locked) {
8010455a:	8b 03                	mov    (%ebx),%eax
8010455c:	83 c4 10             	add    $0x10,%esp
8010455f:	85 c0                	test   %eax,%eax
80104561:	75 ed                	jne    80104550 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104563:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104569:	e8 72 f6 ff ff       	call   80103be0 <myproc>
8010456e:	8b 40 10             	mov    0x10(%eax),%eax
80104571:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104574:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104577:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010457a:	5b                   	pop    %ebx
8010457b:	5e                   	pop    %esi
8010457c:	5d                   	pop    %ebp
  release(&lk->lk);
8010457d:	e9 9e 02 00 00       	jmp    80104820 <release>
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	8d 73 04             	lea    0x4(%ebx),%esi
8010459e:	56                   	push   %esi
8010459f:	e8 bc 01 00 00       	call   80104760 <acquire>
  lk->locked = 0;
801045a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801045aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801045b1:	89 1c 24             	mov    %ebx,(%esp)
801045b4:	e8 97 fd ff ff       	call   80104350 <wakeup>
  release(&lk->lk);
801045b9:	89 75 08             	mov    %esi,0x8(%ebp)
801045bc:	83 c4 10             	add    $0x10,%esp
}
801045bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045c2:	5b                   	pop    %ebx
801045c3:	5e                   	pop    %esi
801045c4:	5d                   	pop    %ebp
  release(&lk->lk);
801045c5:	e9 56 02 00 00       	jmp    80104820 <release>
801045ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	31 ff                	xor    %edi,%edi
801045d8:	83 ec 18             	sub    $0x18,%esp
801045db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801045de:	8d 73 04             	lea    0x4(%ebx),%esi
801045e1:	56                   	push   %esi
801045e2:	e8 79 01 00 00       	call   80104760 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801045e7:	8b 03                	mov    (%ebx),%eax
801045e9:	83 c4 10             	add    $0x10,%esp
801045ec:	85 c0                	test   %eax,%eax
801045ee:	74 13                	je     80104603 <holdingsleep+0x33>
801045f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045f3:	e8 e8 f5 ff ff       	call   80103be0 <myproc>
801045f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801045fb:	0f 94 c0             	sete   %al
801045fe:	0f b6 c0             	movzbl %al,%eax
80104601:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104603:	83 ec 0c             	sub    $0xc,%esp
80104606:	56                   	push   %esi
80104607:	e8 14 02 00 00       	call   80104820 <release>
  return r;
}
8010460c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010460f:	89 f8                	mov    %edi,%eax
80104611:	5b                   	pop    %ebx
80104612:	5e                   	pop    %esi
80104613:	5f                   	pop    %edi
80104614:	5d                   	pop    %ebp
80104615:	c3                   	ret    
80104616:	66 90                	xchg   %ax,%ax
80104618:	66 90                	xchg   %ax,%ax
8010461a:	66 90                	xchg   %ax,%ax
8010461c:	66 90                	xchg   %ax,%ax
8010461e:	66 90                	xchg   %ax,%ax

80104620 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104626:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010462f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104632:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    
8010463b:	90                   	nop
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104640:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104641:	31 d2                	xor    %edx,%edx
{
80104643:	89 e5                	mov    %esp,%ebp
80104645:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104646:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104649:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010464c:	83 e8 08             	sub    $0x8,%eax
8010464f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104650:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104656:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010465c:	77 1a                	ja     80104678 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010465e:	8b 58 04             	mov    0x4(%eax),%ebx
80104661:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104664:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104667:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104669:	83 fa 0a             	cmp    $0xa,%edx
8010466c:	75 e2                	jne    80104650 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010466e:	5b                   	pop    %ebx
8010466f:	5d                   	pop    %ebp
80104670:	c3                   	ret    
80104671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104678:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010467b:	83 c1 28             	add    $0x28,%ecx
8010467e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104680:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104686:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104689:	39 c1                	cmp    %eax,%ecx
8010468b:	75 f3                	jne    80104680 <getcallerpcs+0x40>
}
8010468d:	5b                   	pop    %ebx
8010468e:	5d                   	pop    %ebp
8010468f:	c3                   	ret    

80104690 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104690:	55                   	push   %ebp
80104691:	89 e5                	mov    %esp,%ebp
80104693:	53                   	push   %ebx
80104694:	83 ec 04             	sub    $0x4,%esp
80104697:	9c                   	pushf  
80104698:	5b                   	pop    %ebx
  asm volatile("cli");
80104699:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010469a:	e8 a1 f4 ff ff       	call   80103b40 <mycpu>
8010469f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801046a5:	85 c0                	test   %eax,%eax
801046a7:	75 11                	jne    801046ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801046a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801046af:	e8 8c f4 ff ff       	call   80103b40 <mycpu>
801046b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801046ba:	e8 81 f4 ff ff       	call   80103b40 <mycpu>
801046bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801046c6:	83 c4 04             	add    $0x4,%esp
801046c9:	5b                   	pop    %ebx
801046ca:	5d                   	pop    %ebp
801046cb:	c3                   	ret    
801046cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046d0 <popcli>:

void
popcli(void)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801046d6:	9c                   	pushf  
801046d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801046d8:	f6 c4 02             	test   $0x2,%ah
801046db:	75 35                	jne    80104712 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046dd:	e8 5e f4 ff ff       	call   80103b40 <mycpu>
801046e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046e9:	78 34                	js     8010471f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046eb:	e8 50 f4 ff ff       	call   80103b40 <mycpu>
801046f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046f6:	85 d2                	test   %edx,%edx
801046f8:	74 06                	je     80104700 <popcli+0x30>
    sti();
}
801046fa:	c9                   	leave  
801046fb:	c3                   	ret    
801046fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104700:	e8 3b f4 ff ff       	call   80103b40 <mycpu>
80104705:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010470b:	85 c0                	test   %eax,%eax
8010470d:	74 eb                	je     801046fa <popcli+0x2a>
  asm volatile("sti");
8010470f:	fb                   	sti    
}
80104710:	c9                   	leave  
80104711:	c3                   	ret    
    panic("popcli - interruptible");
80104712:	83 ec 0c             	sub    $0xc,%esp
80104715:	68 eb 7b 10 80       	push   $0x80107beb
8010471a:	e8 71 bc ff ff       	call   80100390 <panic>
    panic("popcli");
8010471f:	83 ec 0c             	sub    $0xc,%esp
80104722:	68 02 7c 10 80       	push   $0x80107c02
80104727:	e8 64 bc ff ff       	call   80100390 <panic>
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104730 <holding>:
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 75 08             	mov    0x8(%ebp),%esi
80104738:	31 db                	xor    %ebx,%ebx
  pushcli();
8010473a:	e8 51 ff ff ff       	call   80104690 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010473f:	8b 06                	mov    (%esi),%eax
80104741:	85 c0                	test   %eax,%eax
80104743:	74 10                	je     80104755 <holding+0x25>
80104745:	8b 5e 08             	mov    0x8(%esi),%ebx
80104748:	e8 f3 f3 ff ff       	call   80103b40 <mycpu>
8010474d:	39 c3                	cmp    %eax,%ebx
8010474f:	0f 94 c3             	sete   %bl
80104752:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104755:	e8 76 ff ff ff       	call   801046d0 <popcli>
}
8010475a:	89 d8                	mov    %ebx,%eax
8010475c:	5b                   	pop    %ebx
8010475d:	5e                   	pop    %esi
8010475e:	5d                   	pop    %ebp
8010475f:	c3                   	ret    

80104760 <acquire>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104765:	e8 26 ff ff ff       	call   80104690 <pushcli>
  if(holding(lk))
8010476a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010476d:	83 ec 0c             	sub    $0xc,%esp
80104770:	53                   	push   %ebx
80104771:	e8 ba ff ff ff       	call   80104730 <holding>
80104776:	83 c4 10             	add    $0x10,%esp
80104779:	85 c0                	test   %eax,%eax
8010477b:	0f 85 83 00 00 00    	jne    80104804 <acquire+0xa4>
80104781:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104783:	ba 01 00 00 00       	mov    $0x1,%edx
80104788:	eb 09                	jmp    80104793 <acquire+0x33>
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104790:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104793:	89 d0                	mov    %edx,%eax
80104795:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104798:	85 c0                	test   %eax,%eax
8010479a:	75 f4                	jne    80104790 <acquire+0x30>
  __sync_synchronize();
8010479c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047a4:	e8 97 f3 ff ff       	call   80103b40 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047a9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801047ac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801047af:	89 e8                	mov    %ebp,%eax
801047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047b8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801047be:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801047c4:	77 1a                	ja     801047e0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801047c6:	8b 48 04             	mov    0x4(%eax),%ecx
801047c9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801047cc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801047cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047d1:	83 fe 0a             	cmp    $0xa,%esi
801047d4:	75 e2                	jne    801047b8 <acquire+0x58>
}
801047d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047d9:	5b                   	pop    %ebx
801047da:	5e                   	pop    %esi
801047db:	5d                   	pop    %ebp
801047dc:	c3                   	ret    
801047dd:	8d 76 00             	lea    0x0(%esi),%esi
801047e0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801047e3:	83 c2 28             	add    $0x28,%edx
801047e6:	8d 76 00             	lea    0x0(%esi),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801047f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801047f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801047f9:	39 d0                	cmp    %edx,%eax
801047fb:	75 f3                	jne    801047f0 <acquire+0x90>
}
801047fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104800:	5b                   	pop    %ebx
80104801:	5e                   	pop    %esi
80104802:	5d                   	pop    %ebp
80104803:	c3                   	ret    
    panic("acquire");
80104804:	83 ec 0c             	sub    $0xc,%esp
80104807:	68 09 7c 10 80       	push   $0x80107c09
8010480c:	e8 7f bb ff ff       	call   80100390 <panic>
80104811:	eb 0d                	jmp    80104820 <release>
80104813:	90                   	nop
80104814:	90                   	nop
80104815:	90                   	nop
80104816:	90                   	nop
80104817:	90                   	nop
80104818:	90                   	nop
80104819:	90                   	nop
8010481a:	90                   	nop
8010481b:	90                   	nop
8010481c:	90                   	nop
8010481d:	90                   	nop
8010481e:	90                   	nop
8010481f:	90                   	nop

80104820 <release>:
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 10             	sub    $0x10,%esp
80104827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010482a:	53                   	push   %ebx
8010482b:	e8 00 ff ff ff       	call   80104730 <holding>
80104830:	83 c4 10             	add    $0x10,%esp
80104833:	85 c0                	test   %eax,%eax
80104835:	74 22                	je     80104859 <release+0x39>
  lk->pcs[0] = 0;
80104837:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010483e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104845:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010484a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104850:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104853:	c9                   	leave  
  popcli();
80104854:	e9 77 fe ff ff       	jmp    801046d0 <popcli>
    panic("release");
80104859:	83 ec 0c             	sub    $0xc,%esp
8010485c:	68 11 7c 10 80       	push   $0x80107c11
80104861:	e8 2a bb ff ff       	call   80100390 <panic>
80104866:	66 90                	xchg   %ax,%ax
80104868:	66 90                	xchg   %ax,%ax
8010486a:	66 90                	xchg   %ax,%ax
8010486c:	66 90                	xchg   %ax,%ax
8010486e:	66 90                	xchg   %ax,%ax

80104870 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	53                   	push   %ebx
80104875:	8b 55 08             	mov    0x8(%ebp),%edx
80104878:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010487b:	f6 c2 03             	test   $0x3,%dl
8010487e:	75 05                	jne    80104885 <memset+0x15>
80104880:	f6 c1 03             	test   $0x3,%cl
80104883:	74 13                	je     80104898 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104885:	89 d7                	mov    %edx,%edi
80104887:	8b 45 0c             	mov    0xc(%ebp),%eax
8010488a:	fc                   	cld    
8010488b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010488d:	5b                   	pop    %ebx
8010488e:	89 d0                	mov    %edx,%eax
80104890:	5f                   	pop    %edi
80104891:	5d                   	pop    %ebp
80104892:	c3                   	ret    
80104893:	90                   	nop
80104894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104898:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010489c:	c1 e9 02             	shr    $0x2,%ecx
8010489f:	89 f8                	mov    %edi,%eax
801048a1:	89 fb                	mov    %edi,%ebx
801048a3:	c1 e0 18             	shl    $0x18,%eax
801048a6:	c1 e3 10             	shl    $0x10,%ebx
801048a9:	09 d8                	or     %ebx,%eax
801048ab:	09 f8                	or     %edi,%eax
801048ad:	c1 e7 08             	shl    $0x8,%edi
801048b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801048b2:	89 d7                	mov    %edx,%edi
801048b4:	fc                   	cld    
801048b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801048b7:	5b                   	pop    %ebx
801048b8:	89 d0                	mov    %edx,%eax
801048ba:	5f                   	pop    %edi
801048bb:	5d                   	pop    %ebp
801048bc:	c3                   	ret    
801048bd:	8d 76 00             	lea    0x0(%esi),%esi

801048c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	56                   	push   %esi
801048c5:	53                   	push   %ebx
801048c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801048c9:	8b 75 08             	mov    0x8(%ebp),%esi
801048cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048cf:	85 db                	test   %ebx,%ebx
801048d1:	74 29                	je     801048fc <memcmp+0x3c>
    if(*s1 != *s2)
801048d3:	0f b6 16             	movzbl (%esi),%edx
801048d6:	0f b6 0f             	movzbl (%edi),%ecx
801048d9:	38 d1                	cmp    %dl,%cl
801048db:	75 2b                	jne    80104908 <memcmp+0x48>
801048dd:	b8 01 00 00 00       	mov    $0x1,%eax
801048e2:	eb 14                	jmp    801048f8 <memcmp+0x38>
801048e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048e8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
801048ec:	83 c0 01             	add    $0x1,%eax
801048ef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
801048f4:	38 ca                	cmp    %cl,%dl
801048f6:	75 10                	jne    80104908 <memcmp+0x48>
  while(n-- > 0){
801048f8:	39 d8                	cmp    %ebx,%eax
801048fa:	75 ec                	jne    801048e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801048fc:	5b                   	pop    %ebx
  return 0;
801048fd:	31 c0                	xor    %eax,%eax
}
801048ff:	5e                   	pop    %esi
80104900:	5f                   	pop    %edi
80104901:	5d                   	pop    %ebp
80104902:	c3                   	ret    
80104903:	90                   	nop
80104904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104908:	0f b6 c2             	movzbl %dl,%eax
}
8010490b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010490c:	29 c8                	sub    %ecx,%eax
}
8010490e:	5e                   	pop    %esi
8010490f:	5f                   	pop    %edi
80104910:	5d                   	pop    %ebp
80104911:	c3                   	ret    
80104912:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104920 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
80104925:	8b 45 08             	mov    0x8(%ebp),%eax
80104928:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010492b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010492e:	39 c3                	cmp    %eax,%ebx
80104930:	73 26                	jae    80104958 <memmove+0x38>
80104932:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104935:	39 c8                	cmp    %ecx,%eax
80104937:	73 1f                	jae    80104958 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104939:	85 f6                	test   %esi,%esi
8010493b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010493e:	74 0f                	je     8010494f <memmove+0x2f>
      *--d = *--s;
80104940:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104944:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104947:	83 ea 01             	sub    $0x1,%edx
8010494a:	83 fa ff             	cmp    $0xffffffff,%edx
8010494d:	75 f1                	jne    80104940 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010494f:	5b                   	pop    %ebx
80104950:	5e                   	pop    %esi
80104951:	5d                   	pop    %ebp
80104952:	c3                   	ret    
80104953:	90                   	nop
80104954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104958:	31 d2                	xor    %edx,%edx
8010495a:	85 f6                	test   %esi,%esi
8010495c:	74 f1                	je     8010494f <memmove+0x2f>
8010495e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104960:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104964:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104967:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010496a:	39 d6                	cmp    %edx,%esi
8010496c:	75 f2                	jne    80104960 <memmove+0x40>
}
8010496e:	5b                   	pop    %ebx
8010496f:	5e                   	pop    %esi
80104970:	5d                   	pop    %ebp
80104971:	c3                   	ret    
80104972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104983:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104984:	eb 9a                	jmp    80104920 <memmove>
80104986:	8d 76 00             	lea    0x0(%esi),%esi
80104989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104990 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	57                   	push   %edi
80104994:	56                   	push   %esi
80104995:	8b 7d 10             	mov    0x10(%ebp),%edi
80104998:	53                   	push   %ebx
80104999:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010499c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010499f:	85 ff                	test   %edi,%edi
801049a1:	74 2f                	je     801049d2 <strncmp+0x42>
801049a3:	0f b6 01             	movzbl (%ecx),%eax
801049a6:	0f b6 1e             	movzbl (%esi),%ebx
801049a9:	84 c0                	test   %al,%al
801049ab:	74 37                	je     801049e4 <strncmp+0x54>
801049ad:	38 c3                	cmp    %al,%bl
801049af:	75 33                	jne    801049e4 <strncmp+0x54>
801049b1:	01 f7                	add    %esi,%edi
801049b3:	eb 13                	jmp    801049c8 <strncmp+0x38>
801049b5:	8d 76 00             	lea    0x0(%esi),%esi
801049b8:	0f b6 01             	movzbl (%ecx),%eax
801049bb:	84 c0                	test   %al,%al
801049bd:	74 21                	je     801049e0 <strncmp+0x50>
801049bf:	0f b6 1a             	movzbl (%edx),%ebx
801049c2:	89 d6                	mov    %edx,%esi
801049c4:	38 d8                	cmp    %bl,%al
801049c6:	75 1c                	jne    801049e4 <strncmp+0x54>
    n--, p++, q++;
801049c8:	8d 56 01             	lea    0x1(%esi),%edx
801049cb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049ce:	39 fa                	cmp    %edi,%edx
801049d0:	75 e6                	jne    801049b8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801049d2:	5b                   	pop    %ebx
    return 0;
801049d3:	31 c0                	xor    %eax,%eax
}
801049d5:	5e                   	pop    %esi
801049d6:	5f                   	pop    %edi
801049d7:	5d                   	pop    %ebp
801049d8:	c3                   	ret    
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049e0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
801049e4:	29 d8                	sub    %ebx,%eax
}
801049e6:	5b                   	pop    %ebx
801049e7:	5e                   	pop    %esi
801049e8:	5f                   	pop    %edi
801049e9:	5d                   	pop    %ebp
801049ea:	c3                   	ret    
801049eb:	90                   	nop
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	56                   	push   %esi
801049f4:	53                   	push   %ebx
801049f5:	8b 45 08             	mov    0x8(%ebp),%eax
801049f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801049fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049fe:	89 c2                	mov    %eax,%edx
80104a00:	eb 19                	jmp    80104a1b <strncpy+0x2b>
80104a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a08:	83 c3 01             	add    $0x1,%ebx
80104a0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104a0f:	83 c2 01             	add    $0x1,%edx
80104a12:	84 c9                	test   %cl,%cl
80104a14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a17:	74 09                	je     80104a22 <strncpy+0x32>
80104a19:	89 f1                	mov    %esi,%ecx
80104a1b:	85 c9                	test   %ecx,%ecx
80104a1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104a20:	7f e6                	jg     80104a08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104a22:	31 c9                	xor    %ecx,%ecx
80104a24:	85 f6                	test   %esi,%esi
80104a26:	7e 17                	jle    80104a3f <strncpy+0x4f>
80104a28:	90                   	nop
80104a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104a34:	89 f3                	mov    %esi,%ebx
80104a36:	83 c1 01             	add    $0x1,%ecx
80104a39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104a3b:	85 db                	test   %ebx,%ebx
80104a3d:	7f f1                	jg     80104a30 <strncpy+0x40>
  return os;
}
80104a3f:	5b                   	pop    %ebx
80104a40:	5e                   	pop    %esi
80104a41:	5d                   	pop    %ebp
80104a42:	c3                   	ret    
80104a43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a58:	8b 45 08             	mov    0x8(%ebp),%eax
80104a5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104a5e:	85 c9                	test   %ecx,%ecx
80104a60:	7e 26                	jle    80104a88 <safestrcpy+0x38>
80104a62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104a66:	89 c1                	mov    %eax,%ecx
80104a68:	eb 17                	jmp    80104a81 <safestrcpy+0x31>
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a70:	83 c2 01             	add    $0x1,%edx
80104a73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104a77:	83 c1 01             	add    $0x1,%ecx
80104a7a:	84 db                	test   %bl,%bl
80104a7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104a7f:	74 04                	je     80104a85 <safestrcpy+0x35>
80104a81:	39 f2                	cmp    %esi,%edx
80104a83:	75 eb                	jne    80104a70 <safestrcpy+0x20>
    ;
  *s = 0;
80104a85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104a88:	5b                   	pop    %ebx
80104a89:	5e                   	pop    %esi
80104a8a:	5d                   	pop    %ebp
80104a8b:	c3                   	ret    
80104a8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a90 <strlen>:

int
strlen(const char *s)
{
80104a90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a91:	31 c0                	xor    %eax,%eax
{
80104a93:	89 e5                	mov    %esp,%ebp
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a98:	80 3a 00             	cmpb   $0x0,(%edx)
80104a9b:	74 0c                	je     80104aa9 <strlen+0x19>
80104a9d:	8d 76 00             	lea    0x0(%esi),%esi
80104aa0:	83 c0 01             	add    $0x1,%eax
80104aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104aa7:	75 f7                	jne    80104aa0 <strlen+0x10>
    ;
  return n;
}
80104aa9:	5d                   	pop    %ebp
80104aaa:	c3                   	ret    

80104aab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104aab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104aaf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104ab3:	55                   	push   %ebp
  pushl %ebx
80104ab4:	53                   	push   %ebx
  pushl %esi
80104ab5:	56                   	push   %esi
  pushl %edi
80104ab6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ab7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ab9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104abb:	5f                   	pop    %edi
  popl %esi
80104abc:	5e                   	pop    %esi
  popl %ebx
80104abd:	5b                   	pop    %ebx
  popl %ebp
80104abe:	5d                   	pop    %ebp
  ret
80104abf:	c3                   	ret    

80104ac0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	53                   	push   %ebx
80104ac4:	83 ec 04             	sub    $0x4,%esp
80104ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aca:	e8 11 f1 ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104acf:	8b 00                	mov    (%eax),%eax
80104ad1:	39 d8                	cmp    %ebx,%eax
80104ad3:	76 1b                	jbe    80104af0 <fetchint+0x30>
80104ad5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ad8:	39 d0                	cmp    %edx,%eax
80104ada:	72 14                	jb     80104af0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104adf:	8b 13                	mov    (%ebx),%edx
80104ae1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ae3:	31 c0                	xor    %eax,%eax
}
80104ae5:	83 c4 04             	add    $0x4,%esp
80104ae8:	5b                   	pop    %ebx
80104ae9:	5d                   	pop    %ebp
80104aea:	c3                   	ret    
80104aeb:	90                   	nop
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104af5:	eb ee                	jmp    80104ae5 <fetchint+0x25>
80104af7:	89 f6                	mov    %esi,%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	53                   	push   %ebx
80104b04:	83 ec 04             	sub    $0x4,%esp
80104b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b0a:	e8 d1 f0 ff ff       	call   80103be0 <myproc>

  if(addr >= curproc->sz)
80104b0f:	39 18                	cmp    %ebx,(%eax)
80104b11:	76 29                	jbe    80104b3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104b13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b16:	89 da                	mov    %ebx,%edx
80104b18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104b1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104b1c:	39 c3                	cmp    %eax,%ebx
80104b1e:	73 1c                	jae    80104b3c <fetchstr+0x3c>
    if(*s == 0)
80104b20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104b23:	75 10                	jne    80104b35 <fetchstr+0x35>
80104b25:	eb 39                	jmp    80104b60 <fetchstr+0x60>
80104b27:	89 f6                	mov    %esi,%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b30:	80 3a 00             	cmpb   $0x0,(%edx)
80104b33:	74 1b                	je     80104b50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104b35:	83 c2 01             	add    $0x1,%edx
80104b38:	39 d0                	cmp    %edx,%eax
80104b3a:	77 f4                	ja     80104b30 <fetchstr+0x30>
    return -1;
80104b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104b41:	83 c4 04             	add    $0x4,%esp
80104b44:	5b                   	pop    %ebx
80104b45:	5d                   	pop    %ebp
80104b46:	c3                   	ret    
80104b47:	89 f6                	mov    %esi,%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b50:	83 c4 04             	add    $0x4,%esp
80104b53:	89 d0                	mov    %edx,%eax
80104b55:	29 d8                	sub    %ebx,%eax
80104b57:	5b                   	pop    %ebx
80104b58:	5d                   	pop    %ebp
80104b59:	c3                   	ret    
80104b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104b60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104b62:	eb dd                	jmp    80104b41 <fetchstr+0x41>
80104b64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104b70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b75:	e8 66 f0 ff ff       	call   80103be0 <myproc>
80104b7a:	8b 40 18             	mov    0x18(%eax),%eax
80104b7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104b80:	8b 40 44             	mov    0x44(%eax),%eax
80104b83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b86:	e8 55 f0 ff ff       	call   80103be0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b90:	39 c6                	cmp    %eax,%esi
80104b92:	73 1c                	jae    80104bb0 <argint+0x40>
80104b94:	8d 53 08             	lea    0x8(%ebx),%edx
80104b97:	39 d0                	cmp    %edx,%eax
80104b99:	72 15                	jb     80104bb0 <argint+0x40>
  *ip = *(int*)(addr);
80104b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104ba1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ba3:	31 c0                	xor    %eax,%eax
}
80104ba5:	5b                   	pop    %ebx
80104ba6:	5e                   	pop    %esi
80104ba7:	5d                   	pop    %ebp
80104ba8:	c3                   	ret    
80104ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bb5:	eb ee                	jmp    80104ba5 <argint+0x35>
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	56                   	push   %esi
80104bc4:	53                   	push   %ebx
80104bc5:	83 ec 10             	sub    $0x10,%esp
80104bc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104bcb:	e8 10 f0 ff ff       	call   80103be0 <myproc>
80104bd0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104bd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bd5:	83 ec 08             	sub    $0x8,%esp
80104bd8:	50                   	push   %eax
80104bd9:	ff 75 08             	pushl  0x8(%ebp)
80104bdc:	e8 8f ff ff ff       	call   80104b70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104be1:	83 c4 10             	add    $0x10,%esp
80104be4:	85 c0                	test   %eax,%eax
80104be6:	78 28                	js     80104c10 <argptr+0x50>
80104be8:	85 db                	test   %ebx,%ebx
80104bea:	78 24                	js     80104c10 <argptr+0x50>
80104bec:	8b 16                	mov    (%esi),%edx
80104bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bf1:	39 c2                	cmp    %eax,%edx
80104bf3:	76 1b                	jbe    80104c10 <argptr+0x50>
80104bf5:	01 c3                	add    %eax,%ebx
80104bf7:	39 da                	cmp    %ebx,%edx
80104bf9:	72 15                	jb     80104c10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104bfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bfe:	89 02                	mov    %eax,(%edx)
  return 0;
80104c00:	31 c0                	xor    %eax,%eax
}
80104c02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c05:	5b                   	pop    %ebx
80104c06:	5e                   	pop    %esi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c15:	eb eb                	jmp    80104c02 <argptr+0x42>
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104c26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c29:	50                   	push   %eax
80104c2a:	ff 75 08             	pushl  0x8(%ebp)
80104c2d:	e8 3e ff ff ff       	call   80104b70 <argint>
80104c32:	83 c4 10             	add    $0x10,%esp
80104c35:	85 c0                	test   %eax,%eax
80104c37:	78 17                	js     80104c50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104c39:	83 ec 08             	sub    $0x8,%esp
80104c3c:	ff 75 0c             	pushl  0xc(%ebp)
80104c3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104c42:	e8 b9 fe ff ff       	call   80104b00 <fetchstr>
80104c47:	83 c4 10             	add    $0x10,%esp
}
80104c4a:	c9                   	leave  
80104c4b:	c3                   	ret    
80104c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <syscall>:
[SYS_swapwrite] sys_swapwrite,
};

void
syscall(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	53                   	push   %ebx
80104c64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c67:	e8 74 ef ff ff       	call   80103be0 <myproc>
80104c6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c6e:	8b 40 18             	mov    0x18(%eax),%eax
80104c71:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c77:	83 fa 16             	cmp    $0x16,%edx
80104c7a:	77 1c                	ja     80104c98 <syscall+0x38>
80104c7c:	8b 14 85 40 7c 10 80 	mov    -0x7fef83c0(,%eax,4),%edx
80104c83:	85 d2                	test   %edx,%edx
80104c85:	74 11                	je     80104c98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104c87:	ff d2                	call   *%edx
80104c89:	8b 53 18             	mov    0x18(%ebx),%edx
80104c8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c92:	c9                   	leave  
80104c93:	c3                   	ret    
80104c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c99:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c9c:	50                   	push   %eax
80104c9d:	ff 73 10             	pushl  0x10(%ebx)
80104ca0:	68 19 7c 10 80       	push   $0x80107c19
80104ca5:	e8 b6 b9 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104caa:	8b 43 18             	mov    0x18(%ebx),%eax
80104cad:	83 c4 10             	add    $0x10,%esp
80104cb0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104cb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cba:	c9                   	leave  
80104cbb:	c3                   	ret    
80104cbc:	66 90                	xchg   %ax,%ax
80104cbe:	66 90                	xchg   %ax,%ax

80104cc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104cc6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104cc9:	83 ec 44             	sub    $0x44,%esp
80104ccc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
80104ccf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104cd2:	56                   	push   %esi
80104cd3:	50                   	push   %eax
{
80104cd4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104cd7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cda:	e8 11 d5 ff ff       	call   801021f0 <nameiparent>
80104cdf:	83 c4 10             	add    $0x10,%esp
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	0f 84 46 01 00 00    	je     80104e30 <create+0x170>
    return 0;
  ilock(dp);
80104cea:	83 ec 0c             	sub    $0xc,%esp
80104ced:	89 c3                	mov    %eax,%ebx
80104cef:	50                   	push   %eax
80104cf0:	e8 bb cb ff ff       	call   801018b0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104cf5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104cf8:	83 c4 0c             	add    $0xc,%esp
80104cfb:	50                   	push   %eax
80104cfc:	56                   	push   %esi
80104cfd:	53                   	push   %ebx
80104cfe:	e8 9d d1 ff ff       	call   80101ea0 <dirlookup>
80104d03:	83 c4 10             	add    $0x10,%esp
80104d06:	85 c0                	test   %eax,%eax
80104d08:	89 c7                	mov    %eax,%edi
80104d0a:	74 34                	je     80104d40 <create+0x80>
    iunlockput(dp);
80104d0c:	83 ec 0c             	sub    $0xc,%esp
80104d0f:	53                   	push   %ebx
80104d10:	e8 eb ce ff ff       	call   80101c00 <iunlockput>
    ilock(ip);
80104d15:	89 3c 24             	mov    %edi,(%esp)
80104d18:	e8 93 cb ff ff       	call   801018b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104d25:	0f 85 95 00 00 00    	jne    80104dc0 <create+0x100>
80104d2b:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104d30:	0f 85 8a 00 00 00    	jne    80104dc0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d39:	89 f8                	mov    %edi,%eax
80104d3b:	5b                   	pop    %ebx
80104d3c:	5e                   	pop    %esi
80104d3d:	5f                   	pop    %edi
80104d3e:	5d                   	pop    %ebp
80104d3f:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
80104d40:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104d44:	83 ec 08             	sub    $0x8,%esp
80104d47:	50                   	push   %eax
80104d48:	ff 33                	pushl  (%ebx)
80104d4a:	e8 d1 c9 ff ff       	call   80101720 <ialloc>
80104d4f:	83 c4 10             	add    $0x10,%esp
80104d52:	85 c0                	test   %eax,%eax
80104d54:	89 c7                	mov    %eax,%edi
80104d56:	0f 84 e8 00 00 00    	je     80104e44 <create+0x184>
  ilock(ip);
80104d5c:	83 ec 0c             	sub    $0xc,%esp
80104d5f:	50                   	push   %eax
80104d60:	e8 4b cb ff ff       	call   801018b0 <ilock>
  ip->major = major;
80104d65:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104d69:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104d6d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104d71:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104d75:	b8 01 00 00 00       	mov    $0x1,%eax
80104d7a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104d7e:	89 3c 24             	mov    %edi,(%esp)
80104d81:	e8 6a ca ff ff       	call   801017f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d86:	83 c4 10             	add    $0x10,%esp
80104d89:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104d8e:	74 50                	je     80104de0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d90:	83 ec 04             	sub    $0x4,%esp
80104d93:	ff 77 04             	pushl  0x4(%edi)
80104d96:	56                   	push   %esi
80104d97:	53                   	push   %ebx
80104d98:	e8 73 d3 ff ff       	call   80102110 <dirlink>
80104d9d:	83 c4 10             	add    $0x10,%esp
80104da0:	85 c0                	test   %eax,%eax
80104da2:	0f 88 8f 00 00 00    	js     80104e37 <create+0x177>
  iunlockput(dp);
80104da8:	83 ec 0c             	sub    $0xc,%esp
80104dab:	53                   	push   %ebx
80104dac:	e8 4f ce ff ff       	call   80101c00 <iunlockput>
  return ip;
80104db1:	83 c4 10             	add    $0x10,%esp
}
80104db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104db7:	89 f8                	mov    %edi,%eax
80104db9:	5b                   	pop    %ebx
80104dba:	5e                   	pop    %esi
80104dbb:	5f                   	pop    %edi
80104dbc:	5d                   	pop    %ebp
80104dbd:	c3                   	ret    
80104dbe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104dc0:	83 ec 0c             	sub    $0xc,%esp
80104dc3:	57                   	push   %edi
    return 0;
80104dc4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104dc6:	e8 35 ce ff ff       	call   80101c00 <iunlockput>
    return 0;
80104dcb:	83 c4 10             	add    $0x10,%esp
}
80104dce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dd1:	89 f8                	mov    %edi,%eax
80104dd3:	5b                   	pop    %ebx
80104dd4:	5e                   	pop    %esi
80104dd5:	5f                   	pop    %edi
80104dd6:	5d                   	pop    %ebp
80104dd7:	c3                   	ret    
80104dd8:	90                   	nop
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104de0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104de5:	83 ec 0c             	sub    $0xc,%esp
80104de8:	53                   	push   %ebx
80104de9:	e8 02 ca ff ff       	call   801017f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dee:	83 c4 0c             	add    $0xc,%esp
80104df1:	ff 77 04             	pushl  0x4(%edi)
80104df4:	68 bc 7c 10 80       	push   $0x80107cbc
80104df9:	57                   	push   %edi
80104dfa:	e8 11 d3 ff ff       	call   80102110 <dirlink>
80104dff:	83 c4 10             	add    $0x10,%esp
80104e02:	85 c0                	test   %eax,%eax
80104e04:	78 1c                	js     80104e22 <create+0x162>
80104e06:	83 ec 04             	sub    $0x4,%esp
80104e09:	ff 73 04             	pushl  0x4(%ebx)
80104e0c:	68 bb 7c 10 80       	push   $0x80107cbb
80104e11:	57                   	push   %edi
80104e12:	e8 f9 d2 ff ff       	call   80102110 <dirlink>
80104e17:	83 c4 10             	add    $0x10,%esp
80104e1a:	85 c0                	test   %eax,%eax
80104e1c:	0f 89 6e ff ff ff    	jns    80104d90 <create+0xd0>
      panic("create dots");
80104e22:	83 ec 0c             	sub    $0xc,%esp
80104e25:	68 af 7c 10 80       	push   $0x80107caf
80104e2a:	e8 61 b5 ff ff       	call   80100390 <panic>
80104e2f:	90                   	nop
    return 0;
80104e30:	31 ff                	xor    %edi,%edi
80104e32:	e9 ff fe ff ff       	jmp    80104d36 <create+0x76>
    panic("create: dirlink");
80104e37:	83 ec 0c             	sub    $0xc,%esp
80104e3a:	68 be 7c 10 80       	push   $0x80107cbe
80104e3f:	e8 4c b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	68 a0 7c 10 80       	push   $0x80107ca0
80104e4c:	e8 3f b5 ff ff       	call   80100390 <panic>
80104e51:	eb 0d                	jmp    80104e60 <argfd.constprop.0>
80104e53:	90                   	nop
80104e54:	90                   	nop
80104e55:	90                   	nop
80104e56:	90                   	nop
80104e57:	90                   	nop
80104e58:	90                   	nop
80104e59:	90                   	nop
80104e5a:	90                   	nop
80104e5b:	90                   	nop
80104e5c:	90                   	nop
80104e5d:	90                   	nop
80104e5e:	90                   	nop
80104e5f:	90                   	nop

80104e60 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
80104e65:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104e67:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e6a:	89 d6                	mov    %edx,%esi
80104e6c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6f:	50                   	push   %eax
80104e70:	6a 00                	push   $0x0
80104e72:	e8 f9 fc ff ff       	call   80104b70 <argint>
80104e77:	83 c4 10             	add    $0x10,%esp
80104e7a:	85 c0                	test   %eax,%eax
80104e7c:	78 2a                	js     80104ea8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e82:	77 24                	ja     80104ea8 <argfd.constprop.0+0x48>
80104e84:	e8 57 ed ff ff       	call   80103be0 <myproc>
80104e89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e8c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104e90:	85 c0                	test   %eax,%eax
80104e92:	74 14                	je     80104ea8 <argfd.constprop.0+0x48>
  if(pfd)
80104e94:	85 db                	test   %ebx,%ebx
80104e96:	74 02                	je     80104e9a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104e98:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104e9a:	89 06                	mov    %eax,(%esi)
  return 0;
80104e9c:	31 c0                	xor    %eax,%eax
}
80104e9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ea1:	5b                   	pop    %ebx
80104ea2:	5e                   	pop    %esi
80104ea3:	5d                   	pop    %ebp
80104ea4:	c3                   	ret    
80104ea5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104ea8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ead:	eb ef                	jmp    80104e9e <argfd.constprop.0+0x3e>
80104eaf:	90                   	nop

80104eb0 <sys_dup>:
{
80104eb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104eb1:	31 c0                	xor    %eax,%eax
{
80104eb3:	89 e5                	mov    %esp,%ebp
80104eb5:	56                   	push   %esi
80104eb6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104eb7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104eba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104ebd:	e8 9e ff ff ff       	call   80104e60 <argfd.constprop.0>
80104ec2:	85 c0                	test   %eax,%eax
80104ec4:	78 42                	js     80104f08 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104ec6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ec9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104ecb:	e8 10 ed ff ff       	call   80103be0 <myproc>
80104ed0:	eb 0e                	jmp    80104ee0 <sys_dup+0x30>
80104ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104ed8:	83 c3 01             	add    $0x1,%ebx
80104edb:	83 fb 10             	cmp    $0x10,%ebx
80104ede:	74 28                	je     80104f08 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104ee0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ee4:	85 d2                	test   %edx,%edx
80104ee6:	75 f0                	jne    80104ed8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104ee8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104eec:	83 ec 0c             	sub    $0xc,%esp
80104eef:	ff 75 f4             	pushl  -0xc(%ebp)
80104ef2:	e8 f9 be ff ff       	call   80100df0 <filedup>
  return fd;
80104ef7:	83 c4 10             	add    $0x10,%esp
}
80104efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104efd:	89 d8                	mov    %ebx,%eax
80104eff:	5b                   	pop    %ebx
80104f00:	5e                   	pop    %esi
80104f01:	5d                   	pop    %ebp
80104f02:	c3                   	ret    
80104f03:	90                   	nop
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f08:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104f10:	89 d8                	mov    %ebx,%eax
80104f12:	5b                   	pop    %ebx
80104f13:	5e                   	pop    %esi
80104f14:	5d                   	pop    %ebp
80104f15:	c3                   	ret    
80104f16:	8d 76 00             	lea    0x0(%esi),%esi
80104f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f20 <sys_read>:
{
80104f20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f21:	31 c0                	xor    %eax,%eax
{
80104f23:	89 e5                	mov    %esp,%ebp
80104f25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f2b:	e8 30 ff ff ff       	call   80104e60 <argfd.constprop.0>
80104f30:	85 c0                	test   %eax,%eax
80104f32:	78 4c                	js     80104f80 <sys_read+0x60>
80104f34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f37:	83 ec 08             	sub    $0x8,%esp
80104f3a:	50                   	push   %eax
80104f3b:	6a 02                	push   $0x2
80104f3d:	e8 2e fc ff ff       	call   80104b70 <argint>
80104f42:	83 c4 10             	add    $0x10,%esp
80104f45:	85 c0                	test   %eax,%eax
80104f47:	78 37                	js     80104f80 <sys_read+0x60>
80104f49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f4c:	83 ec 04             	sub    $0x4,%esp
80104f4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104f52:	50                   	push   %eax
80104f53:	6a 01                	push   $0x1
80104f55:	e8 66 fc ff ff       	call   80104bc0 <argptr>
80104f5a:	83 c4 10             	add    $0x10,%esp
80104f5d:	85 c0                	test   %eax,%eax
80104f5f:	78 1f                	js     80104f80 <sys_read+0x60>
  return fileread(f, p, n);
80104f61:	83 ec 04             	sub    $0x4,%esp
80104f64:	ff 75 f0             	pushl  -0x10(%ebp)
80104f67:	ff 75 f4             	pushl  -0xc(%ebp)
80104f6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104f6d:	e8 ee bf ff ff       	call   80100f60 <fileread>
80104f72:	83 c4 10             	add    $0x10,%esp
}
80104f75:	c9                   	leave  
80104f76:	c3                   	ret    
80104f77:	89 f6                	mov    %esi,%esi
80104f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f85:	c9                   	leave  
80104f86:	c3                   	ret    
80104f87:	89 f6                	mov    %esi,%esi
80104f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f90 <sys_write>:
{
80104f90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f91:	31 c0                	xor    %eax,%eax
{
80104f93:	89 e5                	mov    %esp,%ebp
80104f95:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f98:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f9b:	e8 c0 fe ff ff       	call   80104e60 <argfd.constprop.0>
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	78 4c                	js     80104ff0 <sys_write+0x60>
80104fa4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fa7:	83 ec 08             	sub    $0x8,%esp
80104faa:	50                   	push   %eax
80104fab:	6a 02                	push   $0x2
80104fad:	e8 be fb ff ff       	call   80104b70 <argint>
80104fb2:	83 c4 10             	add    $0x10,%esp
80104fb5:	85 c0                	test   %eax,%eax
80104fb7:	78 37                	js     80104ff0 <sys_write+0x60>
80104fb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fbc:	83 ec 04             	sub    $0x4,%esp
80104fbf:	ff 75 f0             	pushl  -0x10(%ebp)
80104fc2:	50                   	push   %eax
80104fc3:	6a 01                	push   $0x1
80104fc5:	e8 f6 fb ff ff       	call   80104bc0 <argptr>
80104fca:	83 c4 10             	add    $0x10,%esp
80104fcd:	85 c0                	test   %eax,%eax
80104fcf:	78 1f                	js     80104ff0 <sys_write+0x60>
  return filewrite(f, p, n);
80104fd1:	83 ec 04             	sub    $0x4,%esp
80104fd4:	ff 75 f0             	pushl  -0x10(%ebp)
80104fd7:	ff 75 f4             	pushl  -0xc(%ebp)
80104fda:	ff 75 ec             	pushl  -0x14(%ebp)
80104fdd:	e8 0e c0 ff ff       	call   80100ff0 <filewrite>
80104fe2:	83 c4 10             	add    $0x10,%esp
}
80104fe5:	c9                   	leave  
80104fe6:	c3                   	ret    
80104fe7:	89 f6                	mov    %esi,%esi
80104fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ff5:	c9                   	leave  
80104ff6:	c3                   	ret    
80104ff7:	89 f6                	mov    %esi,%esi
80104ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105000 <sys_close>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105006:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105009:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010500c:	e8 4f fe ff ff       	call   80104e60 <argfd.constprop.0>
80105011:	85 c0                	test   %eax,%eax
80105013:	78 2b                	js     80105040 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105015:	e8 c6 eb ff ff       	call   80103be0 <myproc>
8010501a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010501d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105020:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80105027:	00 
  fileclose(f);
80105028:	ff 75 f4             	pushl  -0xc(%ebp)
8010502b:	e8 10 be ff ff       	call   80100e40 <fileclose>
  return 0;
80105030:	83 c4 10             	add    $0x10,%esp
80105033:	31 c0                	xor    %eax,%eax
}
80105035:	c9                   	leave  
80105036:	c3                   	ret    
80105037:	89 f6                	mov    %esi,%esi
80105039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105040:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105045:	c9                   	leave  
80105046:	c3                   	ret    
80105047:	89 f6                	mov    %esi,%esi
80105049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105050 <sys_fstat>:
{
80105050:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105051:	31 c0                	xor    %eax,%eax
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105058:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010505b:	e8 00 fe ff ff       	call   80104e60 <argfd.constprop.0>
80105060:	85 c0                	test   %eax,%eax
80105062:	78 2c                	js     80105090 <sys_fstat+0x40>
80105064:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105067:	83 ec 04             	sub    $0x4,%esp
8010506a:	6a 14                	push   $0x14
8010506c:	50                   	push   %eax
8010506d:	6a 01                	push   $0x1
8010506f:	e8 4c fb ff ff       	call   80104bc0 <argptr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	78 15                	js     80105090 <sys_fstat+0x40>
  return filestat(f, st);
8010507b:	83 ec 08             	sub    $0x8,%esp
8010507e:	ff 75 f4             	pushl  -0xc(%ebp)
80105081:	ff 75 f0             	pushl  -0x10(%ebp)
80105084:	e8 87 be ff ff       	call   80100f10 <filestat>
80105089:	83 c4 10             	add    $0x10,%esp
}
8010508c:	c9                   	leave  
8010508d:	c3                   	ret    
8010508e:	66 90                	xchg   %ax,%ax
    return -1;
80105090:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105095:	c9                   	leave  
80105096:	c3                   	ret    
80105097:	89 f6                	mov    %esi,%esi
80105099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050a0 <sys_link>:
{
801050a0:	55                   	push   %ebp
801050a1:	89 e5                	mov    %esp,%ebp
801050a3:	57                   	push   %edi
801050a4:	56                   	push   %esi
801050a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050ac:	50                   	push   %eax
801050ad:	6a 00                	push   $0x0
801050af:	e8 6c fb ff ff       	call   80104c20 <argstr>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	0f 88 fb 00 00 00    	js     801051ba <sys_link+0x11a>
801050bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050c2:	83 ec 08             	sub    $0x8,%esp
801050c5:	50                   	push   %eax
801050c6:	6a 01                	push   $0x1
801050c8:	e8 53 fb ff ff       	call   80104c20 <argstr>
801050cd:	83 c4 10             	add    $0x10,%esp
801050d0:	85 c0                	test   %eax,%eax
801050d2:	0f 88 e2 00 00 00    	js     801051ba <sys_link+0x11a>
  begin_op();
801050d8:	e8 c3 de ff ff       	call   80102fa0 <begin_op>
  if((ip = namei(old)) == 0){
801050dd:	83 ec 0c             	sub    $0xc,%esp
801050e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801050e3:	e8 e8 d0 ff ff       	call   801021d0 <namei>
801050e8:	83 c4 10             	add    $0x10,%esp
801050eb:	85 c0                	test   %eax,%eax
801050ed:	89 c3                	mov    %eax,%ebx
801050ef:	0f 84 ea 00 00 00    	je     801051df <sys_link+0x13f>
  ilock(ip);
801050f5:	83 ec 0c             	sub    $0xc,%esp
801050f8:	50                   	push   %eax
801050f9:	e8 b2 c7 ff ff       	call   801018b0 <ilock>
  if(ip->type == T_DIR){
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105106:	0f 84 bb 00 00 00    	je     801051c7 <sys_link+0x127>
  ip->nlink++;
8010510c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105111:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105114:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105117:	53                   	push   %ebx
80105118:	e8 d3 c6 ff ff       	call   801017f0 <iupdate>
  iunlock(ip);
8010511d:	89 1c 24             	mov    %ebx,(%esp)
80105120:	e8 7b c8 ff ff       	call   801019a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105125:	58                   	pop    %eax
80105126:	5a                   	pop    %edx
80105127:	57                   	push   %edi
80105128:	ff 75 d0             	pushl  -0x30(%ebp)
8010512b:	e8 c0 d0 ff ff       	call   801021f0 <nameiparent>
80105130:	83 c4 10             	add    $0x10,%esp
80105133:	85 c0                	test   %eax,%eax
80105135:	89 c6                	mov    %eax,%esi
80105137:	74 5b                	je     80105194 <sys_link+0xf4>
  ilock(dp);
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	50                   	push   %eax
8010513d:	e8 6e c7 ff ff       	call   801018b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	8b 03                	mov    (%ebx),%eax
80105147:	39 06                	cmp    %eax,(%esi)
80105149:	75 3d                	jne    80105188 <sys_link+0xe8>
8010514b:	83 ec 04             	sub    $0x4,%esp
8010514e:	ff 73 04             	pushl  0x4(%ebx)
80105151:	57                   	push   %edi
80105152:	56                   	push   %esi
80105153:	e8 b8 cf ff ff       	call   80102110 <dirlink>
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	85 c0                	test   %eax,%eax
8010515d:	78 29                	js     80105188 <sys_link+0xe8>
  iunlockput(dp);
8010515f:	83 ec 0c             	sub    $0xc,%esp
80105162:	56                   	push   %esi
80105163:	e8 98 ca ff ff       	call   80101c00 <iunlockput>
  iput(ip);
80105168:	89 1c 24             	mov    %ebx,(%esp)
8010516b:	e8 80 c8 ff ff       	call   801019f0 <iput>
  end_op();
80105170:	e8 9b de ff ff       	call   80103010 <end_op>
  return 0;
80105175:	83 c4 10             	add    $0x10,%esp
80105178:	31 c0                	xor    %eax,%eax
}
8010517a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010517d:	5b                   	pop    %ebx
8010517e:	5e                   	pop    %esi
8010517f:	5f                   	pop    %edi
80105180:	5d                   	pop    %ebp
80105181:	c3                   	ret    
80105182:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105188:	83 ec 0c             	sub    $0xc,%esp
8010518b:	56                   	push   %esi
8010518c:	e8 6f ca ff ff       	call   80101c00 <iunlockput>
    goto bad;
80105191:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105194:	83 ec 0c             	sub    $0xc,%esp
80105197:	53                   	push   %ebx
80105198:	e8 13 c7 ff ff       	call   801018b0 <ilock>
  ip->nlink--;
8010519d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051a2:	89 1c 24             	mov    %ebx,(%esp)
801051a5:	e8 46 c6 ff ff       	call   801017f0 <iupdate>
  iunlockput(ip);
801051aa:	89 1c 24             	mov    %ebx,(%esp)
801051ad:	e8 4e ca ff ff       	call   80101c00 <iunlockput>
  end_op();
801051b2:	e8 59 de ff ff       	call   80103010 <end_op>
  return -1;
801051b7:	83 c4 10             	add    $0x10,%esp
}
801051ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801051bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051c2:	5b                   	pop    %ebx
801051c3:	5e                   	pop    %esi
801051c4:	5f                   	pop    %edi
801051c5:	5d                   	pop    %ebp
801051c6:	c3                   	ret    
    iunlockput(ip);
801051c7:	83 ec 0c             	sub    $0xc,%esp
801051ca:	53                   	push   %ebx
801051cb:	e8 30 ca ff ff       	call   80101c00 <iunlockput>
    end_op();
801051d0:	e8 3b de ff ff       	call   80103010 <end_op>
    return -1;
801051d5:	83 c4 10             	add    $0x10,%esp
801051d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051dd:	eb 9b                	jmp    8010517a <sys_link+0xda>
    end_op();
801051df:	e8 2c de ff ff       	call   80103010 <end_op>
    return -1;
801051e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e9:	eb 8f                	jmp    8010517a <sys_link+0xda>
801051eb:	90                   	nop
801051ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051f0 <sys_unlink>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
801051f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801051f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801051fc:	50                   	push   %eax
801051fd:	6a 00                	push   $0x0
801051ff:	e8 1c fa ff ff       	call   80104c20 <argstr>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	0f 88 77 01 00 00    	js     80105386 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010520f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105212:	e8 89 dd ff ff       	call   80102fa0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105217:	83 ec 08             	sub    $0x8,%esp
8010521a:	53                   	push   %ebx
8010521b:	ff 75 c0             	pushl  -0x40(%ebp)
8010521e:	e8 cd cf ff ff       	call   801021f0 <nameiparent>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	89 c6                	mov    %eax,%esi
8010522a:	0f 84 60 01 00 00    	je     80105390 <sys_unlink+0x1a0>
  ilock(dp);
80105230:	83 ec 0c             	sub    $0xc,%esp
80105233:	50                   	push   %eax
80105234:	e8 77 c6 ff ff       	call   801018b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105239:	58                   	pop    %eax
8010523a:	5a                   	pop    %edx
8010523b:	68 bc 7c 10 80       	push   $0x80107cbc
80105240:	53                   	push   %ebx
80105241:	e8 3a cc ff ff       	call   80101e80 <namecmp>
80105246:	83 c4 10             	add    $0x10,%esp
80105249:	85 c0                	test   %eax,%eax
8010524b:	0f 84 03 01 00 00    	je     80105354 <sys_unlink+0x164>
80105251:	83 ec 08             	sub    $0x8,%esp
80105254:	68 bb 7c 10 80       	push   $0x80107cbb
80105259:	53                   	push   %ebx
8010525a:	e8 21 cc ff ff       	call   80101e80 <namecmp>
8010525f:	83 c4 10             	add    $0x10,%esp
80105262:	85 c0                	test   %eax,%eax
80105264:	0f 84 ea 00 00 00    	je     80105354 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010526a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010526d:	83 ec 04             	sub    $0x4,%esp
80105270:	50                   	push   %eax
80105271:	53                   	push   %ebx
80105272:	56                   	push   %esi
80105273:	e8 28 cc ff ff       	call   80101ea0 <dirlookup>
80105278:	83 c4 10             	add    $0x10,%esp
8010527b:	85 c0                	test   %eax,%eax
8010527d:	89 c3                	mov    %eax,%ebx
8010527f:	0f 84 cf 00 00 00    	je     80105354 <sys_unlink+0x164>
  ilock(ip);
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	50                   	push   %eax
80105289:	e8 22 c6 ff ff       	call   801018b0 <ilock>
  if(ip->nlink < 1)
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105296:	0f 8e 10 01 00 00    	jle    801053ac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010529c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052a1:	74 6d                	je     80105310 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052a6:	83 ec 04             	sub    $0x4,%esp
801052a9:	6a 10                	push   $0x10
801052ab:	6a 00                	push   $0x0
801052ad:	50                   	push   %eax
801052ae:	e8 bd f5 ff ff       	call   80104870 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801052b6:	6a 10                	push   $0x10
801052b8:	ff 75 c4             	pushl  -0x3c(%ebp)
801052bb:	50                   	push   %eax
801052bc:	56                   	push   %esi
801052bd:	e8 8e ca ff ff       	call   80101d50 <writei>
801052c2:	83 c4 20             	add    $0x20,%esp
801052c5:	83 f8 10             	cmp    $0x10,%eax
801052c8:	0f 85 eb 00 00 00    	jne    801053b9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801052ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052d3:	0f 84 97 00 00 00    	je     80105370 <sys_unlink+0x180>
  iunlockput(dp);
801052d9:	83 ec 0c             	sub    $0xc,%esp
801052dc:	56                   	push   %esi
801052dd:	e8 1e c9 ff ff       	call   80101c00 <iunlockput>
  ip->nlink--;
801052e2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052e7:	89 1c 24             	mov    %ebx,(%esp)
801052ea:	e8 01 c5 ff ff       	call   801017f0 <iupdate>
  iunlockput(ip);
801052ef:	89 1c 24             	mov    %ebx,(%esp)
801052f2:	e8 09 c9 ff ff       	call   80101c00 <iunlockput>
  end_op();
801052f7:	e8 14 dd ff ff       	call   80103010 <end_op>
  return 0;
801052fc:	83 c4 10             	add    $0x10,%esp
801052ff:	31 c0                	xor    %eax,%eax
}
80105301:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105304:	5b                   	pop    %ebx
80105305:	5e                   	pop    %esi
80105306:	5f                   	pop    %edi
80105307:	5d                   	pop    %ebp
80105308:	c3                   	ret    
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105310:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105314:	76 8d                	jbe    801052a3 <sys_unlink+0xb3>
80105316:	bf 20 00 00 00       	mov    $0x20,%edi
8010531b:	eb 0f                	jmp    8010532c <sys_unlink+0x13c>
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
80105320:	83 c7 10             	add    $0x10,%edi
80105323:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105326:	0f 83 77 ff ff ff    	jae    801052a3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010532c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010532f:	6a 10                	push   $0x10
80105331:	57                   	push   %edi
80105332:	50                   	push   %eax
80105333:	53                   	push   %ebx
80105334:	e8 17 c9 ff ff       	call   80101c50 <readi>
80105339:	83 c4 10             	add    $0x10,%esp
8010533c:	83 f8 10             	cmp    $0x10,%eax
8010533f:	75 5e                	jne    8010539f <sys_unlink+0x1af>
    if(de.inum != 0)
80105341:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105346:	74 d8                	je     80105320 <sys_unlink+0x130>
    iunlockput(ip);
80105348:	83 ec 0c             	sub    $0xc,%esp
8010534b:	53                   	push   %ebx
8010534c:	e8 af c8 ff ff       	call   80101c00 <iunlockput>
    goto bad;
80105351:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105354:	83 ec 0c             	sub    $0xc,%esp
80105357:	56                   	push   %esi
80105358:	e8 a3 c8 ff ff       	call   80101c00 <iunlockput>
  end_op();
8010535d:	e8 ae dc ff ff       	call   80103010 <end_op>
  return -1;
80105362:	83 c4 10             	add    $0x10,%esp
80105365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536a:	eb 95                	jmp    80105301 <sys_unlink+0x111>
8010536c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105370:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105375:	83 ec 0c             	sub    $0xc,%esp
80105378:	56                   	push   %esi
80105379:	e8 72 c4 ff ff       	call   801017f0 <iupdate>
8010537e:	83 c4 10             	add    $0x10,%esp
80105381:	e9 53 ff ff ff       	jmp    801052d9 <sys_unlink+0xe9>
    return -1;
80105386:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538b:	e9 71 ff ff ff       	jmp    80105301 <sys_unlink+0x111>
    end_op();
80105390:	e8 7b dc ff ff       	call   80103010 <end_op>
    return -1;
80105395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539a:	e9 62 ff ff ff       	jmp    80105301 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	68 e0 7c 10 80       	push   $0x80107ce0
801053a7:	e8 e4 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801053ac:	83 ec 0c             	sub    $0xc,%esp
801053af:	68 ce 7c 10 80       	push   $0x80107cce
801053b4:	e8 d7 af ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801053b9:	83 ec 0c             	sub    $0xc,%esp
801053bc:	68 f2 7c 10 80       	push   $0x80107cf2
801053c1:	e8 ca af ff ff       	call   80100390 <panic>
801053c6:	8d 76 00             	lea    0x0(%esi),%esi
801053c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053d0 <sys_open>:

int
sys_open(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	57                   	push   %edi
801053d4:	56                   	push   %esi
801053d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053dc:	50                   	push   %eax
801053dd:	6a 00                	push   $0x0
801053df:	e8 3c f8 ff ff       	call   80104c20 <argstr>
801053e4:	83 c4 10             	add    $0x10,%esp
801053e7:	85 c0                	test   %eax,%eax
801053e9:	0f 88 1d 01 00 00    	js     8010550c <sys_open+0x13c>
801053ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053f2:	83 ec 08             	sub    $0x8,%esp
801053f5:	50                   	push   %eax
801053f6:	6a 01                	push   $0x1
801053f8:	e8 73 f7 ff ff       	call   80104b70 <argint>
801053fd:	83 c4 10             	add    $0x10,%esp
80105400:	85 c0                	test   %eax,%eax
80105402:	0f 88 04 01 00 00    	js     8010550c <sys_open+0x13c>
    return -1;

  begin_op();
80105408:	e8 93 db ff ff       	call   80102fa0 <begin_op>

  if(omode & O_CREATE){
8010540d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105411:	0f 85 a9 00 00 00    	jne    801054c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105417:	83 ec 0c             	sub    $0xc,%esp
8010541a:	ff 75 e0             	pushl  -0x20(%ebp)
8010541d:	e8 ae cd ff ff       	call   801021d0 <namei>
80105422:	83 c4 10             	add    $0x10,%esp
80105425:	85 c0                	test   %eax,%eax
80105427:	89 c6                	mov    %eax,%esi
80105429:	0f 84 b2 00 00 00    	je     801054e1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	50                   	push   %eax
80105433:	e8 78 c4 ff ff       	call   801018b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105438:	83 c4 10             	add    $0x10,%esp
8010543b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105440:	0f 84 aa 00 00 00    	je     801054f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105446:	e8 35 b9 ff ff       	call   80100d80 <filealloc>
8010544b:	85 c0                	test   %eax,%eax
8010544d:	89 c7                	mov    %eax,%edi
8010544f:	0f 84 a6 00 00 00    	je     801054fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105455:	e8 86 e7 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010545a:	31 db                	xor    %ebx,%ebx
8010545c:	eb 0e                	jmp    8010546c <sys_open+0x9c>
8010545e:	66 90                	xchg   %ax,%ax
80105460:	83 c3 01             	add    $0x1,%ebx
80105463:	83 fb 10             	cmp    $0x10,%ebx
80105466:	0f 84 ac 00 00 00    	je     80105518 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010546c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105470:	85 d2                	test   %edx,%edx
80105472:	75 ec                	jne    80105460 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105474:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105477:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010547b:	56                   	push   %esi
8010547c:	e8 1f c5 ff ff       	call   801019a0 <iunlock>
  end_op();
80105481:	e8 8a db ff ff       	call   80103010 <end_op>

  f->type = FD_INODE;
80105486:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010548c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010548f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105492:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105495:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010549c:	89 d0                	mov    %edx,%eax
8010549e:	f7 d0                	not    %eax
801054a0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054a3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054a6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054a9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b0:	89 d8                	mov    %ebx,%eax
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5f                   	pop    %edi
801054b5:	5d                   	pop    %ebp
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801054c6:	31 c9                	xor    %ecx,%ecx
801054c8:	6a 00                	push   $0x0
801054ca:	ba 02 00 00 00       	mov    $0x2,%edx
801054cf:	e8 ec f7 ff ff       	call   80104cc0 <create>
    if(ip == 0){
801054d4:	83 c4 10             	add    $0x10,%esp
801054d7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801054d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801054db:	0f 85 65 ff ff ff    	jne    80105446 <sys_open+0x76>
      end_op();
801054e1:	e8 2a db ff ff       	call   80103010 <end_op>
      return -1;
801054e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801054eb:	eb c0                	jmp    801054ad <sys_open+0xdd>
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801054f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054f3:	85 c9                	test   %ecx,%ecx
801054f5:	0f 84 4b ff ff ff    	je     80105446 <sys_open+0x76>
    iunlockput(ip);
801054fb:	83 ec 0c             	sub    $0xc,%esp
801054fe:	56                   	push   %esi
801054ff:	e8 fc c6 ff ff       	call   80101c00 <iunlockput>
    end_op();
80105504:	e8 07 db ff ff       	call   80103010 <end_op>
    return -1;
80105509:	83 c4 10             	add    $0x10,%esp
8010550c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105511:	eb 9a                	jmp    801054ad <sys_open+0xdd>
80105513:	90                   	nop
80105514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105518:	83 ec 0c             	sub    $0xc,%esp
8010551b:	57                   	push   %edi
8010551c:	e8 1f b9 ff ff       	call   80100e40 <fileclose>
80105521:	83 c4 10             	add    $0x10,%esp
80105524:	eb d5                	jmp    801054fb <sys_open+0x12b>
80105526:	8d 76 00             	lea    0x0(%esi),%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_mkdir>:

int
sys_mkdir(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105536:	e8 65 da ff ff       	call   80102fa0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010553b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010553e:	83 ec 08             	sub    $0x8,%esp
80105541:	50                   	push   %eax
80105542:	6a 00                	push   $0x0
80105544:	e8 d7 f6 ff ff       	call   80104c20 <argstr>
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	85 c0                	test   %eax,%eax
8010554e:	78 30                	js     80105580 <sys_mkdir+0x50>
80105550:	83 ec 0c             	sub    $0xc,%esp
80105553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105556:	31 c9                	xor    %ecx,%ecx
80105558:	6a 00                	push   $0x0
8010555a:	ba 01 00 00 00       	mov    $0x1,%edx
8010555f:	e8 5c f7 ff ff       	call   80104cc0 <create>
80105564:	83 c4 10             	add    $0x10,%esp
80105567:	85 c0                	test   %eax,%eax
80105569:	74 15                	je     80105580 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010556b:	83 ec 0c             	sub    $0xc,%esp
8010556e:	50                   	push   %eax
8010556f:	e8 8c c6 ff ff       	call   80101c00 <iunlockput>
  end_op();
80105574:	e8 97 da ff ff       	call   80103010 <end_op>
  return 0;
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	31 c0                	xor    %eax,%eax
}
8010557e:	c9                   	leave  
8010557f:	c3                   	ret    
    end_op();
80105580:	e8 8b da ff ff       	call   80103010 <end_op>
    return -1;
80105585:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010558a:	c9                   	leave  
8010558b:	c3                   	ret    
8010558c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_mknod>:

int
sys_mknod(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105596:	e8 05 da ff ff       	call   80102fa0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010559b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010559e:	83 ec 08             	sub    $0x8,%esp
801055a1:	50                   	push   %eax
801055a2:	6a 00                	push   $0x0
801055a4:	e8 77 f6 ff ff       	call   80104c20 <argstr>
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	85 c0                	test   %eax,%eax
801055ae:	78 60                	js     80105610 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801055b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055b3:	83 ec 08             	sub    $0x8,%esp
801055b6:	50                   	push   %eax
801055b7:	6a 01                	push   $0x1
801055b9:	e8 b2 f5 ff ff       	call   80104b70 <argint>
  if((argstr(0, &path)) < 0 ||
801055be:	83 c4 10             	add    $0x10,%esp
801055c1:	85 c0                	test   %eax,%eax
801055c3:	78 4b                	js     80105610 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801055c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c8:	83 ec 08             	sub    $0x8,%esp
801055cb:	50                   	push   %eax
801055cc:	6a 02                	push   $0x2
801055ce:	e8 9d f5 ff ff       	call   80104b70 <argint>
     argint(1, &major) < 0 ||
801055d3:	83 c4 10             	add    $0x10,%esp
801055d6:	85 c0                	test   %eax,%eax
801055d8:	78 36                	js     80105610 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801055de:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801055e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801055e5:	ba 03 00 00 00       	mov    $0x3,%edx
801055ea:	50                   	push   %eax
801055eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055ee:	e8 cd f6 ff ff       	call   80104cc0 <create>
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	74 16                	je     80105610 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055fa:	83 ec 0c             	sub    $0xc,%esp
801055fd:	50                   	push   %eax
801055fe:	e8 fd c5 ff ff       	call   80101c00 <iunlockput>
  end_op();
80105603:	e8 08 da ff ff       	call   80103010 <end_op>
  return 0;
80105608:	83 c4 10             	add    $0x10,%esp
8010560b:	31 c0                	xor    %eax,%eax
}
8010560d:	c9                   	leave  
8010560e:	c3                   	ret    
8010560f:	90                   	nop
    end_op();
80105610:	e8 fb d9 ff ff       	call   80103010 <end_op>
    return -1;
80105615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010561a:	c9                   	leave  
8010561b:	c3                   	ret    
8010561c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105620 <sys_chdir>:

int
sys_chdir(void)
{
80105620:	55                   	push   %ebp
80105621:	89 e5                	mov    %esp,%ebp
80105623:	56                   	push   %esi
80105624:	53                   	push   %ebx
80105625:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105628:	e8 b3 e5 ff ff       	call   80103be0 <myproc>
8010562d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010562f:	e8 6c d9 ff ff       	call   80102fa0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105634:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105637:	83 ec 08             	sub    $0x8,%esp
8010563a:	50                   	push   %eax
8010563b:	6a 00                	push   $0x0
8010563d:	e8 de f5 ff ff       	call   80104c20 <argstr>
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	85 c0                	test   %eax,%eax
80105647:	78 77                	js     801056c0 <sys_chdir+0xa0>
80105649:	83 ec 0c             	sub    $0xc,%esp
8010564c:	ff 75 f4             	pushl  -0xc(%ebp)
8010564f:	e8 7c cb ff ff       	call   801021d0 <namei>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	89 c3                	mov    %eax,%ebx
8010565b:	74 63                	je     801056c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	50                   	push   %eax
80105661:	e8 4a c2 ff ff       	call   801018b0 <ilock>
  if(ip->type != T_DIR){
80105666:	83 c4 10             	add    $0x10,%esp
80105669:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010566e:	75 30                	jne    801056a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 27 c3 ff ff       	call   801019a0 <iunlock>
  iput(curproc->cwd);
80105679:	58                   	pop    %eax
8010567a:	ff 76 68             	pushl  0x68(%esi)
8010567d:	e8 6e c3 ff ff       	call   801019f0 <iput>
  end_op();
80105682:	e8 89 d9 ff ff       	call   80103010 <end_op>
  curproc->cwd = ip;
80105687:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010568a:	83 c4 10             	add    $0x10,%esp
8010568d:	31 c0                	xor    %eax,%eax
}
8010568f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105692:	5b                   	pop    %ebx
80105693:	5e                   	pop    %esi
80105694:	5d                   	pop    %ebp
80105695:	c3                   	ret    
80105696:	8d 76 00             	lea    0x0(%esi),%esi
80105699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801056a0:	83 ec 0c             	sub    $0xc,%esp
801056a3:	53                   	push   %ebx
801056a4:	e8 57 c5 ff ff       	call   80101c00 <iunlockput>
    end_op();
801056a9:	e8 62 d9 ff ff       	call   80103010 <end_op>
    return -1;
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056b6:	eb d7                	jmp    8010568f <sys_chdir+0x6f>
801056b8:	90                   	nop
801056b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801056c0:	e8 4b d9 ff ff       	call   80103010 <end_op>
    return -1;
801056c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ca:	eb c3                	jmp    8010568f <sys_chdir+0x6f>
801056cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056d0 <sys_exec>:

int
sys_exec(void)
{
801056d0:	55                   	push   %ebp
801056d1:	89 e5                	mov    %esp,%ebp
801056d3:	57                   	push   %edi
801056d4:	56                   	push   %esi
801056d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056e2:	50                   	push   %eax
801056e3:	6a 00                	push   $0x0
801056e5:	e8 36 f5 ff ff       	call   80104c20 <argstr>
801056ea:	83 c4 10             	add    $0x10,%esp
801056ed:	85 c0                	test   %eax,%eax
801056ef:	0f 88 87 00 00 00    	js     8010577c <sys_exec+0xac>
801056f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056fb:	83 ec 08             	sub    $0x8,%esp
801056fe:	50                   	push   %eax
801056ff:	6a 01                	push   $0x1
80105701:	e8 6a f4 ff ff       	call   80104b70 <argint>
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	85 c0                	test   %eax,%eax
8010570b:	78 6f                	js     8010577c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010570d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105713:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105716:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105718:	68 80 00 00 00       	push   $0x80
8010571d:	6a 00                	push   $0x0
8010571f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105725:	50                   	push   %eax
80105726:	e8 45 f1 ff ff       	call   80104870 <memset>
8010572b:	83 c4 10             	add    $0x10,%esp
8010572e:	eb 2c                	jmp    8010575c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105730:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105736:	85 c0                	test   %eax,%eax
80105738:	74 56                	je     80105790 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010573a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105746:	52                   	push   %edx
80105747:	50                   	push   %eax
80105748:	e8 b3 f3 ff ff       	call   80104b00 <fetchstr>
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	85 c0                	test   %eax,%eax
80105752:	78 28                	js     8010577c <sys_exec+0xac>
  for(i=0;; i++){
80105754:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105757:	83 fb 20             	cmp    $0x20,%ebx
8010575a:	74 20                	je     8010577c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010575c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105762:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105769:	83 ec 08             	sub    $0x8,%esp
8010576c:	57                   	push   %edi
8010576d:	01 f0                	add    %esi,%eax
8010576f:	50                   	push   %eax
80105770:	e8 4b f3 ff ff       	call   80104ac0 <fetchint>
80105775:	83 c4 10             	add    $0x10,%esp
80105778:	85 c0                	test   %eax,%eax
8010577a:	79 b4                	jns    80105730 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010577c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010577f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105784:	5b                   	pop    %ebx
80105785:	5e                   	pop    %esi
80105786:	5f                   	pop    %edi
80105787:	5d                   	pop    %ebp
80105788:	c3                   	ret    
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105790:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105796:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105799:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801057a0:	00 00 00 00 
  return exec(path, argv);
801057a4:	50                   	push   %eax
801057a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801057ab:	e8 60 b2 ff ff       	call   80100a10 <exec>
801057b0:	83 c4 10             	add    $0x10,%esp
}
801057b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057b6:	5b                   	pop    %ebx
801057b7:	5e                   	pop    %esi
801057b8:	5f                   	pop    %edi
801057b9:	5d                   	pop    %ebp
801057ba:	c3                   	ret    
801057bb:	90                   	nop
801057bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057c0 <sys_pipe>:

int
sys_pipe(void)
{
801057c0:	55                   	push   %ebp
801057c1:	89 e5                	mov    %esp,%ebp
801057c3:	57                   	push   %edi
801057c4:	56                   	push   %esi
801057c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057cc:	6a 08                	push   $0x8
801057ce:	50                   	push   %eax
801057cf:	6a 00                	push   $0x0
801057d1:	e8 ea f3 ff ff       	call   80104bc0 <argptr>
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	85 c0                	test   %eax,%eax
801057db:	0f 88 ae 00 00 00    	js     8010588f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057e4:	83 ec 08             	sub    $0x8,%esp
801057e7:	50                   	push   %eax
801057e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057eb:	50                   	push   %eax
801057ec:	e8 4f de ff ff       	call   80103640 <pipealloc>
801057f1:	83 c4 10             	add    $0x10,%esp
801057f4:	85 c0                	test   %eax,%eax
801057f6:	0f 88 93 00 00 00    	js     8010588f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105801:	e8 da e3 ff ff       	call   80103be0 <myproc>
80105806:	eb 10                	jmp    80105818 <sys_pipe+0x58>
80105808:	90                   	nop
80105809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105810:	83 c3 01             	add    $0x1,%ebx
80105813:	83 fb 10             	cmp    $0x10,%ebx
80105816:	74 60                	je     80105878 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105818:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010581c:	85 f6                	test   %esi,%esi
8010581e:	75 f0                	jne    80105810 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105820:	8d 73 08             	lea    0x8(%ebx),%esi
80105823:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105827:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010582a:	e8 b1 e3 ff ff       	call   80103be0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010582f:	31 d2                	xor    %edx,%edx
80105831:	eb 0d                	jmp    80105840 <sys_pipe+0x80>
80105833:	90                   	nop
80105834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105838:	83 c2 01             	add    $0x1,%edx
8010583b:	83 fa 10             	cmp    $0x10,%edx
8010583e:	74 28                	je     80105868 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105840:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105844:	85 c9                	test   %ecx,%ecx
80105846:	75 f0                	jne    80105838 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105848:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010584c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010584f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105851:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105854:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105857:	31 c0                	xor    %eax,%eax
}
80105859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010585c:	5b                   	pop    %ebx
8010585d:	5e                   	pop    %esi
8010585e:	5f                   	pop    %edi
8010585f:	5d                   	pop    %ebp
80105860:	c3                   	ret    
80105861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105868:	e8 73 e3 ff ff       	call   80103be0 <myproc>
8010586d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105874:	00 
80105875:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105878:	83 ec 0c             	sub    $0xc,%esp
8010587b:	ff 75 e0             	pushl  -0x20(%ebp)
8010587e:	e8 bd b5 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105883:	58                   	pop    %eax
80105884:	ff 75 e4             	pushl  -0x1c(%ebp)
80105887:	e8 b4 b5 ff ff       	call   80100e40 <fileclose>
    return -1;
8010588c:	83 c4 10             	add    $0x10,%esp
8010588f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105894:	eb c3                	jmp    80105859 <sys_pipe+0x99>
80105896:	8d 76 00             	lea    0x0(%esi),%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <sys_swapread>:

int sys_swapread(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
801058a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a9:	68 00 10 00 00       	push   $0x1000
801058ae:	50                   	push   %eax
801058af:	6a 00                	push   $0x0
801058b1:	e8 0a f3 ff ff       	call   80104bc0 <argptr>
801058b6:	83 c4 10             	add    $0x10,%esp
801058b9:	85 c0                	test   %eax,%eax
801058bb:	78 33                	js     801058f0 <sys_swapread+0x50>
801058bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	50                   	push   %eax
801058c4:	6a 01                	push   $0x1
801058c6:	e8 a5 f2 ff ff       	call   80104b70 <argint>
801058cb:	83 c4 10             	add    $0x10,%esp
801058ce:	85 c0                	test   %eax,%eax
801058d0:	78 1e                	js     801058f0 <sys_swapread+0x50>
		return -1;

	swapread(ptr, blkno);
801058d2:	83 ec 08             	sub    $0x8,%esp
801058d5:	ff 75 f4             	pushl  -0xc(%ebp)
801058d8:	ff 75 f0             	pushl  -0x10(%ebp)
801058db:	e8 30 c9 ff ff       	call   80102210 <swapread>
	return 0;
801058e0:	83 c4 10             	add    $0x10,%esp
801058e3:	31 c0                	xor    %eax,%eax
}
801058e5:	c9                   	leave  
801058e6:	c3                   	ret    
801058e7:	89 f6                	mov    %esi,%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <sys_swapwrite>:

int sys_swapwrite(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	83 ec 1c             	sub    $0x1c,%esp
	char* ptr;
	int blkno;

	if(argptr(0, &ptr, PGSIZE) < 0 || argint(1, &blkno) < 0 )
80105906:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105909:	68 00 10 00 00       	push   $0x1000
8010590e:	50                   	push   %eax
8010590f:	6a 00                	push   $0x0
80105911:	e8 aa f2 ff ff       	call   80104bc0 <argptr>
80105916:	83 c4 10             	add    $0x10,%esp
80105919:	85 c0                	test   %eax,%eax
8010591b:	78 33                	js     80105950 <sys_swapwrite+0x50>
8010591d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105920:	83 ec 08             	sub    $0x8,%esp
80105923:	50                   	push   %eax
80105924:	6a 01                	push   $0x1
80105926:	e8 45 f2 ff ff       	call   80104b70 <argint>
8010592b:	83 c4 10             	add    $0x10,%esp
8010592e:	85 c0                	test   %eax,%eax
80105930:	78 1e                	js     80105950 <sys_swapwrite+0x50>
		return -1;

	swapwrite(ptr, blkno);
80105932:	83 ec 08             	sub    $0x8,%esp
80105935:	ff 75 f4             	pushl  -0xc(%ebp)
80105938:	ff 75 f0             	pushl  -0x10(%ebp)
8010593b:	e8 50 c9 ff ff       	call   80102290 <swapwrite>
	return 0;
80105940:	83 c4 10             	add    $0x10,%esp
80105943:	31 c0                	xor    %eax,%eax
}
80105945:	c9                   	leave  
80105946:	c3                   	ret    
80105947:	89 f6                	mov    %esi,%esi
80105949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
		return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105955:	c9                   	leave  
80105956:	c3                   	ret    
80105957:	66 90                	xchg   %ax,%ax
80105959:	66 90                	xchg   %ax,%ax
8010595b:	66 90                	xchg   %ax,%ax
8010595d:	66 90                	xchg   %ax,%ax
8010595f:	90                   	nop

80105960 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105963:	5d                   	pop    %ebp
  return fork();
80105964:	e9 37 e4 ff ff       	jmp    80103da0 <fork>
80105969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105970 <sys_exit>:

int
sys_exit(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
80105973:	83 ec 08             	sub    $0x8,%esp
  exit();
80105976:	e8 a5 e6 ff ff       	call   80104020 <exit>
  return 0;  // not reached
}
8010597b:	31 c0                	xor    %eax,%eax
8010597d:	c9                   	leave  
8010597e:	c3                   	ret    
8010597f:	90                   	nop

80105980 <sys_wait>:

int
sys_wait(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105983:	5d                   	pop    %ebp
  return wait();
80105984:	e9 d7 e8 ff ff       	jmp    80104260 <wait>
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105990 <sys_kill>:

int
sys_kill(void)
{
80105990:	55                   	push   %ebp
80105991:	89 e5                	mov    %esp,%ebp
80105993:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105996:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105999:	50                   	push   %eax
8010599a:	6a 00                	push   $0x0
8010599c:	e8 cf f1 ff ff       	call   80104b70 <argint>
801059a1:	83 c4 10             	add    $0x10,%esp
801059a4:	85 c0                	test   %eax,%eax
801059a6:	78 18                	js     801059c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801059a8:	83 ec 0c             	sub    $0xc,%esp
801059ab:	ff 75 f4             	pushl  -0xc(%ebp)
801059ae:	e8 fd e9 ff ff       	call   801043b0 <kill>
801059b3:	83 c4 10             	add    $0x10,%esp
}
801059b6:	c9                   	leave  
801059b7:	c3                   	ret    
801059b8:	90                   	nop
801059b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c5:	c9                   	leave  
801059c6:	c3                   	ret    
801059c7:	89 f6                	mov    %esi,%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_getpid>:

int
sys_getpid(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059d6:	e8 05 e2 ff ff       	call   80103be0 <myproc>
801059db:	8b 40 10             	mov    0x10(%eax),%eax
}
801059de:	c9                   	leave  
801059df:	c3                   	ret    

801059e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059e7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059ea:	50                   	push   %eax
801059eb:	6a 00                	push   $0x0
801059ed:	e8 7e f1 ff ff       	call   80104b70 <argint>
801059f2:	83 c4 10             	add    $0x10,%esp
801059f5:	85 c0                	test   %eax,%eax
801059f7:	78 27                	js     80105a20 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059f9:	e8 e2 e1 ff ff       	call   80103be0 <myproc>
  if(growproc(n) < 0)
801059fe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105a01:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105a03:	ff 75 f4             	pushl  -0xc(%ebp)
80105a06:	e8 15 e3 ff ff       	call   80103d20 <growproc>
80105a0b:	83 c4 10             	add    $0x10,%esp
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	78 0e                	js     80105a20 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a12:	89 d8                	mov    %ebx,%eax
80105a14:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a17:	c9                   	leave  
80105a18:	c3                   	ret    
80105a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a20:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a25:	eb eb                	jmp    80105a12 <sys_sbrk+0x32>
80105a27:	89 f6                	mov    %esi,%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a30 <sys_sleep>:

int
sys_sleep(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a34:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a37:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a3a:	50                   	push   %eax
80105a3b:	6a 00                	push   $0x0
80105a3d:	e8 2e f1 ff ff       	call   80104b70 <argint>
80105a42:	83 c4 10             	add    $0x10,%esp
80105a45:	85 c0                	test   %eax,%eax
80105a47:	0f 88 8a 00 00 00    	js     80105ad7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a4d:	83 ec 0c             	sub    $0xc,%esp
80105a50:	68 80 4c 11 80       	push   $0x80114c80
80105a55:	e8 06 ed ff ff       	call   80104760 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a5d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a60:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  while(ticks - ticks0 < n){
80105a66:	85 d2                	test   %edx,%edx
80105a68:	75 27                	jne    80105a91 <sys_sleep+0x61>
80105a6a:	eb 54                	jmp    80105ac0 <sys_sleep+0x90>
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a70:	83 ec 08             	sub    $0x8,%esp
80105a73:	68 80 4c 11 80       	push   $0x80114c80
80105a78:	68 c0 54 11 80       	push   $0x801154c0
80105a7d:	e8 1e e7 ff ff       	call   801041a0 <sleep>
  while(ticks - ticks0 < n){
80105a82:	a1 c0 54 11 80       	mov    0x801154c0,%eax
80105a87:	83 c4 10             	add    $0x10,%esp
80105a8a:	29 d8                	sub    %ebx,%eax
80105a8c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a8f:	73 2f                	jae    80105ac0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a91:	e8 4a e1 ff ff       	call   80103be0 <myproc>
80105a96:	8b 40 24             	mov    0x24(%eax),%eax
80105a99:	85 c0                	test   %eax,%eax
80105a9b:	74 d3                	je     80105a70 <sys_sleep+0x40>
      release(&tickslock);
80105a9d:	83 ec 0c             	sub    $0xc,%esp
80105aa0:	68 80 4c 11 80       	push   $0x80114c80
80105aa5:	e8 76 ed ff ff       	call   80104820 <release>
      return -1;
80105aaa:	83 c4 10             	add    $0x10,%esp
80105aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105ab2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	68 80 4c 11 80       	push   $0x80114c80
80105ac8:	e8 53 ed ff ff       	call   80104820 <release>
  return 0;
80105acd:	83 c4 10             	add    $0x10,%esp
80105ad0:	31 c0                	xor    %eax,%eax
}
80105ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad5:	c9                   	leave  
80105ad6:	c3                   	ret    
    return -1;
80105ad7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105adc:	eb f4                	jmp    80105ad2 <sys_sleep+0xa2>
80105ade:	66 90                	xchg   %ax,%ax

80105ae0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	53                   	push   %ebx
80105ae4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ae7:	68 80 4c 11 80       	push   $0x80114c80
80105aec:	e8 6f ec ff ff       	call   80104760 <acquire>
  xticks = ticks;
80105af1:	8b 1d c0 54 11 80    	mov    0x801154c0,%ebx
  release(&tickslock);
80105af7:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105afe:	e8 1d ed ff ff       	call   80104820 <release>
  return xticks;
}
80105b03:	89 d8                	mov    %ebx,%eax
80105b05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b08:	c9                   	leave  
80105b09:	c3                   	ret    

80105b0a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105b0a:	1e                   	push   %ds
  pushl %es
80105b0b:	06                   	push   %es
  pushl %fs
80105b0c:	0f a0                	push   %fs
  pushl %gs
80105b0e:	0f a8                	push   %gs
  pushal
80105b10:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b11:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b15:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b17:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b19:	54                   	push   %esp
  call trap
80105b1a:	e8 c1 00 00 00       	call   80105be0 <trap>
  addl $4, %esp
80105b1f:	83 c4 04             	add    $0x4,%esp

80105b22 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b22:	61                   	popa   
  popl %gs
80105b23:	0f a9                	pop    %gs
  popl %fs
80105b25:	0f a1                	pop    %fs
  popl %es
80105b27:	07                   	pop    %es
  popl %ds
80105b28:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b29:	83 c4 08             	add    $0x8,%esp
  iret
80105b2c:	cf                   	iret   
80105b2d:	66 90                	xchg   %ax,%ax
80105b2f:	90                   	nop

80105b30 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b30:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b31:	31 c0                	xor    %eax,%eax
{
80105b33:	89 e5                	mov    %esp,%ebp
80105b35:	83 ec 08             	sub    $0x8,%esp
80105b38:	90                   	nop
80105b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b40:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b47:	c7 04 c5 c2 4c 11 80 	movl   $0x8e000008,-0x7feeb33e(,%eax,8)
80105b4e:	08 00 00 8e 
80105b52:	66 89 14 c5 c0 4c 11 	mov    %dx,-0x7feeb340(,%eax,8)
80105b59:	80 
80105b5a:	c1 ea 10             	shr    $0x10,%edx
80105b5d:	66 89 14 c5 c6 4c 11 	mov    %dx,-0x7feeb33a(,%eax,8)
80105b64:	80 
  for(i = 0; i < 256; i++)
80105b65:	83 c0 01             	add    $0x1,%eax
80105b68:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b6d:	75 d1                	jne    80105b40 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b6f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105b74:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b77:	c7 05 c2 4e 11 80 08 	movl   $0xef000008,0x80114ec2
80105b7e:	00 00 ef 
  initlock(&tickslock, "time");
80105b81:	68 01 7d 10 80       	push   $0x80107d01
80105b86:	68 80 4c 11 80       	push   $0x80114c80
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b8b:	66 a3 c0 4e 11 80    	mov    %ax,0x80114ec0
80105b91:	c1 e8 10             	shr    $0x10,%eax
80105b94:	66 a3 c6 4e 11 80    	mov    %ax,0x80114ec6
  initlock(&tickslock, "time");
80105b9a:	e8 81 ea ff ff       	call   80104620 <initlock>
}
80105b9f:	83 c4 10             	add    $0x10,%esp
80105ba2:	c9                   	leave  
80105ba3:	c3                   	ret    
80105ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105bb0 <idtinit>:

void
idtinit(void)
{
80105bb0:	55                   	push   %ebp
  pd[0] = size-1;
80105bb1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105bb6:	89 e5                	mov    %esp,%ebp
80105bb8:	83 ec 10             	sub    $0x10,%esp
80105bbb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105bbf:	b8 c0 4c 11 80       	mov    $0x80114cc0,%eax
80105bc4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bc8:	c1 e8 10             	shr    $0x10,%eax
80105bcb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bcf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bd2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bd5:	c9                   	leave  
80105bd6:	c3                   	ret    
80105bd7:	89 f6                	mov    %esi,%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105be0 <trap>:

void
trap(struct trapframe *tf)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	57                   	push   %edi
80105be4:	56                   	push   %esi
80105be5:	53                   	push   %ebx
80105be6:	83 ec 1c             	sub    $0x1c,%esp
80105be9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105bec:	8b 47 30             	mov    0x30(%edi),%eax
80105bef:	83 f8 40             	cmp    $0x40,%eax
80105bf2:	0f 84 f0 00 00 00    	je     80105ce8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105bf8:	83 e8 20             	sub    $0x20,%eax
80105bfb:	83 f8 1f             	cmp    $0x1f,%eax
80105bfe:	77 10                	ja     80105c10 <trap+0x30>
80105c00:	ff 24 85 a8 7d 10 80 	jmp    *-0x7fef8258(,%eax,4)
80105c07:	89 f6                	mov    %esi,%esi
80105c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c10:	e8 cb df ff ff       	call   80103be0 <myproc>
80105c15:	85 c0                	test   %eax,%eax
80105c17:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c1a:	0f 84 14 02 00 00    	je     80105e34 <trap+0x254>
80105c20:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c24:	0f 84 0a 02 00 00    	je     80105e34 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c2a:	0f 20 d1             	mov    %cr2,%ecx
80105c2d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c30:	e8 8b df ff ff       	call   80103bc0 <cpuid>
80105c35:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c38:	8b 47 34             	mov    0x34(%edi),%eax
80105c3b:	8b 77 30             	mov    0x30(%edi),%esi
80105c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c41:	e8 9a df ff ff       	call   80103be0 <myproc>
80105c46:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c49:	e8 92 df ff ff       	call   80103be0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c4e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c51:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c54:	51                   	push   %ecx
80105c55:	53                   	push   %ebx
80105c56:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105c57:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c5a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c5d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c5e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c61:	52                   	push   %edx
80105c62:	ff 70 10             	pushl  0x10(%eax)
80105c65:	68 64 7d 10 80       	push   $0x80107d64
80105c6a:	e8 f1 a9 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c6f:	83 c4 20             	add    $0x20,%esp
80105c72:	e8 69 df ff ff       	call   80103be0 <myproc>
80105c77:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c7e:	e8 5d df ff ff       	call   80103be0 <myproc>
80105c83:	85 c0                	test   %eax,%eax
80105c85:	74 1d                	je     80105ca4 <trap+0xc4>
80105c87:	e8 54 df ff ff       	call   80103be0 <myproc>
80105c8c:	8b 50 24             	mov    0x24(%eax),%edx
80105c8f:	85 d2                	test   %edx,%edx
80105c91:	74 11                	je     80105ca4 <trap+0xc4>
80105c93:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105c97:	83 e0 03             	and    $0x3,%eax
80105c9a:	66 83 f8 03          	cmp    $0x3,%ax
80105c9e:	0f 84 4c 01 00 00    	je     80105df0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ca4:	e8 37 df ff ff       	call   80103be0 <myproc>
80105ca9:	85 c0                	test   %eax,%eax
80105cab:	74 0b                	je     80105cb8 <trap+0xd8>
80105cad:	e8 2e df ff ff       	call   80103be0 <myproc>
80105cb2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105cb6:	74 68                	je     80105d20 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cb8:	e8 23 df ff ff       	call   80103be0 <myproc>
80105cbd:	85 c0                	test   %eax,%eax
80105cbf:	74 19                	je     80105cda <trap+0xfa>
80105cc1:	e8 1a df ff ff       	call   80103be0 <myproc>
80105cc6:	8b 40 24             	mov    0x24(%eax),%eax
80105cc9:	85 c0                	test   %eax,%eax
80105ccb:	74 0d                	je     80105cda <trap+0xfa>
80105ccd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105cd1:	83 e0 03             	and    $0x3,%eax
80105cd4:	66 83 f8 03          	cmp    $0x3,%ax
80105cd8:	74 37                	je     80105d11 <trap+0x131>
    exit();
}
80105cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105cdd:	5b                   	pop    %ebx
80105cde:	5e                   	pop    %esi
80105cdf:	5f                   	pop    %edi
80105ce0:	5d                   	pop    %ebp
80105ce1:	c3                   	ret    
80105ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105ce8:	e8 f3 de ff ff       	call   80103be0 <myproc>
80105ced:	8b 58 24             	mov    0x24(%eax),%ebx
80105cf0:	85 db                	test   %ebx,%ebx
80105cf2:	0f 85 e8 00 00 00    	jne    80105de0 <trap+0x200>
    myproc()->tf = tf;
80105cf8:	e8 e3 de ff ff       	call   80103be0 <myproc>
80105cfd:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105d00:	e8 5b ef ff ff       	call   80104c60 <syscall>
    if(myproc()->killed)
80105d05:	e8 d6 de ff ff       	call   80103be0 <myproc>
80105d0a:	8b 48 24             	mov    0x24(%eax),%ecx
80105d0d:	85 c9                	test   %ecx,%ecx
80105d0f:	74 c9                	je     80105cda <trap+0xfa>
}
80105d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d14:	5b                   	pop    %ebx
80105d15:	5e                   	pop    %esi
80105d16:	5f                   	pop    %edi
80105d17:	5d                   	pop    %ebp
      exit();
80105d18:	e9 03 e3 ff ff       	jmp    80104020 <exit>
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d20:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d24:	75 92                	jne    80105cb8 <trap+0xd8>
    yield();
80105d26:	e8 25 e4 ff ff       	call   80104150 <yield>
80105d2b:	eb 8b                	jmp    80105cb8 <trap+0xd8>
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105d30:	e8 8b de ff ff       	call   80103bc0 <cpuid>
80105d35:	85 c0                	test   %eax,%eax
80105d37:	0f 84 c3 00 00 00    	je     80105e00 <trap+0x220>
    lapiceoi();
80105d3d:	e8 0e ce ff ff       	call   80102b50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d42:	e8 99 de ff ff       	call   80103be0 <myproc>
80105d47:	85 c0                	test   %eax,%eax
80105d49:	0f 85 38 ff ff ff    	jne    80105c87 <trap+0xa7>
80105d4f:	e9 50 ff ff ff       	jmp    80105ca4 <trap+0xc4>
80105d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d58:	e8 b3 cc ff ff       	call   80102a10 <kbdintr>
    lapiceoi();
80105d5d:	e8 ee cd ff ff       	call   80102b50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d62:	e8 79 de ff ff       	call   80103be0 <myproc>
80105d67:	85 c0                	test   %eax,%eax
80105d69:	0f 85 18 ff ff ff    	jne    80105c87 <trap+0xa7>
80105d6f:	e9 30 ff ff ff       	jmp    80105ca4 <trap+0xc4>
80105d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d78:	e8 53 02 00 00       	call   80105fd0 <uartintr>
    lapiceoi();
80105d7d:	e8 ce cd ff ff       	call   80102b50 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d82:	e8 59 de ff ff       	call   80103be0 <myproc>
80105d87:	85 c0                	test   %eax,%eax
80105d89:	0f 85 f8 fe ff ff    	jne    80105c87 <trap+0xa7>
80105d8f:	e9 10 ff ff ff       	jmp    80105ca4 <trap+0xc4>
80105d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d98:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105d9c:	8b 77 38             	mov    0x38(%edi),%esi
80105d9f:	e8 1c de ff ff       	call   80103bc0 <cpuid>
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
80105da6:	50                   	push   %eax
80105da7:	68 0c 7d 10 80       	push   $0x80107d0c
80105dac:	e8 af a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105db1:	e8 9a cd ff ff       	call   80102b50 <lapiceoi>
    break;
80105db6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105db9:	e8 22 de ff ff       	call   80103be0 <myproc>
80105dbe:	85 c0                	test   %eax,%eax
80105dc0:	0f 85 c1 fe ff ff    	jne    80105c87 <trap+0xa7>
80105dc6:	e9 d9 fe ff ff       	jmp    80105ca4 <trap+0xc4>
80105dcb:	90                   	nop
80105dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105dd0:	e8 ab c6 ff ff       	call   80102480 <ideintr>
80105dd5:	e9 63 ff ff ff       	jmp    80105d3d <trap+0x15d>
80105dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105de0:	e8 3b e2 ff ff       	call   80104020 <exit>
80105de5:	e9 0e ff ff ff       	jmp    80105cf8 <trap+0x118>
80105dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105df0:	e8 2b e2 ff ff       	call   80104020 <exit>
80105df5:	e9 aa fe ff ff       	jmp    80105ca4 <trap+0xc4>
80105dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	68 80 4c 11 80       	push   $0x80114c80
80105e08:	e8 53 e9 ff ff       	call   80104760 <acquire>
      wakeup(&ticks);
80105e0d:	c7 04 24 c0 54 11 80 	movl   $0x801154c0,(%esp)
      ticks++;
80105e14:	83 05 c0 54 11 80 01 	addl   $0x1,0x801154c0
      wakeup(&ticks);
80105e1b:	e8 30 e5 ff ff       	call   80104350 <wakeup>
      release(&tickslock);
80105e20:	c7 04 24 80 4c 11 80 	movl   $0x80114c80,(%esp)
80105e27:	e8 f4 e9 ff ff       	call   80104820 <release>
80105e2c:	83 c4 10             	add    $0x10,%esp
80105e2f:	e9 09 ff ff ff       	jmp    80105d3d <trap+0x15d>
80105e34:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e37:	e8 84 dd ff ff       	call   80103bc0 <cpuid>
80105e3c:	83 ec 0c             	sub    $0xc,%esp
80105e3f:	56                   	push   %esi
80105e40:	53                   	push   %ebx
80105e41:	50                   	push   %eax
80105e42:	ff 77 30             	pushl  0x30(%edi)
80105e45:	68 30 7d 10 80       	push   $0x80107d30
80105e4a:	e8 11 a8 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105e4f:	83 c4 14             	add    $0x14,%esp
80105e52:	68 06 7d 10 80       	push   $0x80107d06
80105e57:	e8 34 a5 ff ff       	call   80100390 <panic>
80105e5c:	66 90                	xchg   %ax,%ax
80105e5e:	66 90                	xchg   %ax,%ax

80105e60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e60:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105e65:	55                   	push   %ebp
80105e66:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105e68:	85 c0                	test   %eax,%eax
80105e6a:	74 1c                	je     80105e88 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e6c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e71:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e72:	a8 01                	test   $0x1,%al
80105e74:	74 12                	je     80105e88 <uartgetc+0x28>
80105e76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e7b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e7c:	0f b6 c0             	movzbl %al,%eax
}
80105e7f:	5d                   	pop    %ebp
80105e80:	c3                   	ret    
80105e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e8d:	5d                   	pop    %ebp
80105e8e:	c3                   	ret    
80105e8f:	90                   	nop

80105e90 <uartputc.part.0>:
uartputc(int c)
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
80105e95:	53                   	push   %ebx
80105e96:	89 c7                	mov    %eax,%edi
80105e98:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ea2:	83 ec 0c             	sub    $0xc,%esp
80105ea5:	eb 1b                	jmp    80105ec2 <uartputc.part.0+0x32>
80105ea7:	89 f6                	mov    %esi,%esi
80105ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105eb0:	83 ec 0c             	sub    $0xc,%esp
80105eb3:	6a 0a                	push   $0xa
80105eb5:	e8 b6 cc ff ff       	call   80102b70 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eba:	83 c4 10             	add    $0x10,%esp
80105ebd:	83 eb 01             	sub    $0x1,%ebx
80105ec0:	74 07                	je     80105ec9 <uartputc.part.0+0x39>
80105ec2:	89 f2                	mov    %esi,%edx
80105ec4:	ec                   	in     (%dx),%al
80105ec5:	a8 20                	test   $0x20,%al
80105ec7:	74 e7                	je     80105eb0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ec9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ece:	89 f8                	mov    %edi,%eax
80105ed0:	ee                   	out    %al,(%dx)
}
80105ed1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ed4:	5b                   	pop    %ebx
80105ed5:	5e                   	pop    %esi
80105ed6:	5f                   	pop    %edi
80105ed7:	5d                   	pop    %ebp
80105ed8:	c3                   	ret    
80105ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ee0 <uartinit>:
{
80105ee0:	55                   	push   %ebp
80105ee1:	31 c9                	xor    %ecx,%ecx
80105ee3:	89 c8                	mov    %ecx,%eax
80105ee5:	89 e5                	mov    %esp,%ebp
80105ee7:	57                   	push   %edi
80105ee8:	56                   	push   %esi
80105ee9:	53                   	push   %ebx
80105eea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105eef:	89 da                	mov    %ebx,%edx
80105ef1:	83 ec 0c             	sub    $0xc,%esp
80105ef4:	ee                   	out    %al,(%dx)
80105ef5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105efa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eff:	89 fa                	mov    %edi,%edx
80105f01:	ee                   	out    %al,(%dx)
80105f02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105f07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f0c:	ee                   	out    %al,(%dx)
80105f0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f12:	89 c8                	mov    %ecx,%eax
80105f14:	89 f2                	mov    %esi,%edx
80105f16:	ee                   	out    %al,(%dx)
80105f17:	b8 03 00 00 00       	mov    $0x3,%eax
80105f1c:	89 fa                	mov    %edi,%edx
80105f1e:	ee                   	out    %al,(%dx)
80105f1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f24:	89 c8                	mov    %ecx,%eax
80105f26:	ee                   	out    %al,(%dx)
80105f27:	b8 01 00 00 00       	mov    $0x1,%eax
80105f2c:	89 f2                	mov    %esi,%edx
80105f2e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f34:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f35:	3c ff                	cmp    $0xff,%al
80105f37:	74 5a                	je     80105f93 <uartinit+0xb3>
  uart = 1;
80105f39:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105f40:	00 00 00 
80105f43:	89 da                	mov    %ebx,%edx
80105f45:	ec                   	in     (%dx),%al
80105f46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f4b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f4c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f4f:	bb 28 7e 10 80       	mov    $0x80107e28,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f54:	6a 00                	push   $0x0
80105f56:	6a 04                	push   $0x4
80105f58:	e8 73 c7 ff ff       	call   801026d0 <ioapicenable>
80105f5d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f60:	b8 78 00 00 00       	mov    $0x78,%eax
80105f65:	eb 13                	jmp    80105f7a <uartinit+0x9a>
80105f67:	89 f6                	mov    %esi,%esi
80105f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f70:	83 c3 01             	add    $0x1,%ebx
80105f73:	0f be 03             	movsbl (%ebx),%eax
80105f76:	84 c0                	test   %al,%al
80105f78:	74 19                	je     80105f93 <uartinit+0xb3>
  if(!uart)
80105f7a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105f80:	85 d2                	test   %edx,%edx
80105f82:	74 ec                	je     80105f70 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105f84:	83 c3 01             	add    $0x1,%ebx
80105f87:	e8 04 ff ff ff       	call   80105e90 <uartputc.part.0>
80105f8c:	0f be 03             	movsbl (%ebx),%eax
80105f8f:	84 c0                	test   %al,%al
80105f91:	75 e7                	jne    80105f7a <uartinit+0x9a>
}
80105f93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f96:	5b                   	pop    %ebx
80105f97:	5e                   	pop    %esi
80105f98:	5f                   	pop    %edi
80105f99:	5d                   	pop    %ebp
80105f9a:	c3                   	ret    
80105f9b:	90                   	nop
80105f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <uartputc>:
  if(!uart)
80105fa0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105fa6:	55                   	push   %ebp
80105fa7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105fa9:	85 d2                	test   %edx,%edx
{
80105fab:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105fae:	74 10                	je     80105fc0 <uartputc+0x20>
}
80105fb0:	5d                   	pop    %ebp
80105fb1:	e9 da fe ff ff       	jmp    80105e90 <uartputc.part.0>
80105fb6:	8d 76 00             	lea    0x0(%esi),%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fc0:	5d                   	pop    %ebp
80105fc1:	c3                   	ret    
80105fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fd0 <uartintr>:

void
uartintr(void)
{
80105fd0:	55                   	push   %ebp
80105fd1:	89 e5                	mov    %esp,%ebp
80105fd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fd6:	68 60 5e 10 80       	push   $0x80105e60
80105fdb:	e8 30 a8 ff ff       	call   80100810 <consoleintr>
}
80105fe0:	83 c4 10             	add    $0x10,%esp
80105fe3:	c9                   	leave  
80105fe4:	c3                   	ret    

80105fe5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fe5:	6a 00                	push   $0x0
  pushl $0
80105fe7:	6a 00                	push   $0x0
  jmp alltraps
80105fe9:	e9 1c fb ff ff       	jmp    80105b0a <alltraps>

80105fee <vector1>:
.globl vector1
vector1:
  pushl $0
80105fee:	6a 00                	push   $0x0
  pushl $1
80105ff0:	6a 01                	push   $0x1
  jmp alltraps
80105ff2:	e9 13 fb ff ff       	jmp    80105b0a <alltraps>

80105ff7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ff7:	6a 00                	push   $0x0
  pushl $2
80105ff9:	6a 02                	push   $0x2
  jmp alltraps
80105ffb:	e9 0a fb ff ff       	jmp    80105b0a <alltraps>

80106000 <vector3>:
.globl vector3
vector3:
  pushl $0
80106000:	6a 00                	push   $0x0
  pushl $3
80106002:	6a 03                	push   $0x3
  jmp alltraps
80106004:	e9 01 fb ff ff       	jmp    80105b0a <alltraps>

80106009 <vector4>:
.globl vector4
vector4:
  pushl $0
80106009:	6a 00                	push   $0x0
  pushl $4
8010600b:	6a 04                	push   $0x4
  jmp alltraps
8010600d:	e9 f8 fa ff ff       	jmp    80105b0a <alltraps>

80106012 <vector5>:
.globl vector5
vector5:
  pushl $0
80106012:	6a 00                	push   $0x0
  pushl $5
80106014:	6a 05                	push   $0x5
  jmp alltraps
80106016:	e9 ef fa ff ff       	jmp    80105b0a <alltraps>

8010601b <vector6>:
.globl vector6
vector6:
  pushl $0
8010601b:	6a 00                	push   $0x0
  pushl $6
8010601d:	6a 06                	push   $0x6
  jmp alltraps
8010601f:	e9 e6 fa ff ff       	jmp    80105b0a <alltraps>

80106024 <vector7>:
.globl vector7
vector7:
  pushl $0
80106024:	6a 00                	push   $0x0
  pushl $7
80106026:	6a 07                	push   $0x7
  jmp alltraps
80106028:	e9 dd fa ff ff       	jmp    80105b0a <alltraps>

8010602d <vector8>:
.globl vector8
vector8:
  pushl $8
8010602d:	6a 08                	push   $0x8
  jmp alltraps
8010602f:	e9 d6 fa ff ff       	jmp    80105b0a <alltraps>

80106034 <vector9>:
.globl vector9
vector9:
  pushl $0
80106034:	6a 00                	push   $0x0
  pushl $9
80106036:	6a 09                	push   $0x9
  jmp alltraps
80106038:	e9 cd fa ff ff       	jmp    80105b0a <alltraps>

8010603d <vector10>:
.globl vector10
vector10:
  pushl $10
8010603d:	6a 0a                	push   $0xa
  jmp alltraps
8010603f:	e9 c6 fa ff ff       	jmp    80105b0a <alltraps>

80106044 <vector11>:
.globl vector11
vector11:
  pushl $11
80106044:	6a 0b                	push   $0xb
  jmp alltraps
80106046:	e9 bf fa ff ff       	jmp    80105b0a <alltraps>

8010604b <vector12>:
.globl vector12
vector12:
  pushl $12
8010604b:	6a 0c                	push   $0xc
  jmp alltraps
8010604d:	e9 b8 fa ff ff       	jmp    80105b0a <alltraps>

80106052 <vector13>:
.globl vector13
vector13:
  pushl $13
80106052:	6a 0d                	push   $0xd
  jmp alltraps
80106054:	e9 b1 fa ff ff       	jmp    80105b0a <alltraps>

80106059 <vector14>:
.globl vector14
vector14:
  pushl $14
80106059:	6a 0e                	push   $0xe
  jmp alltraps
8010605b:	e9 aa fa ff ff       	jmp    80105b0a <alltraps>

80106060 <vector15>:
.globl vector15
vector15:
  pushl $0
80106060:	6a 00                	push   $0x0
  pushl $15
80106062:	6a 0f                	push   $0xf
  jmp alltraps
80106064:	e9 a1 fa ff ff       	jmp    80105b0a <alltraps>

80106069 <vector16>:
.globl vector16
vector16:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $16
8010606b:	6a 10                	push   $0x10
  jmp alltraps
8010606d:	e9 98 fa ff ff       	jmp    80105b0a <alltraps>

80106072 <vector17>:
.globl vector17
vector17:
  pushl $17
80106072:	6a 11                	push   $0x11
  jmp alltraps
80106074:	e9 91 fa ff ff       	jmp    80105b0a <alltraps>

80106079 <vector18>:
.globl vector18
vector18:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $18
8010607b:	6a 12                	push   $0x12
  jmp alltraps
8010607d:	e9 88 fa ff ff       	jmp    80105b0a <alltraps>

80106082 <vector19>:
.globl vector19
vector19:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $19
80106084:	6a 13                	push   $0x13
  jmp alltraps
80106086:	e9 7f fa ff ff       	jmp    80105b0a <alltraps>

8010608b <vector20>:
.globl vector20
vector20:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $20
8010608d:	6a 14                	push   $0x14
  jmp alltraps
8010608f:	e9 76 fa ff ff       	jmp    80105b0a <alltraps>

80106094 <vector21>:
.globl vector21
vector21:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $21
80106096:	6a 15                	push   $0x15
  jmp alltraps
80106098:	e9 6d fa ff ff       	jmp    80105b0a <alltraps>

8010609d <vector22>:
.globl vector22
vector22:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $22
8010609f:	6a 16                	push   $0x16
  jmp alltraps
801060a1:	e9 64 fa ff ff       	jmp    80105b0a <alltraps>

801060a6 <vector23>:
.globl vector23
vector23:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $23
801060a8:	6a 17                	push   $0x17
  jmp alltraps
801060aa:	e9 5b fa ff ff       	jmp    80105b0a <alltraps>

801060af <vector24>:
.globl vector24
vector24:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $24
801060b1:	6a 18                	push   $0x18
  jmp alltraps
801060b3:	e9 52 fa ff ff       	jmp    80105b0a <alltraps>

801060b8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $25
801060ba:	6a 19                	push   $0x19
  jmp alltraps
801060bc:	e9 49 fa ff ff       	jmp    80105b0a <alltraps>

801060c1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $26
801060c3:	6a 1a                	push   $0x1a
  jmp alltraps
801060c5:	e9 40 fa ff ff       	jmp    80105b0a <alltraps>

801060ca <vector27>:
.globl vector27
vector27:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $27
801060cc:	6a 1b                	push   $0x1b
  jmp alltraps
801060ce:	e9 37 fa ff ff       	jmp    80105b0a <alltraps>

801060d3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $28
801060d5:	6a 1c                	push   $0x1c
  jmp alltraps
801060d7:	e9 2e fa ff ff       	jmp    80105b0a <alltraps>

801060dc <vector29>:
.globl vector29
vector29:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $29
801060de:	6a 1d                	push   $0x1d
  jmp alltraps
801060e0:	e9 25 fa ff ff       	jmp    80105b0a <alltraps>

801060e5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $30
801060e7:	6a 1e                	push   $0x1e
  jmp alltraps
801060e9:	e9 1c fa ff ff       	jmp    80105b0a <alltraps>

801060ee <vector31>:
.globl vector31
vector31:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $31
801060f0:	6a 1f                	push   $0x1f
  jmp alltraps
801060f2:	e9 13 fa ff ff       	jmp    80105b0a <alltraps>

801060f7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $32
801060f9:	6a 20                	push   $0x20
  jmp alltraps
801060fb:	e9 0a fa ff ff       	jmp    80105b0a <alltraps>

80106100 <vector33>:
.globl vector33
vector33:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $33
80106102:	6a 21                	push   $0x21
  jmp alltraps
80106104:	e9 01 fa ff ff       	jmp    80105b0a <alltraps>

80106109 <vector34>:
.globl vector34
vector34:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $34
8010610b:	6a 22                	push   $0x22
  jmp alltraps
8010610d:	e9 f8 f9 ff ff       	jmp    80105b0a <alltraps>

80106112 <vector35>:
.globl vector35
vector35:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $35
80106114:	6a 23                	push   $0x23
  jmp alltraps
80106116:	e9 ef f9 ff ff       	jmp    80105b0a <alltraps>

8010611b <vector36>:
.globl vector36
vector36:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $36
8010611d:	6a 24                	push   $0x24
  jmp alltraps
8010611f:	e9 e6 f9 ff ff       	jmp    80105b0a <alltraps>

80106124 <vector37>:
.globl vector37
vector37:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $37
80106126:	6a 25                	push   $0x25
  jmp alltraps
80106128:	e9 dd f9 ff ff       	jmp    80105b0a <alltraps>

8010612d <vector38>:
.globl vector38
vector38:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $38
8010612f:	6a 26                	push   $0x26
  jmp alltraps
80106131:	e9 d4 f9 ff ff       	jmp    80105b0a <alltraps>

80106136 <vector39>:
.globl vector39
vector39:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $39
80106138:	6a 27                	push   $0x27
  jmp alltraps
8010613a:	e9 cb f9 ff ff       	jmp    80105b0a <alltraps>

8010613f <vector40>:
.globl vector40
vector40:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $40
80106141:	6a 28                	push   $0x28
  jmp alltraps
80106143:	e9 c2 f9 ff ff       	jmp    80105b0a <alltraps>

80106148 <vector41>:
.globl vector41
vector41:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $41
8010614a:	6a 29                	push   $0x29
  jmp alltraps
8010614c:	e9 b9 f9 ff ff       	jmp    80105b0a <alltraps>

80106151 <vector42>:
.globl vector42
vector42:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $42
80106153:	6a 2a                	push   $0x2a
  jmp alltraps
80106155:	e9 b0 f9 ff ff       	jmp    80105b0a <alltraps>

8010615a <vector43>:
.globl vector43
vector43:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $43
8010615c:	6a 2b                	push   $0x2b
  jmp alltraps
8010615e:	e9 a7 f9 ff ff       	jmp    80105b0a <alltraps>

80106163 <vector44>:
.globl vector44
vector44:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $44
80106165:	6a 2c                	push   $0x2c
  jmp alltraps
80106167:	e9 9e f9 ff ff       	jmp    80105b0a <alltraps>

8010616c <vector45>:
.globl vector45
vector45:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $45
8010616e:	6a 2d                	push   $0x2d
  jmp alltraps
80106170:	e9 95 f9 ff ff       	jmp    80105b0a <alltraps>

80106175 <vector46>:
.globl vector46
vector46:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $46
80106177:	6a 2e                	push   $0x2e
  jmp alltraps
80106179:	e9 8c f9 ff ff       	jmp    80105b0a <alltraps>

8010617e <vector47>:
.globl vector47
vector47:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $47
80106180:	6a 2f                	push   $0x2f
  jmp alltraps
80106182:	e9 83 f9 ff ff       	jmp    80105b0a <alltraps>

80106187 <vector48>:
.globl vector48
vector48:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $48
80106189:	6a 30                	push   $0x30
  jmp alltraps
8010618b:	e9 7a f9 ff ff       	jmp    80105b0a <alltraps>

80106190 <vector49>:
.globl vector49
vector49:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $49
80106192:	6a 31                	push   $0x31
  jmp alltraps
80106194:	e9 71 f9 ff ff       	jmp    80105b0a <alltraps>

80106199 <vector50>:
.globl vector50
vector50:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $50
8010619b:	6a 32                	push   $0x32
  jmp alltraps
8010619d:	e9 68 f9 ff ff       	jmp    80105b0a <alltraps>

801061a2 <vector51>:
.globl vector51
vector51:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $51
801061a4:	6a 33                	push   $0x33
  jmp alltraps
801061a6:	e9 5f f9 ff ff       	jmp    80105b0a <alltraps>

801061ab <vector52>:
.globl vector52
vector52:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $52
801061ad:	6a 34                	push   $0x34
  jmp alltraps
801061af:	e9 56 f9 ff ff       	jmp    80105b0a <alltraps>

801061b4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $53
801061b6:	6a 35                	push   $0x35
  jmp alltraps
801061b8:	e9 4d f9 ff ff       	jmp    80105b0a <alltraps>

801061bd <vector54>:
.globl vector54
vector54:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $54
801061bf:	6a 36                	push   $0x36
  jmp alltraps
801061c1:	e9 44 f9 ff ff       	jmp    80105b0a <alltraps>

801061c6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $55
801061c8:	6a 37                	push   $0x37
  jmp alltraps
801061ca:	e9 3b f9 ff ff       	jmp    80105b0a <alltraps>

801061cf <vector56>:
.globl vector56
vector56:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $56
801061d1:	6a 38                	push   $0x38
  jmp alltraps
801061d3:	e9 32 f9 ff ff       	jmp    80105b0a <alltraps>

801061d8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $57
801061da:	6a 39                	push   $0x39
  jmp alltraps
801061dc:	e9 29 f9 ff ff       	jmp    80105b0a <alltraps>

801061e1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $58
801061e3:	6a 3a                	push   $0x3a
  jmp alltraps
801061e5:	e9 20 f9 ff ff       	jmp    80105b0a <alltraps>

801061ea <vector59>:
.globl vector59
vector59:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $59
801061ec:	6a 3b                	push   $0x3b
  jmp alltraps
801061ee:	e9 17 f9 ff ff       	jmp    80105b0a <alltraps>

801061f3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $60
801061f5:	6a 3c                	push   $0x3c
  jmp alltraps
801061f7:	e9 0e f9 ff ff       	jmp    80105b0a <alltraps>

801061fc <vector61>:
.globl vector61
vector61:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $61
801061fe:	6a 3d                	push   $0x3d
  jmp alltraps
80106200:	e9 05 f9 ff ff       	jmp    80105b0a <alltraps>

80106205 <vector62>:
.globl vector62
vector62:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $62
80106207:	6a 3e                	push   $0x3e
  jmp alltraps
80106209:	e9 fc f8 ff ff       	jmp    80105b0a <alltraps>

8010620e <vector63>:
.globl vector63
vector63:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $63
80106210:	6a 3f                	push   $0x3f
  jmp alltraps
80106212:	e9 f3 f8 ff ff       	jmp    80105b0a <alltraps>

80106217 <vector64>:
.globl vector64
vector64:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $64
80106219:	6a 40                	push   $0x40
  jmp alltraps
8010621b:	e9 ea f8 ff ff       	jmp    80105b0a <alltraps>

80106220 <vector65>:
.globl vector65
vector65:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $65
80106222:	6a 41                	push   $0x41
  jmp alltraps
80106224:	e9 e1 f8 ff ff       	jmp    80105b0a <alltraps>

80106229 <vector66>:
.globl vector66
vector66:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $66
8010622b:	6a 42                	push   $0x42
  jmp alltraps
8010622d:	e9 d8 f8 ff ff       	jmp    80105b0a <alltraps>

80106232 <vector67>:
.globl vector67
vector67:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $67
80106234:	6a 43                	push   $0x43
  jmp alltraps
80106236:	e9 cf f8 ff ff       	jmp    80105b0a <alltraps>

8010623b <vector68>:
.globl vector68
vector68:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $68
8010623d:	6a 44                	push   $0x44
  jmp alltraps
8010623f:	e9 c6 f8 ff ff       	jmp    80105b0a <alltraps>

80106244 <vector69>:
.globl vector69
vector69:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $69
80106246:	6a 45                	push   $0x45
  jmp alltraps
80106248:	e9 bd f8 ff ff       	jmp    80105b0a <alltraps>

8010624d <vector70>:
.globl vector70
vector70:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $70
8010624f:	6a 46                	push   $0x46
  jmp alltraps
80106251:	e9 b4 f8 ff ff       	jmp    80105b0a <alltraps>

80106256 <vector71>:
.globl vector71
vector71:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $71
80106258:	6a 47                	push   $0x47
  jmp alltraps
8010625a:	e9 ab f8 ff ff       	jmp    80105b0a <alltraps>

8010625f <vector72>:
.globl vector72
vector72:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $72
80106261:	6a 48                	push   $0x48
  jmp alltraps
80106263:	e9 a2 f8 ff ff       	jmp    80105b0a <alltraps>

80106268 <vector73>:
.globl vector73
vector73:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $73
8010626a:	6a 49                	push   $0x49
  jmp alltraps
8010626c:	e9 99 f8 ff ff       	jmp    80105b0a <alltraps>

80106271 <vector74>:
.globl vector74
vector74:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $74
80106273:	6a 4a                	push   $0x4a
  jmp alltraps
80106275:	e9 90 f8 ff ff       	jmp    80105b0a <alltraps>

8010627a <vector75>:
.globl vector75
vector75:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $75
8010627c:	6a 4b                	push   $0x4b
  jmp alltraps
8010627e:	e9 87 f8 ff ff       	jmp    80105b0a <alltraps>

80106283 <vector76>:
.globl vector76
vector76:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $76
80106285:	6a 4c                	push   $0x4c
  jmp alltraps
80106287:	e9 7e f8 ff ff       	jmp    80105b0a <alltraps>

8010628c <vector77>:
.globl vector77
vector77:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $77
8010628e:	6a 4d                	push   $0x4d
  jmp alltraps
80106290:	e9 75 f8 ff ff       	jmp    80105b0a <alltraps>

80106295 <vector78>:
.globl vector78
vector78:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $78
80106297:	6a 4e                	push   $0x4e
  jmp alltraps
80106299:	e9 6c f8 ff ff       	jmp    80105b0a <alltraps>

8010629e <vector79>:
.globl vector79
vector79:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $79
801062a0:	6a 4f                	push   $0x4f
  jmp alltraps
801062a2:	e9 63 f8 ff ff       	jmp    80105b0a <alltraps>

801062a7 <vector80>:
.globl vector80
vector80:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $80
801062a9:	6a 50                	push   $0x50
  jmp alltraps
801062ab:	e9 5a f8 ff ff       	jmp    80105b0a <alltraps>

801062b0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $81
801062b2:	6a 51                	push   $0x51
  jmp alltraps
801062b4:	e9 51 f8 ff ff       	jmp    80105b0a <alltraps>

801062b9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $82
801062bb:	6a 52                	push   $0x52
  jmp alltraps
801062bd:	e9 48 f8 ff ff       	jmp    80105b0a <alltraps>

801062c2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $83
801062c4:	6a 53                	push   $0x53
  jmp alltraps
801062c6:	e9 3f f8 ff ff       	jmp    80105b0a <alltraps>

801062cb <vector84>:
.globl vector84
vector84:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $84
801062cd:	6a 54                	push   $0x54
  jmp alltraps
801062cf:	e9 36 f8 ff ff       	jmp    80105b0a <alltraps>

801062d4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $85
801062d6:	6a 55                	push   $0x55
  jmp alltraps
801062d8:	e9 2d f8 ff ff       	jmp    80105b0a <alltraps>

801062dd <vector86>:
.globl vector86
vector86:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $86
801062df:	6a 56                	push   $0x56
  jmp alltraps
801062e1:	e9 24 f8 ff ff       	jmp    80105b0a <alltraps>

801062e6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $87
801062e8:	6a 57                	push   $0x57
  jmp alltraps
801062ea:	e9 1b f8 ff ff       	jmp    80105b0a <alltraps>

801062ef <vector88>:
.globl vector88
vector88:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $88
801062f1:	6a 58                	push   $0x58
  jmp alltraps
801062f3:	e9 12 f8 ff ff       	jmp    80105b0a <alltraps>

801062f8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $89
801062fa:	6a 59                	push   $0x59
  jmp alltraps
801062fc:	e9 09 f8 ff ff       	jmp    80105b0a <alltraps>

80106301 <vector90>:
.globl vector90
vector90:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $90
80106303:	6a 5a                	push   $0x5a
  jmp alltraps
80106305:	e9 00 f8 ff ff       	jmp    80105b0a <alltraps>

8010630a <vector91>:
.globl vector91
vector91:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $91
8010630c:	6a 5b                	push   $0x5b
  jmp alltraps
8010630e:	e9 f7 f7 ff ff       	jmp    80105b0a <alltraps>

80106313 <vector92>:
.globl vector92
vector92:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $92
80106315:	6a 5c                	push   $0x5c
  jmp alltraps
80106317:	e9 ee f7 ff ff       	jmp    80105b0a <alltraps>

8010631c <vector93>:
.globl vector93
vector93:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $93
8010631e:	6a 5d                	push   $0x5d
  jmp alltraps
80106320:	e9 e5 f7 ff ff       	jmp    80105b0a <alltraps>

80106325 <vector94>:
.globl vector94
vector94:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $94
80106327:	6a 5e                	push   $0x5e
  jmp alltraps
80106329:	e9 dc f7 ff ff       	jmp    80105b0a <alltraps>

8010632e <vector95>:
.globl vector95
vector95:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $95
80106330:	6a 5f                	push   $0x5f
  jmp alltraps
80106332:	e9 d3 f7 ff ff       	jmp    80105b0a <alltraps>

80106337 <vector96>:
.globl vector96
vector96:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $96
80106339:	6a 60                	push   $0x60
  jmp alltraps
8010633b:	e9 ca f7 ff ff       	jmp    80105b0a <alltraps>

80106340 <vector97>:
.globl vector97
vector97:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $97
80106342:	6a 61                	push   $0x61
  jmp alltraps
80106344:	e9 c1 f7 ff ff       	jmp    80105b0a <alltraps>

80106349 <vector98>:
.globl vector98
vector98:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $98
8010634b:	6a 62                	push   $0x62
  jmp alltraps
8010634d:	e9 b8 f7 ff ff       	jmp    80105b0a <alltraps>

80106352 <vector99>:
.globl vector99
vector99:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $99
80106354:	6a 63                	push   $0x63
  jmp alltraps
80106356:	e9 af f7 ff ff       	jmp    80105b0a <alltraps>

8010635b <vector100>:
.globl vector100
vector100:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $100
8010635d:	6a 64                	push   $0x64
  jmp alltraps
8010635f:	e9 a6 f7 ff ff       	jmp    80105b0a <alltraps>

80106364 <vector101>:
.globl vector101
vector101:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $101
80106366:	6a 65                	push   $0x65
  jmp alltraps
80106368:	e9 9d f7 ff ff       	jmp    80105b0a <alltraps>

8010636d <vector102>:
.globl vector102
vector102:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $102
8010636f:	6a 66                	push   $0x66
  jmp alltraps
80106371:	e9 94 f7 ff ff       	jmp    80105b0a <alltraps>

80106376 <vector103>:
.globl vector103
vector103:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $103
80106378:	6a 67                	push   $0x67
  jmp alltraps
8010637a:	e9 8b f7 ff ff       	jmp    80105b0a <alltraps>

8010637f <vector104>:
.globl vector104
vector104:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $104
80106381:	6a 68                	push   $0x68
  jmp alltraps
80106383:	e9 82 f7 ff ff       	jmp    80105b0a <alltraps>

80106388 <vector105>:
.globl vector105
vector105:
  pushl $0
80106388:	6a 00                	push   $0x0
  pushl $105
8010638a:	6a 69                	push   $0x69
  jmp alltraps
8010638c:	e9 79 f7 ff ff       	jmp    80105b0a <alltraps>

80106391 <vector106>:
.globl vector106
vector106:
  pushl $0
80106391:	6a 00                	push   $0x0
  pushl $106
80106393:	6a 6a                	push   $0x6a
  jmp alltraps
80106395:	e9 70 f7 ff ff       	jmp    80105b0a <alltraps>

8010639a <vector107>:
.globl vector107
vector107:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $107
8010639c:	6a 6b                	push   $0x6b
  jmp alltraps
8010639e:	e9 67 f7 ff ff       	jmp    80105b0a <alltraps>

801063a3 <vector108>:
.globl vector108
vector108:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $108
801063a5:	6a 6c                	push   $0x6c
  jmp alltraps
801063a7:	e9 5e f7 ff ff       	jmp    80105b0a <alltraps>

801063ac <vector109>:
.globl vector109
vector109:
  pushl $0
801063ac:	6a 00                	push   $0x0
  pushl $109
801063ae:	6a 6d                	push   $0x6d
  jmp alltraps
801063b0:	e9 55 f7 ff ff       	jmp    80105b0a <alltraps>

801063b5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063b5:	6a 00                	push   $0x0
  pushl $110
801063b7:	6a 6e                	push   $0x6e
  jmp alltraps
801063b9:	e9 4c f7 ff ff       	jmp    80105b0a <alltraps>

801063be <vector111>:
.globl vector111
vector111:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $111
801063c0:	6a 6f                	push   $0x6f
  jmp alltraps
801063c2:	e9 43 f7 ff ff       	jmp    80105b0a <alltraps>

801063c7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $112
801063c9:	6a 70                	push   $0x70
  jmp alltraps
801063cb:	e9 3a f7 ff ff       	jmp    80105b0a <alltraps>

801063d0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063d0:	6a 00                	push   $0x0
  pushl $113
801063d2:	6a 71                	push   $0x71
  jmp alltraps
801063d4:	e9 31 f7 ff ff       	jmp    80105b0a <alltraps>

801063d9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063d9:	6a 00                	push   $0x0
  pushl $114
801063db:	6a 72                	push   $0x72
  jmp alltraps
801063dd:	e9 28 f7 ff ff       	jmp    80105b0a <alltraps>

801063e2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $115
801063e4:	6a 73                	push   $0x73
  jmp alltraps
801063e6:	e9 1f f7 ff ff       	jmp    80105b0a <alltraps>

801063eb <vector116>:
.globl vector116
vector116:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $116
801063ed:	6a 74                	push   $0x74
  jmp alltraps
801063ef:	e9 16 f7 ff ff       	jmp    80105b0a <alltraps>

801063f4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063f4:	6a 00                	push   $0x0
  pushl $117
801063f6:	6a 75                	push   $0x75
  jmp alltraps
801063f8:	e9 0d f7 ff ff       	jmp    80105b0a <alltraps>

801063fd <vector118>:
.globl vector118
vector118:
  pushl $0
801063fd:	6a 00                	push   $0x0
  pushl $118
801063ff:	6a 76                	push   $0x76
  jmp alltraps
80106401:	e9 04 f7 ff ff       	jmp    80105b0a <alltraps>

80106406 <vector119>:
.globl vector119
vector119:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $119
80106408:	6a 77                	push   $0x77
  jmp alltraps
8010640a:	e9 fb f6 ff ff       	jmp    80105b0a <alltraps>

8010640f <vector120>:
.globl vector120
vector120:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $120
80106411:	6a 78                	push   $0x78
  jmp alltraps
80106413:	e9 f2 f6 ff ff       	jmp    80105b0a <alltraps>

80106418 <vector121>:
.globl vector121
vector121:
  pushl $0
80106418:	6a 00                	push   $0x0
  pushl $121
8010641a:	6a 79                	push   $0x79
  jmp alltraps
8010641c:	e9 e9 f6 ff ff       	jmp    80105b0a <alltraps>

80106421 <vector122>:
.globl vector122
vector122:
  pushl $0
80106421:	6a 00                	push   $0x0
  pushl $122
80106423:	6a 7a                	push   $0x7a
  jmp alltraps
80106425:	e9 e0 f6 ff ff       	jmp    80105b0a <alltraps>

8010642a <vector123>:
.globl vector123
vector123:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $123
8010642c:	6a 7b                	push   $0x7b
  jmp alltraps
8010642e:	e9 d7 f6 ff ff       	jmp    80105b0a <alltraps>

80106433 <vector124>:
.globl vector124
vector124:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $124
80106435:	6a 7c                	push   $0x7c
  jmp alltraps
80106437:	e9 ce f6 ff ff       	jmp    80105b0a <alltraps>

8010643c <vector125>:
.globl vector125
vector125:
  pushl $0
8010643c:	6a 00                	push   $0x0
  pushl $125
8010643e:	6a 7d                	push   $0x7d
  jmp alltraps
80106440:	e9 c5 f6 ff ff       	jmp    80105b0a <alltraps>

80106445 <vector126>:
.globl vector126
vector126:
  pushl $0
80106445:	6a 00                	push   $0x0
  pushl $126
80106447:	6a 7e                	push   $0x7e
  jmp alltraps
80106449:	e9 bc f6 ff ff       	jmp    80105b0a <alltraps>

8010644e <vector127>:
.globl vector127
vector127:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $127
80106450:	6a 7f                	push   $0x7f
  jmp alltraps
80106452:	e9 b3 f6 ff ff       	jmp    80105b0a <alltraps>

80106457 <vector128>:
.globl vector128
vector128:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $128
80106459:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010645e:	e9 a7 f6 ff ff       	jmp    80105b0a <alltraps>

80106463 <vector129>:
.globl vector129
vector129:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $129
80106465:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010646a:	e9 9b f6 ff ff       	jmp    80105b0a <alltraps>

8010646f <vector130>:
.globl vector130
vector130:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $130
80106471:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106476:	e9 8f f6 ff ff       	jmp    80105b0a <alltraps>

8010647b <vector131>:
.globl vector131
vector131:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $131
8010647d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106482:	e9 83 f6 ff ff       	jmp    80105b0a <alltraps>

80106487 <vector132>:
.globl vector132
vector132:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $132
80106489:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010648e:	e9 77 f6 ff ff       	jmp    80105b0a <alltraps>

80106493 <vector133>:
.globl vector133
vector133:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $133
80106495:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010649a:	e9 6b f6 ff ff       	jmp    80105b0a <alltraps>

8010649f <vector134>:
.globl vector134
vector134:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $134
801064a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801064a6:	e9 5f f6 ff ff       	jmp    80105b0a <alltraps>

801064ab <vector135>:
.globl vector135
vector135:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $135
801064ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064b2:	e9 53 f6 ff ff       	jmp    80105b0a <alltraps>

801064b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $136
801064b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064be:	e9 47 f6 ff ff       	jmp    80105b0a <alltraps>

801064c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $137
801064c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064ca:	e9 3b f6 ff ff       	jmp    80105b0a <alltraps>

801064cf <vector138>:
.globl vector138
vector138:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $138
801064d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064d6:	e9 2f f6 ff ff       	jmp    80105b0a <alltraps>

801064db <vector139>:
.globl vector139
vector139:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $139
801064dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064e2:	e9 23 f6 ff ff       	jmp    80105b0a <alltraps>

801064e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $140
801064e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064ee:	e9 17 f6 ff ff       	jmp    80105b0a <alltraps>

801064f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $141
801064f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064fa:	e9 0b f6 ff ff       	jmp    80105b0a <alltraps>

801064ff <vector142>:
.globl vector142
vector142:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $142
80106501:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106506:	e9 ff f5 ff ff       	jmp    80105b0a <alltraps>

8010650b <vector143>:
.globl vector143
vector143:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $143
8010650d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106512:	e9 f3 f5 ff ff       	jmp    80105b0a <alltraps>

80106517 <vector144>:
.globl vector144
vector144:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $144
80106519:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010651e:	e9 e7 f5 ff ff       	jmp    80105b0a <alltraps>

80106523 <vector145>:
.globl vector145
vector145:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $145
80106525:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010652a:	e9 db f5 ff ff       	jmp    80105b0a <alltraps>

8010652f <vector146>:
.globl vector146
vector146:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $146
80106531:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106536:	e9 cf f5 ff ff       	jmp    80105b0a <alltraps>

8010653b <vector147>:
.globl vector147
vector147:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $147
8010653d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106542:	e9 c3 f5 ff ff       	jmp    80105b0a <alltraps>

80106547 <vector148>:
.globl vector148
vector148:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $148
80106549:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010654e:	e9 b7 f5 ff ff       	jmp    80105b0a <alltraps>

80106553 <vector149>:
.globl vector149
vector149:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $149
80106555:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010655a:	e9 ab f5 ff ff       	jmp    80105b0a <alltraps>

8010655f <vector150>:
.globl vector150
vector150:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $150
80106561:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106566:	e9 9f f5 ff ff       	jmp    80105b0a <alltraps>

8010656b <vector151>:
.globl vector151
vector151:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $151
8010656d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106572:	e9 93 f5 ff ff       	jmp    80105b0a <alltraps>

80106577 <vector152>:
.globl vector152
vector152:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $152
80106579:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010657e:	e9 87 f5 ff ff       	jmp    80105b0a <alltraps>

80106583 <vector153>:
.globl vector153
vector153:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $153
80106585:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010658a:	e9 7b f5 ff ff       	jmp    80105b0a <alltraps>

8010658f <vector154>:
.globl vector154
vector154:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $154
80106591:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106596:	e9 6f f5 ff ff       	jmp    80105b0a <alltraps>

8010659b <vector155>:
.globl vector155
vector155:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $155
8010659d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801065a2:	e9 63 f5 ff ff       	jmp    80105b0a <alltraps>

801065a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $156
801065a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801065ae:	e9 57 f5 ff ff       	jmp    80105b0a <alltraps>

801065b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $157
801065b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065ba:	e9 4b f5 ff ff       	jmp    80105b0a <alltraps>

801065bf <vector158>:
.globl vector158
vector158:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $158
801065c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065c6:	e9 3f f5 ff ff       	jmp    80105b0a <alltraps>

801065cb <vector159>:
.globl vector159
vector159:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $159
801065cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065d2:	e9 33 f5 ff ff       	jmp    80105b0a <alltraps>

801065d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $160
801065d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065de:	e9 27 f5 ff ff       	jmp    80105b0a <alltraps>

801065e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $161
801065e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065ea:	e9 1b f5 ff ff       	jmp    80105b0a <alltraps>

801065ef <vector162>:
.globl vector162
vector162:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $162
801065f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065f6:	e9 0f f5 ff ff       	jmp    80105b0a <alltraps>

801065fb <vector163>:
.globl vector163
vector163:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $163
801065fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106602:	e9 03 f5 ff ff       	jmp    80105b0a <alltraps>

80106607 <vector164>:
.globl vector164
vector164:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $164
80106609:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010660e:	e9 f7 f4 ff ff       	jmp    80105b0a <alltraps>

80106613 <vector165>:
.globl vector165
vector165:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $165
80106615:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010661a:	e9 eb f4 ff ff       	jmp    80105b0a <alltraps>

8010661f <vector166>:
.globl vector166
vector166:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $166
80106621:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106626:	e9 df f4 ff ff       	jmp    80105b0a <alltraps>

8010662b <vector167>:
.globl vector167
vector167:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $167
8010662d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106632:	e9 d3 f4 ff ff       	jmp    80105b0a <alltraps>

80106637 <vector168>:
.globl vector168
vector168:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $168
80106639:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010663e:	e9 c7 f4 ff ff       	jmp    80105b0a <alltraps>

80106643 <vector169>:
.globl vector169
vector169:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $169
80106645:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010664a:	e9 bb f4 ff ff       	jmp    80105b0a <alltraps>

8010664f <vector170>:
.globl vector170
vector170:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $170
80106651:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106656:	e9 af f4 ff ff       	jmp    80105b0a <alltraps>

8010665b <vector171>:
.globl vector171
vector171:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $171
8010665d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106662:	e9 a3 f4 ff ff       	jmp    80105b0a <alltraps>

80106667 <vector172>:
.globl vector172
vector172:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $172
80106669:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010666e:	e9 97 f4 ff ff       	jmp    80105b0a <alltraps>

80106673 <vector173>:
.globl vector173
vector173:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $173
80106675:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010667a:	e9 8b f4 ff ff       	jmp    80105b0a <alltraps>

8010667f <vector174>:
.globl vector174
vector174:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $174
80106681:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106686:	e9 7f f4 ff ff       	jmp    80105b0a <alltraps>

8010668b <vector175>:
.globl vector175
vector175:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $175
8010668d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106692:	e9 73 f4 ff ff       	jmp    80105b0a <alltraps>

80106697 <vector176>:
.globl vector176
vector176:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $176
80106699:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010669e:	e9 67 f4 ff ff       	jmp    80105b0a <alltraps>

801066a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $177
801066a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801066aa:	e9 5b f4 ff ff       	jmp    80105b0a <alltraps>

801066af <vector178>:
.globl vector178
vector178:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $178
801066b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066b6:	e9 4f f4 ff ff       	jmp    80105b0a <alltraps>

801066bb <vector179>:
.globl vector179
vector179:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $179
801066bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066c2:	e9 43 f4 ff ff       	jmp    80105b0a <alltraps>

801066c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $180
801066c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066ce:	e9 37 f4 ff ff       	jmp    80105b0a <alltraps>

801066d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $181
801066d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066da:	e9 2b f4 ff ff       	jmp    80105b0a <alltraps>

801066df <vector182>:
.globl vector182
vector182:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $182
801066e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066e6:	e9 1f f4 ff ff       	jmp    80105b0a <alltraps>

801066eb <vector183>:
.globl vector183
vector183:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $183
801066ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066f2:	e9 13 f4 ff ff       	jmp    80105b0a <alltraps>

801066f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $184
801066f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066fe:	e9 07 f4 ff ff       	jmp    80105b0a <alltraps>

80106703 <vector185>:
.globl vector185
vector185:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $185
80106705:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010670a:	e9 fb f3 ff ff       	jmp    80105b0a <alltraps>

8010670f <vector186>:
.globl vector186
vector186:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $186
80106711:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106716:	e9 ef f3 ff ff       	jmp    80105b0a <alltraps>

8010671b <vector187>:
.globl vector187
vector187:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $187
8010671d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106722:	e9 e3 f3 ff ff       	jmp    80105b0a <alltraps>

80106727 <vector188>:
.globl vector188
vector188:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $188
80106729:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010672e:	e9 d7 f3 ff ff       	jmp    80105b0a <alltraps>

80106733 <vector189>:
.globl vector189
vector189:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $189
80106735:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010673a:	e9 cb f3 ff ff       	jmp    80105b0a <alltraps>

8010673f <vector190>:
.globl vector190
vector190:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $190
80106741:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106746:	e9 bf f3 ff ff       	jmp    80105b0a <alltraps>

8010674b <vector191>:
.globl vector191
vector191:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $191
8010674d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106752:	e9 b3 f3 ff ff       	jmp    80105b0a <alltraps>

80106757 <vector192>:
.globl vector192
vector192:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $192
80106759:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010675e:	e9 a7 f3 ff ff       	jmp    80105b0a <alltraps>

80106763 <vector193>:
.globl vector193
vector193:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $193
80106765:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010676a:	e9 9b f3 ff ff       	jmp    80105b0a <alltraps>

8010676f <vector194>:
.globl vector194
vector194:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $194
80106771:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106776:	e9 8f f3 ff ff       	jmp    80105b0a <alltraps>

8010677b <vector195>:
.globl vector195
vector195:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $195
8010677d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106782:	e9 83 f3 ff ff       	jmp    80105b0a <alltraps>

80106787 <vector196>:
.globl vector196
vector196:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $196
80106789:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010678e:	e9 77 f3 ff ff       	jmp    80105b0a <alltraps>

80106793 <vector197>:
.globl vector197
vector197:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $197
80106795:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010679a:	e9 6b f3 ff ff       	jmp    80105b0a <alltraps>

8010679f <vector198>:
.globl vector198
vector198:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $198
801067a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801067a6:	e9 5f f3 ff ff       	jmp    80105b0a <alltraps>

801067ab <vector199>:
.globl vector199
vector199:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $199
801067ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067b2:	e9 53 f3 ff ff       	jmp    80105b0a <alltraps>

801067b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $200
801067b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067be:	e9 47 f3 ff ff       	jmp    80105b0a <alltraps>

801067c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $201
801067c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067ca:	e9 3b f3 ff ff       	jmp    80105b0a <alltraps>

801067cf <vector202>:
.globl vector202
vector202:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $202
801067d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067d6:	e9 2f f3 ff ff       	jmp    80105b0a <alltraps>

801067db <vector203>:
.globl vector203
vector203:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $203
801067dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067e2:	e9 23 f3 ff ff       	jmp    80105b0a <alltraps>

801067e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $204
801067e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067ee:	e9 17 f3 ff ff       	jmp    80105b0a <alltraps>

801067f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $205
801067f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067fa:	e9 0b f3 ff ff       	jmp    80105b0a <alltraps>

801067ff <vector206>:
.globl vector206
vector206:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $206
80106801:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106806:	e9 ff f2 ff ff       	jmp    80105b0a <alltraps>

8010680b <vector207>:
.globl vector207
vector207:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $207
8010680d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106812:	e9 f3 f2 ff ff       	jmp    80105b0a <alltraps>

80106817 <vector208>:
.globl vector208
vector208:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $208
80106819:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010681e:	e9 e7 f2 ff ff       	jmp    80105b0a <alltraps>

80106823 <vector209>:
.globl vector209
vector209:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $209
80106825:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010682a:	e9 db f2 ff ff       	jmp    80105b0a <alltraps>

8010682f <vector210>:
.globl vector210
vector210:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $210
80106831:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106836:	e9 cf f2 ff ff       	jmp    80105b0a <alltraps>

8010683b <vector211>:
.globl vector211
vector211:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $211
8010683d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106842:	e9 c3 f2 ff ff       	jmp    80105b0a <alltraps>

80106847 <vector212>:
.globl vector212
vector212:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $212
80106849:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010684e:	e9 b7 f2 ff ff       	jmp    80105b0a <alltraps>

80106853 <vector213>:
.globl vector213
vector213:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $213
80106855:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010685a:	e9 ab f2 ff ff       	jmp    80105b0a <alltraps>

8010685f <vector214>:
.globl vector214
vector214:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $214
80106861:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106866:	e9 9f f2 ff ff       	jmp    80105b0a <alltraps>

8010686b <vector215>:
.globl vector215
vector215:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $215
8010686d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106872:	e9 93 f2 ff ff       	jmp    80105b0a <alltraps>

80106877 <vector216>:
.globl vector216
vector216:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $216
80106879:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010687e:	e9 87 f2 ff ff       	jmp    80105b0a <alltraps>

80106883 <vector217>:
.globl vector217
vector217:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $217
80106885:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010688a:	e9 7b f2 ff ff       	jmp    80105b0a <alltraps>

8010688f <vector218>:
.globl vector218
vector218:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $218
80106891:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106896:	e9 6f f2 ff ff       	jmp    80105b0a <alltraps>

8010689b <vector219>:
.globl vector219
vector219:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $219
8010689d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801068a2:	e9 63 f2 ff ff       	jmp    80105b0a <alltraps>

801068a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $220
801068a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801068ae:	e9 57 f2 ff ff       	jmp    80105b0a <alltraps>

801068b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $221
801068b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068ba:	e9 4b f2 ff ff       	jmp    80105b0a <alltraps>

801068bf <vector222>:
.globl vector222
vector222:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $222
801068c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068c6:	e9 3f f2 ff ff       	jmp    80105b0a <alltraps>

801068cb <vector223>:
.globl vector223
vector223:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $223
801068cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068d2:	e9 33 f2 ff ff       	jmp    80105b0a <alltraps>

801068d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $224
801068d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068de:	e9 27 f2 ff ff       	jmp    80105b0a <alltraps>

801068e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $225
801068e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068ea:	e9 1b f2 ff ff       	jmp    80105b0a <alltraps>

801068ef <vector226>:
.globl vector226
vector226:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $226
801068f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068f6:	e9 0f f2 ff ff       	jmp    80105b0a <alltraps>

801068fb <vector227>:
.globl vector227
vector227:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $227
801068fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106902:	e9 03 f2 ff ff       	jmp    80105b0a <alltraps>

80106907 <vector228>:
.globl vector228
vector228:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $228
80106909:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010690e:	e9 f7 f1 ff ff       	jmp    80105b0a <alltraps>

80106913 <vector229>:
.globl vector229
vector229:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $229
80106915:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010691a:	e9 eb f1 ff ff       	jmp    80105b0a <alltraps>

8010691f <vector230>:
.globl vector230
vector230:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $230
80106921:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106926:	e9 df f1 ff ff       	jmp    80105b0a <alltraps>

8010692b <vector231>:
.globl vector231
vector231:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $231
8010692d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106932:	e9 d3 f1 ff ff       	jmp    80105b0a <alltraps>

80106937 <vector232>:
.globl vector232
vector232:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $232
80106939:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010693e:	e9 c7 f1 ff ff       	jmp    80105b0a <alltraps>

80106943 <vector233>:
.globl vector233
vector233:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $233
80106945:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010694a:	e9 bb f1 ff ff       	jmp    80105b0a <alltraps>

8010694f <vector234>:
.globl vector234
vector234:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $234
80106951:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106956:	e9 af f1 ff ff       	jmp    80105b0a <alltraps>

8010695b <vector235>:
.globl vector235
vector235:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $235
8010695d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106962:	e9 a3 f1 ff ff       	jmp    80105b0a <alltraps>

80106967 <vector236>:
.globl vector236
vector236:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $236
80106969:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010696e:	e9 97 f1 ff ff       	jmp    80105b0a <alltraps>

80106973 <vector237>:
.globl vector237
vector237:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $237
80106975:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010697a:	e9 8b f1 ff ff       	jmp    80105b0a <alltraps>

8010697f <vector238>:
.globl vector238
vector238:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $238
80106981:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106986:	e9 7f f1 ff ff       	jmp    80105b0a <alltraps>

8010698b <vector239>:
.globl vector239
vector239:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $239
8010698d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106992:	e9 73 f1 ff ff       	jmp    80105b0a <alltraps>

80106997 <vector240>:
.globl vector240
vector240:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $240
80106999:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010699e:	e9 67 f1 ff ff       	jmp    80105b0a <alltraps>

801069a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $241
801069a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801069aa:	e9 5b f1 ff ff       	jmp    80105b0a <alltraps>

801069af <vector242>:
.globl vector242
vector242:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $242
801069b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069b6:	e9 4f f1 ff ff       	jmp    80105b0a <alltraps>

801069bb <vector243>:
.globl vector243
vector243:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $243
801069bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069c2:	e9 43 f1 ff ff       	jmp    80105b0a <alltraps>

801069c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $244
801069c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069ce:	e9 37 f1 ff ff       	jmp    80105b0a <alltraps>

801069d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $245
801069d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069da:	e9 2b f1 ff ff       	jmp    80105b0a <alltraps>

801069df <vector246>:
.globl vector246
vector246:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $246
801069e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069e6:	e9 1f f1 ff ff       	jmp    80105b0a <alltraps>

801069eb <vector247>:
.globl vector247
vector247:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $247
801069ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069f2:	e9 13 f1 ff ff       	jmp    80105b0a <alltraps>

801069f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $248
801069f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069fe:	e9 07 f1 ff ff       	jmp    80105b0a <alltraps>

80106a03 <vector249>:
.globl vector249
vector249:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $249
80106a05:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106a0a:	e9 fb f0 ff ff       	jmp    80105b0a <alltraps>

80106a0f <vector250>:
.globl vector250
vector250:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $250
80106a11:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a16:	e9 ef f0 ff ff       	jmp    80105b0a <alltraps>

80106a1b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $251
80106a1d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a22:	e9 e3 f0 ff ff       	jmp    80105b0a <alltraps>

80106a27 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $252
80106a29:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a2e:	e9 d7 f0 ff ff       	jmp    80105b0a <alltraps>

80106a33 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $253
80106a35:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a3a:	e9 cb f0 ff ff       	jmp    80105b0a <alltraps>

80106a3f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $254
80106a41:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a46:	e9 bf f0 ff ff       	jmp    80105b0a <alltraps>

80106a4b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $255
80106a4d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a52:	e9 b3 f0 ff ff       	jmp    80105b0a <alltraps>
80106a57:	66 90                	xchg   %ax,%ax
80106a59:	66 90                	xchg   %ax,%ax
80106a5b:	66 90                	xchg   %ax,%ax
80106a5d:	66 90                	xchg   %ax,%ax
80106a5f:	90                   	nop

80106a60 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a66:	89 d3                	mov    %edx,%ebx
{
80106a68:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106a6a:	c1 eb 16             	shr    $0x16,%ebx
80106a6d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106a70:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106a73:	8b 06                	mov    (%esi),%eax
80106a75:	a8 01                	test   $0x1,%al
80106a77:	74 27                	je     80106aa0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a79:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a7e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a84:	c1 ef 0a             	shr    $0xa,%edi
}
80106a87:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a8a:	89 fa                	mov    %edi,%edx
80106a8c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a92:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106a95:	5b                   	pop    %ebx
80106a96:	5e                   	pop    %esi
80106a97:	5f                   	pop    %edi
80106a98:	5d                   	pop    %ebp
80106a99:	c3                   	ret    
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106aa0:	85 c9                	test   %ecx,%ecx
80106aa2:	74 2c                	je     80106ad0 <walkpgdir+0x70>
80106aa4:	e8 17 be ff ff       	call   801028c0 <kalloc>
80106aa9:	85 c0                	test   %eax,%eax
80106aab:	89 c3                	mov    %eax,%ebx
80106aad:	74 21                	je     80106ad0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106aaf:	83 ec 04             	sub    $0x4,%esp
80106ab2:	68 00 10 00 00       	push   $0x1000
80106ab7:	6a 00                	push   $0x0
80106ab9:	50                   	push   %eax
80106aba:	e8 b1 dd ff ff       	call   80104870 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106abf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ac5:	83 c4 10             	add    $0x10,%esp
80106ac8:	83 c8 07             	or     $0x7,%eax
80106acb:	89 06                	mov    %eax,(%esi)
80106acd:	eb b5                	jmp    80106a84 <walkpgdir+0x24>
80106acf:	90                   	nop
}
80106ad0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ad3:	31 c0                	xor    %eax,%eax
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ae0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ae6:	89 d3                	mov    %edx,%ebx
80106ae8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106aee:	83 ec 1c             	sub    $0x1c,%esp
80106af1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106af4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106af8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106afb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106b03:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b06:	29 df                	sub    %ebx,%edi
80106b08:	83 c8 01             	or     $0x1,%eax
80106b0b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106b0e:	eb 15                	jmp    80106b25 <mappages+0x45>
    if(*pte & PTE_P)
80106b10:	f6 00 01             	testb  $0x1,(%eax)
80106b13:	75 45                	jne    80106b5a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b15:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b18:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b1b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b1d:	74 31                	je     80106b50 <mappages+0x70>
      break;
    a += PGSIZE;
80106b1f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b28:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b2d:	89 da                	mov    %ebx,%edx
80106b2f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b32:	e8 29 ff ff ff       	call   80106a60 <walkpgdir>
80106b37:	85 c0                	test   %eax,%eax
80106b39:	75 d5                	jne    80106b10 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b43:	5b                   	pop    %ebx
80106b44:	5e                   	pop    %esi
80106b45:	5f                   	pop    %edi
80106b46:	5d                   	pop    %ebp
80106b47:	c3                   	ret    
80106b48:	90                   	nop
80106b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b53:	31 c0                	xor    %eax,%eax
}
80106b55:	5b                   	pop    %ebx
80106b56:	5e                   	pop    %esi
80106b57:	5f                   	pop    %edi
80106b58:	5d                   	pop    %ebp
80106b59:	c3                   	ret    
      panic("remap");
80106b5a:	83 ec 0c             	sub    $0xc,%esp
80106b5d:	68 30 7e 10 80       	push   $0x80107e30
80106b62:	e8 29 98 ff ff       	call   80100390 <panic>
80106b67:	89 f6                	mov    %esi,%esi
80106b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b70:	55                   	push   %ebp
80106b71:	89 e5                	mov    %esp,%ebp
80106b73:	57                   	push   %edi
80106b74:	56                   	push   %esi
80106b75:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b76:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b7c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106b7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b84:	83 ec 1c             	sub    $0x1c,%esp
80106b87:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b8a:	39 d3                	cmp    %edx,%ebx
80106b8c:	73 66                	jae    80106bf4 <deallocuvm.part.0+0x84>
80106b8e:	89 d6                	mov    %edx,%esi
80106b90:	eb 3d                	jmp    80106bcf <deallocuvm.part.0+0x5f>
80106b92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106b98:	8b 10                	mov    (%eax),%edx
80106b9a:	f6 c2 01             	test   $0x1,%dl
80106b9d:	74 26                	je     80106bc5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b9f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ba5:	74 58                	je     80106bff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106ba7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106baa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106bb0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106bb3:	52                   	push   %edx
80106bb4:	e8 57 bb ff ff       	call   80102710 <kfree>
      *pte = 0;
80106bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bbc:	83 c4 10             	add    $0x10,%esp
80106bbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106bc5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bcb:	39 f3                	cmp    %esi,%ebx
80106bcd:	73 25                	jae    80106bf4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bcf:	31 c9                	xor    %ecx,%ecx
80106bd1:	89 da                	mov    %ebx,%edx
80106bd3:	89 f8                	mov    %edi,%eax
80106bd5:	e8 86 fe ff ff       	call   80106a60 <walkpgdir>
    if(!pte)
80106bda:	85 c0                	test   %eax,%eax
80106bdc:	75 ba                	jne    80106b98 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bde:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106be4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106bea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bf0:	39 f3                	cmp    %esi,%ebx
80106bf2:	72 db                	jb     80106bcf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106bf4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106bf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bfa:	5b                   	pop    %ebx
80106bfb:	5e                   	pop    %esi
80106bfc:	5f                   	pop    %edi
80106bfd:	5d                   	pop    %ebp
80106bfe:	c3                   	ret    
        panic("kfree");
80106bff:	83 ec 0c             	sub    $0xc,%esp
80106c02:	68 c2 77 10 80       	push   $0x801077c2
80106c07:	e8 84 97 ff ff       	call   80100390 <panic>
80106c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c10 <seginit>:
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c16:	e8 a5 cf ff ff       	call   80103bc0 <cpuid>
80106c1b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c21:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c26:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c2a:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
80106c31:	ff 00 00 
80106c34:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
80106c3b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c3e:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
80106c45:	ff 00 00 
80106c48:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
80106c4f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c52:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
80106c59:	ff 00 00 
80106c5c:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
80106c63:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c66:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
80106c6d:	ff 00 00 
80106c70:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
80106c77:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c7a:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
80106c7f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c83:	c1 e8 10             	shr    $0x10,%eax
80106c86:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c8a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c8d:	0f 01 10             	lgdtl  (%eax)
}
80106c90:	c9                   	leave  
80106c91:	c3                   	ret    
80106c92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ca0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ca0:	a1 c4 54 11 80       	mov    0x801154c4,%eax
{
80106ca5:	55                   	push   %ebp
80106ca6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ca8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cad:	0f 22 d8             	mov    %eax,%cr3
}
80106cb0:	5d                   	pop    %ebp
80106cb1:	c3                   	ret    
80106cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cc0 <switchuvm>:
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 1c             	sub    $0x1c,%esp
80106cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106ccc:	85 db                	test   %ebx,%ebx
80106cce:	0f 84 cb 00 00 00    	je     80106d9f <switchuvm+0xdf>
  if(p->kstack == 0)
80106cd4:	8b 43 08             	mov    0x8(%ebx),%eax
80106cd7:	85 c0                	test   %eax,%eax
80106cd9:	0f 84 da 00 00 00    	je     80106db9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106cdf:	8b 43 04             	mov    0x4(%ebx),%eax
80106ce2:	85 c0                	test   %eax,%eax
80106ce4:	0f 84 c2 00 00 00    	je     80106dac <switchuvm+0xec>
  pushcli();
80106cea:	e8 a1 d9 ff ff       	call   80104690 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cef:	e8 4c ce ff ff       	call   80103b40 <mycpu>
80106cf4:	89 c6                	mov    %eax,%esi
80106cf6:	e8 45 ce ff ff       	call   80103b40 <mycpu>
80106cfb:	89 c7                	mov    %eax,%edi
80106cfd:	e8 3e ce ff ff       	call   80103b40 <mycpu>
80106d02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d05:	83 c7 08             	add    $0x8,%edi
80106d08:	e8 33 ce ff ff       	call   80103b40 <mycpu>
80106d0d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d10:	83 c0 08             	add    $0x8,%eax
80106d13:	ba 67 00 00 00       	mov    $0x67,%edx
80106d18:	c1 e8 18             	shr    $0x18,%eax
80106d1b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d22:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d29:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d2f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d34:	83 c1 08             	add    $0x8,%ecx
80106d37:	c1 e9 10             	shr    $0x10,%ecx
80106d3a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d40:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d45:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d4c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106d51:	e8 ea cd ff ff       	call   80103b40 <mycpu>
80106d56:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d5d:	e8 de cd ff ff       	call   80103b40 <mycpu>
80106d62:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d66:	8b 73 08             	mov    0x8(%ebx),%esi
80106d69:	e8 d2 cd ff ff       	call   80103b40 <mycpu>
80106d6e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d74:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d77:	e8 c4 cd ff ff       	call   80103b40 <mycpu>
80106d7c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d80:	b8 28 00 00 00       	mov    $0x28,%eax
80106d85:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d88:	8b 43 04             	mov    0x4(%ebx),%eax
80106d8b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d90:	0f 22 d8             	mov    %eax,%cr3
}
80106d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d96:	5b                   	pop    %ebx
80106d97:	5e                   	pop    %esi
80106d98:	5f                   	pop    %edi
80106d99:	5d                   	pop    %ebp
  popcli();
80106d9a:	e9 31 d9 ff ff       	jmp    801046d0 <popcli>
    panic("switchuvm: no process");
80106d9f:	83 ec 0c             	sub    $0xc,%esp
80106da2:	68 36 7e 10 80       	push   $0x80107e36
80106da7:	e8 e4 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106dac:	83 ec 0c             	sub    $0xc,%esp
80106daf:	68 61 7e 10 80       	push   $0x80107e61
80106db4:	e8 d7 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106db9:	83 ec 0c             	sub    $0xc,%esp
80106dbc:	68 4c 7e 10 80       	push   $0x80107e4c
80106dc1:	e8 ca 95 ff ff       	call   80100390 <panic>
80106dc6:	8d 76 00             	lea    0x0(%esi),%esi
80106dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dd0 <inituvm>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
80106dd9:	8b 75 10             	mov    0x10(%ebp),%esi
80106ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106de2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106de8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106deb:	77 49                	ja     80106e36 <inituvm+0x66>
  mem = kalloc();
80106ded:	e8 ce ba ff ff       	call   801028c0 <kalloc>
  memset(mem, 0, PGSIZE);
80106df2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106df5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106df7:	68 00 10 00 00       	push   $0x1000
80106dfc:	6a 00                	push   $0x0
80106dfe:	50                   	push   %eax
80106dff:	e8 6c da ff ff       	call   80104870 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e04:	58                   	pop    %eax
80106e05:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e0b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e10:	5a                   	pop    %edx
80106e11:	6a 06                	push   $0x6
80106e13:	50                   	push   %eax
80106e14:	31 d2                	xor    %edx,%edx
80106e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e19:	e8 c2 fc ff ff       	call   80106ae0 <mappages>
  memmove(mem, init, sz);
80106e1e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e21:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e24:	83 c4 10             	add    $0x10,%esp
80106e27:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2d:	5b                   	pop    %ebx
80106e2e:	5e                   	pop    %esi
80106e2f:	5f                   	pop    %edi
80106e30:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e31:	e9 ea da ff ff       	jmp    80104920 <memmove>
    panic("inituvm: more than a page");
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	68 75 7e 10 80       	push   $0x80107e75
80106e3e:	e8 4d 95 ff ff       	call   80100390 <panic>
80106e43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e50 <loaduvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	57                   	push   %edi
80106e54:	56                   	push   %esi
80106e55:	53                   	push   %ebx
80106e56:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106e60:	0f 85 91 00 00 00    	jne    80106ef7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106e66:	8b 75 18             	mov    0x18(%ebp),%esi
80106e69:	31 db                	xor    %ebx,%ebx
80106e6b:	85 f6                	test   %esi,%esi
80106e6d:	75 1a                	jne    80106e89 <loaduvm+0x39>
80106e6f:	eb 6f                	jmp    80106ee0 <loaduvm+0x90>
80106e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106e84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106e87:	76 57                	jbe    80106ee0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e89:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e8f:	31 c9                	xor    %ecx,%ecx
80106e91:	01 da                	add    %ebx,%edx
80106e93:	e8 c8 fb ff ff       	call   80106a60 <walkpgdir>
80106e98:	85 c0                	test   %eax,%eax
80106e9a:	74 4e                	je     80106eea <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106e9c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ea1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ea6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106eab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106eb1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eb4:	01 d9                	add    %ebx,%ecx
80106eb6:	05 00 00 00 80       	add    $0x80000000,%eax
80106ebb:	57                   	push   %edi
80106ebc:	51                   	push   %ecx
80106ebd:	50                   	push   %eax
80106ebe:	ff 75 10             	pushl  0x10(%ebp)
80106ec1:	e8 8a ad ff ff       	call   80101c50 <readi>
80106ec6:	83 c4 10             	add    $0x10,%esp
80106ec9:	39 f8                	cmp    %edi,%eax
80106ecb:	74 ab                	je     80106e78 <loaduvm+0x28>
}
80106ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
80106eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ee0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ee3:	31 c0                	xor    %eax,%eax
}
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5f                   	pop    %edi
80106ee8:	5d                   	pop    %ebp
80106ee9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106eea:	83 ec 0c             	sub    $0xc,%esp
80106eed:	68 8f 7e 10 80       	push   $0x80107e8f
80106ef2:	e8 99 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ef7:	83 ec 0c             	sub    $0xc,%esp
80106efa:	68 30 7f 10 80       	push   $0x80107f30
80106eff:	e8 8c 94 ff ff       	call   80100390 <panic>
80106f04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f10 <allocuvm>:
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f19:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f1c:	85 ff                	test   %edi,%edi
80106f1e:	0f 88 8e 00 00 00    	js     80106fb2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106f24:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f27:	0f 82 93 00 00 00    	jb     80106fc0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f30:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f36:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f3c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f3f:	0f 86 7e 00 00 00    	jbe    80106fc3 <allocuvm+0xb3>
80106f45:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f48:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f4b:	eb 42                	jmp    80106f8f <allocuvm+0x7f>
80106f4d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106f50:	83 ec 04             	sub    $0x4,%esp
80106f53:	68 00 10 00 00       	push   $0x1000
80106f58:	6a 00                	push   $0x0
80106f5a:	50                   	push   %eax
80106f5b:	e8 10 d9 ff ff       	call   80104870 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f60:	58                   	pop    %eax
80106f61:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f67:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f6c:	5a                   	pop    %edx
80106f6d:	6a 06                	push   $0x6
80106f6f:	50                   	push   %eax
80106f70:	89 da                	mov    %ebx,%edx
80106f72:	89 f8                	mov    %edi,%eax
80106f74:	e8 67 fb ff ff       	call   80106ae0 <mappages>
80106f79:	83 c4 10             	add    $0x10,%esp
80106f7c:	85 c0                	test   %eax,%eax
80106f7e:	78 50                	js     80106fd0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106f80:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f86:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f89:	0f 86 81 00 00 00    	jbe    80107010 <allocuvm+0x100>
    mem = kalloc();
80106f8f:	e8 2c b9 ff ff       	call   801028c0 <kalloc>
    if(mem == 0){
80106f94:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106f96:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106f98:	75 b6                	jne    80106f50 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f9a:	83 ec 0c             	sub    $0xc,%esp
80106f9d:	68 ad 7e 10 80       	push   $0x80107ead
80106fa2:	e8 b9 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106fa7:	83 c4 10             	add    $0x10,%esp
80106faa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fad:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fb0:	77 6e                	ja     80107020 <allocuvm+0x110>
}
80106fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106fb5:	31 ff                	xor    %edi,%edi
}
80106fb7:	89 f8                	mov    %edi,%eax
80106fb9:	5b                   	pop    %ebx
80106fba:	5e                   	pop    %esi
80106fbb:	5f                   	pop    %edi
80106fbc:	5d                   	pop    %ebp
80106fbd:	c3                   	ret    
80106fbe:	66 90                	xchg   %ax,%ax
    return oldsz;
80106fc0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc6:	89 f8                	mov    %edi,%eax
80106fc8:	5b                   	pop    %ebx
80106fc9:	5e                   	pop    %esi
80106fca:	5f                   	pop    %edi
80106fcb:	5d                   	pop    %ebp
80106fcc:	c3                   	ret    
80106fcd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106fd0:	83 ec 0c             	sub    $0xc,%esp
80106fd3:	68 c5 7e 10 80       	push   $0x80107ec5
80106fd8:	e8 83 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106fdd:	83 c4 10             	add    $0x10,%esp
80106fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fe3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fe6:	76 0d                	jbe    80106ff5 <allocuvm+0xe5>
80106fe8:	89 c1                	mov    %eax,%ecx
80106fea:	8b 55 10             	mov    0x10(%ebp),%edx
80106fed:	8b 45 08             	mov    0x8(%ebp),%eax
80106ff0:	e8 7b fb ff ff       	call   80106b70 <deallocuvm.part.0>
      kfree(mem);
80106ff5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106ff8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106ffa:	56                   	push   %esi
80106ffb:	e8 10 b7 ff ff       	call   80102710 <kfree>
      return 0;
80107000:	83 c4 10             	add    $0x10,%esp
}
80107003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107006:	89 f8                	mov    %edi,%eax
80107008:	5b                   	pop    %ebx
80107009:	5e                   	pop    %esi
8010700a:	5f                   	pop    %edi
8010700b:	5d                   	pop    %ebp
8010700c:	c3                   	ret    
8010700d:	8d 76 00             	lea    0x0(%esi),%esi
80107010:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107013:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107016:	5b                   	pop    %ebx
80107017:	89 f8                	mov    %edi,%eax
80107019:	5e                   	pop    %esi
8010701a:	5f                   	pop    %edi
8010701b:	5d                   	pop    %ebp
8010701c:	c3                   	ret    
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
80107020:	89 c1                	mov    %eax,%ecx
80107022:	8b 55 10             	mov    0x10(%ebp),%edx
80107025:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107028:	31 ff                	xor    %edi,%edi
8010702a:	e8 41 fb ff ff       	call   80106b70 <deallocuvm.part.0>
8010702f:	eb 92                	jmp    80106fc3 <allocuvm+0xb3>
80107031:	eb 0d                	jmp    80107040 <deallocuvm>
80107033:	90                   	nop
80107034:	90                   	nop
80107035:	90                   	nop
80107036:	90                   	nop
80107037:	90                   	nop
80107038:	90                   	nop
80107039:	90                   	nop
8010703a:	90                   	nop
8010703b:	90                   	nop
8010703c:	90                   	nop
8010703d:	90                   	nop
8010703e:	90                   	nop
8010703f:	90                   	nop

80107040 <deallocuvm>:
{
80107040:	55                   	push   %ebp
80107041:	89 e5                	mov    %esp,%ebp
80107043:	8b 55 0c             	mov    0xc(%ebp),%edx
80107046:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107049:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010704c:	39 d1                	cmp    %edx,%ecx
8010704e:	73 10                	jae    80107060 <deallocuvm+0x20>
}
80107050:	5d                   	pop    %ebp
80107051:	e9 1a fb ff ff       	jmp    80106b70 <deallocuvm.part.0>
80107056:	8d 76 00             	lea    0x0(%esi),%esi
80107059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107060:	89 d0                	mov    %edx,%eax
80107062:	5d                   	pop    %ebp
80107063:	c3                   	ret    
80107064:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010706a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107070 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 0c             	sub    $0xc,%esp
80107079:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010707c:	85 f6                	test   %esi,%esi
8010707e:	74 59                	je     801070d9 <freevm+0x69>
80107080:	31 c9                	xor    %ecx,%ecx
80107082:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107087:	89 f0                	mov    %esi,%eax
80107089:	e8 e2 fa ff ff       	call   80106b70 <deallocuvm.part.0>
8010708e:	89 f3                	mov    %esi,%ebx
80107090:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107096:	eb 0f                	jmp    801070a7 <freevm+0x37>
80107098:	90                   	nop
80107099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070a3:	39 fb                	cmp    %edi,%ebx
801070a5:	74 23                	je     801070ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070a7:	8b 03                	mov    (%ebx),%eax
801070a9:	a8 01                	test   $0x1,%al
801070ab:	74 f3                	je     801070a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070b2:	83 ec 0c             	sub    $0xc,%esp
801070b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070bd:	50                   	push   %eax
801070be:	e8 4d b6 ff ff       	call   80102710 <kfree>
801070c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070c6:	39 fb                	cmp    %edi,%ebx
801070c8:	75 dd                	jne    801070a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070d0:	5b                   	pop    %ebx
801070d1:	5e                   	pop    %esi
801070d2:	5f                   	pop    %edi
801070d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070d4:	e9 37 b6 ff ff       	jmp    80102710 <kfree>
    panic("freevm: no pgdir");
801070d9:	83 ec 0c             	sub    $0xc,%esp
801070dc:	68 e1 7e 10 80       	push   $0x80107ee1
801070e1:	e8 aa 92 ff ff       	call   80100390 <panic>
801070e6:	8d 76 00             	lea    0x0(%esi),%esi
801070e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070f0 <setupkvm>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	56                   	push   %esi
801070f4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070f5:	e8 c6 b7 ff ff       	call   801028c0 <kalloc>
801070fa:	85 c0                	test   %eax,%eax
801070fc:	89 c6                	mov    %eax,%esi
801070fe:	74 42                	je     80107142 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107100:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107103:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107108:	68 00 10 00 00       	push   $0x1000
8010710d:	6a 00                	push   $0x0
8010710f:	50                   	push   %eax
80107110:	e8 5b d7 ff ff       	call   80104870 <memset>
80107115:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107118:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010711b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010711e:	83 ec 08             	sub    $0x8,%esp
80107121:	8b 13                	mov    (%ebx),%edx
80107123:	ff 73 0c             	pushl  0xc(%ebx)
80107126:	50                   	push   %eax
80107127:	29 c1                	sub    %eax,%ecx
80107129:	89 f0                	mov    %esi,%eax
8010712b:	e8 b0 f9 ff ff       	call   80106ae0 <mappages>
80107130:	83 c4 10             	add    $0x10,%esp
80107133:	85 c0                	test   %eax,%eax
80107135:	78 19                	js     80107150 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107137:	83 c3 10             	add    $0x10,%ebx
8010713a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107140:	75 d6                	jne    80107118 <setupkvm+0x28>
}
80107142:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107145:	89 f0                	mov    %esi,%eax
80107147:	5b                   	pop    %ebx
80107148:	5e                   	pop    %esi
80107149:	5d                   	pop    %ebp
8010714a:	c3                   	ret    
8010714b:	90                   	nop
8010714c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107150:	83 ec 0c             	sub    $0xc,%esp
80107153:	56                   	push   %esi
      return 0;
80107154:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107156:	e8 15 ff ff ff       	call   80107070 <freevm>
      return 0;
8010715b:	83 c4 10             	add    $0x10,%esp
}
8010715e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107161:	89 f0                	mov    %esi,%eax
80107163:	5b                   	pop    %ebx
80107164:	5e                   	pop    %esi
80107165:	5d                   	pop    %ebp
80107166:	c3                   	ret    
80107167:	89 f6                	mov    %esi,%esi
80107169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107170 <kvmalloc>:
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107176:	e8 75 ff ff ff       	call   801070f0 <setupkvm>
8010717b:	a3 c4 54 11 80       	mov    %eax,0x801154c4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107180:	05 00 00 00 80       	add    $0x80000000,%eax
80107185:	0f 22 d8             	mov    %eax,%cr3
}
80107188:	c9                   	leave  
80107189:	c3                   	ret    
8010718a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107190 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107190:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107191:	31 c9                	xor    %ecx,%ecx
{
80107193:	89 e5                	mov    %esp,%ebp
80107195:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107198:	8b 55 0c             	mov    0xc(%ebp),%edx
8010719b:	8b 45 08             	mov    0x8(%ebp),%eax
8010719e:	e8 bd f8 ff ff       	call   80106a60 <walkpgdir>
  if(pte == 0)
801071a3:	85 c0                	test   %eax,%eax
801071a5:	74 05                	je     801071ac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801071a7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801071aa:	c9                   	leave  
801071ab:	c3                   	ret    
    panic("clearpteu");
801071ac:	83 ec 0c             	sub    $0xc,%esp
801071af:	68 f2 7e 10 80       	push   $0x80107ef2
801071b4:	e8 d7 91 ff ff       	call   80100390 <panic>
801071b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071c0:	55                   	push   %ebp
801071c1:	89 e5                	mov    %esp,%ebp
801071c3:	57                   	push   %edi
801071c4:	56                   	push   %esi
801071c5:	53                   	push   %ebx
801071c6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071c9:	e8 22 ff ff ff       	call   801070f0 <setupkvm>
801071ce:	85 c0                	test   %eax,%eax
801071d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071d3:	0f 84 9f 00 00 00    	je     80107278 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071dc:	85 c9                	test   %ecx,%ecx
801071de:	0f 84 94 00 00 00    	je     80107278 <copyuvm+0xb8>
801071e4:	31 ff                	xor    %edi,%edi
801071e6:	eb 4a                	jmp    80107232 <copyuvm+0x72>
801071e8:	90                   	nop
801071e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071f0:	83 ec 04             	sub    $0x4,%esp
801071f3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801071f9:	68 00 10 00 00       	push   $0x1000
801071fe:	53                   	push   %ebx
801071ff:	50                   	push   %eax
80107200:	e8 1b d7 ff ff       	call   80104920 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107205:	58                   	pop    %eax
80107206:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010720c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107211:	5a                   	pop    %edx
80107212:	ff 75 e4             	pushl  -0x1c(%ebp)
80107215:	50                   	push   %eax
80107216:	89 fa                	mov    %edi,%edx
80107218:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010721b:	e8 c0 f8 ff ff       	call   80106ae0 <mappages>
80107220:	83 c4 10             	add    $0x10,%esp
80107223:	85 c0                	test   %eax,%eax
80107225:	78 61                	js     80107288 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107227:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010722d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107230:	76 46                	jbe    80107278 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107232:	8b 45 08             	mov    0x8(%ebp),%eax
80107235:	31 c9                	xor    %ecx,%ecx
80107237:	89 fa                	mov    %edi,%edx
80107239:	e8 22 f8 ff ff       	call   80106a60 <walkpgdir>
8010723e:	85 c0                	test   %eax,%eax
80107240:	74 61                	je     801072a3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107242:	8b 00                	mov    (%eax),%eax
80107244:	a8 01                	test   $0x1,%al
80107246:	74 4e                	je     80107296 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107248:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010724a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010724f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107255:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107258:	e8 63 b6 ff ff       	call   801028c0 <kalloc>
8010725d:	85 c0                	test   %eax,%eax
8010725f:	89 c6                	mov    %eax,%esi
80107261:	75 8d                	jne    801071f0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107263:	83 ec 0c             	sub    $0xc,%esp
80107266:	ff 75 e0             	pushl  -0x20(%ebp)
80107269:	e8 02 fe ff ff       	call   80107070 <freevm>
  return 0;
8010726e:	83 c4 10             	add    $0x10,%esp
80107271:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107278:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010727b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010727e:	5b                   	pop    %ebx
8010727f:	5e                   	pop    %esi
80107280:	5f                   	pop    %edi
80107281:	5d                   	pop    %ebp
80107282:	c3                   	ret    
80107283:	90                   	nop
80107284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107288:	83 ec 0c             	sub    $0xc,%esp
8010728b:	56                   	push   %esi
8010728c:	e8 7f b4 ff ff       	call   80102710 <kfree>
      goto bad;
80107291:	83 c4 10             	add    $0x10,%esp
80107294:	eb cd                	jmp    80107263 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107296:	83 ec 0c             	sub    $0xc,%esp
80107299:	68 16 7f 10 80       	push   $0x80107f16
8010729e:	e8 ed 90 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801072a3:	83 ec 0c             	sub    $0xc,%esp
801072a6:	68 fc 7e 10 80       	push   $0x80107efc
801072ab:	e8 e0 90 ff ff       	call   80100390 <panic>

801072b0 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801072b0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801072b1:	31 c9                	xor    %ecx,%ecx
{
801072b3:	89 e5                	mov    %esp,%ebp
801072b5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801072b8:	8b 55 0c             	mov    0xc(%ebp),%edx
801072bb:	8b 45 08             	mov    0x8(%ebp),%eax
801072be:	e8 9d f7 ff ff       	call   80106a60 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072c3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072c5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801072c6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072cd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072d0:	05 00 00 00 80       	add    $0x80000000,%eax
801072d5:	83 fa 05             	cmp    $0x5,%edx
801072d8:	ba 00 00 00 00       	mov    $0x0,%edx
801072dd:	0f 45 c2             	cmovne %edx,%eax
}
801072e0:	c3                   	ret    
801072e1:	eb 0d                	jmp    801072f0 <copyout>
801072e3:	90                   	nop
801072e4:	90                   	nop
801072e5:	90                   	nop
801072e6:	90                   	nop
801072e7:	90                   	nop
801072e8:	90                   	nop
801072e9:	90                   	nop
801072ea:	90                   	nop
801072eb:	90                   	nop
801072ec:	90                   	nop
801072ed:	90                   	nop
801072ee:	90                   	nop
801072ef:	90                   	nop

801072f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072f0:	55                   	push   %ebp
801072f1:	89 e5                	mov    %esp,%ebp
801072f3:	57                   	push   %edi
801072f4:	56                   	push   %esi
801072f5:	53                   	push   %ebx
801072f6:	83 ec 1c             	sub    $0x1c,%esp
801072f9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801072fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801072ff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107302:	85 db                	test   %ebx,%ebx
80107304:	75 40                	jne    80107346 <copyout+0x56>
80107306:	eb 70                	jmp    80107378 <copyout+0x88>
80107308:	90                   	nop
80107309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107310:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107313:	89 f1                	mov    %esi,%ecx
80107315:	29 d1                	sub    %edx,%ecx
80107317:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010731d:	39 d9                	cmp    %ebx,%ecx
8010731f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107322:	29 f2                	sub    %esi,%edx
80107324:	83 ec 04             	sub    $0x4,%esp
80107327:	01 d0                	add    %edx,%eax
80107329:	51                   	push   %ecx
8010732a:	57                   	push   %edi
8010732b:	50                   	push   %eax
8010732c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010732f:	e8 ec d5 ff ff       	call   80104920 <memmove>
    len -= n;
    buf += n;
80107334:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107337:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010733a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107340:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107342:	29 cb                	sub    %ecx,%ebx
80107344:	74 32                	je     80107378 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107346:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107348:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010734b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010734e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107354:	56                   	push   %esi
80107355:	ff 75 08             	pushl  0x8(%ebp)
80107358:	e8 53 ff ff ff       	call   801072b0 <uva2ka>
    if(pa0 == 0)
8010735d:	83 c4 10             	add    $0x10,%esp
80107360:	85 c0                	test   %eax,%eax
80107362:	75 ac                	jne    80107310 <copyout+0x20>
  }
  return 0;
}
80107364:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107367:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010736c:	5b                   	pop    %ebx
8010736d:	5e                   	pop    %esi
8010736e:	5f                   	pop    %edi
8010736f:	5d                   	pop    %ebp
80107370:	c3                   	ret    
80107371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010737b:	31 c0                	xor    %eax,%eax
}
8010737d:	5b                   	pop    %ebx
8010737e:	5e                   	pop    %esi
8010737f:	5f                   	pop    %edi
80107380:	5d                   	pop    %ebp
80107381:	c3                   	ret    
