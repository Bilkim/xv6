
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
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 7b 10 80       	push   $0x80107b80
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 61 45 00 00       	call   801045c0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 7b 10 80       	push   $0x80107b87
80100097:	50                   	push   %eax
80100098:	e8 e3 43 00 00       	call   80104480 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 53 46 00 00       	call   80104740 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 99 46 00 00       	call   80104800 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 43 00 00       	call   801044c0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 20 00 00       	call   80102290 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 8e 7b 10 80       	push   $0x80107b8e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 99 43 00 00       	call   80104560 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 b3 20 00 00       	jmp    80102290 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 7b 10 80       	push   $0x80107b9f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 58 43 00 00       	call   80104560 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 08 43 00 00       	call   80104520 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 1c 45 00 00       	call   80104740 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 8b 45 00 00       	jmp    80104800 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 7b 10 80       	push   $0x80107ba6
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 a6 15 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 8a 44 00 00       	call   80104740 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 f6 3d 00 00       	call   801040e0 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 d1 37 00 00       	call   80103ad0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 ed 44 00 00       	call   80104800 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 54 14 00 00       	call   80101770 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 96 44 00 00       	call   80104800 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 fd 13 00 00       	call   80101770 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 fe 24 00 00       	call   801028b0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 7b 10 80       	push   $0x80107bad
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 7f 86 10 80 	movl   $0x8010867f,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ff 41 00 00       	call   801045e0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 7b 10 80       	push   $0x80107bc1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 51 63 00 00       	call   80106780 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 66 62 00 00       	call   80106780 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 5a 62 00 00       	call   80106780 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 4e 62 00 00       	call   80106780 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 8a 43 00 00       	call   801048f0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 d5 42 00 00       	call   80104850 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 c5 7b 10 80       	push   $0x80107bc5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 f0 7b 10 80 	movzbl -0x7fef8410(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 f8 11 00 00       	call   80101850 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 dc 40 00 00       	call   80104740 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 64 41 00 00       	call   80104800 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 cb 10 00 00       	call   80101770 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb d8 7b 10 80       	mov    $0x80107bd8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 7e 3f 00 00       	call   80104740 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 d3 3f 00 00       	call   80104800 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 df 7b 10 80       	push   $0x80107bdf
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 c4 3e 00 00       	call   80104740 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 2c 3e 00 00       	call   80104800 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 9c 39 00 00       	jmp    801043a0 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 7b 38 00 00       	call   801042a0 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 e8 7b 10 80       	push   $0x80107be8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 77 3b 00 00       	call   801045c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 ce 19 00 00       	call   80102440 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 3b 30 00 00       	call   80103ad0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 a0 22 00 00       	call   80102d40 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 95 15 00 00       	call   80102040 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 08 03 00 00    	je     80100dbe <exec+0x33e>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 af 0c 00 00       	call   80101770 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 9e 0f 00 00       	call   80101a70 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 2d 0f 00 00       	call   80101a10 <iunlockput>
    end_op();
80100ae3:	e8 c8 22 00 00       	call   80102db0 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 df 6d 00 00       	call   801078f0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 ae 02 00 00    	je     80100ddd <exec+0x35d>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 98 6b 00 00       	call   80107710 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 92 6a 00 00       	call   80107640 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 9a 0e 00 00       	call   80101a70 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 80 6c 00 00       	call   80107870 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 ef 0d 00 00       	call   80101a10 <iunlockput>
  end_op();
80100c21:	e8 8a 21 00 00       	call   80102db0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 d9 6a 00 00       	call   80107710 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 38 6d 00 00       	call   80107990 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 a8 3d 00 00       	call   80104a50 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 95 3d 00 00       	call   80104a50 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 24 6e 00 00       	call   80107af0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 8a 6b 00 00       	call   80107870 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 b8 6d 00 00       	call   80107af0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 9a 3c 00 00       	call   80104a10 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d83:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100d85:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d88:	8b 40 18             	mov    0x18(%eax),%eax
80100d8b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 46 18             	mov    0x18(%esi),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 34 24             	mov    %esi,(%esp)
80100d9d:	e8 0e 67 00 00       	call   801074b0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 c6 6a 00 00       	call   80107870 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
  curproc->priority = 1;
80100daf:	c7 86 e4 00 00 00 01 	movl   $0x1,0xe4(%esi)
80100db6:	00 00 00 
  return 0;
80100db9:	e9 32 fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dbe:	e8 ed 1f 00 00       	call   80102db0 <end_op>
    cprintf("exec: fail\n");
80100dc3:	83 ec 0c             	sub    $0xc,%esp
80100dc6:	68 01 7c 10 80       	push   $0x80107c01
80100dcb:	e8 e0 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dd0:	83 c4 10             	add    $0x10,%esp
80100dd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dd8:	e9 13 fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ddd:	31 ff                	xor    %edi,%edi
80100ddf:	be 00 20 00 00       	mov    $0x2000,%esi
80100de4:	e9 2f fe ff ff       	jmp    80100c18 <exec+0x198>
80100de9:	66 90                	xchg   %ax,%ax
80100deb:	66 90                	xchg   %ax,%ax
80100ded:	66 90                	xchg   %ax,%ax
80100def:	90                   	nop

80100df0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100df0:	f3 0f 1e fb          	endbr32 
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dfa:	68 0d 7c 10 80       	push   $0x80107c0d
80100dff:	68 c0 0f 11 80       	push   $0x80110fc0
80100e04:	e8 b7 37 00 00       	call   801045c0 <initlock>
}
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	c9                   	leave  
80100e0d:	c3                   	ret    
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e10:	f3 0f 1e fb          	endbr32 
80100e14:	55                   	push   %ebp
80100e15:	89 e5                	mov    %esp,%ebp
80100e17:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e18:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e1d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e20:	68 c0 0f 11 80       	push   $0x80110fc0
80100e25:	e8 16 39 00 00       	call   80104740 <acquire>
80100e2a:	83 c4 10             	add    $0x10,%esp
80100e2d:	eb 0c                	jmp    80100e3b <filealloc+0x2b>
80100e2f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e30:	83 c3 18             	add    $0x18,%ebx
80100e33:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e39:	74 25                	je     80100e60 <filealloc+0x50>
    if(f->ref == 0){
80100e3b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e3e:	85 c0                	test   %eax,%eax
80100e40:	75 ee                	jne    80100e30 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e42:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e45:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e4c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e51:	e8 aa 39 00 00       	call   80104800 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e56:	89 d8                	mov    %ebx,%eax
      return f;
80100e58:	83 c4 10             	add    $0x10,%esp
}
80100e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e5e:	c9                   	leave  
80100e5f:	c3                   	ret    
  release(&ftable.lock);
80100e60:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e63:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e65:	68 c0 0f 11 80       	push   $0x80110fc0
80100e6a:	e8 91 39 00 00       	call   80104800 <release>
}
80100e6f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e71:	83 c4 10             	add    $0x10,%esp
}
80100e74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e77:	c9                   	leave  
80100e78:	c3                   	ret    
80100e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e80 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e80:	f3 0f 1e fb          	endbr32 
80100e84:	55                   	push   %ebp
80100e85:	89 e5                	mov    %esp,%ebp
80100e87:	53                   	push   %ebx
80100e88:	83 ec 10             	sub    $0x10,%esp
80100e8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e8e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e93:	e8 a8 38 00 00       	call   80104740 <acquire>
  if(f->ref < 1)
80100e98:	8b 43 04             	mov    0x4(%ebx),%eax
80100e9b:	83 c4 10             	add    $0x10,%esp
80100e9e:	85 c0                	test   %eax,%eax
80100ea0:	7e 1a                	jle    80100ebc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ea2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ea8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eab:	68 c0 0f 11 80       	push   $0x80110fc0
80100eb0:	e8 4b 39 00 00       	call   80104800 <release>
  return f;
}
80100eb5:	89 d8                	mov    %ebx,%eax
80100eb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eba:	c9                   	leave  
80100ebb:	c3                   	ret    
    panic("filedup");
80100ebc:	83 ec 0c             	sub    $0xc,%esp
80100ebf:	68 14 7c 10 80       	push   $0x80107c14
80100ec4:	e8 c7 f4 ff ff       	call   80100390 <panic>
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 28             	sub    $0x28,%esp
80100edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ee0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ee5:	e8 56 38 00 00       	call   80104740 <acquire>
  if(f->ref < 1)
80100eea:	8b 53 04             	mov    0x4(%ebx),%edx
80100eed:	83 c4 10             	add    $0x10,%esp
80100ef0:	85 d2                	test   %edx,%edx
80100ef2:	0f 8e a1 00 00 00    	jle    80100f99 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ef8:	83 ea 01             	sub    $0x1,%edx
80100efb:	89 53 04             	mov    %edx,0x4(%ebx)
80100efe:	75 40                	jne    80100f40 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f00:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f04:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f07:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f0f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f12:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f15:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f18:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f20:	e8 db 38 00 00       	call   80104800 <release>

  if(ff.type == FD_PIPE)
80100f25:	83 c4 10             	add    $0x10,%esp
80100f28:	83 ff 01             	cmp    $0x1,%edi
80100f2b:	74 53                	je     80100f80 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f2d:	83 ff 02             	cmp    $0x2,%edi
80100f30:	74 26                	je     80100f58 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f35:	5b                   	pop    %ebx
80100f36:	5e                   	pop    %esi
80100f37:	5f                   	pop    %edi
80100f38:	5d                   	pop    %ebp
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f40:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f4a:	5b                   	pop    %ebx
80100f4b:	5e                   	pop    %esi
80100f4c:	5f                   	pop    %edi
80100f4d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f4e:	e9 ad 38 00 00       	jmp    80104800 <release>
80100f53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f57:	90                   	nop
    begin_op();
80100f58:	e8 e3 1d 00 00       	call   80102d40 <begin_op>
    iput(ff.ip);
80100f5d:	83 ec 0c             	sub    $0xc,%esp
80100f60:	ff 75 e0             	pushl  -0x20(%ebp)
80100f63:	e8 38 09 00 00       	call   801018a0 <iput>
    end_op();
80100f68:	83 c4 10             	add    $0x10,%esp
}
80100f6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6e:	5b                   	pop    %ebx
80100f6f:	5e                   	pop    %esi
80100f70:	5f                   	pop    %edi
80100f71:	5d                   	pop    %ebp
    end_op();
80100f72:	e9 39 1e 00 00       	jmp    80102db0 <end_op>
80100f77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f80:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f84:	83 ec 08             	sub    $0x8,%esp
80100f87:	53                   	push   %ebx
80100f88:	56                   	push   %esi
80100f89:	e8 82 25 00 00       	call   80103510 <pipeclose>
80100f8e:	83 c4 10             	add    $0x10,%esp
}
80100f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f94:	5b                   	pop    %ebx
80100f95:	5e                   	pop    %esi
80100f96:	5f                   	pop    %edi
80100f97:	5d                   	pop    %ebp
80100f98:	c3                   	ret    
    panic("fileclose");
80100f99:	83 ec 0c             	sub    $0xc,%esp
80100f9c:	68 1c 7c 10 80       	push   $0x80107c1c
80100fa1:	e8 ea f3 ff ff       	call   80100390 <panic>
80100fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fad:	8d 76 00             	lea    0x0(%esi),%esi

80100fb0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fb0:	f3 0f 1e fb          	endbr32 
80100fb4:	55                   	push   %ebp
80100fb5:	89 e5                	mov    %esp,%ebp
80100fb7:	53                   	push   %ebx
80100fb8:	83 ec 04             	sub    $0x4,%esp
80100fbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fbe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fc1:	75 2d                	jne    80100ff0 <filestat+0x40>
    ilock(f->ip);
80100fc3:	83 ec 0c             	sub    $0xc,%esp
80100fc6:	ff 73 10             	pushl  0x10(%ebx)
80100fc9:	e8 a2 07 00 00       	call   80101770 <ilock>
    stati(f->ip, st);
80100fce:	58                   	pop    %eax
80100fcf:	5a                   	pop    %edx
80100fd0:	ff 75 0c             	pushl  0xc(%ebp)
80100fd3:	ff 73 10             	pushl  0x10(%ebx)
80100fd6:	e8 65 0a 00 00       	call   80101a40 <stati>
    iunlock(f->ip);
80100fdb:	59                   	pop    %ecx
80100fdc:	ff 73 10             	pushl  0x10(%ebx)
80100fdf:	e8 6c 08 00 00       	call   80101850 <iunlock>
    return 0;
  }
  return -1;
}
80100fe4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fe7:	83 c4 10             	add    $0x10,%esp
80100fea:	31 c0                	xor    %eax,%eax
}
80100fec:	c9                   	leave  
80100fed:	c3                   	ret    
80100fee:	66 90                	xchg   %ax,%ax
80100ff0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101000 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	57                   	push   %edi
80101008:	56                   	push   %esi
80101009:	53                   	push   %ebx
8010100a:	83 ec 0c             	sub    $0xc,%esp
8010100d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101010:	8b 75 0c             	mov    0xc(%ebp),%esi
80101013:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101016:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010101a:	74 64                	je     80101080 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010101c:	8b 03                	mov    (%ebx),%eax
8010101e:	83 f8 01             	cmp    $0x1,%eax
80101021:	74 45                	je     80101068 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101023:	83 f8 02             	cmp    $0x2,%eax
80101026:	75 5f                	jne    80101087 <fileread+0x87>
    ilock(f->ip);
80101028:	83 ec 0c             	sub    $0xc,%esp
8010102b:	ff 73 10             	pushl  0x10(%ebx)
8010102e:	e8 3d 07 00 00       	call   80101770 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101033:	57                   	push   %edi
80101034:	ff 73 14             	pushl  0x14(%ebx)
80101037:	56                   	push   %esi
80101038:	ff 73 10             	pushl  0x10(%ebx)
8010103b:	e8 30 0a 00 00       	call   80101a70 <readi>
80101040:	83 c4 20             	add    $0x20,%esp
80101043:	89 c6                	mov    %eax,%esi
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 03                	jle    8010104c <fileread+0x4c>
      f->off += r;
80101049:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010104c:	83 ec 0c             	sub    $0xc,%esp
8010104f:	ff 73 10             	pushl  0x10(%ebx)
80101052:	e8 f9 07 00 00       	call   80101850 <iunlock>
    return r;
80101057:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010105a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010105d:	89 f0                	mov    %esi,%eax
8010105f:	5b                   	pop    %ebx
80101060:	5e                   	pop    %esi
80101061:	5f                   	pop    %edi
80101062:	5d                   	pop    %ebp
80101063:	c3                   	ret    
80101064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101068:	8b 43 0c             	mov    0xc(%ebx),%eax
8010106b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101075:	e9 36 26 00 00       	jmp    801036b0 <piperead>
8010107a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101080:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101085:	eb d3                	jmp    8010105a <fileread+0x5a>
  panic("fileread");
80101087:	83 ec 0c             	sub    $0xc,%esp
8010108a:	68 26 7c 10 80       	push   $0x80107c26
8010108f:	e8 fc f2 ff ff       	call   80100390 <panic>
80101094:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010109b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010109f:	90                   	nop

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	f3 0f 1e fb          	endbr32 
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 1c             	sub    $0x1c,%esp
801010ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801010b0:	8b 75 08             	mov    0x8(%ebp),%esi
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010b9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010c0:	0f 84 c1 00 00 00    	je     80101187 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010c6:	8b 06                	mov    (%esi),%eax
801010c8:	83 f8 01             	cmp    $0x1,%eax
801010cb:	0f 84 c3 00 00 00    	je     80101194 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010d1:	83 f8 02             	cmp    $0x2,%eax
801010d4:	0f 85 cc 00 00 00    	jne    801011a6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010dd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010df:	85 c0                	test   %eax,%eax
801010e1:	7f 34                	jg     80101117 <filewrite+0x77>
801010e3:	e9 98 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010f3:	83 ec 0c             	sub    $0xc,%esp
801010f6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010fc:	e8 4f 07 00 00       	call   80101850 <iunlock>
      end_op();
80101101:	e8 aa 1c 00 00       	call   80102db0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101106:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101109:	83 c4 10             	add    $0x10,%esp
8010110c:	39 c3                	cmp    %eax,%ebx
8010110e:	75 60                	jne    80101170 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101110:	01 df                	add    %ebx,%edi
    while(i < n){
80101112:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101115:	7e 69                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010111a:	b8 00 06 00 00       	mov    $0x600,%eax
8010111f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101121:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101127:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010112a:	e8 11 1c 00 00       	call   80102d40 <begin_op>
      ilock(f->ip);
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	ff 76 10             	pushl  0x10(%esi)
80101135:	e8 36 06 00 00       	call   80101770 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010113a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010113d:	53                   	push   %ebx
8010113e:	ff 76 14             	pushl  0x14(%esi)
80101141:	01 f8                	add    %edi,%eax
80101143:	50                   	push   %eax
80101144:	ff 76 10             	pushl  0x10(%esi)
80101147:	e8 24 0a 00 00       	call   80101b70 <writei>
8010114c:	83 c4 20             	add    $0x20,%esp
8010114f:	85 c0                	test   %eax,%eax
80101151:	7f 9d                	jg     801010f0 <filewrite+0x50>
      iunlock(f->ip);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	ff 76 10             	pushl  0x10(%esi)
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115c:	e8 ef 06 00 00       	call   80101850 <iunlock>
      end_op();
80101161:	e8 4a 1c 00 00       	call   80102db0 <end_op>
      if(r < 0)
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	83 c4 10             	add    $0x10,%esp
8010116c:	85 c0                	test   %eax,%eax
8010116e:	75 17                	jne    80101187 <filewrite+0xe7>
        panic("short filewrite");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 2f 7c 10 80       	push   $0x80107c2f
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101180:	89 f8                	mov    %edi,%eax
80101182:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101185:	74 05                	je     8010118c <filewrite+0xec>
80101187:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118f:	5b                   	pop    %ebx
80101190:	5e                   	pop    %esi
80101191:	5f                   	pop    %edi
80101192:	5d                   	pop    %ebp
80101193:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101194:	8b 46 0c             	mov    0xc(%esi),%eax
80101197:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010119a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010119d:	5b                   	pop    %ebx
8010119e:	5e                   	pop    %esi
8010119f:	5f                   	pop    %edi
801011a0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011a1:	e9 0a 24 00 00       	jmp    801035b0 <pipewrite>
  panic("filewrite");
801011a6:	83 ec 0c             	sub    $0xc,%esp
801011a9:	68 35 7c 10 80       	push   $0x80107c35
801011ae:	e8 dd f1 ff ff       	call   80100390 <panic>
801011b3:	66 90                	xchg   %ax,%ax
801011b5:	66 90                	xchg   %ax,%ax
801011b7:	66 90                	xchg   %ax,%ax
801011b9:	66 90                	xchg   %ax,%ax
801011bb:	66 90                	xchg   %ax,%ax
801011bd:	66 90                	xchg   %ax,%ax
801011bf:	90                   	nop

801011c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011c0:	55                   	push   %ebp
801011c1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011c3:	89 d0                	mov    %edx,%eax
801011c5:	c1 e8 0c             	shr    $0xc,%eax
801011c8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011ce:	89 e5                	mov    %esp,%ebp
801011d0:	56                   	push   %esi
801011d1:	53                   	push   %ebx
801011d2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011d4:	83 ec 08             	sub    $0x8,%esp
801011d7:	50                   	push   %eax
801011d8:	51                   	push   %ecx
801011d9:	e8 f2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011de:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011e0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011e3:	ba 01 00 00 00       	mov    $0x1,%edx
801011e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011eb:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011f1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011f4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011f6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011fb:	85 d1                	test   %edx,%ecx
801011fd:	74 25                	je     80101224 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ff:	f7 d2                	not    %edx
  log_write(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101206:	21 ca                	and    %ecx,%edx
80101208:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010120c:	50                   	push   %eax
8010120d:	e8 0e 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101212:	89 34 24             	mov    %esi,(%esp)
80101215:	e8 d6 ef ff ff       	call   801001f0 <brelse>
}
8010121a:	83 c4 10             	add    $0x10,%esp
8010121d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101220:	5b                   	pop    %ebx
80101221:	5e                   	pop    %esi
80101222:	5d                   	pop    %ebp
80101223:	c3                   	ret    
    panic("freeing free block");
80101224:	83 ec 0c             	sub    $0xc,%esp
80101227:	68 3f 7c 10 80       	push   $0x80107c3f
8010122c:	e8 5f f1 ff ff       	call   80100390 <panic>
80101231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010123f:	90                   	nop

80101240 <balloc>:
{
80101240:	55                   	push   %ebp
80101241:	89 e5                	mov    %esp,%ebp
80101243:	57                   	push   %edi
80101244:	56                   	push   %esi
80101245:	53                   	push   %ebx
80101246:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101249:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010124f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101252:	85 c9                	test   %ecx,%ecx
80101254:	0f 84 87 00 00 00    	je     801012e1 <balloc+0xa1>
8010125a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101261:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	89 f0                	mov    %esi,%eax
80101269:	c1 f8 0c             	sar    $0xc,%eax
8010126c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101272:	50                   	push   %eax
80101273:	ff 75 d8             	pushl  -0x28(%ebp)
80101276:	e8 55 ee ff ff       	call   801000d0 <bread>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101281:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101286:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101289:	31 c0                	xor    %eax,%eax
8010128b:	eb 2f                	jmp    801012bc <balloc+0x7c>
8010128d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101290:	89 c1                	mov    %eax,%ecx
80101292:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010129a:	83 e1 07             	and    $0x7,%ecx
8010129d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010129f:	89 c1                	mov    %eax,%ecx
801012a1:	c1 f9 03             	sar    $0x3,%ecx
801012a4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012a9:	89 fa                	mov    %edi,%edx
801012ab:	85 df                	test   %ebx,%edi
801012ad:	74 41                	je     801012f0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012af:	83 c0 01             	add    $0x1,%eax
801012b2:	83 c6 01             	add    $0x1,%esi
801012b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ba:	74 05                	je     801012c1 <balloc+0x81>
801012bc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012bf:	77 cf                	ja     80101290 <balloc+0x50>
    brelse(bp);
801012c1:	83 ec 0c             	sub    $0xc,%esp
801012c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012c7:	e8 24 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012cc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012d3:	83 c4 10             	add    $0x10,%esp
801012d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012d9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012df:	77 80                	ja     80101261 <balloc+0x21>
  panic("balloc: out of blocks");
801012e1:	83 ec 0c             	sub    $0xc,%esp
801012e4:	68 52 7c 10 80       	push   $0x80107c52
801012e9:	e8 a2 f0 ff ff       	call   80100390 <panic>
801012ee:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012f3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012f6:	09 da                	or     %ebx,%edx
801012f8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012fc:	57                   	push   %edi
801012fd:	e8 1e 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101302:	89 3c 24             	mov    %edi,(%esp)
80101305:	e8 e6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010130a:	58                   	pop    %eax
8010130b:	5a                   	pop    %edx
8010130c:	56                   	push   %esi
8010130d:	ff 75 d8             	pushl  -0x28(%ebp)
80101310:	e8 bb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101315:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101318:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010131a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010131d:	68 00 02 00 00       	push   $0x200
80101322:	6a 00                	push   $0x0
80101324:	50                   	push   %eax
80101325:	e8 26 35 00 00       	call   80104850 <memset>
  log_write(bp);
8010132a:	89 1c 24             	mov    %ebx,(%esp)
8010132d:	e8 ee 1b 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101332:	89 1c 24             	mov    %ebx,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	89 f0                	mov    %esi,%eax
8010133f:	5b                   	pop    %ebx
80101340:	5e                   	pop    %esi
80101341:	5f                   	pop    %edi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
80101344:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010134b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010134f:	90                   	nop

80101350 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	57                   	push   %edi
80101354:	89 c7                	mov    %eax,%edi
80101356:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101357:	31 f6                	xor    %esi,%esi
{
80101359:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010135f:	83 ec 28             	sub    $0x28,%esp
80101362:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101365:	68 e0 19 11 80       	push   $0x801119e0
8010136a:	e8 d1 33 00 00       	call   80104740 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101372:	83 c4 10             	add    $0x10,%esp
80101375:	eb 1b                	jmp    80101392 <iget+0x42>
80101377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010137e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101380:	39 3b                	cmp    %edi,(%ebx)
80101382:	74 6c                	je     801013f0 <iget+0xa0>
80101384:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101390:	73 26                	jae    801013b8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101392:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	7f e7                	jg     80101380 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101399:	85 f6                	test   %esi,%esi
8010139b:	75 e7                	jne    80101384 <iget+0x34>
8010139d:	89 d8                	mov    %ebx,%eax
8010139f:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013a5:	85 c9                	test   %ecx,%ecx
801013a7:	75 6e                	jne    80101417 <iget+0xc7>
801013a9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ab:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013b1:	72 df                	jb     80101392 <iget+0x42>
801013b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013b7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013b8:	85 f6                	test   %esi,%esi
801013ba:	74 73                	je     8010142f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013bc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013bf:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013c1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013c4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013cb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013d2:	68 e0 19 11 80       	push   $0x801119e0
801013d7:	e8 24 34 00 00       	call   80104800 <release>

  return ip;
801013dc:	83 c4 10             	add    $0x10,%esp
}
801013df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013e2:	89 f0                	mov    %esi,%eax
801013e4:	5b                   	pop    %ebx
801013e5:	5e                   	pop    %esi
801013e6:	5f                   	pop    %edi
801013e7:	5d                   	pop    %ebp
801013e8:	c3                   	ret    
801013e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013f0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013f3:	75 8f                	jne    80101384 <iget+0x34>
      release(&icache.lock);
801013f5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013f8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013fb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013fd:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101402:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101405:	e8 f6 33 00 00       	call   80104800 <release>
      return ip;
8010140a:	83 c4 10             	add    $0x10,%esp
}
8010140d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101410:	89 f0                	mov    %esi,%eax
80101412:	5b                   	pop    %ebx
80101413:	5e                   	pop    %esi
80101414:	5f                   	pop    %edi
80101415:	5d                   	pop    %ebp
80101416:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101417:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010141d:	73 10                	jae    8010142f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010141f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101422:	85 c9                	test   %ecx,%ecx
80101424:	0f 8f 56 ff ff ff    	jg     80101380 <iget+0x30>
8010142a:	e9 6e ff ff ff       	jmp    8010139d <iget+0x4d>
    panic("iget: no inodes");
8010142f:	83 ec 0c             	sub    $0xc,%esp
80101432:	68 68 7c 10 80       	push   $0x80107c68
80101437:	e8 54 ef ff ff       	call   80100390 <panic>
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101440 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	57                   	push   %edi
80101444:	56                   	push   %esi
80101445:	89 c6                	mov    %eax,%esi
80101447:	53                   	push   %ebx
80101448:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010144b:	83 fa 0b             	cmp    $0xb,%edx
8010144e:	0f 86 84 00 00 00    	jbe    801014d8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101454:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101457:	83 fb 7f             	cmp    $0x7f,%ebx
8010145a:	0f 87 98 00 00 00    	ja     801014f8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101460:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101466:	8b 16                	mov    (%esi),%edx
80101468:	85 c0                	test   %eax,%eax
8010146a:	74 54                	je     801014c0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010146c:	83 ec 08             	sub    $0x8,%esp
8010146f:	50                   	push   %eax
80101470:	52                   	push   %edx
80101471:	e8 5a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101476:	83 c4 10             	add    $0x10,%esp
80101479:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010147d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010147f:	8b 1a                	mov    (%edx),%ebx
80101481:	85 db                	test   %ebx,%ebx
80101483:	74 1b                	je     801014a0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101485:	83 ec 0c             	sub    $0xc,%esp
80101488:	57                   	push   %edi
80101489:	e8 62 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010148e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101491:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101494:	89 d8                	mov    %ebx,%eax
80101496:	5b                   	pop    %ebx
80101497:	5e                   	pop    %esi
80101498:	5f                   	pop    %edi
80101499:	5d                   	pop    %ebp
8010149a:	c3                   	ret    
8010149b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010149f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014a0:	8b 06                	mov    (%esi),%eax
801014a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014a5:	e8 96 fd ff ff       	call   80101240 <balloc>
801014aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ad:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b0:	89 c3                	mov    %eax,%ebx
801014b2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014b4:	57                   	push   %edi
801014b5:	e8 66 1a 00 00       	call   80102f20 <log_write>
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	eb c6                	jmp    80101485 <bmap+0x45>
801014bf:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014c0:	89 d0                	mov    %edx,%eax
801014c2:	e8 79 fd ff ff       	call   80101240 <balloc>
801014c7:	8b 16                	mov    (%esi),%edx
801014c9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014cf:	eb 9b                	jmp    8010146c <bmap+0x2c>
801014d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014d8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014db:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014de:	85 db                	test   %ebx,%ebx
801014e0:	75 af                	jne    80101491 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014e2:	8b 00                	mov    (%eax),%eax
801014e4:	e8 57 fd ff ff       	call   80101240 <balloc>
801014e9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ec:	89 c3                	mov    %eax,%ebx
}
801014ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014f1:	89 d8                	mov    %ebx,%eax
801014f3:	5b                   	pop    %ebx
801014f4:	5e                   	pop    %esi
801014f5:	5f                   	pop    %edi
801014f6:	5d                   	pop    %ebp
801014f7:	c3                   	ret    
  panic("bmap: out of range");
801014f8:	83 ec 0c             	sub    $0xc,%esp
801014fb:	68 78 7c 10 80       	push   $0x80107c78
80101500:	e8 8b ee ff ff       	call   80100390 <panic>
80101505:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101510 <readsb>:
{
80101510:	f3 0f 1e fb          	endbr32 
80101514:	55                   	push   %ebp
80101515:	89 e5                	mov    %esp,%ebp
80101517:	56                   	push   %esi
80101518:	53                   	push   %ebx
80101519:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010151c:	83 ec 08             	sub    $0x8,%esp
8010151f:	6a 01                	push   $0x1
80101521:	ff 75 08             	pushl  0x8(%ebp)
80101524:	e8 a7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101529:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010152c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010152e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101531:	6a 1c                	push   $0x1c
80101533:	50                   	push   %eax
80101534:	56                   	push   %esi
80101535:	e8 b6 33 00 00       	call   801048f0 <memmove>
  brelse(bp);
8010153a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010153d:	83 c4 10             	add    $0x10,%esp
}
80101540:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5d                   	pop    %ebp
  brelse(bp);
80101546:	e9 a5 ec ff ff       	jmp    801001f0 <brelse>
8010154b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010154f:	90                   	nop

80101550 <iinit>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	53                   	push   %ebx
80101558:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010155d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101560:	68 8b 7c 10 80       	push   $0x80107c8b
80101565:	68 e0 19 11 80       	push   $0x801119e0
8010156a:	e8 51 30 00 00       	call   801045c0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010156f:	83 c4 10             	add    $0x10,%esp
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101578:	83 ec 08             	sub    $0x8,%esp
8010157b:	68 92 7c 10 80       	push   $0x80107c92
80101580:	53                   	push   %ebx
80101581:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101587:	e8 f4 2e 00 00       	call   80104480 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010158c:	83 c4 10             	add    $0x10,%esp
8010158f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101595:	75 e1                	jne    80101578 <iinit+0x28>
  readsb(dev, &sb);
80101597:	83 ec 08             	sub    $0x8,%esp
8010159a:	68 c0 19 11 80       	push   $0x801119c0
8010159f:	ff 75 08             	pushl  0x8(%ebp)
801015a2:	e8 69 ff ff ff       	call   80101510 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015a7:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015ad:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015b3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015b9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015bf:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015c5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015cb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015d1:	68 f8 7c 10 80       	push   $0x80107cf8
801015d6:	e8 d5 f0 ff ff       	call   801006b0 <cprintf>
}
801015db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015de:	83 c4 30             	add    $0x30,%esp
801015e1:	c9                   	leave  
801015e2:	c3                   	ret    
801015e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015f0 <ialloc>:
{
801015f0:	f3 0f 1e fb          	endbr32 
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	57                   	push   %edi
801015f8:	56                   	push   %esi
801015f9:	53                   	push   %ebx
801015fa:	83 ec 1c             	sub    $0x1c,%esp
801015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101600:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101607:	8b 75 08             	mov    0x8(%ebp),%esi
8010160a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010160d:	0f 86 8d 00 00 00    	jbe    801016a0 <ialloc+0xb0>
80101613:	bf 01 00 00 00       	mov    $0x1,%edi
80101618:	eb 1d                	jmp    80101637 <ialloc+0x47>
8010161a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101620:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101623:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101626:	53                   	push   %ebx
80101627:	e8 c4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010162c:	83 c4 10             	add    $0x10,%esp
8010162f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101635:	73 69                	jae    801016a0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101637:	89 f8                	mov    %edi,%eax
80101639:	83 ec 08             	sub    $0x8,%esp
8010163c:	c1 e8 03             	shr    $0x3,%eax
8010163f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101645:	50                   	push   %eax
80101646:	56                   	push   %esi
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010164c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010164f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101651:	89 f8                	mov    %edi,%eax
80101653:	83 e0 07             	and    $0x7,%eax
80101656:	c1 e0 06             	shl    $0x6,%eax
80101659:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010165d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101661:	75 bd                	jne    80101620 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101663:	83 ec 04             	sub    $0x4,%esp
80101666:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101669:	6a 40                	push   $0x40
8010166b:	6a 00                	push   $0x0
8010166d:	51                   	push   %ecx
8010166e:	e8 dd 31 00 00       	call   80104850 <memset>
      dip->type = type;
80101673:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101677:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010167a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010167d:	89 1c 24             	mov    %ebx,(%esp)
80101680:	e8 9b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
80101685:	89 1c 24             	mov    %ebx,(%esp)
80101688:	e8 63 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010168d:	83 c4 10             	add    $0x10,%esp
}
80101690:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101693:	89 fa                	mov    %edi,%edx
}
80101695:	5b                   	pop    %ebx
      return iget(dev, inum);
80101696:	89 f0                	mov    %esi,%eax
}
80101698:	5e                   	pop    %esi
80101699:	5f                   	pop    %edi
8010169a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010169b:	e9 b0 fc ff ff       	jmp    80101350 <iget>
  panic("ialloc: no inodes");
801016a0:	83 ec 0c             	sub    $0xc,%esp
801016a3:	68 98 7c 10 80       	push   $0x80107c98
801016a8:	e8 e3 ec ff ff       	call   80100390 <panic>
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <iupdate>:
{
801016b0:	f3 0f 1e fb          	endbr32 
801016b4:	55                   	push   %ebp
801016b5:	89 e5                	mov    %esp,%ebp
801016b7:	56                   	push   %esi
801016b8:	53                   	push   %ebx
801016b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016bc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bf:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016c2:	83 ec 08             	sub    $0x8,%esp
801016c5:	c1 e8 03             	shr    $0x3,%eax
801016c8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016ce:	50                   	push   %eax
801016cf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016d2:	e8 f9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016d7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016db:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016de:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016e3:	83 e0 07             	and    $0x7,%eax
801016e6:	c1 e0 06             	shl    $0x6,%eax
801016e9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016ed:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016f4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016f7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016fb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ff:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101703:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101707:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010170b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010170e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101711:	6a 34                	push   $0x34
80101713:	53                   	push   %ebx
80101714:	50                   	push   %eax
80101715:	e8 d6 31 00 00       	call   801048f0 <memmove>
  log_write(bp);
8010171a:	89 34 24             	mov    %esi,(%esp)
8010171d:	e8 fe 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101722:	89 75 08             	mov    %esi,0x8(%ebp)
80101725:	83 c4 10             	add    $0x10,%esp
}
80101728:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010172b:	5b                   	pop    %ebx
8010172c:	5e                   	pop    %esi
8010172d:	5d                   	pop    %ebp
  brelse(bp);
8010172e:	e9 bd ea ff ff       	jmp    801001f0 <brelse>
80101733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010173a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101740 <idup>:
{
80101740:	f3 0f 1e fb          	endbr32 
80101744:	55                   	push   %ebp
80101745:	89 e5                	mov    %esp,%ebp
80101747:	53                   	push   %ebx
80101748:	83 ec 10             	sub    $0x10,%esp
8010174b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010174e:	68 e0 19 11 80       	push   $0x801119e0
80101753:	e8 e8 2f 00 00       	call   80104740 <acquire>
  ip->ref++;
80101758:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010175c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101763:	e8 98 30 00 00       	call   80104800 <release>
}
80101768:	89 d8                	mov    %ebx,%eax
8010176a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010176d:	c9                   	leave  
8010176e:	c3                   	ret    
8010176f:	90                   	nop

80101770 <ilock>:
{
80101770:	f3 0f 1e fb          	endbr32 
80101774:	55                   	push   %ebp
80101775:	89 e5                	mov    %esp,%ebp
80101777:	56                   	push   %esi
80101778:	53                   	push   %ebx
80101779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010177c:	85 db                	test   %ebx,%ebx
8010177e:	0f 84 b3 00 00 00    	je     80101837 <ilock+0xc7>
80101784:	8b 53 08             	mov    0x8(%ebx),%edx
80101787:	85 d2                	test   %edx,%edx
80101789:	0f 8e a8 00 00 00    	jle    80101837 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010178f:	83 ec 0c             	sub    $0xc,%esp
80101792:	8d 43 0c             	lea    0xc(%ebx),%eax
80101795:	50                   	push   %eax
80101796:	e8 25 2d 00 00       	call   801044c0 <acquiresleep>
  if(ip->valid == 0){
8010179b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	85 c0                	test   %eax,%eax
801017a3:	74 0b                	je     801017b0 <ilock+0x40>
}
801017a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017a8:	5b                   	pop    %ebx
801017a9:	5e                   	pop    %esi
801017aa:	5d                   	pop    %ebp
801017ab:	c3                   	ret    
801017ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b0:	8b 43 04             	mov    0x4(%ebx),%eax
801017b3:	83 ec 08             	sub    $0x8,%esp
801017b6:	c1 e8 03             	shr    $0x3,%eax
801017b9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017bf:	50                   	push   %eax
801017c0:	ff 33                	pushl  (%ebx)
801017c2:	e8 09 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017c7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ca:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017cc:	8b 43 04             	mov    0x4(%ebx),%eax
801017cf:	83 e0 07             	and    $0x7,%eax
801017d2:	c1 e0 06             	shl    $0x6,%eax
801017d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017d9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101801:	6a 34                	push   $0x34
80101803:	50                   	push   %eax
80101804:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101807:	50                   	push   %eax
80101808:	e8 e3 30 00 00       	call   801048f0 <memmove>
    brelse(bp);
8010180d:	89 34 24             	mov    %esi,(%esp)
80101810:	e8 db e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101815:	83 c4 10             	add    $0x10,%esp
80101818:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010181d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101824:	0f 85 7b ff ff ff    	jne    801017a5 <ilock+0x35>
      panic("ilock: no type");
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	68 b0 7c 10 80       	push   $0x80107cb0
80101832:	e8 59 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101837:	83 ec 0c             	sub    $0xc,%esp
8010183a:	68 aa 7c 10 80       	push   $0x80107caa
8010183f:	e8 4c eb ff ff       	call   80100390 <panic>
80101844:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010184b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010184f:	90                   	nop

80101850 <iunlock>:
{
80101850:	f3 0f 1e fb          	endbr32 
80101854:	55                   	push   %ebp
80101855:	89 e5                	mov    %esp,%ebp
80101857:	56                   	push   %esi
80101858:	53                   	push   %ebx
80101859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010185c:	85 db                	test   %ebx,%ebx
8010185e:	74 28                	je     80101888 <iunlock+0x38>
80101860:	83 ec 0c             	sub    $0xc,%esp
80101863:	8d 73 0c             	lea    0xc(%ebx),%esi
80101866:	56                   	push   %esi
80101867:	e8 f4 2c 00 00       	call   80104560 <holdingsleep>
8010186c:	83 c4 10             	add    $0x10,%esp
8010186f:	85 c0                	test   %eax,%eax
80101871:	74 15                	je     80101888 <iunlock+0x38>
80101873:	8b 43 08             	mov    0x8(%ebx),%eax
80101876:	85 c0                	test   %eax,%eax
80101878:	7e 0e                	jle    80101888 <iunlock+0x38>
  releasesleep(&ip->lock);
8010187a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010187d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101880:	5b                   	pop    %ebx
80101881:	5e                   	pop    %esi
80101882:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101883:	e9 98 2c 00 00       	jmp    80104520 <releasesleep>
    panic("iunlock");
80101888:	83 ec 0c             	sub    $0xc,%esp
8010188b:	68 bf 7c 10 80       	push   $0x80107cbf
80101890:	e8 fb ea ff ff       	call   80100390 <panic>
80101895:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018a0 <iput>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	57                   	push   %edi
801018a8:	56                   	push   %esi
801018a9:	53                   	push   %ebx
801018aa:	83 ec 28             	sub    $0x28,%esp
801018ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018b0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018b3:	57                   	push   %edi
801018b4:	e8 07 2c 00 00       	call   801044c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018b9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 d2                	test   %edx,%edx
801018c1:	74 07                	je     801018ca <iput+0x2a>
801018c3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018c8:	74 36                	je     80101900 <iput+0x60>
  releasesleep(&ip->lock);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	57                   	push   %edi
801018ce:	e8 4d 2c 00 00       	call   80104520 <releasesleep>
  acquire(&icache.lock);
801018d3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018da:	e8 61 2e 00 00       	call   80104740 <acquire>
  ip->ref--;
801018df:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018e3:	83 c4 10             	add    $0x10,%esp
801018e6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018f0:	5b                   	pop    %ebx
801018f1:	5e                   	pop    %esi
801018f2:	5f                   	pop    %edi
801018f3:	5d                   	pop    %ebp
  release(&icache.lock);
801018f4:	e9 07 2f 00 00       	jmp    80104800 <release>
801018f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 e0 19 11 80       	push   $0x801119e0
80101908:	e8 33 2e 00 00       	call   80104740 <acquire>
    int r = ip->ref;
8010190d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101910:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101917:	e8 e4 2e 00 00       	call   80104800 <release>
    if(r == 1){
8010191c:	83 c4 10             	add    $0x10,%esp
8010191f:	83 fe 01             	cmp    $0x1,%esi
80101922:	75 a6                	jne    801018ca <iput+0x2a>
80101924:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010192a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010192d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101930:	89 cf                	mov    %ecx,%edi
80101932:	eb 0b                	jmp    8010193f <iput+0x9f>
80101934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101938:	83 c6 04             	add    $0x4,%esi
8010193b:	39 fe                	cmp    %edi,%esi
8010193d:	74 19                	je     80101958 <iput+0xb8>
    if(ip->addrs[i]){
8010193f:	8b 16                	mov    (%esi),%edx
80101941:	85 d2                	test   %edx,%edx
80101943:	74 f3                	je     80101938 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101945:	8b 03                	mov    (%ebx),%eax
80101947:	e8 74 f8 ff ff       	call   801011c0 <bfree>
      ip->addrs[i] = 0;
8010194c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101952:	eb e4                	jmp    80101938 <iput+0x98>
80101954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101958:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010195e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101961:	85 c0                	test   %eax,%eax
80101963:	75 33                	jne    80101998 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101965:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101968:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010196f:	53                   	push   %ebx
80101970:	e8 3b fd ff ff       	call   801016b0 <iupdate>
      ip->type = 0;
80101975:	31 c0                	xor    %eax,%eax
80101977:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010197b:	89 1c 24             	mov    %ebx,(%esp)
8010197e:	e8 2d fd ff ff       	call   801016b0 <iupdate>
      ip->valid = 0;
80101983:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010198a:	83 c4 10             	add    $0x10,%esp
8010198d:	e9 38 ff ff ff       	jmp    801018ca <iput+0x2a>
80101992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101998:	83 ec 08             	sub    $0x8,%esp
8010199b:	50                   	push   %eax
8010199c:	ff 33                	pushl  (%ebx)
8010199e:	e8 2d e7 ff ff       	call   801000d0 <bread>
801019a3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019a6:	83 c4 10             	add    $0x10,%esp
801019a9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019b2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019b5:	89 cf                	mov    %ecx,%edi
801019b7:	eb 0e                	jmp    801019c7 <iput+0x127>
801019b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019c0:	83 c6 04             	add    $0x4,%esi
801019c3:	39 f7                	cmp    %esi,%edi
801019c5:	74 19                	je     801019e0 <iput+0x140>
      if(a[j])
801019c7:	8b 16                	mov    (%esi),%edx
801019c9:	85 d2                	test   %edx,%edx
801019cb:	74 f3                	je     801019c0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019cd:	8b 03                	mov    (%ebx),%eax
801019cf:	e8 ec f7 ff ff       	call   801011c0 <bfree>
801019d4:	eb ea                	jmp    801019c0 <iput+0x120>
801019d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019dd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019e0:	83 ec 0c             	sub    $0xc,%esp
801019e3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019e6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019e9:	e8 02 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ee:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019f4:	8b 03                	mov    (%ebx),%eax
801019f6:	e8 c5 f7 ff ff       	call   801011c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019fb:	83 c4 10             	add    $0x10,%esp
801019fe:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a05:	00 00 00 
80101a08:	e9 58 ff ff ff       	jmp    80101965 <iput+0xc5>
80101a0d:	8d 76 00             	lea    0x0(%esi),%esi

80101a10 <iunlockput>:
{
80101a10:	f3 0f 1e fb          	endbr32 
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	53                   	push   %ebx
80101a18:	83 ec 10             	sub    $0x10,%esp
80101a1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a1e:	53                   	push   %ebx
80101a1f:	e8 2c fe ff ff       	call   80101850 <iunlock>
  iput(ip);
80101a24:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a27:	83 c4 10             	add    $0x10,%esp
}
80101a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a2d:	c9                   	leave  
  iput(ip);
80101a2e:	e9 6d fe ff ff       	jmp    801018a0 <iput>
80101a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a40 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a40:	f3 0f 1e fb          	endbr32 
80101a44:	55                   	push   %ebp
80101a45:	89 e5                	mov    %esp,%ebp
80101a47:	8b 55 08             	mov    0x8(%ebp),%edx
80101a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a4d:	8b 0a                	mov    (%edx),%ecx
80101a4f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a52:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a55:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a58:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a5c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a5f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a63:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a67:	8b 52 58             	mov    0x58(%edx),%edx
80101a6a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a6d:	5d                   	pop    %ebp
80101a6e:	c3                   	ret    
80101a6f:	90                   	nop

80101a70 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a70:	f3 0f 1e fb          	endbr32 
80101a74:	55                   	push   %ebp
80101a75:	89 e5                	mov    %esp,%ebp
80101a77:	57                   	push   %edi
80101a78:	56                   	push   %esi
80101a79:	53                   	push   %ebx
80101a7a:	83 ec 1c             	sub    $0x1c,%esp
80101a7d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a80:	8b 45 08             	mov    0x8(%ebp),%eax
80101a83:	8b 75 10             	mov    0x10(%ebp),%esi
80101a86:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a89:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a8c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a91:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a94:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a97:	0f 84 a3 00 00 00    	je     80101b40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aa0:	8b 40 58             	mov    0x58(%eax),%eax
80101aa3:	39 c6                	cmp    %eax,%esi
80101aa5:	0f 87 b6 00 00 00    	ja     80101b61 <readi+0xf1>
80101aab:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aae:	31 c9                	xor    %ecx,%ecx
80101ab0:	89 da                	mov    %ebx,%edx
80101ab2:	01 f2                	add    %esi,%edx
80101ab4:	0f 92 c1             	setb   %cl
80101ab7:	89 cf                	mov    %ecx,%edi
80101ab9:	0f 82 a2 00 00 00    	jb     80101b61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101abf:	89 c1                	mov    %eax,%ecx
80101ac1:	29 f1                	sub    %esi,%ecx
80101ac3:	39 d0                	cmp    %edx,%eax
80101ac5:	0f 43 cb             	cmovae %ebx,%ecx
80101ac8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101acb:	85 c9                	test   %ecx,%ecx
80101acd:	74 63                	je     80101b32 <readi+0xc2>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 d8                	mov    %ebx,%eax
80101ada:	e8 61 f9 ff ff       	call   80101440 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 33                	pushl  (%ebx)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aed:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101af7:	89 f0                	mov    %esi,%eax
80101af9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afe:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b00:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b03:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b05:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b09:	39 d9                	cmp    %ebx,%ecx
80101b0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b0e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0f:	01 df                	add    %ebx,%edi
80101b11:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b13:	50                   	push   %eax
80101b14:	ff 75 e0             	pushl  -0x20(%ebp)
80101b17:	e8 d4 2d 00 00       	call   801048f0 <memmove>
    brelse(bp);
80101b1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b1f:	89 14 24             	mov    %edx,(%esp)
80101b22:	e8 c9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b2a:	83 c4 10             	add    $0x10,%esp
80101b2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b30:	77 9e                	ja     80101ad0 <readi+0x60>
  }
  return n;
80101b32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b38:	5b                   	pop    %ebx
80101b39:	5e                   	pop    %esi
80101b3a:	5f                   	pop    %edi
80101b3b:	5d                   	pop    %ebp
80101b3c:	c3                   	ret    
80101b3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b44:	66 83 f8 09          	cmp    $0x9,%ax
80101b48:	77 17                	ja     80101b61 <readi+0xf1>
80101b4a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b51:	85 c0                	test   %eax,%eax
80101b53:	74 0c                	je     80101b61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b5b:	5b                   	pop    %ebx
80101b5c:	5e                   	pop    %esi
80101b5d:	5f                   	pop    %edi
80101b5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b5f:	ff e0                	jmp    *%eax
      return -1;
80101b61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b66:	eb cd                	jmp    80101b35 <readi+0xc5>
80101b68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b6f:	90                   	nop

80101b70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b70:	f3 0f 1e fb          	endbr32 
80101b74:	55                   	push   %ebp
80101b75:	89 e5                	mov    %esp,%ebp
80101b77:	57                   	push   %edi
80101b78:	56                   	push   %esi
80101b79:	53                   	push   %ebx
80101b7a:	83 ec 1c             	sub    $0x1c,%esp
80101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b80:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b83:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b86:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b8b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b91:	8b 75 10             	mov    0x10(%ebp),%esi
80101b94:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b97:	0f 84 b3 00 00 00    	je     80101c50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b9d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ba0:	39 70 58             	cmp    %esi,0x58(%eax)
80101ba3:	0f 82 e3 00 00 00    	jb     80101c8c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ba9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bac:	89 f8                	mov    %edi,%eax
80101bae:	01 f0                	add    %esi,%eax
80101bb0:	0f 82 d6 00 00 00    	jb     80101c8c <writei+0x11c>
80101bb6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bbb:	0f 87 cb 00 00 00    	ja     80101c8c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bc8:	85 ff                	test   %edi,%edi
80101bca:	74 75                	je     80101c41 <writei+0xd1>
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bd0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bd3:	89 f2                	mov    %esi,%edx
80101bd5:	c1 ea 09             	shr    $0x9,%edx
80101bd8:	89 f8                	mov    %edi,%eax
80101bda:	e8 61 f8 ff ff       	call   80101440 <bmap>
80101bdf:	83 ec 08             	sub    $0x8,%esp
80101be2:	50                   	push   %eax
80101be3:	ff 37                	pushl  (%edi)
80101be5:	e8 e6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bea:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bef:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101bf2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bf5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	89 f0                	mov    %esi,%eax
80101bf9:	83 c4 0c             	add    $0xc,%esp
80101bfc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c07:	39 d9                	cmp    %ebx,%ecx
80101c09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c0c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c0d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c0f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c12:	50                   	push   %eax
80101c13:	e8 d8 2c 00 00       	call   801048f0 <memmove>
    log_write(bp);
80101c18:	89 3c 24             	mov    %edi,(%esp)
80101c1b:	e8 00 13 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101c20:	89 3c 24             	mov    %edi,(%esp)
80101c23:	e8 c8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c2b:	83 c4 10             	add    $0x10,%esp
80101c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c31:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c37:	77 97                	ja     80101bd0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c3f:	77 37                	ja     80101c78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c47:	5b                   	pop    %ebx
80101c48:	5e                   	pop    %esi
80101c49:	5f                   	pop    %edi
80101c4a:	5d                   	pop    %ebp
80101c4b:	c3                   	ret    
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c54:	66 83 f8 09          	cmp    $0x9,%ax
80101c58:	77 32                	ja     80101c8c <writei+0x11c>
80101c5a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c61:	85 c0                	test   %eax,%eax
80101c63:	74 27                	je     80101c8c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c6b:	5b                   	pop    %ebx
80101c6c:	5e                   	pop    %esi
80101c6d:	5f                   	pop    %edi
80101c6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c6f:	ff e0                	jmp    *%eax
80101c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c81:	50                   	push   %eax
80101c82:	e8 29 fa ff ff       	call   801016b0 <iupdate>
80101c87:	83 c4 10             	add    $0x10,%esp
80101c8a:	eb b5                	jmp    80101c41 <writei+0xd1>
      return -1;
80101c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c91:	eb b1                	jmp    80101c44 <writei+0xd4>
80101c93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ca0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ca0:	f3 0f 1e fb          	endbr32 
80101ca4:	55                   	push   %ebp
80101ca5:	89 e5                	mov    %esp,%ebp
80101ca7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101caa:	6a 0e                	push   $0xe
80101cac:	ff 75 0c             	pushl  0xc(%ebp)
80101caf:	ff 75 08             	pushl  0x8(%ebp)
80101cb2:	e8 a9 2c 00 00       	call   80104960 <strncmp>
}
80101cb7:	c9                   	leave  
80101cb8:	c3                   	ret    
80101cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cc0:	f3 0f 1e fb          	endbr32 
80101cc4:	55                   	push   %ebp
80101cc5:	89 e5                	mov    %esp,%ebp
80101cc7:	57                   	push   %edi
80101cc8:	56                   	push   %esi
80101cc9:	53                   	push   %ebx
80101cca:	83 ec 1c             	sub    $0x1c,%esp
80101ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cd5:	0f 85 89 00 00 00    	jne    80101d64 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101cdb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cde:	31 ff                	xor    %edi,%edi
80101ce0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ce3:	85 d2                	test   %edx,%edx
80101ce5:	74 42                	je     80101d29 <dirlookup+0x69>
80101ce7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cee:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cf0:	6a 10                	push   $0x10
80101cf2:	57                   	push   %edi
80101cf3:	56                   	push   %esi
80101cf4:	53                   	push   %ebx
80101cf5:	e8 76 fd ff ff       	call   80101a70 <readi>
80101cfa:	83 c4 10             	add    $0x10,%esp
80101cfd:	83 f8 10             	cmp    $0x10,%eax
80101d00:	75 55                	jne    80101d57 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d02:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d07:	74 18                	je     80101d21 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d09:	83 ec 04             	sub    $0x4,%esp
80101d0c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d0f:	6a 0e                	push   $0xe
80101d11:	50                   	push   %eax
80101d12:	ff 75 0c             	pushl  0xc(%ebp)
80101d15:	e8 46 2c 00 00       	call   80104960 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d1a:	83 c4 10             	add    $0x10,%esp
80101d1d:	85 c0                	test   %eax,%eax
80101d1f:	74 17                	je     80101d38 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d21:	83 c7 10             	add    $0x10,%edi
80101d24:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d27:	72 c7                	jb     80101cf0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d2c:	31 c0                	xor    %eax,%eax
}
80101d2e:	5b                   	pop    %ebx
80101d2f:	5e                   	pop    %esi
80101d30:	5f                   	pop    %edi
80101d31:	5d                   	pop    %ebp
80101d32:	c3                   	ret    
80101d33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d37:	90                   	nop
      if(poff)
80101d38:	8b 45 10             	mov    0x10(%ebp),%eax
80101d3b:	85 c0                	test   %eax,%eax
80101d3d:	74 05                	je     80101d44 <dirlookup+0x84>
        *poff = off;
80101d3f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d42:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d44:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d48:	8b 03                	mov    (%ebx),%eax
80101d4a:	e8 01 f6 ff ff       	call   80101350 <iget>
}
80101d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d52:	5b                   	pop    %ebx
80101d53:	5e                   	pop    %esi
80101d54:	5f                   	pop    %edi
80101d55:	5d                   	pop    %ebp
80101d56:	c3                   	ret    
      panic("dirlookup read");
80101d57:	83 ec 0c             	sub    $0xc,%esp
80101d5a:	68 d9 7c 10 80       	push   $0x80107cd9
80101d5f:	e8 2c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	68 c7 7c 10 80       	push   $0x80107cc7
80101d6c:	e8 1f e6 ff ff       	call   80100390 <panic>
80101d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d7f:	90                   	nop

80101d80 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d80:	55                   	push   %ebp
80101d81:	89 e5                	mov    %esp,%ebp
80101d83:	57                   	push   %edi
80101d84:	56                   	push   %esi
80101d85:	53                   	push   %ebx
80101d86:	89 c3                	mov    %eax,%ebx
80101d88:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d8b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d8e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d91:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d94:	0f 84 86 01 00 00    	je     80101f20 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d9a:	e8 31 1d 00 00       	call   80103ad0 <myproc>
  acquire(&icache.lock);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101da4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101da7:	68 e0 19 11 80       	push   $0x801119e0
80101dac:	e8 8f 29 00 00       	call   80104740 <acquire>
  ip->ref++;
80101db1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101db5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dbc:	e8 3f 2a 00 00       	call   80104800 <release>
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	eb 0d                	jmp    80101dd3 <namex+0x53>
80101dc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dd0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dd3:	0f b6 07             	movzbl (%edi),%eax
80101dd6:	3c 2f                	cmp    $0x2f,%al
80101dd8:	74 f6                	je     80101dd0 <namex+0x50>
  if(*path == 0)
80101dda:	84 c0                	test   %al,%al
80101ddc:	0f 84 ee 00 00 00    	je     80101ed0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101de2:	0f b6 07             	movzbl (%edi),%eax
80101de5:	84 c0                	test   %al,%al
80101de7:	0f 84 fb 00 00 00    	je     80101ee8 <namex+0x168>
80101ded:	89 fb                	mov    %edi,%ebx
80101def:	3c 2f                	cmp    $0x2f,%al
80101df1:	0f 84 f1 00 00 00    	je     80101ee8 <namex+0x168>
80101df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dfe:	66 90                	xchg   %ax,%ax
80101e00:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e04:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e07:	3c 2f                	cmp    $0x2f,%al
80101e09:	74 04                	je     80101e0f <namex+0x8f>
80101e0b:	84 c0                	test   %al,%al
80101e0d:	75 f1                	jne    80101e00 <namex+0x80>
  len = path - s;
80101e0f:	89 d8                	mov    %ebx,%eax
80101e11:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e13:	83 f8 0d             	cmp    $0xd,%eax
80101e16:	0f 8e 84 00 00 00    	jle    80101ea0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e1c:	83 ec 04             	sub    $0x4,%esp
80101e1f:	6a 0e                	push   $0xe
80101e21:	57                   	push   %edi
    path++;
80101e22:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e24:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e27:	e8 c4 2a 00 00       	call   801048f0 <memmove>
80101e2c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e2f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e32:	75 0c                	jne    80101e40 <namex+0xc0>
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e38:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e3b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e3e:	74 f8                	je     80101e38 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	56                   	push   %esi
80101e44:	e8 27 f9 ff ff       	call   80101770 <ilock>
    if(ip->type != T_DIR){
80101e49:	83 c4 10             	add    $0x10,%esp
80101e4c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e51:	0f 85 a1 00 00 00    	jne    80101ef8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e5a:	85 d2                	test   %edx,%edx
80101e5c:	74 09                	je     80101e67 <namex+0xe7>
80101e5e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e61:	0f 84 d9 00 00 00    	je     80101f40 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e67:	83 ec 04             	sub    $0x4,%esp
80101e6a:	6a 00                	push   $0x0
80101e6c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e6f:	56                   	push   %esi
80101e70:	e8 4b fe ff ff       	call   80101cc0 <dirlookup>
80101e75:	83 c4 10             	add    $0x10,%esp
80101e78:	89 c3                	mov    %eax,%ebx
80101e7a:	85 c0                	test   %eax,%eax
80101e7c:	74 7a                	je     80101ef8 <namex+0x178>
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 c9 f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	89 de                	mov    %ebx,%esi
80101e8c:	e8 0f fa ff ff       	call   801018a0 <iput>
80101e91:	83 c4 10             	add    $0x10,%esp
80101e94:	e9 3a ff ff ff       	jmp    80101dd3 <namex+0x53>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ea3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ea6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ea9:	83 ec 04             	sub    $0x4,%esp
80101eac:	50                   	push   %eax
80101ead:	57                   	push   %edi
    name[len] = 0;
80101eae:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101eb0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eb3:	e8 38 2a 00 00       	call   801048f0 <memmove>
    name[len] = 0;
80101eb8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101ebb:	83 c4 10             	add    $0x10,%esp
80101ebe:	c6 00 00             	movb   $0x0,(%eax)
80101ec1:	e9 69 ff ff ff       	jmp    80101e2f <namex+0xaf>
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ed3:	85 c0                	test   %eax,%eax
80101ed5:	0f 85 85 00 00 00    	jne    80101f60 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101edb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ede:	89 f0                	mov    %esi,%eax
80101ee0:	5b                   	pop    %ebx
80101ee1:	5e                   	pop    %esi
80101ee2:	5f                   	pop    %edi
80101ee3:	5d                   	pop    %ebp
80101ee4:	c3                   	ret    
80101ee5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ee8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101eeb:	89 fb                	mov    %edi,%ebx
80101eed:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ef0:	31 c0                	xor    %eax,%eax
80101ef2:	eb b5                	jmp    80101ea9 <namex+0x129>
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	56                   	push   %esi
80101efc:	e8 4f f9 ff ff       	call   80101850 <iunlock>
  iput(ip);
80101f01:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f04:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f06:	e8 95 f9 ff ff       	call   801018a0 <iput>
      return 0;
80101f0b:	83 c4 10             	add    $0x10,%esp
}
80101f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f11:	89 f0                	mov    %esi,%eax
80101f13:	5b                   	pop    %ebx
80101f14:	5e                   	pop    %esi
80101f15:	5f                   	pop    %edi
80101f16:	5d                   	pop    %ebp
80101f17:	c3                   	ret    
80101f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f20:	ba 01 00 00 00       	mov    $0x1,%edx
80101f25:	b8 01 00 00 00       	mov    $0x1,%eax
80101f2a:	89 df                	mov    %ebx,%edi
80101f2c:	e8 1f f4 ff ff       	call   80101350 <iget>
80101f31:	89 c6                	mov    %eax,%esi
80101f33:	e9 9b fe ff ff       	jmp    80101dd3 <namex+0x53>
80101f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f3f:	90                   	nop
      iunlock(ip);
80101f40:	83 ec 0c             	sub    $0xc,%esp
80101f43:	56                   	push   %esi
80101f44:	e8 07 f9 ff ff       	call   80101850 <iunlock>
      return ip;
80101f49:	83 c4 10             	add    $0x10,%esp
}
80101f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f4f:	89 f0                	mov    %esi,%eax
80101f51:	5b                   	pop    %ebx
80101f52:	5e                   	pop    %esi
80101f53:	5f                   	pop    %edi
80101f54:	5d                   	pop    %ebp
80101f55:	c3                   	ret    
80101f56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f60:	83 ec 0c             	sub    $0xc,%esp
80101f63:	56                   	push   %esi
    return 0;
80101f64:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f66:	e8 35 f9 ff ff       	call   801018a0 <iput>
    return 0;
80101f6b:	83 c4 10             	add    $0x10,%esp
80101f6e:	e9 68 ff ff ff       	jmp    80101edb <namex+0x15b>
80101f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f80 <dirlink>:
{
80101f80:	f3 0f 1e fb          	endbr32 
80101f84:	55                   	push   %ebp
80101f85:	89 e5                	mov    %esp,%ebp
80101f87:	57                   	push   %edi
80101f88:	56                   	push   %esi
80101f89:	53                   	push   %ebx
80101f8a:	83 ec 20             	sub    $0x20,%esp
80101f8d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f90:	6a 00                	push   $0x0
80101f92:	ff 75 0c             	pushl  0xc(%ebp)
80101f95:	53                   	push   %ebx
80101f96:	e8 25 fd ff ff       	call   80101cc0 <dirlookup>
80101f9b:	83 c4 10             	add    $0x10,%esp
80101f9e:	85 c0                	test   %eax,%eax
80101fa0:	75 6b                	jne    8010200d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fa2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fa5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa8:	85 ff                	test   %edi,%edi
80101faa:	74 2d                	je     80101fd9 <dirlink+0x59>
80101fac:	31 ff                	xor    %edi,%edi
80101fae:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fb1:	eb 0d                	jmp    80101fc0 <dirlink+0x40>
80101fb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb7:	90                   	nop
80101fb8:	83 c7 10             	add    $0x10,%edi
80101fbb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fbe:	73 19                	jae    80101fd9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fc0:	6a 10                	push   $0x10
80101fc2:	57                   	push   %edi
80101fc3:	56                   	push   %esi
80101fc4:	53                   	push   %ebx
80101fc5:	e8 a6 fa ff ff       	call   80101a70 <readi>
80101fca:	83 c4 10             	add    $0x10,%esp
80101fcd:	83 f8 10             	cmp    $0x10,%eax
80101fd0:	75 4e                	jne    80102020 <dirlink+0xa0>
    if(de.inum == 0)
80101fd2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fd7:	75 df                	jne    80101fb8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fd9:	83 ec 04             	sub    $0x4,%esp
80101fdc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fdf:	6a 0e                	push   $0xe
80101fe1:	ff 75 0c             	pushl  0xc(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	e8 c6 29 00 00       	call   801049b0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fea:	6a 10                	push   $0x10
  de.inum = inum;
80101fec:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fef:	57                   	push   %edi
80101ff0:	56                   	push   %esi
80101ff1:	53                   	push   %ebx
  de.inum = inum;
80101ff2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ff6:	e8 75 fb ff ff       	call   80101b70 <writei>
80101ffb:	83 c4 20             	add    $0x20,%esp
80101ffe:	83 f8 10             	cmp    $0x10,%eax
80102001:	75 2a                	jne    8010202d <dirlink+0xad>
  return 0;
80102003:	31 c0                	xor    %eax,%eax
}
80102005:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102008:	5b                   	pop    %ebx
80102009:	5e                   	pop    %esi
8010200a:	5f                   	pop    %edi
8010200b:	5d                   	pop    %ebp
8010200c:	c3                   	ret    
    iput(ip);
8010200d:	83 ec 0c             	sub    $0xc,%esp
80102010:	50                   	push   %eax
80102011:	e8 8a f8 ff ff       	call   801018a0 <iput>
    return -1;
80102016:	83 c4 10             	add    $0x10,%esp
80102019:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010201e:	eb e5                	jmp    80102005 <dirlink+0x85>
      panic("dirlink read");
80102020:	83 ec 0c             	sub    $0xc,%esp
80102023:	68 e8 7c 10 80       	push   $0x80107ce8
80102028:	e8 63 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010202d:	83 ec 0c             	sub    $0xc,%esp
80102030:	68 5a 83 10 80       	push   $0x8010835a
80102035:	e8 56 e3 ff ff       	call   80100390 <panic>
8010203a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102040 <namei>:

struct inode*
namei(char *path)
{
80102040:	f3 0f 1e fb          	endbr32 
80102044:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102045:	31 d2                	xor    %edx,%edx
{
80102047:	89 e5                	mov    %esp,%ebp
80102049:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010204c:	8b 45 08             	mov    0x8(%ebp),%eax
8010204f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102052:	e8 29 fd ff ff       	call   80101d80 <namex>
}
80102057:	c9                   	leave  
80102058:	c3                   	ret    
80102059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102060 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102060:	f3 0f 1e fb          	endbr32 
80102064:	55                   	push   %ebp
  return namex(path, 1, name);
80102065:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010206a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010206c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010206f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102072:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102073:	e9 08 fd ff ff       	jmp    80101d80 <namex>
80102078:	66 90                	xchg   %ax,%ax
8010207a:	66 90                	xchg   %ax,%ax
8010207c:	66 90                	xchg   %ax,%ax
8010207e:	66 90                	xchg   %ax,%ax

80102080 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102080:	55                   	push   %ebp
80102081:	89 e5                	mov    %esp,%ebp
80102083:	57                   	push   %edi
80102084:	56                   	push   %esi
80102085:	53                   	push   %ebx
80102086:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102089:	85 c0                	test   %eax,%eax
8010208b:	0f 84 b4 00 00 00    	je     80102145 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102091:	8b 70 08             	mov    0x8(%eax),%esi
80102094:	89 c3                	mov    %eax,%ebx
80102096:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010209c:	0f 87 96 00 00 00    	ja     80102138 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ae:	66 90                	xchg   %ax,%ax
801020b0:	89 ca                	mov    %ecx,%edx
801020b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020b3:	83 e0 c0             	and    $0xffffffc0,%eax
801020b6:	3c 40                	cmp    $0x40,%al
801020b8:	75 f6                	jne    801020b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020ba:	31 ff                	xor    %edi,%edi
801020bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020c1:	89 f8                	mov    %edi,%eax
801020c3:	ee                   	out    %al,(%dx)
801020c4:	b8 01 00 00 00       	mov    $0x1,%eax
801020c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020ce:	ee                   	out    %al,(%dx)
801020cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020d4:	89 f0                	mov    %esi,%eax
801020d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020d7:	89 f0                	mov    %esi,%eax
801020d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020de:	c1 f8 08             	sar    $0x8,%eax
801020e1:	ee                   	out    %al,(%dx)
801020e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020e7:	89 f8                	mov    %edi,%eax
801020e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020ea:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f3:	c1 e0 04             	shl    $0x4,%eax
801020f6:	83 e0 10             	and    $0x10,%eax
801020f9:	83 c8 e0             	or     $0xffffffe0,%eax
801020fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020fd:	f6 03 04             	testb  $0x4,(%ebx)
80102100:	75 16                	jne    80102118 <idestart+0x98>
80102102:	b8 20 00 00 00       	mov    $0x20,%eax
80102107:	89 ca                	mov    %ecx,%edx
80102109:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010210a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210d:	5b                   	pop    %ebx
8010210e:	5e                   	pop    %esi
8010210f:	5f                   	pop    %edi
80102110:	5d                   	pop    %ebp
80102111:	c3                   	ret    
80102112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102118:	b8 30 00 00 00       	mov    $0x30,%eax
8010211d:	89 ca                	mov    %ecx,%edx
8010211f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102120:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102125:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102128:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010212d:	fc                   	cld    
8010212e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102130:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102133:	5b                   	pop    %ebx
80102134:	5e                   	pop    %esi
80102135:	5f                   	pop    %edi
80102136:	5d                   	pop    %ebp
80102137:	c3                   	ret    
    panic("incorrect blockno");
80102138:	83 ec 0c             	sub    $0xc,%esp
8010213b:	68 54 7d 10 80       	push   $0x80107d54
80102140:	e8 4b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102145:	83 ec 0c             	sub    $0xc,%esp
80102148:	68 4b 7d 10 80       	push   $0x80107d4b
8010214d:	e8 3e e2 ff ff       	call   80100390 <panic>
80102152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102160 <ideinit>:
{
80102160:	f3 0f 1e fb          	endbr32 
80102164:	55                   	push   %ebp
80102165:	89 e5                	mov    %esp,%ebp
80102167:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010216a:	68 66 7d 10 80       	push   $0x80107d66
8010216f:	68 80 b5 10 80       	push   $0x8010b580
80102174:	e8 47 24 00 00       	call   801045c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102179:	58                   	pop    %eax
8010217a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010217f:	5a                   	pop    %edx
80102180:	83 e8 01             	sub    $0x1,%eax
80102183:	50                   	push   %eax
80102184:	6a 0e                	push   $0xe
80102186:	e8 b5 02 00 00       	call   80102440 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010218b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010218e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102193:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102197:	90                   	nop
80102198:	ec                   	in     (%dx),%al
80102199:	83 e0 c0             	and    $0xffffffc0,%eax
8010219c:	3c 40                	cmp    $0x40,%al
8010219e:	75 f8                	jne    80102198 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021a5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021aa:	ee                   	out    %al,(%dx)
801021ab:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	eb 0e                	jmp    801021c5 <ideinit+0x65>
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021c0:	83 e9 01             	sub    $0x1,%ecx
801021c3:	74 0f                	je     801021d4 <ideinit+0x74>
801021c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021c6:	84 c0                	test   %al,%al
801021c8:	74 f6                	je     801021c0 <ideinit+0x60>
      havedisk1 = 1;
801021ca:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021de:	ee                   	out    %al,(%dx)
}
801021df:	c9                   	leave  
801021e0:	c3                   	ret    
801021e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021f0:	f3 0f 1e fb          	endbr32 
801021f4:	55                   	push   %ebp
801021f5:	89 e5                	mov    %esp,%ebp
801021f7:	57                   	push   %edi
801021f8:	56                   	push   %esi
801021f9:	53                   	push   %ebx
801021fa:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021fd:	68 80 b5 10 80       	push   $0x8010b580
80102202:	e8 39 25 00 00       	call   80104740 <acquire>

  if((b = idequeue) == 0){
80102207:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010220d:	83 c4 10             	add    $0x10,%esp
80102210:	85 db                	test   %ebx,%ebx
80102212:	74 5f                	je     80102273 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102214:	8b 43 58             	mov    0x58(%ebx),%eax
80102217:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010221c:	8b 33                	mov    (%ebx),%esi
8010221e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102224:	75 2b                	jne    80102251 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102226:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010222b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop
80102230:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102231:	89 c1                	mov    %eax,%ecx
80102233:	83 e1 c0             	and    $0xffffffc0,%ecx
80102236:	80 f9 40             	cmp    $0x40,%cl
80102239:	75 f5                	jne    80102230 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010223b:	a8 21                	test   $0x21,%al
8010223d:	75 12                	jne    80102251 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010223f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102242:	b9 80 00 00 00       	mov    $0x80,%ecx
80102247:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010224c:	fc                   	cld    
8010224d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010224f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102251:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102254:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102257:	83 ce 02             	or     $0x2,%esi
8010225a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010225c:	53                   	push   %ebx
8010225d:	e8 3e 20 00 00       	call   801042a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102262:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102267:	83 c4 10             	add    $0x10,%esp
8010226a:	85 c0                	test   %eax,%eax
8010226c:	74 05                	je     80102273 <ideintr+0x83>
    idestart(idequeue);
8010226e:	e8 0d fe ff ff       	call   80102080 <idestart>
    release(&idelock);
80102273:	83 ec 0c             	sub    $0xc,%esp
80102276:	68 80 b5 10 80       	push   $0x8010b580
8010227b:	e8 80 25 00 00       	call   80104800 <release>

  release(&idelock);
}
80102280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102283:	5b                   	pop    %ebx
80102284:	5e                   	pop    %esi
80102285:	5f                   	pop    %edi
80102286:	5d                   	pop    %ebp
80102287:	c3                   	ret    
80102288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010228f:	90                   	nop

80102290 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102290:	f3 0f 1e fb          	endbr32 
80102294:	55                   	push   %ebp
80102295:	89 e5                	mov    %esp,%ebp
80102297:	53                   	push   %ebx
80102298:	83 ec 10             	sub    $0x10,%esp
8010229b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010229e:	8d 43 0c             	lea    0xc(%ebx),%eax
801022a1:	50                   	push   %eax
801022a2:	e8 b9 22 00 00       	call   80104560 <holdingsleep>
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	0f 84 cf 00 00 00    	je     80102381 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022b2:	8b 03                	mov    (%ebx),%eax
801022b4:	83 e0 06             	and    $0x6,%eax
801022b7:	83 f8 02             	cmp    $0x2,%eax
801022ba:	0f 84 b4 00 00 00    	je     80102374 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022c0:	8b 53 04             	mov    0x4(%ebx),%edx
801022c3:	85 d2                	test   %edx,%edx
801022c5:	74 0d                	je     801022d4 <iderw+0x44>
801022c7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022cc:	85 c0                	test   %eax,%eax
801022ce:	0f 84 93 00 00 00    	je     80102367 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 80 b5 10 80       	push   $0x8010b580
801022dc:	e8 5f 24 00 00       	call   80104740 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022e1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022e6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	74 6c                	je     80102360 <iderw+0xd0>
801022f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022f8:	89 c2                	mov    %eax,%edx
801022fa:	8b 40 58             	mov    0x58(%eax),%eax
801022fd:	85 c0                	test   %eax,%eax
801022ff:	75 f7                	jne    801022f8 <iderw+0x68>
80102301:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102304:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102306:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010230c:	74 42                	je     80102350 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010230e:	8b 03                	mov    (%ebx),%eax
80102310:	83 e0 06             	and    $0x6,%eax
80102313:	83 f8 02             	cmp    $0x2,%eax
80102316:	74 23                	je     8010233b <iderw+0xab>
80102318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010231f:	90                   	nop
    sleep(b, &idelock);
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	68 80 b5 10 80       	push   $0x8010b580
80102328:	53                   	push   %ebx
80102329:	e8 b2 1d 00 00       	call   801040e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010232e:	8b 03                	mov    (%ebx),%eax
80102330:	83 c4 10             	add    $0x10,%esp
80102333:	83 e0 06             	and    $0x6,%eax
80102336:	83 f8 02             	cmp    $0x2,%eax
80102339:	75 e5                	jne    80102320 <iderw+0x90>
  }


  release(&idelock);
8010233b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102342:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102345:	c9                   	leave  
  release(&idelock);
80102346:	e9 b5 24 00 00       	jmp    80104800 <release>
8010234b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop
    idestart(b);
80102350:	89 d8                	mov    %ebx,%eax
80102352:	e8 29 fd ff ff       	call   80102080 <idestart>
80102357:	eb b5                	jmp    8010230e <iderw+0x7e>
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102360:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102365:	eb 9d                	jmp    80102304 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102367:	83 ec 0c             	sub    $0xc,%esp
8010236a:	68 95 7d 10 80       	push   $0x80107d95
8010236f:	e8 1c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102374:	83 ec 0c             	sub    $0xc,%esp
80102377:	68 80 7d 10 80       	push   $0x80107d80
8010237c:	e8 0f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102381:	83 ec 0c             	sub    $0xc,%esp
80102384:	68 6a 7d 10 80       	push   $0x80107d6a
80102389:	e8 02 e0 ff ff       	call   80100390 <panic>
8010238e:	66 90                	xchg   %ax,%ax

80102390 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102390:	f3 0f 1e fb          	endbr32 
80102394:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102395:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010239c:	00 c0 fe 
{
8010239f:	89 e5                	mov    %esp,%ebp
801023a1:	56                   	push   %esi
801023a2:	53                   	push   %ebx
  ioapic->reg = reg;
801023a3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023aa:	00 00 00 
  return ioapic->data;
801023ad:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023b3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023b6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023bc:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023c2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023c9:	c1 ee 10             	shr    $0x10,%esi
801023cc:	89 f0                	mov    %esi,%eax
801023ce:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023d1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023d4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023d7:	39 c2                	cmp    %eax,%edx
801023d9:	74 16                	je     801023f1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023db:	83 ec 0c             	sub    $0xc,%esp
801023de:	68 b4 7d 10 80       	push   $0x80107db4
801023e3:	e8 c8 e2 ff ff       	call   801006b0 <cprintf>
801023e8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023ee:	83 c4 10             	add    $0x10,%esp
801023f1:	83 c6 21             	add    $0x21,%esi
{
801023f4:	ba 10 00 00 00       	mov    $0x10,%edx
801023f9:	b8 20 00 00 00       	mov    $0x20,%eax
801023fe:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102400:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102402:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102404:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010240a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010240d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102413:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102416:	8d 5a 01             	lea    0x1(%edx),%ebx
80102419:	83 c2 02             	add    $0x2,%edx
8010241c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010241e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102424:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010242b:	39 f0                	cmp    %esi,%eax
8010242d:	75 d1                	jne    80102400 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010242f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102432:	5b                   	pop    %ebx
80102433:	5e                   	pop    %esi
80102434:	5d                   	pop    %ebp
80102435:	c3                   	ret    
80102436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010243d:	8d 76 00             	lea    0x0(%esi),%esi

80102440 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102440:	f3 0f 1e fb          	endbr32 
80102444:	55                   	push   %ebp
  ioapic->reg = reg;
80102445:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010244b:	89 e5                	mov    %esp,%ebp
8010244d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102450:	8d 50 20             	lea    0x20(%eax),%edx
80102453:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102457:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102459:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102462:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102465:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102468:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010246a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010246f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102472:	89 50 10             	mov    %edx,0x10(%eax)
}
80102475:	5d                   	pop    %ebp
80102476:	c3                   	ret    
80102477:	66 90                	xchg   %ax,%ax
80102479:	66 90                	xchg   %ax,%ax
8010247b:	66 90                	xchg   %ax,%ax
8010247d:	66 90                	xchg   %ax,%ax
8010247f:	90                   	nop

80102480 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	53                   	push   %ebx
80102488:	83 ec 04             	sub    $0x4,%esp
8010248b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010248e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102494:	75 7a                	jne    80102510 <kfree+0x90>
80102496:	81 fb a8 80 11 80    	cmp    $0x801180a8,%ebx
8010249c:	72 72                	jb     80102510 <kfree+0x90>
8010249e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024a4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024a9:	77 65                	ja     80102510 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024ab:	83 ec 04             	sub    $0x4,%esp
801024ae:	68 00 10 00 00       	push   $0x1000
801024b3:	6a 01                	push   $0x1
801024b5:	53                   	push   %ebx
801024b6:	e8 95 23 00 00       	call   80104850 <memset>

  if(kmem.use_lock)
801024bb:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024c1:	83 c4 10             	add    $0x10,%esp
801024c4:	85 d2                	test   %edx,%edx
801024c6:	75 20                	jne    801024e8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024c8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024cd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024cf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024d4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024da:	85 c0                	test   %eax,%eax
801024dc:	75 22                	jne    80102500 <kfree+0x80>
    release(&kmem.lock);
}
801024de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024e1:	c9                   	leave  
801024e2:	c3                   	ret    
801024e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024e7:	90                   	nop
    acquire(&kmem.lock);
801024e8:	83 ec 0c             	sub    $0xc,%esp
801024eb:	68 40 36 11 80       	push   $0x80113640
801024f0:	e8 4b 22 00 00       	call   80104740 <acquire>
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	eb ce                	jmp    801024c8 <kfree+0x48>
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102500:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102507:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010250a:	c9                   	leave  
    release(&kmem.lock);
8010250b:	e9 f0 22 00 00       	jmp    80104800 <release>
    panic("kfree");
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	68 e6 7d 10 80       	push   $0x80107de6
80102518:	e8 73 de ff ff       	call   80100390 <panic>
8010251d:	8d 76 00             	lea    0x0(%esi),%esi

80102520 <freerange>:
{
80102520:	f3 0f 1e fb          	endbr32 
80102524:	55                   	push   %ebp
80102525:	89 e5                	mov    %esp,%ebp
80102527:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102528:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010252b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010252e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010252f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102535:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102541:	39 de                	cmp    %ebx,%esi
80102543:	72 1f                	jb     80102564 <freerange+0x44>
80102545:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102548:	83 ec 0c             	sub    $0xc,%esp
8010254b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 23 ff ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 f3                	cmp    %esi,%ebx
80102562:	76 e4                	jbe    80102548 <freerange+0x28>
}
80102564:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102567:	5b                   	pop    %ebx
80102568:	5e                   	pop    %esi
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010256f:	90                   	nop

80102570 <kinit1>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
80102578:	53                   	push   %ebx
80102579:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010257c:	83 ec 08             	sub    $0x8,%esp
8010257f:	68 ec 7d 10 80       	push   $0x80107dec
80102584:	68 40 36 11 80       	push   $0x80113640
80102589:	e8 32 20 00 00       	call   801045c0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102594:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010259b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010259e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025a4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025aa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025b0:	39 de                	cmp    %ebx,%esi
801025b2:	72 20                	jb     801025d4 <kinit1+0x64>
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025b8:	83 ec 0c             	sub    $0xc,%esp
801025bb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025c7:	50                   	push   %eax
801025c8:	e8 b3 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025cd:	83 c4 10             	add    $0x10,%esp
801025d0:	39 de                	cmp    %ebx,%esi
801025d2:	73 e4                	jae    801025b8 <kinit1+0x48>
}
801025d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025d7:	5b                   	pop    %ebx
801025d8:	5e                   	pop    %esi
801025d9:	5d                   	pop    %ebp
801025da:	c3                   	ret    
801025db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025df:	90                   	nop

801025e0 <kinit2>:
{
801025e0:	f3 0f 1e fb          	endbr32 
801025e4:	55                   	push   %ebp
801025e5:	89 e5                	mov    %esp,%ebp
801025e7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025e8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025eb:	8b 75 0c             	mov    0xc(%ebp),%esi
801025ee:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025ef:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102601:	39 de                	cmp    %ebx,%esi
80102603:	72 1f                	jb     80102624 <kinit2+0x44>
80102605:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 63 fe ff ff       	call   80102480 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit2+0x28>
  kmem.use_lock = 1;
80102624:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010262b:	00 00 00 
}
8010262e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102631:	5b                   	pop    %ebx
80102632:	5e                   	pop    %esi
80102633:	5d                   	pop    %ebp
80102634:	c3                   	ret    
80102635:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102640 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102640:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102644:	a1 74 36 11 80       	mov    0x80113674,%eax
80102649:	85 c0                	test   %eax,%eax
8010264b:	75 1b                	jne    80102668 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010264d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102652:	85 c0                	test   %eax,%eax
80102654:	74 0a                	je     80102660 <kalloc+0x20>
    kmem.freelist = r->next;
80102656:	8b 10                	mov    (%eax),%edx
80102658:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010265e:	c3                   	ret    
8010265f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102660:	c3                   	ret    
80102661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102668:	55                   	push   %ebp
80102669:	89 e5                	mov    %esp,%ebp
8010266b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010266e:	68 40 36 11 80       	push   $0x80113640
80102673:	e8 c8 20 00 00       	call   80104740 <acquire>
  r = kmem.freelist;
80102678:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010267d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102683:	83 c4 10             	add    $0x10,%esp
80102686:	85 c0                	test   %eax,%eax
80102688:	74 08                	je     80102692 <kalloc+0x52>
    kmem.freelist = r->next;
8010268a:	8b 08                	mov    (%eax),%ecx
8010268c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102692:	85 d2                	test   %edx,%edx
80102694:	74 16                	je     801026ac <kalloc+0x6c>
    release(&kmem.lock);
80102696:	83 ec 0c             	sub    $0xc,%esp
80102699:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010269c:	68 40 36 11 80       	push   $0x80113640
801026a1:	e8 5a 21 00 00       	call   80104800 <release>
  return (char*)r;
801026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026a9:	83 c4 10             	add    $0x10,%esp
}
801026ac:	c9                   	leave  
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax

801026b0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026b0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026b4:	ba 64 00 00 00       	mov    $0x64,%edx
801026b9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026ba:	a8 01                	test   $0x1,%al
801026bc:	0f 84 be 00 00 00    	je     80102780 <kbdgetc+0xd0>
{
801026c2:	55                   	push   %ebp
801026c3:	ba 60 00 00 00       	mov    $0x60,%edx
801026c8:	89 e5                	mov    %esp,%ebp
801026ca:	53                   	push   %ebx
801026cb:	ec                   	in     (%dx),%al
  return data;
801026cc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026d2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026d5:	3c e0                	cmp    $0xe0,%al
801026d7:	74 57                	je     80102730 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026d9:	89 d9                	mov    %ebx,%ecx
801026db:	83 e1 40             	and    $0x40,%ecx
801026de:	84 c0                	test   %al,%al
801026e0:	78 5e                	js     80102740 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026e2:	85 c9                	test   %ecx,%ecx
801026e4:	74 09                	je     801026ef <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026e6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026e9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026ec:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026ef:	0f b6 8a 20 7f 10 80 	movzbl -0x7fef80e0(%edx),%ecx
  shift ^= togglecode[data];
801026f6:	0f b6 82 20 7e 10 80 	movzbl -0x7fef81e0(%edx),%eax
  shift |= shiftcode[data];
801026fd:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ff:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102701:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102703:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102709:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010270c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010270f:	8b 04 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%eax
80102716:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010271a:	74 0b                	je     80102727 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010271c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010271f:	83 fa 19             	cmp    $0x19,%edx
80102722:	77 44                	ja     80102768 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102724:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102727:	5b                   	pop    %ebx
80102728:	5d                   	pop    %ebp
80102729:	c3                   	ret    
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102730:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102733:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102735:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010273b:	5b                   	pop    %ebx
8010273c:	5d                   	pop    %ebp
8010273d:	c3                   	ret    
8010273e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102740:	83 e0 7f             	and    $0x7f,%eax
80102743:	85 c9                	test   %ecx,%ecx
80102745:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102748:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010274a:	0f b6 8a 20 7f 10 80 	movzbl -0x7fef80e0(%edx),%ecx
80102751:	83 c9 40             	or     $0x40,%ecx
80102754:	0f b6 c9             	movzbl %cl,%ecx
80102757:	f7 d1                	not    %ecx
80102759:	21 d9                	and    %ebx,%ecx
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010275d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102763:	c3                   	ret    
80102764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102768:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010276b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010276e:	5b                   	pop    %ebx
8010276f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102770:	83 f9 1a             	cmp    $0x1a,%ecx
80102773:	0f 42 c2             	cmovb  %edx,%eax
}
80102776:	c3                   	ret    
80102777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277e:	66 90                	xchg   %ax,%ax
    return -1;
80102780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102785:	c3                   	ret    
80102786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <kbdintr>:

void
kbdintr(void)
{
80102790:	f3 0f 1e fb          	endbr32 
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010279a:	68 b0 26 10 80       	push   $0x801026b0
8010279f:	e8 bc e0 ff ff       	call   80100860 <consoleintr>
}
801027a4:	83 c4 10             	add    $0x10,%esp
801027a7:	c9                   	leave  
801027a8:	c3                   	ret    
801027a9:	66 90                	xchg   %ax,%ax
801027ab:	66 90                	xchg   %ax,%ax
801027ad:	66 90                	xchg   %ax,%ax
801027af:	90                   	nop

801027b0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027b0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027b9:	85 c0                	test   %eax,%eax
801027bb:	0f 84 c7 00 00 00    	je     80102888 <lapicinit+0xd8>
  lapic[index] = value;
801027c1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027c8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027cb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ce:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027d5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027d8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027db:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027e2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027e5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027ef:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027f2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027fc:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ff:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102802:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102809:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010280f:	8b 50 30             	mov    0x30(%eax),%edx
80102812:	c1 ea 10             	shr    $0x10,%edx
80102815:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010281b:	75 73                	jne    80102890 <lapicinit+0xe0>
  lapic[index] = value;
8010281d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102824:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102831:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102834:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102837:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010283e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102841:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102844:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010284b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102851:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102858:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010285e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102865:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102868:	8b 50 20             	mov    0x20(%eax),%edx
8010286b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102870:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102876:	80 e6 10             	and    $0x10,%dh
80102879:	75 f5                	jne    80102870 <lapicinit+0xc0>
  lapic[index] = value;
8010287b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102882:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102888:	c3                   	ret    
80102889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102890:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102897:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010289d:	e9 7b ff ff ff       	jmp    8010281d <lapicinit+0x6d>
801028a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028b0 <lapicid>:

int
lapicid(void)
{
801028b0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028b4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028b9:	85 c0                	test   %eax,%eax
801028bb:	74 0b                	je     801028c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028bd:	8b 40 20             	mov    0x20(%eax),%eax
801028c0:	c1 e8 18             	shr    $0x18,%eax
801028c3:	c3                   	ret    
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028c8:	31 c0                	xor    %eax,%eax
}
801028ca:	c3                   	ret    
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop

801028d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028d0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028d4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028d9:	85 c0                	test   %eax,%eax
801028db:	74 0d                	je     801028ea <lapiceoi+0x1a>
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028ea:	c3                   	ret    
801028eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028ef:	90                   	nop

801028f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028f0:	f3 0f 1e fb          	endbr32 
}
801028f4:	c3                   	ret    
801028f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102900:	f3 0f 1e fb          	endbr32 
80102904:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102905:	b8 0f 00 00 00       	mov    $0xf,%eax
8010290a:	ba 70 00 00 00       	mov    $0x70,%edx
8010290f:	89 e5                	mov    %esp,%ebp
80102911:	53                   	push   %ebx
80102912:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102915:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102918:	ee                   	out    %al,(%dx)
80102919:	b8 0a 00 00 00       	mov    $0xa,%eax
8010291e:	ba 71 00 00 00       	mov    $0x71,%edx
80102923:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102924:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102926:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102929:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010292f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102931:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102934:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102936:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102939:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010293c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102942:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102947:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010294d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102950:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102957:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010295a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102964:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102967:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102970:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102973:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102985:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010298b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010298c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010298f:	5d                   	pop    %ebp
80102990:	c3                   	ret    
80102991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010299f:	90                   	nop

801029a0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029a0:	f3 0f 1e fb          	endbr32 
801029a4:	55                   	push   %ebp
801029a5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029aa:	ba 70 00 00 00       	mov    $0x70,%edx
801029af:	89 e5                	mov    %esp,%ebp
801029b1:	57                   	push   %edi
801029b2:	56                   	push   %esi
801029b3:	53                   	push   %ebx
801029b4:	83 ec 4c             	sub    $0x4c,%esp
801029b7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029b8:	ba 71 00 00 00       	mov    $0x71,%edx
801029bd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029be:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029c6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d0:	31 c0                	xor    %eax,%eax
801029d2:	89 da                	mov    %ebx,%edx
801029d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029da:	89 ca                	mov    %ecx,%edx
801029dc:	ec                   	in     (%dx),%al
801029dd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e0:	89 da                	mov    %ebx,%edx
801029e2:	b8 02 00 00 00       	mov    $0x2,%eax
801029e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e8:	89 ca                	mov    %ecx,%edx
801029ea:	ec                   	in     (%dx),%al
801029eb:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ee:	89 da                	mov    %ebx,%edx
801029f0:	b8 04 00 00 00       	mov    $0x4,%eax
801029f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f6:	89 ca                	mov    %ecx,%edx
801029f8:	ec                   	in     (%dx),%al
801029f9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fc:	89 da                	mov    %ebx,%edx
801029fe:	b8 07 00 00 00       	mov    $0x7,%eax
80102a03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a04:	89 ca                	mov    %ecx,%edx
80102a06:	ec                   	in     (%dx),%al
80102a07:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a0a:	89 da                	mov    %ebx,%edx
80102a0c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a11:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a12:	89 ca                	mov    %ecx,%edx
80102a14:	ec                   	in     (%dx),%al
80102a15:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a17:	89 da                	mov    %ebx,%edx
80102a19:	b8 09 00 00 00       	mov    $0x9,%eax
80102a1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
80102a22:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a24:	89 da                	mov    %ebx,%edx
80102a26:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2c:	89 ca                	mov    %ecx,%edx
80102a2e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a2f:	84 c0                	test   %al,%al
80102a31:	78 9d                	js     801029d0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a33:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a37:	89 fa                	mov    %edi,%edx
80102a39:	0f b6 fa             	movzbl %dl,%edi
80102a3c:	89 f2                	mov    %esi,%edx
80102a3e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a41:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a45:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a48:	89 da                	mov    %ebx,%edx
80102a4a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a4d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a50:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a54:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a57:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a5a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a5e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a61:	31 c0                	xor    %eax,%eax
80102a63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a64:	89 ca                	mov    %ecx,%edx
80102a66:	ec                   	in     (%dx),%al
80102a67:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6a:	89 da                	mov    %ebx,%edx
80102a6c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a6f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a74:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a75:	89 ca                	mov    %ecx,%edx
80102a77:	ec                   	in     (%dx),%al
80102a78:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7b:	89 da                	mov    %ebx,%edx
80102a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a80:	b8 04 00 00 00       	mov    $0x4,%eax
80102a85:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a86:	89 ca                	mov    %ecx,%edx
80102a88:	ec                   	in     (%dx),%al
80102a89:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8c:	89 da                	mov    %ebx,%edx
80102a8e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a91:	b8 07 00 00 00       	mov    $0x7,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 da                	mov    %ebx,%edx
80102a9f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aa2:	b8 08 00 00 00       	mov    $0x8,%eax
80102aa7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa8:	89 ca                	mov    %ecx,%edx
80102aaa:	ec                   	in     (%dx),%al
80102aab:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aae:	89 da                	mov    %ebx,%edx
80102ab0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102ab3:	b8 09 00 00 00       	mov    $0x9,%eax
80102ab8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab9:	89 ca                	mov    %ecx,%edx
80102abb:	ec                   	in     (%dx),%al
80102abc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102abf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ac2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ac5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ac8:	6a 18                	push   $0x18
80102aca:	50                   	push   %eax
80102acb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ace:	50                   	push   %eax
80102acf:	e8 cc 1d 00 00       	call   801048a0 <memcmp>
80102ad4:	83 c4 10             	add    $0x10,%esp
80102ad7:	85 c0                	test   %eax,%eax
80102ad9:	0f 85 f1 fe ff ff    	jne    801029d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102adf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ae3:	75 78                	jne    80102b5d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 c2                	mov    %eax,%edx
80102aea:	83 e0 0f             	and    $0xf,%eax
80102aed:	c1 ea 04             	shr    $0x4,%edx
80102af0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102af6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102af9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102afc:	89 c2                	mov    %eax,%edx
80102afe:	83 e0 0f             	and    $0xf,%eax
80102b01:	c1 ea 04             	shr    $0x4,%edx
80102b04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b0d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b10:	89 c2                	mov    %eax,%edx
80102b12:	83 e0 0f             	and    $0xf,%eax
80102b15:	c1 ea 04             	shr    $0x4,%edx
80102b18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b1e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b21:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b24:	89 c2                	mov    %eax,%edx
80102b26:	83 e0 0f             	and    $0xf,%eax
80102b29:	c1 ea 04             	shr    $0x4,%edx
80102b2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b32:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b35:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b49:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b5d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 06                	mov    %eax,(%esi)
80102b65:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b68:	89 46 04             	mov    %eax,0x4(%esi)
80102b6b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b6e:	89 46 08             	mov    %eax,0x8(%esi)
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 46 0c             	mov    %eax,0xc(%esi)
80102b77:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b7a:	89 46 10             	mov    %eax,0x10(%esi)
80102b7d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b80:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b83:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b8d:	5b                   	pop    %ebx
80102b8e:	5e                   	pop    %esi
80102b8f:	5f                   	pop    %edi
80102b90:	5d                   	pop    %ebp
80102b91:	c3                   	ret    
80102b92:	66 90                	xchg   %ax,%ax
80102b94:	66 90                	xchg   %ax,%ax
80102b96:	66 90                	xchg   %ax,%ax
80102b98:	66 90                	xchg   %ax,%ax
80102b9a:	66 90                	xchg   %ax,%ax
80102b9c:	66 90                	xchg   %ax,%ax
80102b9e:	66 90                	xchg   %ax,%ax

80102ba0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102ba6:	85 c9                	test   %ecx,%ecx
80102ba8:	0f 8e 8a 00 00 00    	jle    80102c38 <install_trans+0x98>
{
80102bae:	55                   	push   %ebp
80102baf:	89 e5                	mov    %esp,%ebp
80102bb1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bb2:	31 ff                	xor    %edi,%edi
{
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bc0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bc5:	83 ec 08             	sub    $0x8,%esp
80102bc8:	01 f8                	add    %edi,%eax
80102bca:	83 c0 01             	add    $0x1,%eax
80102bcd:	50                   	push   %eax
80102bce:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bd4:	e8 f7 d4 ff ff       	call   801000d0 <bread>
80102bd9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdb:	58                   	pop    %eax
80102bdc:	5a                   	pop    %edx
80102bdd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102be4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bea:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bed:	e8 de d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bf5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102bf7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bfa:	68 00 02 00 00       	push   $0x200
80102bff:	50                   	push   %eax
80102c00:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c03:	50                   	push   %eax
80102c04:	e8 e7 1c 00 00       	call   801048f0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 9f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c11:	89 34 24             	mov    %esi,(%esp)
80102c14:	e8 d7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c19:	89 1c 24             	mov    %ebx,(%esp)
80102c1c:	e8 cf d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c21:	83 c4 10             	add    $0x10,%esp
80102c24:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c2a:	7f 94                	jg     80102bc0 <install_trans+0x20>
  }
}
80102c2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c2f:	5b                   	pop    %ebx
80102c30:	5e                   	pop    %esi
80102c31:	5f                   	pop    %edi
80102c32:	5d                   	pop    %ebp
80102c33:	c3                   	ret    
80102c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c38:	c3                   	ret    
80102c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c40:	55                   	push   %ebp
80102c41:	89 e5                	mov    %esp,%ebp
80102c43:	53                   	push   %ebx
80102c44:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c47:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c4d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c53:	e8 78 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c58:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c5b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c5d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c62:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c65:	85 c0                	test   %eax,%eax
80102c67:	7e 19                	jle    80102c82 <write_head+0x42>
80102c69:	31 d2                	xor    %edx,%edx
80102c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c6f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c70:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c77:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c7b:	83 c2 01             	add    $0x1,%edx
80102c7e:	39 d0                	cmp    %edx,%eax
80102c80:	75 ee                	jne    80102c70 <write_head+0x30>
  }
  bwrite(buf);
80102c82:	83 ec 0c             	sub    $0xc,%esp
80102c85:	53                   	push   %ebx
80102c86:	e8 25 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c8b:	89 1c 24             	mov    %ebx,(%esp)
80102c8e:	e8 5d d5 ff ff       	call   801001f0 <brelse>
}
80102c93:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c96:	83 c4 10             	add    $0x10,%esp
80102c99:	c9                   	leave  
80102c9a:	c3                   	ret    
80102c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c9f:	90                   	nop

80102ca0 <initlog>:
{
80102ca0:	f3 0f 1e fb          	endbr32 
80102ca4:	55                   	push   %ebp
80102ca5:	89 e5                	mov    %esp,%ebp
80102ca7:	53                   	push   %ebx
80102ca8:	83 ec 2c             	sub    $0x2c,%esp
80102cab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cae:	68 20 80 10 80       	push   $0x80108020
80102cb3:	68 80 36 11 80       	push   $0x80113680
80102cb8:	e8 03 19 00 00       	call   801045c0 <initlock>
  readsb(dev, &sb);
80102cbd:	58                   	pop    %eax
80102cbe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cc1:	5a                   	pop    %edx
80102cc2:	50                   	push   %eax
80102cc3:	53                   	push   %ebx
80102cc4:	e8 47 e8 ff ff       	call   80101510 <readsb>
  log.start = sb.logstart;
80102cc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ccc:	59                   	pop    %ecx
  log.dev = dev;
80102ccd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102cdb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102ce1:	5a                   	pop    %edx
80102ce2:	50                   	push   %eax
80102ce3:	53                   	push   %ebx
80102ce4:	e8 e7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cec:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cef:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102cf5:	85 c9                	test   %ecx,%ecx
80102cf7:	7e 19                	jle    80102d12 <initlog+0x72>
80102cf9:	31 d2                	xor    %edx,%edx
80102cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cff:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d00:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d04:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d0b:	83 c2 01             	add    $0x1,%edx
80102d0e:	39 d1                	cmp    %edx,%ecx
80102d10:	75 ee                	jne    80102d00 <initlog+0x60>
  brelse(buf);
80102d12:	83 ec 0c             	sub    $0xc,%esp
80102d15:	50                   	push   %eax
80102d16:	e8 d5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d1b:	e8 80 fe ff ff       	call   80102ba0 <install_trans>
  log.lh.n = 0;
80102d20:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d27:	00 00 00 
  write_head(); // clear the log
80102d2a:	e8 11 ff ff ff       	call   80102c40 <write_head>
}
80102d2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d32:	83 c4 10             	add    $0x10,%esp
80102d35:	c9                   	leave  
80102d36:	c3                   	ret    
80102d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d3e:	66 90                	xchg   %ax,%ax

80102d40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d40:	f3 0f 1e fb          	endbr32 
80102d44:	55                   	push   %ebp
80102d45:	89 e5                	mov    %esp,%ebp
80102d47:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d4a:	68 80 36 11 80       	push   $0x80113680
80102d4f:	e8 ec 19 00 00       	call   80104740 <acquire>
80102d54:	83 c4 10             	add    $0x10,%esp
80102d57:	eb 1c                	jmp    80102d75 <begin_op+0x35>
80102d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d60:	83 ec 08             	sub    $0x8,%esp
80102d63:	68 80 36 11 80       	push   $0x80113680
80102d68:	68 80 36 11 80       	push   $0x80113680
80102d6d:	e8 6e 13 00 00       	call   801040e0 <sleep>
80102d72:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d75:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d7a:	85 c0                	test   %eax,%eax
80102d7c:	75 e2                	jne    80102d60 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d7e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d83:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d89:	83 c0 01             	add    $0x1,%eax
80102d8c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d8f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d92:	83 fa 1e             	cmp    $0x1e,%edx
80102d95:	7f c9                	jg     80102d60 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d97:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d9a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102d9f:	68 80 36 11 80       	push   $0x80113680
80102da4:	e8 57 1a 00 00       	call   80104800 <release>
      break;
    }
  }
}
80102da9:	83 c4 10             	add    $0x10,%esp
80102dac:	c9                   	leave  
80102dad:	c3                   	ret    
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102db0:	f3 0f 1e fb          	endbr32 
80102db4:	55                   	push   %ebp
80102db5:	89 e5                	mov    %esp,%ebp
80102db7:	57                   	push   %edi
80102db8:	56                   	push   %esi
80102db9:	53                   	push   %ebx
80102dba:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dbd:	68 80 36 11 80       	push   $0x80113680
80102dc2:	e8 79 19 00 00       	call   80104740 <acquire>
  log.outstanding -= 1;
80102dc7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dcc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102dd2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dd5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dd8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dde:	85 f6                	test   %esi,%esi
80102de0:	0f 85 1e 01 00 00    	jne    80102f04 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102de6:	85 db                	test   %ebx,%ebx
80102de8:	0f 85 f2 00 00 00    	jne    80102ee0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dee:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102df5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102df8:	83 ec 0c             	sub    $0xc,%esp
80102dfb:	68 80 36 11 80       	push   $0x80113680
80102e00:	e8 fb 19 00 00       	call   80104800 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e05:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e0b:	83 c4 10             	add    $0x10,%esp
80102e0e:	85 c9                	test   %ecx,%ecx
80102e10:	7f 3e                	jg     80102e50 <end_op+0xa0>
    acquire(&log.lock);
80102e12:	83 ec 0c             	sub    $0xc,%esp
80102e15:	68 80 36 11 80       	push   $0x80113680
80102e1a:	e8 21 19 00 00       	call   80104740 <acquire>
    wakeup(&log);
80102e1f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e26:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e2d:	00 00 00 
    wakeup(&log);
80102e30:	e8 6b 14 00 00       	call   801042a0 <wakeup>
    release(&log.lock);
80102e35:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e3c:	e8 bf 19 00 00       	call   80104800 <release>
80102e41:	83 c4 10             	add    $0x10,%esp
}
80102e44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e47:	5b                   	pop    %ebx
80102e48:	5e                   	pop    %esi
80102e49:	5f                   	pop    %edi
80102e4a:	5d                   	pop    %ebp
80102e4b:	c3                   	ret    
80102e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e50:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	01 d8                	add    %ebx,%eax
80102e5a:	83 c0 01             	add    $0x1,%eax
80102e5d:	50                   	push   %eax
80102e5e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e64:	e8 67 d2 ff ff       	call   801000d0 <bread>
80102e69:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6b:	58                   	pop    %eax
80102e6c:	5a                   	pop    %edx
80102e6d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e74:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e7a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e7d:	e8 4e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e82:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e85:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e87:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e8a:	68 00 02 00 00       	push   $0x200
80102e8f:	50                   	push   %eax
80102e90:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e93:	50                   	push   %eax
80102e94:	e8 57 1a 00 00       	call   801048f0 <memmove>
    bwrite(to);  // write the log
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 0f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ea1:	89 3c 24             	mov    %edi,(%esp)
80102ea4:	e8 47 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ea9:	89 34 24             	mov    %esi,(%esp)
80102eac:	e8 3f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102eb1:	83 c4 10             	add    $0x10,%esp
80102eb4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eba:	7c 94                	jl     80102e50 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102ebc:	e8 7f fd ff ff       	call   80102c40 <write_head>
    install_trans(); // Now install writes to home locations
80102ec1:	e8 da fc ff ff       	call   80102ba0 <install_trans>
    log.lh.n = 0;
80102ec6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ecd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ed0:	e8 6b fd ff ff       	call   80102c40 <write_head>
80102ed5:	e9 38 ff ff ff       	jmp    80102e12 <end_op+0x62>
80102eda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ee0:	83 ec 0c             	sub    $0xc,%esp
80102ee3:	68 80 36 11 80       	push   $0x80113680
80102ee8:	e8 b3 13 00 00       	call   801042a0 <wakeup>
  release(&log.lock);
80102eed:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ef4:	e8 07 19 00 00       	call   80104800 <release>
80102ef9:	83 c4 10             	add    $0x10,%esp
}
80102efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eff:	5b                   	pop    %ebx
80102f00:	5e                   	pop    %esi
80102f01:	5f                   	pop    %edi
80102f02:	5d                   	pop    %ebp
80102f03:	c3                   	ret    
    panic("log.committing");
80102f04:	83 ec 0c             	sub    $0xc,%esp
80102f07:	68 24 80 10 80       	push   $0x80108024
80102f0c:	e8 7f d4 ff ff       	call   80100390 <panic>
80102f11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	f3 0f 1e fb          	endbr32 
80102f24:	55                   	push   %ebp
80102f25:	89 e5                	mov    %esp,%ebp
80102f27:	53                   	push   %ebx
80102f28:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f2b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f34:	83 fa 1d             	cmp    $0x1d,%edx
80102f37:	0f 8f 91 00 00 00    	jg     80102fce <log_write+0xae>
80102f3d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f42:	83 e8 01             	sub    $0x1,%eax
80102f45:	39 c2                	cmp    %eax,%edx
80102f47:	0f 8d 81 00 00 00    	jge    80102fce <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f4d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f52:	85 c0                	test   %eax,%eax
80102f54:	0f 8e 81 00 00 00    	jle    80102fdb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f5a:	83 ec 0c             	sub    $0xc,%esp
80102f5d:	68 80 36 11 80       	push   $0x80113680
80102f62:	e8 d9 17 00 00       	call   80104740 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f67:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	85 d2                	test   %edx,%edx
80102f72:	7e 4e                	jle    80102fc2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f74:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f77:	31 c0                	xor    %eax,%eax
80102f79:	eb 0c                	jmp    80102f87 <log_write+0x67>
80102f7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
80102f80:	83 c0 01             	add    $0x1,%eax
80102f83:	39 c2                	cmp    %eax,%edx
80102f85:	74 29                	je     80102fb0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f87:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f97:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f9d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102fa4:	c9                   	leave  
  release(&log.lock);
80102fa5:	e9 56 18 00 00       	jmp    80104800 <release>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fb7:	83 c2 01             	add    $0x1,%edx
80102fba:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fc0:	eb d5                	jmp    80102f97 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fc2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fc5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fca:	75 cb                	jne    80102f97 <log_write+0x77>
80102fcc:	eb e9                	jmp    80102fb7 <log_write+0x97>
    panic("too big a transaction");
80102fce:	83 ec 0c             	sub    $0xc,%esp
80102fd1:	68 33 80 10 80       	push   $0x80108033
80102fd6:	e8 b5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fdb:	83 ec 0c             	sub    $0xc,%esp
80102fde:	68 49 80 10 80       	push   $0x80108049
80102fe3:	e8 a8 d3 ff ff       	call   80100390 <panic>
80102fe8:	66 90                	xchg   %ax,%ax
80102fea:	66 90                	xchg   %ax,%ax
80102fec:	66 90                	xchg   %ax,%ax
80102fee:	66 90                	xchg   %ax,%ax

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 b4 0a 00 00       	call   80103ab0 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 ad 0a 00 00       	call   80103ab0 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 64 80 10 80       	push   $0x80108064
8010300d:	e8 9e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103012:	e8 a9 33 00 00       	call   801063c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 24 0a 00 00       	call   80103a40 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 71 0d 00 00       	call   80103da0 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	f3 0f 1e fb          	endbr32 
80103034:	55                   	push   %ebp
80103035:	89 e5                	mov    %esp,%ebp
80103037:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010303a:	e8 51 44 00 00       	call   80107490 <switchkvm>
  seginit();
8010303f:	e8 bc 43 00 00       	call   80107400 <seginit>
  lapicinit();
80103044:	e8 67 f7 ff ff       	call   801027b0 <lapicinit>
  mpmain();
80103049:	e8 a2 ff ff ff       	call   80102ff0 <mpmain>
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	f3 0f 1e fb          	endbr32 
80103054:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103058:	83 e4 f0             	and    $0xfffffff0,%esp
8010305b:	ff 71 fc             	pushl  -0x4(%ecx)
8010305e:	55                   	push   %ebp
8010305f:	89 e5                	mov    %esp,%ebp
80103061:	53                   	push   %ebx
80103062:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103063:	83 ec 08             	sub    $0x8,%esp
80103066:	68 00 00 40 80       	push   $0x80400000
8010306b:	68 a8 80 11 80       	push   $0x801180a8
80103070:	e8 fb f4 ff ff       	call   80102570 <kinit1>
  kvmalloc();      // kernel page table
80103075:	e8 f6 48 00 00       	call   80107970 <kvmalloc>
  mpinit();        // detect other processors
8010307a:	e8 81 01 00 00       	call   80103200 <mpinit>
  lapicinit();     // interrupt controller
8010307f:	e8 2c f7 ff ff       	call   801027b0 <lapicinit>
  seginit();       // segment descriptors
80103084:	e8 77 43 00 00       	call   80107400 <seginit>
  picinit();       // disable pic
80103089:	e8 52 03 00 00       	call   801033e0 <picinit>
  ioapicinit();    // another interrupt controller
8010308e:	e8 fd f2 ff ff       	call   80102390 <ioapicinit>
  consoleinit();   // console hardware
80103093:	e8 98 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103098:	e8 23 36 00 00       	call   801066c0 <uartinit>
  pinit();         // process table
8010309d:	e8 7e 09 00 00       	call   80103a20 <pinit>
  tvinit();        // trap vectors
801030a2:	e8 99 32 00 00       	call   80106340 <tvinit>
  binit();         // buffer cache
801030a7:	e8 94 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ac:	e8 3f dd ff ff       	call   80100df0 <fileinit>
  ideinit();       // disk 
801030b1:	e8 aa f0 ff ff       	call   80102160 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b6:	83 c4 0c             	add    $0xc,%esp
801030b9:	68 8a 00 00 00       	push   $0x8a
801030be:	68 8c b4 10 80       	push   $0x8010b48c
801030c3:	68 00 70 00 80       	push   $0x80007000
801030c8:	e8 23 18 00 00       	call   801048f0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030d7:	00 00 00 
801030da:	05 80 37 11 80       	add    $0x80113780,%eax
801030df:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801030e4:	76 7a                	jbe    80103160 <main+0x110>
801030e6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801030eb:	eb 1c                	jmp    80103109 <main+0xb9>
801030ed:	8d 76 00             	lea    0x0(%esi),%esi
801030f0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030f7:	00 00 00 
801030fa:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103100:	05 80 37 11 80       	add    $0x80113780,%eax
80103105:	39 c3                	cmp    %eax,%ebx
80103107:	73 57                	jae    80103160 <main+0x110>
    if(c == mycpu())  // We've started already.
80103109:	e8 32 09 00 00       	call   80103a40 <mycpu>
8010310e:	39 c3                	cmp    %eax,%ebx
80103110:	74 de                	je     801030f0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103112:	e8 29 f5 ff ff       	call   80102640 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103117:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010311a:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
80103121:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103124:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010312b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010312e:	05 00 10 00 00       	add    $0x1000,%eax
80103133:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103138:	0f b6 03             	movzbl (%ebx),%eax
8010313b:	68 00 70 00 00       	push   $0x7000
80103140:	50                   	push   %eax
80103141:	e8 ba f7 ff ff       	call   80102900 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103146:	83 c4 10             	add    $0x10,%esp
80103149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103150:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103156:	85 c0                	test   %eax,%eax
80103158:	74 f6                	je     80103150 <main+0x100>
8010315a:	eb 94                	jmp    801030f0 <main+0xa0>
8010315c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103160:	83 ec 08             	sub    $0x8,%esp
80103163:	68 00 00 00 8e       	push   $0x8e000000
80103168:	68 00 00 40 80       	push   $0x80400000
8010316d:	e8 6e f4 ff ff       	call   801025e0 <kinit2>
  userinit();      // first user process
80103172:	e8 89 09 00 00       	call   80103b00 <userinit>
  mpmain();        // finish this processor's setup
80103177:	e8 74 fe ff ff       	call   80102ff0 <mpmain>
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103185:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010318b:	53                   	push   %ebx
  e = addr+len;
8010318c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010318f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103192:	39 de                	cmp    %ebx,%esi
80103194:	72 10                	jb     801031a6 <mpsearch1+0x26>
80103196:	eb 50                	jmp    801031e8 <mpsearch1+0x68>
80103198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010319f:	90                   	nop
801031a0:	89 fe                	mov    %edi,%esi
801031a2:	39 fb                	cmp    %edi,%ebx
801031a4:	76 42                	jbe    801031e8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031a6:	83 ec 04             	sub    $0x4,%esp
801031a9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ac:	6a 04                	push   $0x4
801031ae:	68 78 80 10 80       	push   $0x80108078
801031b3:	56                   	push   %esi
801031b4:	e8 e7 16 00 00       	call   801048a0 <memcmp>
801031b9:	83 c4 10             	add    $0x10,%esp
801031bc:	85 c0                	test   %eax,%eax
801031be:	75 e0                	jne    801031a0 <mpsearch1+0x20>
801031c0:	89 f2                	mov    %esi,%edx
801031c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031c8:	0f b6 0a             	movzbl (%edx),%ecx
801031cb:	83 c2 01             	add    $0x1,%edx
801031ce:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031d0:	39 fa                	cmp    %edi,%edx
801031d2:	75 f4                	jne    801031c8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031d4:	84 c0                	test   %al,%al
801031d6:	75 c8                	jne    801031a0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031db:	89 f0                	mov    %esi,%eax
801031dd:	5b                   	pop    %ebx
801031de:	5e                   	pop    %esi
801031df:	5f                   	pop    %edi
801031e0:	5d                   	pop    %ebp
801031e1:	c3                   	ret    
801031e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031eb:	31 f6                	xor    %esi,%esi
}
801031ed:	5b                   	pop    %ebx
801031ee:	89 f0                	mov    %esi,%eax
801031f0:	5e                   	pop    %esi
801031f1:	5f                   	pop    %edi
801031f2:	5d                   	pop    %ebp
801031f3:	c3                   	ret    
801031f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop

80103200 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103200:	f3 0f 1e fb          	endbr32 
80103204:	55                   	push   %ebp
80103205:	89 e5                	mov    %esp,%ebp
80103207:	57                   	push   %edi
80103208:	56                   	push   %esi
80103209:	53                   	push   %ebx
8010320a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010320d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103214:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010321b:	c1 e0 08             	shl    $0x8,%eax
8010321e:	09 d0                	or     %edx,%eax
80103220:	c1 e0 04             	shl    $0x4,%eax
80103223:	75 1b                	jne    80103240 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103225:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010322c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103233:	c1 e0 08             	shl    $0x8,%eax
80103236:	09 d0                	or     %edx,%eax
80103238:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010323b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103240:	ba 00 04 00 00       	mov    $0x400,%edx
80103245:	e8 36 ff ff ff       	call   80103180 <mpsearch1>
8010324a:	89 c6                	mov    %eax,%esi
8010324c:	85 c0                	test   %eax,%eax
8010324e:	0f 84 4c 01 00 00    	je     801033a0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103254:	8b 5e 04             	mov    0x4(%esi),%ebx
80103257:	85 db                	test   %ebx,%ebx
80103259:	0f 84 61 01 00 00    	je     801033c0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010325f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103262:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103268:	6a 04                	push   $0x4
8010326a:	68 7d 80 10 80       	push   $0x8010807d
8010326f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103270:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103273:	e8 28 16 00 00       	call   801048a0 <memcmp>
80103278:	83 c4 10             	add    $0x10,%esp
8010327b:	85 c0                	test   %eax,%eax
8010327d:	0f 85 3d 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103283:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010328a:	3c 01                	cmp    $0x1,%al
8010328c:	74 08                	je     80103296 <mpinit+0x96>
8010328e:	3c 04                	cmp    $0x4,%al
80103290:	0f 85 2a 01 00 00    	jne    801033c0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103296:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010329d:	66 85 d2             	test   %dx,%dx
801032a0:	74 26                	je     801032c8 <mpinit+0xc8>
801032a2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032a5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032a7:	31 d2                	xor    %edx,%edx
801032a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032b0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032b7:	83 c0 01             	add    $0x1,%eax
801032ba:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032bc:	39 f8                	cmp    %edi,%eax
801032be:	75 f0                	jne    801032b0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032c0:	84 d2                	test   %dl,%dl
801032c2:	0f 85 f8 00 00 00    	jne    801033c0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032ce:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032d9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032e0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032e5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032e8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ef:	90                   	nop
801032f0:	39 c2                	cmp    %eax,%edx
801032f2:	76 15                	jbe    80103309 <mpinit+0x109>
    switch(*p){
801032f4:	0f b6 08             	movzbl (%eax),%ecx
801032f7:	80 f9 02             	cmp    $0x2,%cl
801032fa:	74 5c                	je     80103358 <mpinit+0x158>
801032fc:	77 42                	ja     80103340 <mpinit+0x140>
801032fe:	84 c9                	test   %cl,%cl
80103300:	74 6e                	je     80103370 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103302:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103305:	39 c2                	cmp    %eax,%edx
80103307:	77 eb                	ja     801032f4 <mpinit+0xf4>
80103309:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010330c:	85 db                	test   %ebx,%ebx
8010330e:	0f 84 b9 00 00 00    	je     801033cd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103314:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103318:	74 15                	je     8010332f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331a:	b8 70 00 00 00       	mov    $0x70,%eax
8010331f:	ba 22 00 00 00       	mov    $0x22,%edx
80103324:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103325:	ba 23 00 00 00       	mov    $0x23,%edx
8010332a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010332b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332e:	ee                   	out    %al,(%dx)
  }
}
8010332f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103332:	5b                   	pop    %ebx
80103333:	5e                   	pop    %esi
80103334:	5f                   	pop    %edi
80103335:	5d                   	pop    %ebp
80103336:	c3                   	ret    
80103337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010333e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103340:	83 e9 03             	sub    $0x3,%ecx
80103343:	80 f9 01             	cmp    $0x1,%cl
80103346:	76 ba                	jbe    80103302 <mpinit+0x102>
80103348:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010334f:	eb 9f                	jmp    801032f0 <mpinit+0xf0>
80103351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103358:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010335c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010335f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103365:	eb 89                	jmp    801032f0 <mpinit+0xf0>
80103367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010336e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103370:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103376:	83 f9 07             	cmp    $0x7,%ecx
80103379:	7f 19                	jg     80103394 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103381:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103385:	83 c1 01             	add    $0x1,%ecx
80103388:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010338e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103394:	83 c0 14             	add    $0x14,%eax
      continue;
80103397:	e9 54 ff ff ff       	jmp    801032f0 <mpinit+0xf0>
8010339c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033a0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033a5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033aa:	e8 d1 fd ff ff       	call   80103180 <mpsearch1>
801033af:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033b1:	85 c0                	test   %eax,%eax
801033b3:	0f 85 9b fe ff ff    	jne    80103254 <mpinit+0x54>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033c0:	83 ec 0c             	sub    $0xc,%esp
801033c3:	68 82 80 10 80       	push   $0x80108082
801033c8:	e8 c3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033cd:	83 ec 0c             	sub    $0xc,%esp
801033d0:	68 9c 80 10 80       	push   $0x8010809c
801033d5:	e8 b6 cf ff ff       	call   80100390 <panic>
801033da:	66 90                	xchg   %ax,%ax
801033dc:	66 90                	xchg   %ax,%ax
801033de:	66 90                	xchg   %ax,%ax

801033e0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033e0:	f3 0f 1e fb          	endbr32 
801033e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033e9:	ba 21 00 00 00       	mov    $0x21,%edx
801033ee:	ee                   	out    %al,(%dx)
801033ef:	ba a1 00 00 00       	mov    $0xa1,%edx
801033f4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033f5:	c3                   	ret    
801033f6:	66 90                	xchg   %ax,%ax
801033f8:	66 90                	xchg   %ax,%ax
801033fa:	66 90                	xchg   %ax,%ax
801033fc:	66 90                	xchg   %ax,%ax
801033fe:	66 90                	xchg   %ax,%ax

80103400 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103400:	f3 0f 1e fb          	endbr32 
80103404:	55                   	push   %ebp
80103405:	89 e5                	mov    %esp,%ebp
80103407:	57                   	push   %edi
80103408:	56                   	push   %esi
80103409:	53                   	push   %ebx
8010340a:	83 ec 0c             	sub    $0xc,%esp
8010340d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103410:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103413:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103419:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010341f:	e8 ec d9 ff ff       	call   80100e10 <filealloc>
80103424:	89 03                	mov    %eax,(%ebx)
80103426:	85 c0                	test   %eax,%eax
80103428:	0f 84 ac 00 00 00    	je     801034da <pipealloc+0xda>
8010342e:	e8 dd d9 ff ff       	call   80100e10 <filealloc>
80103433:	89 06                	mov    %eax,(%esi)
80103435:	85 c0                	test   %eax,%eax
80103437:	0f 84 8b 00 00 00    	je     801034c8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010343d:	e8 fe f1 ff ff       	call   80102640 <kalloc>
80103442:	89 c7                	mov    %eax,%edi
80103444:	85 c0                	test   %eax,%eax
80103446:	0f 84 b4 00 00 00    	je     80103500 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010344c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103453:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103456:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103459:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103460:	00 00 00 
  p->nwrite = 0;
80103463:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010346a:	00 00 00 
  p->nread = 0;
8010346d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103474:	00 00 00 
  initlock(&p->lock, "pipe");
80103477:	68 bb 80 10 80       	push   $0x801080bb
8010347c:	50                   	push   %eax
8010347d:	e8 3e 11 00 00       	call   801045c0 <initlock>
  (*f0)->type = FD_PIPE;
80103482:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103484:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103487:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010348d:	8b 03                	mov    (%ebx),%eax
8010348f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103493:	8b 03                	mov    (%ebx),%eax
80103495:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103499:	8b 03                	mov    (%ebx),%eax
8010349b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010349e:	8b 06                	mov    (%esi),%eax
801034a0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034a6:	8b 06                	mov    (%esi),%eax
801034a8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ac:	8b 06                	mov    (%esi),%eax
801034ae:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034b2:	8b 06                	mov    (%esi),%eax
801034b4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ba:	31 c0                	xor    %eax,%eax
}
801034bc:	5b                   	pop    %ebx
801034bd:	5e                   	pop    %esi
801034be:	5f                   	pop    %edi
801034bf:	5d                   	pop    %ebp
801034c0:	c3                   	ret    
801034c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034c8:	8b 03                	mov    (%ebx),%eax
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 1e                	je     801034ec <pipealloc+0xec>
    fileclose(*f0);
801034ce:	83 ec 0c             	sub    $0xc,%esp
801034d1:	50                   	push   %eax
801034d2:	e8 f9 d9 ff ff       	call   80100ed0 <fileclose>
801034d7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	85 c0                	test   %eax,%eax
801034de:	74 0c                	je     801034ec <pipealloc+0xec>
    fileclose(*f1);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	50                   	push   %eax
801034e4:	e8 e7 d9 ff ff       	call   80100ed0 <fileclose>
801034e9:	83 c4 10             	add    $0x10,%esp
}
801034ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034f4:	5b                   	pop    %ebx
801034f5:	5e                   	pop    %esi
801034f6:	5f                   	pop    %edi
801034f7:	5d                   	pop    %ebp
801034f8:	c3                   	ret    
801034f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103500:	8b 03                	mov    (%ebx),%eax
80103502:	85 c0                	test   %eax,%eax
80103504:	75 c8                	jne    801034ce <pipealloc+0xce>
80103506:	eb d2                	jmp    801034da <pipealloc+0xda>
80103508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010350f:	90                   	nop

80103510 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103510:	f3 0f 1e fb          	endbr32 
80103514:	55                   	push   %ebp
80103515:	89 e5                	mov    %esp,%ebp
80103517:	56                   	push   %esi
80103518:	53                   	push   %ebx
80103519:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010351c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	53                   	push   %ebx
80103523:	e8 18 12 00 00       	call   80104740 <acquire>
  if(writable){
80103528:	83 c4 10             	add    $0x10,%esp
8010352b:	85 f6                	test   %esi,%esi
8010352d:	74 41                	je     80103570 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010352f:	83 ec 0c             	sub    $0xc,%esp
80103532:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103538:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010353f:	00 00 00 
    wakeup(&p->nread);
80103542:	50                   	push   %eax
80103543:	e8 58 0d 00 00       	call   801042a0 <wakeup>
80103548:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010354b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103551:	85 d2                	test   %edx,%edx
80103553:	75 0a                	jne    8010355f <pipeclose+0x4f>
80103555:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010355b:	85 c0                	test   %eax,%eax
8010355d:	74 31                	je     80103590 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010355f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103562:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103565:	5b                   	pop    %ebx
80103566:	5e                   	pop    %esi
80103567:	5d                   	pop    %ebp
    release(&p->lock);
80103568:	e9 93 12 00 00       	jmp    80104800 <release>
8010356d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103570:	83 ec 0c             	sub    $0xc,%esp
80103573:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103579:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103580:	00 00 00 
    wakeup(&p->nwrite);
80103583:	50                   	push   %eax
80103584:	e8 17 0d 00 00       	call   801042a0 <wakeup>
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	eb bd                	jmp    8010354b <pipeclose+0x3b>
8010358e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	53                   	push   %ebx
80103594:	e8 67 12 00 00       	call   80104800 <release>
    kfree((char*)p);
80103599:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010359c:	83 c4 10             	add    $0x10,%esp
}
8010359f:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a2:	5b                   	pop    %ebx
801035a3:	5e                   	pop    %esi
801035a4:	5d                   	pop    %ebp
    kfree((char*)p);
801035a5:	e9 d6 ee ff ff       	jmp    80102480 <kfree>
801035aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035b0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035b0:	f3 0f 1e fb          	endbr32 
801035b4:	55                   	push   %ebp
801035b5:	89 e5                	mov    %esp,%ebp
801035b7:	57                   	push   %edi
801035b8:	56                   	push   %esi
801035b9:	53                   	push   %ebx
801035ba:	83 ec 28             	sub    $0x28,%esp
801035bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035c0:	53                   	push   %ebx
801035c1:	e8 7a 11 00 00       	call   80104740 <acquire>
  for(i = 0; i < n; i++){
801035c6:	8b 45 10             	mov    0x10(%ebp),%eax
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	85 c0                	test   %eax,%eax
801035ce:	0f 8e bc 00 00 00    	jle    80103690 <pipewrite+0xe0>
801035d4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035d7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035dd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035e6:	03 45 10             	add    0x10(%ebp),%eax
801035e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035ec:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035f8:	89 ca                	mov    %ecx,%edx
801035fa:	05 00 02 00 00       	add    $0x200,%eax
801035ff:	39 c1                	cmp    %eax,%ecx
80103601:	74 3b                	je     8010363e <pipewrite+0x8e>
80103603:	eb 63                	jmp    80103668 <pipewrite+0xb8>
80103605:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103608:	e8 c3 04 00 00       	call   80103ad0 <myproc>
8010360d:	8b 48 24             	mov    0x24(%eax),%ecx
80103610:	85 c9                	test   %ecx,%ecx
80103612:	75 34                	jne    80103648 <pipewrite+0x98>
      wakeup(&p->nread);
80103614:	83 ec 0c             	sub    $0xc,%esp
80103617:	57                   	push   %edi
80103618:	e8 83 0c 00 00       	call   801042a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010361d:	58                   	pop    %eax
8010361e:	5a                   	pop    %edx
8010361f:	53                   	push   %ebx
80103620:	56                   	push   %esi
80103621:	e8 ba 0a 00 00       	call   801040e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103626:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010362c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103632:	83 c4 10             	add    $0x10,%esp
80103635:	05 00 02 00 00       	add    $0x200,%eax
8010363a:	39 c2                	cmp    %eax,%edx
8010363c:	75 2a                	jne    80103668 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010363e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103644:	85 c0                	test   %eax,%eax
80103646:	75 c0                	jne    80103608 <pipewrite+0x58>
        release(&p->lock);
80103648:	83 ec 0c             	sub    $0xc,%esp
8010364b:	53                   	push   %ebx
8010364c:	e8 af 11 00 00       	call   80104800 <release>
        return -1;
80103651:	83 c4 10             	add    $0x10,%esp
80103654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103659:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010365c:	5b                   	pop    %ebx
8010365d:	5e                   	pop    %esi
8010365e:	5f                   	pop    %edi
8010365f:	5d                   	pop    %ebp
80103660:	c3                   	ret    
80103661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103668:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010366b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010366e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103674:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010367a:	0f b6 06             	movzbl (%esi),%eax
8010367d:	83 c6 01             	add    $0x1,%esi
80103680:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103683:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103687:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010368a:	0f 85 5c ff ff ff    	jne    801035ec <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103690:	83 ec 0c             	sub    $0xc,%esp
80103693:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103699:	50                   	push   %eax
8010369a:	e8 01 0c 00 00       	call   801042a0 <wakeup>
  release(&p->lock);
8010369f:	89 1c 24             	mov    %ebx,(%esp)
801036a2:	e8 59 11 00 00       	call   80104800 <release>
  return n;
801036a7:	8b 45 10             	mov    0x10(%ebp),%eax
801036aa:	83 c4 10             	add    $0x10,%esp
801036ad:	eb aa                	jmp    80103659 <pipewrite+0xa9>
801036af:	90                   	nop

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	f3 0f 1e fb          	endbr32 
801036b4:	55                   	push   %ebp
801036b5:	89 e5                	mov    %esp,%ebp
801036b7:	57                   	push   %edi
801036b8:	56                   	push   %esi
801036b9:	53                   	push   %ebx
801036ba:	83 ec 18             	sub    $0x18,%esp
801036bd:	8b 75 08             	mov    0x8(%ebp),%esi
801036c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036c3:	56                   	push   %esi
801036c4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ca:	e8 71 10 00 00       	call   80104740 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036cf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036d5:	83 c4 10             	add    $0x10,%esp
801036d8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036de:	74 33                	je     80103713 <piperead+0x63>
801036e0:	eb 3b                	jmp    8010371d <piperead+0x6d>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036e8:	e8 e3 03 00 00       	call   80103ad0 <myproc>
801036ed:	8b 48 24             	mov    0x24(%eax),%ecx
801036f0:	85 c9                	test   %ecx,%ecx
801036f2:	0f 85 88 00 00 00    	jne    80103780 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	56                   	push   %esi
801036fc:	53                   	push   %ebx
801036fd:	e8 de 09 00 00       	call   801040e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103702:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103708:	83 c4 10             	add    $0x10,%esp
8010370b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103711:	75 0a                	jne    8010371d <piperead+0x6d>
80103713:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103719:	85 c0                	test   %eax,%eax
8010371b:	75 cb                	jne    801036e8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010371d:	8b 55 10             	mov    0x10(%ebp),%edx
80103720:	31 db                	xor    %ebx,%ebx
80103722:	85 d2                	test   %edx,%edx
80103724:	7f 28                	jg     8010374e <piperead+0x9e>
80103726:	eb 34                	jmp    8010375c <piperead+0xac>
80103728:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103730:	8d 48 01             	lea    0x1(%eax),%ecx
80103733:	25 ff 01 00 00       	and    $0x1ff,%eax
80103738:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010373e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103743:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103746:	83 c3 01             	add    $0x1,%ebx
80103749:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010374c:	74 0e                	je     8010375c <piperead+0xac>
    if(p->nread == p->nwrite)
8010374e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	75 d4                	jne    80103730 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010375c:	83 ec 0c             	sub    $0xc,%esp
8010375f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103765:	50                   	push   %eax
80103766:	e8 35 0b 00 00       	call   801042a0 <wakeup>
  release(&p->lock);
8010376b:	89 34 24             	mov    %esi,(%esp)
8010376e:	e8 8d 10 00 00       	call   80104800 <release>
  return i;
80103773:	83 c4 10             	add    $0x10,%esp
}
80103776:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103779:	89 d8                	mov    %ebx,%eax
8010377b:	5b                   	pop    %ebx
8010377c:	5e                   	pop    %esi
8010377d:	5f                   	pop    %edi
8010377e:	5d                   	pop    %ebp
8010377f:	c3                   	ret    
      release(&p->lock);
80103780:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103783:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103788:	56                   	push   %esi
80103789:	e8 72 10 00 00       	call   80104800 <release>
      return -1;
8010378e:	83 c4 10             	add    $0x10,%esp
}
80103791:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103794:	89 d8                	mov    %ebx,%eax
80103796:	5b                   	pop    %ebx
80103797:	5e                   	pop    %esi
80103798:	5f                   	pop    %edi
80103799:	5d                   	pop    %ebp
8010379a:	c3                   	ret    
8010379b:	66 90                	xchg   %ax,%ax
8010379d:	66 90                	xchg   %ax,%ax
8010379f:	90                   	nop

801037a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037a4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ac:	68 20 3d 11 80       	push   $0x80113d20
801037b1:	e8 8a 0f 00 00       	call   80104740 <acquire>
801037b6:	83 c4 10             	add    $0x10,%esp
801037b9:	eb 17                	jmp    801037d2 <allocproc+0x32>
801037bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037bf:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037c0:	81 c3 ec 00 00 00    	add    $0xec,%ebx
801037c6:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
801037cc:	0f 84 8e 00 00 00    	je     80103860 <allocproc+0xc0>
    if(p->state == UNUSED)
801037d2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 e7                	jne    801037c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037d9:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority = 10;
  release(&ptable.lock);
801037de:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037e1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->priority = 10;
801037e8:	c7 83 e4 00 00 00 0a 	movl   $0xa,0xe4(%ebx)
801037ef:	00 00 00 
  p->pid = nextpid++;
801037f2:	89 43 10             	mov    %eax,0x10(%ebx)
801037f5:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037f8:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
801037fd:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103803:	e8 f8 0f 00 00       	call   80104800 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103808:	e8 33 ee ff ff       	call   80102640 <kalloc>
8010380d:	83 c4 10             	add    $0x10,%esp
80103810:	89 43 08             	mov    %eax,0x8(%ebx)
80103813:	85 c0                	test   %eax,%eax
80103815:	74 62                	je     80103879 <allocproc+0xd9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103817:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381d:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103820:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103825:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103828:	c7 40 14 26 63 10 80 	movl   $0x80106326,0x14(%eax)
  p->context = (struct context*)sp;
8010382f:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103832:	6a 14                	push   $0x14
80103834:	6a 00                	push   $0x0
80103836:	50                   	push   %eax
80103837:	e8 14 10 00 00       	call   80104850 <memset>
  p->context->eip = (uint)forkret;
8010383c:	8b 43 1c             	mov    0x1c(%ebx),%eax

  p->creation_time = ticks;
  p->start_time = ticks;

  return p;
8010383f:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103842:	c7 40 10 90 38 10 80 	movl   $0x80103890,0x10(%eax)
  p->creation_time = ticks;
80103849:	a1 a0 80 11 80       	mov    0x801180a0,%eax
8010384e:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->start_time = ticks;
80103851:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
}
80103857:	89 d8                	mov    %ebx,%eax
80103859:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385c:	c9                   	leave  
8010385d:	c3                   	ret    
8010385e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103860:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103863:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103865:	68 20 3d 11 80       	push   $0x80113d20
8010386a:	e8 91 0f 00 00       	call   80104800 <release>
}
8010386f:	89 d8                	mov    %ebx,%eax
  return 0;
80103871:	83 c4 10             	add    $0x10,%esp
}
80103874:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103877:	c9                   	leave  
80103878:	c3                   	ret    
    p->state = UNUSED;
80103879:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103880:	31 db                	xor    %ebx,%ebx
}
80103882:	89 d8                	mov    %ebx,%eax
80103884:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103887:	c9                   	leave  
80103888:	c3                   	ret    
80103889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103890 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103890:	f3 0f 1e fb          	endbr32 
80103894:	55                   	push   %ebp
80103895:	89 e5                	mov    %esp,%ebp
80103897:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010389a:	68 20 3d 11 80       	push   $0x80113d20
8010389f:	e8 5c 0f 00 00       	call   80104800 <release>

  if (first) {
801038a4:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801038a9:	83 c4 10             	add    $0x10,%esp
801038ac:	85 c0                	test   %eax,%eax
801038ae:	75 08                	jne    801038b8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038b0:	c9                   	leave  
801038b1:	c3                   	ret    
801038b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038b8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038bf:	00 00 00 
    iinit(ROOTDEV);
801038c2:	83 ec 0c             	sub    $0xc,%esp
801038c5:	6a 01                	push   $0x1
801038c7:	e8 84 dc ff ff       	call   80101550 <iinit>
    initlog(ROOTDEV);
801038cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038d3:	e8 c8 f3 ff ff       	call   80102ca0 <initlog>
}
801038d8:	83 c4 10             	add    $0x10,%esp
801038db:	c9                   	leave  
801038dc:	c3                   	ret    
801038dd:	8d 76 00             	lea    0x0(%esi),%esi

801038e0 <cps>:
{
801038e0:	f3 0f 1e fb          	endbr32 
801038e4:	55                   	push   %ebp
801038e5:	89 e5                	mov    %esp,%ebp
801038e7:	53                   	push   %ebx
801038e8:	83 ec 10             	sub    $0x10,%esp
  asm volatile("sti");
801038eb:	fb                   	sti    
acquire(&ptable.lock);
801038ec:	68 20 3d 11 80       	push   $0x80113d20
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038f1:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
acquire(&ptable.lock);
801038f6:	e8 45 0e 00 00       	call   80104740 <acquire>
cprintf("name \t pid \t state \t priority \n");
801038fb:	c7 04 24 c0 80 10 80 	movl   $0x801080c0,(%esp)
80103902:	e8 a9 cd ff ff       	call   801006b0 <cprintf>
80103907:	83 c4 10             	add    $0x10,%esp
8010390a:	eb 1c                	jmp    80103928 <cps+0x48>
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
	else if(p->state == RUNNING)
80103910:	83 f8 04             	cmp    $0x4,%eax
80103913:	74 63                	je     80103978 <cps+0x98>
	else if(p->state == RUNNABLE)
80103915:	83 f8 03             	cmp    $0x3,%eax
80103918:	74 7e                	je     80103998 <cps+0xb8>
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010391a:	81 c3 ec 00 00 00    	add    $0xec,%ebx
80103920:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80103926:	74 33                	je     8010395b <cps+0x7b>
  if(p->state == SLEEPING)
80103928:	8b 43 0c             	mov    0xc(%ebx),%eax
8010392b:	83 f8 02             	cmp    $0x2,%eax
8010392e:	75 e0                	jne    80103910 <cps+0x30>
	  cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
80103930:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103933:	ff b3 e4 00 00 00    	pushl  0xe4(%ebx)
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103939:	81 c3 ec 00 00 00    	add    $0xec,%ebx
	  cprintf("%s \t %d \t SLEEPING \t %d \n ", p->name,p->pid,p->priority);
8010393f:	ff b3 24 ff ff ff    	pushl  -0xdc(%ebx)
80103945:	50                   	push   %eax
80103946:	68 06 81 10 80       	push   $0x80108106
8010394b:	e8 60 cd ff ff       	call   801006b0 <cprintf>
80103950:	83 c4 10             	add    $0x10,%esp
for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103953:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80103959:	75 cd                	jne    80103928 <cps+0x48>
release(&ptable.lock);
8010395b:	83 ec 0c             	sub    $0xc,%esp
8010395e:	68 20 3d 11 80       	push   $0x80113d20
80103963:	e8 98 0e 00 00       	call   80104800 <release>
}
80103968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010396b:	b8 16 00 00 00       	mov    $0x16,%eax
80103970:	c9                   	leave  
80103971:	c3                   	ret    
80103972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 	  cprintf("%s \t %d \t RUNNING \t %d \n ", p->name,p->pid,p->priority);
80103978:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010397b:	ff b3 e4 00 00 00    	pushl  0xe4(%ebx)
80103981:	ff 73 10             	pushl  0x10(%ebx)
80103984:	50                   	push   %eax
80103985:	68 21 81 10 80       	push   $0x80108121
8010398a:	e8 21 cd ff ff       	call   801006b0 <cprintf>
8010398f:	83 c4 10             	add    $0x10,%esp
80103992:	eb 86                	jmp    8010391a <cps+0x3a>
80103994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 	  cprintf("%s \t %d \t RUNNABLE \t %d \n ", p->name,p->pid,p->priority);
80103998:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010399b:	ff b3 e4 00 00 00    	pushl  0xe4(%ebx)
801039a1:	ff 73 10             	pushl  0x10(%ebx)
801039a4:	50                   	push   %eax
801039a5:	68 3b 81 10 80       	push   $0x8010813b
801039aa:	e8 01 cd ff ff       	call   801006b0 <cprintf>
801039af:	83 c4 10             	add    $0x10,%esp
801039b2:	e9 63 ff ff ff       	jmp    8010391a <cps+0x3a>
801039b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039be:	66 90                	xchg   %ax,%ax

801039c0 <chpr>:
{
801039c0:	f3 0f 1e fb          	endbr32 
801039c4:	55                   	push   %ebp
801039c5:	89 e5                	mov    %esp,%ebp
801039c7:	53                   	push   %ebx
801039c8:	83 ec 10             	sub    $0x10,%esp
801039cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	acquire(&ptable.lock);
801039ce:	68 20 3d 11 80       	push   $0x80113d20
801039d3:	e8 68 0d 00 00       	call   80104740 <acquire>
801039d8:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039db:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801039e0:	eb 12                	jmp    801039f4 <chpr+0x34>
801039e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039e8:	05 ec 00 00 00       	add    $0xec,%eax
801039ed:	3d 54 78 11 80       	cmp    $0x80117854,%eax
801039f2:	74 0e                	je     80103a02 <chpr+0x42>
	  if(p->pid == pid){
801039f4:	39 58 10             	cmp    %ebx,0x10(%eax)
801039f7:	75 ef                	jne    801039e8 <chpr+0x28>
			p->priority = priority;
801039f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801039fc:	89 90 e4 00 00 00    	mov    %edx,0xe4(%eax)
	release(&ptable.lock);
80103a02:	83 ec 0c             	sub    $0xc,%esp
80103a05:	68 20 3d 11 80       	push   $0x80113d20
80103a0a:	e8 f1 0d 00 00       	call   80104800 <release>
}
80103a0f:	89 d8                	mov    %ebx,%eax
80103a11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a14:	c9                   	leave  
80103a15:	c3                   	ret    
80103a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi

80103a20 <pinit>:
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a2a:	68 56 81 10 80       	push   $0x80108156
80103a2f:	68 20 3d 11 80       	push   $0x80113d20
80103a34:	e8 87 0b 00 00       	call   801045c0 <initlock>
}
80103a39:	83 c4 10             	add    $0x10,%esp
80103a3c:	c9                   	leave  
80103a3d:	c3                   	ret    
80103a3e:	66 90                	xchg   %ax,%ax

80103a40 <mycpu>:
{
80103a40:	f3 0f 1e fb          	endbr32 
80103a44:	55                   	push   %ebp
80103a45:	89 e5                	mov    %esp,%ebp
80103a47:	56                   	push   %esi
80103a48:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a49:	9c                   	pushf  
80103a4a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a4b:	f6 c4 02             	test   $0x2,%ah
80103a4e:	75 4a                	jne    80103a9a <mycpu+0x5a>
  apicid = lapicid();
80103a50:	e8 5b ee ff ff       	call   801028b0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a55:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
80103a5b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103a5d:	85 f6                	test   %esi,%esi
80103a5f:	7e 2c                	jle    80103a8d <mycpu+0x4d>
80103a61:	31 d2                	xor    %edx,%edx
80103a63:	eb 0a                	jmp    80103a6f <mycpu+0x2f>
80103a65:	8d 76 00             	lea    0x0(%esi),%esi
80103a68:	83 c2 01             	add    $0x1,%edx
80103a6b:	39 f2                	cmp    %esi,%edx
80103a6d:	74 1e                	je     80103a8d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103a6f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a75:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
80103a7c:	39 d8                	cmp    %ebx,%eax
80103a7e:	75 e8                	jne    80103a68 <mycpu+0x28>
}
80103a80:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a83:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103a89:	5b                   	pop    %ebx
80103a8a:	5e                   	pop    %esi
80103a8b:	5d                   	pop    %ebp
80103a8c:	c3                   	ret    
  panic("unknown apicid\n");
80103a8d:	83 ec 0c             	sub    $0xc,%esp
80103a90:	68 5d 81 10 80       	push   $0x8010815d
80103a95:	e8 f6 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a9a:	83 ec 0c             	sub    $0xc,%esp
80103a9d:	68 e0 80 10 80       	push   $0x801080e0
80103aa2:	e8 e9 c8 ff ff       	call   80100390 <panic>
80103aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aae:	66 90                	xchg   %ax,%ax

80103ab0 <cpuid>:
cpuid() {
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103aba:	e8 81 ff ff ff       	call   80103a40 <mycpu>
}
80103abf:	c9                   	leave  
  return mycpu()-cpus;
80103ac0:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103ac5:	c1 f8 04             	sar    $0x4,%eax
80103ac8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103ace:	c3                   	ret    
80103acf:	90                   	nop

80103ad0 <myproc>:
myproc(void) {
80103ad0:	f3 0f 1e fb          	endbr32 
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	53                   	push   %ebx
80103ad8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103adb:	e8 60 0b 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103ae0:	e8 5b ff ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103ae5:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aeb:	e8 a0 0b 00 00       	call   80104690 <popcli>
}
80103af0:	83 c4 04             	add    $0x4,%esp
80103af3:	89 d8                	mov    %ebx,%eax
80103af5:	5b                   	pop    %ebx
80103af6:	5d                   	pop    %ebp
80103af7:	c3                   	ret    
80103af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aff:	90                   	nop

80103b00 <userinit>:
{
80103b00:	f3 0f 1e fb          	endbr32 
80103b04:	55                   	push   %ebp
80103b05:	89 e5                	mov    %esp,%ebp
80103b07:	53                   	push   %ebx
80103b08:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103b0b:	e8 90 fc ff ff       	call   801037a0 <allocproc>
80103b10:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103b12:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103b17:	e8 d4 3d 00 00       	call   801078f0 <setupkvm>
80103b1c:	89 43 04             	mov    %eax,0x4(%ebx)
80103b1f:	85 c0                	test   %eax,%eax
80103b21:	0f 84 bd 00 00 00    	je     80103be4 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b27:	83 ec 04             	sub    $0x4,%esp
80103b2a:	68 2c 00 00 00       	push   $0x2c
80103b2f:	68 60 b4 10 80       	push   $0x8010b460
80103b34:	50                   	push   %eax
80103b35:	e8 86 3a 00 00       	call   801075c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b3a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b3d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b43:	6a 4c                	push   $0x4c
80103b45:	6a 00                	push   $0x0
80103b47:	ff 73 18             	pushl  0x18(%ebx)
80103b4a:	e8 01 0d 00 00       	call   80104850 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b4f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b52:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b57:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b5a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b5f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b63:	8b 43 18             	mov    0x18(%ebx),%eax
80103b66:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b6a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b6d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b71:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b75:	8b 43 18             	mov    0x18(%ebx),%eax
80103b78:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b7c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b80:	8b 43 18             	mov    0x18(%ebx),%eax
80103b83:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b8a:	8b 43 18             	mov    0x18(%ebx),%eax
80103b8d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b94:	8b 43 18             	mov    0x18(%ebx),%eax
80103b97:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b9e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ba1:	6a 10                	push   $0x10
80103ba3:	68 86 81 10 80       	push   $0x80108186
80103ba8:	50                   	push   %eax
80103ba9:	e8 62 0e 00 00       	call   80104a10 <safestrcpy>
  p->cwd = namei("/");
80103bae:	c7 04 24 8f 81 10 80 	movl   $0x8010818f,(%esp)
80103bb5:	e8 86 e4 ff ff       	call   80102040 <namei>
80103bba:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103bbd:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bc4:	e8 77 0b 00 00       	call   80104740 <acquire>
  p->state = RUNNABLE;
80103bc9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bd0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bd7:	e8 24 0c 00 00       	call   80104800 <release>
}
80103bdc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bdf:	83 c4 10             	add    $0x10,%esp
80103be2:	c9                   	leave  
80103be3:	c3                   	ret    
    panic("userinit: out of memory?");
80103be4:	83 ec 0c             	sub    $0xc,%esp
80103be7:	68 6d 81 10 80       	push   $0x8010816d
80103bec:	e8 9f c7 ff ff       	call   80100390 <panic>
80103bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bff:	90                   	nop

80103c00 <growproc>:
{
80103c00:	f3 0f 1e fb          	endbr32 
80103c04:	55                   	push   %ebp
80103c05:	89 e5                	mov    %esp,%ebp
80103c07:	56                   	push   %esi
80103c08:	53                   	push   %ebx
80103c09:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103c0c:	e8 2f 0a 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103c11:	e8 2a fe ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103c16:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c1c:	e8 6f 0a 00 00       	call   80104690 <popcli>
  sz = curproc->sz;
80103c21:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103c23:	85 f6                	test   %esi,%esi
80103c25:	7f 19                	jg     80103c40 <growproc+0x40>
  } else if(n < 0){
80103c27:	75 37                	jne    80103c60 <growproc+0x60>
  switchuvm(curproc);
80103c29:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103c2c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103c2e:	53                   	push   %ebx
80103c2f:	e8 7c 38 00 00       	call   801074b0 <switchuvm>
  return 0;
80103c34:	83 c4 10             	add    $0x10,%esp
80103c37:	31 c0                	xor    %eax,%eax
}
80103c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c3c:	5b                   	pop    %ebx
80103c3d:	5e                   	pop    %esi
80103c3e:	5d                   	pop    %ebp
80103c3f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c40:	83 ec 04             	sub    $0x4,%esp
80103c43:	01 c6                	add    %eax,%esi
80103c45:	56                   	push   %esi
80103c46:	50                   	push   %eax
80103c47:	ff 73 04             	pushl  0x4(%ebx)
80103c4a:	e8 c1 3a 00 00       	call   80107710 <allocuvm>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 d3                	jne    80103c29 <growproc+0x29>
      return -1;
80103c56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c5b:	eb dc                	jmp    80103c39 <growproc+0x39>
80103c5d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c60:	83 ec 04             	sub    $0x4,%esp
80103c63:	01 c6                	add    %eax,%esi
80103c65:	56                   	push   %esi
80103c66:	50                   	push   %eax
80103c67:	ff 73 04             	pushl  0x4(%ebx)
80103c6a:	e8 d1 3b 00 00       	call   80107840 <deallocuvm>
80103c6f:	83 c4 10             	add    $0x10,%esp
80103c72:	85 c0                	test   %eax,%eax
80103c74:	75 b3                	jne    80103c29 <growproc+0x29>
80103c76:	eb de                	jmp    80103c56 <growproc+0x56>
80103c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c7f:	90                   	nop

80103c80 <fork>:
{
80103c80:	f3 0f 1e fb          	endbr32 
80103c84:	55                   	push   %ebp
80103c85:	89 e5                	mov    %esp,%ebp
80103c87:	57                   	push   %edi
80103c88:	56                   	push   %esi
80103c89:	53                   	push   %ebx
80103c8a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c8d:	e8 ae 09 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103c92:	e8 a9 fd ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103c97:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c9d:	e8 ee 09 00 00       	call   80104690 <popcli>
  if((np = allocproc()) == 0){
80103ca2:	e8 f9 fa ff ff       	call   801037a0 <allocproc>
80103ca7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103caa:	85 c0                	test   %eax,%eax
80103cac:	0f 84 bb 00 00 00    	je     80103d6d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103cb2:	83 ec 08             	sub    $0x8,%esp
80103cb5:	ff 33                	pushl  (%ebx)
80103cb7:	89 c7                	mov    %eax,%edi
80103cb9:	ff 73 04             	pushl  0x4(%ebx)
80103cbc:	e8 ff 3c 00 00       	call   801079c0 <copyuvm>
80103cc1:	83 c4 10             	add    $0x10,%esp
80103cc4:	89 47 04             	mov    %eax,0x4(%edi)
80103cc7:	85 c0                	test   %eax,%eax
80103cc9:	0f 84 a5 00 00 00    	je     80103d74 <fork+0xf4>
  np->sz = curproc->sz;
80103ccf:	8b 03                	mov    (%ebx),%eax
80103cd1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cd4:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103cd6:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103cd9:	89 c8                	mov    %ecx,%eax
80103cdb:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103cde:	b9 13 00 00 00       	mov    $0x13,%ecx
80103ce3:	8b 73 18             	mov    0x18(%ebx),%esi
80103ce6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ce8:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cea:	8b 40 18             	mov    0x18(%eax),%eax
80103ced:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103cf8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cfc:	85 c0                	test   %eax,%eax
80103cfe:	74 13                	je     80103d13 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d00:	83 ec 0c             	sub    $0xc,%esp
80103d03:	50                   	push   %eax
80103d04:	e8 77 d1 ff ff       	call   80100e80 <filedup>
80103d09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103d0c:	83 c4 10             	add    $0x10,%esp
80103d0f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d13:	83 c6 01             	add    $0x1,%esi
80103d16:	83 fe 10             	cmp    $0x10,%esi
80103d19:	75 dd                	jne    80103cf8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103d1b:	83 ec 0c             	sub    $0xc,%esp
80103d1e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d21:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d24:	e8 17 da ff ff       	call   80101740 <idup>
80103d29:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d2c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d2f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d32:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d35:	6a 10                	push   $0x10
80103d37:	53                   	push   %ebx
80103d38:	50                   	push   %eax
80103d39:	e8 d2 0c 00 00       	call   80104a10 <safestrcpy>
  pid = np->pid;
80103d3e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d41:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d48:	e8 f3 09 00 00       	call   80104740 <acquire>
  np->state = RUNNABLE;
80103d4d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d54:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d5b:	e8 a0 0a 00 00       	call   80104800 <release>
  return pid;
80103d60:	83 c4 10             	add    $0x10,%esp
}
80103d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d66:	89 d8                	mov    %ebx,%eax
80103d68:	5b                   	pop    %ebx
80103d69:	5e                   	pop    %esi
80103d6a:	5f                   	pop    %edi
80103d6b:	5d                   	pop    %ebp
80103d6c:	c3                   	ret    
    return -1;
80103d6d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d72:	eb ef                	jmp    80103d63 <fork+0xe3>
    kfree(np->kstack);
80103d74:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d77:	83 ec 0c             	sub    $0xc,%esp
80103d7a:	ff 73 08             	pushl  0x8(%ebx)
80103d7d:	e8 fe e6 ff ff       	call   80102480 <kfree>
    np->kstack = 0;
80103d82:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d89:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d8c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d93:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d98:	eb c9                	jmp    80103d63 <fork+0xe3>
80103d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103da0 <scheduler>:
{
80103da0:	f3 0f 1e fb          	endbr32 
80103da4:	55                   	push   %ebp
80103da5:	89 e5                	mov    %esp,%ebp
80103da7:	57                   	push   %edi
80103da8:	56                   	push   %esi
80103da9:	53                   	push   %ebx
80103daa:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103dad:	e8 8e fc ff ff       	call   80103a40 <mycpu>
  c->proc = 0;
80103db2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103db9:	00 00 00 
  struct cpu *c = mycpu();
80103dbc:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
80103dbe:	8d 70 04             	lea    0x4(%eax),%esi
80103dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103dc8:	fb                   	sti    
    acquire(&ptable.lock);
80103dc9:	83 ec 0c             	sub    $0xc,%esp
    struct proc *minP = 0;
80103dcc:	31 ff                	xor    %edi,%edi
    acquire(&ptable.lock);
80103dce:	68 20 3d 11 80       	push   $0x80113d20
80103dd3:	e8 68 09 00 00       	call   80104740 <acquire>
80103dd8:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ddb:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103de0:	eb 21                	jmp    80103e03 <scheduler+0x63>
80103de2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(minP == 0 || p->ctime < minP->ctime)
80103de8:	8b 97 e8 00 00 00    	mov    0xe8(%edi),%edx
80103dee:	39 90 e8 00 00 00    	cmp    %edx,0xe8(%eax)
80103df4:	0f 4c f8             	cmovl  %eax,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df7:	05 ec 00 00 00       	add    $0xec,%eax
80103dfc:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103e01:	74 1d                	je     80103e20 <scheduler+0x80>
        if(p->state != RUNNABLE)
80103e03:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
80103e07:	75 ee                	jne    80103df7 <scheduler+0x57>
        if(minP == 0 || p->ctime < minP->ctime)
80103e09:	85 ff                	test   %edi,%edi
80103e0b:	75 db                	jne    80103de8 <scheduler+0x48>
80103e0d:	89 c7                	mov    %eax,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e0f:	05 ec 00 00 00       	add    $0xec,%eax
80103e14:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103e19:	75 e8                	jne    80103e03 <scheduler+0x63>
80103e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e1f:	90                   	nop
    if(minP)
80103e20:	85 ff                	test   %edi,%edi
80103e22:	74 33                	je     80103e57 <scheduler+0xb7>
        switchuvm(p);
80103e24:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103e27:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
        switchuvm(p);
80103e2d:	57                   	push   %edi
80103e2e:	e8 7d 36 00 00       	call   801074b0 <switchuvm>
        p->state = RUNNING;
80103e33:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
        swtch(&(c->scheduler), p->context);
80103e3a:	58                   	pop    %eax
80103e3b:	5a                   	pop    %edx
80103e3c:	ff 77 1c             	pushl  0x1c(%edi)
80103e3f:	56                   	push   %esi
80103e40:	e8 2e 0c 00 00       	call   80104a73 <swtch>
        switchkvm();
80103e45:	e8 46 36 00 00       	call   80107490 <switchkvm>
        c->proc = 0;
80103e4a:	83 c4 10             	add    $0x10,%esp
80103e4d:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103e54:	00 00 00 
    release(&ptable.lock);
80103e57:	83 ec 0c             	sub    $0xc,%esp
80103e5a:	68 20 3d 11 80       	push   $0x80113d20
80103e5f:	e8 9c 09 00 00       	call   80104800 <release>
  {
80103e64:	83 c4 10             	add    $0x10,%esp
80103e67:	e9 5c ff ff ff       	jmp    80103dc8 <scheduler+0x28>
80103e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103e70 <sched>:
{
80103e70:	f3 0f 1e fb          	endbr32 
80103e74:	55                   	push   %ebp
80103e75:	89 e5                	mov    %esp,%ebp
80103e77:	56                   	push   %esi
80103e78:	53                   	push   %ebx
  pushcli();
80103e79:	e8 c2 07 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103e7e:	e8 bd fb ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103e83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e89:	e8 02 08 00 00       	call   80104690 <popcli>
  if(!holding(&ptable.lock))
80103e8e:	83 ec 0c             	sub    $0xc,%esp
80103e91:	68 20 3d 11 80       	push   $0x80113d20
80103e96:	e8 55 08 00 00       	call   801046f0 <holding>
80103e9b:	83 c4 10             	add    $0x10,%esp
80103e9e:	85 c0                	test   %eax,%eax
80103ea0:	74 4f                	je     80103ef1 <sched+0x81>
  if(mycpu()->ncli != 1)
80103ea2:	e8 99 fb ff ff       	call   80103a40 <mycpu>
80103ea7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eae:	75 68                	jne    80103f18 <sched+0xa8>
  if(p->state == RUNNING)
80103eb0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103eb4:	74 55                	je     80103f0b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103eb6:	9c                   	pushf  
80103eb7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103eb8:	f6 c4 02             	test   $0x2,%ah
80103ebb:	75 41                	jne    80103efe <sched+0x8e>
  intena = mycpu()->intena;
80103ebd:	e8 7e fb ff ff       	call   80103a40 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ec2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ec5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ecb:	e8 70 fb ff ff       	call   80103a40 <mycpu>
80103ed0:	83 ec 08             	sub    $0x8,%esp
80103ed3:	ff 70 04             	pushl  0x4(%eax)
80103ed6:	53                   	push   %ebx
80103ed7:	e8 97 0b 00 00       	call   80104a73 <swtch>
  mycpu()->intena = intena;
80103edc:	e8 5f fb ff ff       	call   80103a40 <mycpu>
}
80103ee1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ee4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eed:	5b                   	pop    %ebx
80103eee:	5e                   	pop    %esi
80103eef:	5d                   	pop    %ebp
80103ef0:	c3                   	ret    
    panic("sched ptable.lock");
80103ef1:	83 ec 0c             	sub    $0xc,%esp
80103ef4:	68 91 81 10 80       	push   $0x80108191
80103ef9:	e8 92 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103efe:	83 ec 0c             	sub    $0xc,%esp
80103f01:	68 bd 81 10 80       	push   $0x801081bd
80103f06:	e8 85 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f0b:	83 ec 0c             	sub    $0xc,%esp
80103f0e:	68 af 81 10 80       	push   $0x801081af
80103f13:	e8 78 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f18:	83 ec 0c             	sub    $0xc,%esp
80103f1b:	68 a3 81 10 80       	push   $0x801081a3
80103f20:	e8 6b c4 ff ff       	call   80100390 <panic>
80103f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f30 <exit>:
{
80103f30:	f3 0f 1e fb          	endbr32 
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	57                   	push   %edi
80103f38:	56                   	push   %esi
80103f39:	53                   	push   %ebx
80103f3a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f3d:	e8 fe 06 00 00       	call   80104640 <pushcli>
  c = mycpu();
80103f42:	e8 f9 fa ff ff       	call   80103a40 <mycpu>
  p = c->proc;
80103f47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f4d:	e8 3e 07 00 00       	call   80104690 <popcli>
  if(curproc == initproc)
80103f52:	8d 73 28             	lea    0x28(%ebx),%esi
80103f55:	8d 7b 68             	lea    0x68(%ebx),%edi
80103f58:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80103f5e:	0f 84 11 01 00 00    	je     80104075 <exit+0x145>
80103f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103f68:	8b 06                	mov    (%esi),%eax
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	74 12                	je     80103f80 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103f6e:	83 ec 0c             	sub    $0xc,%esp
80103f71:	50                   	push   %eax
80103f72:	e8 59 cf ff ff       	call   80100ed0 <fileclose>
      curproc->ofile[fd] = 0;
80103f77:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f7d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f80:	83 c6 04             	add    $0x4,%esi
80103f83:	39 f7                	cmp    %esi,%edi
80103f85:	75 e1                	jne    80103f68 <exit+0x38>
  begin_op();
80103f87:	e8 b4 ed ff ff       	call   80102d40 <begin_op>
  iput(curproc->cwd);
80103f8c:	83 ec 0c             	sub    $0xc,%esp
80103f8f:	ff 73 68             	pushl  0x68(%ebx)
80103f92:	e8 09 d9 ff ff       	call   801018a0 <iput>
  end_op();
80103f97:	e8 14 ee ff ff       	call   80102db0 <end_op>
  curproc->cwd = 0;
80103f9c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103fa3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103faa:	e8 91 07 00 00       	call   80104740 <acquire>
  wakeup1(curproc->parent);
80103faf:	8b 53 14             	mov    0x14(%ebx),%edx
80103fb2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb5:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103fba:	eb 10                	jmp    80103fcc <exit+0x9c>
80103fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fc0:	05 ec 00 00 00       	add    $0xec,%eax
80103fc5:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103fca:	74 1e                	je     80103fea <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103fcc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fd0:	75 ee                	jne    80103fc0 <exit+0x90>
80103fd2:	3b 50 20             	cmp    0x20(%eax),%edx
80103fd5:	75 e9                	jne    80103fc0 <exit+0x90>
      p->state = RUNNABLE;
80103fd7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fde:	05 ec 00 00 00       	add    $0xec,%eax
80103fe3:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80103fe8:	75 e2                	jne    80103fcc <exit+0x9c>
      p->parent = initproc;
80103fea:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff0:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103ff5:	eb 17                	jmp    8010400e <exit+0xde>
80103ff7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ffe:	66 90                	xchg   %ax,%ax
80104000:	81 c2 ec 00 00 00    	add    $0xec,%edx
80104006:	81 fa 54 78 11 80    	cmp    $0x80117854,%edx
8010400c:	74 3a                	je     80104048 <exit+0x118>
    if(p->parent == curproc){
8010400e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104011:	75 ed                	jne    80104000 <exit+0xd0>
      if(p->state == ZOMBIE)
80104013:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104017:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010401a:	75 e4                	jne    80104000 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010401c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104021:	eb 11                	jmp    80104034 <exit+0x104>
80104023:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104027:	90                   	nop
80104028:	05 ec 00 00 00       	add    $0xec,%eax
8010402d:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104032:	74 cc                	je     80104000 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80104034:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104038:	75 ee                	jne    80104028 <exit+0xf8>
8010403a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010403d:	75 e9                	jne    80104028 <exit+0xf8>
      p->state = RUNNABLE;
8010403f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104046:	eb e0                	jmp    80104028 <exit+0xf8>
  curproc->end_time = ticks;
80104048:	a1 a0 80 11 80       	mov    0x801180a0,%eax
  curproc->state = ZOMBIE;
8010404d:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  curproc->end_time = ticks;
80104054:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  curproc->total_time = curproc->end_time - curproc->creation_time;
8010405a:	2b 43 7c             	sub    0x7c(%ebx),%eax
8010405d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  sched();
80104063:	e8 08 fe ff ff       	call   80103e70 <sched>
  panic("zombie exit");
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 de 81 10 80       	push   $0x801081de
80104070:	e8 1b c3 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104075:	83 ec 0c             	sub    $0xc,%esp
80104078:	68 d1 81 10 80       	push   $0x801081d1
8010407d:	e8 0e c3 ff ff       	call   80100390 <panic>
80104082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104090 <yield>:
{
80104090:	f3 0f 1e fb          	endbr32 
80104094:	55                   	push   %ebp
80104095:	89 e5                	mov    %esp,%ebp
80104097:	53                   	push   %ebx
80104098:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010409b:	68 20 3d 11 80       	push   $0x80113d20
801040a0:	e8 9b 06 00 00       	call   80104740 <acquire>
  pushcli();
801040a5:	e8 96 05 00 00       	call   80104640 <pushcli>
  c = mycpu();
801040aa:	e8 91 f9 ff ff       	call   80103a40 <mycpu>
  p = c->proc;
801040af:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040b5:	e8 d6 05 00 00       	call   80104690 <popcli>
  myproc()->state = RUNNABLE;
801040ba:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040c1:	e8 aa fd ff ff       	call   80103e70 <sched>
  release(&ptable.lock);
801040c6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801040cd:	e8 2e 07 00 00       	call   80104800 <release>
}
801040d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d5:	83 c4 10             	add    $0x10,%esp
801040d8:	c9                   	leave  
801040d9:	c3                   	ret    
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040e0 <sleep>:
{
801040e0:	f3 0f 1e fb          	endbr32 
801040e4:	55                   	push   %ebp
801040e5:	89 e5                	mov    %esp,%ebp
801040e7:	57                   	push   %edi
801040e8:	56                   	push   %esi
801040e9:	53                   	push   %ebx
801040ea:	83 ec 0c             	sub    $0xc,%esp
801040ed:	8b 7d 08             	mov    0x8(%ebp),%edi
801040f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801040f3:	e8 48 05 00 00       	call   80104640 <pushcli>
  c = mycpu();
801040f8:	e8 43 f9 ff ff       	call   80103a40 <mycpu>
  p = c->proc;
801040fd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104103:	e8 88 05 00 00       	call   80104690 <popcli>
  if(p == 0)
80104108:	85 db                	test   %ebx,%ebx
8010410a:	0f 84 83 00 00 00    	je     80104193 <sleep+0xb3>
  if(lk == 0)
80104110:	85 f6                	test   %esi,%esi
80104112:	74 72                	je     80104186 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104114:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010411a:	74 4c                	je     80104168 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010411c:	83 ec 0c             	sub    $0xc,%esp
8010411f:	68 20 3d 11 80       	push   $0x80113d20
80104124:	e8 17 06 00 00       	call   80104740 <acquire>
    release(lk);
80104129:	89 34 24             	mov    %esi,(%esp)
8010412c:	e8 cf 06 00 00       	call   80104800 <release>
  p->chan = chan;
80104131:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104134:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010413b:	e8 30 fd ff ff       	call   80103e70 <sched>
  p->chan = 0;
80104140:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104147:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010414e:	e8 ad 06 00 00       	call   80104800 <release>
    acquire(lk);
80104153:	89 75 08             	mov    %esi,0x8(%ebp)
80104156:	83 c4 10             	add    $0x10,%esp
}
80104159:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415c:	5b                   	pop    %ebx
8010415d:	5e                   	pop    %esi
8010415e:	5f                   	pop    %edi
8010415f:	5d                   	pop    %ebp
    acquire(lk);
80104160:	e9 db 05 00 00       	jmp    80104740 <acquire>
80104165:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104168:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010416b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104172:	e8 f9 fc ff ff       	call   80103e70 <sched>
  p->chan = 0;
80104177:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010417e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104181:	5b                   	pop    %ebx
80104182:	5e                   	pop    %esi
80104183:	5f                   	pop    %edi
80104184:	5d                   	pop    %ebp
80104185:	c3                   	ret    
    panic("sleep without lk");
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	68 f0 81 10 80       	push   $0x801081f0
8010418e:	e8 fd c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104193:	83 ec 0c             	sub    $0xc,%esp
80104196:	68 ea 81 10 80       	push   $0x801081ea
8010419b:	e8 f0 c1 ff ff       	call   80100390 <panic>

801041a0 <wait>:
{
801041a0:	f3 0f 1e fb          	endbr32 
801041a4:	55                   	push   %ebp
801041a5:	89 e5                	mov    %esp,%ebp
801041a7:	56                   	push   %esi
801041a8:	53                   	push   %ebx
  pushcli();
801041a9:	e8 92 04 00 00       	call   80104640 <pushcli>
  c = mycpu();
801041ae:	e8 8d f8 ff ff       	call   80103a40 <mycpu>
  p = c->proc;
801041b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041b9:	e8 d2 04 00 00       	call   80104690 <popcli>
  acquire(&ptable.lock);
801041be:	83 ec 0c             	sub    $0xc,%esp
801041c1:	68 20 3d 11 80       	push   $0x80113d20
801041c6:	e8 75 05 00 00       	call   80104740 <acquire>
801041cb:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801041ce:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041d0:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
801041d5:	eb 17                	jmp    801041ee <wait+0x4e>
801041d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041de:	66 90                	xchg   %ax,%ax
801041e0:	81 c3 ec 00 00 00    	add    $0xec,%ebx
801041e6:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
801041ec:	74 1e                	je     8010420c <wait+0x6c>
      if(p->parent != curproc)
801041ee:	39 73 14             	cmp    %esi,0x14(%ebx)
801041f1:	75 ed                	jne    801041e0 <wait+0x40>
      if(p->state == ZOMBIE){
801041f3:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801041f7:	74 37                	je     80104230 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041f9:	81 c3 ec 00 00 00    	add    $0xec,%ebx
      havekids = 1;
801041ff:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104204:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
8010420a:	75 e2                	jne    801041ee <wait+0x4e>
    if(!havekids || curproc->killed){
8010420c:	85 c0                	test   %eax,%eax
8010420e:	74 76                	je     80104286 <wait+0xe6>
80104210:	8b 46 24             	mov    0x24(%esi),%eax
80104213:	85 c0                	test   %eax,%eax
80104215:	75 6f                	jne    80104286 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104217:	83 ec 08             	sub    $0x8,%esp
8010421a:	68 20 3d 11 80       	push   $0x80113d20
8010421f:	56                   	push   %esi
80104220:	e8 bb fe ff ff       	call   801040e0 <sleep>
    havekids = 0;
80104225:	83 c4 10             	add    $0x10,%esp
80104228:	eb a4                	jmp    801041ce <wait+0x2e>
8010422a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104230:	83 ec 0c             	sub    $0xc,%esp
80104233:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104236:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104239:	e8 42 e2 ff ff       	call   80102480 <kfree>
        freevm(p->pgdir);
8010423e:	5a                   	pop    %edx
8010423f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104242:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104249:	e8 22 36 00 00       	call   80107870 <freevm>
        release(&ptable.lock);
8010424e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
80104255:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010425c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104263:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104267:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010426e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104275:	e8 86 05 00 00       	call   80104800 <release>
        return pid;
8010427a:	83 c4 10             	add    $0x10,%esp
}
8010427d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104280:	89 f0                	mov    %esi,%eax
80104282:	5b                   	pop    %ebx
80104283:	5e                   	pop    %esi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
      release(&ptable.lock);
80104286:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104289:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010428e:	68 20 3d 11 80       	push   $0x80113d20
80104293:	e8 68 05 00 00       	call   80104800 <release>
      return -1;
80104298:	83 c4 10             	add    $0x10,%esp
8010429b:	eb e0                	jmp    8010427d <wait+0xdd>
8010429d:	8d 76 00             	lea    0x0(%esi),%esi

801042a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042a0:	f3 0f 1e fb          	endbr32 
801042a4:	55                   	push   %ebp
801042a5:	89 e5                	mov    %esp,%ebp
801042a7:	53                   	push   %ebx
801042a8:	83 ec 10             	sub    $0x10,%esp
801042ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042ae:	68 20 3d 11 80       	push   $0x80113d20
801042b3:	e8 88 04 00 00       	call   80104740 <acquire>
801042b8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042bb:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801042c0:	eb 12                	jmp    801042d4 <wakeup+0x34>
801042c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801042c8:	05 ec 00 00 00       	add    $0xec,%eax
801042cd:	3d 54 78 11 80       	cmp    $0x80117854,%eax
801042d2:	74 1e                	je     801042f2 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
801042d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042d8:	75 ee                	jne    801042c8 <wakeup+0x28>
801042da:	3b 58 20             	cmp    0x20(%eax),%ebx
801042dd:	75 e9                	jne    801042c8 <wakeup+0x28>
      p->state = RUNNABLE;
801042df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042e6:	05 ec 00 00 00       	add    $0xec,%eax
801042eb:	3d 54 78 11 80       	cmp    $0x80117854,%eax
801042f0:	75 e2                	jne    801042d4 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
801042f2:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
801042f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042fc:	c9                   	leave  
  release(&ptable.lock);
801042fd:	e9 fe 04 00 00       	jmp    80104800 <release>
80104302:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104310 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	53                   	push   %ebx
80104318:	83 ec 10             	sub    $0x10,%esp
8010431b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010431e:	68 20 3d 11 80       	push   $0x80113d20
80104323:	e8 18 04 00 00       	call   80104740 <acquire>
80104328:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010432b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104330:	eb 12                	jmp    80104344 <kill+0x34>
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104338:	05 ec 00 00 00       	add    $0xec,%eax
8010433d:	3d 54 78 11 80       	cmp    $0x80117854,%eax
80104342:	74 34                	je     80104378 <kill+0x68>
    if(p->pid == pid){
80104344:	39 58 10             	cmp    %ebx,0x10(%eax)
80104347:	75 ef                	jne    80104338 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104349:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
8010434d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104354:	75 07                	jne    8010435d <kill+0x4d>
        p->state = RUNNABLE;
80104356:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
8010435d:	83 ec 0c             	sub    $0xc,%esp
80104360:	68 20 3d 11 80       	push   $0x80113d20
80104365:	e8 96 04 00 00       	call   80104800 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010436a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
8010436d:	83 c4 10             	add    $0x10,%esp
80104370:	31 c0                	xor    %eax,%eax
}
80104372:	c9                   	leave  
80104373:	c3                   	ret    
80104374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104378:	83 ec 0c             	sub    $0xc,%esp
8010437b:	68 20 3d 11 80       	push   $0x80113d20
80104380:	e8 7b 04 00 00       	call   80104800 <release>
}
80104385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104390:	c9                   	leave  
80104391:	c3                   	ret    
80104392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	57                   	push   %edi
801043a8:	56                   	push   %esi
801043a9:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043ac:	53                   	push   %ebx
801043ad:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801043b2:	83 ec 3c             	sub    $0x3c,%esp
801043b5:	eb 2b                	jmp    801043e2 <procdump+0x42>
801043b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043be:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	68 7f 86 10 80       	push   $0x8010867f
801043c8:	e8 e3 c2 ff ff       	call   801006b0 <cprintf>
801043cd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043d0:	81 c3 ec 00 00 00    	add    $0xec,%ebx
801043d6:	81 fb c0 78 11 80    	cmp    $0x801178c0,%ebx
801043dc:	0f 84 8e 00 00 00    	je     80104470 <procdump+0xd0>
    if(p->state == UNUSED)
801043e2:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043e5:	85 c0                	test   %eax,%eax
801043e7:	74 e7                	je     801043d0 <procdump+0x30>
      state = "???";
801043e9:	ba 01 82 10 80       	mov    $0x80108201,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043ee:	83 f8 05             	cmp    $0x5,%eax
801043f1:	77 11                	ja     80104404 <procdump+0x64>
801043f3:	8b 14 85 38 82 10 80 	mov    -0x7fef7dc8(,%eax,4),%edx
      state = "???";
801043fa:	b8 01 82 10 80       	mov    $0x80108201,%eax
801043ff:	85 d2                	test   %edx,%edx
80104401:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104404:	53                   	push   %ebx
80104405:	52                   	push   %edx
80104406:	ff 73 a4             	pushl  -0x5c(%ebx)
80104409:	68 05 82 10 80       	push   $0x80108205
8010440e:	e8 9d c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104413:	83 c4 10             	add    $0x10,%esp
80104416:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010441a:	75 a4                	jne    801043c0 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010441c:	83 ec 08             	sub    $0x8,%esp
8010441f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104422:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104425:	50                   	push   %eax
80104426:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104429:	8b 40 0c             	mov    0xc(%eax),%eax
8010442c:	83 c0 08             	add    $0x8,%eax
8010442f:	50                   	push   %eax
80104430:	e8 ab 01 00 00       	call   801045e0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104435:	83 c4 10             	add    $0x10,%esp
80104438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010443f:	90                   	nop
80104440:	8b 17                	mov    (%edi),%edx
80104442:	85 d2                	test   %edx,%edx
80104444:	0f 84 76 ff ff ff    	je     801043c0 <procdump+0x20>
        cprintf(" %p", pc[i]);
8010444a:	83 ec 08             	sub    $0x8,%esp
8010444d:	83 c7 04             	add    $0x4,%edi
80104450:	52                   	push   %edx
80104451:	68 c1 7b 10 80       	push   $0x80107bc1
80104456:	e8 55 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
8010445b:	83 c4 10             	add    $0x10,%esp
8010445e:	39 fe                	cmp    %edi,%esi
80104460:	75 de                	jne    80104440 <procdump+0xa0>
80104462:	e9 59 ff ff ff       	jmp    801043c0 <procdump+0x20>
80104467:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010446e:	66 90                	xchg   %ax,%ax
  }
}
80104470:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104473:	5b                   	pop    %ebx
80104474:	5e                   	pop    %esi
80104475:	5f                   	pop    %edi
80104476:	5d                   	pop    %ebp
80104477:	c3                   	ret    
80104478:	66 90                	xchg   %ax,%ax
8010447a:	66 90                	xchg   %ax,%ax
8010447c:	66 90                	xchg   %ax,%ax
8010447e:	66 90                	xchg   %ax,%ax

80104480 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104480:	f3 0f 1e fb          	endbr32 
80104484:	55                   	push   %ebp
80104485:	89 e5                	mov    %esp,%ebp
80104487:	53                   	push   %ebx
80104488:	83 ec 0c             	sub    $0xc,%esp
8010448b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010448e:	68 50 82 10 80       	push   $0x80108250
80104493:	8d 43 04             	lea    0x4(%ebx),%eax
80104496:	50                   	push   %eax
80104497:	e8 24 01 00 00       	call   801045c0 <initlock>
  lk->name = name;
8010449c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010449f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801044a5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801044a8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801044af:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b5:	c9                   	leave  
801044b6:	c3                   	ret    
801044b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044be:	66 90                	xchg   %ax,%ax

801044c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	56                   	push   %esi
801044c8:	53                   	push   %ebx
801044c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044cc:	8d 73 04             	lea    0x4(%ebx),%esi
801044cf:	83 ec 0c             	sub    $0xc,%esp
801044d2:	56                   	push   %esi
801044d3:	e8 68 02 00 00       	call   80104740 <acquire>
  while (lk->locked) {
801044d8:	8b 13                	mov    (%ebx),%edx
801044da:	83 c4 10             	add    $0x10,%esp
801044dd:	85 d2                	test   %edx,%edx
801044df:	74 1a                	je     801044fb <acquiresleep+0x3b>
801044e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801044e8:	83 ec 08             	sub    $0x8,%esp
801044eb:	56                   	push   %esi
801044ec:	53                   	push   %ebx
801044ed:	e8 ee fb ff ff       	call   801040e0 <sleep>
  while (lk->locked) {
801044f2:	8b 03                	mov    (%ebx),%eax
801044f4:	83 c4 10             	add    $0x10,%esp
801044f7:	85 c0                	test   %eax,%eax
801044f9:	75 ed                	jne    801044e8 <acquiresleep+0x28>
  }
  lk->locked = 1;
801044fb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104501:	e8 ca f5 ff ff       	call   80103ad0 <myproc>
80104506:	8b 40 10             	mov    0x10(%eax),%eax
80104509:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010450c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010450f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104512:	5b                   	pop    %ebx
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
  release(&lk->lk);
80104515:	e9 e6 02 00 00       	jmp    80104800 <release>
8010451a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104520 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104520:	f3 0f 1e fb          	endbr32 
80104524:	55                   	push   %ebp
80104525:	89 e5                	mov    %esp,%ebp
80104527:	56                   	push   %esi
80104528:	53                   	push   %ebx
80104529:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010452c:	8d 73 04             	lea    0x4(%ebx),%esi
8010452f:	83 ec 0c             	sub    $0xc,%esp
80104532:	56                   	push   %esi
80104533:	e8 08 02 00 00       	call   80104740 <acquire>
  lk->locked = 0;
80104538:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010453e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104545:	89 1c 24             	mov    %ebx,(%esp)
80104548:	e8 53 fd ff ff       	call   801042a0 <wakeup>
  release(&lk->lk);
8010454d:	89 75 08             	mov    %esi,0x8(%ebp)
80104550:	83 c4 10             	add    $0x10,%esp
}
80104553:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104556:	5b                   	pop    %ebx
80104557:	5e                   	pop    %esi
80104558:	5d                   	pop    %ebp
  release(&lk->lk);
80104559:	e9 a2 02 00 00       	jmp    80104800 <release>
8010455e:	66 90                	xchg   %ax,%ax

80104560 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104560:	f3 0f 1e fb          	endbr32 
80104564:	55                   	push   %ebp
80104565:	89 e5                	mov    %esp,%ebp
80104567:	57                   	push   %edi
80104568:	31 ff                	xor    %edi,%edi
8010456a:	56                   	push   %esi
8010456b:	53                   	push   %ebx
8010456c:	83 ec 18             	sub    $0x18,%esp
8010456f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104572:	8d 73 04             	lea    0x4(%ebx),%esi
80104575:	56                   	push   %esi
80104576:	e8 c5 01 00 00       	call   80104740 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
8010457b:	8b 03                	mov    (%ebx),%eax
8010457d:	83 c4 10             	add    $0x10,%esp
80104580:	85 c0                	test   %eax,%eax
80104582:	75 1c                	jne    801045a0 <holdingsleep+0x40>
  release(&lk->lk);
80104584:	83 ec 0c             	sub    $0xc,%esp
80104587:	56                   	push   %esi
80104588:	e8 73 02 00 00       	call   80104800 <release>
  return r;
}
8010458d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104590:	89 f8                	mov    %edi,%eax
80104592:	5b                   	pop    %ebx
80104593:	5e                   	pop    %esi
80104594:	5f                   	pop    %edi
80104595:	5d                   	pop    %ebp
80104596:	c3                   	ret    
80104597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010459e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
801045a0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801045a3:	e8 28 f5 ff ff       	call   80103ad0 <myproc>
801045a8:	39 58 10             	cmp    %ebx,0x10(%eax)
801045ab:	0f 94 c0             	sete   %al
801045ae:	0f b6 c0             	movzbl %al,%eax
801045b1:	89 c7                	mov    %eax,%edi
801045b3:	eb cf                	jmp    80104584 <holdingsleep+0x24>
801045b5:	66 90                	xchg   %ax,%ax
801045b7:	66 90                	xchg   %ax,%ax
801045b9:	66 90                	xchg   %ax,%ax
801045bb:	66 90                	xchg   %ax,%ax
801045bd:	66 90                	xchg   %ax,%ax
801045bf:	90                   	nop

801045c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045d3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045dd:	5d                   	pop    %ebp
801045de:	c3                   	ret    
801045df:	90                   	nop

801045e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045e0:	f3 0f 1e fb          	endbr32 
801045e4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801045e5:	31 d2                	xor    %edx,%edx
{
801045e7:	89 e5                	mov    %esp,%ebp
801045e9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045ea:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801045f0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045f8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801045fe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104604:	77 1a                	ja     80104620 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104606:	8b 58 04             	mov    0x4(%eax),%ebx
80104609:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010460c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010460f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104611:	83 fa 0a             	cmp    $0xa,%edx
80104614:	75 e2                	jne    801045f8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104616:	5b                   	pop    %ebx
80104617:	5d                   	pop    %ebp
80104618:	c3                   	ret    
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104620:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104623:	8d 51 28             	lea    0x28(%ecx),%edx
80104626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104630:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104636:	83 c0 04             	add    $0x4,%eax
80104639:	39 d0                	cmp    %edx,%eax
8010463b:	75 f3                	jne    80104630 <getcallerpcs+0x50>
}
8010463d:	5b                   	pop    %ebx
8010463e:	5d                   	pop    %ebp
8010463f:	c3                   	ret    

80104640 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104640:	f3 0f 1e fb          	endbr32 
80104644:	55                   	push   %ebp
80104645:	89 e5                	mov    %esp,%ebp
80104647:	53                   	push   %ebx
80104648:	83 ec 04             	sub    $0x4,%esp
8010464b:	9c                   	pushf  
8010464c:	5b                   	pop    %ebx
  asm volatile("cli");
8010464d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010464e:	e8 ed f3 ff ff       	call   80103a40 <mycpu>
80104653:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104659:	85 c0                	test   %eax,%eax
8010465b:	74 13                	je     80104670 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
8010465d:	e8 de f3 ff ff       	call   80103a40 <mycpu>
80104662:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104669:	83 c4 04             	add    $0x4,%esp
8010466c:	5b                   	pop    %ebx
8010466d:	5d                   	pop    %ebp
8010466e:	c3                   	ret    
8010466f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104670:	e8 cb f3 ff ff       	call   80103a40 <mycpu>
80104675:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010467b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104681:	eb da                	jmp    8010465d <pushcli+0x1d>
80104683:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104690 <popcli>:

void
popcli(void)
{
80104690:	f3 0f 1e fb          	endbr32 
80104694:	55                   	push   %ebp
80104695:	89 e5                	mov    %esp,%ebp
80104697:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010469a:	9c                   	pushf  
8010469b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010469c:	f6 c4 02             	test   $0x2,%ah
8010469f:	75 31                	jne    801046d2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801046a1:	e8 9a f3 ff ff       	call   80103a40 <mycpu>
801046a6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801046ad:	78 30                	js     801046df <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046af:	e8 8c f3 ff ff       	call   80103a40 <mycpu>
801046b4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046ba:	85 d2                	test   %edx,%edx
801046bc:	74 02                	je     801046c0 <popcli+0x30>
    sti();
}
801046be:	c9                   	leave  
801046bf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046c0:	e8 7b f3 ff ff       	call   80103a40 <mycpu>
801046c5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046cb:	85 c0                	test   %eax,%eax
801046cd:	74 ef                	je     801046be <popcli+0x2e>
  asm volatile("sti");
801046cf:	fb                   	sti    
}
801046d0:	c9                   	leave  
801046d1:	c3                   	ret    
    panic("popcli - interruptible");
801046d2:	83 ec 0c             	sub    $0xc,%esp
801046d5:	68 5b 82 10 80       	push   $0x8010825b
801046da:	e8 b1 bc ff ff       	call   80100390 <panic>
    panic("popcli");
801046df:	83 ec 0c             	sub    $0xc,%esp
801046e2:	68 72 82 10 80       	push   $0x80108272
801046e7:	e8 a4 bc ff ff       	call   80100390 <panic>
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046f0 <holding>:
{
801046f0:	f3 0f 1e fb          	endbr32 
801046f4:	55                   	push   %ebp
801046f5:	89 e5                	mov    %esp,%ebp
801046f7:	56                   	push   %esi
801046f8:	53                   	push   %ebx
801046f9:	8b 75 08             	mov    0x8(%ebp),%esi
801046fc:	31 db                	xor    %ebx,%ebx
  pushcli();
801046fe:	e8 3d ff ff ff       	call   80104640 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104703:	8b 06                	mov    (%esi),%eax
80104705:	85 c0                	test   %eax,%eax
80104707:	75 0f                	jne    80104718 <holding+0x28>
  popcli();
80104709:	e8 82 ff ff ff       	call   80104690 <popcli>
}
8010470e:	89 d8                	mov    %ebx,%eax
80104710:	5b                   	pop    %ebx
80104711:	5e                   	pop    %esi
80104712:	5d                   	pop    %ebp
80104713:	c3                   	ret    
80104714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104718:	8b 5e 08             	mov    0x8(%esi),%ebx
8010471b:	e8 20 f3 ff ff       	call   80103a40 <mycpu>
80104720:	39 c3                	cmp    %eax,%ebx
80104722:	0f 94 c3             	sete   %bl
  popcli();
80104725:	e8 66 ff ff ff       	call   80104690 <popcli>
  r = lock->locked && lock->cpu == mycpu();
8010472a:	0f b6 db             	movzbl %bl,%ebx
}
8010472d:	89 d8                	mov    %ebx,%eax
8010472f:	5b                   	pop    %ebx
80104730:	5e                   	pop    %esi
80104731:	5d                   	pop    %ebp
80104732:	c3                   	ret    
80104733:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104740 <acquire>:
{
80104740:	f3 0f 1e fb          	endbr32 
80104744:	55                   	push   %ebp
80104745:	89 e5                	mov    %esp,%ebp
80104747:	56                   	push   %esi
80104748:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104749:	e8 f2 fe ff ff       	call   80104640 <pushcli>
  if(holding(lk))
8010474e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104751:	83 ec 0c             	sub    $0xc,%esp
80104754:	53                   	push   %ebx
80104755:	e8 96 ff ff ff       	call   801046f0 <holding>
8010475a:	83 c4 10             	add    $0x10,%esp
8010475d:	85 c0                	test   %eax,%eax
8010475f:	0f 85 7f 00 00 00    	jne    801047e4 <acquire+0xa4>
80104765:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104767:	ba 01 00 00 00       	mov    $0x1,%edx
8010476c:	eb 05                	jmp    80104773 <acquire+0x33>
8010476e:	66 90                	xchg   %ax,%ax
80104770:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104773:	89 d0                	mov    %edx,%eax
80104775:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104778:	85 c0                	test   %eax,%eax
8010477a:	75 f4                	jne    80104770 <acquire+0x30>
  __sync_synchronize();
8010477c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104781:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104784:	e8 b7 f2 ff ff       	call   80103a40 <mycpu>
80104789:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010478c:	89 e8                	mov    %ebp,%eax
8010478e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104790:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104796:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010479c:	77 22                	ja     801047c0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010479e:	8b 50 04             	mov    0x4(%eax),%edx
801047a1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
801047a5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801047a8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047aa:	83 fe 0a             	cmp    $0xa,%esi
801047ad:	75 e1                	jne    80104790 <acquire+0x50>
}
801047af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047b2:	5b                   	pop    %ebx
801047b3:	5e                   	pop    %esi
801047b4:	5d                   	pop    %ebp
801047b5:	c3                   	ret    
801047b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
801047c0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
801047c4:	83 c3 34             	add    $0x34,%ebx
801047c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ce:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047d6:	83 c0 04             	add    $0x4,%eax
801047d9:	39 d8                	cmp    %ebx,%eax
801047db:	75 f3                	jne    801047d0 <acquire+0x90>
}
801047dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047e0:	5b                   	pop    %ebx
801047e1:	5e                   	pop    %esi
801047e2:	5d                   	pop    %ebp
801047e3:	c3                   	ret    
    panic("acquire");
801047e4:	83 ec 0c             	sub    $0xc,%esp
801047e7:	68 79 82 10 80       	push   $0x80108279
801047ec:	e8 9f bb ff ff       	call   80100390 <panic>
801047f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047ff:	90                   	nop

80104800 <release>:
{
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	53                   	push   %ebx
80104808:	83 ec 10             	sub    $0x10,%esp
8010480b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010480e:	53                   	push   %ebx
8010480f:	e8 dc fe ff ff       	call   801046f0 <holding>
80104814:	83 c4 10             	add    $0x10,%esp
80104817:	85 c0                	test   %eax,%eax
80104819:	74 22                	je     8010483d <release+0x3d>
  lk->pcs[0] = 0;
8010481b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104822:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104829:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010482e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104834:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104837:	c9                   	leave  
  popcli();
80104838:	e9 53 fe ff ff       	jmp    80104690 <popcli>
    panic("release");
8010483d:	83 ec 0c             	sub    $0xc,%esp
80104840:	68 81 82 10 80       	push   $0x80108281
80104845:	e8 46 bb ff ff       	call   80100390 <panic>
8010484a:	66 90                	xchg   %ax,%ax
8010484c:	66 90                	xchg   %ax,%ax
8010484e:	66 90                	xchg   %ax,%ax

80104850 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104850:	f3 0f 1e fb          	endbr32 
80104854:	55                   	push   %ebp
80104855:	89 e5                	mov    %esp,%ebp
80104857:	57                   	push   %edi
80104858:	8b 55 08             	mov    0x8(%ebp),%edx
8010485b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010485e:	53                   	push   %ebx
8010485f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104862:	89 d7                	mov    %edx,%edi
80104864:	09 cf                	or     %ecx,%edi
80104866:	83 e7 03             	and    $0x3,%edi
80104869:	75 25                	jne    80104890 <memset+0x40>
    c &= 0xFF;
8010486b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010486e:	c1 e0 18             	shl    $0x18,%eax
80104871:	89 fb                	mov    %edi,%ebx
80104873:	c1 e9 02             	shr    $0x2,%ecx
80104876:	c1 e3 10             	shl    $0x10,%ebx
80104879:	09 d8                	or     %ebx,%eax
8010487b:	09 f8                	or     %edi,%eax
8010487d:	c1 e7 08             	shl    $0x8,%edi
80104880:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104882:	89 d7                	mov    %edx,%edi
80104884:	fc                   	cld    
80104885:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104887:	5b                   	pop    %ebx
80104888:	89 d0                	mov    %edx,%eax
8010488a:	5f                   	pop    %edi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104890:	89 d7                	mov    %edx,%edi
80104892:	fc                   	cld    
80104893:	f3 aa                	rep stos %al,%es:(%edi)
80104895:	5b                   	pop    %ebx
80104896:	89 d0                	mov    %edx,%eax
80104898:	5f                   	pop    %edi
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    
8010489b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop

801048a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048a0:	f3 0f 1e fb          	endbr32 
801048a4:	55                   	push   %ebp
801048a5:	89 e5                	mov    %esp,%ebp
801048a7:	56                   	push   %esi
801048a8:	8b 75 10             	mov    0x10(%ebp),%esi
801048ab:	8b 55 08             	mov    0x8(%ebp),%edx
801048ae:	53                   	push   %ebx
801048af:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048b2:	85 f6                	test   %esi,%esi
801048b4:	74 2a                	je     801048e0 <memcmp+0x40>
801048b6:	01 c6                	add    %eax,%esi
801048b8:	eb 10                	jmp    801048ca <memcmp+0x2a>
801048ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048c0:	83 c0 01             	add    $0x1,%eax
801048c3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048c6:	39 f0                	cmp    %esi,%eax
801048c8:	74 16                	je     801048e0 <memcmp+0x40>
    if(*s1 != *s2)
801048ca:	0f b6 0a             	movzbl (%edx),%ecx
801048cd:	0f b6 18             	movzbl (%eax),%ebx
801048d0:	38 d9                	cmp    %bl,%cl
801048d2:	74 ec                	je     801048c0 <memcmp+0x20>
      return *s1 - *s2;
801048d4:	0f b6 c1             	movzbl %cl,%eax
801048d7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048d9:	5b                   	pop    %ebx
801048da:	5e                   	pop    %esi
801048db:	5d                   	pop    %ebp
801048dc:	c3                   	ret    
801048dd:	8d 76 00             	lea    0x0(%esi),%esi
801048e0:	5b                   	pop    %ebx
  return 0;
801048e1:	31 c0                	xor    %eax,%eax
}
801048e3:	5e                   	pop    %esi
801048e4:	5d                   	pop    %ebp
801048e5:	c3                   	ret    
801048e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048ed:	8d 76 00             	lea    0x0(%esi),%esi

801048f0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801048f0:	f3 0f 1e fb          	endbr32 
801048f4:	55                   	push   %ebp
801048f5:	89 e5                	mov    %esp,%ebp
801048f7:	57                   	push   %edi
801048f8:	8b 55 08             	mov    0x8(%ebp),%edx
801048fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801048fe:	56                   	push   %esi
801048ff:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104902:	39 d6                	cmp    %edx,%esi
80104904:	73 2a                	jae    80104930 <memmove+0x40>
80104906:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104909:	39 fa                	cmp    %edi,%edx
8010490b:	73 23                	jae    80104930 <memmove+0x40>
8010490d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104910:	85 c9                	test   %ecx,%ecx
80104912:	74 13                	je     80104927 <memmove+0x37>
80104914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104918:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010491c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010491f:	83 e8 01             	sub    $0x1,%eax
80104922:	83 f8 ff             	cmp    $0xffffffff,%eax
80104925:	75 f1                	jne    80104918 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104927:	5e                   	pop    %esi
80104928:	89 d0                	mov    %edx,%eax
8010492a:	5f                   	pop    %edi
8010492b:	5d                   	pop    %ebp
8010492c:	c3                   	ret    
8010492d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104930:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104933:	89 d7                	mov    %edx,%edi
80104935:	85 c9                	test   %ecx,%ecx
80104937:	74 ee                	je     80104927 <memmove+0x37>
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104940:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104941:	39 f0                	cmp    %esi,%eax
80104943:	75 fb                	jne    80104940 <memmove+0x50>
}
80104945:	5e                   	pop    %esi
80104946:	89 d0                	mov    %edx,%eax
80104948:	5f                   	pop    %edi
80104949:	5d                   	pop    %ebp
8010494a:	c3                   	ret    
8010494b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop

80104950 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104950:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104954:	eb 9a                	jmp    801048f0 <memmove>
80104956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010495d:	8d 76 00             	lea    0x0(%esi),%esi

80104960 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104960:	f3 0f 1e fb          	endbr32 
80104964:	55                   	push   %ebp
80104965:	89 e5                	mov    %esp,%ebp
80104967:	56                   	push   %esi
80104968:	8b 75 10             	mov    0x10(%ebp),%esi
8010496b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010496e:	53                   	push   %ebx
8010496f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104972:	85 f6                	test   %esi,%esi
80104974:	74 32                	je     801049a8 <strncmp+0x48>
80104976:	01 c6                	add    %eax,%esi
80104978:	eb 14                	jmp    8010498e <strncmp+0x2e>
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104980:	38 da                	cmp    %bl,%dl
80104982:	75 14                	jne    80104998 <strncmp+0x38>
    n--, p++, q++;
80104984:	83 c0 01             	add    $0x1,%eax
80104987:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010498a:	39 f0                	cmp    %esi,%eax
8010498c:	74 1a                	je     801049a8 <strncmp+0x48>
8010498e:	0f b6 11             	movzbl (%ecx),%edx
80104991:	0f b6 18             	movzbl (%eax),%ebx
80104994:	84 d2                	test   %dl,%dl
80104996:	75 e8                	jne    80104980 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104998:	0f b6 c2             	movzbl %dl,%eax
8010499b:	29 d8                	sub    %ebx,%eax
}
8010499d:	5b                   	pop    %ebx
8010499e:	5e                   	pop    %esi
8010499f:	5d                   	pop    %ebp
801049a0:	c3                   	ret    
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	5b                   	pop    %ebx
    return 0;
801049a9:	31 c0                	xor    %eax,%eax
}
801049ab:	5e                   	pop    %esi
801049ac:	5d                   	pop    %ebp
801049ad:	c3                   	ret    
801049ae:	66 90                	xchg   %ax,%ax

801049b0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	57                   	push   %edi
801049b8:	56                   	push   %esi
801049b9:	8b 75 08             	mov    0x8(%ebp),%esi
801049bc:	53                   	push   %ebx
801049bd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049c0:	89 f2                	mov    %esi,%edx
801049c2:	eb 1b                	jmp    801049df <strncpy+0x2f>
801049c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049cf:	83 c2 01             	add    $0x1,%edx
801049d2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801049d6:	89 f9                	mov    %edi,%ecx
801049d8:	88 4a ff             	mov    %cl,-0x1(%edx)
801049db:	84 c9                	test   %cl,%cl
801049dd:	74 09                	je     801049e8 <strncpy+0x38>
801049df:	89 c3                	mov    %eax,%ebx
801049e1:	83 e8 01             	sub    $0x1,%eax
801049e4:	85 db                	test   %ebx,%ebx
801049e6:	7f e0                	jg     801049c8 <strncpy+0x18>
    ;
  while(n-- > 0)
801049e8:	89 d1                	mov    %edx,%ecx
801049ea:	85 c0                	test   %eax,%eax
801049ec:	7e 15                	jle    80104a03 <strncpy+0x53>
801049ee:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801049f0:	83 c1 01             	add    $0x1,%ecx
801049f3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801049f7:	89 c8                	mov    %ecx,%eax
801049f9:	f7 d0                	not    %eax
801049fb:	01 d0                	add    %edx,%eax
801049fd:	01 d8                	add    %ebx,%eax
801049ff:	85 c0                	test   %eax,%eax
80104a01:	7f ed                	jg     801049f0 <strncpy+0x40>
  return os;
}
80104a03:	5b                   	pop    %ebx
80104a04:	89 f0                	mov    %esi,%eax
80104a06:	5e                   	pop    %esi
80104a07:	5f                   	pop    %edi
80104a08:	5d                   	pop    %ebp
80104a09:	c3                   	ret    
80104a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a10 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a10:	f3 0f 1e fb          	endbr32 
80104a14:	55                   	push   %ebp
80104a15:	89 e5                	mov    %esp,%ebp
80104a17:	56                   	push   %esi
80104a18:	8b 55 10             	mov    0x10(%ebp),%edx
80104a1b:	8b 75 08             	mov    0x8(%ebp),%esi
80104a1e:	53                   	push   %ebx
80104a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a22:	85 d2                	test   %edx,%edx
80104a24:	7e 21                	jle    80104a47 <safestrcpy+0x37>
80104a26:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a2a:	89 f2                	mov    %esi,%edx
80104a2c:	eb 12                	jmp    80104a40 <safestrcpy+0x30>
80104a2e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a30:	0f b6 08             	movzbl (%eax),%ecx
80104a33:	83 c0 01             	add    $0x1,%eax
80104a36:	83 c2 01             	add    $0x1,%edx
80104a39:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a3c:	84 c9                	test   %cl,%cl
80104a3e:	74 04                	je     80104a44 <safestrcpy+0x34>
80104a40:	39 d8                	cmp    %ebx,%eax
80104a42:	75 ec                	jne    80104a30 <safestrcpy+0x20>
    ;
  *s = 0;
80104a44:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a47:	89 f0                	mov    %esi,%eax
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret    
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi

80104a50 <strlen>:

int
strlen(const char *s)
{
80104a50:	f3 0f 1e fb          	endbr32 
80104a54:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a55:	31 c0                	xor    %eax,%eax
{
80104a57:	89 e5                	mov    %esp,%ebp
80104a59:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a5c:	80 3a 00             	cmpb   $0x0,(%edx)
80104a5f:	74 10                	je     80104a71 <strlen+0x21>
80104a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a68:	83 c0 01             	add    $0x1,%eax
80104a6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a6f:	75 f7                	jne    80104a68 <strlen+0x18>
    ;
  return n;
}
80104a71:	5d                   	pop    %ebp
80104a72:	c3                   	ret    

80104a73 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a73:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a77:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a7b:	55                   	push   %ebp
  pushl %ebx
80104a7c:	53                   	push   %ebx
  pushl %esi
80104a7d:	56                   	push   %esi
  pushl %edi
80104a7e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a7f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a81:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a83:	5f                   	pop    %edi
  popl %esi
80104a84:	5e                   	pop    %esi
  popl %ebx
80104a85:	5b                   	pop    %ebx
  popl %ebp
80104a86:	5d                   	pop    %ebp
  ret
80104a87:	c3                   	ret    
80104a88:	66 90                	xchg   %ax,%ax
80104a8a:	66 90                	xchg   %ax,%ax
80104a8c:	66 90                	xchg   %ax,%ax
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a90:	f3 0f 1e fb          	endbr32 
80104a94:	55                   	push   %ebp
80104a95:	89 e5                	mov    %esp,%ebp
80104a97:	53                   	push   %ebx
80104a98:	83 ec 04             	sub    $0x4,%esp
80104a9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a9e:	e8 2d f0 ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aa3:	8b 00                	mov    (%eax),%eax
80104aa5:	39 d8                	cmp    %ebx,%eax
80104aa7:	76 17                	jbe    80104ac0 <fetchint+0x30>
80104aa9:	8d 53 04             	lea    0x4(%ebx),%edx
80104aac:	39 d0                	cmp    %edx,%eax
80104aae:	72 10                	jb     80104ac0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104ab0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ab3:	8b 13                	mov    (%ebx),%edx
80104ab5:	89 10                	mov    %edx,(%eax)
  return 0;
80104ab7:	31 c0                	xor    %eax,%eax
}
80104ab9:	83 c4 04             	add    $0x4,%esp
80104abc:	5b                   	pop    %ebx
80104abd:	5d                   	pop    %ebp
80104abe:	c3                   	ret    
80104abf:	90                   	nop
    return -1;
80104ac0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ac5:	eb f2                	jmp    80104ab9 <fetchint+0x29>
80104ac7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ace:	66 90                	xchg   %ax,%ax

80104ad0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	53                   	push   %ebx
80104ad8:	83 ec 04             	sub    $0x4,%esp
80104adb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104ade:	e8 ed ef ff ff       	call   80103ad0 <myproc>

  if(addr >= curproc->sz)
80104ae3:	39 18                	cmp    %ebx,(%eax)
80104ae5:	76 31                	jbe    80104b18 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104ae7:	8b 55 0c             	mov    0xc(%ebp),%edx
80104aea:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104aec:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104aee:	39 d3                	cmp    %edx,%ebx
80104af0:	73 26                	jae    80104b18 <fetchstr+0x48>
80104af2:	89 d8                	mov    %ebx,%eax
80104af4:	eb 11                	jmp    80104b07 <fetchstr+0x37>
80104af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
80104b00:	83 c0 01             	add    $0x1,%eax
80104b03:	39 c2                	cmp    %eax,%edx
80104b05:	76 11                	jbe    80104b18 <fetchstr+0x48>
    if(*s == 0)
80104b07:	80 38 00             	cmpb   $0x0,(%eax)
80104b0a:	75 f4                	jne    80104b00 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104b0c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104b0f:	29 d8                	sub    %ebx,%eax
}
80104b11:	5b                   	pop    %ebx
80104b12:	5d                   	pop    %ebp
80104b13:	c3                   	ret    
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b18:	83 c4 04             	add    $0x4,%esp
    return -1;
80104b1b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b20:	5b                   	pop    %ebx
80104b21:	5d                   	pop    %ebp
80104b22:	c3                   	ret    
80104b23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b30:	f3 0f 1e fb          	endbr32 
80104b34:	55                   	push   %ebp
80104b35:	89 e5                	mov    %esp,%ebp
80104b37:	56                   	push   %esi
80104b38:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b39:	e8 92 ef ff ff       	call   80103ad0 <myproc>
80104b3e:	8b 55 08             	mov    0x8(%ebp),%edx
80104b41:	8b 40 18             	mov    0x18(%eax),%eax
80104b44:	8b 40 44             	mov    0x44(%eax),%eax
80104b47:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b4a:	e8 81 ef ff ff       	call   80103ad0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b4f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b52:	8b 00                	mov    (%eax),%eax
80104b54:	39 c6                	cmp    %eax,%esi
80104b56:	73 18                	jae    80104b70 <argint+0x40>
80104b58:	8d 53 08             	lea    0x8(%ebx),%edx
80104b5b:	39 d0                	cmp    %edx,%eax
80104b5d:	72 11                	jb     80104b70 <argint+0x40>
  *ip = *(int*)(addr);
80104b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b62:	8b 53 04             	mov    0x4(%ebx),%edx
80104b65:	89 10                	mov    %edx,(%eax)
  return 0;
80104b67:	31 c0                	xor    %eax,%eax
}
80104b69:	5b                   	pop    %ebx
80104b6a:	5e                   	pop    %esi
80104b6b:	5d                   	pop    %ebp
80104b6c:	c3                   	ret    
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b75:	eb f2                	jmp    80104b69 <argint+0x39>
80104b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7e:	66 90                	xchg   %ax,%ax

80104b80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	56                   	push   %esi
80104b88:	53                   	push   %ebx
80104b89:	83 ec 10             	sub    $0x10,%esp
80104b8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104b8f:	e8 3c ef ff ff       	call   80103ad0 <myproc>
 
  if(argint(n, &i) < 0)
80104b94:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104b97:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104b99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b9c:	50                   	push   %eax
80104b9d:	ff 75 08             	pushl  0x8(%ebp)
80104ba0:	e8 8b ff ff ff       	call   80104b30 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ba5:	83 c4 10             	add    $0x10,%esp
80104ba8:	85 c0                	test   %eax,%eax
80104baa:	78 24                	js     80104bd0 <argptr+0x50>
80104bac:	85 db                	test   %ebx,%ebx
80104bae:	78 20                	js     80104bd0 <argptr+0x50>
80104bb0:	8b 16                	mov    (%esi),%edx
80104bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bb5:	39 c2                	cmp    %eax,%edx
80104bb7:	76 17                	jbe    80104bd0 <argptr+0x50>
80104bb9:	01 c3                	add    %eax,%ebx
80104bbb:	39 da                	cmp    %ebx,%edx
80104bbd:	72 11                	jb     80104bd0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bc2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bc4:	31 c0                	xor    %eax,%eax
}
80104bc6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bc9:	5b                   	pop    %ebx
80104bca:	5e                   	pop    %esi
80104bcb:	5d                   	pop    %ebp
80104bcc:	c3                   	ret    
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd5:	eb ef                	jmp    80104bc6 <argptr+0x46>
80104bd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bde:	66 90                	xchg   %ax,%ax

80104be0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104bea:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bed:	50                   	push   %eax
80104bee:	ff 75 08             	pushl  0x8(%ebp)
80104bf1:	e8 3a ff ff ff       	call   80104b30 <argint>
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	85 c0                	test   %eax,%eax
80104bfb:	78 13                	js     80104c10 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104bfd:	83 ec 08             	sub    $0x8,%esp
80104c00:	ff 75 0c             	pushl  0xc(%ebp)
80104c03:	ff 75 f4             	pushl  -0xc(%ebp)
80104c06:	e8 c5 fe ff ff       	call   80104ad0 <fetchstr>
80104c0b:	83 c4 10             	add    $0x10,%esp
}
80104c0e:	c9                   	leave  
80104c0f:	c3                   	ret    
80104c10:	c9                   	leave  
    return -1;
80104c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c16:	c3                   	ret    
80104c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1e:	66 90                	xchg   %ax,%ax

80104c20 <syscall>:
[SYS_chpr]    sys_chpr,
};

void
syscall(void)
{
80104c20:	f3 0f 1e fb          	endbr32 
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	53                   	push   %ebx
80104c28:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c2b:	e8 a0 ee ff ff       	call   80103ad0 <myproc>
80104c30:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c32:	8b 40 18             	mov    0x18(%eax),%eax
80104c35:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c38:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c3b:	83 fa 1b             	cmp    $0x1b,%edx
80104c3e:	77 20                	ja     80104c60 <syscall+0x40>
80104c40:	8b 14 85 c0 82 10 80 	mov    -0x7fef7d40(,%eax,4),%edx
80104c47:	85 d2                	test   %edx,%edx
80104c49:	74 15                	je     80104c60 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c4b:	ff d2                	call   *%edx
80104c4d:	89 c2                	mov    %eax,%edx
80104c4f:	8b 43 18             	mov    0x18(%ebx),%eax
80104c52:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c58:	c9                   	leave  
80104c59:	c3                   	ret    
80104c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104c60:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104c61:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104c64:	50                   	push   %eax
80104c65:	ff 73 10             	pushl  0x10(%ebx)
80104c68:	68 89 82 10 80       	push   $0x80108289
80104c6d:	e8 3e ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104c72:	8b 43 18             	mov    0x18(%ebx),%eax
80104c75:	83 c4 10             	add    $0x10,%esp
80104c78:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104c7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c82:	c9                   	leave  
80104c83:	c3                   	ret    
80104c84:	66 90                	xchg   %ax,%ax
80104c86:	66 90                	xchg   %ax,%ax
80104c88:	66 90                	xchg   %ax,%ax
80104c8a:	66 90                	xchg   %ax,%ax
80104c8c:	66 90                	xchg   %ax,%ax
80104c8e:	66 90                	xchg   %ax,%ax

80104c90 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	57                   	push   %edi
80104c94:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c95:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104c98:	53                   	push   %ebx
80104c99:	83 ec 34             	sub    $0x34,%esp
80104c9c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ca2:	57                   	push   %edi
80104ca3:	50                   	push   %eax
{
80104ca4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ca7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104caa:	e8 b1 d3 ff ff       	call   80102060 <nameiparent>
80104caf:	83 c4 10             	add    $0x10,%esp
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	0f 84 46 01 00 00    	je     80104e00 <create+0x170>
    return 0;
  ilock(dp);
80104cba:	83 ec 0c             	sub    $0xc,%esp
80104cbd:	89 c3                	mov    %eax,%ebx
80104cbf:	50                   	push   %eax
80104cc0:	e8 ab ca ff ff       	call   80101770 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104cc5:	83 c4 0c             	add    $0xc,%esp
80104cc8:	6a 00                	push   $0x0
80104cca:	57                   	push   %edi
80104ccb:	53                   	push   %ebx
80104ccc:	e8 ef cf ff ff       	call   80101cc0 <dirlookup>
80104cd1:	83 c4 10             	add    $0x10,%esp
80104cd4:	89 c6                	mov    %eax,%esi
80104cd6:	85 c0                	test   %eax,%eax
80104cd8:	74 56                	je     80104d30 <create+0xa0>
    iunlockput(dp);
80104cda:	83 ec 0c             	sub    $0xc,%esp
80104cdd:	53                   	push   %ebx
80104cde:	e8 2d cd ff ff       	call   80101a10 <iunlockput>
    ilock(ip);
80104ce3:	89 34 24             	mov    %esi,(%esp)
80104ce6:	e8 85 ca ff ff       	call   80101770 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ceb:	83 c4 10             	add    $0x10,%esp
80104cee:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104cf3:	75 1b                	jne    80104d10 <create+0x80>
80104cf5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cfa:	75 14                	jne    80104d10 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cff:	89 f0                	mov    %esi,%eax
80104d01:	5b                   	pop    %ebx
80104d02:	5e                   	pop    %esi
80104d03:	5f                   	pop    %edi
80104d04:	5d                   	pop    %ebp
80104d05:	c3                   	ret    
80104d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d10:	83 ec 0c             	sub    $0xc,%esp
80104d13:	56                   	push   %esi
    return 0;
80104d14:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104d16:	e8 f5 cc ff ff       	call   80101a10 <iunlockput>
    return 0;
80104d1b:	83 c4 10             	add    $0x10,%esp
}
80104d1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d21:	89 f0                	mov    %esi,%eax
80104d23:	5b                   	pop    %ebx
80104d24:	5e                   	pop    %esi
80104d25:	5f                   	pop    %edi
80104d26:	5d                   	pop    %ebp
80104d27:	c3                   	ret    
80104d28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104d30:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d34:	83 ec 08             	sub    $0x8,%esp
80104d37:	50                   	push   %eax
80104d38:	ff 33                	pushl  (%ebx)
80104d3a:	e8 b1 c8 ff ff       	call   801015f0 <ialloc>
80104d3f:	83 c4 10             	add    $0x10,%esp
80104d42:	89 c6                	mov    %eax,%esi
80104d44:	85 c0                	test   %eax,%eax
80104d46:	0f 84 cd 00 00 00    	je     80104e19 <create+0x189>
  ilock(ip);
80104d4c:	83 ec 0c             	sub    $0xc,%esp
80104d4f:	50                   	push   %eax
80104d50:	e8 1b ca ff ff       	call   80101770 <ilock>
  ip->major = major;
80104d55:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d59:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d5d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d61:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d65:	b8 01 00 00 00       	mov    $0x1,%eax
80104d6a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d6e:	89 34 24             	mov    %esi,(%esp)
80104d71:	e8 3a c9 ff ff       	call   801016b0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d76:	83 c4 10             	add    $0x10,%esp
80104d79:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d7e:	74 30                	je     80104db0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104d80:	83 ec 04             	sub    $0x4,%esp
80104d83:	ff 76 04             	pushl  0x4(%esi)
80104d86:	57                   	push   %edi
80104d87:	53                   	push   %ebx
80104d88:	e8 f3 d1 ff ff       	call   80101f80 <dirlink>
80104d8d:	83 c4 10             	add    $0x10,%esp
80104d90:	85 c0                	test   %eax,%eax
80104d92:	78 78                	js     80104e0c <create+0x17c>
  iunlockput(dp);
80104d94:	83 ec 0c             	sub    $0xc,%esp
80104d97:	53                   	push   %ebx
80104d98:	e8 73 cc ff ff       	call   80101a10 <iunlockput>
  return ip;
80104d9d:	83 c4 10             	add    $0x10,%esp
}
80104da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104da3:	89 f0                	mov    %esi,%eax
80104da5:	5b                   	pop    %ebx
80104da6:	5e                   	pop    %esi
80104da7:	5f                   	pop    %edi
80104da8:	5d                   	pop    %ebp
80104da9:	c3                   	ret    
80104daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104db0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104db3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104db8:	53                   	push   %ebx
80104db9:	e8 f2 c8 ff ff       	call   801016b0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dbe:	83 c4 0c             	add    $0xc,%esp
80104dc1:	ff 76 04             	pushl  0x4(%esi)
80104dc4:	68 50 83 10 80       	push   $0x80108350
80104dc9:	56                   	push   %esi
80104dca:	e8 b1 d1 ff ff       	call   80101f80 <dirlink>
80104dcf:	83 c4 10             	add    $0x10,%esp
80104dd2:	85 c0                	test   %eax,%eax
80104dd4:	78 18                	js     80104dee <create+0x15e>
80104dd6:	83 ec 04             	sub    $0x4,%esp
80104dd9:	ff 73 04             	pushl  0x4(%ebx)
80104ddc:	68 4f 83 10 80       	push   $0x8010834f
80104de1:	56                   	push   %esi
80104de2:	e8 99 d1 ff ff       	call   80101f80 <dirlink>
80104de7:	83 c4 10             	add    $0x10,%esp
80104dea:	85 c0                	test   %eax,%eax
80104dec:	79 92                	jns    80104d80 <create+0xf0>
      panic("create dots");
80104dee:	83 ec 0c             	sub    $0xc,%esp
80104df1:	68 43 83 10 80       	push   $0x80108343
80104df6:	e8 95 b5 ff ff       	call   80100390 <panic>
80104dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dff:	90                   	nop
}
80104e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104e03:	31 f6                	xor    %esi,%esi
}
80104e05:	5b                   	pop    %ebx
80104e06:	89 f0                	mov    %esi,%eax
80104e08:	5e                   	pop    %esi
80104e09:	5f                   	pop    %edi
80104e0a:	5d                   	pop    %ebp
80104e0b:	c3                   	ret    
    panic("create: dirlink");
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	68 52 83 10 80       	push   $0x80108352
80104e14:	e8 77 b5 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104e19:	83 ec 0c             	sub    $0xc,%esp
80104e1c:	68 34 83 10 80       	push   $0x80108334
80104e21:	e8 6a b5 ff ff       	call   80100390 <panic>
80104e26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2d:	8d 76 00             	lea    0x0(%esi),%esi

80104e30 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	56                   	push   %esi
80104e34:	89 d6                	mov    %edx,%esi
80104e36:	53                   	push   %ebx
80104e37:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104e39:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104e3c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e3f:	50                   	push   %eax
80104e40:	6a 00                	push   $0x0
80104e42:	e8 e9 fc ff ff       	call   80104b30 <argint>
80104e47:	83 c4 10             	add    $0x10,%esp
80104e4a:	85 c0                	test   %eax,%eax
80104e4c:	78 2a                	js     80104e78 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e4e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e52:	77 24                	ja     80104e78 <argfd.constprop.0+0x48>
80104e54:	e8 77 ec ff ff       	call   80103ad0 <myproc>
80104e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e5c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104e60:	85 c0                	test   %eax,%eax
80104e62:	74 14                	je     80104e78 <argfd.constprop.0+0x48>
  if(pfd)
80104e64:	85 db                	test   %ebx,%ebx
80104e66:	74 02                	je     80104e6a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104e68:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104e6a:	89 06                	mov    %eax,(%esi)
  return 0;
80104e6c:	31 c0                	xor    %eax,%eax
}
80104e6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e71:	5b                   	pop    %ebx
80104e72:	5e                   	pop    %esi
80104e73:	5d                   	pop    %ebp
80104e74:	c3                   	ret    
80104e75:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e7d:	eb ef                	jmp    80104e6e <argfd.constprop.0+0x3e>
80104e7f:	90                   	nop

80104e80 <sys_dup>:
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104e85:	31 c0                	xor    %eax,%eax
{
80104e87:	89 e5                	mov    %esp,%ebp
80104e89:	56                   	push   %esi
80104e8a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104e8b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104e8e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104e91:	e8 9a ff ff ff       	call   80104e30 <argfd.constprop.0>
80104e96:	85 c0                	test   %eax,%eax
80104e98:	78 1e                	js     80104eb8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104e9a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104e9d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104e9f:	e8 2c ec ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104ea4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104ea8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104eac:	85 d2                	test   %edx,%edx
80104eae:	74 20                	je     80104ed0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104eb0:	83 c3 01             	add    $0x1,%ebx
80104eb3:	83 fb 10             	cmp    $0x10,%ebx
80104eb6:	75 f0                	jne    80104ea8 <sys_dup+0x28>
}
80104eb8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104ebb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ec0:	89 d8                	mov    %ebx,%eax
80104ec2:	5b                   	pop    %ebx
80104ec3:	5e                   	pop    %esi
80104ec4:	5d                   	pop    %ebp
80104ec5:	c3                   	ret    
80104ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104ed0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ed4:	83 ec 0c             	sub    $0xc,%esp
80104ed7:	ff 75 f4             	pushl  -0xc(%ebp)
80104eda:	e8 a1 bf ff ff       	call   80100e80 <filedup>
  return fd;
80104edf:	83 c4 10             	add    $0x10,%esp
}
80104ee2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ee5:	89 d8                	mov    %ebx,%eax
80104ee7:	5b                   	pop    %ebx
80104ee8:	5e                   	pop    %esi
80104ee9:	5d                   	pop    %ebp
80104eea:	c3                   	ret    
80104eeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eef:	90                   	nop

80104ef0 <sys_read>:
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ef5:	31 c0                	xor    %eax,%eax
{
80104ef7:	89 e5                	mov    %esp,%ebp
80104ef9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104efc:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104eff:	e8 2c ff ff ff       	call   80104e30 <argfd.constprop.0>
80104f04:	85 c0                	test   %eax,%eax
80104f06:	78 48                	js     80104f50 <sys_read+0x60>
80104f08:	83 ec 08             	sub    $0x8,%esp
80104f0b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f0e:	50                   	push   %eax
80104f0f:	6a 02                	push   $0x2
80104f11:	e8 1a fc ff ff       	call   80104b30 <argint>
80104f16:	83 c4 10             	add    $0x10,%esp
80104f19:	85 c0                	test   %eax,%eax
80104f1b:	78 33                	js     80104f50 <sys_read+0x60>
80104f1d:	83 ec 04             	sub    $0x4,%esp
80104f20:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f23:	ff 75 f0             	pushl  -0x10(%ebp)
80104f26:	50                   	push   %eax
80104f27:	6a 01                	push   $0x1
80104f29:	e8 52 fc ff ff       	call   80104b80 <argptr>
80104f2e:	83 c4 10             	add    $0x10,%esp
80104f31:	85 c0                	test   %eax,%eax
80104f33:	78 1b                	js     80104f50 <sys_read+0x60>
  return fileread(f, p, n);
80104f35:	83 ec 04             	sub    $0x4,%esp
80104f38:	ff 75 f0             	pushl  -0x10(%ebp)
80104f3b:	ff 75 f4             	pushl  -0xc(%ebp)
80104f3e:	ff 75 ec             	pushl  -0x14(%ebp)
80104f41:	e8 ba c0 ff ff       	call   80101000 <fileread>
80104f46:	83 c4 10             	add    $0x10,%esp
}
80104f49:	c9                   	leave  
80104f4a:	c3                   	ret    
80104f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f4f:	90                   	nop
80104f50:	c9                   	leave  
    return -1;
80104f51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f56:	c3                   	ret    
80104f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <sys_write>:
{
80104f60:	f3 0f 1e fb          	endbr32 
80104f64:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f65:	31 c0                	xor    %eax,%eax
{
80104f67:	89 e5                	mov    %esp,%ebp
80104f69:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f6c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104f6f:	e8 bc fe ff ff       	call   80104e30 <argfd.constprop.0>
80104f74:	85 c0                	test   %eax,%eax
80104f76:	78 48                	js     80104fc0 <sys_write+0x60>
80104f78:	83 ec 08             	sub    $0x8,%esp
80104f7b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f7e:	50                   	push   %eax
80104f7f:	6a 02                	push   $0x2
80104f81:	e8 aa fb ff ff       	call   80104b30 <argint>
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	85 c0                	test   %eax,%eax
80104f8b:	78 33                	js     80104fc0 <sys_write+0x60>
80104f8d:	83 ec 04             	sub    $0x4,%esp
80104f90:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f93:	ff 75 f0             	pushl  -0x10(%ebp)
80104f96:	50                   	push   %eax
80104f97:	6a 01                	push   $0x1
80104f99:	e8 e2 fb ff ff       	call   80104b80 <argptr>
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	78 1b                	js     80104fc0 <sys_write+0x60>
  return filewrite(f, p, n);
80104fa5:	83 ec 04             	sub    $0x4,%esp
80104fa8:	ff 75 f0             	pushl  -0x10(%ebp)
80104fab:	ff 75 f4             	pushl  -0xc(%ebp)
80104fae:	ff 75 ec             	pushl  -0x14(%ebp)
80104fb1:	e8 ea c0 ff ff       	call   801010a0 <filewrite>
80104fb6:	83 c4 10             	add    $0x10,%esp
}
80104fb9:	c9                   	leave  
80104fba:	c3                   	ret    
80104fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fbf:	90                   	nop
80104fc0:	c9                   	leave  
    return -1;
80104fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fc6:	c3                   	ret    
80104fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fce:	66 90                	xchg   %ax,%ax

80104fd0 <sys_close>:
{
80104fd0:	f3 0f 1e fb          	endbr32 
80104fd4:	55                   	push   %ebp
80104fd5:	89 e5                	mov    %esp,%ebp
80104fd7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104fda:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104fdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fe0:	e8 4b fe ff ff       	call   80104e30 <argfd.constprop.0>
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	78 27                	js     80105010 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104fe9:	e8 e2 ea ff ff       	call   80103ad0 <myproc>
80104fee:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104ff1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ff4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ffb:	00 
  fileclose(f);
80104ffc:	ff 75 f4             	pushl  -0xc(%ebp)
80104fff:	e8 cc be ff ff       	call   80100ed0 <fileclose>
  return 0;
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	31 c0                	xor    %eax,%eax
}
80105009:	c9                   	leave  
8010500a:	c3                   	ret    
8010500b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010500f:	90                   	nop
80105010:	c9                   	leave  
    return -1;
80105011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105016:	c3                   	ret    
80105017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501e:	66 90                	xchg   %ax,%ax

80105020 <sys_fstat>:
{
80105020:	f3 0f 1e fb          	endbr32 
80105024:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105025:	31 c0                	xor    %eax,%eax
{
80105027:	89 e5                	mov    %esp,%ebp
80105029:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010502c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010502f:	e8 fc fd ff ff       	call   80104e30 <argfd.constprop.0>
80105034:	85 c0                	test   %eax,%eax
80105036:	78 30                	js     80105068 <sys_fstat+0x48>
80105038:	83 ec 04             	sub    $0x4,%esp
8010503b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010503e:	6a 14                	push   $0x14
80105040:	50                   	push   %eax
80105041:	6a 01                	push   $0x1
80105043:	e8 38 fb ff ff       	call   80104b80 <argptr>
80105048:	83 c4 10             	add    $0x10,%esp
8010504b:	85 c0                	test   %eax,%eax
8010504d:	78 19                	js     80105068 <sys_fstat+0x48>
  return filestat(f, st);
8010504f:	83 ec 08             	sub    $0x8,%esp
80105052:	ff 75 f4             	pushl  -0xc(%ebp)
80105055:	ff 75 f0             	pushl  -0x10(%ebp)
80105058:	e8 53 bf ff ff       	call   80100fb0 <filestat>
8010505d:	83 c4 10             	add    $0x10,%esp
}
80105060:	c9                   	leave  
80105061:	c3                   	ret    
80105062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105068:	c9                   	leave  
    return -1;
80105069:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010506e:	c3                   	ret    
8010506f:	90                   	nop

80105070 <sys_link>:
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	57                   	push   %edi
80105078:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105079:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010507c:	53                   	push   %ebx
8010507d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105080:	50                   	push   %eax
80105081:	6a 00                	push   $0x0
80105083:	e8 58 fb ff ff       	call   80104be0 <argstr>
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	85 c0                	test   %eax,%eax
8010508d:	0f 88 ff 00 00 00    	js     80105192 <sys_link+0x122>
80105093:	83 ec 08             	sub    $0x8,%esp
80105096:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105099:	50                   	push   %eax
8010509a:	6a 01                	push   $0x1
8010509c:	e8 3f fb ff ff       	call   80104be0 <argstr>
801050a1:	83 c4 10             	add    $0x10,%esp
801050a4:	85 c0                	test   %eax,%eax
801050a6:	0f 88 e6 00 00 00    	js     80105192 <sys_link+0x122>
  begin_op();
801050ac:	e8 8f dc ff ff       	call   80102d40 <begin_op>
  if((ip = namei(old)) == 0){
801050b1:	83 ec 0c             	sub    $0xc,%esp
801050b4:	ff 75 d4             	pushl  -0x2c(%ebp)
801050b7:	e8 84 cf ff ff       	call   80102040 <namei>
801050bc:	83 c4 10             	add    $0x10,%esp
801050bf:	89 c3                	mov    %eax,%ebx
801050c1:	85 c0                	test   %eax,%eax
801050c3:	0f 84 e8 00 00 00    	je     801051b1 <sys_link+0x141>
  ilock(ip);
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	50                   	push   %eax
801050cd:	e8 9e c6 ff ff       	call   80101770 <ilock>
  if(ip->type == T_DIR){
801050d2:	83 c4 10             	add    $0x10,%esp
801050d5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050da:	0f 84 b9 00 00 00    	je     80105199 <sys_link+0x129>
  iupdate(ip);
801050e0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801050e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801050e8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801050eb:	53                   	push   %ebx
801050ec:	e8 bf c5 ff ff       	call   801016b0 <iupdate>
  iunlock(ip);
801050f1:	89 1c 24             	mov    %ebx,(%esp)
801050f4:	e8 57 c7 ff ff       	call   80101850 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801050f9:	58                   	pop    %eax
801050fa:	5a                   	pop    %edx
801050fb:	57                   	push   %edi
801050fc:	ff 75 d0             	pushl  -0x30(%ebp)
801050ff:	e8 5c cf ff ff       	call   80102060 <nameiparent>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	89 c6                	mov    %eax,%esi
80105109:	85 c0                	test   %eax,%eax
8010510b:	74 5f                	je     8010516c <sys_link+0xfc>
  ilock(dp);
8010510d:	83 ec 0c             	sub    $0xc,%esp
80105110:	50                   	push   %eax
80105111:	e8 5a c6 ff ff       	call   80101770 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105116:	8b 03                	mov    (%ebx),%eax
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	39 06                	cmp    %eax,(%esi)
8010511d:	75 41                	jne    80105160 <sys_link+0xf0>
8010511f:	83 ec 04             	sub    $0x4,%esp
80105122:	ff 73 04             	pushl  0x4(%ebx)
80105125:	57                   	push   %edi
80105126:	56                   	push   %esi
80105127:	e8 54 ce ff ff       	call   80101f80 <dirlink>
8010512c:	83 c4 10             	add    $0x10,%esp
8010512f:	85 c0                	test   %eax,%eax
80105131:	78 2d                	js     80105160 <sys_link+0xf0>
  iunlockput(dp);
80105133:	83 ec 0c             	sub    $0xc,%esp
80105136:	56                   	push   %esi
80105137:	e8 d4 c8 ff ff       	call   80101a10 <iunlockput>
  iput(ip);
8010513c:	89 1c 24             	mov    %ebx,(%esp)
8010513f:	e8 5c c7 ff ff       	call   801018a0 <iput>
  end_op();
80105144:	e8 67 dc ff ff       	call   80102db0 <end_op>
  return 0;
80105149:	83 c4 10             	add    $0x10,%esp
8010514c:	31 c0                	xor    %eax,%eax
}
8010514e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105151:	5b                   	pop    %ebx
80105152:	5e                   	pop    %esi
80105153:	5f                   	pop    %edi
80105154:	5d                   	pop    %ebp
80105155:	c3                   	ret    
80105156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	56                   	push   %esi
80105164:	e8 a7 c8 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105169:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010516c:	83 ec 0c             	sub    $0xc,%esp
8010516f:	53                   	push   %ebx
80105170:	e8 fb c5 ff ff       	call   80101770 <ilock>
  ip->nlink--;
80105175:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010517a:	89 1c 24             	mov    %ebx,(%esp)
8010517d:	e8 2e c5 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
80105182:	89 1c 24             	mov    %ebx,(%esp)
80105185:	e8 86 c8 ff ff       	call   80101a10 <iunlockput>
  end_op();
8010518a:	e8 21 dc ff ff       	call   80102db0 <end_op>
  return -1;
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105197:	eb b5                	jmp    8010514e <sys_link+0xde>
    iunlockput(ip);
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	53                   	push   %ebx
8010519d:	e8 6e c8 ff ff       	call   80101a10 <iunlockput>
    end_op();
801051a2:	e8 09 dc ff ff       	call   80102db0 <end_op>
    return -1;
801051a7:	83 c4 10             	add    $0x10,%esp
801051aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051af:	eb 9d                	jmp    8010514e <sys_link+0xde>
    end_op();
801051b1:	e8 fa db ff ff       	call   80102db0 <end_op>
    return -1;
801051b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051bb:	eb 91                	jmp    8010514e <sys_link+0xde>
801051bd:	8d 76 00             	lea    0x0(%esi),%esi

801051c0 <sys_unlink>:
{
801051c0:	f3 0f 1e fb          	endbr32 
801051c4:	55                   	push   %ebp
801051c5:	89 e5                	mov    %esp,%ebp
801051c7:	57                   	push   %edi
801051c8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051cc:	53                   	push   %ebx
801051cd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051d0:	50                   	push   %eax
801051d1:	6a 00                	push   $0x0
801051d3:	e8 08 fa ff ff       	call   80104be0 <argstr>
801051d8:	83 c4 10             	add    $0x10,%esp
801051db:	85 c0                	test   %eax,%eax
801051dd:	0f 88 7d 01 00 00    	js     80105360 <sys_unlink+0x1a0>
  begin_op();
801051e3:	e8 58 db ff ff       	call   80102d40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801051e8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801051eb:	83 ec 08             	sub    $0x8,%esp
801051ee:	53                   	push   %ebx
801051ef:	ff 75 c0             	pushl  -0x40(%ebp)
801051f2:	e8 69 ce ff ff       	call   80102060 <nameiparent>
801051f7:	83 c4 10             	add    $0x10,%esp
801051fa:	89 c6                	mov    %eax,%esi
801051fc:	85 c0                	test   %eax,%eax
801051fe:	0f 84 66 01 00 00    	je     8010536a <sys_unlink+0x1aa>
  ilock(dp);
80105204:	83 ec 0c             	sub    $0xc,%esp
80105207:	50                   	push   %eax
80105208:	e8 63 c5 ff ff       	call   80101770 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010520d:	58                   	pop    %eax
8010520e:	5a                   	pop    %edx
8010520f:	68 50 83 10 80       	push   $0x80108350
80105214:	53                   	push   %ebx
80105215:	e8 86 ca ff ff       	call   80101ca0 <namecmp>
8010521a:	83 c4 10             	add    $0x10,%esp
8010521d:	85 c0                	test   %eax,%eax
8010521f:	0f 84 03 01 00 00    	je     80105328 <sys_unlink+0x168>
80105225:	83 ec 08             	sub    $0x8,%esp
80105228:	68 4f 83 10 80       	push   $0x8010834f
8010522d:	53                   	push   %ebx
8010522e:	e8 6d ca ff ff       	call   80101ca0 <namecmp>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	0f 84 ea 00 00 00    	je     80105328 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010523e:	83 ec 04             	sub    $0x4,%esp
80105241:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105244:	50                   	push   %eax
80105245:	53                   	push   %ebx
80105246:	56                   	push   %esi
80105247:	e8 74 ca ff ff       	call   80101cc0 <dirlookup>
8010524c:	83 c4 10             	add    $0x10,%esp
8010524f:	89 c3                	mov    %eax,%ebx
80105251:	85 c0                	test   %eax,%eax
80105253:	0f 84 cf 00 00 00    	je     80105328 <sys_unlink+0x168>
  ilock(ip);
80105259:	83 ec 0c             	sub    $0xc,%esp
8010525c:	50                   	push   %eax
8010525d:	e8 0e c5 ff ff       	call   80101770 <ilock>
  if(ip->nlink < 1)
80105262:	83 c4 10             	add    $0x10,%esp
80105265:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010526a:	0f 8e 23 01 00 00    	jle    80105393 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105270:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105275:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105278:	74 66                	je     801052e0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010527a:	83 ec 04             	sub    $0x4,%esp
8010527d:	6a 10                	push   $0x10
8010527f:	6a 00                	push   $0x0
80105281:	57                   	push   %edi
80105282:	e8 c9 f5 ff ff       	call   80104850 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105287:	6a 10                	push   $0x10
80105289:	ff 75 c4             	pushl  -0x3c(%ebp)
8010528c:	57                   	push   %edi
8010528d:	56                   	push   %esi
8010528e:	e8 dd c8 ff ff       	call   80101b70 <writei>
80105293:	83 c4 20             	add    $0x20,%esp
80105296:	83 f8 10             	cmp    $0x10,%eax
80105299:	0f 85 e7 00 00 00    	jne    80105386 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010529f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052a4:	0f 84 96 00 00 00    	je     80105340 <sys_unlink+0x180>
  iunlockput(dp);
801052aa:	83 ec 0c             	sub    $0xc,%esp
801052ad:	56                   	push   %esi
801052ae:	e8 5d c7 ff ff       	call   80101a10 <iunlockput>
  ip->nlink--;
801052b3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052b8:	89 1c 24             	mov    %ebx,(%esp)
801052bb:	e8 f0 c3 ff ff       	call   801016b0 <iupdate>
  iunlockput(ip);
801052c0:	89 1c 24             	mov    %ebx,(%esp)
801052c3:	e8 48 c7 ff ff       	call   80101a10 <iunlockput>
  end_op();
801052c8:	e8 e3 da ff ff       	call   80102db0 <end_op>
  return 0;
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	31 c0                	xor    %eax,%eax
}
801052d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052d5:	5b                   	pop    %ebx
801052d6:	5e                   	pop    %esi
801052d7:	5f                   	pop    %edi
801052d8:	5d                   	pop    %ebp
801052d9:	c3                   	ret    
801052da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801052e0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801052e4:	76 94                	jbe    8010527a <sys_unlink+0xba>
801052e6:	ba 20 00 00 00       	mov    $0x20,%edx
801052eb:	eb 0b                	jmp    801052f8 <sys_unlink+0x138>
801052ed:	8d 76 00             	lea    0x0(%esi),%esi
801052f0:	83 c2 10             	add    $0x10,%edx
801052f3:	39 53 58             	cmp    %edx,0x58(%ebx)
801052f6:	76 82                	jbe    8010527a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052f8:	6a 10                	push   $0x10
801052fa:	52                   	push   %edx
801052fb:	57                   	push   %edi
801052fc:	53                   	push   %ebx
801052fd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105300:	e8 6b c7 ff ff       	call   80101a70 <readi>
80105305:	83 c4 10             	add    $0x10,%esp
80105308:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010530b:	83 f8 10             	cmp    $0x10,%eax
8010530e:	75 69                	jne    80105379 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105310:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105315:	74 d9                	je     801052f0 <sys_unlink+0x130>
    iunlockput(ip);
80105317:	83 ec 0c             	sub    $0xc,%esp
8010531a:	53                   	push   %ebx
8010531b:	e8 f0 c6 ff ff       	call   80101a10 <iunlockput>
    goto bad;
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105327:	90                   	nop
  iunlockput(dp);
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	56                   	push   %esi
8010532c:	e8 df c6 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105331:	e8 7a da ff ff       	call   80102db0 <end_op>
  return -1;
80105336:	83 c4 10             	add    $0x10,%esp
80105339:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010533e:	eb 92                	jmp    801052d2 <sys_unlink+0x112>
    iupdate(dp);
80105340:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105343:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105348:	56                   	push   %esi
80105349:	e8 62 c3 ff ff       	call   801016b0 <iupdate>
8010534e:	83 c4 10             	add    $0x10,%esp
80105351:	e9 54 ff ff ff       	jmp    801052aa <sys_unlink+0xea>
80105356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105360:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105365:	e9 68 ff ff ff       	jmp    801052d2 <sys_unlink+0x112>
    end_op();
8010536a:	e8 41 da ff ff       	call   80102db0 <end_op>
    return -1;
8010536f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105374:	e9 59 ff ff ff       	jmp    801052d2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105379:	83 ec 0c             	sub    $0xc,%esp
8010537c:	68 74 83 10 80       	push   $0x80108374
80105381:	e8 0a b0 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105386:	83 ec 0c             	sub    $0xc,%esp
80105389:	68 86 83 10 80       	push   $0x80108386
8010538e:	e8 fd af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105393:	83 ec 0c             	sub    $0xc,%esp
80105396:	68 62 83 10 80       	push   $0x80108362
8010539b:	e8 f0 af ff ff       	call   80100390 <panic>

801053a0 <sys_open>:

int
sys_open(void)
{
801053a0:	f3 0f 1e fb          	endbr32 
801053a4:	55                   	push   %ebp
801053a5:	89 e5                	mov    %esp,%ebp
801053a7:	57                   	push   %edi
801053a8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053ac:	53                   	push   %ebx
801053ad:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053b0:	50                   	push   %eax
801053b1:	6a 00                	push   $0x0
801053b3:	e8 28 f8 ff ff       	call   80104be0 <argstr>
801053b8:	83 c4 10             	add    $0x10,%esp
801053bb:	85 c0                	test   %eax,%eax
801053bd:	0f 88 8a 00 00 00    	js     8010544d <sys_open+0xad>
801053c3:	83 ec 08             	sub    $0x8,%esp
801053c6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053c9:	50                   	push   %eax
801053ca:	6a 01                	push   $0x1
801053cc:	e8 5f f7 ff ff       	call   80104b30 <argint>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	85 c0                	test   %eax,%eax
801053d6:	78 75                	js     8010544d <sys_open+0xad>
    return -1;

  begin_op();
801053d8:	e8 63 d9 ff ff       	call   80102d40 <begin_op>

  if(omode & O_CREATE){
801053dd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053e1:	75 75                	jne    80105458 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053e3:	83 ec 0c             	sub    $0xc,%esp
801053e6:	ff 75 e0             	pushl  -0x20(%ebp)
801053e9:	e8 52 cc ff ff       	call   80102040 <namei>
801053ee:	83 c4 10             	add    $0x10,%esp
801053f1:	89 c6                	mov    %eax,%esi
801053f3:	85 c0                	test   %eax,%eax
801053f5:	74 7e                	je     80105475 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801053f7:	83 ec 0c             	sub    $0xc,%esp
801053fa:	50                   	push   %eax
801053fb:	e8 70 c3 ff ff       	call   80101770 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105400:	83 c4 10             	add    $0x10,%esp
80105403:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105408:	0f 84 c2 00 00 00    	je     801054d0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010540e:	e8 fd b9 ff ff       	call   80100e10 <filealloc>
80105413:	89 c7                	mov    %eax,%edi
80105415:	85 c0                	test   %eax,%eax
80105417:	74 23                	je     8010543c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105419:	e8 b2 e6 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010541e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105420:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105424:	85 d2                	test   %edx,%edx
80105426:	74 60                	je     80105488 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105428:	83 c3 01             	add    $0x1,%ebx
8010542b:	83 fb 10             	cmp    $0x10,%ebx
8010542e:	75 f0                	jne    80105420 <sys_open+0x80>
    if(f)
      fileclose(f);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	57                   	push   %edi
80105434:	e8 97 ba ff ff       	call   80100ed0 <fileclose>
80105439:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	56                   	push   %esi
80105440:	e8 cb c5 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105445:	e8 66 d9 ff ff       	call   80102db0 <end_op>
    return -1;
8010544a:	83 c4 10             	add    $0x10,%esp
8010544d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105452:	eb 6d                	jmp    801054c1 <sys_open+0x121>
80105454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105458:	83 ec 0c             	sub    $0xc,%esp
8010545b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010545e:	31 c9                	xor    %ecx,%ecx
80105460:	ba 02 00 00 00       	mov    $0x2,%edx
80105465:	6a 00                	push   $0x0
80105467:	e8 24 f8 ff ff       	call   80104c90 <create>
    if(ip == 0){
8010546c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010546f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105471:	85 c0                	test   %eax,%eax
80105473:	75 99                	jne    8010540e <sys_open+0x6e>
      end_op();
80105475:	e8 36 d9 ff ff       	call   80102db0 <end_op>
      return -1;
8010547a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010547f:	eb 40                	jmp    801054c1 <sys_open+0x121>
80105481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105488:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010548b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010548f:	56                   	push   %esi
80105490:	e8 bb c3 ff ff       	call   80101850 <iunlock>
  end_op();
80105495:	e8 16 d9 ff ff       	call   80102db0 <end_op>

  f->type = FD_INODE;
8010549a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054a3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054a6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054a9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054ab:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054b2:	f7 d0                	not    %eax
801054b4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054b7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054ba:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054bd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054c4:	89 d8                	mov    %ebx,%eax
801054c6:	5b                   	pop    %ebx
801054c7:	5e                   	pop    %esi
801054c8:	5f                   	pop    %edi
801054c9:	5d                   	pop    %ebp
801054ca:	c3                   	ret    
801054cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054cf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801054d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054d3:	85 c9                	test   %ecx,%ecx
801054d5:	0f 84 33 ff ff ff    	je     8010540e <sys_open+0x6e>
801054db:	e9 5c ff ff ff       	jmp    8010543c <sys_open+0x9c>

801054e0 <sys_mkdir>:

int
sys_mkdir(void)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801054ea:	e8 51 d8 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801054ef:	83 ec 08             	sub    $0x8,%esp
801054f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054f5:	50                   	push   %eax
801054f6:	6a 00                	push   $0x0
801054f8:	e8 e3 f6 ff ff       	call   80104be0 <argstr>
801054fd:	83 c4 10             	add    $0x10,%esp
80105500:	85 c0                	test   %eax,%eax
80105502:	78 34                	js     80105538 <sys_mkdir+0x58>
80105504:	83 ec 0c             	sub    $0xc,%esp
80105507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550a:	31 c9                	xor    %ecx,%ecx
8010550c:	ba 01 00 00 00       	mov    $0x1,%edx
80105511:	6a 00                	push   $0x0
80105513:	e8 78 f7 ff ff       	call   80104c90 <create>
80105518:	83 c4 10             	add    $0x10,%esp
8010551b:	85 c0                	test   %eax,%eax
8010551d:	74 19                	je     80105538 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010551f:	83 ec 0c             	sub    $0xc,%esp
80105522:	50                   	push   %eax
80105523:	e8 e8 c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
80105528:	e8 83 d8 ff ff       	call   80102db0 <end_op>
  return 0;
8010552d:	83 c4 10             	add    $0x10,%esp
80105530:	31 c0                	xor    %eax,%eax
}
80105532:	c9                   	leave  
80105533:	c3                   	ret    
80105534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105538:	e8 73 d8 ff ff       	call   80102db0 <end_op>
    return -1;
8010553d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105542:	c9                   	leave  
80105543:	c3                   	ret    
80105544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010554f:	90                   	nop

80105550 <sys_mknod>:

int
sys_mknod(void)
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
80105555:	89 e5                	mov    %esp,%ebp
80105557:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
8010555a:	e8 e1 d7 ff ff       	call   80102d40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010555f:	83 ec 08             	sub    $0x8,%esp
80105562:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105565:	50                   	push   %eax
80105566:	6a 00                	push   $0x0
80105568:	e8 73 f6 ff ff       	call   80104be0 <argstr>
8010556d:	83 c4 10             	add    $0x10,%esp
80105570:	85 c0                	test   %eax,%eax
80105572:	78 64                	js     801055d8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105574:	83 ec 08             	sub    $0x8,%esp
80105577:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010557a:	50                   	push   %eax
8010557b:	6a 01                	push   $0x1
8010557d:	e8 ae f5 ff ff       	call   80104b30 <argint>
  if((argstr(0, &path)) < 0 ||
80105582:	83 c4 10             	add    $0x10,%esp
80105585:	85 c0                	test   %eax,%eax
80105587:	78 4f                	js     801055d8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105589:	83 ec 08             	sub    $0x8,%esp
8010558c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010558f:	50                   	push   %eax
80105590:	6a 02                	push   $0x2
80105592:	e8 99 f5 ff ff       	call   80104b30 <argint>
     argint(1, &major) < 0 ||
80105597:	83 c4 10             	add    $0x10,%esp
8010559a:	85 c0                	test   %eax,%eax
8010559c:	78 3a                	js     801055d8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010559e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055a2:	83 ec 0c             	sub    $0xc,%esp
801055a5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055a9:	ba 03 00 00 00       	mov    $0x3,%edx
801055ae:	50                   	push   %eax
801055af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055b2:	e8 d9 f6 ff ff       	call   80104c90 <create>
     argint(2, &minor) < 0 ||
801055b7:	83 c4 10             	add    $0x10,%esp
801055ba:	85 c0                	test   %eax,%eax
801055bc:	74 1a                	je     801055d8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055be:	83 ec 0c             	sub    $0xc,%esp
801055c1:	50                   	push   %eax
801055c2:	e8 49 c4 ff ff       	call   80101a10 <iunlockput>
  end_op();
801055c7:	e8 e4 d7 ff ff       	call   80102db0 <end_op>
  return 0;
801055cc:	83 c4 10             	add    $0x10,%esp
801055cf:	31 c0                	xor    %eax,%eax
}
801055d1:	c9                   	leave  
801055d2:	c3                   	ret    
801055d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055d7:	90                   	nop
    end_op();
801055d8:	e8 d3 d7 ff ff       	call   80102db0 <end_op>
    return -1;
801055dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055e2:	c9                   	leave  
801055e3:	c3                   	ret    
801055e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop

801055f0 <sys_chdir>:

int
sys_chdir(void)
{
801055f0:	f3 0f 1e fb          	endbr32 
801055f4:	55                   	push   %ebp
801055f5:	89 e5                	mov    %esp,%ebp
801055f7:	56                   	push   %esi
801055f8:	53                   	push   %ebx
801055f9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055fc:	e8 cf e4 ff ff       	call   80103ad0 <myproc>
80105601:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105603:	e8 38 d7 ff ff       	call   80102d40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105608:	83 ec 08             	sub    $0x8,%esp
8010560b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010560e:	50                   	push   %eax
8010560f:	6a 00                	push   $0x0
80105611:	e8 ca f5 ff ff       	call   80104be0 <argstr>
80105616:	83 c4 10             	add    $0x10,%esp
80105619:	85 c0                	test   %eax,%eax
8010561b:	78 73                	js     80105690 <sys_chdir+0xa0>
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	ff 75 f4             	pushl  -0xc(%ebp)
80105623:	e8 18 ca ff ff       	call   80102040 <namei>
80105628:	83 c4 10             	add    $0x10,%esp
8010562b:	89 c3                	mov    %eax,%ebx
8010562d:	85 c0                	test   %eax,%eax
8010562f:	74 5f                	je     80105690 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105631:	83 ec 0c             	sub    $0xc,%esp
80105634:	50                   	push   %eax
80105635:	e8 36 c1 ff ff       	call   80101770 <ilock>
  if(ip->type != T_DIR){
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105642:	75 2c                	jne    80105670 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105644:	83 ec 0c             	sub    $0xc,%esp
80105647:	53                   	push   %ebx
80105648:	e8 03 c2 ff ff       	call   80101850 <iunlock>
  iput(curproc->cwd);
8010564d:	58                   	pop    %eax
8010564e:	ff 76 68             	pushl  0x68(%esi)
80105651:	e8 4a c2 ff ff       	call   801018a0 <iput>
  end_op();
80105656:	e8 55 d7 ff ff       	call   80102db0 <end_op>
  curproc->cwd = ip;
8010565b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010565e:	83 c4 10             	add    $0x10,%esp
80105661:	31 c0                	xor    %eax,%eax
}
80105663:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105666:	5b                   	pop    %ebx
80105667:	5e                   	pop    %esi
80105668:	5d                   	pop    %ebp
80105669:	c3                   	ret    
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 97 c3 ff ff       	call   80101a10 <iunlockput>
    end_op();
80105679:	e8 32 d7 ff ff       	call   80102db0 <end_op>
    return -1;
8010567e:	83 c4 10             	add    $0x10,%esp
80105681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105686:	eb db                	jmp    80105663 <sys_chdir+0x73>
80105688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010568f:	90                   	nop
    end_op();
80105690:	e8 1b d7 ff ff       	call   80102db0 <end_op>
    return -1;
80105695:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010569a:	eb c7                	jmp    80105663 <sys_chdir+0x73>
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056a0 <sys_exec>:

int
sys_exec(void)
{
801056a0:	f3 0f 1e fb          	endbr32 
801056a4:	55                   	push   %ebp
801056a5:	89 e5                	mov    %esp,%ebp
801056a7:	57                   	push   %edi
801056a8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056a9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056af:	53                   	push   %ebx
801056b0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056b6:	50                   	push   %eax
801056b7:	6a 00                	push   $0x0
801056b9:	e8 22 f5 ff ff       	call   80104be0 <argstr>
801056be:	83 c4 10             	add    $0x10,%esp
801056c1:	85 c0                	test   %eax,%eax
801056c3:	0f 88 8b 00 00 00    	js     80105754 <sys_exec+0xb4>
801056c9:	83 ec 08             	sub    $0x8,%esp
801056cc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056d2:	50                   	push   %eax
801056d3:	6a 01                	push   $0x1
801056d5:	e8 56 f4 ff ff       	call   80104b30 <argint>
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	85 c0                	test   %eax,%eax
801056df:	78 73                	js     80105754 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056e1:	83 ec 04             	sub    $0x4,%esp
801056e4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801056ea:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056ec:	68 80 00 00 00       	push   $0x80
801056f1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801056f7:	6a 00                	push   $0x0
801056f9:	50                   	push   %eax
801056fa:	e8 51 f1 ff ff       	call   80104850 <memset>
801056ff:	83 c4 10             	add    $0x10,%esp
80105702:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105708:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010570e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105715:	83 ec 08             	sub    $0x8,%esp
80105718:	57                   	push   %edi
80105719:	01 f0                	add    %esi,%eax
8010571b:	50                   	push   %eax
8010571c:	e8 6f f3 ff ff       	call   80104a90 <fetchint>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	85 c0                	test   %eax,%eax
80105726:	78 2c                	js     80105754 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105728:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010572e:	85 c0                	test   %eax,%eax
80105730:	74 36                	je     80105768 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105732:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105738:	83 ec 08             	sub    $0x8,%esp
8010573b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
8010573e:	52                   	push   %edx
8010573f:	50                   	push   %eax
80105740:	e8 8b f3 ff ff       	call   80104ad0 <fetchstr>
80105745:	83 c4 10             	add    $0x10,%esp
80105748:	85 c0                	test   %eax,%eax
8010574a:	78 08                	js     80105754 <sys_exec+0xb4>
  for(i=0;; i++){
8010574c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010574f:	83 fb 20             	cmp    $0x20,%ebx
80105752:	75 b4                	jne    80105708 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105754:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010575c:	5b                   	pop    %ebx
8010575d:	5e                   	pop    %esi
8010575e:	5f                   	pop    %edi
8010575f:	5d                   	pop    %ebp
80105760:	c3                   	ret    
80105761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105768:	83 ec 08             	sub    $0x8,%esp
8010576b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105771:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105778:	00 00 00 00 
  return exec(path, argv);
8010577c:	50                   	push   %eax
8010577d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105783:	e8 f8 b2 ff ff       	call   80100a80 <exec>
80105788:	83 c4 10             	add    $0x10,%esp
}
8010578b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010578e:	5b                   	pop    %ebx
8010578f:	5e                   	pop    %esi
80105790:	5f                   	pop    %edi
80105791:	5d                   	pop    %ebp
80105792:	c3                   	ret    
80105793:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010579a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801057a0 <sys_pipe>:

int
sys_pipe(void)
{
801057a0:	f3 0f 1e fb          	endbr32 
801057a4:	55                   	push   %ebp
801057a5:	89 e5                	mov    %esp,%ebp
801057a7:	57                   	push   %edi
801057a8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057a9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801057ac:	53                   	push   %ebx
801057ad:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801057b0:	6a 08                	push   $0x8
801057b2:	50                   	push   %eax
801057b3:	6a 00                	push   $0x0
801057b5:	e8 c6 f3 ff ff       	call   80104b80 <argptr>
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	85 c0                	test   %eax,%eax
801057bf:	78 4e                	js     8010580f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057c1:	83 ec 08             	sub    $0x8,%esp
801057c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057c7:	50                   	push   %eax
801057c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057cb:	50                   	push   %eax
801057cc:	e8 2f dc ff ff       	call   80103400 <pipealloc>
801057d1:	83 c4 10             	add    $0x10,%esp
801057d4:	85 c0                	test   %eax,%eax
801057d6:	78 37                	js     8010580f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057d8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057db:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057dd:	e8 ee e2 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801057e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057ec:	85 f6                	test   %esi,%esi
801057ee:	74 30                	je     80105820 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801057f0:	83 c3 01             	add    $0x1,%ebx
801057f3:	83 fb 10             	cmp    $0x10,%ebx
801057f6:	75 f0                	jne    801057e8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	ff 75 e0             	pushl  -0x20(%ebp)
801057fe:	e8 cd b6 ff ff       	call   80100ed0 <fileclose>
    fileclose(wf);
80105803:	58                   	pop    %eax
80105804:	ff 75 e4             	pushl  -0x1c(%ebp)
80105807:	e8 c4 b6 ff ff       	call   80100ed0 <fileclose>
    return -1;
8010580c:	83 c4 10             	add    $0x10,%esp
8010580f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105814:	eb 5b                	jmp    80105871 <sys_pipe+0xd1>
80105816:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105820:	8d 73 08             	lea    0x8(%ebx),%esi
80105823:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105827:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010582a:	e8 a1 e2 ff ff       	call   80103ad0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010582f:	31 d2                	xor    %edx,%edx
80105831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105838:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010583c:	85 c9                	test   %ecx,%ecx
8010583e:	74 20                	je     80105860 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105840:	83 c2 01             	add    $0x1,%edx
80105843:	83 fa 10             	cmp    $0x10,%edx
80105846:	75 f0                	jne    80105838 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105848:	e8 83 e2 ff ff       	call   80103ad0 <myproc>
8010584d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105854:	00 
80105855:	eb a1                	jmp    801057f8 <sys_pipe+0x58>
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105860:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105864:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105867:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105869:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010586c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010586f:	31 c0                	xor    %eax,%eax
}
80105871:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105874:	5b                   	pop    %ebx
80105875:	5e                   	pop    %esi
80105876:	5f                   	pop    %edi
80105877:	5d                   	pop    %ebp
80105878:	c3                   	ret    
80105879:	66 90                	xchg   %ax,%ax
8010587b:	66 90                	xchg   %ax,%ax
8010587d:	66 90                	xchg   %ax,%ax
8010587f:	90                   	nop

80105880 <sys_getticks>:
  struct proc proc[NPROC];
} ptable;

int
sys_getticks(void)
{
80105880:	f3 0f 1e fb          	endbr32 
    return ticks; // Return current ticks since boot
}
80105884:	a1 a0 80 11 80       	mov    0x801180a0,%eax
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105890 <sys_cps>:

int
sys_cps(void)
{
80105890:	f3 0f 1e fb          	endbr32 
  return cps();
80105894:	e9 47 e0 ff ff       	jmp    801038e0 <cps>
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_chpr>:
}

int
sys_chpr(void)
{
801058a0:	f3 0f 1e fb          	endbr32 
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	83 ec 20             	sub    $0x20,%esp
  int pid, pr;
  if(argint(0, &pid) < 0)
801058aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058ad:	50                   	push   %eax
801058ae:	6a 00                	push   $0x0
801058b0:	e8 7b f2 ff ff       	call   80104b30 <argint>
801058b5:	83 c4 10             	add    $0x10,%esp
801058b8:	85 c0                	test   %eax,%eax
801058ba:	78 2c                	js     801058e8 <sys_chpr+0x48>
    return -1;
  if(argint(1, &pr) < 0)
801058bc:	83 ec 08             	sub    $0x8,%esp
801058bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058c2:	50                   	push   %eax
801058c3:	6a 01                	push   $0x1
801058c5:	e8 66 f2 ff ff       	call   80104b30 <argint>
801058ca:	83 c4 10             	add    $0x10,%esp
801058cd:	85 c0                	test   %eax,%eax
801058cf:	78 17                	js     801058e8 <sys_chpr+0x48>
    return -1;

  return chpr(pid, pr);
801058d1:	83 ec 08             	sub    $0x8,%esp
801058d4:	ff 75 f4             	pushl  -0xc(%ebp)
801058d7:	ff 75 f0             	pushl  -0x10(%ebp)
801058da:	e8 e1 e0 ff ff       	call   801039c0 <chpr>
801058df:	83 c4 10             	add    $0x10,%esp
}
801058e2:	c9                   	leave  
801058e3:	c3                   	ret    
801058e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058e8:	c9                   	leave  
    return -1;
801058e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058ee:	c3                   	ret    
801058ef:	90                   	nop

801058f0 <sys_ps>:




int sys_ps(void) {
801058f0:	f3 0f 1e fb          	endbr32 
801058f4:	55                   	push   %ebp
801058f5:	89 e5                	mov    %esp,%ebp
801058f7:	53                   	push   %ebx
801058f8:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
801058fd:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    cprintf("Name\tpid\tstatus\tStart time\tend time\ttotal time\tpriority\n");
80105900:	68 98 83 10 80       	push   $0x80108398
80105905:	e8 a6 ad ff ff       	call   801006b0 <cprintf>

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010590a:	83 c4 10             	add    $0x10,%esp
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
	cprintf("%s\t", p->name);
80105910:	83 ec 08             	sub    $0x8,%esp
80105913:	53                   	push   %ebx
80105914:	68 39 84 10 80       	push   $0x80108439
80105919:	e8 92 ad ff ff       	call   801006b0 <cprintf>
        cprintf("%d\t", p->pid);
8010591e:	58                   	pop    %eax
8010591f:	5a                   	pop    %edx
80105920:	ff 73 a4             	pushl  -0x5c(%ebx)
80105923:	68 3d 84 10 80       	push   $0x8010843d
80105928:	e8 83 ad ff ff       	call   801006b0 <cprintf>
        switch(p->state) {
8010592d:	83 c4 10             	add    $0x10,%esp
80105930:	83 7b a0 05          	cmpl   $0x5,-0x60(%ebx)
80105934:	77 2a                	ja     80105960 <sys_ps+0x70>
80105936:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105939:	3e ff 24 85 88 84 10 	notrack jmp *-0x7fef7b78(,%eax,4)
80105940:	80 
80105941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            case UNUSED: cprintf("UNUSED"); break;
	    case EMBRYO: cprintf("EMBRYO"); break;
            case RUNNING: cprintf("RUNNING"); break;
80105948:	83 ec 0c             	sub    $0xc,%esp
8010594b:	68 4f 84 10 80       	push   $0x8010844f
80105950:	e8 5b ad ff ff       	call   801006b0 <cprintf>
80105955:	83 c4 10             	add    $0x10,%esp
80105958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010595f:	90                   	nop
            case SLEEPING: cprintf("SLEEPING"); break;
            case RUNNABLE: cprintf("RUNNABLE"); break;
            case ZOMBIE: cprintf("ZOMBIE"); break;
        }
        cprintf("\t%d\t%d\t%d\t%d\n", p->start_time,p->end_time,p->total_time,p->priority);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	ff 73 78             	pushl  0x78(%ebx)
80105966:	81 c3 ec 00 00 00    	add    $0xec,%ebx
8010596c:	ff b3 2c ff ff ff    	pushl  -0xd4(%ebx)
80105972:	ff b3 28 ff ff ff    	pushl  -0xd8(%ebx)
80105978:	ff b3 30 ff ff ff    	pushl  -0xd0(%ebx)
8010597e:	68 70 84 10 80       	push   $0x80108470
80105983:	e8 28 ad ff ff       	call   801006b0 <cprintf>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105988:	83 c4 20             	add    $0x20,%esp
8010598b:	81 fb c0 78 11 80    	cmp    $0x801178c0,%ebx
80105991:	0f 85 79 ff ff ff    	jne    80105910 <sys_ps+0x20>
    }

    return 0;
}
80105997:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010599a:	31 c0                	xor    %eax,%eax
8010599c:	c9                   	leave  
8010599d:	c3                   	ret    
8010599e:	66 90                	xchg   %ax,%ax
            case RUNNABLE: cprintf("RUNNABLE"); break;
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	68 60 84 10 80       	push   $0x80108460
801059a8:	e8 03 ad ff ff       	call   801006b0 <cprintf>
801059ad:	83 c4 10             	add    $0x10,%esp
801059b0:	eb ae                	jmp    80105960 <sys_ps+0x70>
801059b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            case SLEEPING: cprintf("SLEEPING"); break;
801059b8:	83 ec 0c             	sub    $0xc,%esp
801059bb:	68 57 84 10 80       	push   $0x80108457
801059c0:	e8 eb ac ff ff       	call   801006b0 <cprintf>
801059c5:	83 c4 10             	add    $0x10,%esp
801059c8:	eb 96                	jmp    80105960 <sys_ps+0x70>
801059ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	    case EMBRYO: cprintf("EMBRYO"); break;
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	68 48 84 10 80       	push   $0x80108448
801059d8:	e8 d3 ac ff ff       	call   801006b0 <cprintf>
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	e9 7b ff ff ff       	jmp    80105960 <sys_ps+0x70>
801059e5:	8d 76 00             	lea    0x0(%esi),%esi
            case ZOMBIE: cprintf("ZOMBIE"); break;
801059e8:	83 ec 0c             	sub    $0xc,%esp
801059eb:	68 69 84 10 80       	push   $0x80108469
801059f0:	e8 bb ac ff ff       	call   801006b0 <cprintf>
801059f5:	83 c4 10             	add    $0x10,%esp
801059f8:	e9 63 ff ff ff       	jmp    80105960 <sys_ps+0x70>
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
            case UNUSED: cprintf("UNUSED"); break;
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	68 41 84 10 80       	push   $0x80108441
80105a08:	e8 a3 ac ff ff       	call   801006b0 <cprintf>
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	e9 4b ff ff ff       	jmp    80105960 <sys_ps+0x70>
80105a15:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a20 <sys_waitx>:


int sys_waitx(int* waittime, int* runtime)
{
80105a20:	f3 0f 1e fb          	endbr32 
80105a24:	55                   	push   %ebp
80105a25:	89 e5                	mov    %esp,%ebp
80105a27:	57                   	push   %edi
80105a28:	56                   	push   %esi
    struct proc *p;
    int havekids, pid;

    // Use argptr to safely get arguments from user space
    if(argptr(0, (void*)&waittime, sizeof(waittime)) < 0)
80105a29:	8d 45 08             	lea    0x8(%ebp),%eax
{
80105a2c:	53                   	push   %ebx
80105a2d:	83 ec 10             	sub    $0x10,%esp
    if(argptr(0, (void*)&waittime, sizeof(waittime)) < 0)
80105a30:	6a 04                	push   $0x4
80105a32:	50                   	push   %eax
80105a33:	6a 00                	push   $0x0
80105a35:	e8 46 f1 ff ff       	call   80104b80 <argptr>
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	85 c0                	test   %eax,%eax
80105a3f:	0f 88 7b 01 00 00    	js     80105bc0 <sys_waitx+0x1a0>
        return -1;

    if(argptr(1, (void*)&runtime, sizeof(runtime)) < 0)
80105a45:	83 ec 04             	sub    $0x4,%esp
80105a48:	8d 45 0c             	lea    0xc(%ebp),%eax
80105a4b:	6a 04                	push   $0x4
80105a4d:	50                   	push   %eax
80105a4e:	6a 01                	push   $0x1
80105a50:	e8 2b f1 ff ff       	call   80104b80 <argptr>
80105a55:	83 c4 10             	add    $0x10,%esp
80105a58:	85 c0                	test   %eax,%eax
80105a5a:	0f 88 60 01 00 00    	js     80105bc0 <sys_waitx+0x1a0>
        return -1;

    acquire(&ptable.lock);
80105a60:	83 ec 0c             	sub    $0xc,%esp
80105a63:	68 20 3d 11 80       	push   $0x80113d20
80105a68:	e8 d3 ec ff ff       	call   80104740 <acquire>
80105a6d:	83 c4 10             	add    $0x10,%esp
    for(;;) {
        havekids = 0;
80105a70:	31 ff                	xor    %edi,%edi
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105a72:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80105a77:	eb 15                	jmp    80105a8e <sys_waitx+0x6e>
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a80:	81 c3 ec 00 00 00    	add    $0xec,%ebx
80105a86:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80105a8c:	74 25                	je     80105ab3 <sys_waitx+0x93>
            if(p->parent != myproc())
80105a8e:	8b 73 14             	mov    0x14(%ebx),%esi
80105a91:	e8 3a e0 ff ff       	call   80103ad0 <myproc>
80105a96:	39 c6                	cmp    %eax,%esi
80105a98:	75 e6                	jne    80105a80 <sys_waitx+0x60>
                continue;
            havekids = 1;
            if(p->state == ZOMBIE) {
80105a9a:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80105a9e:	74 48                	je     80105ae8 <sys_waitx+0xc8>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105aa0:	81 c3 ec 00 00 00    	add    $0xec,%ebx
            havekids = 1;
80105aa6:	bf 01 00 00 00       	mov    $0x1,%edi
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105aab:	81 fb 54 78 11 80    	cmp    $0x80117854,%ebx
80105ab1:	75 db                	jne    80105a8e <sys_waitx+0x6e>
                release(&ptable.lock);
                return pid;
            }
        }

        if(!havekids || myproc()->killed) {
80105ab3:	85 ff                	test   %edi,%edi
80105ab5:	0f 84 ee 00 00 00    	je     80105ba9 <sys_waitx+0x189>
80105abb:	e8 10 e0 ff ff       	call   80103ad0 <myproc>
80105ac0:	8b 40 24             	mov    0x24(%eax),%eax
80105ac3:	85 c0                	test   %eax,%eax
80105ac5:	0f 85 de 00 00 00    	jne    80105ba9 <sys_waitx+0x189>
            release(&ptable.lock);
            return -1;
        }

        // Keep waiting
        sleep(myproc(), &ptable.lock);
80105acb:	e8 00 e0 ff ff       	call   80103ad0 <myproc>
80105ad0:	83 ec 08             	sub    $0x8,%esp
80105ad3:	68 20 3d 11 80       	push   $0x80113d20
80105ad8:	50                   	push   %eax
80105ad9:	e8 02 e6 ff ff       	call   801040e0 <sleep>
        havekids = 0;
80105ade:	83 c4 10             	add    $0x10,%esp
80105ae1:	eb 8d                	jmp    80105a70 <sys_waitx+0x50>
80105ae3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ae7:	90                   	nop
                *waittime = p->end_time - p->creation_time - p->total_time;
80105ae8:	8b 55 08             	mov    0x8(%ebp),%edx
80105aeb:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
                strncpy(p->last_3_unused[p->last_index].name, p->name, sizeof(p->name));
80105af1:	83 ec 04             	sub    $0x4,%esp
                *waittime = p->end_time - p->creation_time - p->total_time;
80105af4:	2b 43 7c             	sub    0x7c(%ebx),%eax
80105af7:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
                pid = p->pid;
80105afd:	8b 73 10             	mov    0x10(%ebx),%esi
                *waittime = p->end_time - p->creation_time - p->total_time;
80105b00:	89 02                	mov    %eax,(%edx)
                *runtime = p->total_time;
80105b02:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80105b08:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b0b:	89 10                	mov    %edx,(%eax)
                p->last_3_unused[p->last_index].pid = p->pid;
80105b0d:	6b 83 e0 00 00 00 1c 	imul   $0x1c,0xe0(%ebx),%eax
80105b14:	8b 53 10             	mov    0x10(%ebx),%edx
                strncpy(p->last_3_unused[p->last_index].name, p->name, sizeof(p->name));
80105b17:	6a 10                	push   $0x10
                p->last_3_unused[p->last_index].pid = p->pid;
80105b19:	89 94 03 8c 00 00 00 	mov    %edx,0x8c(%ebx,%eax,1)
                strncpy(p->last_3_unused[p->last_index].name, p->name, sizeof(p->name));
80105b20:	8d 53 6c             	lea    0x6c(%ebx),%edx
80105b23:	8d 84 03 90 00 00 00 	lea    0x90(%ebx,%eax,1),%eax
80105b2a:	52                   	push   %edx
80105b2b:	50                   	push   %eax
80105b2c:	e8 7f ee ff ff       	call   801049b0 <strncpy>
                p->last_3_unused[p->last_index].start_time = p->start_time;
80105b31:	8b 8b e0 00 00 00    	mov    0xe0(%ebx),%ecx
80105b37:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
80105b3d:	6b c1 1c             	imul   $0x1c,%ecx,%eax
                p->last_index = (p->last_index + 1) % 3;  // Ensure it cycles between 0-2
80105b40:	83 c1 01             	add    $0x1,%ecx
                p->last_3_unused[p->last_index].start_time = p->start_time;
80105b43:	01 d8                	add    %ebx,%eax
80105b45:	89 90 a0 00 00 00    	mov    %edx,0xa0(%eax)
                p->last_3_unused[p->last_index].total_time = p->total_time;
80105b4b:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80105b51:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
                p->last_index = (p->last_index + 1) % 3;  // Ensure it cycles between 0-2
80105b57:	89 c8                	mov    %ecx,%eax
80105b59:	ba 56 55 55 55       	mov    $0x55555556,%edx
80105b5e:	f7 ea                	imul   %edx
80105b60:	89 c8                	mov    %ecx,%eax
80105b62:	c1 f8 1f             	sar    $0x1f,%eax
80105b65:	29 c2                	sub    %eax,%edx
80105b67:	8d 04 52             	lea    (%edx,%edx,2),%eax
                kfree(p->kstack);
80105b6a:	5a                   	pop    %edx
80105b6b:	ff 73 08             	pushl  0x8(%ebx)
                p->last_index = (p->last_index + 1) % 3;  // Ensure it cycles between 0-2
80105b6e:	29 c1                	sub    %eax,%ecx
80105b70:	89 8b e0 00 00 00    	mov    %ecx,0xe0(%ebx)
                kfree(p->kstack);
80105b76:	e8 05 c9 ff ff       	call   80102480 <kfree>
                release(&ptable.lock);
80105b7b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
                p->state = UNUSED;
80105b82:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
80105b89:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->killed = 0;
80105b90:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                release(&ptable.lock);
80105b97:	e8 64 ec ff ff       	call   80104800 <release>
                return pid;
80105b9c:	83 c4 10             	add    $0x10,%esp
    }
}
80105b9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba2:	89 f0                	mov    %esi,%eax
80105ba4:	5b                   	pop    %ebx
80105ba5:	5e                   	pop    %esi
80105ba6:	5f                   	pop    %edi
80105ba7:	5d                   	pop    %ebp
80105ba8:	c3                   	ret    
            release(&ptable.lock);
80105ba9:	83 ec 0c             	sub    $0xc,%esp
            return -1;
80105bac:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
80105bb1:	68 20 3d 11 80       	push   $0x80113d20
80105bb6:	e8 45 ec ff ff       	call   80104800 <release>
            return -1;
80105bbb:	83 c4 10             	add    $0x10,%esp
80105bbe:	eb df                	jmp    80105b9f <sys_waitx+0x17f>
        return -1;
80105bc0:	be ff ff ff ff       	mov    $0xffffffff,%esi
80105bc5:	eb d8                	jmp    80105b9f <sys_waitx+0x17f>
80105bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bce:	66 90                	xchg   %ax,%ax

80105bd0 <tolower_kernel>:



int tolower_kernel(int c) {
80105bd0:	f3 0f 1e fb          	endbr32 
80105bd4:	55                   	push   %ebp
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	8b 45 08             	mov    0x8(%ebp),%eax
    if (c >= 'A' && c <= 'Z') {
        return c + 'a' - 'A';
    }
    return c;
}
80105bda:	5d                   	pop    %ebp
    if (c >= 'A' && c <= 'Z') {
80105bdb:	8d 48 bf             	lea    -0x41(%eax),%ecx
        return c + 'a' - 'A';
80105bde:	8d 50 20             	lea    0x20(%eax),%edx
80105be1:	83 f9 1a             	cmp    $0x1a,%ecx
80105be4:	0f 42 c2             	cmovb  %edx,%eax
}
80105be7:	c3                   	ret    
80105be8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bef:	90                   	nop

80105bf0 <strcmp_kernel>:

int strcmp_kernel(const char *s1, const char *s2, int ignore_case) {
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	57                   	push   %edi
80105bf8:	8b 45 10             	mov    0x10(%ebp),%eax
80105bfb:	8b 7d 08             	mov    0x8(%ebp),%edi
80105bfe:	56                   	push   %esi
80105bff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105c02:	53                   	push   %ebx
80105c03:	0f b6 17             	movzbl (%edi),%edx
    if (ignore_case) {
80105c06:	85 c0                	test   %eax,%eax
80105c08:	0f 84 80 00 00 00    	je     80105c8e <strcmp_kernel+0x9e>
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105c0e:	84 d2                	test   %dl,%dl
80105c10:	0f 84 8a 00 00 00    	je     80105ca0 <strcmp_kernel+0xb0>
80105c16:	89 7d 08             	mov    %edi,0x8(%ebp)
80105c19:	eb 16                	jmp    80105c31 <strcmp_kernel+0x41>
80105c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop
            s1++;
80105c20:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105c24:	8b 45 08             	mov    0x8(%ebp),%eax
            s2++;
80105c27:	83 c1 01             	add    $0x1,%ecx
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105c2a:	0f b6 10             	movzbl (%eax),%edx
80105c2d:	84 d2                	test   %dl,%dl
80105c2f:	74 6f                	je     80105ca0 <strcmp_kernel+0xb0>
80105c31:	0f be c2             	movsbl %dl,%eax
    if (c >= 'A' && c <= 'Z') {
80105c34:	8d 70 bf             	lea    -0x41(%eax),%esi
        return c + 'a' - 'A';
80105c37:	8d 58 20             	lea    0x20(%eax),%ebx
80105c3a:	83 fe 1a             	cmp    $0x1a,%esi
80105c3d:	0f 42 c3             	cmovb  %ebx,%eax
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105c40:	0f be 19             	movsbl (%ecx),%ebx
    if (c >= 'A' && c <= 'Z') {
80105c43:	8d 73 bf             	lea    -0x41(%ebx),%esi
        return c + 'a' - 'A';
80105c46:	8d 7b 20             	lea    0x20(%ebx),%edi
80105c49:	83 fe 1a             	cmp    $0x1a,%esi
80105c4c:	0f 42 df             	cmovb  %edi,%ebx
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105c4f:	39 c3                	cmp    %eax,%ebx
80105c51:	74 cd                	je     80105c20 <strcmp_kernel+0x30>
        }
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105c53:	0f b6 c2             	movzbl %dl,%eax
    if (c >= 'A' && c <= 'Z') {
80105c56:	8d 58 bf             	lea    -0x41(%eax),%ebx
        return c + 'a' - 'A';
80105c59:	8d 50 20             	lea    0x20(%eax),%edx
80105c5c:	83 fb 1a             	cmp    $0x1a,%ebx
80105c5f:	0f 42 c2             	cmovb  %edx,%eax
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105c62:	0f b6 11             	movzbl (%ecx),%edx
    if (c >= 'A' && c <= 'Z') {
80105c65:	8d 5a bf             	lea    -0x41(%edx),%ebx
        return c + 'a' - 'A';
80105c68:	8d 4a 20             	lea    0x20(%edx),%ecx
80105c6b:	83 fb 1a             	cmp    $0x1a,%ebx
            s1++;
            s2++;
        }
        return *(const unsigned char *)s1 - *(const unsigned char *)s2;
    }
}
80105c6e:	5b                   	pop    %ebx
80105c6f:	5e                   	pop    %esi
        return c + 'a' - 'A';
80105c70:	0f 42 d1             	cmovb  %ecx,%edx
}
80105c73:	5f                   	pop    %edi
80105c74:	5d                   	pop    %ebp
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105c75:	29 d0                	sub    %edx,%eax
}
80105c77:	c3                   	ret    
80105c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
        while (*s1 && (*s1 == *s2)) {
80105c80:	3a 11                	cmp    (%ecx),%dl
80105c82:	75 24                	jne    80105ca8 <strcmp_kernel+0xb8>
80105c84:	0f b6 57 01          	movzbl 0x1(%edi),%edx
            s1++;
80105c88:	83 c7 01             	add    $0x1,%edi
            s2++;
80105c8b:	83 c1 01             	add    $0x1,%ecx
        while (*s1 && (*s1 == *s2)) {
80105c8e:	84 d2                	test   %dl,%dl
80105c90:	75 ee                	jne    80105c80 <strcmp_kernel+0x90>
        return *(const unsigned char *)s1 - *(const unsigned char *)s2;
80105c92:	0f b6 11             	movzbl (%ecx),%edx
}
80105c95:	5b                   	pop    %ebx
80105c96:	5e                   	pop    %esi
80105c97:	5f                   	pop    %edi
        return *(const unsigned char *)s1 - *(const unsigned char *)s2;
80105c98:	29 d0                	sub    %edx,%eax
}
80105c9a:	5d                   	pop    %ebp
80105c9b:	c3                   	ret    
80105c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105ca0:	31 c0                	xor    %eax,%eax
80105ca2:	eb be                	jmp    80105c62 <strcmp_kernel+0x72>
80105ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ca8:	0f b6 c2             	movzbl %dl,%eax
80105cab:	eb e5                	jmp    80105c92 <strcmp_kernel+0xa2>
80105cad:	8d 76 00             	lea    0x0(%esi),%esi

80105cb0 <atoi>:



int atoi(const char *s) {
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
80105cb5:	89 e5                	mov    %esp,%ebp
80105cb7:	53                   	push   %ebx
80105cb8:	8b 55 08             	mov    0x8(%ebp),%edx
    int n = 0;
    while ('0' <= *s && *s <= '9') {
80105cbb:	0f be 02             	movsbl (%edx),%eax
80105cbe:	8d 48 d0             	lea    -0x30(%eax),%ecx
80105cc1:	80 f9 09             	cmp    $0x9,%cl
    int n = 0;
80105cc4:	b9 00 00 00 00       	mov    $0x0,%ecx
    while ('0' <= *s && *s <= '9') {
80105cc9:	77 1a                	ja     80105ce5 <atoi+0x35>
80105ccb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ccf:	90                   	nop
        n = n*10 + *s++ - '0';
80105cd0:	83 c2 01             	add    $0x1,%edx
80105cd3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
80105cd6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
    while ('0' <= *s && *s <= '9') {
80105cda:	0f be 02             	movsbl (%edx),%eax
80105cdd:	8d 58 d0             	lea    -0x30(%eax),%ebx
80105ce0:	80 fb 09             	cmp    $0x9,%bl
80105ce3:	76 eb                	jbe    80105cd0 <atoi+0x20>
    }
    return n;
}
80105ce5:	89 c8                	mov    %ecx,%eax
80105ce7:	5b                   	pop    %ebx
80105ce8:	5d                   	pop    %ebp
80105ce9:	c3                   	ret    
80105cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cf0 <sys_head>:




int sys_head(void) {
80105cf0:	f3 0f 1e fb          	endbr32 
80105cf4:	55                   	push   %ebp
80105cf5:	89 e5                	mov    %esp,%ebp
80105cf7:	57                   	push   %edi
80105cf8:	56                   	push   %esi
    int lines_to_show;
    struct inode *ip;
    char buf[BUFSIZE];
    int offset = 0, n, lines_printed = 0;

    if(argstr(0, &filename1) < 0)
80105cf9:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
int sys_head(void) {
80105cff:	53                   	push   %ebx
80105d00:	81 ec 44 02 00 00    	sub    $0x244,%esp
    if(argstr(0, &filename1) < 0)
80105d06:	50                   	push   %eax
80105d07:	6a 00                	push   $0x0
80105d09:	e8 d2 ee ff ff       	call   80104be0 <argstr>
80105d0e:	83 c4 10             	add    $0x10,%esp
80105d11:	85 c0                	test   %eax,%eax
80105d13:	0f 88 7d 01 00 00    	js     80105e96 <sys_head+0x1a6>
        return -1;

    if(argint(1, &lines_to_show) < 0)
80105d19:	83 ec 08             	sub    $0x8,%esp
80105d1c:	8d 85 e4 fd ff ff    	lea    -0x21c(%ebp),%eax
80105d22:	50                   	push   %eax
80105d23:	6a 01                	push   $0x1
80105d25:	e8 06 ee ff ff       	call   80104b30 <argint>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	85 c0                	test   %eax,%eax
80105d2f:	79 0a                	jns    80105d3b <sys_head+0x4b>
        lines_to_show = 10;  // Default value if no second argument is provided
80105d31:	c7 85 e4 fd ff ff 0a 	movl   $0xa,-0x21c(%ebp)
80105d38:	00 00 00 

    // Fetch inode for filename1
    if((ip = namei(filename1)) == 0)
80105d3b:	83 ec 0c             	sub    $0xc,%esp
80105d3e:	ff b5 e0 fd ff ff    	pushl  -0x220(%ebp)
80105d44:	e8 f7 c2 ff ff       	call   80102040 <namei>
80105d49:	83 c4 10             	add    $0x10,%esp
80105d4c:	89 85 c4 fd ff ff    	mov    %eax,-0x23c(%ebp)
80105d52:	85 c0                	test   %eax,%eax
80105d54:	0f 84 3c 01 00 00    	je     80105e96 <sys_head+0x1a6>
        return -1;

    ilock(ip);
80105d5a:	83 ec 0c             	sub    $0xc,%esp
    int offset = 0, n, lines_printed = 0;
80105d5d:	31 ff                	xor    %edi,%edi
80105d5f:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
    ilock(ip);
80105d65:	50                   	push   %eax
80105d66:	e8 05 ba ff ff       	call   80101770 <ilock>

    cprintf("Head command is getting executed in kernel mode\n");
80105d6b:	c7 04 24 d4 83 10 80 	movl   $0x801083d4,(%esp)
80105d72:	e8 39 a9 ff ff       	call   801006b0 <cprintf>

    int line_start = 0;
    while((n = readi(ip, buf, offset, sizeof(buf) - 1)) > 0 && lines_printed < lines_to_show) { // Added condition to stop once we've printed enough lines
80105d77:	83 c4 10             	add    $0x10,%esp
80105d7a:	89 fa                	mov    %edi,%edx
    int offset = 0, n, lines_printed = 0;
80105d7c:	c7 85 c8 fd ff ff 00 	movl   $0x0,-0x238(%ebp)
80105d83:	00 00 00 
80105d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8d:	8d 76 00             	lea    0x0(%esi),%esi
    while((n = readi(ip, buf, offset, sizeof(buf) - 1)) > 0 && lines_printed < lines_to_show) { // Added condition to stop once we've printed enough lines
80105d90:	68 ff 01 00 00       	push   $0x1ff
80105d95:	ff b5 c8 fd ff ff    	pushl  -0x238(%ebp)
80105d9b:	56                   	push   %esi
80105d9c:	ff b5 c4 fd ff ff    	pushl  -0x23c(%ebp)
80105da2:	89 95 d4 fd ff ff    	mov    %edx,-0x22c(%ebp)
80105da8:	e8 c3 bc ff ff       	call   80101a70 <readi>
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	89 c7                	mov    %eax,%edi
80105db2:	85 c0                	test   %eax,%eax
80105db4:	0f 8e c1 00 00 00    	jle    80105e7b <sys_head+0x18b>
80105dba:	8b 95 d4 fd ff ff    	mov    -0x22c(%ebp),%edx
80105dc0:	39 95 e4 fd ff ff    	cmp    %edx,-0x21c(%ebp)
80105dc6:	0f 8e af 00 00 00    	jle    80105e7b <sys_head+0x18b>
        buf[n] = '\0'; // Ensure null termination
80105dcc:	8d 47 ff             	lea    -0x1(%edi),%eax
80105dcf:	c6 84 3d e8 fd ff ff 	movb   $0x0,-0x218(%ebp,%edi,1)
80105dd6:	00 
80105dd7:	31 db                	xor    %ebx,%ebx
80105dd9:	89 85 d0 fd ff ff    	mov    %eax,-0x230(%ebp)
80105ddf:	31 c0                	xor    %eax,%eax
80105de1:	89 bd d4 fd ff ff    	mov    %edi,-0x22c(%ebp)
80105de7:	89 d7                	mov    %edx,%edi
80105de9:	eb 10                	jmp    80105dfb <sys_head+0x10b>
80105deb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
80105df0:	83 c3 01             	add    $0x1,%ebx
        
        for(int i = 0; i < n; i++) {
80105df3:	3b 9d d4 fd ff ff    	cmp    -0x22c(%ebp),%ebx
80105df9:	7d 4a                	jge    80105e45 <sys_head+0x155>
            if(buf[i] == '\n' || i == n-1) {
80105dfb:	80 3c 1e 0a          	cmpb   $0xa,(%esi,%ebx,1)
80105dff:	74 08                	je     80105e09 <sys_head+0x119>
80105e01:	39 9d d0 fd ff ff    	cmp    %ebx,-0x230(%ebp)
80105e07:	75 e7                	jne    80105df0 <sys_head+0x100>
                buf[i] = '\0'; // Null-terminate the line
                
                cprintf("%s\n", buf + line_start);
80105e09:	83 ec 08             	sub    $0x8,%esp
80105e0c:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
                buf[i] = '\0'; // Null-terminate the line
80105e0f:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
                lines_printed++;
80105e13:	83 c7 01             	add    $0x1,%edi
                cprintf("%s\n", buf + line_start);
80105e16:	51                   	push   %ecx
80105e17:	68 81 84 10 80       	push   $0x80108481
80105e1c:	89 85 cc fd ff ff    	mov    %eax,-0x234(%ebp)
80105e22:	e8 89 a8 ff ff       	call   801006b0 <cprintf>

                if (lines_printed >= lines_to_show) {
80105e27:	83 c4 10             	add    $0x10,%esp
80105e2a:	39 bd e4 fd ff ff    	cmp    %edi,-0x21c(%ebp)
80105e30:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
80105e36:	7e 0d                	jle    80105e45 <sys_head+0x155>
                    break;  // Exit if we've printed enough lines
                }
                
                line_start = i + 1;  // Mark the start of the next line
80105e38:	83 c3 01             	add    $0x1,%ebx
80105e3b:	89 d8                	mov    %ebx,%eax
        for(int i = 0; i < n; i++) {
80105e3d:	3b 9d d4 fd ff ff    	cmp    -0x22c(%ebp),%ebx
80105e43:	7c b6                	jl     80105dfb <sys_head+0x10b>
            }
        }

        // If buffer doesn't end with a newline, adjust offset
        if (buf[n-1] != '\n') {
80105e45:	8b 8d d0 fd ff ff    	mov    -0x230(%ebp),%ecx
80105e4b:	89 fa                	mov    %edi,%edx
80105e4d:	8b bd d4 fd ff ff    	mov    -0x22c(%ebp),%edi
80105e53:	80 bc 0d e8 fd ff ff 	cmpb   $0xa,-0x218(%ebp,%ecx,1)
80105e5a:	0a 
80105e5b:	74 13                	je     80105e70 <sys_head+0x180>
            offset -= (n - line_start);
80105e5d:	29 c7                	sub    %eax,%edi
80105e5f:	29 bd c8 fd ff ff    	sub    %edi,-0x238(%ebp)
80105e65:	e9 26 ff ff ff       	jmp    80105d90 <sys_head+0xa0>
80105e6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        } else {
            offset += n;
80105e70:	01 bd c8 fd ff ff    	add    %edi,-0x238(%ebp)
80105e76:	e9 15 ff ff ff       	jmp    80105d90 <sys_head+0xa0>
        }
        line_start = 0; // Reset line start for the next buffer read
    }

    iunlockput(ip);
80105e7b:	83 ec 0c             	sub    $0xc,%esp
80105e7e:	ff b5 c4 fd ff ff    	pushl  -0x23c(%ebp)
80105e84:	e8 87 bb ff ff       	call   80101a10 <iunlockput>

    return 0;
80105e89:	83 c4 10             	add    $0x10,%esp
80105e8c:	31 c0                	xor    %eax,%eax
}
80105e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e91:	5b                   	pop    %ebx
80105e92:	5e                   	pop    %esi
80105e93:	5f                   	pop    %edi
80105e94:	5d                   	pop    %ebp
80105e95:	c3                   	ret    
        return -1;
80105e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e9b:	eb f1                	jmp    80105e8e <sys_head+0x19e>
80105e9d:	8d 76 00             	lea    0x0(%esi),%esi

80105ea0 <sys_uniq>:


int sys_uniq(void) {
80105ea0:	f3 0f 1e fb          	endbr32 
80105ea4:	55                   	push   %ebp
    char *filename1;
    struct inode *ip;
    char buf[BUFSIZE];
    char prev_line[BUFSIZE] = {0};
80105ea5:	31 c0                	xor    %eax,%eax
80105ea7:	b9 7f 00 00 00       	mov    $0x7f,%ecx
int sys_uniq(void) {
80105eac:	89 e5                	mov    %esp,%ebp
80105eae:	57                   	push   %edi
80105eaf:	56                   	push   %esi
    char prev_line[BUFSIZE] = {0};
80105eb0:	8d bd ec fd ff ff    	lea    -0x214(%ebp),%edi
int sys_uniq(void) {
80105eb6:	53                   	push   %ebx
80105eb7:	81 ec 34 04 00 00    	sub    $0x434,%esp
    char prev_line[BUFSIZE] = {0};
80105ebd:	c7 85 e8 fd ff ff 00 	movl   $0x0,-0x218(%ebp)
80105ec4:	00 00 00 
80105ec7:	f3 ab                	rep stos %eax,%es:(%edi)
    int offset = 0, n;
    int ignore_case = 0, show_count = 0, show_only_duplicated = 0;
    int count = 0;

    // Fetching the flags first (assuming flags are passed as additional arguments to sys_uniq)
    if (argint(0, &ignore_case) < 0 || argint(1, &show_count) < 0 || argint(2, &show_only_duplicated) < 0)
80105ec9:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    int ignore_case = 0, show_count = 0, show_only_duplicated = 0;
80105ecf:	c7 85 dc fb ff ff 00 	movl   $0x0,-0x424(%ebp)
80105ed6:	00 00 00 
    if (argint(0, &ignore_case) < 0 || argint(1, &show_count) < 0 || argint(2, &show_only_duplicated) < 0)
80105ed9:	50                   	push   %eax
80105eda:	6a 00                	push   $0x0
    int ignore_case = 0, show_count = 0, show_only_duplicated = 0;
80105edc:	c7 85 e0 fb ff ff 00 	movl   $0x0,-0x420(%ebp)
80105ee3:	00 00 00 
80105ee6:	c7 85 e4 fb ff ff 00 	movl   $0x0,-0x41c(%ebp)
80105eed:	00 00 00 
    if (argint(0, &ignore_case) < 0 || argint(1, &show_count) < 0 || argint(2, &show_only_duplicated) < 0)
80105ef0:	e8 3b ec ff ff       	call   80104b30 <argint>
80105ef5:	83 c4 10             	add    $0x10,%esp
80105ef8:	85 c0                	test   %eax,%eax
80105efa:	0f 88 34 02 00 00    	js     80106134 <sys_uniq+0x294>
80105f00:	83 ec 08             	sub    $0x8,%esp
80105f03:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
80105f09:	50                   	push   %eax
80105f0a:	6a 01                	push   $0x1
80105f0c:	e8 1f ec ff ff       	call   80104b30 <argint>
80105f11:	83 c4 10             	add    $0x10,%esp
80105f14:	85 c0                	test   %eax,%eax
80105f16:	0f 88 18 02 00 00    	js     80106134 <sys_uniq+0x294>
80105f1c:	83 ec 08             	sub    $0x8,%esp
80105f1f:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
80105f25:	50                   	push   %eax
80105f26:	6a 02                	push   $0x2
80105f28:	e8 03 ec ff ff       	call   80104b30 <argint>
80105f2d:	83 c4 10             	add    $0x10,%esp
80105f30:	85 c0                	test   %eax,%eax
80105f32:	0f 88 fc 01 00 00    	js     80106134 <sys_uniq+0x294>
        return -1;

    // Fetch filename after flags
    if(argstr(3, &filename1) < 0)
80105f38:	83 ec 08             	sub    $0x8,%esp
80105f3b:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
80105f41:	50                   	push   %eax
80105f42:	6a 03                	push   $0x3
80105f44:	e8 97 ec ff ff       	call   80104be0 <argstr>
80105f49:	83 c4 10             	add    $0x10,%esp
80105f4c:	85 c0                	test   %eax,%eax
80105f4e:	0f 88 e0 01 00 00    	js     80106134 <sys_uniq+0x294>
        return -1;

    // Fetch inode for filename1
    if((ip = namei(filename1)) == 0)
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	ff b5 d8 fb ff ff    	pushl  -0x428(%ebp)
80105f5d:	e8 de c0 ff ff       	call   80102040 <namei>
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	89 85 cc fb ff ff    	mov    %eax,-0x434(%ebp)
80105f6b:	85 c0                	test   %eax,%eax
80105f6d:	0f 84 c1 01 00 00    	je     80106134 <sys_uniq+0x294>
        return -1;

    ilock(ip);
80105f73:	83 ec 0c             	sub    $0xc,%esp
80105f76:	50                   	push   %eax
80105f77:	e8 f4 b7 ff ff       	call   80101770 <ilock>

    cprintf("Uniq command is getting executed in kernel mode\n");
80105f7c:	c7 04 24 08 84 10 80 	movl   $0x80108408,(%esp)
80105f83:	e8 28 a7 ff ff       	call   801006b0 <cprintf>

    while((n = readi(ip, buf, offset, sizeof(buf))) > 0) {
80105f88:	83 c4 10             	add    $0x10,%esp
    int count = 0;
80105f8b:	c7 85 d4 fb ff ff 00 	movl   $0x0,-0x42c(%ebp)
80105f92:	00 00 00 
    int offset = 0, n;
80105f95:	c7 85 d0 fb ff ff 00 	movl   $0x0,-0x430(%ebp)
80105f9c:	00 00 00 
80105f9f:	90                   	nop
    while((n = readi(ip, buf, offset, sizeof(buf))) > 0) {
80105fa0:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
80105fa6:	68 00 02 00 00       	push   $0x200
80105fab:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80105fb1:	50                   	push   %eax
80105fb2:	ff b5 cc fb ff ff    	pushl  -0x434(%ebp)
80105fb8:	e8 b3 ba ff ff       	call   80101a70 <readi>
80105fbd:	83 c4 10             	add    $0x10,%esp
80105fc0:	89 c7                	mov    %eax,%edi
80105fc2:	85 c0                	test   %eax,%eax
80105fc4:	0f 8e f6 00 00 00    	jle    801060c0 <sys_uniq+0x220>
        int line_start = 0;
        for(int i = 0; i < n; i++) {
80105fca:	31 db                	xor    %ebx,%ebx
        int line_start = 0;
80105fcc:	31 f6                	xor    %esi,%esi
80105fce:	eb 04                	jmp    80105fd4 <sys_uniq+0x134>
        for(int i = 0; i < n; i++) {
80105fd0:	39 fb                	cmp    %edi,%ebx
80105fd2:	74 52                	je     80106026 <sys_uniq+0x186>
            if(buf[i] == '\n' || i == n-1) {
80105fd4:	0f b6 84 1d e8 fb ff 	movzbl -0x418(%ebp,%ebx,1),%eax
80105fdb:	ff 
80105fdc:	89 d9                	mov    %ebx,%ecx
80105fde:	83 c3 01             	add    $0x1,%ebx
80105fe1:	3c 0a                	cmp    $0xa,%al
80105fe3:	74 07                	je     80105fec <sys_uniq+0x14c>
80105fe5:	8d 47 ff             	lea    -0x1(%edi),%eax
80105fe8:	39 c8                	cmp    %ecx,%eax
80105fea:	75 e4                	jne    80105fd0 <sys_uniq+0x130>
                buf[i] = '\0';

                if(strcmp_kernel(buf + line_start, prev_line, ignore_case) == 0) {
80105fec:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
80105ff2:	83 ec 04             	sub    $0x4,%esp
80105ff5:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
80105ffb:	01 c6                	add    %eax,%esi
80105ffd:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
                buf[i] = '\0';
80106003:	c6 84 1d e7 fb ff ff 	movb   $0x0,-0x419(%ebp,%ebx,1)
8010600a:	00 
                if(strcmp_kernel(buf + line_start, prev_line, ignore_case) == 0) {
8010600b:	50                   	push   %eax
8010600c:	56                   	push   %esi
8010600d:	e8 de fb ff ff       	call   80105bf0 <strcmp_kernel>
80106012:	83 c4 10             	add    $0x10,%esp
80106015:	85 c0                	test   %eax,%eax
80106017:	75 1f                	jne    80106038 <sys_uniq+0x198>
                    count++;
80106019:	83 85 d4 fb ff ff 01 	addl   $0x1,-0x42c(%ebp)
                        } else {
                            cprintf("%s\n", prev_line);
                        }
                    }
                    safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
                    count = 1;
80106020:	89 de                	mov    %ebx,%esi
        for(int i = 0; i < n; i++) {
80106022:	39 fb                	cmp    %edi,%ebx
80106024:	75 ae                	jne    80105fd4 <sys_uniq+0x134>
                }
                line_start = i + 1;  // mark the start of the next line
            }
        }
        offset += n;
80106026:	01 9d d0 fb ff ff    	add    %ebx,-0x430(%ebp)
8010602c:	e9 6f ff ff ff       	jmp    80105fa0 <sys_uniq+0x100>
80106031:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
80106038:	8b 85 d4 fb ff ff    	mov    -0x42c(%ebp),%eax
8010603e:	85 c0                	test   %eax,%eax
80106040:	74 36                	je     80106078 <sys_uniq+0x1d8>
80106042:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
80106048:	85 d2                	test   %edx,%edx
8010604a:	74 05                	je     80106051 <sys_uniq+0x1b1>
8010604c:	83 f8 01             	cmp    $0x1,%eax
8010604f:	74 27                	je     80106078 <sys_uniq+0x1d8>
                        if (show_count) {
80106051:	8b 8d e0 fb ff ff    	mov    -0x420(%ebp),%ecx
80106057:	85 c9                	test   %ecx,%ecx
80106059:	74 45                	je     801060a0 <sys_uniq+0x200>
                            cprintf("%d %s\n", count, prev_line);
8010605b:	83 ec 04             	sub    $0x4,%esp
8010605e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80106064:	50                   	push   %eax
80106065:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
8010606b:	68 7e 84 10 80       	push   $0x8010847e
80106070:	e8 3b a6 ff ff       	call   801006b0 <cprintf>
80106075:	83 c4 10             	add    $0x10,%esp
                    safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
80106078:	83 ec 04             	sub    $0x4,%esp
8010607b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80106081:	68 00 02 00 00       	push   $0x200
80106086:	56                   	push   %esi
                    count = 1;
80106087:	89 de                	mov    %ebx,%esi
                    safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
80106089:	50                   	push   %eax
8010608a:	e8 81 e9 ff ff       	call   80104a10 <safestrcpy>
8010608f:	83 c4 10             	add    $0x10,%esp
                    count = 1;
80106092:	c7 85 d4 fb ff ff 01 	movl   $0x1,-0x42c(%ebp)
80106099:	00 00 00 
                line_start = i + 1;  // mark the start of the next line
8010609c:	eb 84                	jmp    80106022 <sys_uniq+0x182>
8010609e:	66 90                	xchg   %ax,%ax
                            cprintf("%s\n", prev_line);
801060a0:	83 ec 08             	sub    $0x8,%esp
801060a3:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
801060a9:	50                   	push   %eax
801060aa:	68 81 84 10 80       	push   $0x80108481
801060af:	e8 fc a5 ff ff       	call   801006b0 <cprintf>
801060b4:	83 c4 10             	add    $0x10,%esp
801060b7:	eb bf                	jmp    80106078 <sys_uniq+0x1d8>
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
801060c0:	8b 85 d4 fb ff ff    	mov    -0x42c(%ebp),%eax
801060c6:	85 c0                	test   %eax,%eax
801060c8:	74 36                	je     80106100 <sys_uniq+0x260>
801060ca:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
801060d0:	85 d2                	test   %edx,%edx
801060d2:	74 05                	je     801060d9 <sys_uniq+0x239>
801060d4:	83 f8 01             	cmp    $0x1,%eax
801060d7:	74 27                	je     80106100 <sys_uniq+0x260>
        if (show_count) {
801060d9:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
801060df:	85 c0                	test   %eax,%eax
801060e1:	74 38                	je     8010611b <sys_uniq+0x27b>
            cprintf("%d %s\n", count, prev_line);
801060e3:	83 ec 04             	sub    $0x4,%esp
801060e6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
801060ec:	50                   	push   %eax
801060ed:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
801060f3:	68 7e 84 10 80       	push   $0x8010847e
801060f8:	e8 b3 a5 ff ff       	call   801006b0 <cprintf>
801060fd:	83 c4 10             	add    $0x10,%esp
        } else {
            cprintf("%s\n", prev_line);
        }
    }

    iunlockput(ip);
80106100:	83 ec 0c             	sub    $0xc,%esp
80106103:	ff b5 cc fb ff ff    	pushl  -0x434(%ebp)
80106109:	e8 02 b9 ff ff       	call   80101a10 <iunlockput>

    return 0;
8010610e:	83 c4 10             	add    $0x10,%esp
80106111:	31 c0                	xor    %eax,%eax
}
80106113:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106116:	5b                   	pop    %ebx
80106117:	5e                   	pop    %esi
80106118:	5f                   	pop    %edi
80106119:	5d                   	pop    %ebp
8010611a:	c3                   	ret    
            cprintf("%s\n", prev_line);
8010611b:	83 ec 08             	sub    $0x8,%esp
8010611e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80106124:	50                   	push   %eax
80106125:	68 81 84 10 80       	push   $0x80108481
8010612a:	e8 81 a5 ff ff       	call   801006b0 <cprintf>
8010612f:	83 c4 10             	add    $0x10,%esp
80106132:	eb cc                	jmp    80106100 <sys_uniq+0x260>
        return -1;
80106134:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106139:	eb d8                	jmp    80106113 <sys_uniq+0x273>
8010613b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010613f:	90                   	nop

80106140 <sys_fork>:



int
sys_fork(void)
{
80106140:	f3 0f 1e fb          	endbr32 
  return fork();
80106144:	e9 37 db ff ff       	jmp    80103c80 <fork>
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106150 <sys_exit>:
}

int
sys_exit(void)
{
80106150:	f3 0f 1e fb          	endbr32 
80106154:	55                   	push   %ebp
80106155:	89 e5                	mov    %esp,%ebp
80106157:	83 ec 08             	sub    $0x8,%esp
  exit();
8010615a:	e8 d1 dd ff ff       	call   80103f30 <exit>
  return 0;  // not reached
}
8010615f:	31 c0                	xor    %eax,%eax
80106161:	c9                   	leave  
80106162:	c3                   	ret    
80106163:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106170 <sys_wait>:

int
sys_wait(void)
{
80106170:	f3 0f 1e fb          	endbr32 
  return wait();
80106174:	e9 27 e0 ff ff       	jmp    801041a0 <wait>
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106180 <sys_kill>:
}

int
sys_kill(void)
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010618a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010618d:	50                   	push   %eax
8010618e:	6a 00                	push   $0x0
80106190:	e8 9b e9 ff ff       	call   80104b30 <argint>
80106195:	83 c4 10             	add    $0x10,%esp
80106198:	85 c0                	test   %eax,%eax
8010619a:	78 14                	js     801061b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010619c:	83 ec 0c             	sub    $0xc,%esp
8010619f:	ff 75 f4             	pushl  -0xc(%ebp)
801061a2:	e8 69 e1 ff ff       	call   80104310 <kill>
801061a7:	83 c4 10             	add    $0x10,%esp
}
801061aa:	c9                   	leave  
801061ab:	c3                   	ret    
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061b0:	c9                   	leave  
    return -1;
801061b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061b6:	c3                   	ret    
801061b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061be:	66 90                	xchg   %ax,%ax

801061c0 <sys_getpid>:

int
sys_getpid(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
801061c4:	55                   	push   %ebp
801061c5:	89 e5                	mov    %esp,%ebp
801061c7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801061ca:	e8 01 d9 ff ff       	call   80103ad0 <myproc>
801061cf:	8b 40 10             	mov    0x10(%eax),%eax
}
801061d2:	c9                   	leave  
801061d3:	c3                   	ret    
801061d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061df:	90                   	nop

801061e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801061e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061ee:	50                   	push   %eax
801061ef:	6a 00                	push   $0x0
801061f1:	e8 3a e9 ff ff       	call   80104b30 <argint>
801061f6:	83 c4 10             	add    $0x10,%esp
801061f9:	85 c0                	test   %eax,%eax
801061fb:	78 23                	js     80106220 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801061fd:	e8 ce d8 ff ff       	call   80103ad0 <myproc>
  if(growproc(n) < 0)
80106202:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106205:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106207:	ff 75 f4             	pushl  -0xc(%ebp)
8010620a:	e8 f1 d9 ff ff       	call   80103c00 <growproc>
8010620f:	83 c4 10             	add    $0x10,%esp
80106212:	85 c0                	test   %eax,%eax
80106214:	78 0a                	js     80106220 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106216:	89 d8                	mov    %ebx,%eax
80106218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010621b:	c9                   	leave  
8010621c:	c3                   	ret    
8010621d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106220:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106225:	eb ef                	jmp    80106216 <sys_sbrk+0x36>
80106227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622e:	66 90                	xchg   %ax,%ax

80106230 <sys_sleep>:

int
sys_sleep(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106238:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010623b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010623e:	50                   	push   %eax
8010623f:	6a 00                	push   $0x0
80106241:	e8 ea e8 ff ff       	call   80104b30 <argint>
80106246:	83 c4 10             	add    $0x10,%esp
80106249:	85 c0                	test   %eax,%eax
8010624b:	0f 88 86 00 00 00    	js     801062d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106251:	83 ec 0c             	sub    $0xc,%esp
80106254:	68 60 78 11 80       	push   $0x80117860
80106259:	e8 e2 e4 ff ff       	call   80104740 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010625e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106261:	8b 1d a0 80 11 80    	mov    0x801180a0,%ebx
  while(ticks - ticks0 < n){
80106267:	83 c4 10             	add    $0x10,%esp
8010626a:	85 d2                	test   %edx,%edx
8010626c:	75 23                	jne    80106291 <sys_sleep+0x61>
8010626e:	eb 50                	jmp    801062c0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106270:	83 ec 08             	sub    $0x8,%esp
80106273:	68 60 78 11 80       	push   $0x80117860
80106278:	68 a0 80 11 80       	push   $0x801180a0
8010627d:	e8 5e de ff ff       	call   801040e0 <sleep>
  while(ticks - ticks0 < n){
80106282:	a1 a0 80 11 80       	mov    0x801180a0,%eax
80106287:	83 c4 10             	add    $0x10,%esp
8010628a:	29 d8                	sub    %ebx,%eax
8010628c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010628f:	73 2f                	jae    801062c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106291:	e8 3a d8 ff ff       	call   80103ad0 <myproc>
80106296:	8b 40 24             	mov    0x24(%eax),%eax
80106299:	85 c0                	test   %eax,%eax
8010629b:	74 d3                	je     80106270 <sys_sleep+0x40>
      release(&tickslock);
8010629d:	83 ec 0c             	sub    $0xc,%esp
801062a0:	68 60 78 11 80       	push   $0x80117860
801062a5:	e8 56 e5 ff ff       	call   80104800 <release>
  }
  release(&tickslock);
  return 0;
}
801062aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801062ad:	83 c4 10             	add    $0x10,%esp
801062b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062b5:	c9                   	leave  
801062b6:	c3                   	ret    
801062b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062be:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	68 60 78 11 80       	push   $0x80117860
801062c8:	e8 33 e5 ff ff       	call   80104800 <release>
  return 0;
801062cd:	83 c4 10             	add    $0x10,%esp
801062d0:	31 c0                	xor    %eax,%eax
}
801062d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062d5:	c9                   	leave  
801062d6:	c3                   	ret    
    return -1;
801062d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062dc:	eb f4                	jmp    801062d2 <sys_sleep+0xa2>
801062de:	66 90                	xchg   %ax,%ax

801062e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801062e0:	f3 0f 1e fb          	endbr32 
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	53                   	push   %ebx
801062e8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801062eb:	68 60 78 11 80       	push   $0x80117860
801062f0:	e8 4b e4 ff ff       	call   80104740 <acquire>
  xticks = ticks;
801062f5:	8b 1d a0 80 11 80    	mov    0x801180a0,%ebx
  release(&tickslock);
801062fb:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
80106302:	e8 f9 e4 ff ff       	call   80104800 <release>
  return xticks;
}
80106307:	89 d8                	mov    %ebx,%eax
80106309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010630c:	c9                   	leave  
8010630d:	c3                   	ret    

8010630e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010630e:	1e                   	push   %ds
  pushl %es
8010630f:	06                   	push   %es
  pushl %fs
80106310:	0f a0                	push   %fs
  pushl %gs
80106312:	0f a8                	push   %gs
  pushal
80106314:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106315:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106319:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010631b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010631d:	54                   	push   %esp
  call trap
8010631e:	e8 cd 00 00 00       	call   801063f0 <trap>
  addl $4, %esp
80106323:	83 c4 04             	add    $0x4,%esp

80106326 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106326:	61                   	popa   
  popl %gs
80106327:	0f a9                	pop    %gs
  popl %fs
80106329:	0f a1                	pop    %fs
  popl %es
8010632b:	07                   	pop    %es
  popl %ds
8010632c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010632d:	83 c4 08             	add    $0x8,%esp
  iret
80106330:	cf                   	iret   
80106331:	66 90                	xchg   %ax,%ax
80106333:	66 90                	xchg   %ax,%ax
80106335:	66 90                	xchg   %ax,%ax
80106337:	66 90                	xchg   %ax,%ax
80106339:	66 90                	xchg   %ax,%ax
8010633b:	66 90                	xchg   %ax,%ax
8010633d:	66 90                	xchg   %ax,%ax
8010633f:	90                   	nop

80106340 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106345:	31 c0                	xor    %eax,%eax
{
80106347:	89 e5                	mov    %esp,%ebp
80106349:	83 ec 08             	sub    $0x8,%esp
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106350:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106357:	c7 04 c5 a2 78 11 80 	movl   $0x8e000008,-0x7fee875e(,%eax,8)
8010635e:	08 00 00 8e 
80106362:	66 89 14 c5 a0 78 11 	mov    %dx,-0x7fee8760(,%eax,8)
80106369:	80 
8010636a:	c1 ea 10             	shr    $0x10,%edx
8010636d:	66 89 14 c5 a6 78 11 	mov    %dx,-0x7fee875a(,%eax,8)
80106374:	80 
  for(i = 0; i < 256; i++)
80106375:	83 c0 01             	add    $0x1,%eax
80106378:	3d 00 01 00 00       	cmp    $0x100,%eax
8010637d:	75 d1                	jne    80106350 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010637f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106382:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106387:	c7 05 a2 7a 11 80 08 	movl   $0xef000008,0x80117aa2
8010638e:	00 00 ef 
  initlock(&tickslock, "time");
80106391:	68 a0 84 10 80       	push   $0x801084a0
80106396:	68 60 78 11 80       	push   $0x80117860
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010639b:	66 a3 a0 7a 11 80    	mov    %ax,0x80117aa0
801063a1:	c1 e8 10             	shr    $0x10,%eax
801063a4:	66 a3 a6 7a 11 80    	mov    %ax,0x80117aa6
  initlock(&tickslock, "time");
801063aa:	e8 11 e2 ff ff       	call   801045c0 <initlock>
}
801063af:	83 c4 10             	add    $0x10,%esp
801063b2:	c9                   	leave  
801063b3:	c3                   	ret    
801063b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063bf:	90                   	nop

801063c0 <idtinit>:

void
idtinit(void)
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
  pd[0] = size-1;
801063c5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801063ca:	89 e5                	mov    %esp,%ebp
801063cc:	83 ec 10             	sub    $0x10,%esp
801063cf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801063d3:	b8 a0 78 11 80       	mov    $0x801178a0,%eax
801063d8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801063dc:	c1 e8 10             	shr    $0x10,%eax
801063df:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801063e3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063e6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801063e9:	c9                   	leave  
801063ea:	c3                   	ret    
801063eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063ef:	90                   	nop

801063f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	57                   	push   %edi
801063f8:	56                   	push   %esi
801063f9:	53                   	push   %ebx
801063fa:	83 ec 1c             	sub    $0x1c,%esp
801063fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106400:	8b 43 30             	mov    0x30(%ebx),%eax
80106403:	83 f8 40             	cmp    $0x40,%eax
80106406:	0f 84 bc 01 00 00    	je     801065c8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010640c:	83 e8 20             	sub    $0x20,%eax
8010640f:	83 f8 1f             	cmp    $0x1f,%eax
80106412:	77 08                	ja     8010641c <trap+0x2c>
80106414:	3e ff 24 85 48 85 10 	notrack jmp *-0x7fef7ab8(,%eax,4)
8010641b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010641c:	e8 af d6 ff ff       	call   80103ad0 <myproc>
80106421:	8b 7b 38             	mov    0x38(%ebx),%edi
80106424:	85 c0                	test   %eax,%eax
80106426:	0f 84 eb 01 00 00    	je     80106617 <trap+0x227>
8010642c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106430:	0f 84 e1 01 00 00    	je     80106617 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106436:	0f 20 d1             	mov    %cr2,%ecx
80106439:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010643c:	e8 6f d6 ff ff       	call   80103ab0 <cpuid>
80106441:	8b 73 30             	mov    0x30(%ebx),%esi
80106444:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106447:	8b 43 34             	mov    0x34(%ebx),%eax
8010644a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010644d:	e8 7e d6 ff ff       	call   80103ad0 <myproc>
80106452:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106455:	e8 76 d6 ff ff       	call   80103ad0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010645a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010645d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106460:	51                   	push   %ecx
80106461:	57                   	push   %edi
80106462:	52                   	push   %edx
80106463:	ff 75 e4             	pushl  -0x1c(%ebp)
80106466:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106467:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010646a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010646d:	56                   	push   %esi
8010646e:	ff 70 10             	pushl  0x10(%eax)
80106471:	68 04 85 10 80       	push   $0x80108504
80106476:	e8 35 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010647b:	83 c4 20             	add    $0x20,%esp
8010647e:	e8 4d d6 ff ff       	call   80103ad0 <myproc>
80106483:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010648a:	e8 41 d6 ff ff       	call   80103ad0 <myproc>
8010648f:	85 c0                	test   %eax,%eax
80106491:	74 1d                	je     801064b0 <trap+0xc0>
80106493:	e8 38 d6 ff ff       	call   80103ad0 <myproc>
80106498:	8b 50 24             	mov    0x24(%eax),%edx
8010649b:	85 d2                	test   %edx,%edx
8010649d:	74 11                	je     801064b0 <trap+0xc0>
8010649f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801064a3:	83 e0 03             	and    $0x3,%eax
801064a6:	66 83 f8 03          	cmp    $0x3,%ax
801064aa:	0f 84 50 01 00 00    	je     80106600 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801064b0:	e8 1b d6 ff ff       	call   80103ad0 <myproc>
801064b5:	85 c0                	test   %eax,%eax
801064b7:	74 0f                	je     801064c8 <trap+0xd8>
801064b9:	e8 12 d6 ff ff       	call   80103ad0 <myproc>
801064be:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801064c2:	0f 84 e8 00 00 00    	je     801065b0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064c8:	e8 03 d6 ff ff       	call   80103ad0 <myproc>
801064cd:	85 c0                	test   %eax,%eax
801064cf:	74 1d                	je     801064ee <trap+0xfe>
801064d1:	e8 fa d5 ff ff       	call   80103ad0 <myproc>
801064d6:	8b 40 24             	mov    0x24(%eax),%eax
801064d9:	85 c0                	test   %eax,%eax
801064db:	74 11                	je     801064ee <trap+0xfe>
801064dd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801064e1:	83 e0 03             	and    $0x3,%eax
801064e4:	66 83 f8 03          	cmp    $0x3,%ax
801064e8:	0f 84 03 01 00 00    	je     801065f1 <trap+0x201>
    exit();
}
801064ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f1:	5b                   	pop    %ebx
801064f2:	5e                   	pop    %esi
801064f3:	5f                   	pop    %edi
801064f4:	5d                   	pop    %ebp
801064f5:	c3                   	ret    
    ideintr();
801064f6:	e8 f5 bc ff ff       	call   801021f0 <ideintr>
    lapiceoi();
801064fb:	e8 d0 c3 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106500:	e8 cb d5 ff ff       	call   80103ad0 <myproc>
80106505:	85 c0                	test   %eax,%eax
80106507:	75 8a                	jne    80106493 <trap+0xa3>
80106509:	eb a5                	jmp    801064b0 <trap+0xc0>
    if(cpuid() == 0){
8010650b:	e8 a0 d5 ff ff       	call   80103ab0 <cpuid>
80106510:	85 c0                	test   %eax,%eax
80106512:	75 e7                	jne    801064fb <trap+0x10b>
      acquire(&tickslock);
80106514:	83 ec 0c             	sub    $0xc,%esp
80106517:	68 60 78 11 80       	push   $0x80117860
8010651c:	e8 1f e2 ff ff       	call   80104740 <acquire>
      wakeup(&ticks);
80106521:	c7 04 24 a0 80 11 80 	movl   $0x801180a0,(%esp)
      ticks++;
80106528:	83 05 a0 80 11 80 01 	addl   $0x1,0x801180a0
      wakeup(&ticks);
8010652f:	e8 6c dd ff ff       	call   801042a0 <wakeup>
      release(&tickslock);
80106534:	c7 04 24 60 78 11 80 	movl   $0x80117860,(%esp)
8010653b:	e8 c0 e2 ff ff       	call   80104800 <release>
80106540:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106543:	eb b6                	jmp    801064fb <trap+0x10b>
    kbdintr();
80106545:	e8 46 c2 ff ff       	call   80102790 <kbdintr>
    lapiceoi();
8010654a:	e8 81 c3 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010654f:	e8 7c d5 ff ff       	call   80103ad0 <myproc>
80106554:	85 c0                	test   %eax,%eax
80106556:	0f 85 37 ff ff ff    	jne    80106493 <trap+0xa3>
8010655c:	e9 4f ff ff ff       	jmp    801064b0 <trap+0xc0>
    uartintr();
80106561:	e8 4a 02 00 00       	call   801067b0 <uartintr>
    lapiceoi();
80106566:	e8 65 c3 ff ff       	call   801028d0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010656b:	e8 60 d5 ff ff       	call   80103ad0 <myproc>
80106570:	85 c0                	test   %eax,%eax
80106572:	0f 85 1b ff ff ff    	jne    80106493 <trap+0xa3>
80106578:	e9 33 ff ff ff       	jmp    801064b0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010657d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106580:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106584:	e8 27 d5 ff ff       	call   80103ab0 <cpuid>
80106589:	57                   	push   %edi
8010658a:	56                   	push   %esi
8010658b:	50                   	push   %eax
8010658c:	68 ac 84 10 80       	push   $0x801084ac
80106591:	e8 1a a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106596:	e8 35 c3 ff ff       	call   801028d0 <lapiceoi>
    break;
8010659b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010659e:	e8 2d d5 ff ff       	call   80103ad0 <myproc>
801065a3:	85 c0                	test   %eax,%eax
801065a5:	0f 85 e8 fe ff ff    	jne    80106493 <trap+0xa3>
801065ab:	e9 00 ff ff ff       	jmp    801064b0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801065b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801065b4:	0f 85 0e ff ff ff    	jne    801064c8 <trap+0xd8>
    yield();
801065ba:	e8 d1 da ff ff       	call   80104090 <yield>
801065bf:	e9 04 ff ff ff       	jmp    801064c8 <trap+0xd8>
801065c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801065c8:	e8 03 d5 ff ff       	call   80103ad0 <myproc>
801065cd:	8b 70 24             	mov    0x24(%eax),%esi
801065d0:	85 f6                	test   %esi,%esi
801065d2:	75 3c                	jne    80106610 <trap+0x220>
    myproc()->tf = tf;
801065d4:	e8 f7 d4 ff ff       	call   80103ad0 <myproc>
801065d9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801065dc:	e8 3f e6 ff ff       	call   80104c20 <syscall>
    if(myproc()->killed)
801065e1:	e8 ea d4 ff ff       	call   80103ad0 <myproc>
801065e6:	8b 48 24             	mov    0x24(%eax),%ecx
801065e9:	85 c9                	test   %ecx,%ecx
801065eb:	0f 84 fd fe ff ff    	je     801064ee <trap+0xfe>
}
801065f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065f4:	5b                   	pop    %ebx
801065f5:	5e                   	pop    %esi
801065f6:	5f                   	pop    %edi
801065f7:	5d                   	pop    %ebp
      exit();
801065f8:	e9 33 d9 ff ff       	jmp    80103f30 <exit>
801065fd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106600:	e8 2b d9 ff ff       	call   80103f30 <exit>
80106605:	e9 a6 fe ff ff       	jmp    801064b0 <trap+0xc0>
8010660a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106610:	e8 1b d9 ff ff       	call   80103f30 <exit>
80106615:	eb bd                	jmp    801065d4 <trap+0x1e4>
80106617:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010661a:	e8 91 d4 ff ff       	call   80103ab0 <cpuid>
8010661f:	83 ec 0c             	sub    $0xc,%esp
80106622:	56                   	push   %esi
80106623:	57                   	push   %edi
80106624:	50                   	push   %eax
80106625:	ff 73 30             	pushl  0x30(%ebx)
80106628:	68 d0 84 10 80       	push   $0x801084d0
8010662d:	e8 7e a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106632:	83 c4 14             	add    $0x14,%esp
80106635:	68 a5 84 10 80       	push   $0x801084a5
8010663a:	e8 51 9d ff ff       	call   80100390 <panic>
8010663f:	90                   	nop

80106640 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106640:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106644:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106649:	85 c0                	test   %eax,%eax
8010664b:	74 1b                	je     80106668 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010664d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106652:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106653:	a8 01                	test   $0x1,%al
80106655:	74 11                	je     80106668 <uartgetc+0x28>
80106657:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010665c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010665d:	0f b6 c0             	movzbl %al,%eax
80106660:	c3                   	ret    
80106661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010666d:	c3                   	ret    
8010666e:	66 90                	xchg   %ax,%ax

80106670 <uartputc.part.0>:
uartputc(int c)
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	89 c7                	mov    %eax,%edi
80106676:	56                   	push   %esi
80106677:	be fd 03 00 00       	mov    $0x3fd,%esi
8010667c:	53                   	push   %ebx
8010667d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106682:	83 ec 0c             	sub    $0xc,%esp
80106685:	eb 1b                	jmp    801066a2 <uartputc.part.0+0x32>
80106687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010668e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106690:	83 ec 0c             	sub    $0xc,%esp
80106693:	6a 0a                	push   $0xa
80106695:	e8 56 c2 ff ff       	call   801028f0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010669a:	83 c4 10             	add    $0x10,%esp
8010669d:	83 eb 01             	sub    $0x1,%ebx
801066a0:	74 07                	je     801066a9 <uartputc.part.0+0x39>
801066a2:	89 f2                	mov    %esi,%edx
801066a4:	ec                   	in     (%dx),%al
801066a5:	a8 20                	test   $0x20,%al
801066a7:	74 e7                	je     80106690 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066ae:	89 f8                	mov    %edi,%eax
801066b0:	ee                   	out    %al,(%dx)
}
801066b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066b4:	5b                   	pop    %ebx
801066b5:	5e                   	pop    %esi
801066b6:	5f                   	pop    %edi
801066b7:	5d                   	pop    %ebp
801066b8:	c3                   	ret    
801066b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066c0 <uartinit>:
{
801066c0:	f3 0f 1e fb          	endbr32 
801066c4:	55                   	push   %ebp
801066c5:	31 c9                	xor    %ecx,%ecx
801066c7:	89 c8                	mov    %ecx,%eax
801066c9:	89 e5                	mov    %esp,%ebp
801066cb:	57                   	push   %edi
801066cc:	56                   	push   %esi
801066cd:	53                   	push   %ebx
801066ce:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801066d3:	89 da                	mov    %ebx,%edx
801066d5:	83 ec 0c             	sub    $0xc,%esp
801066d8:	ee                   	out    %al,(%dx)
801066d9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801066de:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801066e3:	89 fa                	mov    %edi,%edx
801066e5:	ee                   	out    %al,(%dx)
801066e6:	b8 0c 00 00 00       	mov    $0xc,%eax
801066eb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066f0:	ee                   	out    %al,(%dx)
801066f1:	be f9 03 00 00       	mov    $0x3f9,%esi
801066f6:	89 c8                	mov    %ecx,%eax
801066f8:	89 f2                	mov    %esi,%edx
801066fa:	ee                   	out    %al,(%dx)
801066fb:	b8 03 00 00 00       	mov    $0x3,%eax
80106700:	89 fa                	mov    %edi,%edx
80106702:	ee                   	out    %al,(%dx)
80106703:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106708:	89 c8                	mov    %ecx,%eax
8010670a:	ee                   	out    %al,(%dx)
8010670b:	b8 01 00 00 00       	mov    $0x1,%eax
80106710:	89 f2                	mov    %esi,%edx
80106712:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106713:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106718:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106719:	3c ff                	cmp    $0xff,%al
8010671b:	74 52                	je     8010676f <uartinit+0xaf>
  uart = 1;
8010671d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106724:	00 00 00 
80106727:	89 da                	mov    %ebx,%edx
80106729:	ec                   	in     (%dx),%al
8010672a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010672f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106730:	83 ec 08             	sub    $0x8,%esp
80106733:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106738:	bb c8 85 10 80       	mov    $0x801085c8,%ebx
  ioapicenable(IRQ_COM1, 0);
8010673d:	6a 00                	push   $0x0
8010673f:	6a 04                	push   $0x4
80106741:	e8 fa bc ff ff       	call   80102440 <ioapicenable>
80106746:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106749:	b8 78 00 00 00       	mov    $0x78,%eax
8010674e:	eb 04                	jmp    80106754 <uartinit+0x94>
80106750:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106754:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010675a:	85 d2                	test   %edx,%edx
8010675c:	74 08                	je     80106766 <uartinit+0xa6>
    uartputc(*p);
8010675e:	0f be c0             	movsbl %al,%eax
80106761:	e8 0a ff ff ff       	call   80106670 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106766:	89 f0                	mov    %esi,%eax
80106768:	83 c3 01             	add    $0x1,%ebx
8010676b:	84 c0                	test   %al,%al
8010676d:	75 e1                	jne    80106750 <uartinit+0x90>
}
8010676f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106772:	5b                   	pop    %ebx
80106773:	5e                   	pop    %esi
80106774:	5f                   	pop    %edi
80106775:	5d                   	pop    %ebp
80106776:	c3                   	ret    
80106777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010677e:	66 90                	xchg   %ax,%ax

80106780 <uartputc>:
{
80106780:	f3 0f 1e fb          	endbr32 
80106784:	55                   	push   %ebp
  if(!uart)
80106785:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010678b:	89 e5                	mov    %esp,%ebp
8010678d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106790:	85 d2                	test   %edx,%edx
80106792:	74 0c                	je     801067a0 <uartputc+0x20>
}
80106794:	5d                   	pop    %ebp
80106795:	e9 d6 fe ff ff       	jmp    80106670 <uartputc.part.0>
8010679a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067a0:	5d                   	pop    %ebp
801067a1:	c3                   	ret    
801067a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067b0 <uartintr>:

void
uartintr(void)
{
801067b0:	f3 0f 1e fb          	endbr32 
801067b4:	55                   	push   %ebp
801067b5:	89 e5                	mov    %esp,%ebp
801067b7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801067ba:	68 40 66 10 80       	push   $0x80106640
801067bf:	e8 9c a0 ff ff       	call   80100860 <consoleintr>
}
801067c4:	83 c4 10             	add    $0x10,%esp
801067c7:	c9                   	leave  
801067c8:	c3                   	ret    

801067c9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $0
801067cb:	6a 00                	push   $0x0
  jmp alltraps
801067cd:	e9 3c fb ff ff       	jmp    8010630e <alltraps>

801067d2 <vector1>:
.globl vector1
vector1:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $1
801067d4:	6a 01                	push   $0x1
  jmp alltraps
801067d6:	e9 33 fb ff ff       	jmp    8010630e <alltraps>

801067db <vector2>:
.globl vector2
vector2:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $2
801067dd:	6a 02                	push   $0x2
  jmp alltraps
801067df:	e9 2a fb ff ff       	jmp    8010630e <alltraps>

801067e4 <vector3>:
.globl vector3
vector3:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $3
801067e6:	6a 03                	push   $0x3
  jmp alltraps
801067e8:	e9 21 fb ff ff       	jmp    8010630e <alltraps>

801067ed <vector4>:
.globl vector4
vector4:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $4
801067ef:	6a 04                	push   $0x4
  jmp alltraps
801067f1:	e9 18 fb ff ff       	jmp    8010630e <alltraps>

801067f6 <vector5>:
.globl vector5
vector5:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $5
801067f8:	6a 05                	push   $0x5
  jmp alltraps
801067fa:	e9 0f fb ff ff       	jmp    8010630e <alltraps>

801067ff <vector6>:
.globl vector6
vector6:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $6
80106801:	6a 06                	push   $0x6
  jmp alltraps
80106803:	e9 06 fb ff ff       	jmp    8010630e <alltraps>

80106808 <vector7>:
.globl vector7
vector7:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $7
8010680a:	6a 07                	push   $0x7
  jmp alltraps
8010680c:	e9 fd fa ff ff       	jmp    8010630e <alltraps>

80106811 <vector8>:
.globl vector8
vector8:
  pushl $8
80106811:	6a 08                	push   $0x8
  jmp alltraps
80106813:	e9 f6 fa ff ff       	jmp    8010630e <alltraps>

80106818 <vector9>:
.globl vector9
vector9:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $9
8010681a:	6a 09                	push   $0x9
  jmp alltraps
8010681c:	e9 ed fa ff ff       	jmp    8010630e <alltraps>

80106821 <vector10>:
.globl vector10
vector10:
  pushl $10
80106821:	6a 0a                	push   $0xa
  jmp alltraps
80106823:	e9 e6 fa ff ff       	jmp    8010630e <alltraps>

80106828 <vector11>:
.globl vector11
vector11:
  pushl $11
80106828:	6a 0b                	push   $0xb
  jmp alltraps
8010682a:	e9 df fa ff ff       	jmp    8010630e <alltraps>

8010682f <vector12>:
.globl vector12
vector12:
  pushl $12
8010682f:	6a 0c                	push   $0xc
  jmp alltraps
80106831:	e9 d8 fa ff ff       	jmp    8010630e <alltraps>

80106836 <vector13>:
.globl vector13
vector13:
  pushl $13
80106836:	6a 0d                	push   $0xd
  jmp alltraps
80106838:	e9 d1 fa ff ff       	jmp    8010630e <alltraps>

8010683d <vector14>:
.globl vector14
vector14:
  pushl $14
8010683d:	6a 0e                	push   $0xe
  jmp alltraps
8010683f:	e9 ca fa ff ff       	jmp    8010630e <alltraps>

80106844 <vector15>:
.globl vector15
vector15:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $15
80106846:	6a 0f                	push   $0xf
  jmp alltraps
80106848:	e9 c1 fa ff ff       	jmp    8010630e <alltraps>

8010684d <vector16>:
.globl vector16
vector16:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $16
8010684f:	6a 10                	push   $0x10
  jmp alltraps
80106851:	e9 b8 fa ff ff       	jmp    8010630e <alltraps>

80106856 <vector17>:
.globl vector17
vector17:
  pushl $17
80106856:	6a 11                	push   $0x11
  jmp alltraps
80106858:	e9 b1 fa ff ff       	jmp    8010630e <alltraps>

8010685d <vector18>:
.globl vector18
vector18:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $18
8010685f:	6a 12                	push   $0x12
  jmp alltraps
80106861:	e9 a8 fa ff ff       	jmp    8010630e <alltraps>

80106866 <vector19>:
.globl vector19
vector19:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $19
80106868:	6a 13                	push   $0x13
  jmp alltraps
8010686a:	e9 9f fa ff ff       	jmp    8010630e <alltraps>

8010686f <vector20>:
.globl vector20
vector20:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $20
80106871:	6a 14                	push   $0x14
  jmp alltraps
80106873:	e9 96 fa ff ff       	jmp    8010630e <alltraps>

80106878 <vector21>:
.globl vector21
vector21:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $21
8010687a:	6a 15                	push   $0x15
  jmp alltraps
8010687c:	e9 8d fa ff ff       	jmp    8010630e <alltraps>

80106881 <vector22>:
.globl vector22
vector22:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $22
80106883:	6a 16                	push   $0x16
  jmp alltraps
80106885:	e9 84 fa ff ff       	jmp    8010630e <alltraps>

8010688a <vector23>:
.globl vector23
vector23:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $23
8010688c:	6a 17                	push   $0x17
  jmp alltraps
8010688e:	e9 7b fa ff ff       	jmp    8010630e <alltraps>

80106893 <vector24>:
.globl vector24
vector24:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $24
80106895:	6a 18                	push   $0x18
  jmp alltraps
80106897:	e9 72 fa ff ff       	jmp    8010630e <alltraps>

8010689c <vector25>:
.globl vector25
vector25:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $25
8010689e:	6a 19                	push   $0x19
  jmp alltraps
801068a0:	e9 69 fa ff ff       	jmp    8010630e <alltraps>

801068a5 <vector26>:
.globl vector26
vector26:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $26
801068a7:	6a 1a                	push   $0x1a
  jmp alltraps
801068a9:	e9 60 fa ff ff       	jmp    8010630e <alltraps>

801068ae <vector27>:
.globl vector27
vector27:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $27
801068b0:	6a 1b                	push   $0x1b
  jmp alltraps
801068b2:	e9 57 fa ff ff       	jmp    8010630e <alltraps>

801068b7 <vector28>:
.globl vector28
vector28:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $28
801068b9:	6a 1c                	push   $0x1c
  jmp alltraps
801068bb:	e9 4e fa ff ff       	jmp    8010630e <alltraps>

801068c0 <vector29>:
.globl vector29
vector29:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $29
801068c2:	6a 1d                	push   $0x1d
  jmp alltraps
801068c4:	e9 45 fa ff ff       	jmp    8010630e <alltraps>

801068c9 <vector30>:
.globl vector30
vector30:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $30
801068cb:	6a 1e                	push   $0x1e
  jmp alltraps
801068cd:	e9 3c fa ff ff       	jmp    8010630e <alltraps>

801068d2 <vector31>:
.globl vector31
vector31:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $31
801068d4:	6a 1f                	push   $0x1f
  jmp alltraps
801068d6:	e9 33 fa ff ff       	jmp    8010630e <alltraps>

801068db <vector32>:
.globl vector32
vector32:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $32
801068dd:	6a 20                	push   $0x20
  jmp alltraps
801068df:	e9 2a fa ff ff       	jmp    8010630e <alltraps>

801068e4 <vector33>:
.globl vector33
vector33:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $33
801068e6:	6a 21                	push   $0x21
  jmp alltraps
801068e8:	e9 21 fa ff ff       	jmp    8010630e <alltraps>

801068ed <vector34>:
.globl vector34
vector34:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $34
801068ef:	6a 22                	push   $0x22
  jmp alltraps
801068f1:	e9 18 fa ff ff       	jmp    8010630e <alltraps>

801068f6 <vector35>:
.globl vector35
vector35:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $35
801068f8:	6a 23                	push   $0x23
  jmp alltraps
801068fa:	e9 0f fa ff ff       	jmp    8010630e <alltraps>

801068ff <vector36>:
.globl vector36
vector36:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $36
80106901:	6a 24                	push   $0x24
  jmp alltraps
80106903:	e9 06 fa ff ff       	jmp    8010630e <alltraps>

80106908 <vector37>:
.globl vector37
vector37:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $37
8010690a:	6a 25                	push   $0x25
  jmp alltraps
8010690c:	e9 fd f9 ff ff       	jmp    8010630e <alltraps>

80106911 <vector38>:
.globl vector38
vector38:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $38
80106913:	6a 26                	push   $0x26
  jmp alltraps
80106915:	e9 f4 f9 ff ff       	jmp    8010630e <alltraps>

8010691a <vector39>:
.globl vector39
vector39:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $39
8010691c:	6a 27                	push   $0x27
  jmp alltraps
8010691e:	e9 eb f9 ff ff       	jmp    8010630e <alltraps>

80106923 <vector40>:
.globl vector40
vector40:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $40
80106925:	6a 28                	push   $0x28
  jmp alltraps
80106927:	e9 e2 f9 ff ff       	jmp    8010630e <alltraps>

8010692c <vector41>:
.globl vector41
vector41:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $41
8010692e:	6a 29                	push   $0x29
  jmp alltraps
80106930:	e9 d9 f9 ff ff       	jmp    8010630e <alltraps>

80106935 <vector42>:
.globl vector42
vector42:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $42
80106937:	6a 2a                	push   $0x2a
  jmp alltraps
80106939:	e9 d0 f9 ff ff       	jmp    8010630e <alltraps>

8010693e <vector43>:
.globl vector43
vector43:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $43
80106940:	6a 2b                	push   $0x2b
  jmp alltraps
80106942:	e9 c7 f9 ff ff       	jmp    8010630e <alltraps>

80106947 <vector44>:
.globl vector44
vector44:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $44
80106949:	6a 2c                	push   $0x2c
  jmp alltraps
8010694b:	e9 be f9 ff ff       	jmp    8010630e <alltraps>

80106950 <vector45>:
.globl vector45
vector45:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $45
80106952:	6a 2d                	push   $0x2d
  jmp alltraps
80106954:	e9 b5 f9 ff ff       	jmp    8010630e <alltraps>

80106959 <vector46>:
.globl vector46
vector46:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $46
8010695b:	6a 2e                	push   $0x2e
  jmp alltraps
8010695d:	e9 ac f9 ff ff       	jmp    8010630e <alltraps>

80106962 <vector47>:
.globl vector47
vector47:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $47
80106964:	6a 2f                	push   $0x2f
  jmp alltraps
80106966:	e9 a3 f9 ff ff       	jmp    8010630e <alltraps>

8010696b <vector48>:
.globl vector48
vector48:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $48
8010696d:	6a 30                	push   $0x30
  jmp alltraps
8010696f:	e9 9a f9 ff ff       	jmp    8010630e <alltraps>

80106974 <vector49>:
.globl vector49
vector49:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $49
80106976:	6a 31                	push   $0x31
  jmp alltraps
80106978:	e9 91 f9 ff ff       	jmp    8010630e <alltraps>

8010697d <vector50>:
.globl vector50
vector50:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $50
8010697f:	6a 32                	push   $0x32
  jmp alltraps
80106981:	e9 88 f9 ff ff       	jmp    8010630e <alltraps>

80106986 <vector51>:
.globl vector51
vector51:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $51
80106988:	6a 33                	push   $0x33
  jmp alltraps
8010698a:	e9 7f f9 ff ff       	jmp    8010630e <alltraps>

8010698f <vector52>:
.globl vector52
vector52:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $52
80106991:	6a 34                	push   $0x34
  jmp alltraps
80106993:	e9 76 f9 ff ff       	jmp    8010630e <alltraps>

80106998 <vector53>:
.globl vector53
vector53:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $53
8010699a:	6a 35                	push   $0x35
  jmp alltraps
8010699c:	e9 6d f9 ff ff       	jmp    8010630e <alltraps>

801069a1 <vector54>:
.globl vector54
vector54:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $54
801069a3:	6a 36                	push   $0x36
  jmp alltraps
801069a5:	e9 64 f9 ff ff       	jmp    8010630e <alltraps>

801069aa <vector55>:
.globl vector55
vector55:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $55
801069ac:	6a 37                	push   $0x37
  jmp alltraps
801069ae:	e9 5b f9 ff ff       	jmp    8010630e <alltraps>

801069b3 <vector56>:
.globl vector56
vector56:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $56
801069b5:	6a 38                	push   $0x38
  jmp alltraps
801069b7:	e9 52 f9 ff ff       	jmp    8010630e <alltraps>

801069bc <vector57>:
.globl vector57
vector57:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $57
801069be:	6a 39                	push   $0x39
  jmp alltraps
801069c0:	e9 49 f9 ff ff       	jmp    8010630e <alltraps>

801069c5 <vector58>:
.globl vector58
vector58:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $58
801069c7:	6a 3a                	push   $0x3a
  jmp alltraps
801069c9:	e9 40 f9 ff ff       	jmp    8010630e <alltraps>

801069ce <vector59>:
.globl vector59
vector59:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $59
801069d0:	6a 3b                	push   $0x3b
  jmp alltraps
801069d2:	e9 37 f9 ff ff       	jmp    8010630e <alltraps>

801069d7 <vector60>:
.globl vector60
vector60:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $60
801069d9:	6a 3c                	push   $0x3c
  jmp alltraps
801069db:	e9 2e f9 ff ff       	jmp    8010630e <alltraps>

801069e0 <vector61>:
.globl vector61
vector61:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $61
801069e2:	6a 3d                	push   $0x3d
  jmp alltraps
801069e4:	e9 25 f9 ff ff       	jmp    8010630e <alltraps>

801069e9 <vector62>:
.globl vector62
vector62:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $62
801069eb:	6a 3e                	push   $0x3e
  jmp alltraps
801069ed:	e9 1c f9 ff ff       	jmp    8010630e <alltraps>

801069f2 <vector63>:
.globl vector63
vector63:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $63
801069f4:	6a 3f                	push   $0x3f
  jmp alltraps
801069f6:	e9 13 f9 ff ff       	jmp    8010630e <alltraps>

801069fb <vector64>:
.globl vector64
vector64:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $64
801069fd:	6a 40                	push   $0x40
  jmp alltraps
801069ff:	e9 0a f9 ff ff       	jmp    8010630e <alltraps>

80106a04 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $65
80106a06:	6a 41                	push   $0x41
  jmp alltraps
80106a08:	e9 01 f9 ff ff       	jmp    8010630e <alltraps>

80106a0d <vector66>:
.globl vector66
vector66:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $66
80106a0f:	6a 42                	push   $0x42
  jmp alltraps
80106a11:	e9 f8 f8 ff ff       	jmp    8010630e <alltraps>

80106a16 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $67
80106a18:	6a 43                	push   $0x43
  jmp alltraps
80106a1a:	e9 ef f8 ff ff       	jmp    8010630e <alltraps>

80106a1f <vector68>:
.globl vector68
vector68:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $68
80106a21:	6a 44                	push   $0x44
  jmp alltraps
80106a23:	e9 e6 f8 ff ff       	jmp    8010630e <alltraps>

80106a28 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $69
80106a2a:	6a 45                	push   $0x45
  jmp alltraps
80106a2c:	e9 dd f8 ff ff       	jmp    8010630e <alltraps>

80106a31 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $70
80106a33:	6a 46                	push   $0x46
  jmp alltraps
80106a35:	e9 d4 f8 ff ff       	jmp    8010630e <alltraps>

80106a3a <vector71>:
.globl vector71
vector71:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $71
80106a3c:	6a 47                	push   $0x47
  jmp alltraps
80106a3e:	e9 cb f8 ff ff       	jmp    8010630e <alltraps>

80106a43 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $72
80106a45:	6a 48                	push   $0x48
  jmp alltraps
80106a47:	e9 c2 f8 ff ff       	jmp    8010630e <alltraps>

80106a4c <vector73>:
.globl vector73
vector73:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $73
80106a4e:	6a 49                	push   $0x49
  jmp alltraps
80106a50:	e9 b9 f8 ff ff       	jmp    8010630e <alltraps>

80106a55 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $74
80106a57:	6a 4a                	push   $0x4a
  jmp alltraps
80106a59:	e9 b0 f8 ff ff       	jmp    8010630e <alltraps>

80106a5e <vector75>:
.globl vector75
vector75:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $75
80106a60:	6a 4b                	push   $0x4b
  jmp alltraps
80106a62:	e9 a7 f8 ff ff       	jmp    8010630e <alltraps>

80106a67 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $76
80106a69:	6a 4c                	push   $0x4c
  jmp alltraps
80106a6b:	e9 9e f8 ff ff       	jmp    8010630e <alltraps>

80106a70 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $77
80106a72:	6a 4d                	push   $0x4d
  jmp alltraps
80106a74:	e9 95 f8 ff ff       	jmp    8010630e <alltraps>

80106a79 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $78
80106a7b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a7d:	e9 8c f8 ff ff       	jmp    8010630e <alltraps>

80106a82 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $79
80106a84:	6a 4f                	push   $0x4f
  jmp alltraps
80106a86:	e9 83 f8 ff ff       	jmp    8010630e <alltraps>

80106a8b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $80
80106a8d:	6a 50                	push   $0x50
  jmp alltraps
80106a8f:	e9 7a f8 ff ff       	jmp    8010630e <alltraps>

80106a94 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $81
80106a96:	6a 51                	push   $0x51
  jmp alltraps
80106a98:	e9 71 f8 ff ff       	jmp    8010630e <alltraps>

80106a9d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $82
80106a9f:	6a 52                	push   $0x52
  jmp alltraps
80106aa1:	e9 68 f8 ff ff       	jmp    8010630e <alltraps>

80106aa6 <vector83>:
.globl vector83
vector83:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $83
80106aa8:	6a 53                	push   $0x53
  jmp alltraps
80106aaa:	e9 5f f8 ff ff       	jmp    8010630e <alltraps>

80106aaf <vector84>:
.globl vector84
vector84:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $84
80106ab1:	6a 54                	push   $0x54
  jmp alltraps
80106ab3:	e9 56 f8 ff ff       	jmp    8010630e <alltraps>

80106ab8 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $85
80106aba:	6a 55                	push   $0x55
  jmp alltraps
80106abc:	e9 4d f8 ff ff       	jmp    8010630e <alltraps>

80106ac1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $86
80106ac3:	6a 56                	push   $0x56
  jmp alltraps
80106ac5:	e9 44 f8 ff ff       	jmp    8010630e <alltraps>

80106aca <vector87>:
.globl vector87
vector87:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $87
80106acc:	6a 57                	push   $0x57
  jmp alltraps
80106ace:	e9 3b f8 ff ff       	jmp    8010630e <alltraps>

80106ad3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $88
80106ad5:	6a 58                	push   $0x58
  jmp alltraps
80106ad7:	e9 32 f8 ff ff       	jmp    8010630e <alltraps>

80106adc <vector89>:
.globl vector89
vector89:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $89
80106ade:	6a 59                	push   $0x59
  jmp alltraps
80106ae0:	e9 29 f8 ff ff       	jmp    8010630e <alltraps>

80106ae5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $90
80106ae7:	6a 5a                	push   $0x5a
  jmp alltraps
80106ae9:	e9 20 f8 ff ff       	jmp    8010630e <alltraps>

80106aee <vector91>:
.globl vector91
vector91:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $91
80106af0:	6a 5b                	push   $0x5b
  jmp alltraps
80106af2:	e9 17 f8 ff ff       	jmp    8010630e <alltraps>

80106af7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $92
80106af9:	6a 5c                	push   $0x5c
  jmp alltraps
80106afb:	e9 0e f8 ff ff       	jmp    8010630e <alltraps>

80106b00 <vector93>:
.globl vector93
vector93:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $93
80106b02:	6a 5d                	push   $0x5d
  jmp alltraps
80106b04:	e9 05 f8 ff ff       	jmp    8010630e <alltraps>

80106b09 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $94
80106b0b:	6a 5e                	push   $0x5e
  jmp alltraps
80106b0d:	e9 fc f7 ff ff       	jmp    8010630e <alltraps>

80106b12 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $95
80106b14:	6a 5f                	push   $0x5f
  jmp alltraps
80106b16:	e9 f3 f7 ff ff       	jmp    8010630e <alltraps>

80106b1b <vector96>:
.globl vector96
vector96:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $96
80106b1d:	6a 60                	push   $0x60
  jmp alltraps
80106b1f:	e9 ea f7 ff ff       	jmp    8010630e <alltraps>

80106b24 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $97
80106b26:	6a 61                	push   $0x61
  jmp alltraps
80106b28:	e9 e1 f7 ff ff       	jmp    8010630e <alltraps>

80106b2d <vector98>:
.globl vector98
vector98:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $98
80106b2f:	6a 62                	push   $0x62
  jmp alltraps
80106b31:	e9 d8 f7 ff ff       	jmp    8010630e <alltraps>

80106b36 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $99
80106b38:	6a 63                	push   $0x63
  jmp alltraps
80106b3a:	e9 cf f7 ff ff       	jmp    8010630e <alltraps>

80106b3f <vector100>:
.globl vector100
vector100:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $100
80106b41:	6a 64                	push   $0x64
  jmp alltraps
80106b43:	e9 c6 f7 ff ff       	jmp    8010630e <alltraps>

80106b48 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $101
80106b4a:	6a 65                	push   $0x65
  jmp alltraps
80106b4c:	e9 bd f7 ff ff       	jmp    8010630e <alltraps>

80106b51 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $102
80106b53:	6a 66                	push   $0x66
  jmp alltraps
80106b55:	e9 b4 f7 ff ff       	jmp    8010630e <alltraps>

80106b5a <vector103>:
.globl vector103
vector103:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $103
80106b5c:	6a 67                	push   $0x67
  jmp alltraps
80106b5e:	e9 ab f7 ff ff       	jmp    8010630e <alltraps>

80106b63 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $104
80106b65:	6a 68                	push   $0x68
  jmp alltraps
80106b67:	e9 a2 f7 ff ff       	jmp    8010630e <alltraps>

80106b6c <vector105>:
.globl vector105
vector105:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $105
80106b6e:	6a 69                	push   $0x69
  jmp alltraps
80106b70:	e9 99 f7 ff ff       	jmp    8010630e <alltraps>

80106b75 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $106
80106b77:	6a 6a                	push   $0x6a
  jmp alltraps
80106b79:	e9 90 f7 ff ff       	jmp    8010630e <alltraps>

80106b7e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $107
80106b80:	6a 6b                	push   $0x6b
  jmp alltraps
80106b82:	e9 87 f7 ff ff       	jmp    8010630e <alltraps>

80106b87 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $108
80106b89:	6a 6c                	push   $0x6c
  jmp alltraps
80106b8b:	e9 7e f7 ff ff       	jmp    8010630e <alltraps>

80106b90 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $109
80106b92:	6a 6d                	push   $0x6d
  jmp alltraps
80106b94:	e9 75 f7 ff ff       	jmp    8010630e <alltraps>

80106b99 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $110
80106b9b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b9d:	e9 6c f7 ff ff       	jmp    8010630e <alltraps>

80106ba2 <vector111>:
.globl vector111
vector111:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $111
80106ba4:	6a 6f                	push   $0x6f
  jmp alltraps
80106ba6:	e9 63 f7 ff ff       	jmp    8010630e <alltraps>

80106bab <vector112>:
.globl vector112
vector112:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $112
80106bad:	6a 70                	push   $0x70
  jmp alltraps
80106baf:	e9 5a f7 ff ff       	jmp    8010630e <alltraps>

80106bb4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $113
80106bb6:	6a 71                	push   $0x71
  jmp alltraps
80106bb8:	e9 51 f7 ff ff       	jmp    8010630e <alltraps>

80106bbd <vector114>:
.globl vector114
vector114:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $114
80106bbf:	6a 72                	push   $0x72
  jmp alltraps
80106bc1:	e9 48 f7 ff ff       	jmp    8010630e <alltraps>

80106bc6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $115
80106bc8:	6a 73                	push   $0x73
  jmp alltraps
80106bca:	e9 3f f7 ff ff       	jmp    8010630e <alltraps>

80106bcf <vector116>:
.globl vector116
vector116:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $116
80106bd1:	6a 74                	push   $0x74
  jmp alltraps
80106bd3:	e9 36 f7 ff ff       	jmp    8010630e <alltraps>

80106bd8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $117
80106bda:	6a 75                	push   $0x75
  jmp alltraps
80106bdc:	e9 2d f7 ff ff       	jmp    8010630e <alltraps>

80106be1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $118
80106be3:	6a 76                	push   $0x76
  jmp alltraps
80106be5:	e9 24 f7 ff ff       	jmp    8010630e <alltraps>

80106bea <vector119>:
.globl vector119
vector119:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $119
80106bec:	6a 77                	push   $0x77
  jmp alltraps
80106bee:	e9 1b f7 ff ff       	jmp    8010630e <alltraps>

80106bf3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $120
80106bf5:	6a 78                	push   $0x78
  jmp alltraps
80106bf7:	e9 12 f7 ff ff       	jmp    8010630e <alltraps>

80106bfc <vector121>:
.globl vector121
vector121:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $121
80106bfe:	6a 79                	push   $0x79
  jmp alltraps
80106c00:	e9 09 f7 ff ff       	jmp    8010630e <alltraps>

80106c05 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $122
80106c07:	6a 7a                	push   $0x7a
  jmp alltraps
80106c09:	e9 00 f7 ff ff       	jmp    8010630e <alltraps>

80106c0e <vector123>:
.globl vector123
vector123:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $123
80106c10:	6a 7b                	push   $0x7b
  jmp alltraps
80106c12:	e9 f7 f6 ff ff       	jmp    8010630e <alltraps>

80106c17 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $124
80106c19:	6a 7c                	push   $0x7c
  jmp alltraps
80106c1b:	e9 ee f6 ff ff       	jmp    8010630e <alltraps>

80106c20 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $125
80106c22:	6a 7d                	push   $0x7d
  jmp alltraps
80106c24:	e9 e5 f6 ff ff       	jmp    8010630e <alltraps>

80106c29 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $126
80106c2b:	6a 7e                	push   $0x7e
  jmp alltraps
80106c2d:	e9 dc f6 ff ff       	jmp    8010630e <alltraps>

80106c32 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $127
80106c34:	6a 7f                	push   $0x7f
  jmp alltraps
80106c36:	e9 d3 f6 ff ff       	jmp    8010630e <alltraps>

80106c3b <vector128>:
.globl vector128
vector128:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $128
80106c3d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c42:	e9 c7 f6 ff ff       	jmp    8010630e <alltraps>

80106c47 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $129
80106c49:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c4e:	e9 bb f6 ff ff       	jmp    8010630e <alltraps>

80106c53 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $130
80106c55:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c5a:	e9 af f6 ff ff       	jmp    8010630e <alltraps>

80106c5f <vector131>:
.globl vector131
vector131:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $131
80106c61:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c66:	e9 a3 f6 ff ff       	jmp    8010630e <alltraps>

80106c6b <vector132>:
.globl vector132
vector132:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $132
80106c6d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c72:	e9 97 f6 ff ff       	jmp    8010630e <alltraps>

80106c77 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $133
80106c79:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c7e:	e9 8b f6 ff ff       	jmp    8010630e <alltraps>

80106c83 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $134
80106c85:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c8a:	e9 7f f6 ff ff       	jmp    8010630e <alltraps>

80106c8f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $135
80106c91:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c96:	e9 73 f6 ff ff       	jmp    8010630e <alltraps>

80106c9b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $136
80106c9d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ca2:	e9 67 f6 ff ff       	jmp    8010630e <alltraps>

80106ca7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $137
80106ca9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106cae:	e9 5b f6 ff ff       	jmp    8010630e <alltraps>

80106cb3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $138
80106cb5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106cba:	e9 4f f6 ff ff       	jmp    8010630e <alltraps>

80106cbf <vector139>:
.globl vector139
vector139:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $139
80106cc1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106cc6:	e9 43 f6 ff ff       	jmp    8010630e <alltraps>

80106ccb <vector140>:
.globl vector140
vector140:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $140
80106ccd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cd2:	e9 37 f6 ff ff       	jmp    8010630e <alltraps>

80106cd7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $141
80106cd9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106cde:	e9 2b f6 ff ff       	jmp    8010630e <alltraps>

80106ce3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $142
80106ce5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106cea:	e9 1f f6 ff ff       	jmp    8010630e <alltraps>

80106cef <vector143>:
.globl vector143
vector143:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $143
80106cf1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106cf6:	e9 13 f6 ff ff       	jmp    8010630e <alltraps>

80106cfb <vector144>:
.globl vector144
vector144:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $144
80106cfd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d02:	e9 07 f6 ff ff       	jmp    8010630e <alltraps>

80106d07 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $145
80106d09:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d0e:	e9 fb f5 ff ff       	jmp    8010630e <alltraps>

80106d13 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $146
80106d15:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d1a:	e9 ef f5 ff ff       	jmp    8010630e <alltraps>

80106d1f <vector147>:
.globl vector147
vector147:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $147
80106d21:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d26:	e9 e3 f5 ff ff       	jmp    8010630e <alltraps>

80106d2b <vector148>:
.globl vector148
vector148:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $148
80106d2d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d32:	e9 d7 f5 ff ff       	jmp    8010630e <alltraps>

80106d37 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $149
80106d39:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d3e:	e9 cb f5 ff ff       	jmp    8010630e <alltraps>

80106d43 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $150
80106d45:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d4a:	e9 bf f5 ff ff       	jmp    8010630e <alltraps>

80106d4f <vector151>:
.globl vector151
vector151:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $151
80106d51:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d56:	e9 b3 f5 ff ff       	jmp    8010630e <alltraps>

80106d5b <vector152>:
.globl vector152
vector152:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $152
80106d5d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d62:	e9 a7 f5 ff ff       	jmp    8010630e <alltraps>

80106d67 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $153
80106d69:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d6e:	e9 9b f5 ff ff       	jmp    8010630e <alltraps>

80106d73 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $154
80106d75:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d7a:	e9 8f f5 ff ff       	jmp    8010630e <alltraps>

80106d7f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $155
80106d81:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d86:	e9 83 f5 ff ff       	jmp    8010630e <alltraps>

80106d8b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $156
80106d8d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d92:	e9 77 f5 ff ff       	jmp    8010630e <alltraps>

80106d97 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $157
80106d99:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d9e:	e9 6b f5 ff ff       	jmp    8010630e <alltraps>

80106da3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $158
80106da5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106daa:	e9 5f f5 ff ff       	jmp    8010630e <alltraps>

80106daf <vector159>:
.globl vector159
vector159:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $159
80106db1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106db6:	e9 53 f5 ff ff       	jmp    8010630e <alltraps>

80106dbb <vector160>:
.globl vector160
vector160:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $160
80106dbd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106dc2:	e9 47 f5 ff ff       	jmp    8010630e <alltraps>

80106dc7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $161
80106dc9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dce:	e9 3b f5 ff ff       	jmp    8010630e <alltraps>

80106dd3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $162
80106dd5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106dda:	e9 2f f5 ff ff       	jmp    8010630e <alltraps>

80106ddf <vector163>:
.globl vector163
vector163:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $163
80106de1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106de6:	e9 23 f5 ff ff       	jmp    8010630e <alltraps>

80106deb <vector164>:
.globl vector164
vector164:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $164
80106ded:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106df2:	e9 17 f5 ff ff       	jmp    8010630e <alltraps>

80106df7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $165
80106df9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106dfe:	e9 0b f5 ff ff       	jmp    8010630e <alltraps>

80106e03 <vector166>:
.globl vector166
vector166:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $166
80106e05:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e0a:	e9 ff f4 ff ff       	jmp    8010630e <alltraps>

80106e0f <vector167>:
.globl vector167
vector167:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $167
80106e11:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e16:	e9 f3 f4 ff ff       	jmp    8010630e <alltraps>

80106e1b <vector168>:
.globl vector168
vector168:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $168
80106e1d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e22:	e9 e7 f4 ff ff       	jmp    8010630e <alltraps>

80106e27 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $169
80106e29:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e2e:	e9 db f4 ff ff       	jmp    8010630e <alltraps>

80106e33 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $170
80106e35:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e3a:	e9 cf f4 ff ff       	jmp    8010630e <alltraps>

80106e3f <vector171>:
.globl vector171
vector171:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $171
80106e41:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e46:	e9 c3 f4 ff ff       	jmp    8010630e <alltraps>

80106e4b <vector172>:
.globl vector172
vector172:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $172
80106e4d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e52:	e9 b7 f4 ff ff       	jmp    8010630e <alltraps>

80106e57 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $173
80106e59:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e5e:	e9 ab f4 ff ff       	jmp    8010630e <alltraps>

80106e63 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $174
80106e65:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e6a:	e9 9f f4 ff ff       	jmp    8010630e <alltraps>

80106e6f <vector175>:
.globl vector175
vector175:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $175
80106e71:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e76:	e9 93 f4 ff ff       	jmp    8010630e <alltraps>

80106e7b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $176
80106e7d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e82:	e9 87 f4 ff ff       	jmp    8010630e <alltraps>

80106e87 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $177
80106e89:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e8e:	e9 7b f4 ff ff       	jmp    8010630e <alltraps>

80106e93 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $178
80106e95:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e9a:	e9 6f f4 ff ff       	jmp    8010630e <alltraps>

80106e9f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $179
80106ea1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ea6:	e9 63 f4 ff ff       	jmp    8010630e <alltraps>

80106eab <vector180>:
.globl vector180
vector180:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $180
80106ead:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106eb2:	e9 57 f4 ff ff       	jmp    8010630e <alltraps>

80106eb7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $181
80106eb9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ebe:	e9 4b f4 ff ff       	jmp    8010630e <alltraps>

80106ec3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $182
80106ec5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106eca:	e9 3f f4 ff ff       	jmp    8010630e <alltraps>

80106ecf <vector183>:
.globl vector183
vector183:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $183
80106ed1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ed6:	e9 33 f4 ff ff       	jmp    8010630e <alltraps>

80106edb <vector184>:
.globl vector184
vector184:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $184
80106edd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ee2:	e9 27 f4 ff ff       	jmp    8010630e <alltraps>

80106ee7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $185
80106ee9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106eee:	e9 1b f4 ff ff       	jmp    8010630e <alltraps>

80106ef3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $186
80106ef5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106efa:	e9 0f f4 ff ff       	jmp    8010630e <alltraps>

80106eff <vector187>:
.globl vector187
vector187:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $187
80106f01:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f06:	e9 03 f4 ff ff       	jmp    8010630e <alltraps>

80106f0b <vector188>:
.globl vector188
vector188:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $188
80106f0d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f12:	e9 f7 f3 ff ff       	jmp    8010630e <alltraps>

80106f17 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $189
80106f19:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f1e:	e9 eb f3 ff ff       	jmp    8010630e <alltraps>

80106f23 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $190
80106f25:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f2a:	e9 df f3 ff ff       	jmp    8010630e <alltraps>

80106f2f <vector191>:
.globl vector191
vector191:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $191
80106f31:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f36:	e9 d3 f3 ff ff       	jmp    8010630e <alltraps>

80106f3b <vector192>:
.globl vector192
vector192:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $192
80106f3d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f42:	e9 c7 f3 ff ff       	jmp    8010630e <alltraps>

80106f47 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $193
80106f49:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f4e:	e9 bb f3 ff ff       	jmp    8010630e <alltraps>

80106f53 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $194
80106f55:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f5a:	e9 af f3 ff ff       	jmp    8010630e <alltraps>

80106f5f <vector195>:
.globl vector195
vector195:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $195
80106f61:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f66:	e9 a3 f3 ff ff       	jmp    8010630e <alltraps>

80106f6b <vector196>:
.globl vector196
vector196:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $196
80106f6d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f72:	e9 97 f3 ff ff       	jmp    8010630e <alltraps>

80106f77 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $197
80106f79:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f7e:	e9 8b f3 ff ff       	jmp    8010630e <alltraps>

80106f83 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $198
80106f85:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f8a:	e9 7f f3 ff ff       	jmp    8010630e <alltraps>

80106f8f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $199
80106f91:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f96:	e9 73 f3 ff ff       	jmp    8010630e <alltraps>

80106f9b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $200
80106f9d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106fa2:	e9 67 f3 ff ff       	jmp    8010630e <alltraps>

80106fa7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $201
80106fa9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106fae:	e9 5b f3 ff ff       	jmp    8010630e <alltraps>

80106fb3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $202
80106fb5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106fba:	e9 4f f3 ff ff       	jmp    8010630e <alltraps>

80106fbf <vector203>:
.globl vector203
vector203:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $203
80106fc1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106fc6:	e9 43 f3 ff ff       	jmp    8010630e <alltraps>

80106fcb <vector204>:
.globl vector204
vector204:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $204
80106fcd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106fd2:	e9 37 f3 ff ff       	jmp    8010630e <alltraps>

80106fd7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $205
80106fd9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106fde:	e9 2b f3 ff ff       	jmp    8010630e <alltraps>

80106fe3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $206
80106fe5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106fea:	e9 1f f3 ff ff       	jmp    8010630e <alltraps>

80106fef <vector207>:
.globl vector207
vector207:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $207
80106ff1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ff6:	e9 13 f3 ff ff       	jmp    8010630e <alltraps>

80106ffb <vector208>:
.globl vector208
vector208:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $208
80106ffd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107002:	e9 07 f3 ff ff       	jmp    8010630e <alltraps>

80107007 <vector209>:
.globl vector209
vector209:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $209
80107009:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010700e:	e9 fb f2 ff ff       	jmp    8010630e <alltraps>

80107013 <vector210>:
.globl vector210
vector210:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $210
80107015:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010701a:	e9 ef f2 ff ff       	jmp    8010630e <alltraps>

8010701f <vector211>:
.globl vector211
vector211:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $211
80107021:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107026:	e9 e3 f2 ff ff       	jmp    8010630e <alltraps>

8010702b <vector212>:
.globl vector212
vector212:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $212
8010702d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107032:	e9 d7 f2 ff ff       	jmp    8010630e <alltraps>

80107037 <vector213>:
.globl vector213
vector213:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $213
80107039:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010703e:	e9 cb f2 ff ff       	jmp    8010630e <alltraps>

80107043 <vector214>:
.globl vector214
vector214:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $214
80107045:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010704a:	e9 bf f2 ff ff       	jmp    8010630e <alltraps>

8010704f <vector215>:
.globl vector215
vector215:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $215
80107051:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107056:	e9 b3 f2 ff ff       	jmp    8010630e <alltraps>

8010705b <vector216>:
.globl vector216
vector216:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $216
8010705d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107062:	e9 a7 f2 ff ff       	jmp    8010630e <alltraps>

80107067 <vector217>:
.globl vector217
vector217:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $217
80107069:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010706e:	e9 9b f2 ff ff       	jmp    8010630e <alltraps>

80107073 <vector218>:
.globl vector218
vector218:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $218
80107075:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010707a:	e9 8f f2 ff ff       	jmp    8010630e <alltraps>

8010707f <vector219>:
.globl vector219
vector219:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $219
80107081:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107086:	e9 83 f2 ff ff       	jmp    8010630e <alltraps>

8010708b <vector220>:
.globl vector220
vector220:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $220
8010708d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107092:	e9 77 f2 ff ff       	jmp    8010630e <alltraps>

80107097 <vector221>:
.globl vector221
vector221:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $221
80107099:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010709e:	e9 6b f2 ff ff       	jmp    8010630e <alltraps>

801070a3 <vector222>:
.globl vector222
vector222:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $222
801070a5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801070aa:	e9 5f f2 ff ff       	jmp    8010630e <alltraps>

801070af <vector223>:
.globl vector223
vector223:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $223
801070b1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070b6:	e9 53 f2 ff ff       	jmp    8010630e <alltraps>

801070bb <vector224>:
.globl vector224
vector224:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $224
801070bd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070c2:	e9 47 f2 ff ff       	jmp    8010630e <alltraps>

801070c7 <vector225>:
.globl vector225
vector225:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $225
801070c9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070ce:	e9 3b f2 ff ff       	jmp    8010630e <alltraps>

801070d3 <vector226>:
.globl vector226
vector226:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $226
801070d5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070da:	e9 2f f2 ff ff       	jmp    8010630e <alltraps>

801070df <vector227>:
.globl vector227
vector227:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $227
801070e1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070e6:	e9 23 f2 ff ff       	jmp    8010630e <alltraps>

801070eb <vector228>:
.globl vector228
vector228:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $228
801070ed:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070f2:	e9 17 f2 ff ff       	jmp    8010630e <alltraps>

801070f7 <vector229>:
.globl vector229
vector229:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $229
801070f9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070fe:	e9 0b f2 ff ff       	jmp    8010630e <alltraps>

80107103 <vector230>:
.globl vector230
vector230:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $230
80107105:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010710a:	e9 ff f1 ff ff       	jmp    8010630e <alltraps>

8010710f <vector231>:
.globl vector231
vector231:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $231
80107111:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107116:	e9 f3 f1 ff ff       	jmp    8010630e <alltraps>

8010711b <vector232>:
.globl vector232
vector232:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $232
8010711d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107122:	e9 e7 f1 ff ff       	jmp    8010630e <alltraps>

80107127 <vector233>:
.globl vector233
vector233:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $233
80107129:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010712e:	e9 db f1 ff ff       	jmp    8010630e <alltraps>

80107133 <vector234>:
.globl vector234
vector234:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $234
80107135:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010713a:	e9 cf f1 ff ff       	jmp    8010630e <alltraps>

8010713f <vector235>:
.globl vector235
vector235:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $235
80107141:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107146:	e9 c3 f1 ff ff       	jmp    8010630e <alltraps>

8010714b <vector236>:
.globl vector236
vector236:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $236
8010714d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107152:	e9 b7 f1 ff ff       	jmp    8010630e <alltraps>

80107157 <vector237>:
.globl vector237
vector237:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $237
80107159:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010715e:	e9 ab f1 ff ff       	jmp    8010630e <alltraps>

80107163 <vector238>:
.globl vector238
vector238:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $238
80107165:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010716a:	e9 9f f1 ff ff       	jmp    8010630e <alltraps>

8010716f <vector239>:
.globl vector239
vector239:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $239
80107171:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107176:	e9 93 f1 ff ff       	jmp    8010630e <alltraps>

8010717b <vector240>:
.globl vector240
vector240:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $240
8010717d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107182:	e9 87 f1 ff ff       	jmp    8010630e <alltraps>

80107187 <vector241>:
.globl vector241
vector241:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $241
80107189:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010718e:	e9 7b f1 ff ff       	jmp    8010630e <alltraps>

80107193 <vector242>:
.globl vector242
vector242:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $242
80107195:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010719a:	e9 6f f1 ff ff       	jmp    8010630e <alltraps>

8010719f <vector243>:
.globl vector243
vector243:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $243
801071a1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801071a6:	e9 63 f1 ff ff       	jmp    8010630e <alltraps>

801071ab <vector244>:
.globl vector244
vector244:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $244
801071ad:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071b2:	e9 57 f1 ff ff       	jmp    8010630e <alltraps>

801071b7 <vector245>:
.globl vector245
vector245:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $245
801071b9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071be:	e9 4b f1 ff ff       	jmp    8010630e <alltraps>

801071c3 <vector246>:
.globl vector246
vector246:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $246
801071c5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071ca:	e9 3f f1 ff ff       	jmp    8010630e <alltraps>

801071cf <vector247>:
.globl vector247
vector247:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $247
801071d1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071d6:	e9 33 f1 ff ff       	jmp    8010630e <alltraps>

801071db <vector248>:
.globl vector248
vector248:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $248
801071dd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071e2:	e9 27 f1 ff ff       	jmp    8010630e <alltraps>

801071e7 <vector249>:
.globl vector249
vector249:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $249
801071e9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071ee:	e9 1b f1 ff ff       	jmp    8010630e <alltraps>

801071f3 <vector250>:
.globl vector250
vector250:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $250
801071f5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071fa:	e9 0f f1 ff ff       	jmp    8010630e <alltraps>

801071ff <vector251>:
.globl vector251
vector251:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $251
80107201:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107206:	e9 03 f1 ff ff       	jmp    8010630e <alltraps>

8010720b <vector252>:
.globl vector252
vector252:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $252
8010720d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107212:	e9 f7 f0 ff ff       	jmp    8010630e <alltraps>

80107217 <vector253>:
.globl vector253
vector253:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $253
80107219:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010721e:	e9 eb f0 ff ff       	jmp    8010630e <alltraps>

80107223 <vector254>:
.globl vector254
vector254:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $254
80107225:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010722a:	e9 df f0 ff ff       	jmp    8010630e <alltraps>

8010722f <vector255>:
.globl vector255
vector255:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $255
80107231:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107236:	e9 d3 f0 ff ff       	jmp    8010630e <alltraps>
8010723b:	66 90                	xchg   %ax,%ax
8010723d:	66 90                	xchg   %ax,%ax
8010723f:	90                   	nop

80107240 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107247:	c1 ea 16             	shr    $0x16,%edx
{
8010724a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010724b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010724e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107251:	8b 1f                	mov    (%edi),%ebx
80107253:	f6 c3 01             	test   $0x1,%bl
80107256:	74 28                	je     80107280 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107258:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010725e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107264:	89 f0                	mov    %esi,%eax
}
80107266:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107269:	c1 e8 0a             	shr    $0xa,%eax
8010726c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107271:	01 d8                	add    %ebx,%eax
}
80107273:	5b                   	pop    %ebx
80107274:	5e                   	pop    %esi
80107275:	5f                   	pop    %edi
80107276:	5d                   	pop    %ebp
80107277:	c3                   	ret    
80107278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107280:	85 c9                	test   %ecx,%ecx
80107282:	74 2c                	je     801072b0 <walkpgdir+0x70>
80107284:	e8 b7 b3 ff ff       	call   80102640 <kalloc>
80107289:	89 c3                	mov    %eax,%ebx
8010728b:	85 c0                	test   %eax,%eax
8010728d:	74 21                	je     801072b0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010728f:	83 ec 04             	sub    $0x4,%esp
80107292:	68 00 10 00 00       	push   $0x1000
80107297:	6a 00                	push   $0x0
80107299:	50                   	push   %eax
8010729a:	e8 b1 d5 ff ff       	call   80104850 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010729f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072a5:	83 c4 10             	add    $0x10,%esp
801072a8:	83 c8 07             	or     $0x7,%eax
801072ab:	89 07                	mov    %eax,(%edi)
801072ad:	eb b5                	jmp    80107264 <walkpgdir+0x24>
801072af:	90                   	nop
}
801072b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801072b3:	31 c0                	xor    %eax,%eax
}
801072b5:	5b                   	pop    %ebx
801072b6:	5e                   	pop    %esi
801072b7:	5f                   	pop    %edi
801072b8:	5d                   	pop    %ebp
801072b9:	c3                   	ret    
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072c0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072c6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801072ca:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801072d0:	89 d6                	mov    %edx,%esi
{
801072d2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801072d3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801072d9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072df:	8b 45 08             	mov    0x8(%ebp),%eax
801072e2:	29 f0                	sub    %esi,%eax
801072e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072e7:	eb 1f                	jmp    80107308 <mappages+0x48>
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801072f0:	f6 00 01             	testb  $0x1,(%eax)
801072f3:	75 45                	jne    8010733a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072f5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801072f8:	83 cb 01             	or     $0x1,%ebx
801072fb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801072fd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107300:	74 2e                	je     80107330 <mappages+0x70>
      break;
    a += PGSIZE;
80107302:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010730b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107310:	89 f2                	mov    %esi,%edx
80107312:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107315:	89 f8                	mov    %edi,%eax
80107317:	e8 24 ff ff ff       	call   80107240 <walkpgdir>
8010731c:	85 c0                	test   %eax,%eax
8010731e:	75 d0                	jne    801072f0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret    
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107333:	31 c0                	xor    %eax,%eax
}
80107335:	5b                   	pop    %ebx
80107336:	5e                   	pop    %esi
80107337:	5f                   	pop    %edi
80107338:	5d                   	pop    %ebp
80107339:	c3                   	ret    
      panic("remap");
8010733a:	83 ec 0c             	sub    $0xc,%esp
8010733d:	68 d0 85 10 80       	push   $0x801085d0
80107342:	e8 49 90 ff ff       	call   80100390 <panic>
80107347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734e:	66 90                	xchg   %ax,%ax

80107350 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	89 c6                	mov    %eax,%esi
80107357:	53                   	push   %ebx
80107358:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010735a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107360:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010736c:	39 da                	cmp    %ebx,%edx
8010736e:	73 5b                	jae    801073cb <deallocuvm.part.0+0x7b>
80107370:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107373:	89 d7                	mov    %edx,%edi
80107375:	eb 14                	jmp    8010738b <deallocuvm.part.0+0x3b>
80107377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737e:	66 90                	xchg   %ax,%ax
80107380:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107386:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107389:	76 40                	jbe    801073cb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010738b:	31 c9                	xor    %ecx,%ecx
8010738d:	89 fa                	mov    %edi,%edx
8010738f:	89 f0                	mov    %esi,%eax
80107391:	e8 aa fe ff ff       	call   80107240 <walkpgdir>
80107396:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107398:	85 c0                	test   %eax,%eax
8010739a:	74 44                	je     801073e0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010739c:	8b 00                	mov    (%eax),%eax
8010739e:	a8 01                	test   $0x1,%al
801073a0:	74 de                	je     80107380 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801073a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073a7:	74 47                	je     801073f0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801073a9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801073ac:	05 00 00 00 80       	add    $0x80000000,%eax
801073b1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801073b7:	50                   	push   %eax
801073b8:	e8 c3 b0 ff ff       	call   80102480 <kfree>
      *pte = 0;
801073bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801073c3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801073c6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801073c9:	77 c0                	ja     8010738b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801073cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d1:	5b                   	pop    %ebx
801073d2:	5e                   	pop    %esi
801073d3:	5f                   	pop    %edi
801073d4:	5d                   	pop    %ebp
801073d5:	c3                   	ret    
801073d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801073e0:	89 fa                	mov    %edi,%edx
801073e2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801073e8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801073ee:	eb 96                	jmp    80107386 <deallocuvm.part.0+0x36>
        panic("kfree");
801073f0:	83 ec 0c             	sub    $0xc,%esp
801073f3:	68 e6 7d 10 80       	push   $0x80107de6
801073f8:	e8 93 8f ff ff       	call   80100390 <panic>
801073fd:	8d 76 00             	lea    0x0(%esi),%esi

80107400 <seginit>:
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010740a:	e8 a1 c6 ff ff       	call   80103ab0 <cpuid>
  pd[0] = size-1;
8010740f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107414:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010741a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010741e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107425:	ff 00 00 
80107428:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010742f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107432:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107439:	ff 00 00 
8010743c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107443:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107446:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
8010744d:	ff 00 00 
80107450:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107457:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010745a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80107461:	ff 00 00 
80107464:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
8010746b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010746e:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80107473:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107477:	c1 e8 10             	shr    $0x10,%eax
8010747a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010747e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107481:	0f 01 10             	lgdtl  (%eax)
}
80107484:	c9                   	leave  
80107485:	c3                   	ret    
80107486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748d:	8d 76 00             	lea    0x0(%esi),%esi

80107490 <switchkvm>:
{
80107490:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107494:	a1 a4 80 11 80       	mov    0x801180a4,%eax
80107499:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010749e:	0f 22 d8             	mov    %eax,%cr3
}
801074a1:	c3                   	ret    
801074a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074b0 <switchuvm>:
{
801074b0:	f3 0f 1e fb          	endbr32 
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	57                   	push   %edi
801074b8:	56                   	push   %esi
801074b9:	53                   	push   %ebx
801074ba:	83 ec 1c             	sub    $0x1c,%esp
801074bd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801074c0:	85 f6                	test   %esi,%esi
801074c2:	0f 84 cb 00 00 00    	je     80107593 <switchuvm+0xe3>
  if(p->kstack == 0)
801074c8:	8b 46 08             	mov    0x8(%esi),%eax
801074cb:	85 c0                	test   %eax,%eax
801074cd:	0f 84 da 00 00 00    	je     801075ad <switchuvm+0xfd>
  if(p->pgdir == 0)
801074d3:	8b 46 04             	mov    0x4(%esi),%eax
801074d6:	85 c0                	test   %eax,%eax
801074d8:	0f 84 c2 00 00 00    	je     801075a0 <switchuvm+0xf0>
  pushcli();
801074de:	e8 5d d1 ff ff       	call   80104640 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074e3:	e8 58 c5 ff ff       	call   80103a40 <mycpu>
801074e8:	89 c3                	mov    %eax,%ebx
801074ea:	e8 51 c5 ff ff       	call   80103a40 <mycpu>
801074ef:	89 c7                	mov    %eax,%edi
801074f1:	e8 4a c5 ff ff       	call   80103a40 <mycpu>
801074f6:	83 c7 08             	add    $0x8,%edi
801074f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074fc:	e8 3f c5 ff ff       	call   80103a40 <mycpu>
80107501:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107504:	ba 67 00 00 00       	mov    $0x67,%edx
80107509:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107510:	83 c0 08             	add    $0x8,%eax
80107513:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010751a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010751f:	83 c1 08             	add    $0x8,%ecx
80107522:	c1 e8 18             	shr    $0x18,%eax
80107525:	c1 e9 10             	shr    $0x10,%ecx
80107528:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010752e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107534:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107539:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107540:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107545:	e8 f6 c4 ff ff       	call   80103a40 <mycpu>
8010754a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107551:	e8 ea c4 ff ff       	call   80103a40 <mycpu>
80107556:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010755a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010755d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107563:	e8 d8 c4 ff ff       	call   80103a40 <mycpu>
80107568:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010756b:	e8 d0 c4 ff ff       	call   80103a40 <mycpu>
80107570:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107574:	b8 28 00 00 00       	mov    $0x28,%eax
80107579:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010757c:	8b 46 04             	mov    0x4(%esi),%eax
8010757f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107584:	0f 22 d8             	mov    %eax,%cr3
}
80107587:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758a:	5b                   	pop    %ebx
8010758b:	5e                   	pop    %esi
8010758c:	5f                   	pop    %edi
8010758d:	5d                   	pop    %ebp
  popcli();
8010758e:	e9 fd d0 ff ff       	jmp    80104690 <popcli>
    panic("switchuvm: no process");
80107593:	83 ec 0c             	sub    $0xc,%esp
80107596:	68 d6 85 10 80       	push   $0x801085d6
8010759b:	e8 f0 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801075a0:	83 ec 0c             	sub    $0xc,%esp
801075a3:	68 01 86 10 80       	push   $0x80108601
801075a8:	e8 e3 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801075ad:	83 ec 0c             	sub    $0xc,%esp
801075b0:	68 ec 85 10 80       	push   $0x801085ec
801075b5:	e8 d6 8d ff ff       	call   80100390 <panic>
801075ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075c0 <inituvm>:
{
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	57                   	push   %edi
801075c8:	56                   	push   %esi
801075c9:	53                   	push   %ebx
801075ca:	83 ec 1c             	sub    $0x1c,%esp
801075cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801075d0:	8b 75 10             	mov    0x10(%ebp),%esi
801075d3:	8b 7d 08             	mov    0x8(%ebp),%edi
801075d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801075d9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075df:	77 4b                	ja     8010762c <inituvm+0x6c>
  mem = kalloc();
801075e1:	e8 5a b0 ff ff       	call   80102640 <kalloc>
  memset(mem, 0, PGSIZE);
801075e6:	83 ec 04             	sub    $0x4,%esp
801075e9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075ee:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075f0:	6a 00                	push   $0x0
801075f2:	50                   	push   %eax
801075f3:	e8 58 d2 ff ff       	call   80104850 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801075f8:	58                   	pop    %eax
801075f9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075ff:	5a                   	pop    %edx
80107600:	6a 06                	push   $0x6
80107602:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107607:	31 d2                	xor    %edx,%edx
80107609:	50                   	push   %eax
8010760a:	89 f8                	mov    %edi,%eax
8010760c:	e8 af fc ff ff       	call   801072c0 <mappages>
  memmove(mem, init, sz);
80107611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107614:	89 75 10             	mov    %esi,0x10(%ebp)
80107617:	83 c4 10             	add    $0x10,%esp
8010761a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010761d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107623:	5b                   	pop    %ebx
80107624:	5e                   	pop    %esi
80107625:	5f                   	pop    %edi
80107626:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107627:	e9 c4 d2 ff ff       	jmp    801048f0 <memmove>
    panic("inituvm: more than a page");
8010762c:	83 ec 0c             	sub    $0xc,%esp
8010762f:	68 15 86 10 80       	push   $0x80108615
80107634:	e8 57 8d ff ff       	call   80100390 <panic>
80107639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107640 <loaduvm>:
{
80107640:	f3 0f 1e fb          	endbr32 
80107644:	55                   	push   %ebp
80107645:	89 e5                	mov    %esp,%ebp
80107647:	57                   	push   %edi
80107648:	56                   	push   %esi
80107649:	53                   	push   %ebx
8010764a:	83 ec 1c             	sub    $0x1c,%esp
8010764d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107650:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107653:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107658:	0f 85 99 00 00 00    	jne    801076f7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010765e:	01 f0                	add    %esi,%eax
80107660:	89 f3                	mov    %esi,%ebx
80107662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107665:	8b 45 14             	mov    0x14(%ebp),%eax
80107668:	01 f0                	add    %esi,%eax
8010766a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010766d:	85 f6                	test   %esi,%esi
8010766f:	75 15                	jne    80107686 <loaduvm+0x46>
80107671:	eb 6d                	jmp    801076e0 <loaduvm+0xa0>
80107673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107677:	90                   	nop
80107678:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010767e:	89 f0                	mov    %esi,%eax
80107680:	29 d8                	sub    %ebx,%eax
80107682:	39 c6                	cmp    %eax,%esi
80107684:	76 5a                	jbe    801076e0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107686:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107689:	8b 45 08             	mov    0x8(%ebp),%eax
8010768c:	31 c9                	xor    %ecx,%ecx
8010768e:	29 da                	sub    %ebx,%edx
80107690:	e8 ab fb ff ff       	call   80107240 <walkpgdir>
80107695:	85 c0                	test   %eax,%eax
80107697:	74 51                	je     801076ea <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107699:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010769b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010769e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801076a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801076a8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801076ae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076b1:	29 d9                	sub    %ebx,%ecx
801076b3:	05 00 00 00 80       	add    $0x80000000,%eax
801076b8:	57                   	push   %edi
801076b9:	51                   	push   %ecx
801076ba:	50                   	push   %eax
801076bb:	ff 75 10             	pushl  0x10(%ebp)
801076be:	e8 ad a3 ff ff       	call   80101a70 <readi>
801076c3:	83 c4 10             	add    $0x10,%esp
801076c6:	39 f8                	cmp    %edi,%eax
801076c8:	74 ae                	je     80107678 <loaduvm+0x38>
}
801076ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076d2:	5b                   	pop    %ebx
801076d3:	5e                   	pop    %esi
801076d4:	5f                   	pop    %edi
801076d5:	5d                   	pop    %ebp
801076d6:	c3                   	ret    
801076d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076de:	66 90                	xchg   %ax,%ax
801076e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076e3:	31 c0                	xor    %eax,%eax
}
801076e5:	5b                   	pop    %ebx
801076e6:	5e                   	pop    %esi
801076e7:	5f                   	pop    %edi
801076e8:	5d                   	pop    %ebp
801076e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801076ea:	83 ec 0c             	sub    $0xc,%esp
801076ed:	68 2f 86 10 80       	push   $0x8010862f
801076f2:	e8 99 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801076f7:	83 ec 0c             	sub    $0xc,%esp
801076fa:	68 d0 86 10 80       	push   $0x801086d0
801076ff:	e8 8c 8c ff ff       	call   80100390 <panic>
80107704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <allocuvm>:
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	57                   	push   %edi
80107718:	56                   	push   %esi
80107719:	53                   	push   %ebx
8010771a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010771d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107720:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107723:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107726:	85 c0                	test   %eax,%eax
80107728:	0f 88 b2 00 00 00    	js     801077e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010772e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107731:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107734:	0f 82 96 00 00 00    	jb     801077d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010773a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107740:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107746:	39 75 10             	cmp    %esi,0x10(%ebp)
80107749:	77 40                	ja     8010778b <allocuvm+0x7b>
8010774b:	e9 83 00 00 00       	jmp    801077d3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107750:	83 ec 04             	sub    $0x4,%esp
80107753:	68 00 10 00 00       	push   $0x1000
80107758:	6a 00                	push   $0x0
8010775a:	50                   	push   %eax
8010775b:	e8 f0 d0 ff ff       	call   80104850 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107760:	58                   	pop    %eax
80107761:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107767:	5a                   	pop    %edx
80107768:	6a 06                	push   $0x6
8010776a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010776f:	89 f2                	mov    %esi,%edx
80107771:	50                   	push   %eax
80107772:	89 f8                	mov    %edi,%eax
80107774:	e8 47 fb ff ff       	call   801072c0 <mappages>
80107779:	83 c4 10             	add    $0x10,%esp
8010777c:	85 c0                	test   %eax,%eax
8010777e:	78 78                	js     801077f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107780:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107786:	39 75 10             	cmp    %esi,0x10(%ebp)
80107789:	76 48                	jbe    801077d3 <allocuvm+0xc3>
    mem = kalloc();
8010778b:	e8 b0 ae ff ff       	call   80102640 <kalloc>
80107790:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107792:	85 c0                	test   %eax,%eax
80107794:	75 ba                	jne    80107750 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107796:	83 ec 0c             	sub    $0xc,%esp
80107799:	68 4d 86 10 80       	push   $0x8010864d
8010779e:	e8 0d 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801077a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801077a6:	83 c4 10             	add    $0x10,%esp
801077a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801077ac:	74 32                	je     801077e0 <allocuvm+0xd0>
801077ae:	8b 55 10             	mov    0x10(%ebp),%edx
801077b1:	89 c1                	mov    %eax,%ecx
801077b3:	89 f8                	mov    %edi,%eax
801077b5:	e8 96 fb ff ff       	call   80107350 <deallocuvm.part.0>
      return 0;
801077ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077c7:	5b                   	pop    %ebx
801077c8:	5e                   	pop    %esi
801077c9:	5f                   	pop    %edi
801077ca:	5d                   	pop    %ebp
801077cb:	c3                   	ret    
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801077d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801077d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d9:	5b                   	pop    %ebx
801077da:	5e                   	pop    %esi
801077db:	5f                   	pop    %edi
801077dc:	5d                   	pop    %ebp
801077dd:	c3                   	ret    
801077de:	66 90                	xchg   %ax,%ax
    return 0;
801077e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ed:	5b                   	pop    %ebx
801077ee:	5e                   	pop    %esi
801077ef:	5f                   	pop    %edi
801077f0:	5d                   	pop    %ebp
801077f1:	c3                   	ret    
801077f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801077f8:	83 ec 0c             	sub    $0xc,%esp
801077fb:	68 65 86 10 80       	push   $0x80108665
80107800:	e8 ab 8e ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107805:	8b 45 0c             	mov    0xc(%ebp),%eax
80107808:	83 c4 10             	add    $0x10,%esp
8010780b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010780e:	74 0c                	je     8010781c <allocuvm+0x10c>
80107810:	8b 55 10             	mov    0x10(%ebp),%edx
80107813:	89 c1                	mov    %eax,%ecx
80107815:	89 f8                	mov    %edi,%eax
80107817:	e8 34 fb ff ff       	call   80107350 <deallocuvm.part.0>
      kfree(mem);
8010781c:	83 ec 0c             	sub    $0xc,%esp
8010781f:	53                   	push   %ebx
80107820:	e8 5b ac ff ff       	call   80102480 <kfree>
      return 0;
80107825:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010782c:	83 c4 10             	add    $0x10,%esp
}
8010782f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107832:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107835:	5b                   	pop    %ebx
80107836:	5e                   	pop    %esi
80107837:	5f                   	pop    %edi
80107838:	5d                   	pop    %ebp
80107839:	c3                   	ret    
8010783a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107840 <deallocuvm>:
{
80107840:	f3 0f 1e fb          	endbr32 
80107844:	55                   	push   %ebp
80107845:	89 e5                	mov    %esp,%ebp
80107847:	8b 55 0c             	mov    0xc(%ebp),%edx
8010784a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010784d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107850:	39 d1                	cmp    %edx,%ecx
80107852:	73 0c                	jae    80107860 <deallocuvm+0x20>
}
80107854:	5d                   	pop    %ebp
80107855:	e9 f6 fa ff ff       	jmp    80107350 <deallocuvm.part.0>
8010785a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107860:	89 d0                	mov    %edx,%eax
80107862:	5d                   	pop    %ebp
80107863:	c3                   	ret    
80107864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010786f:	90                   	nop

80107870 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107870:	f3 0f 1e fb          	endbr32 
80107874:	55                   	push   %ebp
80107875:	89 e5                	mov    %esp,%ebp
80107877:	57                   	push   %edi
80107878:	56                   	push   %esi
80107879:	53                   	push   %ebx
8010787a:	83 ec 0c             	sub    $0xc,%esp
8010787d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107880:	85 f6                	test   %esi,%esi
80107882:	74 55                	je     801078d9 <freevm+0x69>
  if(newsz >= oldsz)
80107884:	31 c9                	xor    %ecx,%ecx
80107886:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010788b:	89 f0                	mov    %esi,%eax
8010788d:	89 f3                	mov    %esi,%ebx
8010788f:	e8 bc fa ff ff       	call   80107350 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107894:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010789a:	eb 0b                	jmp    801078a7 <freevm+0x37>
8010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078a0:	83 c3 04             	add    $0x4,%ebx
801078a3:	39 df                	cmp    %ebx,%edi
801078a5:	74 23                	je     801078ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801078a7:	8b 03                	mov    (%ebx),%eax
801078a9:	a8 01                	test   $0x1,%al
801078ab:	74 f3                	je     801078a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801078b2:	83 ec 0c             	sub    $0xc,%esp
801078b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078bd:	50                   	push   %eax
801078be:	e8 bd ab ff ff       	call   80102480 <kfree>
801078c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078c6:	39 df                	cmp    %ebx,%edi
801078c8:	75 dd                	jne    801078a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801078ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d0:	5b                   	pop    %ebx
801078d1:	5e                   	pop    %esi
801078d2:	5f                   	pop    %edi
801078d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078d4:	e9 a7 ab ff ff       	jmp    80102480 <kfree>
    panic("freevm: no pgdir");
801078d9:	83 ec 0c             	sub    $0xc,%esp
801078dc:	68 81 86 10 80       	push   $0x80108681
801078e1:	e8 aa 8a ff ff       	call   80100390 <panic>
801078e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ed:	8d 76 00             	lea    0x0(%esi),%esi

801078f0 <setupkvm>:
{
801078f0:	f3 0f 1e fb          	endbr32 
801078f4:	55                   	push   %ebp
801078f5:	89 e5                	mov    %esp,%ebp
801078f7:	56                   	push   %esi
801078f8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078f9:	e8 42 ad ff ff       	call   80102640 <kalloc>
801078fe:	89 c6                	mov    %eax,%esi
80107900:	85 c0                	test   %eax,%eax
80107902:	74 42                	je     80107946 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107904:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107907:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010790c:	68 00 10 00 00       	push   $0x1000
80107911:	6a 00                	push   $0x0
80107913:	50                   	push   %eax
80107914:	e8 37 cf ff ff       	call   80104850 <memset>
80107919:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010791c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010791f:	83 ec 08             	sub    $0x8,%esp
80107922:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107925:	ff 73 0c             	pushl  0xc(%ebx)
80107928:	8b 13                	mov    (%ebx),%edx
8010792a:	50                   	push   %eax
8010792b:	29 c1                	sub    %eax,%ecx
8010792d:	89 f0                	mov    %esi,%eax
8010792f:	e8 8c f9 ff ff       	call   801072c0 <mappages>
80107934:	83 c4 10             	add    $0x10,%esp
80107937:	85 c0                	test   %eax,%eax
80107939:	78 15                	js     80107950 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010793b:	83 c3 10             	add    $0x10,%ebx
8010793e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107944:	75 d6                	jne    8010791c <setupkvm+0x2c>
}
80107946:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107949:	89 f0                	mov    %esi,%eax
8010794b:	5b                   	pop    %ebx
8010794c:	5e                   	pop    %esi
8010794d:	5d                   	pop    %ebp
8010794e:	c3                   	ret    
8010794f:	90                   	nop
      freevm(pgdir);
80107950:	83 ec 0c             	sub    $0xc,%esp
80107953:	56                   	push   %esi
      return 0;
80107954:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107956:	e8 15 ff ff ff       	call   80107870 <freevm>
      return 0;
8010795b:	83 c4 10             	add    $0x10,%esp
}
8010795e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107961:	89 f0                	mov    %esi,%eax
80107963:	5b                   	pop    %ebx
80107964:	5e                   	pop    %esi
80107965:	5d                   	pop    %ebp
80107966:	c3                   	ret    
80107967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010796e:	66 90                	xchg   %ax,%ax

80107970 <kvmalloc>:
{
80107970:	f3 0f 1e fb          	endbr32 
80107974:	55                   	push   %ebp
80107975:	89 e5                	mov    %esp,%ebp
80107977:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010797a:	e8 71 ff ff ff       	call   801078f0 <setupkvm>
8010797f:	a3 a4 80 11 80       	mov    %eax,0x801180a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107984:	05 00 00 00 80       	add    $0x80000000,%eax
80107989:	0f 22 d8             	mov    %eax,%cr3
}
8010798c:	c9                   	leave  
8010798d:	c3                   	ret    
8010798e:	66 90                	xchg   %ax,%ax

80107990 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107990:	f3 0f 1e fb          	endbr32 
80107994:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107995:	31 c9                	xor    %ecx,%ecx
{
80107997:	89 e5                	mov    %esp,%ebp
80107999:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010799c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010799f:	8b 45 08             	mov    0x8(%ebp),%eax
801079a2:	e8 99 f8 ff ff       	call   80107240 <walkpgdir>
  if(pte == 0)
801079a7:	85 c0                	test   %eax,%eax
801079a9:	74 05                	je     801079b0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801079ab:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079ae:	c9                   	leave  
801079af:	c3                   	ret    
    panic("clearpteu");
801079b0:	83 ec 0c             	sub    $0xc,%esp
801079b3:	68 92 86 10 80       	push   $0x80108692
801079b8:	e8 d3 89 ff ff       	call   80100390 <panic>
801079bd:	8d 76 00             	lea    0x0(%esi),%esi

801079c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801079c0:	f3 0f 1e fb          	endbr32 
801079c4:	55                   	push   %ebp
801079c5:	89 e5                	mov    %esp,%ebp
801079c7:	57                   	push   %edi
801079c8:	56                   	push   %esi
801079c9:	53                   	push   %ebx
801079ca:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801079cd:	e8 1e ff ff ff       	call   801078f0 <setupkvm>
801079d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079d5:	85 c0                	test   %eax,%eax
801079d7:	0f 84 9b 00 00 00    	je     80107a78 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079e0:	85 c9                	test   %ecx,%ecx
801079e2:	0f 84 90 00 00 00    	je     80107a78 <copyuvm+0xb8>
801079e8:	31 f6                	xor    %esi,%esi
801079ea:	eb 46                	jmp    80107a32 <copyuvm+0x72>
801079ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801079f0:	83 ec 04             	sub    $0x4,%esp
801079f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079f9:	68 00 10 00 00       	push   $0x1000
801079fe:	57                   	push   %edi
801079ff:	50                   	push   %eax
80107a00:	e8 eb ce ff ff       	call   801048f0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a05:	58                   	pop    %eax
80107a06:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a0c:	5a                   	pop    %edx
80107a0d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a10:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a15:	89 f2                	mov    %esi,%edx
80107a17:	50                   	push   %eax
80107a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a1b:	e8 a0 f8 ff ff       	call   801072c0 <mappages>
80107a20:	83 c4 10             	add    $0x10,%esp
80107a23:	85 c0                	test   %eax,%eax
80107a25:	78 61                	js     80107a88 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107a27:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a2d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a30:	76 46                	jbe    80107a78 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a32:	8b 45 08             	mov    0x8(%ebp),%eax
80107a35:	31 c9                	xor    %ecx,%ecx
80107a37:	89 f2                	mov    %esi,%edx
80107a39:	e8 02 f8 ff ff       	call   80107240 <walkpgdir>
80107a3e:	85 c0                	test   %eax,%eax
80107a40:	74 61                	je     80107aa3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107a42:	8b 00                	mov    (%eax),%eax
80107a44:	a8 01                	test   $0x1,%al
80107a46:	74 4e                	je     80107a96 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107a48:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a4a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a52:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a58:	e8 e3 ab ff ff       	call   80102640 <kalloc>
80107a5d:	89 c3                	mov    %eax,%ebx
80107a5f:	85 c0                	test   %eax,%eax
80107a61:	75 8d                	jne    801079f0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107a63:	83 ec 0c             	sub    $0xc,%esp
80107a66:	ff 75 e0             	pushl  -0x20(%ebp)
80107a69:	e8 02 fe ff ff       	call   80107870 <freevm>
  return 0;
80107a6e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a75:	83 c4 10             	add    $0x10,%esp
}
80107a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a7e:	5b                   	pop    %ebx
80107a7f:	5e                   	pop    %esi
80107a80:	5f                   	pop    %edi
80107a81:	5d                   	pop    %ebp
80107a82:	c3                   	ret    
80107a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a87:	90                   	nop
      kfree(mem);
80107a88:	83 ec 0c             	sub    $0xc,%esp
80107a8b:	53                   	push   %ebx
80107a8c:	e8 ef a9 ff ff       	call   80102480 <kfree>
      goto bad;
80107a91:	83 c4 10             	add    $0x10,%esp
80107a94:	eb cd                	jmp    80107a63 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107a96:	83 ec 0c             	sub    $0xc,%esp
80107a99:	68 b6 86 10 80       	push   $0x801086b6
80107a9e:	e8 ed 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107aa3:	83 ec 0c             	sub    $0xc,%esp
80107aa6:	68 9c 86 10 80       	push   $0x8010869c
80107aab:	e8 e0 88 ff ff       	call   80100390 <panic>

80107ab0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ab0:	f3 0f 1e fb          	endbr32 
80107ab4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ab5:	31 c9                	xor    %ecx,%ecx
{
80107ab7:	89 e5                	mov    %esp,%ebp
80107ab9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107abc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107abf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac2:	e8 79 f7 ff ff       	call   80107240 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107ac7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ac9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107aca:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107acc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ad1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ad4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ad9:	83 fa 05             	cmp    $0x5,%edx
80107adc:	ba 00 00 00 00       	mov    $0x0,%edx
80107ae1:	0f 45 c2             	cmovne %edx,%eax
}
80107ae4:	c3                   	ret    
80107ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107af0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107af0:	f3 0f 1e fb          	endbr32 
80107af4:	55                   	push   %ebp
80107af5:	89 e5                	mov    %esp,%ebp
80107af7:	57                   	push   %edi
80107af8:	56                   	push   %esi
80107af9:	53                   	push   %ebx
80107afa:	83 ec 0c             	sub    $0xc,%esp
80107afd:	8b 75 14             	mov    0x14(%ebp),%esi
80107b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b03:	85 f6                	test   %esi,%esi
80107b05:	75 3c                	jne    80107b43 <copyout+0x53>
80107b07:	eb 67                	jmp    80107b70 <copyout+0x80>
80107b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b10:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b13:	89 fb                	mov    %edi,%ebx
80107b15:	29 d3                	sub    %edx,%ebx
80107b17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b1d:	39 f3                	cmp    %esi,%ebx
80107b1f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b22:	29 fa                	sub    %edi,%edx
80107b24:	83 ec 04             	sub    $0x4,%esp
80107b27:	01 c2                	add    %eax,%edx
80107b29:	53                   	push   %ebx
80107b2a:	ff 75 10             	pushl  0x10(%ebp)
80107b2d:	52                   	push   %edx
80107b2e:	e8 bd cd ff ff       	call   801048f0 <memmove>
    len -= n;
    buf += n;
80107b33:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b36:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b3c:	83 c4 10             	add    $0x10,%esp
80107b3f:	29 de                	sub    %ebx,%esi
80107b41:	74 2d                	je     80107b70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b43:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b45:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b48:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b4b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b51:	57                   	push   %edi
80107b52:	ff 75 08             	pushl  0x8(%ebp)
80107b55:	e8 56 ff ff ff       	call   80107ab0 <uva2ka>
    if(pa0 == 0)
80107b5a:	83 c4 10             	add    $0x10,%esp
80107b5d:	85 c0                	test   %eax,%eax
80107b5f:	75 af                	jne    80107b10 <copyout+0x20>
  }
  return 0;
}
80107b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b69:	5b                   	pop    %ebx
80107b6a:	5e                   	pop    %esi
80107b6b:	5f                   	pop    %edi
80107b6c:	5d                   	pop    %ebp
80107b6d:	c3                   	ret    
80107b6e:	66 90                	xchg   %ax,%ax
80107b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b73:	31 c0                	xor    %eax,%eax
}
80107b75:	5b                   	pop    %ebx
80107b76:	5e                   	pop    %esi
80107b77:	5f                   	pop    %edi
80107b78:	5d                   	pop    %ebp
80107b79:	c3                   	ret    
