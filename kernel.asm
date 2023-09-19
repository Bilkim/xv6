
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
8010002d:	b8 40 30 10 80       	mov    $0x80103040,%eax
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
80100050:	68 a0 79 10 80       	push   $0x801079a0
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 e1 43 00 00       	call   80104440 <initlock>
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
80100092:	68 a7 79 10 80       	push   $0x801079a7
80100097:	50                   	push   %eax
80100098:	e8 63 42 00 00       	call   80104300 <initsleeplock>
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
801000e8:	e8 d3 44 00 00       	call   801045c0 <acquire>
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
80100162:	e8 19 45 00 00       	call   80104680 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 41 00 00       	call   80104340 <acquiresleep>
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
8010018c:	e8 ef 20 00 00       	call   80102280 <iderw>
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
801001a3:	68 ae 79 10 80       	push   $0x801079ae
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
801001c2:	e8 19 42 00 00       	call   801043e0 <holdingsleep>
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
801001d8:	e9 a3 20 00 00       	jmp    80102280 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 bf 79 10 80       	push   $0x801079bf
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
80100203:	e8 d8 41 00 00       	call   801043e0 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 88 41 00 00       	call   801043a0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 9c 43 00 00       	call   801045c0 <acquire>
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
80100270:	e9 0b 44 00 00       	jmp    80104680 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 c6 79 10 80       	push   $0x801079c6
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
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 0a 43 00 00       	call   801045c0 <acquire>
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
801002e5:	e8 76 3c 00 00       	call   80103f60 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 81 36 00 00       	call   80103980 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 6d 43 00 00       	call   80104680 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
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
80100365:	e8 16 43 00 00       	call   80104680 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
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
801003ad:	e8 ee 24 00 00       	call   801028a0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 cd 79 10 80       	push   $0x801079cd
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 fb 83 10 80 	movl   $0x801083fb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 7f 40 00 00       	call   80104460 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 e1 79 10 80       	push   $0x801079e1
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
8010042a:	e8 61 61 00 00       	call   80106590 <uartputc>
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
80100515:	e8 76 60 00 00       	call   80106590 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 6a 60 00 00       	call   80106590 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 5e 60 00 00       	call   80106590 <uartputc>
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
80100561:	e8 0a 42 00 00       	call   80104770 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 55 41 00 00       	call   801046d0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 e5 79 10 80       	push   $0x801079e5
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
801005c9:	0f b6 92 10 7a 10 80 	movzbl -0x7fef85f0(%edx),%edx
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
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 5c 3f 00 00       	call   801045c0 <acquire>
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
80100697:	e8 e4 3f 00 00       	call   80104680 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

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
8010077d:	bb f8 79 10 80       	mov    $0x801079f8,%ebx
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
801007bd:	e8 fe 3d 00 00       	call   801045c0 <acquire>
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
80100828:	e8 53 3e 00 00       	call   80104680 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 ff 79 10 80       	push   $0x801079ff
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
80100877:	e8 44 3d 00 00       	call   801045c0 <acquire>
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
801009cf:	e8 ac 3c 00 00       	call   80104680 <release>
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
801009ff:	e9 1c 38 00 00       	jmp    80104220 <procdump>
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
80100a20:	e8 fb 36 00 00       	call   80104120 <wakeup>
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
80100a3a:	68 08 7a 10 80       	push   $0x80107a08
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 f7 39 00 00       	call   80104440 <initlock>

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
80100a6d:	e8 be 19 00 00       	call   80102430 <ioapicenable>
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
80100a90:	e8 eb 2e 00 00       	call   80103980 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 90 22 00 00       	call   80102d30 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
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
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 b8 22 00 00       	call   80102da0 <end_op>
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
80100b0c:	e8 ef 6b 00 00       	call   80107700 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
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
80100b73:	e8 a8 69 00 00       	call   80107520 <allocuvm>
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
80100ba9:	e8 a2 68 00 00       	call   80107450 <loaduvm>
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
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 90 6a 00 00       	call   80107680 <freevm>
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
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 7a 21 00 00       	call   80102da0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 e9 68 00 00       	call   80107520 <allocuvm>
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
80100c53:	e8 48 6b 00 00       	call   801077a0 <clearpteu>
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
80100ca3:	e8 28 3c 00 00       	call   801048d0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 15 3c 00 00       	call   801048d0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 34 6c 00 00       	call   80107900 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 9a 69 00 00       	call   80107680 <freevm>
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
80100d33:	e8 c8 6b 00 00       	call   80107900 <copyout>
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
80100d71:	e8 1a 3b 00 00       	call   80104890 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 1e 65 00 00       	call   801072c0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 d6 68 00 00       	call   80107680 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 e7 1f 00 00       	call   80102da0 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 21 7a 10 80       	push   $0x80107a21
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 2d 7a 10 80       	push   $0x80107a2d
80100def:	68 c0 0f 11 80       	push   $0x80110fc0
80100df4:	e8 47 36 00 00       	call   80104440 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 c0 0f 11 80       	push   $0x80110fc0
80100e15:	e8 a6 37 00 00       	call   801045c0 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 3a 38 00 00       	call   80104680 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 0f 11 80       	push   $0x80110fc0
80100e5a:	e8 21 38 00 00       	call   80104680 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 c0 0f 11 80       	push   $0x80110fc0
80100e83:	e8 38 37 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea0:	e8 db 37 00 00       	call   80104680 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 34 7a 10 80       	push   $0x80107a34
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed5:	e8 e6 36 00 00       	call   801045c0 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 6b 37 00 00       	call   80104680 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 3d 37 00 00       	jmp    80104680 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 e3 1d 00 00       	call   80102d30 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 39 1e 00 00       	jmp    80102da0 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 82 25 00 00       	call   80103500 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 3c 7a 10 80       	push   $0x80107a3c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 36 26 00 00       	jmp    801036a0 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 46 7a 10 80       	push   $0x80107a46
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 aa 1c 00 00       	call   80102da0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 11 1c 00 00       	call   80102d30 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 4a 1c 00 00       	call   80102da0 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 4f 7a 10 80       	push   $0x80107a4f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 0a 24 00 00       	jmp    801035a0 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 55 7a 10 80       	push   $0x80107a55
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 0e 1d 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 5f 7a 10 80       	push   $0x80107a5f
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 d8 19 11 80    	add    0x801119d8,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 72 7a 10 80       	push   $0x80107a72
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 1e 1c 00 00       	call   80102f10 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 b6 33 00 00       	call   801046d0 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 ee 1b 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 e0 19 11 80       	push   $0x801119e0
8010135a:	e8 61 32 00 00       	call   801045c0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 e0 19 11 80       	push   $0x801119e0
801013c7:	e8 b4 32 00 00       	call   80104680 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 86 32 00 00       	call   80104680 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 88 7a 10 80       	push   $0x80107a88
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 66 1a 00 00       	call   80102f10 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 98 7a 10 80       	push   $0x80107a98
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 46 32 00 00       	call   80104770 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 ab 7a 10 80       	push   $0x80107aab
80101555:	68 e0 19 11 80       	push   $0x801119e0
8010155a:	e8 e1 2e 00 00       	call   80104440 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 b2 7a 10 80       	push   $0x80107ab2
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 84 2d 00 00       	call   80104300 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 c0 19 11 80       	push   $0x801119c0
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 d8 19 11 80    	pushl  0x801119d8
8010159d:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015a3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015af:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015b5:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015bb:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015c1:	68 18 7b 10 80       	push   $0x80107b18
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 6d 30 00 00       	call   801046d0 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 9b 18 00 00       	call   80102f10 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 b8 7a 10 80       	push   $0x80107ab8
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 66 30 00 00       	call   80104770 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 fe 17 00 00       	call   80102f10 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 e0 19 11 80       	push   $0x801119e0
80101743:	e8 78 2e 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101753:	e8 28 2f 00 00       	call   80104680 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 b5 2b 00 00       	call   80104340 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 73 2f 00 00       	call   80104770 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 d0 7a 10 80       	push   $0x80107ad0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 ca 7a 10 80       	push   $0x80107aca
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 84 2b 00 00       	call   801043e0 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 28 2b 00 00       	jmp    801043a0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 df 7a 10 80       	push   $0x80107adf
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 97 2a 00 00       	call   80104340 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 dd 2a 00 00       	call   801043a0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018ca:	e8 f1 2c 00 00       	call   801045c0 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 97 2d 00 00       	jmp    80104680 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 e0 19 11 80       	push   $0x801119e0
801018f8:	e8 c3 2c 00 00       	call   801045c0 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101907:	e8 74 2d 00 00       	call   80104680 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 64 2c 00 00       	call   80104770 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 68 2b 00 00       	call   80104770 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 00 13 00 00       	call   80102f10 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 39 2b 00 00       	call   801047e0 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 d6 2a 00 00       	call   801047e0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 f9 7a 10 80       	push   $0x80107af9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 e7 7a 10 80       	push   $0x80107ae7
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 f1 1b 00 00       	call   80103980 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 e0 19 11 80       	push   $0x801119e0
80101d9c:	e8 1f 28 00 00       	call   801045c0 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dac:	e8 cf 28 00 00       	call   80104680 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 54 29 00 00       	call   80104770 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 c8 28 00 00       	call   80104770 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 56 28 00 00       	call   80104830 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
  return 0;
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 08 7b 10 80       	push   $0x80107b08
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 f2 80 10 80       	push   $0x801080f2
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	66 90                	xchg   %ax,%ax
8010206a:	66 90                	xchg   %ax,%ax
8010206c:	66 90                	xchg   %ax,%ax
8010206e:	66 90                	xchg   %ax,%ax

80102070 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
80102076:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102079:	85 c0                	test   %eax,%eax
8010207b:	0f 84 b4 00 00 00    	je     80102135 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102081:	8b 70 08             	mov    0x8(%eax),%esi
80102084:	89 c3                	mov    %eax,%ebx
80102086:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010208c:	0f 87 96 00 00 00    	ja     80102128 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102092:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102097:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010209e:	66 90                	xchg   %ax,%ax
801020a0:	89 ca                	mov    %ecx,%edx
801020a2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a3:	83 e0 c0             	and    $0xffffffc0,%eax
801020a6:	3c 40                	cmp    $0x40,%al
801020a8:	75 f6                	jne    801020a0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020aa:	31 ff                	xor    %edi,%edi
801020ac:	ba f6 03 00 00       	mov    $0x3f6,%edx
801020b1:	89 f8                	mov    %edi,%eax
801020b3:	ee                   	out    %al,(%dx)
801020b4:	b8 01 00 00 00       	mov    $0x1,%eax
801020b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801020be:	ee                   	out    %al,(%dx)
801020bf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801020c4:	89 f0                	mov    %esi,%eax
801020c6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801020c7:	89 f0                	mov    %esi,%eax
801020c9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801020ce:	c1 f8 08             	sar    $0x8,%eax
801020d1:	ee                   	out    %al,(%dx)
801020d2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801020d7:	89 f8                	mov    %edi,%eax
801020d9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801020da:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801020de:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020e3:	c1 e0 04             	shl    $0x4,%eax
801020e6:	83 e0 10             	and    $0x10,%eax
801020e9:	83 c8 e0             	or     $0xffffffe0,%eax
801020ec:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801020ed:	f6 03 04             	testb  $0x4,(%ebx)
801020f0:	75 16                	jne    80102108 <idestart+0x98>
801020f2:	b8 20 00 00 00       	mov    $0x20,%eax
801020f7:	89 ca                	mov    %ecx,%edx
801020f9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801020fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020fd:	5b                   	pop    %ebx
801020fe:	5e                   	pop    %esi
801020ff:	5f                   	pop    %edi
80102100:	5d                   	pop    %ebp
80102101:	c3                   	ret    
80102102:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102108:	b8 30 00 00 00       	mov    $0x30,%eax
8010210d:	89 ca                	mov    %ecx,%edx
8010210f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102110:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102115:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102118:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211d:	fc                   	cld    
8010211e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102120:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102123:	5b                   	pop    %ebx
80102124:	5e                   	pop    %esi
80102125:	5f                   	pop    %edi
80102126:	5d                   	pop    %ebp
80102127:	c3                   	ret    
    panic("incorrect blockno");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 74 7b 10 80       	push   $0x80107b74
80102130:	e8 5b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 6b 7b 10 80       	push   $0x80107b6b
8010213d:	e8 4e e2 ff ff       	call   80100390 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <ideinit>:
{
80102150:	f3 0f 1e fb          	endbr32 
80102154:	55                   	push   %ebp
80102155:	89 e5                	mov    %esp,%ebp
80102157:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
8010215a:	68 86 7b 10 80       	push   $0x80107b86
8010215f:	68 80 b5 10 80       	push   $0x8010b580
80102164:	e8 d7 22 00 00       	call   80104440 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102169:	58                   	pop    %eax
8010216a:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010216f:	5a                   	pop    %edx
80102170:	83 e8 01             	sub    $0x1,%eax
80102173:	50                   	push   %eax
80102174:	6a 0e                	push   $0xe
80102176:	e8 b5 02 00 00       	call   80102430 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
8010217b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010217e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102183:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102187:	90                   	nop
80102188:	ec                   	in     (%dx),%al
80102189:	83 e0 c0             	and    $0xffffffc0,%eax
8010218c:	3c 40                	cmp    $0x40,%al
8010218e:	75 f8                	jne    80102188 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102190:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102195:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010219a:	ee                   	out    %al,(%dx)
8010219b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021a5:	eb 0e                	jmp    801021b5 <ideinit+0x65>
801021a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ae:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
801021b0:	83 e9 01             	sub    $0x1,%ecx
801021b3:	74 0f                	je     801021c4 <ideinit+0x74>
801021b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801021b6:	84 c0                	test   %al,%al
801021b8:	74 f6                	je     801021b0 <ideinit+0x60>
      havedisk1 = 1;
801021ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801021c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801021c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ce:	ee                   	out    %al,(%dx)
}
801021cf:	c9                   	leave  
801021d0:	c3                   	ret    
801021d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021df:	90                   	nop

801021e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801021e0:	f3 0f 1e fb          	endbr32 
801021e4:	55                   	push   %ebp
801021e5:	89 e5                	mov    %esp,%ebp
801021e7:	57                   	push   %edi
801021e8:	56                   	push   %esi
801021e9:	53                   	push   %ebx
801021ea:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801021ed:	68 80 b5 10 80       	push   $0x8010b580
801021f2:	e8 c9 23 00 00       	call   801045c0 <acquire>

  if((b = idequeue) == 0){
801021f7:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801021fd:	83 c4 10             	add    $0x10,%esp
80102200:	85 db                	test   %ebx,%ebx
80102202:	74 5f                	je     80102263 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102204:	8b 43 58             	mov    0x58(%ebx),%eax
80102207:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010220c:	8b 33                	mov    (%ebx),%esi
8010220e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102214:	75 2b                	jne    80102241 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102216:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010221b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010221f:	90                   	nop
80102220:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102221:	89 c1                	mov    %eax,%ecx
80102223:	83 e1 c0             	and    $0xffffffc0,%ecx
80102226:	80 f9 40             	cmp    $0x40,%cl
80102229:	75 f5                	jne    80102220 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010222b:	a8 21                	test   $0x21,%al
8010222d:	75 12                	jne    80102241 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010222f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102232:	b9 80 00 00 00       	mov    $0x80,%ecx
80102237:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223c:	fc                   	cld    
8010223d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010223f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102241:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102244:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102247:	83 ce 02             	or     $0x2,%esi
8010224a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010224c:	53                   	push   %ebx
8010224d:	e8 ce 1e 00 00       	call   80104120 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102252:	a1 64 b5 10 80       	mov    0x8010b564,%eax
80102257:	83 c4 10             	add    $0x10,%esp
8010225a:	85 c0                	test   %eax,%eax
8010225c:	74 05                	je     80102263 <ideintr+0x83>
    idestart(idequeue);
8010225e:	e8 0d fe ff ff       	call   80102070 <idestart>
    release(&idelock);
80102263:	83 ec 0c             	sub    $0xc,%esp
80102266:	68 80 b5 10 80       	push   $0x8010b580
8010226b:	e8 10 24 00 00       	call   80104680 <release>

  release(&idelock);
}
80102270:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102273:	5b                   	pop    %ebx
80102274:	5e                   	pop    %esi
80102275:	5f                   	pop    %edi
80102276:	5d                   	pop    %ebp
80102277:	c3                   	ret    
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop

80102280 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102280:	f3 0f 1e fb          	endbr32 
80102284:	55                   	push   %ebp
80102285:	89 e5                	mov    %esp,%ebp
80102287:	53                   	push   %ebx
80102288:	83 ec 10             	sub    $0x10,%esp
8010228b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010228e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102291:	50                   	push   %eax
80102292:	e8 49 21 00 00       	call   801043e0 <holdingsleep>
80102297:	83 c4 10             	add    $0x10,%esp
8010229a:	85 c0                	test   %eax,%eax
8010229c:	0f 84 cf 00 00 00    	je     80102371 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022a2:	8b 03                	mov    (%ebx),%eax
801022a4:	83 e0 06             	and    $0x6,%eax
801022a7:	83 f8 02             	cmp    $0x2,%eax
801022aa:	0f 84 b4 00 00 00    	je     80102364 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022b0:	8b 53 04             	mov    0x4(%ebx),%edx
801022b3:	85 d2                	test   %edx,%edx
801022b5:	74 0d                	je     801022c4 <iderw+0x44>
801022b7:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801022bc:	85 c0                	test   %eax,%eax
801022be:	0f 84 93 00 00 00    	je     80102357 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801022c4:	83 ec 0c             	sub    $0xc,%esp
801022c7:	68 80 b5 10 80       	push   $0x8010b580
801022cc:	e8 ef 22 00 00       	call   801045c0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022d1:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
801022d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 c0                	test   %eax,%eax
801022e2:	74 6c                	je     80102350 <iderw+0xd0>
801022e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022e8:	89 c2                	mov    %eax,%edx
801022ea:	8b 40 58             	mov    0x58(%eax),%eax
801022ed:	85 c0                	test   %eax,%eax
801022ef:	75 f7                	jne    801022e8 <iderw+0x68>
801022f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801022f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801022f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801022fc:	74 42                	je     80102340 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801022fe:	8b 03                	mov    (%ebx),%eax
80102300:	83 e0 06             	and    $0x6,%eax
80102303:	83 f8 02             	cmp    $0x2,%eax
80102306:	74 23                	je     8010232b <iderw+0xab>
80102308:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010230f:	90                   	nop
    sleep(b, &idelock);
80102310:	83 ec 08             	sub    $0x8,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	53                   	push   %ebx
80102319:	e8 42 1c 00 00       	call   80103f60 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010231e:	8b 03                	mov    (%ebx),%eax
80102320:	83 c4 10             	add    $0x10,%esp
80102323:	83 e0 06             	and    $0x6,%eax
80102326:	83 f8 02             	cmp    $0x2,%eax
80102329:	75 e5                	jne    80102310 <iderw+0x90>
  }


  release(&idelock);
8010232b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102335:	c9                   	leave  
  release(&idelock);
80102336:	e9 45 23 00 00       	jmp    80104680 <release>
8010233b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010233f:	90                   	nop
    idestart(b);
80102340:	89 d8                	mov    %ebx,%eax
80102342:	e8 29 fd ff ff       	call   80102070 <idestart>
80102347:	eb b5                	jmp    801022fe <iderw+0x7e>
80102349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102350:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102355:	eb 9d                	jmp    801022f4 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 b5 7b 10 80       	push   $0x80107bb5
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 a0 7b 10 80       	push   $0x80107ba0
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102371:	83 ec 0c             	sub    $0xc,%esp
80102374:	68 8a 7b 10 80       	push   $0x80107b8a
80102379:	e8 12 e0 ff ff       	call   80100390 <panic>
8010237e:	66 90                	xchg   %ax,%ax

80102380 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102385:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
8010238c:	00 c0 fe 
{
8010238f:	89 e5                	mov    %esp,%ebp
80102391:	56                   	push   %esi
80102392:	53                   	push   %ebx
  ioapic->reg = reg;
80102393:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
8010239a:	00 00 00 
  return ioapic->data;
8010239d:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023a3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023a6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023ac:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023b2:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801023b9:	c1 ee 10             	shr    $0x10,%esi
801023bc:	89 f0                	mov    %esi,%eax
801023be:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801023c1:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801023c4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801023c7:	39 c2                	cmp    %eax,%edx
801023c9:	74 16                	je     801023e1 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801023cb:	83 ec 0c             	sub    $0xc,%esp
801023ce:	68 d4 7b 10 80       	push   $0x80107bd4
801023d3:	e8 d8 e2 ff ff       	call   801006b0 <cprintf>
801023d8:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	83 c6 21             	add    $0x21,%esi
{
801023e4:	ba 10 00 00 00       	mov    $0x10,%edx
801023e9:	b8 20 00 00 00       	mov    $0x20,%eax
801023ee:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
801023f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801023f4:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801023fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801023fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102403:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102406:	8d 5a 01             	lea    0x1(%edx),%ebx
80102409:	83 c2 02             	add    $0x2,%edx
8010240c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010240e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102414:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010241b:	39 f0                	cmp    %esi,%eax
8010241d:	75 d1                	jne    801023f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010241f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102422:	5b                   	pop    %ebx
80102423:	5e                   	pop    %esi
80102424:	5d                   	pop    %ebp
80102425:	c3                   	ret    
80102426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010242d:	8d 76 00             	lea    0x0(%esi),%esi

80102430 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102430:	f3 0f 1e fb          	endbr32 
80102434:	55                   	push   %ebp
  ioapic->reg = reg;
80102435:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010243b:	89 e5                	mov    %esp,%ebp
8010243d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102440:	8d 50 20             	lea    0x20(%eax),%edx
80102443:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102447:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102449:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010244f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102452:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102455:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102458:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010245a:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010245f:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102462:	89 50 10             	mov    %edx,0x10(%eax)
}
80102465:	5d                   	pop    %ebp
80102466:	c3                   	ret    
80102467:	66 90                	xchg   %ax,%ax
80102469:	66 90                	xchg   %ax,%ax
8010246b:	66 90                	xchg   %ax,%ax
8010246d:	66 90                	xchg   %ax,%ax
8010246f:	90                   	nop

80102470 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102470:	f3 0f 1e fb          	endbr32 
80102474:	55                   	push   %ebp
80102475:	89 e5                	mov    %esp,%ebp
80102477:	53                   	push   %ebx
80102478:	83 ec 04             	sub    $0x4,%esp
8010247b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010247e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102484:	75 7a                	jne    80102500 <kfree+0x90>
80102486:	81 fb a8 7e 11 80    	cmp    $0x80117ea8,%ebx
8010248c:	72 72                	jb     80102500 <kfree+0x90>
8010248e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102494:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102499:	77 65                	ja     80102500 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
8010249b:	83 ec 04             	sub    $0x4,%esp
8010249e:	68 00 10 00 00       	push   $0x1000
801024a3:	6a 01                	push   $0x1
801024a5:	53                   	push   %ebx
801024a6:	e8 25 22 00 00       	call   801046d0 <memset>

  if(kmem.use_lock)
801024ab:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801024b1:	83 c4 10             	add    $0x10,%esp
801024b4:	85 d2                	test   %edx,%edx
801024b6:	75 20                	jne    801024d8 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801024b8:	a1 78 36 11 80       	mov    0x80113678,%eax
801024bd:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801024bf:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801024c4:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801024ca:	85 c0                	test   %eax,%eax
801024cc:	75 22                	jne    801024f0 <kfree+0x80>
    release(&kmem.lock);
}
801024ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024d1:	c9                   	leave  
801024d2:	c3                   	ret    
801024d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024d7:	90                   	nop
    acquire(&kmem.lock);
801024d8:	83 ec 0c             	sub    $0xc,%esp
801024db:	68 40 36 11 80       	push   $0x80113640
801024e0:	e8 db 20 00 00       	call   801045c0 <acquire>
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	eb ce                	jmp    801024b8 <kfree+0x48>
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801024f0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801024f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024fa:	c9                   	leave  
    release(&kmem.lock);
801024fb:	e9 80 21 00 00       	jmp    80104680 <release>
    panic("kfree");
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 06 7c 10 80       	push   $0x80107c06
80102508:	e8 83 de ff ff       	call   80100390 <panic>
8010250d:	8d 76 00             	lea    0x0(%esi),%esi

80102510 <freerange>:
{
80102510:	f3 0f 1e fb          	endbr32 
80102514:	55                   	push   %ebp
80102515:	89 e5                	mov    %esp,%ebp
80102517:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102518:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010251b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010251e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010251f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102525:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010252b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102531:	39 de                	cmp    %ebx,%esi
80102533:	72 1f                	jb     80102554 <freerange+0x44>
80102535:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 23 ff ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 f3                	cmp    %esi,%ebx
80102552:	76 e4                	jbe    80102538 <freerange+0x28>
}
80102554:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102557:	5b                   	pop    %ebx
80102558:	5e                   	pop    %esi
80102559:	5d                   	pop    %ebp
8010255a:	c3                   	ret    
8010255b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010255f:	90                   	nop

80102560 <kinit1>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
80102568:	53                   	push   %ebx
80102569:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010256c:	83 ec 08             	sub    $0x8,%esp
8010256f:	68 0c 7c 10 80       	push   $0x80107c0c
80102574:	68 40 36 11 80       	push   $0x80113640
80102579:	e8 c2 1e 00 00       	call   80104440 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010257e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102584:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
8010258b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010258e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102594:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025a0:	39 de                	cmp    %ebx,%esi
801025a2:	72 20                	jb     801025c4 <kinit1+0x64>
801025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025b7:	50                   	push   %eax
801025b8:	e8 b3 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
801025c0:	39 de                	cmp    %ebx,%esi
801025c2:	73 e4                	jae    801025a8 <kinit1+0x48>
}
801025c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025c7:	5b                   	pop    %ebx
801025c8:	5e                   	pop    %esi
801025c9:	5d                   	pop    %ebp
801025ca:	c3                   	ret    
801025cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop

801025d0 <kinit2>:
{
801025d0:	f3 0f 1e fb          	endbr32 
801025d4:	55                   	push   %ebp
801025d5:	89 e5                	mov    %esp,%ebp
801025d7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801025d8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025db:	8b 75 0c             	mov    0xc(%ebp),%esi
801025de:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025df:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025eb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f1:	39 de                	cmp    %ebx,%esi
801025f3:	72 1f                	jb     80102614 <kinit2+0x44>
801025f5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 63 fe ff ff       	call   80102470 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit2+0x28>
  kmem.use_lock = 1;
80102614:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010261b:	00 00 00 
}
8010261e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102621:	5b                   	pop    %ebx
80102622:	5e                   	pop    %esi
80102623:	5d                   	pop    %ebp
80102624:	c3                   	ret    
80102625:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102630 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102630:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102634:	a1 74 36 11 80       	mov    0x80113674,%eax
80102639:	85 c0                	test   %eax,%eax
8010263b:	75 1b                	jne    80102658 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010263d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102642:	85 c0                	test   %eax,%eax
80102644:	74 0a                	je     80102650 <kalloc+0x20>
    kmem.freelist = r->next;
80102646:	8b 10                	mov    (%eax),%edx
80102648:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010264e:	c3                   	ret    
8010264f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102650:	c3                   	ret    
80102651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102658:	55                   	push   %ebp
80102659:	89 e5                	mov    %esp,%ebp
8010265b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010265e:	68 40 36 11 80       	push   $0x80113640
80102663:	e8 58 1f 00 00       	call   801045c0 <acquire>
  r = kmem.freelist;
80102668:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010266d:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102673:	83 c4 10             	add    $0x10,%esp
80102676:	85 c0                	test   %eax,%eax
80102678:	74 08                	je     80102682 <kalloc+0x52>
    kmem.freelist = r->next;
8010267a:	8b 08                	mov    (%eax),%ecx
8010267c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102682:	85 d2                	test   %edx,%edx
80102684:	74 16                	je     8010269c <kalloc+0x6c>
    release(&kmem.lock);
80102686:	83 ec 0c             	sub    $0xc,%esp
80102689:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010268c:	68 40 36 11 80       	push   $0x80113640
80102691:	e8 ea 1f 00 00       	call   80104680 <release>
  return (char*)r;
80102696:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102699:	83 c4 10             	add    $0x10,%esp
}
8010269c:	c9                   	leave  
8010269d:	c3                   	ret    
8010269e:	66 90                	xchg   %ax,%ax

801026a0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026a0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026a4:	ba 64 00 00 00       	mov    $0x64,%edx
801026a9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026aa:	a8 01                	test   $0x1,%al
801026ac:	0f 84 be 00 00 00    	je     80102770 <kbdgetc+0xd0>
{
801026b2:	55                   	push   %ebp
801026b3:	ba 60 00 00 00       	mov    $0x60,%edx
801026b8:	89 e5                	mov    %esp,%ebp
801026ba:	53                   	push   %ebx
801026bb:	ec                   	in     (%dx),%al
  return data;
801026bc:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
801026c2:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801026c5:	3c e0                	cmp    $0xe0,%al
801026c7:	74 57                	je     80102720 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801026c9:	89 d9                	mov    %ebx,%ecx
801026cb:	83 e1 40             	and    $0x40,%ecx
801026ce:	84 c0                	test   %al,%al
801026d0:	78 5e                	js     80102730 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801026d2:	85 c9                	test   %ecx,%ecx
801026d4:	74 09                	je     801026df <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801026d6:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801026d9:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801026dc:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801026df:	0f b6 8a 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%ecx
  shift ^= togglecode[data];
801026e6:	0f b6 82 40 7c 10 80 	movzbl -0x7fef83c0(%edx),%eax
  shift |= shiftcode[data];
801026ed:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
801026ef:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026f1:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801026f3:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801026f9:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801026fc:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801026ff:	8b 04 85 20 7c 10 80 	mov    -0x7fef83e0(,%eax,4),%eax
80102706:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010270a:	74 0b                	je     80102717 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010270c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010270f:	83 fa 19             	cmp    $0x19,%edx
80102712:	77 44                	ja     80102758 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102714:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102717:	5b                   	pop    %ebx
80102718:	5d                   	pop    %ebp
80102719:	c3                   	ret    
8010271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102720:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102723:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102725:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010272b:	5b                   	pop    %ebx
8010272c:	5d                   	pop    %ebp
8010272d:	c3                   	ret    
8010272e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102730:	83 e0 7f             	and    $0x7f,%eax
80102733:	85 c9                	test   %ecx,%ecx
80102735:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102738:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010273a:	0f b6 8a 40 7d 10 80 	movzbl -0x7fef82c0(%edx),%ecx
80102741:	83 c9 40             	or     $0x40,%ecx
80102744:	0f b6 c9             	movzbl %cl,%ecx
80102747:	f7 d1                	not    %ecx
80102749:	21 d9                	and    %ebx,%ecx
}
8010274b:	5b                   	pop    %ebx
8010274c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010274d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102753:	c3                   	ret    
80102754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102758:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010275b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010275e:	5b                   	pop    %ebx
8010275f:	5d                   	pop    %ebp
      c += 'a' - 'A';
80102760:	83 f9 1a             	cmp    $0x1a,%ecx
80102763:	0f 42 c2             	cmovb  %edx,%eax
}
80102766:	c3                   	ret    
80102767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010276e:	66 90                	xchg   %ax,%ax
    return -1;
80102770:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102775:	c3                   	ret    
80102776:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010277d:	8d 76 00             	lea    0x0(%esi),%esi

80102780 <kbdintr>:

void
kbdintr(void)
{
80102780:	f3 0f 1e fb          	endbr32 
80102784:	55                   	push   %ebp
80102785:	89 e5                	mov    %esp,%ebp
80102787:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010278a:	68 a0 26 10 80       	push   $0x801026a0
8010278f:	e8 cc e0 ff ff       	call   80100860 <consoleintr>
}
80102794:	83 c4 10             	add    $0x10,%esp
80102797:	c9                   	leave  
80102798:	c3                   	ret    
80102799:	66 90                	xchg   %ax,%ax
8010279b:	66 90                	xchg   %ax,%ax
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027a0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027a9:	85 c0                	test   %eax,%eax
801027ab:	0f 84 c7 00 00 00    	je     80102878 <lapicinit+0xd8>
  lapic[index] = value;
801027b1:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027b8:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027bb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027be:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801027c5:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c8:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027cb:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801027d2:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801027d5:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027d8:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801027df:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801027e2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027e5:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801027ec:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027f2:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801027f9:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801027ff:	8b 50 30             	mov    0x30(%eax),%edx
80102802:	c1 ea 10             	shr    $0x10,%edx
80102805:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010280b:	75 73                	jne    80102880 <lapicinit+0xe0>
  lapic[index] = value;
8010280d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102814:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102817:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102821:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102827:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010282e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102831:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102834:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010283b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102841:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102848:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010284b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010284e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102855:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102858:	8b 50 20             	mov    0x20(%eax),%edx
8010285b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010285f:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102860:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102866:	80 e6 10             	and    $0x10,%dh
80102869:	75 f5                	jne    80102860 <lapicinit+0xc0>
  lapic[index] = value;
8010286b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102872:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102875:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102878:	c3                   	ret    
80102879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102880:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102887:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010288a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010288d:	e9 7b ff ff ff       	jmp    8010280d <lapicinit+0x6d>
80102892:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028a0 <lapicid>:

int
lapicid(void)
{
801028a0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028a4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028a9:	85 c0                	test   %eax,%eax
801028ab:	74 0b                	je     801028b8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028ad:	8b 40 20             	mov    0x20(%eax),%eax
801028b0:	c1 e8 18             	shr    $0x18,%eax
801028b3:	c3                   	ret    
801028b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801028b8:	31 c0                	xor    %eax,%eax
}
801028ba:	c3                   	ret    
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop

801028c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801028c0:	f3 0f 1e fb          	endbr32 
  if(lapic)
801028c4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028c9:	85 c0                	test   %eax,%eax
801028cb:	74 0d                	je     801028da <lapiceoi+0x1a>
  lapic[index] = value;
801028cd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d7:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801028da:	c3                   	ret    
801028db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028df:	90                   	nop

801028e0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028e0:	f3 0f 1e fb          	endbr32 
}
801028e4:	c3                   	ret    
801028e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028f0:	f3 0f 1e fb          	endbr32 
801028f4:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f5:	b8 0f 00 00 00       	mov    $0xf,%eax
801028fa:	ba 70 00 00 00       	mov    $0x70,%edx
801028ff:	89 e5                	mov    %esp,%ebp
80102901:	53                   	push   %ebx
80102902:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102905:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102908:	ee                   	out    %al,(%dx)
80102909:	b8 0a 00 00 00       	mov    $0xa,%eax
8010290e:	ba 71 00 00 00       	mov    $0x71,%edx
80102913:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102914:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102916:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102919:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010291f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102921:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102924:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102926:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102929:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010292c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102932:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102937:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010293d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102940:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102947:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010294a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010294d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102954:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102957:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010295a:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102960:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102963:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102969:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010296c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102972:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102975:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010297b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010297c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010297f:	5d                   	pop    %ebp
80102980:	c3                   	ret    
80102981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102988:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010298f:	90                   	nop

80102990 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102990:	f3 0f 1e fb          	endbr32 
80102994:	55                   	push   %ebp
80102995:	b8 0b 00 00 00       	mov    $0xb,%eax
8010299a:	ba 70 00 00 00       	mov    $0x70,%edx
8010299f:	89 e5                	mov    %esp,%ebp
801029a1:	57                   	push   %edi
801029a2:	56                   	push   %esi
801029a3:	53                   	push   %ebx
801029a4:	83 ec 4c             	sub    $0x4c,%esp
801029a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a8:	ba 71 00 00 00       	mov    $0x71,%edx
801029ad:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029ae:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b1:	bb 70 00 00 00       	mov    $0x70,%ebx
801029b6:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029c0:	31 c0                	xor    %eax,%eax
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801029ca:	89 ca                	mov    %ecx,%edx
801029cc:	ec                   	in     (%dx),%al
801029cd:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d0:	89 da                	mov    %ebx,%edx
801029d2:	b8 02 00 00 00       	mov    $0x2,%eax
801029d7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d8:	89 ca                	mov    %ecx,%edx
801029da:	ec                   	in     (%dx),%al
801029db:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029de:	89 da                	mov    %ebx,%edx
801029e0:	b8 04 00 00 00       	mov    $0x4,%eax
801029e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e6:	89 ca                	mov    %ecx,%edx
801029e8:	ec                   	in     (%dx),%al
801029e9:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029ec:	89 da                	mov    %ebx,%edx
801029ee:	b8 07 00 00 00       	mov    $0x7,%eax
801029f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f4:	89 ca                	mov    %ecx,%edx
801029f6:	ec                   	in     (%dx),%al
801029f7:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029fa:	89 da                	mov    %ebx,%edx
801029fc:	b8 08 00 00 00       	mov    $0x8,%eax
80102a01:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a02:	89 ca                	mov    %ecx,%edx
80102a04:	ec                   	in     (%dx),%al
80102a05:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a07:	89 da                	mov    %ebx,%edx
80102a09:	b8 09 00 00 00       	mov    $0x9,%eax
80102a0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0f:	89 ca                	mov    %ecx,%edx
80102a11:	ec                   	in     (%dx),%al
80102a12:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a1f:	84 c0                	test   %al,%al
80102a21:	78 9d                	js     801029c0 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a23:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a27:	89 fa                	mov    %edi,%edx
80102a29:	0f b6 fa             	movzbl %dl,%edi
80102a2c:	89 f2                	mov    %esi,%edx
80102a2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a31:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a35:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a38:	89 da                	mov    %ebx,%edx
80102a3a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a3d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a40:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a44:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a47:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a4a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a4e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a51:	31 c0                	xor    %eax,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a5f:	b8 02 00 00 00       	mov    $0x2,%eax
80102a64:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a65:	89 ca                	mov    %ecx,%edx
80102a67:	ec                   	in     (%dx),%al
80102a68:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a6b:	89 da                	mov    %ebx,%edx
80102a6d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a70:	b8 04 00 00 00       	mov    $0x4,%eax
80102a75:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a76:	89 ca                	mov    %ecx,%edx
80102a78:	ec                   	in     (%dx),%al
80102a79:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a7c:	89 da                	mov    %ebx,%edx
80102a7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a81:	b8 07 00 00 00       	mov    $0x7,%eax
80102a86:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a87:	89 ca                	mov    %ecx,%edx
80102a89:	ec                   	in     (%dx),%al
80102a8a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	89 da                	mov    %ebx,%edx
80102a8f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a92:	b8 08 00 00 00       	mov    $0x8,%eax
80102a97:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a98:	89 ca                	mov    %ecx,%edx
80102a9a:	ec                   	in     (%dx),%al
80102a9b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9e:	89 da                	mov    %ebx,%edx
80102aa0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102aa3:	b8 09 00 00 00       	mov    $0x9,%eax
80102aa8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa9:	89 ca                	mov    %ecx,%edx
80102aab:	ec                   	in     (%dx),%al
80102aac:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aaf:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ab5:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ab8:	6a 18                	push   $0x18
80102aba:	50                   	push   %eax
80102abb:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102abe:	50                   	push   %eax
80102abf:	e8 5c 1c 00 00       	call   80104720 <memcmp>
80102ac4:	83 c4 10             	add    $0x10,%esp
80102ac7:	85 c0                	test   %eax,%eax
80102ac9:	0f 85 f1 fe ff ff    	jne    801029c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102acf:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ad3:	75 78                	jne    80102b4d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ad5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	83 e0 0f             	and    $0xf,%eax
80102add:	c1 ea 04             	shr    $0x4,%edx
80102ae0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ae3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ae6:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102ae9:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aec:	89 c2                	mov    %eax,%edx
80102aee:	83 e0 0f             	and    $0xf,%eax
80102af1:	c1 ea 04             	shr    $0x4,%edx
80102af4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102af7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102afa:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102afd:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b11:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b39:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b4d:	8b 75 08             	mov    0x8(%ebp),%esi
80102b50:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b53:	89 06                	mov    %eax,(%esi)
80102b55:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b58:	89 46 04             	mov    %eax,0x4(%esi)
80102b5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b5e:	89 46 08             	mov    %eax,0x8(%esi)
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 46 0c             	mov    %eax,0xc(%esi)
80102b67:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b6a:	89 46 10             	mov    %eax,0x10(%esi)
80102b6d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b70:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b73:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7d:	5b                   	pop    %ebx
80102b7e:	5e                   	pop    %esi
80102b7f:	5f                   	pop    %edi
80102b80:	5d                   	pop    %ebp
80102b81:	c3                   	ret    
80102b82:	66 90                	xchg   %ax,%ax
80102b84:	66 90                	xchg   %ax,%ax
80102b86:	66 90                	xchg   %ax,%ax
80102b88:	66 90                	xchg   %ax,%ax
80102b8a:	66 90                	xchg   %ax,%ax
80102b8c:	66 90                	xchg   %ax,%ax
80102b8e:	66 90                	xchg   %ax,%ax

80102b90 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b90:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102b96:	85 c9                	test   %ecx,%ecx
80102b98:	0f 8e 8a 00 00 00    	jle    80102c28 <install_trans+0x98>
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ba2:	31 ff                	xor    %edi,%edi
{
80102ba4:	56                   	push   %esi
80102ba5:	53                   	push   %ebx
80102ba6:	83 ec 0c             	sub    $0xc,%esp
80102ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bb0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102bb5:	83 ec 08             	sub    $0x8,%esp
80102bb8:	01 f8                	add    %edi,%eax
80102bba:	83 c0 01             	add    $0x1,%eax
80102bbd:	50                   	push   %eax
80102bbe:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102bc4:	e8 07 d5 ff ff       	call   801000d0 <bread>
80102bc9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bcb:	58                   	pop    %eax
80102bcc:	5a                   	pop    %edx
80102bcd:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102bd4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102bda:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bdd:	e8 ee d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102be5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102be7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102bea:	68 00 02 00 00       	push   $0x200
80102bef:	50                   	push   %eax
80102bf0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102bf3:	50                   	push   %eax
80102bf4:	e8 77 1b 00 00       	call   80104770 <memmove>
    bwrite(dbuf);  // write dst to disk
80102bf9:	89 1c 24             	mov    %ebx,(%esp)
80102bfc:	e8 af d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c01:	89 34 24             	mov    %esi,(%esp)
80102c04:	e8 e7 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c09:	89 1c 24             	mov    %ebx,(%esp)
80102c0c:	e8 df d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c1a:	7f 94                	jg     80102bb0 <install_trans+0x20>
  }
}
80102c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c1f:	5b                   	pop    %ebx
80102c20:	5e                   	pop    %esi
80102c21:	5f                   	pop    %edi
80102c22:	5d                   	pop    %ebp
80102c23:	c3                   	ret    
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c28:	c3                   	ret    
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c30:	55                   	push   %ebp
80102c31:	89 e5                	mov    %esp,%ebp
80102c33:	53                   	push   %ebx
80102c34:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c37:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c3d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c48:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c4d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102c52:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102c55:	85 c0                	test   %eax,%eax
80102c57:	7e 19                	jle    80102c72 <write_head+0x42>
80102c59:	31 d2                	xor    %edx,%edx
80102c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c5f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102c60:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102c67:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c6b:	83 c2 01             	add    $0x1,%edx
80102c6e:	39 d0                	cmp    %edx,%eax
80102c70:	75 ee                	jne    80102c60 <write_head+0x30>
  }
  bwrite(buf);
80102c72:	83 ec 0c             	sub    $0xc,%esp
80102c75:	53                   	push   %ebx
80102c76:	e8 35 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102c7b:	89 1c 24             	mov    %ebx,(%esp)
80102c7e:	e8 6d d5 ff ff       	call   801001f0 <brelse>
}
80102c83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c86:	83 c4 10             	add    $0x10,%esp
80102c89:	c9                   	leave  
80102c8a:	c3                   	ret    
80102c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c8f:	90                   	nop

80102c90 <initlog>:
{
80102c90:	f3 0f 1e fb          	endbr32 
80102c94:	55                   	push   %ebp
80102c95:	89 e5                	mov    %esp,%ebp
80102c97:	53                   	push   %ebx
80102c98:	83 ec 2c             	sub    $0x2c,%esp
80102c9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102c9e:	68 40 7e 10 80       	push   $0x80107e40
80102ca3:	68 80 36 11 80       	push   $0x80113680
80102ca8:	e8 93 17 00 00       	call   80104440 <initlock>
  readsb(dev, &sb);
80102cad:	58                   	pop    %eax
80102cae:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102cb1:	5a                   	pop    %edx
80102cb2:	50                   	push   %eax
80102cb3:	53                   	push   %ebx
80102cb4:	e8 47 e8 ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80102cb9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cbc:	59                   	pop    %ecx
  log.dev = dev;
80102cbd:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102cc3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cc6:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102ccb:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102cd1:	5a                   	pop    %edx
80102cd2:	50                   	push   %eax
80102cd3:	53                   	push   %ebx
80102cd4:	e8 f7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102cd9:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102cdc:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102cdf:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102ce5:	85 c9                	test   %ecx,%ecx
80102ce7:	7e 19                	jle    80102d02 <initlog+0x72>
80102ce9:	31 d2                	xor    %edx,%edx
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102cf0:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102cf4:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cfb:	83 c2 01             	add    $0x1,%edx
80102cfe:	39 d1                	cmp    %edx,%ecx
80102d00:	75 ee                	jne    80102cf0 <initlog+0x60>
  brelse(buf);
80102d02:	83 ec 0c             	sub    $0xc,%esp
80102d05:	50                   	push   %eax
80102d06:	e8 e5 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d0b:	e8 80 fe ff ff       	call   80102b90 <install_trans>
  log.lh.n = 0;
80102d10:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d17:	00 00 00 
  write_head(); // clear the log
80102d1a:	e8 11 ff ff ff       	call   80102c30 <write_head>
}
80102d1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d22:	83 c4 10             	add    $0x10,%esp
80102d25:	c9                   	leave  
80102d26:	c3                   	ret    
80102d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d2e:	66 90                	xchg   %ax,%ax

80102d30 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d30:	f3 0f 1e fb          	endbr32 
80102d34:	55                   	push   %ebp
80102d35:	89 e5                	mov    %esp,%ebp
80102d37:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d3a:	68 80 36 11 80       	push   $0x80113680
80102d3f:	e8 7c 18 00 00       	call   801045c0 <acquire>
80102d44:	83 c4 10             	add    $0x10,%esp
80102d47:	eb 1c                	jmp    80102d65 <begin_op+0x35>
80102d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d50:	83 ec 08             	sub    $0x8,%esp
80102d53:	68 80 36 11 80       	push   $0x80113680
80102d58:	68 80 36 11 80       	push   $0x80113680
80102d5d:	e8 fe 11 00 00       	call   80103f60 <sleep>
80102d62:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d65:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102d6a:	85 c0                	test   %eax,%eax
80102d6c:	75 e2                	jne    80102d50 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d6e:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102d73:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102d79:	83 c0 01             	add    $0x1,%eax
80102d7c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d7f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d82:	83 fa 1e             	cmp    $0x1e,%edx
80102d85:	7f c9                	jg     80102d50 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d87:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102d8a:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102d8f:	68 80 36 11 80       	push   $0x80113680
80102d94:	e8 e7 18 00 00       	call   80104680 <release>
      break;
    }
  }
}
80102d99:	83 c4 10             	add    $0x10,%esp
80102d9c:	c9                   	leave  
80102d9d:	c3                   	ret    
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102da0:	f3 0f 1e fb          	endbr32 
80102da4:	55                   	push   %ebp
80102da5:	89 e5                	mov    %esp,%ebp
80102da7:	57                   	push   %edi
80102da8:	56                   	push   %esi
80102da9:	53                   	push   %ebx
80102daa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dad:	68 80 36 11 80       	push   $0x80113680
80102db2:	e8 09 18 00 00       	call   801045c0 <acquire>
  log.outstanding -= 1;
80102db7:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102dbc:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102dc2:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102dc5:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102dc8:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102dce:	85 f6                	test   %esi,%esi
80102dd0:	0f 85 1e 01 00 00    	jne    80102ef4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102dd6:	85 db                	test   %ebx,%ebx
80102dd8:	0f 85 f2 00 00 00    	jne    80102ed0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102dde:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102de5:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 80 36 11 80       	push   $0x80113680
80102df0:	e8 8b 18 00 00       	call   80104680 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102df5:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102dfb:	83 c4 10             	add    $0x10,%esp
80102dfe:	85 c9                	test   %ecx,%ecx
80102e00:	7f 3e                	jg     80102e40 <end_op+0xa0>
    acquire(&log.lock);
80102e02:	83 ec 0c             	sub    $0xc,%esp
80102e05:	68 80 36 11 80       	push   $0x80113680
80102e0a:	e8 b1 17 00 00       	call   801045c0 <acquire>
    wakeup(&log);
80102e0f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e16:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e1d:	00 00 00 
    wakeup(&log);
80102e20:	e8 fb 12 00 00       	call   80104120 <wakeup>
    release(&log.lock);
80102e25:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e2c:	e8 4f 18 00 00       	call   80104680 <release>
80102e31:	83 c4 10             	add    $0x10,%esp
}
80102e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e37:	5b                   	pop    %ebx
80102e38:	5e                   	pop    %esi
80102e39:	5f                   	pop    %edi
80102e3a:	5d                   	pop    %ebp
80102e3b:	c3                   	ret    
80102e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e40:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	01 d8                	add    %ebx,%eax
80102e4a:	83 c0 01             	add    $0x1,%eax
80102e4d:	50                   	push   %eax
80102e4e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
80102e59:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e5b:	58                   	pop    %eax
80102e5c:	5a                   	pop    %edx
80102e5d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102e64:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102e6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e6d:	e8 5e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102e72:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e75:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e77:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e7a:	68 00 02 00 00       	push   $0x200
80102e7f:	50                   	push   %eax
80102e80:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e83:	50                   	push   %eax
80102e84:	e8 e7 18 00 00       	call   80104770 <memmove>
    bwrite(to);  // write the log
80102e89:	89 34 24             	mov    %esi,(%esp)
80102e8c:	e8 1f d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102e91:	89 3c 24             	mov    %edi,(%esp)
80102e94:	e8 57 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102e99:	89 34 24             	mov    %esi,(%esp)
80102e9c:	e8 4f d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ea1:	83 c4 10             	add    $0x10,%esp
80102ea4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102eaa:	7c 94                	jl     80102e40 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102eac:	e8 7f fd ff ff       	call   80102c30 <write_head>
    install_trans(); // Now install writes to home locations
80102eb1:	e8 da fc ff ff       	call   80102b90 <install_trans>
    log.lh.n = 0;
80102eb6:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102ebd:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ec0:	e8 6b fd ff ff       	call   80102c30 <write_head>
80102ec5:	e9 38 ff ff ff       	jmp    80102e02 <end_op+0x62>
80102eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102ed0:	83 ec 0c             	sub    $0xc,%esp
80102ed3:	68 80 36 11 80       	push   $0x80113680
80102ed8:	e8 43 12 00 00       	call   80104120 <wakeup>
  release(&log.lock);
80102edd:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102ee4:	e8 97 17 00 00       	call   80104680 <release>
80102ee9:	83 c4 10             	add    $0x10,%esp
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
    panic("log.committing");
80102ef4:	83 ec 0c             	sub    $0xc,%esp
80102ef7:	68 44 7e 10 80       	push   $0x80107e44
80102efc:	e8 8f d4 ff ff       	call   80100390 <panic>
80102f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f0f:	90                   	nop

80102f10 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f1b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f21:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f24:	83 fa 1d             	cmp    $0x1d,%edx
80102f27:	0f 8f 91 00 00 00    	jg     80102fbe <log_write+0xae>
80102f2d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f32:	83 e8 01             	sub    $0x1,%eax
80102f35:	39 c2                	cmp    %eax,%edx
80102f37:	0f 8d 81 00 00 00    	jge    80102fbe <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f3d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f42:	85 c0                	test   %eax,%eax
80102f44:	0f 8e 81 00 00 00    	jle    80102fcb <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f4a:	83 ec 0c             	sub    $0xc,%esp
80102f4d:	68 80 36 11 80       	push   $0x80113680
80102f52:	e8 69 16 00 00       	call   801045c0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f57:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102f5d:	83 c4 10             	add    $0x10,%esp
80102f60:	85 d2                	test   %edx,%edx
80102f62:	7e 4e                	jle    80102fb2 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f64:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102f67:	31 c0                	xor    %eax,%eax
80102f69:	eb 0c                	jmp    80102f77 <log_write+0x67>
80102f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop
80102f70:	83 c0 01             	add    $0x1,%eax
80102f73:	39 c2                	cmp    %eax,%edx
80102f75:	74 29                	je     80102fa0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f77:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102f7e:	75 f0                	jne    80102f70 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f80:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102f87:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102f8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102f8d:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102f94:	c9                   	leave  
  release(&log.lock);
80102f95:	e9 e6 16 00 00       	jmp    80104680 <release>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fa0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102fa7:	83 c2 01             	add    $0x1,%edx
80102faa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80102fb0:	eb d5                	jmp    80102f87 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80102fb2:	8b 43 08             	mov    0x8(%ebx),%eax
80102fb5:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80102fba:	75 cb                	jne    80102f87 <log_write+0x77>
80102fbc:	eb e9                	jmp    80102fa7 <log_write+0x97>
    panic("too big a transaction");
80102fbe:	83 ec 0c             	sub    $0xc,%esp
80102fc1:	68 53 7e 10 80       	push   $0x80107e53
80102fc6:	e8 c5 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	68 69 7e 10 80       	push   $0x80107e69
80102fd3:	e8 b8 d3 ff ff       	call   80100390 <panic>
80102fd8:	66 90                	xchg   %ax,%ax
80102fda:	66 90                	xchg   %ax,%ax
80102fdc:	66 90                	xchg   %ax,%ax
80102fde:	66 90                	xchg   %ax,%ax

80102fe0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102fe7:	e8 74 09 00 00       	call   80103960 <cpuid>
80102fec:	89 c3                	mov    %eax,%ebx
80102fee:	e8 6d 09 00 00       	call   80103960 <cpuid>
80102ff3:	83 ec 04             	sub    $0x4,%esp
80102ff6:	53                   	push   %ebx
80102ff7:	50                   	push   %eax
80102ff8:	68 84 7e 10 80       	push   $0x80107e84
80102ffd:	e8 ae d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103002:	e8 c9 31 00 00       	call   801061d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103007:	e8 e4 08 00 00       	call   801038f0 <mycpu>
8010300c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010300e:	b8 01 00 00 00       	mov    $0x1,%eax
80103013:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010301a:	e8 31 0c 00 00       	call   80103c50 <scheduler>
8010301f:	90                   	nop

80103020 <mpenter>:
{
80103020:	f3 0f 1e fb          	endbr32 
80103024:	55                   	push   %ebp
80103025:	89 e5                	mov    %esp,%ebp
80103027:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010302a:	e8 71 42 00 00       	call   801072a0 <switchkvm>
  seginit();
8010302f:	e8 dc 41 00 00       	call   80107210 <seginit>
  lapicinit();
80103034:	e8 67 f7 ff ff       	call   801027a0 <lapicinit>
  mpmain();
80103039:	e8 a2 ff ff ff       	call   80102fe0 <mpmain>
8010303e:	66 90                	xchg   %ax,%ax

80103040 <main>:
{
80103040:	f3 0f 1e fb          	endbr32 
80103044:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103048:	83 e4 f0             	and    $0xfffffff0,%esp
8010304b:	ff 71 fc             	pushl  -0x4(%ecx)
8010304e:	55                   	push   %ebp
8010304f:	89 e5                	mov    %esp,%ebp
80103051:	53                   	push   %ebx
80103052:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 40 80       	push   $0x80400000
8010305b:	68 a8 7e 11 80       	push   $0x80117ea8
80103060:	e8 fb f4 ff ff       	call   80102560 <kinit1>
  kvmalloc();      // kernel page table
80103065:	e8 16 47 00 00       	call   80107780 <kvmalloc>
  mpinit();        // detect other processors
8010306a:	e8 81 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010306f:	e8 2c f7 ff ff       	call   801027a0 <lapicinit>
  seginit();       // segment descriptors
80103074:	e8 97 41 00 00       	call   80107210 <seginit>
  picinit();       // disable pic
80103079:	e8 52 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010307e:	e8 fd f2 ff ff       	call   80102380 <ioapicinit>
  consoleinit();   // console hardware
80103083:	e8 a8 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103088:	e8 43 34 00 00       	call   801064d0 <uartinit>
  pinit();         // process table
8010308d:	e8 3e 08 00 00       	call   801038d0 <pinit>
  tvinit();        // trap vectors
80103092:	e8 b9 30 00 00       	call   80106150 <tvinit>
  binit();         // buffer cache
80103097:	e8 a4 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010309c:	e8 3f dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
801030a1:	e8 aa f0 ff ff       	call   80102150 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030a6:	83 c4 0c             	add    $0xc,%esp
801030a9:	68 8a 00 00 00       	push   $0x8a
801030ae:	68 8c b4 10 80       	push   $0x8010b48c
801030b3:	68 00 70 00 80       	push   $0x80007000
801030b8:	e8 b3 16 00 00       	call   80104770 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030bd:	83 c4 10             	add    $0x10,%esp
801030c0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030c7:	00 00 00 
801030ca:	05 80 37 11 80       	add    $0x80113780,%eax
801030cf:	3d 80 37 11 80       	cmp    $0x80113780,%eax
801030d4:	76 7a                	jbe    80103150 <main+0x110>
801030d6:	bb 80 37 11 80       	mov    $0x80113780,%ebx
801030db:	eb 1c                	jmp    801030f9 <main+0xb9>
801030dd:	8d 76 00             	lea    0x0(%esi),%esi
801030e0:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801030e7:	00 00 00 
801030ea:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801030f0:	05 80 37 11 80       	add    $0x80113780,%eax
801030f5:	39 c3                	cmp    %eax,%ebx
801030f7:	73 57                	jae    80103150 <main+0x110>
    if(c == mycpu())  // We've started already.
801030f9:	e8 f2 07 00 00       	call   801038f0 <mycpu>
801030fe:	39 c3                	cmp    %eax,%ebx
80103100:	74 de                	je     801030e0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103102:	e8 29 f5 ff ff       	call   80102630 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103107:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010310a:	c7 05 f8 6f 00 80 20 	movl   $0x80103020,0x80006ff8
80103111:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103114:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010311b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010311e:	05 00 10 00 00       	add    $0x1000,%eax
80103123:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103128:	0f b6 03             	movzbl (%ebx),%eax
8010312b:	68 00 70 00 00       	push   $0x7000
80103130:	50                   	push   %eax
80103131:	e8 ba f7 ff ff       	call   801028f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103136:	83 c4 10             	add    $0x10,%esp
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103146:	85 c0                	test   %eax,%eax
80103148:	74 f6                	je     80103140 <main+0x100>
8010314a:	eb 94                	jmp    801030e0 <main+0xa0>
8010314c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103150:	83 ec 08             	sub    $0x8,%esp
80103153:	68 00 00 00 8e       	push   $0x8e000000
80103158:	68 00 00 40 80       	push   $0x80400000
8010315d:	e8 6e f4 ff ff       	call   801025d0 <kinit2>
  userinit();      // first user process
80103162:	e8 49 08 00 00       	call   801039b0 <userinit>
  mpmain();        // finish this processor's setup
80103167:	e8 74 fe ff ff       	call   80102fe0 <mpmain>
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103175:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010317b:	53                   	push   %ebx
  e = addr+len;
8010317c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010317f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103182:	39 de                	cmp    %ebx,%esi
80103184:	72 10                	jb     80103196 <mpsearch1+0x26>
80103186:	eb 50                	jmp    801031d8 <mpsearch1+0x68>
80103188:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010318f:	90                   	nop
80103190:	89 fe                	mov    %edi,%esi
80103192:	39 fb                	cmp    %edi,%ebx
80103194:	76 42                	jbe    801031d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103196:	83 ec 04             	sub    $0x4,%esp
80103199:	8d 7e 10             	lea    0x10(%esi),%edi
8010319c:	6a 04                	push   $0x4
8010319e:	68 98 7e 10 80       	push   $0x80107e98
801031a3:	56                   	push   %esi
801031a4:	e8 77 15 00 00       	call   80104720 <memcmp>
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	85 c0                	test   %eax,%eax
801031ae:	75 e0                	jne    80103190 <mpsearch1+0x20>
801031b0:	89 f2                	mov    %esi,%edx
801031b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031b8:	0f b6 0a             	movzbl (%edx),%ecx
801031bb:	83 c2 01             	add    $0x1,%edx
801031be:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
801031c0:	39 fa                	cmp    %edi,%edx
801031c2:	75 f4                	jne    801031b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c4:	84 c0                	test   %al,%al
801031c6:	75 c8                	jne    80103190 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cb:	89 f0                	mov    %esi,%eax
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031db:	31 f6                	xor    %esi,%esi
}
801031dd:	5b                   	pop    %ebx
801031de:	89 f0                	mov    %esi,%eax
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
801031e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop

801031f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031f0:	f3 0f 1e fb          	endbr32 
801031f4:	55                   	push   %ebp
801031f5:	89 e5                	mov    %esp,%ebp
801031f7:	57                   	push   %edi
801031f8:	56                   	push   %esi
801031f9:	53                   	push   %ebx
801031fa:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031fd:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103204:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010320b:	c1 e0 08             	shl    $0x8,%eax
8010320e:	09 d0                	or     %edx,%eax
80103210:	c1 e0 04             	shl    $0x4,%eax
80103213:	75 1b                	jne    80103230 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103215:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010321c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103223:	c1 e0 08             	shl    $0x8,%eax
80103226:	09 d0                	or     %edx,%eax
80103228:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010322b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103230:	ba 00 04 00 00       	mov    $0x400,%edx
80103235:	e8 36 ff ff ff       	call   80103170 <mpsearch1>
8010323a:	89 c6                	mov    %eax,%esi
8010323c:	85 c0                	test   %eax,%eax
8010323e:	0f 84 4c 01 00 00    	je     80103390 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103244:	8b 5e 04             	mov    0x4(%esi),%ebx
80103247:	85 db                	test   %ebx,%ebx
80103249:	0f 84 61 01 00 00    	je     801033b0 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010324f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103252:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103258:	6a 04                	push   $0x4
8010325a:	68 9d 7e 10 80       	push   $0x80107e9d
8010325f:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103260:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103263:	e8 b8 14 00 00       	call   80104720 <memcmp>
80103268:	83 c4 10             	add    $0x10,%esp
8010326b:	85 c0                	test   %eax,%eax
8010326d:	0f 85 3d 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103273:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
8010327a:	3c 01                	cmp    $0x1,%al
8010327c:	74 08                	je     80103286 <mpinit+0x96>
8010327e:	3c 04                	cmp    $0x4,%al
80103280:	0f 85 2a 01 00 00    	jne    801033b0 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103286:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
8010328d:	66 85 d2             	test   %dx,%dx
80103290:	74 26                	je     801032b8 <mpinit+0xc8>
80103292:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103295:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103297:	31 d2                	xor    %edx,%edx
80103299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032a0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032a7:	83 c0 01             	add    $0x1,%eax
801032aa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032ac:	39 f8                	cmp    %edi,%eax
801032ae:	75 f0                	jne    801032a0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
801032b0:	84 d2                	test   %dl,%dl
801032b2:	0f 85 f8 00 00 00    	jne    801033b0 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032b8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032be:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
801032c9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
801032d0:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032d5:	03 55 e4             	add    -0x1c(%ebp),%edx
801032d8:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801032db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032df:	90                   	nop
801032e0:	39 c2                	cmp    %eax,%edx
801032e2:	76 15                	jbe    801032f9 <mpinit+0x109>
    switch(*p){
801032e4:	0f b6 08             	movzbl (%eax),%ecx
801032e7:	80 f9 02             	cmp    $0x2,%cl
801032ea:	74 5c                	je     80103348 <mpinit+0x158>
801032ec:	77 42                	ja     80103330 <mpinit+0x140>
801032ee:	84 c9                	test   %cl,%cl
801032f0:	74 6e                	je     80103360 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032f2:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032f5:	39 c2                	cmp    %eax,%edx
801032f7:	77 eb                	ja     801032e4 <mpinit+0xf4>
801032f9:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801032fc:	85 db                	test   %ebx,%ebx
801032fe:	0f 84 b9 00 00 00    	je     801033bd <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103304:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103308:	74 15                	je     8010331f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010330a:	b8 70 00 00 00       	mov    $0x70,%eax
8010330f:	ba 22 00 00 00       	mov    $0x22,%edx
80103314:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103315:	ba 23 00 00 00       	mov    $0x23,%edx
8010331a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010331b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010331e:	ee                   	out    %al,(%dx)
  }
}
8010331f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103322:	5b                   	pop    %ebx
80103323:	5e                   	pop    %esi
80103324:	5f                   	pop    %edi
80103325:	5d                   	pop    %ebp
80103326:	c3                   	ret    
80103327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010332e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103330:	83 e9 03             	sub    $0x3,%ecx
80103333:	80 f9 01             	cmp    $0x1,%cl
80103336:	76 ba                	jbe    801032f2 <mpinit+0x102>
80103338:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010333f:	eb 9f                	jmp    801032e0 <mpinit+0xf0>
80103341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103348:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010334c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010334f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
80103355:	eb 89                	jmp    801032e0 <mpinit+0xf0>
80103357:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010335e:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103360:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
80103366:	83 f9 07             	cmp    $0x7,%ecx
80103369:	7f 19                	jg     80103384 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010336b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103371:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103375:	83 c1 01             	add    $0x1,%ecx
80103378:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010337e:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
80103384:	83 c0 14             	add    $0x14,%eax
      continue;
80103387:	e9 54 ff ff ff       	jmp    801032e0 <mpinit+0xf0>
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103390:	ba 00 00 01 00       	mov    $0x10000,%edx
80103395:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010339a:	e8 d1 fd ff ff       	call   80103170 <mpsearch1>
8010339f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033a1:	85 c0                	test   %eax,%eax
801033a3:	0f 85 9b fe ff ff    	jne    80103244 <mpinit+0x54>
801033a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801033b0:	83 ec 0c             	sub    $0xc,%esp
801033b3:	68 a2 7e 10 80       	push   $0x80107ea2
801033b8:	e8 d3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033bd:	83 ec 0c             	sub    $0xc,%esp
801033c0:	68 bc 7e 10 80       	push   $0x80107ebc
801033c5:	e8 c6 cf ff ff       	call   80100390 <panic>
801033ca:	66 90                	xchg   %ax,%ax
801033cc:	66 90                	xchg   %ax,%ax
801033ce:	66 90                	xchg   %ax,%ax

801033d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033d0:	f3 0f 1e fb          	endbr32 
801033d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d9:	ba 21 00 00 00       	mov    $0x21,%edx
801033de:	ee                   	out    %al,(%dx)
801033df:	ba a1 00 00 00       	mov    $0xa1,%edx
801033e4:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033e5:	c3                   	ret    
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033f0:	f3 0f 1e fb          	endbr32 
801033f4:	55                   	push   %ebp
801033f5:	89 e5                	mov    %esp,%ebp
801033f7:	57                   	push   %edi
801033f8:	56                   	push   %esi
801033f9:	53                   	push   %ebx
801033fa:	83 ec 0c             	sub    $0xc,%esp
801033fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103400:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103403:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103409:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010340f:	e8 ec d9 ff ff       	call   80100e00 <filealloc>
80103414:	89 03                	mov    %eax,(%ebx)
80103416:	85 c0                	test   %eax,%eax
80103418:	0f 84 ac 00 00 00    	je     801034ca <pipealloc+0xda>
8010341e:	e8 dd d9 ff ff       	call   80100e00 <filealloc>
80103423:	89 06                	mov    %eax,(%esi)
80103425:	85 c0                	test   %eax,%eax
80103427:	0f 84 8b 00 00 00    	je     801034b8 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010342d:	e8 fe f1 ff ff       	call   80102630 <kalloc>
80103432:	89 c7                	mov    %eax,%edi
80103434:	85 c0                	test   %eax,%eax
80103436:	0f 84 b4 00 00 00    	je     801034f0 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010343c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103443:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103446:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103449:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103450:	00 00 00 
  p->nwrite = 0;
80103453:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010345a:	00 00 00 
  p->nread = 0;
8010345d:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103464:	00 00 00 
  initlock(&p->lock, "pipe");
80103467:	68 db 7e 10 80       	push   $0x80107edb
8010346c:	50                   	push   %eax
8010346d:	e8 ce 0f 00 00       	call   80104440 <initlock>
  (*f0)->type = FD_PIPE;
80103472:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103474:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103477:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010347d:	8b 03                	mov    (%ebx),%eax
8010347f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103483:	8b 03                	mov    (%ebx),%eax
80103485:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103489:	8b 03                	mov    (%ebx),%eax
8010348b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010348e:	8b 06                	mov    (%esi),%eax
80103490:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103496:	8b 06                	mov    (%esi),%eax
80103498:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010349c:	8b 06                	mov    (%esi),%eax
8010349e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034a2:	8b 06                	mov    (%esi),%eax
801034a4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034aa:	31 c0                	xor    %eax,%eax
}
801034ac:	5b                   	pop    %ebx
801034ad:	5e                   	pop    %esi
801034ae:	5f                   	pop    %edi
801034af:	5d                   	pop    %ebp
801034b0:	c3                   	ret    
801034b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034b8:	8b 03                	mov    (%ebx),%eax
801034ba:	85 c0                	test   %eax,%eax
801034bc:	74 1e                	je     801034dc <pipealloc+0xec>
    fileclose(*f0);
801034be:	83 ec 0c             	sub    $0xc,%esp
801034c1:	50                   	push   %eax
801034c2:	e8 f9 d9 ff ff       	call   80100ec0 <fileclose>
801034c7:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801034ca:	8b 06                	mov    (%esi),%eax
801034cc:	85 c0                	test   %eax,%eax
801034ce:	74 0c                	je     801034dc <pipealloc+0xec>
    fileclose(*f1);
801034d0:	83 ec 0c             	sub    $0xc,%esp
801034d3:	50                   	push   %eax
801034d4:	e8 e7 d9 ff ff       	call   80100ec0 <fileclose>
801034d9:	83 c4 10             	add    $0x10,%esp
}
801034dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801034df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801034e4:	5b                   	pop    %ebx
801034e5:	5e                   	pop    %esi
801034e6:	5f                   	pop    %edi
801034e7:	5d                   	pop    %ebp
801034e8:	c3                   	ret    
801034e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801034f0:	8b 03                	mov    (%ebx),%eax
801034f2:	85 c0                	test   %eax,%eax
801034f4:	75 c8                	jne    801034be <pipealloc+0xce>
801034f6:	eb d2                	jmp    801034ca <pipealloc+0xda>
801034f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ff:	90                   	nop

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	f3 0f 1e fb          	endbr32 
80103504:	55                   	push   %ebp
80103505:	89 e5                	mov    %esp,%ebp
80103507:	56                   	push   %esi
80103508:	53                   	push   %ebx
80103509:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010350c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350f:	83 ec 0c             	sub    $0xc,%esp
80103512:	53                   	push   %ebx
80103513:	e8 a8 10 00 00       	call   801045c0 <acquire>
  if(writable){
80103518:	83 c4 10             	add    $0x10,%esp
8010351b:	85 f6                	test   %esi,%esi
8010351d:	74 41                	je     80103560 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351f:	83 ec 0c             	sub    $0xc,%esp
80103522:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103528:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352f:	00 00 00 
    wakeup(&p->nread);
80103532:	50                   	push   %eax
80103533:	e8 e8 0b 00 00       	call   80104120 <wakeup>
80103538:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010353b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103541:	85 d2                	test   %edx,%edx
80103543:	75 0a                	jne    8010354f <pipeclose+0x4f>
80103545:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	74 31                	je     80103580 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103552:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103555:	5b                   	pop    %ebx
80103556:	5e                   	pop    %esi
80103557:	5d                   	pop    %ebp
    release(&p->lock);
80103558:	e9 23 11 00 00       	jmp    80104680 <release>
8010355d:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103560:	83 ec 0c             	sub    $0xc,%esp
80103563:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 a7 0b 00 00       	call   80104120 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb bd                	jmp    8010353b <pipeclose+0x3b>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 f7 10 00 00       	call   80104680 <release>
    kfree((char*)p);
80103589:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010358c:	83 c4 10             	add    $0x10,%esp
}
8010358f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5d                   	pop    %ebp
    kfree((char*)p);
80103595:	e9 d6 ee ff ff       	jmp    80102470 <kfree>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	f3 0f 1e fb          	endbr32 
801035a4:	55                   	push   %ebp
801035a5:	89 e5                	mov    %esp,%ebp
801035a7:	57                   	push   %edi
801035a8:	56                   	push   %esi
801035a9:	53                   	push   %ebx
801035aa:	83 ec 28             	sub    $0x28,%esp
801035ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035b0:	53                   	push   %ebx
801035b1:	e8 0a 10 00 00       	call   801045c0 <acquire>
  for(i = 0; i < n; i++){
801035b6:	8b 45 10             	mov    0x10(%ebp),%eax
801035b9:	83 c4 10             	add    $0x10,%esp
801035bc:	85 c0                	test   %eax,%eax
801035be:	0f 8e bc 00 00 00    	jle    80103680 <pipewrite+0xe0>
801035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801035c7:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035cd:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801035d6:	03 45 10             	add    0x10(%ebp),%eax
801035d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035dc:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035e8:	89 ca                	mov    %ecx,%edx
801035ea:	05 00 02 00 00       	add    $0x200,%eax
801035ef:	39 c1                	cmp    %eax,%ecx
801035f1:	74 3b                	je     8010362e <pipewrite+0x8e>
801035f3:	eb 63                	jmp    80103658 <pipewrite+0xb8>
801035f5:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
801035f8:	e8 83 03 00 00       	call   80103980 <myproc>
801035fd:	8b 48 24             	mov    0x24(%eax),%ecx
80103600:	85 c9                	test   %ecx,%ecx
80103602:	75 34                	jne    80103638 <pipewrite+0x98>
      wakeup(&p->nread);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	57                   	push   %edi
80103608:	e8 13 0b 00 00       	call   80104120 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010360d:	58                   	pop    %eax
8010360e:	5a                   	pop    %edx
8010360f:	53                   	push   %ebx
80103610:	56                   	push   %esi
80103611:	e8 4a 09 00 00       	call   80103f60 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103616:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010361c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103622:	83 c4 10             	add    $0x10,%esp
80103625:	05 00 02 00 00       	add    $0x200,%eax
8010362a:	39 c2                	cmp    %eax,%edx
8010362c:	75 2a                	jne    80103658 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010362e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103634:	85 c0                	test   %eax,%eax
80103636:	75 c0                	jne    801035f8 <pipewrite+0x58>
        release(&p->lock);
80103638:	83 ec 0c             	sub    $0xc,%esp
8010363b:	53                   	push   %ebx
8010363c:	e8 3f 10 00 00       	call   80104680 <release>
        return -1;
80103641:	83 c4 10             	add    $0x10,%esp
80103644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103649:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010364c:	5b                   	pop    %ebx
8010364d:	5e                   	pop    %esi
8010364e:	5f                   	pop    %edi
8010364f:	5d                   	pop    %ebp
80103650:	c3                   	ret    
80103651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103658:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010365b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010365e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103664:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010366a:	0f b6 06             	movzbl (%esi),%eax
8010366d:	83 c6 01             	add    $0x1,%esi
80103670:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80103673:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103677:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367a:	0f 85 5c ff ff ff    	jne    801035dc <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103680:	83 ec 0c             	sub    $0xc,%esp
80103683:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103689:	50                   	push   %eax
8010368a:	e8 91 0a 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010368f:	89 1c 24             	mov    %ebx,(%esp)
80103692:	e8 e9 0f 00 00       	call   80104680 <release>
  return n;
80103697:	8b 45 10             	mov    0x10(%ebp),%eax
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	eb aa                	jmp    80103649 <pipewrite+0xa9>
8010369f:	90                   	nop

801036a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036a0:	f3 0f 1e fb          	endbr32 
801036a4:	55                   	push   %ebp
801036a5:	89 e5                	mov    %esp,%ebp
801036a7:	57                   	push   %edi
801036a8:	56                   	push   %esi
801036a9:	53                   	push   %ebx
801036aa:	83 ec 18             	sub    $0x18,%esp
801036ad:	8b 75 08             	mov    0x8(%ebp),%esi
801036b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036b3:	56                   	push   %esi
801036b4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ba:	e8 01 0f 00 00       	call   801045c0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036bf:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801036ce:	74 33                	je     80103703 <piperead+0x63>
801036d0:	eb 3b                	jmp    8010370d <piperead+0x6d>
801036d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
801036d8:	e8 a3 02 00 00       	call   80103980 <myproc>
801036dd:	8b 48 24             	mov    0x24(%eax),%ecx
801036e0:	85 c9                	test   %ecx,%ecx
801036e2:	0f 85 88 00 00 00    	jne    80103770 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e8:	83 ec 08             	sub    $0x8,%esp
801036eb:	56                   	push   %esi
801036ec:	53                   	push   %ebx
801036ed:	e8 6e 08 00 00       	call   80103f60 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036f2:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801036f8:	83 c4 10             	add    $0x10,%esp
801036fb:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103701:	75 0a                	jne    8010370d <piperead+0x6d>
80103703:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103709:	85 c0                	test   %eax,%eax
8010370b:	75 cb                	jne    801036d8 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010370d:	8b 55 10             	mov    0x10(%ebp),%edx
80103710:	31 db                	xor    %ebx,%ebx
80103712:	85 d2                	test   %edx,%edx
80103714:	7f 28                	jg     8010373e <piperead+0x9e>
80103716:	eb 34                	jmp    8010374c <piperead+0xac>
80103718:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010371f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103720:	8d 48 01             	lea    0x1(%eax),%ecx
80103723:	25 ff 01 00 00       	and    $0x1ff,%eax
80103728:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010372e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103733:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103736:	83 c3 01             	add    $0x1,%ebx
80103739:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010373c:	74 0e                	je     8010374c <piperead+0xac>
    if(p->nread == p->nwrite)
8010373e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103744:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010374a:	75 d4                	jne    80103720 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010374c:	83 ec 0c             	sub    $0xc,%esp
8010374f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103755:	50                   	push   %eax
80103756:	e8 c5 09 00 00       	call   80104120 <wakeup>
  release(&p->lock);
8010375b:	89 34 24             	mov    %esi,(%esp)
8010375e:	e8 1d 0f 00 00       	call   80104680 <release>
  return i;
80103763:	83 c4 10             	add    $0x10,%esp
}
80103766:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103769:	89 d8                	mov    %ebx,%eax
8010376b:	5b                   	pop    %ebx
8010376c:	5e                   	pop    %esi
8010376d:	5f                   	pop    %edi
8010376e:	5d                   	pop    %ebp
8010376f:	c3                   	ret    
      release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103773:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103778:	56                   	push   %esi
80103779:	e8 02 0f 00 00       	call   80104680 <release>
      return -1;
8010377e:	83 c4 10             	add    $0x10,%esp
}
80103781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103784:	89 d8                	mov    %ebx,%eax
80103786:	5b                   	pop    %ebx
80103787:	5e                   	pop    %esi
80103788:	5f                   	pop    %edi
80103789:	5d                   	pop    %ebp
8010378a:	c3                   	ret    
8010378b:	66 90                	xchg   %ax,%ax
8010378d:	66 90                	xchg   %ax,%ax
8010378f:	90                   	nop

80103790 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103794:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80103799:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010379c:	68 20 3d 11 80       	push   $0x80113d20
801037a1:	e8 1a 0e 00 00       	call   801045c0 <acquire>
801037a6:	83 c4 10             	add    $0x10,%esp
801037a9:	eb 17                	jmp    801037c2 <allocproc+0x32>
801037ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037af:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b0:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
801037b6:	81 fb 54 76 11 80    	cmp    $0x80117654,%ebx
801037bc:	0f 84 86 00 00 00    	je     80103848 <allocproc+0xb8>
    if(p->state == UNUSED)
801037c2:	8b 43 0c             	mov    0xc(%ebx),%eax
801037c5:	85 c0                	test   %eax,%eax
801037c7:	75 e7                	jne    801037b0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037c9:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801037ce:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037d1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037d8:	89 43 10             	mov    %eax,0x10(%ebx)
801037db:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801037de:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
801037e3:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801037e9:	e8 92 0e 00 00       	call   80104680 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801037ee:	e8 3d ee ff ff       	call   80102630 <kalloc>
801037f3:	83 c4 10             	add    $0x10,%esp
801037f6:	89 43 08             	mov    %eax,0x8(%ebx)
801037f9:	85 c0                	test   %eax,%eax
801037fb:	74 64                	je     80103861 <allocproc+0xd1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037fd:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103803:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103806:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010380b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010380e:	c7 40 14 36 61 10 80 	movl   $0x80106136,0x14(%eax)
  p->context = (struct context*)sp;
80103815:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103818:	6a 14                	push   $0x14
8010381a:	6a 00                	push   $0x0
8010381c:	50                   	push   %eax
8010381d:	e8 ae 0e 00 00       	call   801046d0 <memset>
  p->context->eip = (uint)forkret;
80103822:	8b 43 1c             	mov    0x1c(%ebx),%eax

  p->creation_time = ticks;
  p->start_time = ticks;

  return p;
80103825:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103828:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
  p->creation_time = ticks;
8010382f:	a1 a0 7e 11 80       	mov    0x80117ea0,%eax
80103834:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->start_time = ticks;
80103837:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
}
8010383d:	89 d8                	mov    %ebx,%eax
8010383f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103842:	c9                   	leave  
80103843:	c3                   	ret    
80103844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103848:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010384b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010384d:	68 20 3d 11 80       	push   $0x80113d20
80103852:	e8 29 0e 00 00       	call   80104680 <release>
}
80103857:	89 d8                	mov    %ebx,%eax
  return 0;
80103859:	83 c4 10             	add    $0x10,%esp
}
8010385c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385f:	c9                   	leave  
80103860:	c3                   	ret    
    p->state = UNUSED;
80103861:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103868:	31 db                	xor    %ebx,%ebx
}
8010386a:	89 d8                	mov    %ebx,%eax
8010386c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386f:	c9                   	leave  
80103870:	c3                   	ret    
80103871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	f3 0f 1e fb          	endbr32 
80103884:	55                   	push   %ebp
80103885:	89 e5                	mov    %esp,%ebp
80103887:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010388a:	68 20 3d 11 80       	push   $0x80113d20
8010388f:	e8 ec 0d 00 00       	call   80104680 <release>

  if (first) {
80103894:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103899:	83 c4 10             	add    $0x10,%esp
8010389c:	85 c0                	test   %eax,%eax
8010389e:	75 08                	jne    801038a8 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038a0:	c9                   	leave  
801038a1:	c3                   	ret    
801038a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
801038a8:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038af:	00 00 00 
    iinit(ROOTDEV);
801038b2:	83 ec 0c             	sub    $0xc,%esp
801038b5:	6a 01                	push   $0x1
801038b7:	e8 84 dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
801038bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038c3:	e8 c8 f3 ff ff       	call   80102c90 <initlog>
}
801038c8:	83 c4 10             	add    $0x10,%esp
801038cb:	c9                   	leave  
801038cc:	c3                   	ret    
801038cd:	8d 76 00             	lea    0x0(%esi),%esi

801038d0 <pinit>:
{
801038d0:	f3 0f 1e fb          	endbr32 
801038d4:	55                   	push   %ebp
801038d5:	89 e5                	mov    %esp,%ebp
801038d7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038da:	68 e0 7e 10 80       	push   $0x80107ee0
801038df:	68 20 3d 11 80       	push   $0x80113d20
801038e4:	e8 57 0b 00 00       	call   80104440 <initlock>
}
801038e9:	83 c4 10             	add    $0x10,%esp
801038ec:	c9                   	leave  
801038ed:	c3                   	ret    
801038ee:	66 90                	xchg   %ax,%ax

801038f0 <mycpu>:
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	56                   	push   %esi
801038f8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801038f9:	9c                   	pushf  
801038fa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801038fb:	f6 c4 02             	test   $0x2,%ah
801038fe:	75 4a                	jne    8010394a <mycpu+0x5a>
  apicid = lapicid();
80103900:	e8 9b ef ff ff       	call   801028a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103905:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
8010390b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010390d:	85 f6                	test   %esi,%esi
8010390f:	7e 2c                	jle    8010393d <mycpu+0x4d>
80103911:	31 d2                	xor    %edx,%edx
80103913:	eb 0a                	jmp    8010391f <mycpu+0x2f>
80103915:	8d 76 00             	lea    0x0(%esi),%esi
80103918:	83 c2 01             	add    $0x1,%edx
8010391b:	39 f2                	cmp    %esi,%edx
8010391d:	74 1e                	je     8010393d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010391f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103925:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
8010392c:	39 d8                	cmp    %ebx,%eax
8010392e:	75 e8                	jne    80103918 <mycpu+0x28>
}
80103930:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103933:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
80103939:	5b                   	pop    %ebx
8010393a:	5e                   	pop    %esi
8010393b:	5d                   	pop    %ebp
8010393c:	c3                   	ret    
  panic("unknown apicid\n");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 e7 7e 10 80       	push   $0x80107ee7
80103945:	e8 46 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 c4 7f 10 80       	push   $0x80107fc4
80103952:	e8 39 ca ff ff       	call   80100390 <panic>
80103957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010395e:	66 90                	xchg   %ax,%ax

80103960 <cpuid>:
cpuid() {
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
8010396a:	e8 81 ff ff ff       	call   801038f0 <mycpu>
}
8010396f:	c9                   	leave  
  return mycpu()-cpus;
80103970:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103975:	c1 f8 04             	sar    $0x4,%eax
80103978:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010397e:	c3                   	ret    
8010397f:	90                   	nop

80103980 <myproc>:
myproc(void) {
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	53                   	push   %ebx
80103988:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010398b:	e8 30 0b 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103990:	e8 5b ff ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103995:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010399b:	e8 70 0b 00 00       	call   80104510 <popcli>
}
801039a0:	83 c4 04             	add    $0x4,%esp
801039a3:	89 d8                	mov    %ebx,%eax
801039a5:	5b                   	pop    %ebx
801039a6:	5d                   	pop    %ebp
801039a7:	c3                   	ret    
801039a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <userinit>:
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039bb:	e8 d0 fd ff ff       	call   80103790 <allocproc>
801039c0:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039c2:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
801039c7:	e8 34 3d 00 00       	call   80107700 <setupkvm>
801039cc:	89 43 04             	mov    %eax,0x4(%ebx)
801039cf:	85 c0                	test   %eax,%eax
801039d1:	0f 84 bd 00 00 00    	je     80103a94 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801039d7:	83 ec 04             	sub    $0x4,%esp
801039da:	68 2c 00 00 00       	push   $0x2c
801039df:	68 60 b4 10 80       	push   $0x8010b460
801039e4:	50                   	push   %eax
801039e5:	e8 e6 39 00 00       	call   801073d0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801039ea:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801039ed:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039f3:	6a 4c                	push   $0x4c
801039f5:	6a 00                	push   $0x0
801039f7:	ff 73 18             	pushl  0x18(%ebx)
801039fa:	e8 d1 0c 00 00       	call   801046d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039ff:	8b 43 18             	mov    0x18(%ebx),%eax
80103a02:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a07:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a0a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a0f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a13:	8b 43 18             	mov    0x18(%ebx),%eax
80103a16:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a1a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a1d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a21:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a25:	8b 43 18             	mov    0x18(%ebx),%eax
80103a28:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a2c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a30:	8b 43 18             	mov    0x18(%ebx),%eax
80103a33:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a3a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a3d:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a44:	8b 43 18             	mov    0x18(%ebx),%eax
80103a47:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a4e:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a51:	6a 10                	push   $0x10
80103a53:	68 10 7f 10 80       	push   $0x80107f10
80103a58:	50                   	push   %eax
80103a59:	e8 32 0e 00 00       	call   80104890 <safestrcpy>
  p->cwd = namei("/");
80103a5e:	c7 04 24 19 7f 10 80 	movl   $0x80107f19,(%esp)
80103a65:	e8 c6 e5 ff ff       	call   80102030 <namei>
80103a6a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103a6d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a74:	e8 47 0b 00 00       	call   801045c0 <acquire>
  p->state = RUNNABLE;
80103a79:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103a80:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103a87:	e8 f4 0b 00 00       	call   80104680 <release>
}
80103a8c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a8f:	83 c4 10             	add    $0x10,%esp
80103a92:	c9                   	leave  
80103a93:	c3                   	ret    
    panic("userinit: out of memory?");
80103a94:	83 ec 0c             	sub    $0xc,%esp
80103a97:	68 f7 7e 10 80       	push   $0x80107ef7
80103a9c:	e8 ef c8 ff ff       	call   80100390 <panic>
80103aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aaf:	90                   	nop

80103ab0 <growproc>:
{
80103ab0:	f3 0f 1e fb          	endbr32 
80103ab4:	55                   	push   %ebp
80103ab5:	89 e5                	mov    %esp,%ebp
80103ab7:	56                   	push   %esi
80103ab8:	53                   	push   %ebx
80103ab9:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103abc:	e8 ff 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103ac1:	e8 2a fe ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103ac6:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103acc:	e8 3f 0a 00 00       	call   80104510 <popcli>
  sz = curproc->sz;
80103ad1:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ad3:	85 f6                	test   %esi,%esi
80103ad5:	7f 19                	jg     80103af0 <growproc+0x40>
  } else if(n < 0){
80103ad7:	75 37                	jne    80103b10 <growproc+0x60>
  switchuvm(curproc);
80103ad9:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103adc:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ade:	53                   	push   %ebx
80103adf:	e8 dc 37 00 00       	call   801072c0 <switchuvm>
  return 0;
80103ae4:	83 c4 10             	add    $0x10,%esp
80103ae7:	31 c0                	xor    %eax,%eax
}
80103ae9:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aec:	5b                   	pop    %ebx
80103aed:	5e                   	pop    %esi
80103aee:	5d                   	pop    %ebp
80103aef:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103af0:	83 ec 04             	sub    $0x4,%esp
80103af3:	01 c6                	add    %eax,%esi
80103af5:	56                   	push   %esi
80103af6:	50                   	push   %eax
80103af7:	ff 73 04             	pushl  0x4(%ebx)
80103afa:	e8 21 3a 00 00       	call   80107520 <allocuvm>
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	85 c0                	test   %eax,%eax
80103b04:	75 d3                	jne    80103ad9 <growproc+0x29>
      return -1;
80103b06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b0b:	eb dc                	jmp    80103ae9 <growproc+0x39>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 31 3b 00 00       	call   80107650 <deallocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 b3                	jne    80103ad9 <growproc+0x29>
80103b26:	eb de                	jmp    80103b06 <growproc+0x56>
80103b28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b2f:	90                   	nop

80103b30 <fork>:
{
80103b30:	f3 0f 1e fb          	endbr32 
80103b34:	55                   	push   %ebp
80103b35:	89 e5                	mov    %esp,%ebp
80103b37:	57                   	push   %edi
80103b38:	56                   	push   %esi
80103b39:	53                   	push   %ebx
80103b3a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103b3d:	e8 7e 09 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103b42:	e8 a9 fd ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103b47:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b4d:	e8 be 09 00 00       	call   80104510 <popcli>
  if((np = allocproc()) == 0){
80103b52:	e8 39 fc ff ff       	call   80103790 <allocproc>
80103b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103b5a:	85 c0                	test   %eax,%eax
80103b5c:	0f 84 bb 00 00 00    	je     80103c1d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103b62:	83 ec 08             	sub    $0x8,%esp
80103b65:	ff 33                	pushl  (%ebx)
80103b67:	89 c7                	mov    %eax,%edi
80103b69:	ff 73 04             	pushl  0x4(%ebx)
80103b6c:	e8 5f 3c 00 00       	call   801077d0 <copyuvm>
80103b71:	83 c4 10             	add    $0x10,%esp
80103b74:	89 47 04             	mov    %eax,0x4(%edi)
80103b77:	85 c0                	test   %eax,%eax
80103b79:	0f 84 a5 00 00 00    	je     80103c24 <fork+0xf4>
  np->sz = curproc->sz;
80103b7f:	8b 03                	mov    (%ebx),%eax
80103b81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103b84:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103b86:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103b89:	89 c8                	mov    %ecx,%eax
80103b8b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103b8e:	b9 13 00 00 00       	mov    $0x13,%ecx
80103b93:	8b 73 18             	mov    0x18(%ebx),%esi
80103b96:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103b98:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103b9a:	8b 40 18             	mov    0x18(%eax),%eax
80103b9d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103ba8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103bac:	85 c0                	test   %eax,%eax
80103bae:	74 13                	je     80103bc3 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	50                   	push   %eax
80103bb4:	e8 b7 d2 ff ff       	call   80100e70 <filedup>
80103bb9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103bbc:	83 c4 10             	add    $0x10,%esp
80103bbf:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103bc3:	83 c6 01             	add    $0x1,%esi
80103bc6:	83 fe 10             	cmp    $0x10,%esi
80103bc9:	75 dd                	jne    80103ba8 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103bcb:	83 ec 0c             	sub    $0xc,%esp
80103bce:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bd1:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103bd4:	e8 57 db ff ff       	call   80101730 <idup>
80103bd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103bdc:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103bdf:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103be2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103be5:	6a 10                	push   $0x10
80103be7:	53                   	push   %ebx
80103be8:	50                   	push   %eax
80103be9:	e8 a2 0c 00 00       	call   80104890 <safestrcpy>
  pid = np->pid;
80103bee:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103bf1:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103bf8:	e8 c3 09 00 00       	call   801045c0 <acquire>
  np->state = RUNNABLE;
80103bfd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103c04:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103c0b:	e8 70 0a 00 00       	call   80104680 <release>
  return pid;
80103c10:	83 c4 10             	add    $0x10,%esp
}
80103c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c16:	89 d8                	mov    %ebx,%eax
80103c18:	5b                   	pop    %ebx
80103c19:	5e                   	pop    %esi
80103c1a:	5f                   	pop    %edi
80103c1b:	5d                   	pop    %ebp
80103c1c:	c3                   	ret    
    return -1;
80103c1d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c22:	eb ef                	jmp    80103c13 <fork+0xe3>
    kfree(np->kstack);
80103c24:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103c27:	83 ec 0c             	sub    $0xc,%esp
80103c2a:	ff 73 08             	pushl  0x8(%ebx)
80103c2d:	e8 3e e8 ff ff       	call   80102470 <kfree>
    np->kstack = 0;
80103c32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103c39:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103c3c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103c43:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103c48:	eb c9                	jmp    80103c13 <fork+0xe3>
80103c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c50 <scheduler>:
{
80103c50:	f3 0f 1e fb          	endbr32 
80103c54:	55                   	push   %ebp
80103c55:	89 e5                	mov    %esp,%ebp
80103c57:	57                   	push   %edi
80103c58:	56                   	push   %esi
80103c59:	53                   	push   %ebx
80103c5a:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103c5d:	e8 8e fc ff ff       	call   801038f0 <mycpu>
  c->proc = 0;
80103c62:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103c69:	00 00 00 
  struct cpu *c = mycpu();
80103c6c:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103c6e:	8d 78 04             	lea    0x4(%eax),%edi
80103c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103c78:	fb                   	sti    
    acquire(&ptable.lock);
80103c79:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c7c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80103c81:	68 20 3d 11 80       	push   $0x80113d20
80103c86:	e8 35 09 00 00       	call   801045c0 <acquire>
80103c8b:	83 c4 10             	add    $0x10,%esp
80103c8e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103c90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103c94:	75 33                	jne    80103cc9 <scheduler+0x79>
      switchuvm(p);
80103c96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103c99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103c9f:	53                   	push   %ebx
80103ca0:	e8 1b 36 00 00       	call   801072c0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ca5:	58                   	pop    %eax
80103ca6:	5a                   	pop    %edx
80103ca7:	ff 73 1c             	pushl  0x1c(%ebx)
80103caa:	57                   	push   %edi
      p->state = RUNNING;
80103cab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103cb2:	e8 3c 0c 00 00       	call   801048f3 <swtch>
      switchkvm();
80103cb7:	e8 e4 35 00 00       	call   801072a0 <switchkvm>
      c->proc = 0;
80103cbc:	83 c4 10             	add    $0x10,%esp
80103cbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103cc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc9:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
80103ccf:	81 fb 54 76 11 80    	cmp    $0x80117654,%ebx
80103cd5:	75 b9                	jne    80103c90 <scheduler+0x40>
    release(&ptable.lock);
80103cd7:	83 ec 0c             	sub    $0xc,%esp
80103cda:	68 20 3d 11 80       	push   $0x80113d20
80103cdf:	e8 9c 09 00 00       	call   80104680 <release>
    sti();
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	eb 8f                	jmp    80103c78 <scheduler+0x28>
80103ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cf0 <sched>:
{
80103cf0:	f3 0f 1e fb          	endbr32 
80103cf4:	55                   	push   %ebp
80103cf5:	89 e5                	mov    %esp,%ebp
80103cf7:	56                   	push   %esi
80103cf8:	53                   	push   %ebx
  pushcli();
80103cf9:	e8 c2 07 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103cfe:	e8 ed fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103d03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d09:	e8 02 08 00 00       	call   80104510 <popcli>
  if(!holding(&ptable.lock))
80103d0e:	83 ec 0c             	sub    $0xc,%esp
80103d11:	68 20 3d 11 80       	push   $0x80113d20
80103d16:	e8 55 08 00 00       	call   80104570 <holding>
80103d1b:	83 c4 10             	add    $0x10,%esp
80103d1e:	85 c0                	test   %eax,%eax
80103d20:	74 4f                	je     80103d71 <sched+0x81>
  if(mycpu()->ncli != 1)
80103d22:	e8 c9 fb ff ff       	call   801038f0 <mycpu>
80103d27:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103d2e:	75 68                	jne    80103d98 <sched+0xa8>
  if(p->state == RUNNING)
80103d30:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103d34:	74 55                	je     80103d8b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d36:	9c                   	pushf  
80103d37:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d38:	f6 c4 02             	test   $0x2,%ah
80103d3b:	75 41                	jne    80103d7e <sched+0x8e>
  intena = mycpu()->intena;
80103d3d:	e8 ae fb ff ff       	call   801038f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103d42:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103d45:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103d4b:	e8 a0 fb ff ff       	call   801038f0 <mycpu>
80103d50:	83 ec 08             	sub    $0x8,%esp
80103d53:	ff 70 04             	pushl  0x4(%eax)
80103d56:	53                   	push   %ebx
80103d57:	e8 97 0b 00 00       	call   801048f3 <swtch>
  mycpu()->intena = intena;
80103d5c:	e8 8f fb ff ff       	call   801038f0 <mycpu>
}
80103d61:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103d64:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103d6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d6d:	5b                   	pop    %ebx
80103d6e:	5e                   	pop    %esi
80103d6f:	5d                   	pop    %ebp
80103d70:	c3                   	ret    
    panic("sched ptable.lock");
80103d71:	83 ec 0c             	sub    $0xc,%esp
80103d74:	68 1b 7f 10 80       	push   $0x80107f1b
80103d79:	e8 12 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103d7e:	83 ec 0c             	sub    $0xc,%esp
80103d81:	68 47 7f 10 80       	push   $0x80107f47
80103d86:	e8 05 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	68 39 7f 10 80       	push   $0x80107f39
80103d93:	e8 f8 c5 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103d98:	83 ec 0c             	sub    $0xc,%esp
80103d9b:	68 2d 7f 10 80       	push   $0x80107f2d
80103da0:	e8 eb c5 ff ff       	call   80100390 <panic>
80103da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103db0 <exit>:
{
80103db0:	f3 0f 1e fb          	endbr32 
80103db4:	55                   	push   %ebp
80103db5:	89 e5                	mov    %esp,%ebp
80103db7:	57                   	push   %edi
80103db8:	56                   	push   %esi
80103db9:	53                   	push   %ebx
80103dba:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103dbd:	e8 fe 06 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103dc2:	e8 29 fb ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103dc7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dcd:	e8 3e 07 00 00       	call   80104510 <popcli>
  if(curproc == initproc)
80103dd2:	8d 73 28             	lea    0x28(%ebx),%esi
80103dd5:	8d 7b 68             	lea    0x68(%ebx),%edi
80103dd8:	39 1d b8 b5 10 80    	cmp    %ebx,0x8010b5b8
80103dde:	0f 84 11 01 00 00    	je     80103ef5 <exit+0x145>
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80103de8:	8b 06                	mov    (%esi),%eax
80103dea:	85 c0                	test   %eax,%eax
80103dec:	74 12                	je     80103e00 <exit+0x50>
      fileclose(curproc->ofile[fd]);
80103dee:	83 ec 0c             	sub    $0xc,%esp
80103df1:	50                   	push   %eax
80103df2:	e8 c9 d0 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103df7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103dfd:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e00:	83 c6 04             	add    $0x4,%esi
80103e03:	39 f7                	cmp    %esi,%edi
80103e05:	75 e1                	jne    80103de8 <exit+0x38>
  begin_op();
80103e07:	e8 24 ef ff ff       	call   80102d30 <begin_op>
  iput(curproc->cwd);
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	ff 73 68             	pushl  0x68(%ebx)
80103e12:	e8 79 da ff ff       	call   80101890 <iput>
  end_op();
80103e17:	e8 84 ef ff ff       	call   80102da0 <end_op>
  curproc->cwd = 0;
80103e1c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103e23:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103e2a:	e8 91 07 00 00       	call   801045c0 <acquire>
  wakeup1(curproc->parent);
80103e2f:	8b 53 14             	mov    0x14(%ebx),%edx
80103e32:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e35:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103e3a:	eb 10                	jmp    80103e4c <exit+0x9c>
80103e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e40:	05 e4 00 00 00       	add    $0xe4,%eax
80103e45:	3d 54 76 11 80       	cmp    $0x80117654,%eax
80103e4a:	74 1e                	je     80103e6a <exit+0xba>
    if(p->state == SLEEPING && p->chan == chan)
80103e4c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e50:	75 ee                	jne    80103e40 <exit+0x90>
80103e52:	3b 50 20             	cmp    0x20(%eax),%edx
80103e55:	75 e9                	jne    80103e40 <exit+0x90>
      p->state = RUNNABLE;
80103e57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e5e:	05 e4 00 00 00       	add    $0xe4,%eax
80103e63:	3d 54 76 11 80       	cmp    $0x80117654,%eax
80103e68:	75 e2                	jne    80103e4c <exit+0x9c>
      p->parent = initproc;
80103e6a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e70:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80103e75:	eb 17                	jmp    80103e8e <exit+0xde>
80103e77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e7e:	66 90                	xchg   %ax,%ax
80103e80:	81 c2 e4 00 00 00    	add    $0xe4,%edx
80103e86:	81 fa 54 76 11 80    	cmp    $0x80117654,%edx
80103e8c:	74 3a                	je     80103ec8 <exit+0x118>
    if(p->parent == curproc){
80103e8e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103e91:	75 ed                	jne    80103e80 <exit+0xd0>
      if(p->state == ZOMBIE)
80103e93:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103e97:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103e9a:	75 e4                	jne    80103e80 <exit+0xd0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e9c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ea1:	eb 11                	jmp    80103eb4 <exit+0x104>
80103ea3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ea7:	90                   	nop
80103ea8:	05 e4 00 00 00       	add    $0xe4,%eax
80103ead:	3d 54 76 11 80       	cmp    $0x80117654,%eax
80103eb2:	74 cc                	je     80103e80 <exit+0xd0>
    if(p->state == SLEEPING && p->chan == chan)
80103eb4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103eb8:	75 ee                	jne    80103ea8 <exit+0xf8>
80103eba:	3b 48 20             	cmp    0x20(%eax),%ecx
80103ebd:	75 e9                	jne    80103ea8 <exit+0xf8>
      p->state = RUNNABLE;
80103ebf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103ec6:	eb e0                	jmp    80103ea8 <exit+0xf8>
  curproc->end_time = ticks;
80103ec8:	a1 a0 7e 11 80       	mov    0x80117ea0,%eax
  curproc->state = ZOMBIE;
80103ecd:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  curproc->end_time = ticks;
80103ed4:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
  curproc->total_time = curproc->end_time - curproc->creation_time;
80103eda:	2b 43 7c             	sub    0x7c(%ebx),%eax
80103edd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  sched();
80103ee3:	e8 08 fe ff ff       	call   80103cf0 <sched>
  panic("zombie exit");
80103ee8:	83 ec 0c             	sub    $0xc,%esp
80103eeb:	68 68 7f 10 80       	push   $0x80107f68
80103ef0:	e8 9b c4 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103ef5:	83 ec 0c             	sub    $0xc,%esp
80103ef8:	68 5b 7f 10 80       	push   $0x80107f5b
80103efd:	e8 8e c4 ff ff       	call   80100390 <panic>
80103f02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f10 <yield>:
{
80103f10:	f3 0f 1e fb          	endbr32 
80103f14:	55                   	push   %ebp
80103f15:	89 e5                	mov    %esp,%ebp
80103f17:	53                   	push   %ebx
80103f18:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103f1b:	68 20 3d 11 80       	push   $0x80113d20
80103f20:	e8 9b 06 00 00       	call   801045c0 <acquire>
  pushcli();
80103f25:	e8 96 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f2a:	e8 c1 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f2f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f35:	e8 d6 05 00 00       	call   80104510 <popcli>
  myproc()->state = RUNNABLE;
80103f3a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103f41:	e8 aa fd ff ff       	call   80103cf0 <sched>
  release(&ptable.lock);
80103f46:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103f4d:	e8 2e 07 00 00       	call   80104680 <release>
}
80103f52:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f55:	83 c4 10             	add    $0x10,%esp
80103f58:	c9                   	leave  
80103f59:	c3                   	ret    
80103f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f60 <sleep>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	57                   	push   %edi
80103f68:	56                   	push   %esi
80103f69:	53                   	push   %ebx
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f70:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103f73:	e8 48 05 00 00       	call   801044c0 <pushcli>
  c = mycpu();
80103f78:	e8 73 f9 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80103f7d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103f83:	e8 88 05 00 00       	call   80104510 <popcli>
  if(p == 0)
80103f88:	85 db                	test   %ebx,%ebx
80103f8a:	0f 84 83 00 00 00    	je     80104013 <sleep+0xb3>
  if(lk == 0)
80103f90:	85 f6                	test   %esi,%esi
80103f92:	74 72                	je     80104006 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f94:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80103f9a:	74 4c                	je     80103fe8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f9c:	83 ec 0c             	sub    $0xc,%esp
80103f9f:	68 20 3d 11 80       	push   $0x80113d20
80103fa4:	e8 17 06 00 00       	call   801045c0 <acquire>
    release(lk);
80103fa9:	89 34 24             	mov    %esi,(%esp)
80103fac:	e8 cf 06 00 00       	call   80104680 <release>
  p->chan = chan;
80103fb1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103fb4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103fbb:	e8 30 fd ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103fc0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103fc7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fce:	e8 ad 06 00 00       	call   80104680 <release>
    acquire(lk);
80103fd3:	89 75 08             	mov    %esi,0x8(%ebp)
80103fd6:	83 c4 10             	add    $0x10,%esp
}
80103fd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fdc:	5b                   	pop    %ebx
80103fdd:	5e                   	pop    %esi
80103fde:	5f                   	pop    %edi
80103fdf:	5d                   	pop    %ebp
    acquire(lk);
80103fe0:	e9 db 05 00 00       	jmp    801045c0 <acquire>
80103fe5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80103fe8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103feb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ff2:	e8 f9 fc ff ff       	call   80103cf0 <sched>
  p->chan = 0;
80103ff7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104001:	5b                   	pop    %ebx
80104002:	5e                   	pop    %esi
80104003:	5f                   	pop    %edi
80104004:	5d                   	pop    %ebp
80104005:	c3                   	ret    
    panic("sleep without lk");
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	68 7a 7f 10 80       	push   $0x80107f7a
8010400e:	e8 7d c3 ff ff       	call   80100390 <panic>
    panic("sleep");
80104013:	83 ec 0c             	sub    $0xc,%esp
80104016:	68 74 7f 10 80       	push   $0x80107f74
8010401b:	e8 70 c3 ff ff       	call   80100390 <panic>

80104020 <wait>:
{
80104020:	f3 0f 1e fb          	endbr32 
80104024:	55                   	push   %ebp
80104025:	89 e5                	mov    %esp,%ebp
80104027:	56                   	push   %esi
80104028:	53                   	push   %ebx
  pushcli();
80104029:	e8 92 04 00 00       	call   801044c0 <pushcli>
  c = mycpu();
8010402e:	e8 bd f8 ff ff       	call   801038f0 <mycpu>
  p = c->proc;
80104033:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104039:	e8 d2 04 00 00       	call   80104510 <popcli>
  acquire(&ptable.lock);
8010403e:	83 ec 0c             	sub    $0xc,%esp
80104041:	68 20 3d 11 80       	push   $0x80113d20
80104046:	e8 75 05 00 00       	call   801045c0 <acquire>
8010404b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010404e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104050:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104055:	eb 17                	jmp    8010406e <wait+0x4e>
80104057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010405e:	66 90                	xchg   %ax,%ax
80104060:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
80104066:	81 fb 54 76 11 80    	cmp    $0x80117654,%ebx
8010406c:	74 1e                	je     8010408c <wait+0x6c>
      if(p->parent != curproc)
8010406e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104071:	75 ed                	jne    80104060 <wait+0x40>
      if(p->state == ZOMBIE){
80104073:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104077:	74 37                	je     801040b0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104079:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
      havekids = 1;
8010407f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104084:	81 fb 54 76 11 80    	cmp    $0x80117654,%ebx
8010408a:	75 e2                	jne    8010406e <wait+0x4e>
    if(!havekids || curproc->killed){
8010408c:	85 c0                	test   %eax,%eax
8010408e:	74 76                	je     80104106 <wait+0xe6>
80104090:	8b 46 24             	mov    0x24(%esi),%eax
80104093:	85 c0                	test   %eax,%eax
80104095:	75 6f                	jne    80104106 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104097:	83 ec 08             	sub    $0x8,%esp
8010409a:	68 20 3d 11 80       	push   $0x80113d20
8010409f:	56                   	push   %esi
801040a0:	e8 bb fe ff ff       	call   80103f60 <sleep>
    havekids = 0;
801040a5:	83 c4 10             	add    $0x10,%esp
801040a8:	eb a4                	jmp    8010404e <wait+0x2e>
801040aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801040b0:	83 ec 0c             	sub    $0xc,%esp
801040b3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801040b6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040b9:	e8 b2 e3 ff ff       	call   80102470 <kfree>
        freevm(p->pgdir);
801040be:	5a                   	pop    %edx
801040bf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801040c2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040c9:	e8 b2 35 00 00       	call   80107680 <freevm>
        release(&ptable.lock);
801040ce:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801040d5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040dc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040e3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040e7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040ee:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040f5:	e8 86 05 00 00       	call   80104680 <release>
        return pid;
801040fa:	83 c4 10             	add    $0x10,%esp
}
801040fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104100:	89 f0                	mov    %esi,%eax
80104102:	5b                   	pop    %ebx
80104103:	5e                   	pop    %esi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret    
      release(&ptable.lock);
80104106:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104109:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010410e:	68 20 3d 11 80       	push   $0x80113d20
80104113:	e8 68 05 00 00       	call   80104680 <release>
      return -1;
80104118:	83 c4 10             	add    $0x10,%esp
8010411b:	eb e0                	jmp    801040fd <wait+0xdd>
8010411d:	8d 76 00             	lea    0x0(%esi),%esi

80104120 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104120:	f3 0f 1e fb          	endbr32 
80104124:	55                   	push   %ebp
80104125:	89 e5                	mov    %esp,%ebp
80104127:	53                   	push   %ebx
80104128:	83 ec 10             	sub    $0x10,%esp
8010412b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010412e:	68 20 3d 11 80       	push   $0x80113d20
80104133:	e8 88 04 00 00       	call   801045c0 <acquire>
80104138:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104140:	eb 12                	jmp    80104154 <wakeup+0x34>
80104142:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104148:	05 e4 00 00 00       	add    $0xe4,%eax
8010414d:	3d 54 76 11 80       	cmp    $0x80117654,%eax
80104152:	74 1e                	je     80104172 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104154:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104158:	75 ee                	jne    80104148 <wakeup+0x28>
8010415a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010415d:	75 e9                	jne    80104148 <wakeup+0x28>
      p->state = RUNNABLE;
8010415f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104166:	05 e4 00 00 00       	add    $0xe4,%eax
8010416b:	3d 54 76 11 80       	cmp    $0x80117654,%eax
80104170:	75 e2                	jne    80104154 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104172:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010417c:	c9                   	leave  
  release(&ptable.lock);
8010417d:	e9 fe 04 00 00       	jmp    80104680 <release>
80104182:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104190 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104190:	f3 0f 1e fb          	endbr32 
80104194:	55                   	push   %ebp
80104195:	89 e5                	mov    %esp,%ebp
80104197:	53                   	push   %ebx
80104198:	83 ec 10             	sub    $0x10,%esp
8010419b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010419e:	68 20 3d 11 80       	push   $0x80113d20
801041a3:	e8 18 04 00 00       	call   801045c0 <acquire>
801041a8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041ab:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801041b0:	eb 12                	jmp    801041c4 <kill+0x34>
801041b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041b8:	05 e4 00 00 00       	add    $0xe4,%eax
801041bd:	3d 54 76 11 80       	cmp    $0x80117654,%eax
801041c2:	74 34                	je     801041f8 <kill+0x68>
    if(p->pid == pid){
801041c4:	39 58 10             	cmp    %ebx,0x10(%eax)
801041c7:	75 ef                	jne    801041b8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801041c9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801041cd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801041d4:	75 07                	jne    801041dd <kill+0x4d>
        p->state = RUNNABLE;
801041d6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801041dd:	83 ec 0c             	sub    $0xc,%esp
801041e0:	68 20 3d 11 80       	push   $0x80113d20
801041e5:	e8 96 04 00 00       	call   80104680 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801041ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801041ed:	83 c4 10             	add    $0x10,%esp
801041f0:	31 c0                	xor    %eax,%eax
}
801041f2:	c9                   	leave  
801041f3:	c3                   	ret    
801041f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 20 3d 11 80       	push   $0x80113d20
80104200:	e8 7b 04 00 00       	call   80104680 <release>
}
80104205:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104208:	83 c4 10             	add    $0x10,%esp
8010420b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104210:	c9                   	leave  
80104211:	c3                   	ret    
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104220:	f3 0f 1e fb          	endbr32 
80104224:	55                   	push   %ebp
80104225:	89 e5                	mov    %esp,%ebp
80104227:	57                   	push   %edi
80104228:	56                   	push   %esi
80104229:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010422c:	53                   	push   %ebx
8010422d:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104232:	83 ec 3c             	sub    $0x3c,%esp
80104235:	eb 2b                	jmp    80104262 <procdump+0x42>
80104237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010423e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104240:	83 ec 0c             	sub    $0xc,%esp
80104243:	68 fb 83 10 80       	push   $0x801083fb
80104248:	e8 63 c4 ff ff       	call   801006b0 <cprintf>
8010424d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104250:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
80104256:	81 fb c0 76 11 80    	cmp    $0x801176c0,%ebx
8010425c:	0f 84 8e 00 00 00    	je     801042f0 <procdump+0xd0>
    if(p->state == UNUSED)
80104262:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104265:	85 c0                	test   %eax,%eax
80104267:	74 e7                	je     80104250 <procdump+0x30>
      state = "???";
80104269:	ba 8b 7f 10 80       	mov    $0x80107f8b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010426e:	83 f8 05             	cmp    $0x5,%eax
80104271:	77 11                	ja     80104284 <procdump+0x64>
80104273:	8b 14 85 ec 7f 10 80 	mov    -0x7fef8014(,%eax,4),%edx
      state = "???";
8010427a:	b8 8b 7f 10 80       	mov    $0x80107f8b,%eax
8010427f:	85 d2                	test   %edx,%edx
80104281:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104284:	53                   	push   %ebx
80104285:	52                   	push   %edx
80104286:	ff 73 a4             	pushl  -0x5c(%ebx)
80104289:	68 8f 7f 10 80       	push   $0x80107f8f
8010428e:	e8 1d c4 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104293:	83 c4 10             	add    $0x10,%esp
80104296:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010429a:	75 a4                	jne    80104240 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010429c:	83 ec 08             	sub    $0x8,%esp
8010429f:	8d 45 c0             	lea    -0x40(%ebp),%eax
801042a2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801042a5:	50                   	push   %eax
801042a6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801042a9:	8b 40 0c             	mov    0xc(%eax),%eax
801042ac:	83 c0 08             	add    $0x8,%eax
801042af:	50                   	push   %eax
801042b0:	e8 ab 01 00 00       	call   80104460 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801042b5:	83 c4 10             	add    $0x10,%esp
801042b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042bf:	90                   	nop
801042c0:	8b 17                	mov    (%edi),%edx
801042c2:	85 d2                	test   %edx,%edx
801042c4:	0f 84 76 ff ff ff    	je     80104240 <procdump+0x20>
        cprintf(" %p", pc[i]);
801042ca:	83 ec 08             	sub    $0x8,%esp
801042cd:	83 c7 04             	add    $0x4,%edi
801042d0:	52                   	push   %edx
801042d1:	68 e1 79 10 80       	push   $0x801079e1
801042d6:	e8 d5 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801042db:	83 c4 10             	add    $0x10,%esp
801042de:	39 fe                	cmp    %edi,%esi
801042e0:	75 de                	jne    801042c0 <procdump+0xa0>
801042e2:	e9 59 ff ff ff       	jmp    80104240 <procdump+0x20>
801042e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042ee:	66 90                	xchg   %ax,%ax
  }
}
801042f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042f3:	5b                   	pop    %ebx
801042f4:	5e                   	pop    %esi
801042f5:	5f                   	pop    %edi
801042f6:	5d                   	pop    %ebp
801042f7:	c3                   	ret    
801042f8:	66 90                	xchg   %ax,%ax
801042fa:	66 90                	xchg   %ax,%ax
801042fc:	66 90                	xchg   %ax,%ax
801042fe:	66 90                	xchg   %ax,%ax

80104300 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	53                   	push   %ebx
80104308:	83 ec 0c             	sub    $0xc,%esp
8010430b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010430e:	68 04 80 10 80       	push   $0x80108004
80104313:	8d 43 04             	lea    0x4(%ebx),%eax
80104316:	50                   	push   %eax
80104317:	e8 24 01 00 00       	call   80104440 <initlock>
  lk->name = name;
8010431c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010431f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104325:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104328:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010432f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104335:	c9                   	leave  
80104336:	c3                   	ret    
80104337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433e:	66 90                	xchg   %ax,%ax

80104340 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104340:	f3 0f 1e fb          	endbr32 
80104344:	55                   	push   %ebp
80104345:	89 e5                	mov    %esp,%ebp
80104347:	56                   	push   %esi
80104348:	53                   	push   %ebx
80104349:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010434c:	8d 73 04             	lea    0x4(%ebx),%esi
8010434f:	83 ec 0c             	sub    $0xc,%esp
80104352:	56                   	push   %esi
80104353:	e8 68 02 00 00       	call   801045c0 <acquire>
  while (lk->locked) {
80104358:	8b 13                	mov    (%ebx),%edx
8010435a:	83 c4 10             	add    $0x10,%esp
8010435d:	85 d2                	test   %edx,%edx
8010435f:	74 1a                	je     8010437b <acquiresleep+0x3b>
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104368:	83 ec 08             	sub    $0x8,%esp
8010436b:	56                   	push   %esi
8010436c:	53                   	push   %ebx
8010436d:	e8 ee fb ff ff       	call   80103f60 <sleep>
  while (lk->locked) {
80104372:	8b 03                	mov    (%ebx),%eax
80104374:	83 c4 10             	add    $0x10,%esp
80104377:	85 c0                	test   %eax,%eax
80104379:	75 ed                	jne    80104368 <acquiresleep+0x28>
  }
  lk->locked = 1;
8010437b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104381:	e8 fa f5 ff ff       	call   80103980 <myproc>
80104386:	8b 40 10             	mov    0x10(%eax),%eax
80104389:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
8010438c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010438f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104392:	5b                   	pop    %ebx
80104393:	5e                   	pop    %esi
80104394:	5d                   	pop    %ebp
  release(&lk->lk);
80104395:	e9 e6 02 00 00       	jmp    80104680 <release>
8010439a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801043a0:	f3 0f 1e fb          	endbr32 
801043a4:	55                   	push   %ebp
801043a5:	89 e5                	mov    %esp,%ebp
801043a7:	56                   	push   %esi
801043a8:	53                   	push   %ebx
801043a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043ac:	8d 73 04             	lea    0x4(%ebx),%esi
801043af:	83 ec 0c             	sub    $0xc,%esp
801043b2:	56                   	push   %esi
801043b3:	e8 08 02 00 00       	call   801045c0 <acquire>
  lk->locked = 0;
801043b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801043be:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801043c5:	89 1c 24             	mov    %ebx,(%esp)
801043c8:	e8 53 fd ff ff       	call   80104120 <wakeup>
  release(&lk->lk);
801043cd:	89 75 08             	mov    %esi,0x8(%ebp)
801043d0:	83 c4 10             	add    $0x10,%esp
}
801043d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d6:	5b                   	pop    %ebx
801043d7:	5e                   	pop    %esi
801043d8:	5d                   	pop    %ebp
  release(&lk->lk);
801043d9:	e9 a2 02 00 00       	jmp    80104680 <release>
801043de:	66 90                	xchg   %ax,%ax

801043e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	57                   	push   %edi
801043e8:	31 ff                	xor    %edi,%edi
801043ea:	56                   	push   %esi
801043eb:	53                   	push   %ebx
801043ec:	83 ec 18             	sub    $0x18,%esp
801043ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801043f2:	8d 73 04             	lea    0x4(%ebx),%esi
801043f5:	56                   	push   %esi
801043f6:	e8 c5 01 00 00       	call   801045c0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801043fb:	8b 03                	mov    (%ebx),%eax
801043fd:	83 c4 10             	add    $0x10,%esp
80104400:	85 c0                	test   %eax,%eax
80104402:	75 1c                	jne    80104420 <holdingsleep+0x40>
  release(&lk->lk);
80104404:	83 ec 0c             	sub    $0xc,%esp
80104407:	56                   	push   %esi
80104408:	e8 73 02 00 00       	call   80104680 <release>
  return r;
}
8010440d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104410:	89 f8                	mov    %edi,%eax
80104412:	5b                   	pop    %ebx
80104413:	5e                   	pop    %esi
80104414:	5f                   	pop    %edi
80104415:	5d                   	pop    %ebp
80104416:	c3                   	ret    
80104417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010441e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104420:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104423:	e8 58 f5 ff ff       	call   80103980 <myproc>
80104428:	39 58 10             	cmp    %ebx,0x10(%eax)
8010442b:	0f 94 c0             	sete   %al
8010442e:	0f b6 c0             	movzbl %al,%eax
80104431:	89 c7                	mov    %eax,%edi
80104433:	eb cf                	jmp    80104404 <holdingsleep+0x24>
80104435:	66 90                	xchg   %ax,%ax
80104437:	66 90                	xchg   %ax,%ax
80104439:	66 90                	xchg   %ax,%ax
8010443b:	66 90                	xchg   %ax,%ax
8010443d:	66 90                	xchg   %ax,%ax
8010443f:	90                   	nop

80104440 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104440:	f3 0f 1e fb          	endbr32 
80104444:	55                   	push   %ebp
80104445:	89 e5                	mov    %esp,%ebp
80104447:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
8010444a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
8010444d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104453:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104456:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010445d:	5d                   	pop    %ebp
8010445e:	c3                   	ret    
8010445f:	90                   	nop

80104460 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104460:	f3 0f 1e fb          	endbr32 
80104464:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104465:	31 d2                	xor    %edx,%edx
{
80104467:	89 e5                	mov    %esp,%ebp
80104469:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010446a:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010446d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104470:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104477:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104478:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010447e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104484:	77 1a                	ja     801044a0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104486:	8b 58 04             	mov    0x4(%eax),%ebx
80104489:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010448c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010448f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104491:	83 fa 0a             	cmp    $0xa,%edx
80104494:	75 e2                	jne    80104478 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104496:	5b                   	pop    %ebx
80104497:	5d                   	pop    %ebp
80104498:	c3                   	ret    
80104499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
801044a0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801044a3:	8d 51 28             	lea    0x28(%ecx),%edx
801044a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ad:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
801044b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801044b6:	83 c0 04             	add    $0x4,%eax
801044b9:	39 d0                	cmp    %edx,%eax
801044bb:	75 f3                	jne    801044b0 <getcallerpcs+0x50>
}
801044bd:	5b                   	pop    %ebx
801044be:	5d                   	pop    %ebp
801044bf:	c3                   	ret    

801044c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801044c0:	f3 0f 1e fb          	endbr32 
801044c4:	55                   	push   %ebp
801044c5:	89 e5                	mov    %esp,%ebp
801044c7:	53                   	push   %ebx
801044c8:	83 ec 04             	sub    $0x4,%esp
801044cb:	9c                   	pushf  
801044cc:	5b                   	pop    %ebx
  asm volatile("cli");
801044cd:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801044ce:	e8 1d f4 ff ff       	call   801038f0 <mycpu>
801044d3:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801044d9:	85 c0                	test   %eax,%eax
801044db:	74 13                	je     801044f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801044dd:	e8 0e f4 ff ff       	call   801038f0 <mycpu>
801044e2:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801044e9:	83 c4 04             	add    $0x4,%esp
801044ec:	5b                   	pop    %ebx
801044ed:	5d                   	pop    %ebp
801044ee:	c3                   	ret    
801044ef:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801044f0:	e8 fb f3 ff ff       	call   801038f0 <mycpu>
801044f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801044fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104501:	eb da                	jmp    801044dd <pushcli+0x1d>
80104503:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010450a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104510 <popcli>:

void
popcli(void)
{
80104510:	f3 0f 1e fb          	endbr32 
80104514:	55                   	push   %ebp
80104515:	89 e5                	mov    %esp,%ebp
80104517:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010451a:	9c                   	pushf  
8010451b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010451c:	f6 c4 02             	test   $0x2,%ah
8010451f:	75 31                	jne    80104552 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104521:	e8 ca f3 ff ff       	call   801038f0 <mycpu>
80104526:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
8010452d:	78 30                	js     8010455f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010452f:	e8 bc f3 ff ff       	call   801038f0 <mycpu>
80104534:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010453a:	85 d2                	test   %edx,%edx
8010453c:	74 02                	je     80104540 <popcli+0x30>
    sti();
}
8010453e:	c9                   	leave  
8010453f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104540:	e8 ab f3 ff ff       	call   801038f0 <mycpu>
80104545:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010454b:	85 c0                	test   %eax,%eax
8010454d:	74 ef                	je     8010453e <popcli+0x2e>
  asm volatile("sti");
8010454f:	fb                   	sti    
}
80104550:	c9                   	leave  
80104551:	c3                   	ret    
    panic("popcli - interruptible");
80104552:	83 ec 0c             	sub    $0xc,%esp
80104555:	68 0f 80 10 80       	push   $0x8010800f
8010455a:	e8 31 be ff ff       	call   80100390 <panic>
    panic("popcli");
8010455f:	83 ec 0c             	sub    $0xc,%esp
80104562:	68 26 80 10 80       	push   $0x80108026
80104567:	e8 24 be ff ff       	call   80100390 <panic>
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104570 <holding>:
{
80104570:	f3 0f 1e fb          	endbr32 
80104574:	55                   	push   %ebp
80104575:	89 e5                	mov    %esp,%ebp
80104577:	56                   	push   %esi
80104578:	53                   	push   %ebx
80104579:	8b 75 08             	mov    0x8(%ebp),%esi
8010457c:	31 db                	xor    %ebx,%ebx
  pushcli();
8010457e:	e8 3d ff ff ff       	call   801044c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104583:	8b 06                	mov    (%esi),%eax
80104585:	85 c0                	test   %eax,%eax
80104587:	75 0f                	jne    80104598 <holding+0x28>
  popcli();
80104589:	e8 82 ff ff ff       	call   80104510 <popcli>
}
8010458e:	89 d8                	mov    %ebx,%eax
80104590:	5b                   	pop    %ebx
80104591:	5e                   	pop    %esi
80104592:	5d                   	pop    %ebp
80104593:	c3                   	ret    
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104598:	8b 5e 08             	mov    0x8(%esi),%ebx
8010459b:	e8 50 f3 ff ff       	call   801038f0 <mycpu>
801045a0:	39 c3                	cmp    %eax,%ebx
801045a2:	0f 94 c3             	sete   %bl
  popcli();
801045a5:	e8 66 ff ff ff       	call   80104510 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801045aa:	0f b6 db             	movzbl %bl,%ebx
}
801045ad:	89 d8                	mov    %ebx,%eax
801045af:	5b                   	pop    %ebx
801045b0:	5e                   	pop    %esi
801045b1:	5d                   	pop    %ebp
801045b2:	c3                   	ret    
801045b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045c0 <acquire>:
{
801045c0:	f3 0f 1e fb          	endbr32 
801045c4:	55                   	push   %ebp
801045c5:	89 e5                	mov    %esp,%ebp
801045c7:	56                   	push   %esi
801045c8:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801045c9:	e8 f2 fe ff ff       	call   801044c0 <pushcli>
  if(holding(lk))
801045ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	53                   	push   %ebx
801045d5:	e8 96 ff ff ff       	call   80104570 <holding>
801045da:	83 c4 10             	add    $0x10,%esp
801045dd:	85 c0                	test   %eax,%eax
801045df:	0f 85 7f 00 00 00    	jne    80104664 <acquire+0xa4>
801045e5:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801045e7:	ba 01 00 00 00       	mov    $0x1,%edx
801045ec:	eb 05                	jmp    801045f3 <acquire+0x33>
801045ee:	66 90                	xchg   %ax,%ax
801045f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801045f3:	89 d0                	mov    %edx,%eax
801045f5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801045f8:	85 c0                	test   %eax,%eax
801045fa:	75 f4                	jne    801045f0 <acquire+0x30>
  __sync_synchronize();
801045fc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104601:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104604:	e8 e7 f2 ff ff       	call   801038f0 <mycpu>
80104609:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010460c:	89 e8                	mov    %ebp,%eax
8010460e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104610:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104616:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010461c:	77 22                	ja     80104640 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010461e:	8b 50 04             	mov    0x4(%eax),%edx
80104621:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104625:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104628:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010462a:	83 fe 0a             	cmp    $0xa,%esi
8010462d:	75 e1                	jne    80104610 <acquire+0x50>
}
8010462f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104632:	5b                   	pop    %ebx
80104633:	5e                   	pop    %esi
80104634:	5d                   	pop    %ebp
80104635:	c3                   	ret    
80104636:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104640:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104644:	83 c3 34             	add    $0x34,%ebx
80104647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104650:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104656:	83 c0 04             	add    $0x4,%eax
80104659:	39 d8                	cmp    %ebx,%eax
8010465b:	75 f3                	jne    80104650 <acquire+0x90>
}
8010465d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104660:	5b                   	pop    %ebx
80104661:	5e                   	pop    %esi
80104662:	5d                   	pop    %ebp
80104663:	c3                   	ret    
    panic("acquire");
80104664:	83 ec 0c             	sub    $0xc,%esp
80104667:	68 2d 80 10 80       	push   $0x8010802d
8010466c:	e8 1f bd ff ff       	call   80100390 <panic>
80104671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467f:	90                   	nop

80104680 <release>:
{
80104680:	f3 0f 1e fb          	endbr32 
80104684:	55                   	push   %ebp
80104685:	89 e5                	mov    %esp,%ebp
80104687:	53                   	push   %ebx
80104688:	83 ec 10             	sub    $0x10,%esp
8010468b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010468e:	53                   	push   %ebx
8010468f:	e8 dc fe ff ff       	call   80104570 <holding>
80104694:	83 c4 10             	add    $0x10,%esp
80104697:	85 c0                	test   %eax,%eax
80104699:	74 22                	je     801046bd <release+0x3d>
  lk->pcs[0] = 0;
8010469b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801046a2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801046a9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801046ae:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801046b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801046b7:	c9                   	leave  
  popcli();
801046b8:	e9 53 fe ff ff       	jmp    80104510 <popcli>
    panic("release");
801046bd:	83 ec 0c             	sub    $0xc,%esp
801046c0:	68 35 80 10 80       	push   $0x80108035
801046c5:	e8 c6 bc ff ff       	call   80100390 <panic>
801046ca:	66 90                	xchg   %ax,%ax
801046cc:	66 90                	xchg   %ax,%ax
801046ce:	66 90                	xchg   %ax,%ax

801046d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	57                   	push   %edi
801046d8:	8b 55 08             	mov    0x8(%ebp),%edx
801046db:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046de:	53                   	push   %ebx
801046df:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801046e2:	89 d7                	mov    %edx,%edi
801046e4:	09 cf                	or     %ecx,%edi
801046e6:	83 e7 03             	and    $0x3,%edi
801046e9:	75 25                	jne    80104710 <memset+0x40>
    c &= 0xFF;
801046eb:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801046ee:	c1 e0 18             	shl    $0x18,%eax
801046f1:	89 fb                	mov    %edi,%ebx
801046f3:	c1 e9 02             	shr    $0x2,%ecx
801046f6:	c1 e3 10             	shl    $0x10,%ebx
801046f9:	09 d8                	or     %ebx,%eax
801046fb:	09 f8                	or     %edi,%eax
801046fd:	c1 e7 08             	shl    $0x8,%edi
80104700:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104702:	89 d7                	mov    %edx,%edi
80104704:	fc                   	cld    
80104705:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104707:	5b                   	pop    %ebx
80104708:	89 d0                	mov    %edx,%eax
8010470a:	5f                   	pop    %edi
8010470b:	5d                   	pop    %ebp
8010470c:	c3                   	ret    
8010470d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104710:	89 d7                	mov    %edx,%edi
80104712:	fc                   	cld    
80104713:	f3 aa                	rep stos %al,%es:(%edi)
80104715:	5b                   	pop    %ebx
80104716:	89 d0                	mov    %edx,%eax
80104718:	5f                   	pop    %edi
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret    
8010471b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010471f:	90                   	nop

80104720 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104720:	f3 0f 1e fb          	endbr32 
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	56                   	push   %esi
80104728:	8b 75 10             	mov    0x10(%ebp),%esi
8010472b:	8b 55 08             	mov    0x8(%ebp),%edx
8010472e:	53                   	push   %ebx
8010472f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104732:	85 f6                	test   %esi,%esi
80104734:	74 2a                	je     80104760 <memcmp+0x40>
80104736:	01 c6                	add    %eax,%esi
80104738:	eb 10                	jmp    8010474a <memcmp+0x2a>
8010473a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104740:	83 c0 01             	add    $0x1,%eax
80104743:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104746:	39 f0                	cmp    %esi,%eax
80104748:	74 16                	je     80104760 <memcmp+0x40>
    if(*s1 != *s2)
8010474a:	0f b6 0a             	movzbl (%edx),%ecx
8010474d:	0f b6 18             	movzbl (%eax),%ebx
80104750:	38 d9                	cmp    %bl,%cl
80104752:	74 ec                	je     80104740 <memcmp+0x20>
      return *s1 - *s2;
80104754:	0f b6 c1             	movzbl %cl,%eax
80104757:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104759:	5b                   	pop    %ebx
8010475a:	5e                   	pop    %esi
8010475b:	5d                   	pop    %ebp
8010475c:	c3                   	ret    
8010475d:	8d 76 00             	lea    0x0(%esi),%esi
80104760:	5b                   	pop    %ebx
  return 0;
80104761:	31 c0                	xor    %eax,%eax
}
80104763:	5e                   	pop    %esi
80104764:	5d                   	pop    %ebp
80104765:	c3                   	ret    
80104766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	57                   	push   %edi
80104778:	8b 55 08             	mov    0x8(%ebp),%edx
8010477b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010477e:	56                   	push   %esi
8010477f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104782:	39 d6                	cmp    %edx,%esi
80104784:	73 2a                	jae    801047b0 <memmove+0x40>
80104786:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104789:	39 fa                	cmp    %edi,%edx
8010478b:	73 23                	jae    801047b0 <memmove+0x40>
8010478d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104790:	85 c9                	test   %ecx,%ecx
80104792:	74 13                	je     801047a7 <memmove+0x37>
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104798:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010479c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010479f:	83 e8 01             	sub    $0x1,%eax
801047a2:	83 f8 ff             	cmp    $0xffffffff,%eax
801047a5:	75 f1                	jne    80104798 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801047a7:	5e                   	pop    %esi
801047a8:	89 d0                	mov    %edx,%eax
801047aa:	5f                   	pop    %edi
801047ab:	5d                   	pop    %ebp
801047ac:	c3                   	ret    
801047ad:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801047b0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801047b3:	89 d7                	mov    %edx,%edi
801047b5:	85 c9                	test   %ecx,%ecx
801047b7:	74 ee                	je     801047a7 <memmove+0x37>
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
801047c0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
801047c1:	39 f0                	cmp    %esi,%eax
801047c3:	75 fb                	jne    801047c0 <memmove+0x50>
}
801047c5:	5e                   	pop    %esi
801047c6:	89 d0                	mov    %edx,%eax
801047c8:	5f                   	pop    %edi
801047c9:	5d                   	pop    %ebp
801047ca:	c3                   	ret    
801047cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047cf:	90                   	nop

801047d0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801047d0:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
801047d4:	eb 9a                	jmp    80104770 <memmove>
801047d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047dd:	8d 76 00             	lea    0x0(%esi),%esi

801047e0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801047e0:	f3 0f 1e fb          	endbr32 
801047e4:	55                   	push   %ebp
801047e5:	89 e5                	mov    %esp,%ebp
801047e7:	56                   	push   %esi
801047e8:	8b 75 10             	mov    0x10(%ebp),%esi
801047eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047ee:	53                   	push   %ebx
801047ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
801047f2:	85 f6                	test   %esi,%esi
801047f4:	74 32                	je     80104828 <strncmp+0x48>
801047f6:	01 c6                	add    %eax,%esi
801047f8:	eb 14                	jmp    8010480e <strncmp+0x2e>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104800:	38 da                	cmp    %bl,%dl
80104802:	75 14                	jne    80104818 <strncmp+0x38>
    n--, p++, q++;
80104804:	83 c0 01             	add    $0x1,%eax
80104807:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010480a:	39 f0                	cmp    %esi,%eax
8010480c:	74 1a                	je     80104828 <strncmp+0x48>
8010480e:	0f b6 11             	movzbl (%ecx),%edx
80104811:	0f b6 18             	movzbl (%eax),%ebx
80104814:	84 d2                	test   %dl,%dl
80104816:	75 e8                	jne    80104800 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104818:	0f b6 c2             	movzbl %dl,%eax
8010481b:	29 d8                	sub    %ebx,%eax
}
8010481d:	5b                   	pop    %ebx
8010481e:	5e                   	pop    %esi
8010481f:	5d                   	pop    %ebp
80104820:	c3                   	ret    
80104821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104828:	5b                   	pop    %ebx
    return 0;
80104829:	31 c0                	xor    %eax,%eax
}
8010482b:	5e                   	pop    %esi
8010482c:	5d                   	pop    %ebp
8010482d:	c3                   	ret    
8010482e:	66 90                	xchg   %ax,%ax

80104830 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	56                   	push   %esi
80104839:	8b 75 08             	mov    0x8(%ebp),%esi
8010483c:	53                   	push   %ebx
8010483d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104840:	89 f2                	mov    %esi,%edx
80104842:	eb 1b                	jmp    8010485f <strncpy+0x2f>
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104848:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010484c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010484f:	83 c2 01             	add    $0x1,%edx
80104852:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104856:	89 f9                	mov    %edi,%ecx
80104858:	88 4a ff             	mov    %cl,-0x1(%edx)
8010485b:	84 c9                	test   %cl,%cl
8010485d:	74 09                	je     80104868 <strncpy+0x38>
8010485f:	89 c3                	mov    %eax,%ebx
80104861:	83 e8 01             	sub    $0x1,%eax
80104864:	85 db                	test   %ebx,%ebx
80104866:	7f e0                	jg     80104848 <strncpy+0x18>
    ;
  while(n-- > 0)
80104868:	89 d1                	mov    %edx,%ecx
8010486a:	85 c0                	test   %eax,%eax
8010486c:	7e 15                	jle    80104883 <strncpy+0x53>
8010486e:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104870:	83 c1 01             	add    $0x1,%ecx
80104873:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104877:	89 c8                	mov    %ecx,%eax
80104879:	f7 d0                	not    %eax
8010487b:	01 d0                	add    %edx,%eax
8010487d:	01 d8                	add    %ebx,%eax
8010487f:	85 c0                	test   %eax,%eax
80104881:	7f ed                	jg     80104870 <strncpy+0x40>
  return os;
}
80104883:	5b                   	pop    %ebx
80104884:	89 f0                	mov    %esi,%eax
80104886:	5e                   	pop    %esi
80104887:	5f                   	pop    %edi
80104888:	5d                   	pop    %ebp
80104889:	c3                   	ret    
8010488a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104890 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104890:	f3 0f 1e fb          	endbr32 
80104894:	55                   	push   %ebp
80104895:	89 e5                	mov    %esp,%ebp
80104897:	56                   	push   %esi
80104898:	8b 55 10             	mov    0x10(%ebp),%edx
8010489b:	8b 75 08             	mov    0x8(%ebp),%esi
8010489e:	53                   	push   %ebx
8010489f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801048a2:	85 d2                	test   %edx,%edx
801048a4:	7e 21                	jle    801048c7 <safestrcpy+0x37>
801048a6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801048aa:	89 f2                	mov    %esi,%edx
801048ac:	eb 12                	jmp    801048c0 <safestrcpy+0x30>
801048ae:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801048b0:	0f b6 08             	movzbl (%eax),%ecx
801048b3:	83 c0 01             	add    $0x1,%eax
801048b6:	83 c2 01             	add    $0x1,%edx
801048b9:	88 4a ff             	mov    %cl,-0x1(%edx)
801048bc:	84 c9                	test   %cl,%cl
801048be:	74 04                	je     801048c4 <safestrcpy+0x34>
801048c0:	39 d8                	cmp    %ebx,%eax
801048c2:	75 ec                	jne    801048b0 <safestrcpy+0x20>
    ;
  *s = 0;
801048c4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
801048c7:	89 f0                	mov    %esi,%eax
801048c9:	5b                   	pop    %ebx
801048ca:	5e                   	pop    %esi
801048cb:	5d                   	pop    %ebp
801048cc:	c3                   	ret    
801048cd:	8d 76 00             	lea    0x0(%esi),%esi

801048d0 <strlen>:

int
strlen(const char *s)
{
801048d0:	f3 0f 1e fb          	endbr32 
801048d4:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801048d5:	31 c0                	xor    %eax,%eax
{
801048d7:	89 e5                	mov    %esp,%ebp
801048d9:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801048dc:	80 3a 00             	cmpb   $0x0,(%edx)
801048df:	74 10                	je     801048f1 <strlen+0x21>
801048e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048e8:	83 c0 01             	add    $0x1,%eax
801048eb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801048ef:	75 f7                	jne    801048e8 <strlen+0x18>
    ;
  return n;
}
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    

801048f3 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801048f3:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801048f7:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801048fb:	55                   	push   %ebp
  pushl %ebx
801048fc:	53                   	push   %ebx
  pushl %esi
801048fd:	56                   	push   %esi
  pushl %edi
801048fe:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801048ff:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104901:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104903:	5f                   	pop    %edi
  popl %esi
80104904:	5e                   	pop    %esi
  popl %ebx
80104905:	5b                   	pop    %ebx
  popl %ebp
80104906:	5d                   	pop    %ebp
  ret
80104907:	c3                   	ret    
80104908:	66 90                	xchg   %ax,%ax
8010490a:	66 90                	xchg   %ax,%ax
8010490c:	66 90                	xchg   %ax,%ax
8010490e:	66 90                	xchg   %ax,%ax

80104910 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104910:	f3 0f 1e fb          	endbr32 
80104914:	55                   	push   %ebp
80104915:	89 e5                	mov    %esp,%ebp
80104917:	53                   	push   %ebx
80104918:	83 ec 04             	sub    $0x4,%esp
8010491b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010491e:	e8 5d f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104923:	8b 00                	mov    (%eax),%eax
80104925:	39 d8                	cmp    %ebx,%eax
80104927:	76 17                	jbe    80104940 <fetchint+0x30>
80104929:	8d 53 04             	lea    0x4(%ebx),%edx
8010492c:	39 d0                	cmp    %edx,%eax
8010492e:	72 10                	jb     80104940 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104930:	8b 45 0c             	mov    0xc(%ebp),%eax
80104933:	8b 13                	mov    (%ebx),%edx
80104935:	89 10                	mov    %edx,(%eax)
  return 0;
80104937:	31 c0                	xor    %eax,%eax
}
80104939:	83 c4 04             	add    $0x4,%esp
8010493c:	5b                   	pop    %ebx
8010493d:	5d                   	pop    %ebp
8010493e:	c3                   	ret    
8010493f:	90                   	nop
    return -1;
80104940:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104945:	eb f2                	jmp    80104939 <fetchint+0x29>
80104947:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010494e:	66 90                	xchg   %ax,%ax

80104950 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104950:	f3 0f 1e fb          	endbr32 
80104954:	55                   	push   %ebp
80104955:	89 e5                	mov    %esp,%ebp
80104957:	53                   	push   %ebx
80104958:	83 ec 04             	sub    $0x4,%esp
8010495b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010495e:	e8 1d f0 ff ff       	call   80103980 <myproc>

  if(addr >= curproc->sz)
80104963:	39 18                	cmp    %ebx,(%eax)
80104965:	76 31                	jbe    80104998 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
80104967:	8b 55 0c             	mov    0xc(%ebp),%edx
8010496a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010496c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010496e:	39 d3                	cmp    %edx,%ebx
80104970:	73 26                	jae    80104998 <fetchstr+0x48>
80104972:	89 d8                	mov    %ebx,%eax
80104974:	eb 11                	jmp    80104987 <fetchstr+0x37>
80104976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	39 c2                	cmp    %eax,%edx
80104985:	76 11                	jbe    80104998 <fetchstr+0x48>
    if(*s == 0)
80104987:	80 38 00             	cmpb   $0x0,(%eax)
8010498a:	75 f4                	jne    80104980 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010498c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010498f:	29 d8                	sub    %ebx,%eax
}
80104991:	5b                   	pop    %ebx
80104992:	5d                   	pop    %ebp
80104993:	c3                   	ret    
80104994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104998:	83 c4 04             	add    $0x4,%esp
    return -1;
8010499b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049a0:	5b                   	pop    %ebx
801049a1:	5d                   	pop    %ebp
801049a2:	c3                   	ret    
801049a3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	56                   	push   %esi
801049b8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049b9:	e8 c2 ef ff ff       	call   80103980 <myproc>
801049be:	8b 55 08             	mov    0x8(%ebp),%edx
801049c1:	8b 40 18             	mov    0x18(%eax),%eax
801049c4:	8b 40 44             	mov    0x44(%eax),%eax
801049c7:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801049ca:	e8 b1 ef ff ff       	call   80103980 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049cf:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049d2:	8b 00                	mov    (%eax),%eax
801049d4:	39 c6                	cmp    %eax,%esi
801049d6:	73 18                	jae    801049f0 <argint+0x40>
801049d8:	8d 53 08             	lea    0x8(%ebx),%edx
801049db:	39 d0                	cmp    %edx,%eax
801049dd:	72 11                	jb     801049f0 <argint+0x40>
  *ip = *(int*)(addr);
801049df:	8b 45 0c             	mov    0xc(%ebp),%eax
801049e2:	8b 53 04             	mov    0x4(%ebx),%edx
801049e5:	89 10                	mov    %edx,(%eax)
  return 0;
801049e7:	31 c0                	xor    %eax,%eax
}
801049e9:	5b                   	pop    %ebx
801049ea:	5e                   	pop    %esi
801049eb:	5d                   	pop    %ebp
801049ec:	c3                   	ret    
801049ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801049f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801049f5:	eb f2                	jmp    801049e9 <argint+0x39>
801049f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049fe:	66 90                	xchg   %ax,%ax

80104a00 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a00:	f3 0f 1e fb          	endbr32 
80104a04:	55                   	push   %ebp
80104a05:	89 e5                	mov    %esp,%ebp
80104a07:	56                   	push   %esi
80104a08:	53                   	push   %ebx
80104a09:	83 ec 10             	sub    $0x10,%esp
80104a0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104a0f:	e8 6c ef ff ff       	call   80103980 <myproc>
 
  if(argint(n, &i) < 0)
80104a14:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80104a17:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80104a19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a1c:	50                   	push   %eax
80104a1d:	ff 75 08             	pushl  0x8(%ebp)
80104a20:	e8 8b ff ff ff       	call   801049b0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104a25:	83 c4 10             	add    $0x10,%esp
80104a28:	85 c0                	test   %eax,%eax
80104a2a:	78 24                	js     80104a50 <argptr+0x50>
80104a2c:	85 db                	test   %ebx,%ebx
80104a2e:	78 20                	js     80104a50 <argptr+0x50>
80104a30:	8b 16                	mov    (%esi),%edx
80104a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a35:	39 c2                	cmp    %eax,%edx
80104a37:	76 17                	jbe    80104a50 <argptr+0x50>
80104a39:	01 c3                	add    %eax,%ebx
80104a3b:	39 da                	cmp    %ebx,%edx
80104a3d:	72 11                	jb     80104a50 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104a42:	89 02                	mov    %eax,(%edx)
  return 0;
80104a44:	31 c0                	xor    %eax,%eax
}
80104a46:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret    
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a55:	eb ef                	jmp    80104a46 <argptr+0x46>
80104a57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5e:	66 90                	xchg   %ax,%ax

80104a60 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104a60:	f3 0f 1e fb          	endbr32 
80104a64:	55                   	push   %ebp
80104a65:	89 e5                	mov    %esp,%ebp
80104a67:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104a6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a6d:	50                   	push   %eax
80104a6e:	ff 75 08             	pushl  0x8(%ebp)
80104a71:	e8 3a ff ff ff       	call   801049b0 <argint>
80104a76:	83 c4 10             	add    $0x10,%esp
80104a79:	85 c0                	test   %eax,%eax
80104a7b:	78 13                	js     80104a90 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104a7d:	83 ec 08             	sub    $0x8,%esp
80104a80:	ff 75 0c             	pushl  0xc(%ebp)
80104a83:	ff 75 f4             	pushl  -0xc(%ebp)
80104a86:	e8 c5 fe ff ff       	call   80104950 <fetchstr>
80104a8b:	83 c4 10             	add    $0x10,%esp
}
80104a8e:	c9                   	leave  
80104a8f:	c3                   	ret    
80104a90:	c9                   	leave  
    return -1;
80104a91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a96:	c3                   	ret    
80104a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <syscall>:

};

void
syscall(void)
{
80104aa0:	f3 0f 1e fb          	endbr32 
80104aa4:	55                   	push   %ebp
80104aa5:	89 e5                	mov    %esp,%ebp
80104aa7:	53                   	push   %ebx
80104aa8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104aab:	e8 d0 ee ff ff       	call   80103980 <myproc>
80104ab0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104ab2:	8b 40 18             	mov    0x18(%eax),%eax
80104ab5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ab8:	8d 50 ff             	lea    -0x1(%eax),%edx
80104abb:	83 fa 19             	cmp    $0x19,%edx
80104abe:	77 20                	ja     80104ae0 <syscall+0x40>
80104ac0:	8b 14 85 60 80 10 80 	mov    -0x7fef7fa0(,%eax,4),%edx
80104ac7:	85 d2                	test   %edx,%edx
80104ac9:	74 15                	je     80104ae0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104acb:	ff d2                	call   *%edx
80104acd:	89 c2                	mov    %eax,%edx
80104acf:	8b 43 18             	mov    0x18(%ebx),%eax
80104ad2:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ad5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ad8:	c9                   	leave  
80104ad9:	c3                   	ret    
80104ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ae0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ae1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ae4:	50                   	push   %eax
80104ae5:	ff 73 10             	pushl  0x10(%ebx)
80104ae8:	68 3d 80 10 80       	push   $0x8010803d
80104aed:	e8 be bb ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104af2:	8b 43 18             	mov    0x18(%ebx),%eax
80104af5:	83 c4 10             	add    $0x10,%esp
80104af8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104aff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b02:	c9                   	leave  
80104b03:	c3                   	ret    
80104b04:	66 90                	xchg   %ax,%ax
80104b06:	66 90                	xchg   %ax,%ax
80104b08:	66 90                	xchg   %ax,%ax
80104b0a:	66 90                	xchg   %ax,%ax
80104b0c:	66 90                	xchg   %ax,%ax
80104b0e:	66 90                	xchg   %ax,%ax

80104b10 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104b10:	55                   	push   %ebp
80104b11:	89 e5                	mov    %esp,%ebp
80104b13:	57                   	push   %edi
80104b14:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104b15:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104b18:	53                   	push   %ebx
80104b19:	83 ec 34             	sub    $0x34,%esp
80104b1c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104b1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104b22:	57                   	push   %edi
80104b23:	50                   	push   %eax
{
80104b24:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104b27:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104b2a:	e8 21 d5 ff ff       	call   80102050 <nameiparent>
80104b2f:	83 c4 10             	add    $0x10,%esp
80104b32:	85 c0                	test   %eax,%eax
80104b34:	0f 84 46 01 00 00    	je     80104c80 <create+0x170>
    return 0;
  ilock(dp);
80104b3a:	83 ec 0c             	sub    $0xc,%esp
80104b3d:	89 c3                	mov    %eax,%ebx
80104b3f:	50                   	push   %eax
80104b40:	e8 1b cc ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104b45:	83 c4 0c             	add    $0xc,%esp
80104b48:	6a 00                	push   $0x0
80104b4a:	57                   	push   %edi
80104b4b:	53                   	push   %ebx
80104b4c:	e8 5f d1 ff ff       	call   80101cb0 <dirlookup>
80104b51:	83 c4 10             	add    $0x10,%esp
80104b54:	89 c6                	mov    %eax,%esi
80104b56:	85 c0                	test   %eax,%eax
80104b58:	74 56                	je     80104bb0 <create+0xa0>
    iunlockput(dp);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	53                   	push   %ebx
80104b5e:	e8 9d ce ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
80104b63:	89 34 24             	mov    %esi,(%esp)
80104b66:	e8 f5 cb ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104b6b:	83 c4 10             	add    $0x10,%esp
80104b6e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104b73:	75 1b                	jne    80104b90 <create+0x80>
80104b75:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104b7a:	75 14                	jne    80104b90 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7f:	89 f0                	mov    %esi,%eax
80104b81:	5b                   	pop    %ebx
80104b82:	5e                   	pop    %esi
80104b83:	5f                   	pop    %edi
80104b84:	5d                   	pop    %ebp
80104b85:	c3                   	ret    
80104b86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	56                   	push   %esi
    return 0;
80104b94:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104b96:	e8 65 ce ff ff       	call   80101a00 <iunlockput>
    return 0;
80104b9b:	83 c4 10             	add    $0x10,%esp
}
80104b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ba1:	89 f0                	mov    %esi,%eax
80104ba3:	5b                   	pop    %ebx
80104ba4:	5e                   	pop    %esi
80104ba5:	5f                   	pop    %edi
80104ba6:	5d                   	pop    %ebp
80104ba7:	c3                   	ret    
80104ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104baf:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104bb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104bb4:	83 ec 08             	sub    $0x8,%esp
80104bb7:	50                   	push   %eax
80104bb8:	ff 33                	pushl  (%ebx)
80104bba:	e8 21 ca ff ff       	call   801015e0 <ialloc>
80104bbf:	83 c4 10             	add    $0x10,%esp
80104bc2:	89 c6                	mov    %eax,%esi
80104bc4:	85 c0                	test   %eax,%eax
80104bc6:	0f 84 cd 00 00 00    	je     80104c99 <create+0x189>
  ilock(ip);
80104bcc:	83 ec 0c             	sub    $0xc,%esp
80104bcf:	50                   	push   %eax
80104bd0:	e8 8b cb ff ff       	call   80101760 <ilock>
  ip->major = major;
80104bd5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104bd9:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104bdd:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104be1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104be5:	b8 01 00 00 00       	mov    $0x1,%eax
80104bea:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104bee:	89 34 24             	mov    %esi,(%esp)
80104bf1:	e8 aa ca ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104bf6:	83 c4 10             	add    $0x10,%esp
80104bf9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104bfe:	74 30                	je     80104c30 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104c00:	83 ec 04             	sub    $0x4,%esp
80104c03:	ff 76 04             	pushl  0x4(%esi)
80104c06:	57                   	push   %edi
80104c07:	53                   	push   %ebx
80104c08:	e8 63 d3 ff ff       	call   80101f70 <dirlink>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	78 78                	js     80104c8c <create+0x17c>
  iunlockput(dp);
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	53                   	push   %ebx
80104c18:	e8 e3 cd ff ff       	call   80101a00 <iunlockput>
  return ip;
80104c1d:	83 c4 10             	add    $0x10,%esp
}
80104c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c23:	89 f0                	mov    %esi,%eax
80104c25:	5b                   	pop    %ebx
80104c26:	5e                   	pop    %esi
80104c27:	5f                   	pop    %edi
80104c28:	5d                   	pop    %ebp
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104c30:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104c33:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104c38:	53                   	push   %ebx
80104c39:	e8 62 ca ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104c3e:	83 c4 0c             	add    $0xc,%esp
80104c41:	ff 76 04             	pushl  0x4(%esi)
80104c44:	68 e8 80 10 80       	push   $0x801080e8
80104c49:	56                   	push   %esi
80104c4a:	e8 21 d3 ff ff       	call   80101f70 <dirlink>
80104c4f:	83 c4 10             	add    $0x10,%esp
80104c52:	85 c0                	test   %eax,%eax
80104c54:	78 18                	js     80104c6e <create+0x15e>
80104c56:	83 ec 04             	sub    $0x4,%esp
80104c59:	ff 73 04             	pushl  0x4(%ebx)
80104c5c:	68 e7 80 10 80       	push   $0x801080e7
80104c61:	56                   	push   %esi
80104c62:	e8 09 d3 ff ff       	call   80101f70 <dirlink>
80104c67:	83 c4 10             	add    $0x10,%esp
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	79 92                	jns    80104c00 <create+0xf0>
      panic("create dots");
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	68 db 80 10 80       	push   $0x801080db
80104c76:	e8 15 b7 ff ff       	call   80100390 <panic>
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
}
80104c80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c83:	31 f6                	xor    %esi,%esi
}
80104c85:	5b                   	pop    %ebx
80104c86:	89 f0                	mov    %esi,%eax
80104c88:	5e                   	pop    %esi
80104c89:	5f                   	pop    %edi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
    panic("create: dirlink");
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	68 ea 80 10 80       	push   $0x801080ea
80104c94:	e8 f7 b6 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104c99:	83 ec 0c             	sub    $0xc,%esp
80104c9c:	68 cc 80 10 80       	push   $0x801080cc
80104ca1:	e8 ea b6 ff ff       	call   80100390 <panic>
80104ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cad:	8d 76 00             	lea    0x0(%esi),%esi

80104cb0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	56                   	push   %esi
80104cb4:	89 d6                	mov    %edx,%esi
80104cb6:	53                   	push   %ebx
80104cb7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104cb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104cbc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104cbf:	50                   	push   %eax
80104cc0:	6a 00                	push   $0x0
80104cc2:	e8 e9 fc ff ff       	call   801049b0 <argint>
80104cc7:	83 c4 10             	add    $0x10,%esp
80104cca:	85 c0                	test   %eax,%eax
80104ccc:	78 2a                	js     80104cf8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104cce:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104cd2:	77 24                	ja     80104cf8 <argfd.constprop.0+0x48>
80104cd4:	e8 a7 ec ff ff       	call   80103980 <myproc>
80104cd9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cdc:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	74 14                	je     80104cf8 <argfd.constprop.0+0x48>
  if(pfd)
80104ce4:	85 db                	test   %ebx,%ebx
80104ce6:	74 02                	je     80104cea <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ce8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104cea:	89 06                	mov    %eax,(%esi)
  return 0;
80104cec:	31 c0                	xor    %eax,%eax
}
80104cee:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104cf1:	5b                   	pop    %ebx
80104cf2:	5e                   	pop    %esi
80104cf3:	5d                   	pop    %ebp
80104cf4:	c3                   	ret    
80104cf5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104cf8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cfd:	eb ef                	jmp    80104cee <argfd.constprop.0+0x3e>
80104cff:	90                   	nop

80104d00 <sys_dup>:
{
80104d00:	f3 0f 1e fb          	endbr32 
80104d04:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104d05:	31 c0                	xor    %eax,%eax
{
80104d07:	89 e5                	mov    %esp,%ebp
80104d09:	56                   	push   %esi
80104d0a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d0b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d0e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d11:	e8 9a ff ff ff       	call   80104cb0 <argfd.constprop.0>
80104d16:	85 c0                	test   %eax,%eax
80104d18:	78 1e                	js     80104d38 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104d1a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d1d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d1f:	e8 5c ec ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80104d28:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104d2c:	85 d2                	test   %edx,%edx
80104d2e:	74 20                	je     80104d50 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80104d30:	83 c3 01             	add    $0x1,%ebx
80104d33:	83 fb 10             	cmp    $0x10,%ebx
80104d36:	75 f0                	jne    80104d28 <sys_dup+0x28>
}
80104d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104d3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104d40:	89 d8                	mov    %ebx,%eax
80104d42:	5b                   	pop    %ebx
80104d43:	5e                   	pop    %esi
80104d44:	5d                   	pop    %ebp
80104d45:	c3                   	ret    
80104d46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80104d50:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	ff 75 f4             	pushl  -0xc(%ebp)
80104d5a:	e8 11 c1 ff ff       	call   80100e70 <filedup>
  return fd;
80104d5f:	83 c4 10             	add    $0x10,%esp
}
80104d62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d65:	89 d8                	mov    %ebx,%eax
80104d67:	5b                   	pop    %ebx
80104d68:	5e                   	pop    %esi
80104d69:	5d                   	pop    %ebp
80104d6a:	c3                   	ret    
80104d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d6f:	90                   	nop

80104d70 <sys_read>:
{
80104d70:	f3 0f 1e fb          	endbr32 
80104d74:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d75:	31 c0                	xor    %eax,%eax
{
80104d77:	89 e5                	mov    %esp,%ebp
80104d79:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104d7c:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104d7f:	e8 2c ff ff ff       	call   80104cb0 <argfd.constprop.0>
80104d84:	85 c0                	test   %eax,%eax
80104d86:	78 48                	js     80104dd0 <sys_read+0x60>
80104d88:	83 ec 08             	sub    $0x8,%esp
80104d8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d8e:	50                   	push   %eax
80104d8f:	6a 02                	push   $0x2
80104d91:	e8 1a fc ff ff       	call   801049b0 <argint>
80104d96:	83 c4 10             	add    $0x10,%esp
80104d99:	85 c0                	test   %eax,%eax
80104d9b:	78 33                	js     80104dd0 <sys_read+0x60>
80104d9d:	83 ec 04             	sub    $0x4,%esp
80104da0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da3:	ff 75 f0             	pushl  -0x10(%ebp)
80104da6:	50                   	push   %eax
80104da7:	6a 01                	push   $0x1
80104da9:	e8 52 fc ff ff       	call   80104a00 <argptr>
80104dae:	83 c4 10             	add    $0x10,%esp
80104db1:	85 c0                	test   %eax,%eax
80104db3:	78 1b                	js     80104dd0 <sys_read+0x60>
  return fileread(f, p, n);
80104db5:	83 ec 04             	sub    $0x4,%esp
80104db8:	ff 75 f0             	pushl  -0x10(%ebp)
80104dbb:	ff 75 f4             	pushl  -0xc(%ebp)
80104dbe:	ff 75 ec             	pushl  -0x14(%ebp)
80104dc1:	e8 2a c2 ff ff       	call   80100ff0 <fileread>
80104dc6:	83 c4 10             	add    $0x10,%esp
}
80104dc9:	c9                   	leave  
80104dca:	c3                   	ret    
80104dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop
80104dd0:	c9                   	leave  
    return -1;
80104dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd6:	c3                   	ret    
80104dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dde:	66 90                	xchg   %ax,%ax

80104de0 <sys_write>:
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de5:	31 c0                	xor    %eax,%eax
{
80104de7:	89 e5                	mov    %esp,%ebp
80104de9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104dec:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104def:	e8 bc fe ff ff       	call   80104cb0 <argfd.constprop.0>
80104df4:	85 c0                	test   %eax,%eax
80104df6:	78 48                	js     80104e40 <sys_write+0x60>
80104df8:	83 ec 08             	sub    $0x8,%esp
80104dfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104dfe:	50                   	push   %eax
80104dff:	6a 02                	push   $0x2
80104e01:	e8 aa fb ff ff       	call   801049b0 <argint>
80104e06:	83 c4 10             	add    $0x10,%esp
80104e09:	85 c0                	test   %eax,%eax
80104e0b:	78 33                	js     80104e40 <sys_write+0x60>
80104e0d:	83 ec 04             	sub    $0x4,%esp
80104e10:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e13:	ff 75 f0             	pushl  -0x10(%ebp)
80104e16:	50                   	push   %eax
80104e17:	6a 01                	push   $0x1
80104e19:	e8 e2 fb ff ff       	call   80104a00 <argptr>
80104e1e:	83 c4 10             	add    $0x10,%esp
80104e21:	85 c0                	test   %eax,%eax
80104e23:	78 1b                	js     80104e40 <sys_write+0x60>
  return filewrite(f, p, n);
80104e25:	83 ec 04             	sub    $0x4,%esp
80104e28:	ff 75 f0             	pushl  -0x10(%ebp)
80104e2b:	ff 75 f4             	pushl  -0xc(%ebp)
80104e2e:	ff 75 ec             	pushl  -0x14(%ebp)
80104e31:	e8 5a c2 ff ff       	call   80101090 <filewrite>
80104e36:	83 c4 10             	add    $0x10,%esp
}
80104e39:	c9                   	leave  
80104e3a:	c3                   	ret    
80104e3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e3f:	90                   	nop
80104e40:	c9                   	leave  
    return -1;
80104e41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e46:	c3                   	ret    
80104e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4e:	66 90                	xchg   %ax,%ax

80104e50 <sys_close>:
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104e5a:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e60:	e8 4b fe ff ff       	call   80104cb0 <argfd.constprop.0>
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 27                	js     80104e90 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104e69:	e8 12 eb ff ff       	call   80103980 <myproc>
80104e6e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104e71:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104e74:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104e7b:	00 
  fileclose(f);
80104e7c:	ff 75 f4             	pushl  -0xc(%ebp)
80104e7f:	e8 3c c0 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104e84:	83 c4 10             	add    $0x10,%esp
80104e87:	31 c0                	xor    %eax,%eax
}
80104e89:	c9                   	leave  
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop
80104e90:	c9                   	leave  
    return -1;
80104e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e96:	c3                   	ret    
80104e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e9e:	66 90                	xchg   %ax,%ax

80104ea0 <sys_fstat>:
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ea5:	31 c0                	xor    %eax,%eax
{
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104eac:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104eaf:	e8 fc fd ff ff       	call   80104cb0 <argfd.constprop.0>
80104eb4:	85 c0                	test   %eax,%eax
80104eb6:	78 30                	js     80104ee8 <sys_fstat+0x48>
80104eb8:	83 ec 04             	sub    $0x4,%esp
80104ebb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ebe:	6a 14                	push   $0x14
80104ec0:	50                   	push   %eax
80104ec1:	6a 01                	push   $0x1
80104ec3:	e8 38 fb ff ff       	call   80104a00 <argptr>
80104ec8:	83 c4 10             	add    $0x10,%esp
80104ecb:	85 c0                	test   %eax,%eax
80104ecd:	78 19                	js     80104ee8 <sys_fstat+0x48>
  return filestat(f, st);
80104ecf:	83 ec 08             	sub    $0x8,%esp
80104ed2:	ff 75 f4             	pushl  -0xc(%ebp)
80104ed5:	ff 75 f0             	pushl  -0x10(%ebp)
80104ed8:	e8 c3 c0 ff ff       	call   80100fa0 <filestat>
80104edd:	83 c4 10             	add    $0x10,%esp
}
80104ee0:	c9                   	leave  
80104ee1:	c3                   	ret    
80104ee2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ee8:	c9                   	leave  
    return -1;
80104ee9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eee:	c3                   	ret    
80104eef:	90                   	nop

80104ef0 <sys_link>:
{
80104ef0:	f3 0f 1e fb          	endbr32 
80104ef4:	55                   	push   %ebp
80104ef5:	89 e5                	mov    %esp,%ebp
80104ef7:	57                   	push   %edi
80104ef8:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ef9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104efc:	53                   	push   %ebx
80104efd:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f00:	50                   	push   %eax
80104f01:	6a 00                	push   $0x0
80104f03:	e8 58 fb ff ff       	call   80104a60 <argstr>
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	0f 88 ff 00 00 00    	js     80105012 <sys_link+0x122>
80104f13:	83 ec 08             	sub    $0x8,%esp
80104f16:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f19:	50                   	push   %eax
80104f1a:	6a 01                	push   $0x1
80104f1c:	e8 3f fb ff ff       	call   80104a60 <argstr>
80104f21:	83 c4 10             	add    $0x10,%esp
80104f24:	85 c0                	test   %eax,%eax
80104f26:	0f 88 e6 00 00 00    	js     80105012 <sys_link+0x122>
  begin_op();
80104f2c:	e8 ff dd ff ff       	call   80102d30 <begin_op>
  if((ip = namei(old)) == 0){
80104f31:	83 ec 0c             	sub    $0xc,%esp
80104f34:	ff 75 d4             	pushl  -0x2c(%ebp)
80104f37:	e8 f4 d0 ff ff       	call   80102030 <namei>
80104f3c:	83 c4 10             	add    $0x10,%esp
80104f3f:	89 c3                	mov    %eax,%ebx
80104f41:	85 c0                	test   %eax,%eax
80104f43:	0f 84 e8 00 00 00    	je     80105031 <sys_link+0x141>
  ilock(ip);
80104f49:	83 ec 0c             	sub    $0xc,%esp
80104f4c:	50                   	push   %eax
80104f4d:	e8 0e c8 ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80104f52:	83 c4 10             	add    $0x10,%esp
80104f55:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f5a:	0f 84 b9 00 00 00    	je     80105019 <sys_link+0x129>
  iupdate(ip);
80104f60:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104f63:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104f68:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104f6b:	53                   	push   %ebx
80104f6c:	e8 2f c7 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
80104f71:	89 1c 24             	mov    %ebx,(%esp)
80104f74:	e8 c7 c8 ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104f79:	58                   	pop    %eax
80104f7a:	5a                   	pop    %edx
80104f7b:	57                   	push   %edi
80104f7c:	ff 75 d0             	pushl  -0x30(%ebp)
80104f7f:	e8 cc d0 ff ff       	call   80102050 <nameiparent>
80104f84:	83 c4 10             	add    $0x10,%esp
80104f87:	89 c6                	mov    %eax,%esi
80104f89:	85 c0                	test   %eax,%eax
80104f8b:	74 5f                	je     80104fec <sys_link+0xfc>
  ilock(dp);
80104f8d:	83 ec 0c             	sub    $0xc,%esp
80104f90:	50                   	push   %eax
80104f91:	e8 ca c7 ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104f96:	8b 03                	mov    (%ebx),%eax
80104f98:	83 c4 10             	add    $0x10,%esp
80104f9b:	39 06                	cmp    %eax,(%esi)
80104f9d:	75 41                	jne    80104fe0 <sys_link+0xf0>
80104f9f:	83 ec 04             	sub    $0x4,%esp
80104fa2:	ff 73 04             	pushl  0x4(%ebx)
80104fa5:	57                   	push   %edi
80104fa6:	56                   	push   %esi
80104fa7:	e8 c4 cf ff ff       	call   80101f70 <dirlink>
80104fac:	83 c4 10             	add    $0x10,%esp
80104faf:	85 c0                	test   %eax,%eax
80104fb1:	78 2d                	js     80104fe0 <sys_link+0xf0>
  iunlockput(dp);
80104fb3:	83 ec 0c             	sub    $0xc,%esp
80104fb6:	56                   	push   %esi
80104fb7:	e8 44 ca ff ff       	call   80101a00 <iunlockput>
  iput(ip);
80104fbc:	89 1c 24             	mov    %ebx,(%esp)
80104fbf:	e8 cc c8 ff ff       	call   80101890 <iput>
  end_op();
80104fc4:	e8 d7 dd ff ff       	call   80102da0 <end_op>
  return 0;
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	31 c0                	xor    %eax,%eax
}
80104fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd1:	5b                   	pop    %ebx
80104fd2:	5e                   	pop    %esi
80104fd3:	5f                   	pop    %edi
80104fd4:	5d                   	pop    %ebp
80104fd5:	c3                   	ret    
80104fd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fdd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
80104fe3:	56                   	push   %esi
80104fe4:	e8 17 ca ff ff       	call   80101a00 <iunlockput>
    goto bad;
80104fe9:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104fec:	83 ec 0c             	sub    $0xc,%esp
80104fef:	53                   	push   %ebx
80104ff0:	e8 6b c7 ff ff       	call   80101760 <ilock>
  ip->nlink--;
80104ff5:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ffa:	89 1c 24             	mov    %ebx,(%esp)
80104ffd:	e8 9e c6 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105002:	89 1c 24             	mov    %ebx,(%esp)
80105005:	e8 f6 c9 ff ff       	call   80101a00 <iunlockput>
  end_op();
8010500a:	e8 91 dd ff ff       	call   80102da0 <end_op>
  return -1;
8010500f:	83 c4 10             	add    $0x10,%esp
80105012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105017:	eb b5                	jmp    80104fce <sys_link+0xde>
    iunlockput(ip);
80105019:	83 ec 0c             	sub    $0xc,%esp
8010501c:	53                   	push   %ebx
8010501d:	e8 de c9 ff ff       	call   80101a00 <iunlockput>
    end_op();
80105022:	e8 79 dd ff ff       	call   80102da0 <end_op>
    return -1;
80105027:	83 c4 10             	add    $0x10,%esp
8010502a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502f:	eb 9d                	jmp    80104fce <sys_link+0xde>
    end_op();
80105031:	e8 6a dd ff ff       	call   80102da0 <end_op>
    return -1;
80105036:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503b:	eb 91                	jmp    80104fce <sys_link+0xde>
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

80105040 <sys_unlink>:
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
80105045:	89 e5                	mov    %esp,%ebp
80105047:	57                   	push   %edi
80105048:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105049:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
8010504c:	53                   	push   %ebx
8010504d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105050:	50                   	push   %eax
80105051:	6a 00                	push   $0x0
80105053:	e8 08 fa ff ff       	call   80104a60 <argstr>
80105058:	83 c4 10             	add    $0x10,%esp
8010505b:	85 c0                	test   %eax,%eax
8010505d:	0f 88 7d 01 00 00    	js     801051e0 <sys_unlink+0x1a0>
  begin_op();
80105063:	e8 c8 dc ff ff       	call   80102d30 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105068:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010506b:	83 ec 08             	sub    $0x8,%esp
8010506e:	53                   	push   %ebx
8010506f:	ff 75 c0             	pushl  -0x40(%ebp)
80105072:	e8 d9 cf ff ff       	call   80102050 <nameiparent>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	89 c6                	mov    %eax,%esi
8010507c:	85 c0                	test   %eax,%eax
8010507e:	0f 84 66 01 00 00    	je     801051ea <sys_unlink+0x1aa>
  ilock(dp);
80105084:	83 ec 0c             	sub    $0xc,%esp
80105087:	50                   	push   %eax
80105088:	e8 d3 c6 ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010508d:	58                   	pop    %eax
8010508e:	5a                   	pop    %edx
8010508f:	68 e8 80 10 80       	push   $0x801080e8
80105094:	53                   	push   %ebx
80105095:	e8 f6 cb ff ff       	call   80101c90 <namecmp>
8010509a:	83 c4 10             	add    $0x10,%esp
8010509d:	85 c0                	test   %eax,%eax
8010509f:	0f 84 03 01 00 00    	je     801051a8 <sys_unlink+0x168>
801050a5:	83 ec 08             	sub    $0x8,%esp
801050a8:	68 e7 80 10 80       	push   $0x801080e7
801050ad:	53                   	push   %ebx
801050ae:	e8 dd cb ff ff       	call   80101c90 <namecmp>
801050b3:	83 c4 10             	add    $0x10,%esp
801050b6:	85 c0                	test   %eax,%eax
801050b8:	0f 84 ea 00 00 00    	je     801051a8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
801050be:	83 ec 04             	sub    $0x4,%esp
801050c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801050c4:	50                   	push   %eax
801050c5:	53                   	push   %ebx
801050c6:	56                   	push   %esi
801050c7:	e8 e4 cb ff ff       	call   80101cb0 <dirlookup>
801050cc:	83 c4 10             	add    $0x10,%esp
801050cf:	89 c3                	mov    %eax,%ebx
801050d1:	85 c0                	test   %eax,%eax
801050d3:	0f 84 cf 00 00 00    	je     801051a8 <sys_unlink+0x168>
  ilock(ip);
801050d9:	83 ec 0c             	sub    $0xc,%esp
801050dc:	50                   	push   %eax
801050dd:	e8 7e c6 ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801050ea:	0f 8e 23 01 00 00    	jle    80105213 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
801050f0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801050f5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050f8:	74 66                	je     80105160 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801050fa:	83 ec 04             	sub    $0x4,%esp
801050fd:	6a 10                	push   $0x10
801050ff:	6a 00                	push   $0x0
80105101:	57                   	push   %edi
80105102:	e8 c9 f5 ff ff       	call   801046d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105107:	6a 10                	push   $0x10
80105109:	ff 75 c4             	pushl  -0x3c(%ebp)
8010510c:	57                   	push   %edi
8010510d:	56                   	push   %esi
8010510e:	e8 4d ca ff ff       	call   80101b60 <writei>
80105113:	83 c4 20             	add    $0x20,%esp
80105116:	83 f8 10             	cmp    $0x10,%eax
80105119:	0f 85 e7 00 00 00    	jne    80105206 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010511f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105124:	0f 84 96 00 00 00    	je     801051c0 <sys_unlink+0x180>
  iunlockput(dp);
8010512a:	83 ec 0c             	sub    $0xc,%esp
8010512d:	56                   	push   %esi
8010512e:	e8 cd c8 ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105133:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105138:	89 1c 24             	mov    %ebx,(%esp)
8010513b:	e8 60 c5 ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105140:	89 1c 24             	mov    %ebx,(%esp)
80105143:	e8 b8 c8 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105148:	e8 53 dc ff ff       	call   80102da0 <end_op>
  return 0;
8010514d:	83 c4 10             	add    $0x10,%esp
80105150:	31 c0                	xor    %eax,%eax
}
80105152:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105155:	5b                   	pop    %ebx
80105156:	5e                   	pop    %esi
80105157:	5f                   	pop    %edi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105160:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105164:	76 94                	jbe    801050fa <sys_unlink+0xba>
80105166:	ba 20 00 00 00       	mov    $0x20,%edx
8010516b:	eb 0b                	jmp    80105178 <sys_unlink+0x138>
8010516d:	8d 76 00             	lea    0x0(%esi),%esi
80105170:	83 c2 10             	add    $0x10,%edx
80105173:	39 53 58             	cmp    %edx,0x58(%ebx)
80105176:	76 82                	jbe    801050fa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105178:	6a 10                	push   $0x10
8010517a:	52                   	push   %edx
8010517b:	57                   	push   %edi
8010517c:	53                   	push   %ebx
8010517d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105180:	e8 db c8 ff ff       	call   80101a60 <readi>
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010518b:	83 f8 10             	cmp    $0x10,%eax
8010518e:	75 69                	jne    801051f9 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105190:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105195:	74 d9                	je     80105170 <sys_unlink+0x130>
    iunlockput(ip);
80105197:	83 ec 0c             	sub    $0xc,%esp
8010519a:	53                   	push   %ebx
8010519b:	e8 60 c8 ff ff       	call   80101a00 <iunlockput>
    goto bad;
801051a0:	83 c4 10             	add    $0x10,%esp
801051a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801051a7:	90                   	nop
  iunlockput(dp);
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	56                   	push   %esi
801051ac:	e8 4f c8 ff ff       	call   80101a00 <iunlockput>
  end_op();
801051b1:	e8 ea db ff ff       	call   80102da0 <end_op>
  return -1;
801051b6:	83 c4 10             	add    $0x10,%esp
801051b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051be:	eb 92                	jmp    80105152 <sys_unlink+0x112>
    iupdate(dp);
801051c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
801051c3:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
801051c8:	56                   	push   %esi
801051c9:	e8 d2 c4 ff ff       	call   801016a0 <iupdate>
801051ce:	83 c4 10             	add    $0x10,%esp
801051d1:	e9 54 ff ff ff       	jmp    8010512a <sys_unlink+0xea>
801051d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e5:	e9 68 ff ff ff       	jmp    80105152 <sys_unlink+0x112>
    end_op();
801051ea:	e8 b1 db ff ff       	call   80102da0 <end_op>
    return -1;
801051ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f4:	e9 59 ff ff ff       	jmp    80105152 <sys_unlink+0x112>
      panic("isdirempty: readi");
801051f9:	83 ec 0c             	sub    $0xc,%esp
801051fc:	68 0c 81 10 80       	push   $0x8010810c
80105201:	e8 8a b1 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105206:	83 ec 0c             	sub    $0xc,%esp
80105209:	68 1e 81 10 80       	push   $0x8010811e
8010520e:	e8 7d b1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105213:	83 ec 0c             	sub    $0xc,%esp
80105216:	68 fa 80 10 80       	push   $0x801080fa
8010521b:	e8 70 b1 ff ff       	call   80100390 <panic>

80105220 <sys_open>:

int
sys_open(void)
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
80105225:	89 e5                	mov    %esp,%ebp
80105227:	57                   	push   %edi
80105228:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105229:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010522c:	53                   	push   %ebx
8010522d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105230:	50                   	push   %eax
80105231:	6a 00                	push   $0x0
80105233:	e8 28 f8 ff ff       	call   80104a60 <argstr>
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	85 c0                	test   %eax,%eax
8010523d:	0f 88 8a 00 00 00    	js     801052cd <sys_open+0xad>
80105243:	83 ec 08             	sub    $0x8,%esp
80105246:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105249:	50                   	push   %eax
8010524a:	6a 01                	push   $0x1
8010524c:	e8 5f f7 ff ff       	call   801049b0 <argint>
80105251:	83 c4 10             	add    $0x10,%esp
80105254:	85 c0                	test   %eax,%eax
80105256:	78 75                	js     801052cd <sys_open+0xad>
    return -1;

  begin_op();
80105258:	e8 d3 da ff ff       	call   80102d30 <begin_op>

  if(omode & O_CREATE){
8010525d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105261:	75 75                	jne    801052d8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105263:	83 ec 0c             	sub    $0xc,%esp
80105266:	ff 75 e0             	pushl  -0x20(%ebp)
80105269:	e8 c2 cd ff ff       	call   80102030 <namei>
8010526e:	83 c4 10             	add    $0x10,%esp
80105271:	89 c6                	mov    %eax,%esi
80105273:	85 c0                	test   %eax,%eax
80105275:	74 7e                	je     801052f5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105277:	83 ec 0c             	sub    $0xc,%esp
8010527a:	50                   	push   %eax
8010527b:	e8 e0 c4 ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105280:	83 c4 10             	add    $0x10,%esp
80105283:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105288:	0f 84 c2 00 00 00    	je     80105350 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010528e:	e8 6d bb ff ff       	call   80100e00 <filealloc>
80105293:	89 c7                	mov    %eax,%edi
80105295:	85 c0                	test   %eax,%eax
80105297:	74 23                	je     801052bc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105299:	e8 e2 e6 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010529e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
801052a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801052a4:	85 d2                	test   %edx,%edx
801052a6:	74 60                	je     80105308 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
801052a8:	83 c3 01             	add    $0x1,%ebx
801052ab:	83 fb 10             	cmp    $0x10,%ebx
801052ae:	75 f0                	jne    801052a0 <sys_open+0x80>
    if(f)
      fileclose(f);
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	57                   	push   %edi
801052b4:	e8 07 bc ff ff       	call   80100ec0 <fileclose>
801052b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	56                   	push   %esi
801052c0:	e8 3b c7 ff ff       	call   80101a00 <iunlockput>
    end_op();
801052c5:	e8 d6 da ff ff       	call   80102da0 <end_op>
    return -1;
801052ca:	83 c4 10             	add    $0x10,%esp
801052cd:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052d2:	eb 6d                	jmp    80105341 <sys_open+0x121>
801052d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801052d8:	83 ec 0c             	sub    $0xc,%esp
801052db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801052de:	31 c9                	xor    %ecx,%ecx
801052e0:	ba 02 00 00 00       	mov    $0x2,%edx
801052e5:	6a 00                	push   $0x0
801052e7:	e8 24 f8 ff ff       	call   80104b10 <create>
    if(ip == 0){
801052ec:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801052ef:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801052f1:	85 c0                	test   %eax,%eax
801052f3:	75 99                	jne    8010528e <sys_open+0x6e>
      end_op();
801052f5:	e8 a6 da ff ff       	call   80102da0 <end_op>
      return -1;
801052fa:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801052ff:	eb 40                	jmp    80105341 <sys_open+0x121>
80105301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105308:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010530b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010530f:	56                   	push   %esi
80105310:	e8 2b c5 ff ff       	call   80101840 <iunlock>
  end_op();
80105315:	e8 86 da ff ff       	call   80102da0 <end_op>

  f->type = FD_INODE;
8010531a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105320:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105323:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105326:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105329:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010532b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105332:	f7 d0                	not    %eax
80105334:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105337:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010533a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010533d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105341:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105344:	89 d8                	mov    %ebx,%eax
80105346:	5b                   	pop    %ebx
80105347:	5e                   	pop    %esi
80105348:	5f                   	pop    %edi
80105349:	5d                   	pop    %ebp
8010534a:	c3                   	ret    
8010534b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010534f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105350:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105353:	85 c9                	test   %ecx,%ecx
80105355:	0f 84 33 ff ff ff    	je     8010528e <sys_open+0x6e>
8010535b:	e9 5c ff ff ff       	jmp    801052bc <sys_open+0x9c>

80105360 <sys_mkdir>:

int
sys_mkdir(void)
{
80105360:	f3 0f 1e fb          	endbr32 
80105364:	55                   	push   %ebp
80105365:	89 e5                	mov    %esp,%ebp
80105367:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010536a:	e8 c1 d9 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010536f:	83 ec 08             	sub    $0x8,%esp
80105372:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105375:	50                   	push   %eax
80105376:	6a 00                	push   $0x0
80105378:	e8 e3 f6 ff ff       	call   80104a60 <argstr>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	78 34                	js     801053b8 <sys_mkdir+0x58>
80105384:	83 ec 0c             	sub    $0xc,%esp
80105387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010538a:	31 c9                	xor    %ecx,%ecx
8010538c:	ba 01 00 00 00       	mov    $0x1,%edx
80105391:	6a 00                	push   $0x0
80105393:	e8 78 f7 ff ff       	call   80104b10 <create>
80105398:	83 c4 10             	add    $0x10,%esp
8010539b:	85 c0                	test   %eax,%eax
8010539d:	74 19                	je     801053b8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010539f:	83 ec 0c             	sub    $0xc,%esp
801053a2:	50                   	push   %eax
801053a3:	e8 58 c6 ff ff       	call   80101a00 <iunlockput>
  end_op();
801053a8:	e8 f3 d9 ff ff       	call   80102da0 <end_op>
  return 0;
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	31 c0                	xor    %eax,%eax
}
801053b2:	c9                   	leave  
801053b3:	c3                   	ret    
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801053b8:	e8 e3 d9 ff ff       	call   80102da0 <end_op>
    return -1;
801053bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c2:	c9                   	leave  
801053c3:	c3                   	ret    
801053c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053cf:	90                   	nop

801053d0 <sys_mknod>:

int
sys_mknod(void)
{
801053d0:	f3 0f 1e fb          	endbr32 
801053d4:	55                   	push   %ebp
801053d5:	89 e5                	mov    %esp,%ebp
801053d7:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801053da:	e8 51 d9 ff ff       	call   80102d30 <begin_op>
  if((argstr(0, &path)) < 0 ||
801053df:	83 ec 08             	sub    $0x8,%esp
801053e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801053e5:	50                   	push   %eax
801053e6:	6a 00                	push   $0x0
801053e8:	e8 73 f6 ff ff       	call   80104a60 <argstr>
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 64                	js     80105458 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
801053f4:	83 ec 08             	sub    $0x8,%esp
801053f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053fa:	50                   	push   %eax
801053fb:	6a 01                	push   $0x1
801053fd:	e8 ae f5 ff ff       	call   801049b0 <argint>
  if((argstr(0, &path)) < 0 ||
80105402:	83 c4 10             	add    $0x10,%esp
80105405:	85 c0                	test   %eax,%eax
80105407:	78 4f                	js     80105458 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105409:	83 ec 08             	sub    $0x8,%esp
8010540c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010540f:	50                   	push   %eax
80105410:	6a 02                	push   $0x2
80105412:	e8 99 f5 ff ff       	call   801049b0 <argint>
     argint(1, &major) < 0 ||
80105417:	83 c4 10             	add    $0x10,%esp
8010541a:	85 c0                	test   %eax,%eax
8010541c:	78 3a                	js     80105458 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010541e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105422:	83 ec 0c             	sub    $0xc,%esp
80105425:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105429:	ba 03 00 00 00       	mov    $0x3,%edx
8010542e:	50                   	push   %eax
8010542f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105432:	e8 d9 f6 ff ff       	call   80104b10 <create>
     argint(2, &minor) < 0 ||
80105437:	83 c4 10             	add    $0x10,%esp
8010543a:	85 c0                	test   %eax,%eax
8010543c:	74 1a                	je     80105458 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543e:	83 ec 0c             	sub    $0xc,%esp
80105441:	50                   	push   %eax
80105442:	e8 b9 c5 ff ff       	call   80101a00 <iunlockput>
  end_op();
80105447:	e8 54 d9 ff ff       	call   80102da0 <end_op>
  return 0;
8010544c:	83 c4 10             	add    $0x10,%esp
8010544f:	31 c0                	xor    %eax,%eax
}
80105451:	c9                   	leave  
80105452:	c3                   	ret    
80105453:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105457:	90                   	nop
    end_op();
80105458:	e8 43 d9 ff ff       	call   80102da0 <end_op>
    return -1;
8010545d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105462:	c9                   	leave  
80105463:	c3                   	ret    
80105464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010546b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010546f:	90                   	nop

80105470 <sys_chdir>:

int
sys_chdir(void)
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
80105475:	89 e5                	mov    %esp,%ebp
80105477:	56                   	push   %esi
80105478:	53                   	push   %ebx
80105479:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010547c:	e8 ff e4 ff ff       	call   80103980 <myproc>
80105481:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105483:	e8 a8 d8 ff ff       	call   80102d30 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105488:	83 ec 08             	sub    $0x8,%esp
8010548b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010548e:	50                   	push   %eax
8010548f:	6a 00                	push   $0x0
80105491:	e8 ca f5 ff ff       	call   80104a60 <argstr>
80105496:	83 c4 10             	add    $0x10,%esp
80105499:	85 c0                	test   %eax,%eax
8010549b:	78 73                	js     80105510 <sys_chdir+0xa0>
8010549d:	83 ec 0c             	sub    $0xc,%esp
801054a0:	ff 75 f4             	pushl  -0xc(%ebp)
801054a3:	e8 88 cb ff ff       	call   80102030 <namei>
801054a8:	83 c4 10             	add    $0x10,%esp
801054ab:	89 c3                	mov    %eax,%ebx
801054ad:	85 c0                	test   %eax,%eax
801054af:	74 5f                	je     80105510 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801054b1:	83 ec 0c             	sub    $0xc,%esp
801054b4:	50                   	push   %eax
801054b5:	e8 a6 c2 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
801054ba:	83 c4 10             	add    $0x10,%esp
801054bd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c2:	75 2c                	jne    801054f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	53                   	push   %ebx
801054c8:	e8 73 c3 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
801054cd:	58                   	pop    %eax
801054ce:	ff 76 68             	pushl  0x68(%esi)
801054d1:	e8 ba c3 ff ff       	call   80101890 <iput>
  end_op();
801054d6:	e8 c5 d8 ff ff       	call   80102da0 <end_op>
  curproc->cwd = ip;
801054db:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801054de:	83 c4 10             	add    $0x10,%esp
801054e1:	31 c0                	xor    %eax,%eax
}
801054e3:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054e6:	5b                   	pop    %ebx
801054e7:	5e                   	pop    %esi
801054e8:	5d                   	pop    %ebp
801054e9:	c3                   	ret    
801054ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
801054f0:	83 ec 0c             	sub    $0xc,%esp
801054f3:	53                   	push   %ebx
801054f4:	e8 07 c5 ff ff       	call   80101a00 <iunlockput>
    end_op();
801054f9:	e8 a2 d8 ff ff       	call   80102da0 <end_op>
    return -1;
801054fe:	83 c4 10             	add    $0x10,%esp
80105501:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105506:	eb db                	jmp    801054e3 <sys_chdir+0x73>
80105508:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
    end_op();
80105510:	e8 8b d8 ff ff       	call   80102da0 <end_op>
    return -1;
80105515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010551a:	eb c7                	jmp    801054e3 <sys_chdir+0x73>
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_exec>:

int
sys_exec(void)
{
80105520:	f3 0f 1e fb          	endbr32 
80105524:	55                   	push   %ebp
80105525:	89 e5                	mov    %esp,%ebp
80105527:	57                   	push   %edi
80105528:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105529:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010552f:	53                   	push   %ebx
80105530:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105536:	50                   	push   %eax
80105537:	6a 00                	push   $0x0
80105539:	e8 22 f5 ff ff       	call   80104a60 <argstr>
8010553e:	83 c4 10             	add    $0x10,%esp
80105541:	85 c0                	test   %eax,%eax
80105543:	0f 88 8b 00 00 00    	js     801055d4 <sys_exec+0xb4>
80105549:	83 ec 08             	sub    $0x8,%esp
8010554c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105552:	50                   	push   %eax
80105553:	6a 01                	push   $0x1
80105555:	e8 56 f4 ff ff       	call   801049b0 <argint>
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	85 c0                	test   %eax,%eax
8010555f:	78 73                	js     801055d4 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105561:	83 ec 04             	sub    $0x4,%esp
80105564:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010556a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010556c:	68 80 00 00 00       	push   $0x80
80105571:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105577:	6a 00                	push   $0x0
80105579:	50                   	push   %eax
8010557a:	e8 51 f1 ff ff       	call   801046d0 <memset>
8010557f:	83 c4 10             	add    $0x10,%esp
80105582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105588:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
8010558e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105595:	83 ec 08             	sub    $0x8,%esp
80105598:	57                   	push   %edi
80105599:	01 f0                	add    %esi,%eax
8010559b:	50                   	push   %eax
8010559c:	e8 6f f3 ff ff       	call   80104910 <fetchint>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 2c                	js     801055d4 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
801055a8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801055ae:	85 c0                	test   %eax,%eax
801055b0:	74 36                	je     801055e8 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801055b2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801055b8:	83 ec 08             	sub    $0x8,%esp
801055bb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801055be:	52                   	push   %edx
801055bf:	50                   	push   %eax
801055c0:	e8 8b f3 ff ff       	call   80104950 <fetchstr>
801055c5:	83 c4 10             	add    $0x10,%esp
801055c8:	85 c0                	test   %eax,%eax
801055ca:	78 08                	js     801055d4 <sys_exec+0xb4>
  for(i=0;; i++){
801055cc:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801055cf:	83 fb 20             	cmp    $0x20,%ebx
801055d2:	75 b4                	jne    80105588 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
801055d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801055d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055dc:	5b                   	pop    %ebx
801055dd:	5e                   	pop    %esi
801055de:	5f                   	pop    %edi
801055df:	5d                   	pop    %ebp
801055e0:	c3                   	ret    
801055e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
801055e8:	83 ec 08             	sub    $0x8,%esp
801055eb:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
801055f1:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801055f8:	00 00 00 00 
  return exec(path, argv);
801055fc:	50                   	push   %eax
801055fd:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105603:	e8 78 b4 ff ff       	call   80100a80 <exec>
80105608:	83 c4 10             	add    $0x10,%esp
}
8010560b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010560e:	5b                   	pop    %ebx
8010560f:	5e                   	pop    %esi
80105610:	5f                   	pop    %edi
80105611:	5d                   	pop    %ebp
80105612:	c3                   	ret    
80105613:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105620 <sys_pipe>:

int
sys_pipe(void)
{
80105620:	f3 0f 1e fb          	endbr32 
80105624:	55                   	push   %ebp
80105625:	89 e5                	mov    %esp,%ebp
80105627:	57                   	push   %edi
80105628:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105629:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010562c:	53                   	push   %ebx
8010562d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105630:	6a 08                	push   $0x8
80105632:	50                   	push   %eax
80105633:	6a 00                	push   $0x0
80105635:	e8 c6 f3 ff ff       	call   80104a00 <argptr>
8010563a:	83 c4 10             	add    $0x10,%esp
8010563d:	85 c0                	test   %eax,%eax
8010563f:	78 4e                	js     8010568f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105641:	83 ec 08             	sub    $0x8,%esp
80105644:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105647:	50                   	push   %eax
80105648:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010564b:	50                   	push   %eax
8010564c:	e8 9f dd ff ff       	call   801033f0 <pipealloc>
80105651:	83 c4 10             	add    $0x10,%esp
80105654:	85 c0                	test   %eax,%eax
80105656:	78 37                	js     8010568f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105658:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010565b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010565d:	e8 1e e3 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105662:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105668:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
8010566c:	85 f6                	test   %esi,%esi
8010566e:	74 30                	je     801056a0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105670:	83 c3 01             	add    $0x1,%ebx
80105673:	83 fb 10             	cmp    $0x10,%ebx
80105676:	75 f0                	jne    80105668 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	ff 75 e0             	pushl  -0x20(%ebp)
8010567e:	e8 3d b8 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
80105683:	58                   	pop    %eax
80105684:	ff 75 e4             	pushl  -0x1c(%ebp)
80105687:	e8 34 b8 ff ff       	call   80100ec0 <fileclose>
    return -1;
8010568c:	83 c4 10             	add    $0x10,%esp
8010568f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105694:	eb 5b                	jmp    801056f1 <sys_pipe+0xd1>
80105696:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010569d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801056a0:	8d 73 08             	lea    0x8(%ebx),%esi
801056a3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056aa:	e8 d1 e2 ff ff       	call   80103980 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056af:	31 d2                	xor    %edx,%edx
801056b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801056b8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801056bc:	85 c9                	test   %ecx,%ecx
801056be:	74 20                	je     801056e0 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
801056c0:	83 c2 01             	add    $0x1,%edx
801056c3:	83 fa 10             	cmp    $0x10,%edx
801056c6:	75 f0                	jne    801056b8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
801056c8:	e8 b3 e2 ff ff       	call   80103980 <myproc>
801056cd:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801056d4:	00 
801056d5:	eb a1                	jmp    80105678 <sys_pipe+0x58>
801056d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056de:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801056e0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
801056e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056e7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801056e9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801056ec:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801056ef:	31 c0                	xor    %eax,%eax
}
801056f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056f4:	5b                   	pop    %ebx
801056f5:	5e                   	pop    %esi
801056f6:	5f                   	pop    %edi
801056f7:	5d                   	pop    %ebp
801056f8:	c3                   	ret    
801056f9:	66 90                	xchg   %ax,%ax
801056fb:	66 90                	xchg   %ax,%ax
801056fd:	66 90                	xchg   %ax,%ax
801056ff:	90                   	nop

80105700 <sys_getticks>:
  struct proc proc[NPROC];
} ptable;

int
sys_getticks(void)
{
80105700:	f3 0f 1e fb          	endbr32 
    return ticks; // Return current ticks since boot
}
80105704:	a1 a0 7e 11 80       	mov    0x80117ea0,%eax
80105709:	c3                   	ret    
8010570a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105710 <sys_ps>:

int sys_ps(void) {
80105710:	f3 0f 1e fb          	endbr32 
80105714:	55                   	push   %ebp
80105715:	89 e5                	mov    %esp,%ebp
80105717:	53                   	push   %ebx
80105718:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
8010571d:	83 ec 10             	sub    $0x10,%esp
    struct proc *p;
    cprintf("Name\tpid\tstatus\tStart time\tend time\n");
80105720:	68 30 81 10 80       	push   $0x80108130
80105725:	e8 86 af ff ff       	call   801006b0 <cprintf>

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	8d 76 00             	lea    0x0(%esi),%esi
	cprintf("%s\t", p->name);
80105730:	83 ec 08             	sub    $0x8,%esp
80105733:	53                   	push   %ebx
80105734:	68 bd 81 10 80       	push   $0x801081bd
80105739:	e8 72 af ff ff       	call   801006b0 <cprintf>
        cprintf("%d\t", p->pid);
8010573e:	58                   	pop    %eax
8010573f:	5a                   	pop    %edx
80105740:	ff 73 a4             	pushl  -0x5c(%ebx)
80105743:	68 c1 81 10 80       	push   $0x801081c1
80105748:	e8 63 af ff ff       	call   801006b0 <cprintf>
        switch(p->state) {
8010574d:	83 c4 10             	add    $0x10,%esp
80105750:	83 7b a0 05          	cmpl   $0x5,-0x60(%ebx)
80105754:	77 2a                	ja     80105780 <sys_ps+0x70>
80105756:	8b 43 a0             	mov    -0x60(%ebx),%eax
80105759:	3e ff 24 85 04 82 10 	notrack jmp *-0x7fef7dfc(,%eax,4)
80105760:	80 
80105761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
            case UNUSED: cprintf("UNUSED"); break;
	    case EMBRYO: cprintf("EMBRYO"); break;
            case RUNNING: cprintf("RUNNING"); break;
80105768:	83 ec 0c             	sub    $0xc,%esp
8010576b:	68 d3 81 10 80       	push   $0x801081d3
80105770:	e8 3b af ff ff       	call   801006b0 <cprintf>
80105775:	83 c4 10             	add    $0x10,%esp
80105778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010577f:	90                   	nop
            case SLEEPING: cprintf("SLEEPING"); break;
            case RUNNABLE: cprintf("RUNNABLE"); break;
            case ZOMBIE: cprintf("ZOMBIE"); break;
        }
        cprintf("\t%d\t%d\n", p->start_time,p->end_time);
80105780:	83 ec 04             	sub    $0x4,%esp
80105783:	ff 73 14             	pushl  0x14(%ebx)
80105786:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
8010578c:	ff b3 38 ff ff ff    	pushl  -0xc8(%ebx)
80105792:	68 f4 81 10 80       	push   $0x801081f4
80105797:	e8 14 af ff ff       	call   801006b0 <cprintf>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010579c:	83 c4 10             	add    $0x10,%esp
8010579f:	81 fb c0 76 11 80    	cmp    $0x801176c0,%ebx
801057a5:	75 89                	jne    80105730 <sys_ps+0x20>
    }

    return 0;
}
801057a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057aa:	31 c0                	xor    %eax,%eax
801057ac:	c9                   	leave  
801057ad:	c3                   	ret    
801057ae:	66 90                	xchg   %ax,%ax
            case RUNNABLE: cprintf("RUNNABLE"); break;
801057b0:	83 ec 0c             	sub    $0xc,%esp
801057b3:	68 e4 81 10 80       	push   $0x801081e4
801057b8:	e8 f3 ae ff ff       	call   801006b0 <cprintf>
801057bd:	83 c4 10             	add    $0x10,%esp
801057c0:	eb be                	jmp    80105780 <sys_ps+0x70>
801057c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            case SLEEPING: cprintf("SLEEPING"); break;
801057c8:	83 ec 0c             	sub    $0xc,%esp
801057cb:	68 db 81 10 80       	push   $0x801081db
801057d0:	e8 db ae ff ff       	call   801006b0 <cprintf>
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	eb a6                	jmp    80105780 <sys_ps+0x70>
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
	    case EMBRYO: cprintf("EMBRYO"); break;
801057e0:	83 ec 0c             	sub    $0xc,%esp
801057e3:	68 cc 81 10 80       	push   $0x801081cc
801057e8:	e8 c3 ae ff ff       	call   801006b0 <cprintf>
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	eb 8e                	jmp    80105780 <sys_ps+0x70>
801057f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            case ZOMBIE: cprintf("ZOMBIE"); break;
801057f8:	83 ec 0c             	sub    $0xc,%esp
801057fb:	68 ed 81 10 80       	push   $0x801081ed
80105800:	e8 ab ae ff ff       	call   801006b0 <cprintf>
80105805:	83 c4 10             	add    $0x10,%esp
80105808:	e9 73 ff ff ff       	jmp    80105780 <sys_ps+0x70>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
            case UNUSED: cprintf("UNUSED"); break;
80105810:	83 ec 0c             	sub    $0xc,%esp
80105813:	68 c5 81 10 80       	push   $0x801081c5
80105818:	e8 93 ae ff ff       	call   801006b0 <cprintf>
8010581d:	83 c4 10             	add    $0x10,%esp
80105820:	e9 5b ff ff ff       	jmp    80105780 <sys_ps+0x70>
80105825:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105830 <sys_waitx>:


int sys_waitx(int* waittime, int* runtime)
{
80105830:	f3 0f 1e fb          	endbr32 
80105834:	55                   	push   %ebp
80105835:	89 e5                	mov    %esp,%ebp
80105837:	57                   	push   %edi
80105838:	56                   	push   %esi
    struct proc *p;
    int havekids, pid;

    // Use argptr to safely get arguments from user space
    if(argptr(0, (void*)&waittime, sizeof(waittime)) < 0)
80105839:	8d 45 08             	lea    0x8(%ebp),%eax
{
8010583c:	53                   	push   %ebx
8010583d:	83 ec 10             	sub    $0x10,%esp
    if(argptr(0, (void*)&waittime, sizeof(waittime)) < 0)
80105840:	6a 04                	push   $0x4
80105842:	50                   	push   %eax
80105843:	6a 00                	push   $0x0
80105845:	e8 b6 f1 ff ff       	call   80104a00 <argptr>
8010584a:	83 c4 10             	add    $0x10,%esp
8010584d:	85 c0                	test   %eax,%eax
8010584f:	0f 88 7b 01 00 00    	js     801059d0 <sys_waitx+0x1a0>
        return -1;

    if(argptr(1, (void*)&runtime, sizeof(runtime)) < 0)
80105855:	83 ec 04             	sub    $0x4,%esp
80105858:	8d 45 0c             	lea    0xc(%ebp),%eax
8010585b:	6a 04                	push   $0x4
8010585d:	50                   	push   %eax
8010585e:	6a 01                	push   $0x1
80105860:	e8 9b f1 ff ff       	call   80104a00 <argptr>
80105865:	83 c4 10             	add    $0x10,%esp
80105868:	85 c0                	test   %eax,%eax
8010586a:	0f 88 60 01 00 00    	js     801059d0 <sys_waitx+0x1a0>
        return -1;

    acquire(&ptable.lock);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	68 20 3d 11 80       	push   $0x80113d20
80105878:	e8 43 ed ff ff       	call   801045c0 <acquire>
8010587d:	83 c4 10             	add    $0x10,%esp
    for(;;) {
        havekids = 0;
80105880:	31 ff                	xor    %edi,%edi
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80105882:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80105887:	eb 15                	jmp    8010589e <sys_waitx+0x6e>
80105889:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105890:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
80105896:	81 fb 54 76 11 80    	cmp    $0x80117654,%ebx
8010589c:	74 25                	je     801058c3 <sys_waitx+0x93>
            if(p->parent != myproc())
8010589e:	8b 73 14             	mov    0x14(%ebx),%esi
801058a1:	e8 da e0 ff ff       	call   80103980 <myproc>
801058a6:	39 c6                	cmp    %eax,%esi
801058a8:	75 e6                	jne    80105890 <sys_waitx+0x60>
                continue;
            havekids = 1;
            if(p->state == ZOMBIE) {
801058aa:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801058ae:	74 48                	je     801058f8 <sys_waitx+0xc8>
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801058b0:	81 c3 e4 00 00 00    	add    $0xe4,%ebx
            havekids = 1;
801058b6:	bf 01 00 00 00       	mov    $0x1,%edi
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801058bb:	81 fb 54 76 11 80    	cmp    $0x80117654,%ebx
801058c1:	75 db                	jne    8010589e <sys_waitx+0x6e>
                release(&ptable.lock);
                return pid;
            }
        }

        if(!havekids || myproc()->killed) {
801058c3:	85 ff                	test   %edi,%edi
801058c5:	0f 84 ee 00 00 00    	je     801059b9 <sys_waitx+0x189>
801058cb:	e8 b0 e0 ff ff       	call   80103980 <myproc>
801058d0:	8b 40 24             	mov    0x24(%eax),%eax
801058d3:	85 c0                	test   %eax,%eax
801058d5:	0f 85 de 00 00 00    	jne    801059b9 <sys_waitx+0x189>
            release(&ptable.lock);
            return -1;
        }

        // Keep waiting
        sleep(myproc(), &ptable.lock);
801058db:	e8 a0 e0 ff ff       	call   80103980 <myproc>
801058e0:	83 ec 08             	sub    $0x8,%esp
801058e3:	68 20 3d 11 80       	push   $0x80113d20
801058e8:	50                   	push   %eax
801058e9:	e8 72 e6 ff ff       	call   80103f60 <sleep>
        havekids = 0;
801058ee:	83 c4 10             	add    $0x10,%esp
801058f1:	eb 8d                	jmp    80105880 <sys_waitx+0x50>
801058f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058f7:	90                   	nop
                *waittime = p->end_time - p->creation_time - p->total_time;
801058f8:	8b 55 08             	mov    0x8(%ebp),%edx
801058fb:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
                strncpy(p->last_3_unused[p->last_index].name, p->name, sizeof(p->name));
80105901:	83 ec 04             	sub    $0x4,%esp
                *waittime = p->end_time - p->creation_time - p->total_time;
80105904:	2b 43 7c             	sub    0x7c(%ebx),%eax
80105907:	2b 83 84 00 00 00    	sub    0x84(%ebx),%eax
                pid = p->pid;
8010590d:	8b 73 10             	mov    0x10(%ebx),%esi
                *waittime = p->end_time - p->creation_time - p->total_time;
80105910:	89 02                	mov    %eax,(%edx)
                *runtime = p->total_time;
80105912:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80105918:	8b 45 0c             	mov    0xc(%ebp),%eax
8010591b:	89 10                	mov    %edx,(%eax)
                p->last_3_unused[p->last_index].pid = p->pid;
8010591d:	6b 83 e0 00 00 00 1c 	imul   $0x1c,0xe0(%ebx),%eax
80105924:	8b 53 10             	mov    0x10(%ebx),%edx
                strncpy(p->last_3_unused[p->last_index].name, p->name, sizeof(p->name));
80105927:	6a 10                	push   $0x10
                p->last_3_unused[p->last_index].pid = p->pid;
80105929:	89 94 03 8c 00 00 00 	mov    %edx,0x8c(%ebx,%eax,1)
                strncpy(p->last_3_unused[p->last_index].name, p->name, sizeof(p->name));
80105930:	8d 53 6c             	lea    0x6c(%ebx),%edx
80105933:	8d 84 03 90 00 00 00 	lea    0x90(%ebx,%eax,1),%eax
8010593a:	52                   	push   %edx
8010593b:	50                   	push   %eax
8010593c:	e8 ef ee ff ff       	call   80104830 <strncpy>
                p->last_3_unused[p->last_index].start_time = p->start_time;
80105941:	8b 8b e0 00 00 00    	mov    0xe0(%ebx),%ecx
80105947:	8b 93 88 00 00 00    	mov    0x88(%ebx),%edx
8010594d:	6b c1 1c             	imul   $0x1c,%ecx,%eax
                p->last_index = (p->last_index + 1) % 3;  // Ensure it cycles between 0-2
80105950:	83 c1 01             	add    $0x1,%ecx
                p->last_3_unused[p->last_index].start_time = p->start_time;
80105953:	01 d8                	add    %ebx,%eax
80105955:	89 90 a0 00 00 00    	mov    %edx,0xa0(%eax)
                p->last_3_unused[p->last_index].total_time = p->total_time;
8010595b:	8b 93 84 00 00 00    	mov    0x84(%ebx),%edx
80105961:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
                p->last_index = (p->last_index + 1) % 3;  // Ensure it cycles between 0-2
80105967:	89 c8                	mov    %ecx,%eax
80105969:	ba 56 55 55 55       	mov    $0x55555556,%edx
8010596e:	f7 ea                	imul   %edx
80105970:	89 c8                	mov    %ecx,%eax
80105972:	c1 f8 1f             	sar    $0x1f,%eax
80105975:	29 c2                	sub    %eax,%edx
80105977:	8d 04 52             	lea    (%edx,%edx,2),%eax
                kfree(p->kstack);
8010597a:	5a                   	pop    %edx
8010597b:	ff 73 08             	pushl  0x8(%ebx)
                p->last_index = (p->last_index + 1) % 3;  // Ensure it cycles between 0-2
8010597e:	29 c1                	sub    %eax,%ecx
80105980:	89 8b e0 00 00 00    	mov    %ecx,0xe0(%ebx)
                kfree(p->kstack);
80105986:	e8 e5 ca ff ff       	call   80102470 <kfree>
                release(&ptable.lock);
8010598b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
                p->state = UNUSED;
80105992:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                p->parent = 0;
80105999:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->killed = 0;
801059a0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                release(&ptable.lock);
801059a7:	e8 d4 ec ff ff       	call   80104680 <release>
                return pid;
801059ac:	83 c4 10             	add    $0x10,%esp
    }
}
801059af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b2:	89 f0                	mov    %esi,%eax
801059b4:	5b                   	pop    %ebx
801059b5:	5e                   	pop    %esi
801059b6:	5f                   	pop    %edi
801059b7:	5d                   	pop    %ebp
801059b8:	c3                   	ret    
            release(&ptable.lock);
801059b9:	83 ec 0c             	sub    $0xc,%esp
            return -1;
801059bc:	be ff ff ff ff       	mov    $0xffffffff,%esi
            release(&ptable.lock);
801059c1:	68 20 3d 11 80       	push   $0x80113d20
801059c6:	e8 b5 ec ff ff       	call   80104680 <release>
            return -1;
801059cb:	83 c4 10             	add    $0x10,%esp
801059ce:	eb df                	jmp    801059af <sys_waitx+0x17f>
        return -1;
801059d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801059d5:	eb d8                	jmp    801059af <sys_waitx+0x17f>
801059d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059de:	66 90                	xchg   %ax,%ax

801059e0 <tolower_kernel>:



int tolower_kernel(int c) {
801059e0:	f3 0f 1e fb          	endbr32 
801059e4:	55                   	push   %ebp
801059e5:	89 e5                	mov    %esp,%ebp
801059e7:	8b 45 08             	mov    0x8(%ebp),%eax
    if (c >= 'A' && c <= 'Z') {
        return c + 'a' - 'A';
    }
    return c;
}
801059ea:	5d                   	pop    %ebp
    if (c >= 'A' && c <= 'Z') {
801059eb:	8d 48 bf             	lea    -0x41(%eax),%ecx
        return c + 'a' - 'A';
801059ee:	8d 50 20             	lea    0x20(%eax),%edx
801059f1:	83 f9 1a             	cmp    $0x1a,%ecx
801059f4:	0f 42 c2             	cmovb  %edx,%eax
}
801059f7:	c3                   	ret    
801059f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059ff:	90                   	nop

80105a00 <strcmp_kernel>:

int strcmp_kernel(const char *s1, const char *s2, int ignore_case) {
80105a00:	f3 0f 1e fb          	endbr32 
80105a04:	55                   	push   %ebp
80105a05:	89 e5                	mov    %esp,%ebp
80105a07:	57                   	push   %edi
80105a08:	8b 45 10             	mov    0x10(%ebp),%eax
80105a0b:	8b 7d 08             	mov    0x8(%ebp),%edi
80105a0e:	56                   	push   %esi
80105a0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105a12:	53                   	push   %ebx
80105a13:	0f b6 17             	movzbl (%edi),%edx
    if (ignore_case) {
80105a16:	85 c0                	test   %eax,%eax
80105a18:	0f 84 80 00 00 00    	je     80105a9e <strcmp_kernel+0x9e>
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105a1e:	84 d2                	test   %dl,%dl
80105a20:	0f 84 8a 00 00 00    	je     80105ab0 <strcmp_kernel+0xb0>
80105a26:	89 7d 08             	mov    %edi,0x8(%ebp)
80105a29:	eb 16                	jmp    80105a41 <strcmp_kernel+0x41>
80105a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a2f:	90                   	nop
            s1++;
80105a30:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105a34:	8b 45 08             	mov    0x8(%ebp),%eax
            s2++;
80105a37:	83 c1 01             	add    $0x1,%ecx
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105a3a:	0f b6 10             	movzbl (%eax),%edx
80105a3d:	84 d2                	test   %dl,%dl
80105a3f:	74 6f                	je     80105ab0 <strcmp_kernel+0xb0>
80105a41:	0f be c2             	movsbl %dl,%eax
    if (c >= 'A' && c <= 'Z') {
80105a44:	8d 70 bf             	lea    -0x41(%eax),%esi
        return c + 'a' - 'A';
80105a47:	8d 58 20             	lea    0x20(%eax),%ebx
80105a4a:	83 fe 1a             	cmp    $0x1a,%esi
80105a4d:	0f 42 c3             	cmovb  %ebx,%eax
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105a50:	0f be 19             	movsbl (%ecx),%ebx
    if (c >= 'A' && c <= 'Z') {
80105a53:	8d 73 bf             	lea    -0x41(%ebx),%esi
        return c + 'a' - 'A';
80105a56:	8d 7b 20             	lea    0x20(%ebx),%edi
80105a59:	83 fe 1a             	cmp    $0x1a,%esi
80105a5c:	0f 42 df             	cmovb  %edi,%ebx
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
80105a5f:	39 c3                	cmp    %eax,%ebx
80105a61:	74 cd                	je     80105a30 <strcmp_kernel+0x30>
        }
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105a63:	0f b6 c2             	movzbl %dl,%eax
    if (c >= 'A' && c <= 'Z') {
80105a66:	8d 58 bf             	lea    -0x41(%eax),%ebx
        return c + 'a' - 'A';
80105a69:	8d 50 20             	lea    0x20(%eax),%edx
80105a6c:	83 fb 1a             	cmp    $0x1a,%ebx
80105a6f:	0f 42 c2             	cmovb  %edx,%eax
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105a72:	0f b6 11             	movzbl (%ecx),%edx
    if (c >= 'A' && c <= 'Z') {
80105a75:	8d 5a bf             	lea    -0x41(%edx),%ebx
        return c + 'a' - 'A';
80105a78:	8d 4a 20             	lea    0x20(%edx),%ecx
80105a7b:	83 fb 1a             	cmp    $0x1a,%ebx
            s1++;
            s2++;
        }
        return *(const unsigned char *)s1 - *(const unsigned char *)s2;
    }
}
80105a7e:	5b                   	pop    %ebx
80105a7f:	5e                   	pop    %esi
        return c + 'a' - 'A';
80105a80:	0f 42 d1             	cmovb  %ecx,%edx
}
80105a83:	5f                   	pop    %edi
80105a84:	5d                   	pop    %ebp
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105a85:	29 d0                	sub    %edx,%eax
}
80105a87:	c3                   	ret    
80105a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8f:	90                   	nop
        while (*s1 && (*s1 == *s2)) {
80105a90:	3a 11                	cmp    (%ecx),%dl
80105a92:	75 24                	jne    80105ab8 <strcmp_kernel+0xb8>
80105a94:	0f b6 57 01          	movzbl 0x1(%edi),%edx
            s1++;
80105a98:	83 c7 01             	add    $0x1,%edi
            s2++;
80105a9b:	83 c1 01             	add    $0x1,%ecx
        while (*s1 && (*s1 == *s2)) {
80105a9e:	84 d2                	test   %dl,%dl
80105aa0:	75 ee                	jne    80105a90 <strcmp_kernel+0x90>
        return *(const unsigned char *)s1 - *(const unsigned char *)s2;
80105aa2:	0f b6 11             	movzbl (%ecx),%edx
}
80105aa5:	5b                   	pop    %ebx
80105aa6:	5e                   	pop    %esi
80105aa7:	5f                   	pop    %edi
        return *(const unsigned char *)s1 - *(const unsigned char *)s2;
80105aa8:	29 d0                	sub    %edx,%eax
}
80105aaa:	5d                   	pop    %ebp
80105aab:	c3                   	ret    
80105aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
80105ab0:	31 c0                	xor    %eax,%eax
80105ab2:	eb be                	jmp    80105a72 <strcmp_kernel+0x72>
80105ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ab8:	0f b6 c2             	movzbl %dl,%eax
80105abb:	eb e5                	jmp    80105aa2 <strcmp_kernel+0xa2>
80105abd:	8d 76 00             	lea    0x0(%esi),%esi

80105ac0 <atoi>:



int atoi(const char *s) {
80105ac0:	f3 0f 1e fb          	endbr32 
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	53                   	push   %ebx
80105ac8:	8b 55 08             	mov    0x8(%ebp),%edx
    int n = 0;
    while ('0' <= *s && *s <= '9') {
80105acb:	0f be 02             	movsbl (%edx),%eax
80105ace:	8d 48 d0             	lea    -0x30(%eax),%ecx
80105ad1:	80 f9 09             	cmp    $0x9,%cl
    int n = 0;
80105ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
    while ('0' <= *s && *s <= '9') {
80105ad9:	77 1a                	ja     80105af5 <atoi+0x35>
80105adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105adf:	90                   	nop
        n = n*10 + *s++ - '0';
80105ae0:	83 c2 01             	add    $0x1,%edx
80105ae3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
80105ae6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
    while ('0' <= *s && *s <= '9') {
80105aea:	0f be 02             	movsbl (%edx),%eax
80105aed:	8d 58 d0             	lea    -0x30(%eax),%ebx
80105af0:	80 fb 09             	cmp    $0x9,%bl
80105af3:	76 eb                	jbe    80105ae0 <atoi+0x20>
    }
    return n;
}
80105af5:	89 c8                	mov    %ecx,%eax
80105af7:	5b                   	pop    %ebx
80105af8:	5d                   	pop    %ebp
80105af9:	c3                   	ret    
80105afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105b00 <sys_head>:




int sys_head(void) {
80105b00:	f3 0f 1e fb          	endbr32 
80105b04:	55                   	push   %ebp
80105b05:	89 e5                	mov    %esp,%ebp
80105b07:	57                   	push   %edi
80105b08:	56                   	push   %esi
    int lines_to_show;
    struct inode *ip;
    char buf[BUFSIZE];
    int offset = 0, n, lines_printed = 0;

    if(argstr(0, &filename1) < 0)
80105b09:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
int sys_head(void) {
80105b0f:	53                   	push   %ebx
80105b10:	81 ec 44 02 00 00    	sub    $0x244,%esp
    if(argstr(0, &filename1) < 0)
80105b16:	50                   	push   %eax
80105b17:	6a 00                	push   $0x0
80105b19:	e8 42 ef ff ff       	call   80104a60 <argstr>
80105b1e:	83 c4 10             	add    $0x10,%esp
80105b21:	85 c0                	test   %eax,%eax
80105b23:	0f 88 7d 01 00 00    	js     80105ca6 <sys_head+0x1a6>
        return -1;

    if(argint(1, &lines_to_show) < 0)
80105b29:	83 ec 08             	sub    $0x8,%esp
80105b2c:	8d 85 e4 fd ff ff    	lea    -0x21c(%ebp),%eax
80105b32:	50                   	push   %eax
80105b33:	6a 01                	push   $0x1
80105b35:	e8 76 ee ff ff       	call   801049b0 <argint>
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	85 c0                	test   %eax,%eax
80105b3f:	79 0a                	jns    80105b4b <sys_head+0x4b>
        lines_to_show = 10;  // Default value if no second argument is provided
80105b41:	c7 85 e4 fd ff ff 0a 	movl   $0xa,-0x21c(%ebp)
80105b48:	00 00 00 

    // Fetch inode for filename1
    if((ip = namei(filename1)) == 0)
80105b4b:	83 ec 0c             	sub    $0xc,%esp
80105b4e:	ff b5 e0 fd ff ff    	pushl  -0x220(%ebp)
80105b54:	e8 d7 c4 ff ff       	call   80102030 <namei>
80105b59:	83 c4 10             	add    $0x10,%esp
80105b5c:	89 85 c4 fd ff ff    	mov    %eax,-0x23c(%ebp)
80105b62:	85 c0                	test   %eax,%eax
80105b64:	0f 84 3c 01 00 00    	je     80105ca6 <sys_head+0x1a6>
        return -1;

    ilock(ip);
80105b6a:	83 ec 0c             	sub    $0xc,%esp
    int offset = 0, n, lines_printed = 0;
80105b6d:	31 ff                	xor    %edi,%edi
80105b6f:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
    ilock(ip);
80105b75:	50                   	push   %eax
80105b76:	e8 e5 bb ff ff       	call   80101760 <ilock>

    cprintf("Head command is getting executed in kernel mode\n");
80105b7b:	c7 04 24 58 81 10 80 	movl   $0x80108158,(%esp)
80105b82:	e8 29 ab ff ff       	call   801006b0 <cprintf>

    int line_start = 0;
    while((n = readi(ip, buf, offset, sizeof(buf) - 1)) > 0 && lines_printed < lines_to_show) { // Added condition to stop once we've printed enough lines
80105b87:	83 c4 10             	add    $0x10,%esp
80105b8a:	89 fa                	mov    %edi,%edx
    int offset = 0, n, lines_printed = 0;
80105b8c:	c7 85 c8 fd ff ff 00 	movl   $0x0,-0x238(%ebp)
80105b93:	00 00 00 
80105b96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b9d:	8d 76 00             	lea    0x0(%esi),%esi
    while((n = readi(ip, buf, offset, sizeof(buf) - 1)) > 0 && lines_printed < lines_to_show) { // Added condition to stop once we've printed enough lines
80105ba0:	68 ff 01 00 00       	push   $0x1ff
80105ba5:	ff b5 c8 fd ff ff    	pushl  -0x238(%ebp)
80105bab:	56                   	push   %esi
80105bac:	ff b5 c4 fd ff ff    	pushl  -0x23c(%ebp)
80105bb2:	89 95 d4 fd ff ff    	mov    %edx,-0x22c(%ebp)
80105bb8:	e8 a3 be ff ff       	call   80101a60 <readi>
80105bbd:	83 c4 10             	add    $0x10,%esp
80105bc0:	89 c7                	mov    %eax,%edi
80105bc2:	85 c0                	test   %eax,%eax
80105bc4:	0f 8e c1 00 00 00    	jle    80105c8b <sys_head+0x18b>
80105bca:	8b 95 d4 fd ff ff    	mov    -0x22c(%ebp),%edx
80105bd0:	39 95 e4 fd ff ff    	cmp    %edx,-0x21c(%ebp)
80105bd6:	0f 8e af 00 00 00    	jle    80105c8b <sys_head+0x18b>
        buf[n] = '\0'; // Ensure null termination
80105bdc:	8d 47 ff             	lea    -0x1(%edi),%eax
80105bdf:	c6 84 3d e8 fd ff ff 	movb   $0x0,-0x218(%ebp,%edi,1)
80105be6:	00 
80105be7:	31 db                	xor    %ebx,%ebx
80105be9:	89 85 d0 fd ff ff    	mov    %eax,-0x230(%ebp)
80105bef:	31 c0                	xor    %eax,%eax
80105bf1:	89 bd d4 fd ff ff    	mov    %edi,-0x22c(%ebp)
80105bf7:	89 d7                	mov    %edx,%edi
80105bf9:	eb 10                	jmp    80105c0b <sys_head+0x10b>
80105bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bff:	90                   	nop
80105c00:	83 c3 01             	add    $0x1,%ebx
        
        for(int i = 0; i < n; i++) {
80105c03:	3b 9d d4 fd ff ff    	cmp    -0x22c(%ebp),%ebx
80105c09:	7d 4a                	jge    80105c55 <sys_head+0x155>
            if(buf[i] == '\n' || i == n-1) {
80105c0b:	80 3c 1e 0a          	cmpb   $0xa,(%esi,%ebx,1)
80105c0f:	74 08                	je     80105c19 <sys_head+0x119>
80105c11:	39 9d d0 fd ff ff    	cmp    %ebx,-0x230(%ebp)
80105c17:	75 e7                	jne    80105c00 <sys_head+0x100>
                buf[i] = '\0'; // Null-terminate the line
                
                cprintf("%s\n", buf + line_start);
80105c19:	83 ec 08             	sub    $0x8,%esp
80105c1c:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
                buf[i] = '\0'; // Null-terminate the line
80105c1f:	c6 04 1e 00          	movb   $0x0,(%esi,%ebx,1)
                lines_printed++;
80105c23:	83 c7 01             	add    $0x1,%edi
                cprintf("%s\n", buf + line_start);
80105c26:	51                   	push   %ecx
80105c27:	68 ff 81 10 80       	push   $0x801081ff
80105c2c:	89 85 cc fd ff ff    	mov    %eax,-0x234(%ebp)
80105c32:	e8 79 aa ff ff       	call   801006b0 <cprintf>

                if (lines_printed >= lines_to_show) {
80105c37:	83 c4 10             	add    $0x10,%esp
80105c3a:	39 bd e4 fd ff ff    	cmp    %edi,-0x21c(%ebp)
80105c40:	8b 85 cc fd ff ff    	mov    -0x234(%ebp),%eax
80105c46:	7e 0d                	jle    80105c55 <sys_head+0x155>
                    break;  // Exit if we've printed enough lines
                }
                
                line_start = i + 1;  // Mark the start of the next line
80105c48:	83 c3 01             	add    $0x1,%ebx
80105c4b:	89 d8                	mov    %ebx,%eax
        for(int i = 0; i < n; i++) {
80105c4d:	3b 9d d4 fd ff ff    	cmp    -0x22c(%ebp),%ebx
80105c53:	7c b6                	jl     80105c0b <sys_head+0x10b>
            }
        }

        // If buffer doesn't end with a newline, adjust offset
        if (buf[n-1] != '\n') {
80105c55:	8b 8d d0 fd ff ff    	mov    -0x230(%ebp),%ecx
80105c5b:	89 fa                	mov    %edi,%edx
80105c5d:	8b bd d4 fd ff ff    	mov    -0x22c(%ebp),%edi
80105c63:	80 bc 0d e8 fd ff ff 	cmpb   $0xa,-0x218(%ebp,%ecx,1)
80105c6a:	0a 
80105c6b:	74 13                	je     80105c80 <sys_head+0x180>
            offset -= (n - line_start);
80105c6d:	29 c7                	sub    %eax,%edi
80105c6f:	29 bd c8 fd ff ff    	sub    %edi,-0x238(%ebp)
80105c75:	e9 26 ff ff ff       	jmp    80105ba0 <sys_head+0xa0>
80105c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        } else {
            offset += n;
80105c80:	01 bd c8 fd ff ff    	add    %edi,-0x238(%ebp)
80105c86:	e9 15 ff ff ff       	jmp    80105ba0 <sys_head+0xa0>
        }
        line_start = 0; // Reset line start for the next buffer read
    }

    iunlockput(ip);
80105c8b:	83 ec 0c             	sub    $0xc,%esp
80105c8e:	ff b5 c4 fd ff ff    	pushl  -0x23c(%ebp)
80105c94:	e8 67 bd ff ff       	call   80101a00 <iunlockput>

    return 0;
80105c99:	83 c4 10             	add    $0x10,%esp
80105c9c:	31 c0                	xor    %eax,%eax
}
80105c9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ca1:	5b                   	pop    %ebx
80105ca2:	5e                   	pop    %esi
80105ca3:	5f                   	pop    %edi
80105ca4:	5d                   	pop    %ebp
80105ca5:	c3                   	ret    
        return -1;
80105ca6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cab:	eb f1                	jmp    80105c9e <sys_head+0x19e>
80105cad:	8d 76 00             	lea    0x0(%esi),%esi

80105cb0 <sys_uniq>:


int sys_uniq(void) {
80105cb0:	f3 0f 1e fb          	endbr32 
80105cb4:	55                   	push   %ebp
    char *filename1;
    struct inode *ip;
    char buf[BUFSIZE];
    char prev_line[BUFSIZE] = {0};
80105cb5:	31 c0                	xor    %eax,%eax
80105cb7:	b9 7f 00 00 00       	mov    $0x7f,%ecx
int sys_uniq(void) {
80105cbc:	89 e5                	mov    %esp,%ebp
80105cbe:	57                   	push   %edi
80105cbf:	56                   	push   %esi
    char prev_line[BUFSIZE] = {0};
80105cc0:	8d bd ec fd ff ff    	lea    -0x214(%ebp),%edi
int sys_uniq(void) {
80105cc6:	53                   	push   %ebx
80105cc7:	81 ec 34 04 00 00    	sub    $0x434,%esp
    char prev_line[BUFSIZE] = {0};
80105ccd:	c7 85 e8 fd ff ff 00 	movl   $0x0,-0x218(%ebp)
80105cd4:	00 00 00 
80105cd7:	f3 ab                	rep stos %eax,%es:(%edi)
    int offset = 0, n;
    int ignore_case = 0, show_count = 0, show_only_duplicated = 0;
    int count = 0;

    // Fetching the flags first (assuming flags are passed as additional arguments to sys_uniq)
    if (argint(0, &ignore_case) < 0 || argint(1, &show_count) < 0 || argint(2, &show_only_duplicated) < 0)
80105cd9:	8d 85 dc fb ff ff    	lea    -0x424(%ebp),%eax
    int ignore_case = 0, show_count = 0, show_only_duplicated = 0;
80105cdf:	c7 85 dc fb ff ff 00 	movl   $0x0,-0x424(%ebp)
80105ce6:	00 00 00 
    if (argint(0, &ignore_case) < 0 || argint(1, &show_count) < 0 || argint(2, &show_only_duplicated) < 0)
80105ce9:	50                   	push   %eax
80105cea:	6a 00                	push   $0x0
    int ignore_case = 0, show_count = 0, show_only_duplicated = 0;
80105cec:	c7 85 e0 fb ff ff 00 	movl   $0x0,-0x420(%ebp)
80105cf3:	00 00 00 
80105cf6:	c7 85 e4 fb ff ff 00 	movl   $0x0,-0x41c(%ebp)
80105cfd:	00 00 00 
    if (argint(0, &ignore_case) < 0 || argint(1, &show_count) < 0 || argint(2, &show_only_duplicated) < 0)
80105d00:	e8 ab ec ff ff       	call   801049b0 <argint>
80105d05:	83 c4 10             	add    $0x10,%esp
80105d08:	85 c0                	test   %eax,%eax
80105d0a:	0f 88 34 02 00 00    	js     80105f44 <sys_uniq+0x294>
80105d10:	83 ec 08             	sub    $0x8,%esp
80105d13:	8d 85 e0 fb ff ff    	lea    -0x420(%ebp),%eax
80105d19:	50                   	push   %eax
80105d1a:	6a 01                	push   $0x1
80105d1c:	e8 8f ec ff ff       	call   801049b0 <argint>
80105d21:	83 c4 10             	add    $0x10,%esp
80105d24:	85 c0                	test   %eax,%eax
80105d26:	0f 88 18 02 00 00    	js     80105f44 <sys_uniq+0x294>
80105d2c:	83 ec 08             	sub    $0x8,%esp
80105d2f:	8d 85 e4 fb ff ff    	lea    -0x41c(%ebp),%eax
80105d35:	50                   	push   %eax
80105d36:	6a 02                	push   $0x2
80105d38:	e8 73 ec ff ff       	call   801049b0 <argint>
80105d3d:	83 c4 10             	add    $0x10,%esp
80105d40:	85 c0                	test   %eax,%eax
80105d42:	0f 88 fc 01 00 00    	js     80105f44 <sys_uniq+0x294>
        return -1;

    // Fetch filename after flags
    if(argstr(3, &filename1) < 0)
80105d48:	83 ec 08             	sub    $0x8,%esp
80105d4b:	8d 85 d8 fb ff ff    	lea    -0x428(%ebp),%eax
80105d51:	50                   	push   %eax
80105d52:	6a 03                	push   $0x3
80105d54:	e8 07 ed ff ff       	call   80104a60 <argstr>
80105d59:	83 c4 10             	add    $0x10,%esp
80105d5c:	85 c0                	test   %eax,%eax
80105d5e:	0f 88 e0 01 00 00    	js     80105f44 <sys_uniq+0x294>
        return -1;

    // Fetch inode for filename1
    if((ip = namei(filename1)) == 0)
80105d64:	83 ec 0c             	sub    $0xc,%esp
80105d67:	ff b5 d8 fb ff ff    	pushl  -0x428(%ebp)
80105d6d:	e8 be c2 ff ff       	call   80102030 <namei>
80105d72:	83 c4 10             	add    $0x10,%esp
80105d75:	89 85 cc fb ff ff    	mov    %eax,-0x434(%ebp)
80105d7b:	85 c0                	test   %eax,%eax
80105d7d:	0f 84 c1 01 00 00    	je     80105f44 <sys_uniq+0x294>
        return -1;

    ilock(ip);
80105d83:	83 ec 0c             	sub    $0xc,%esp
80105d86:	50                   	push   %eax
80105d87:	e8 d4 b9 ff ff       	call   80101760 <ilock>

    cprintf("Uniq command is getting executed in kernel mode\n");
80105d8c:	c7 04 24 8c 81 10 80 	movl   $0x8010818c,(%esp)
80105d93:	e8 18 a9 ff ff       	call   801006b0 <cprintf>

    while((n = readi(ip, buf, offset, sizeof(buf))) > 0) {
80105d98:	83 c4 10             	add    $0x10,%esp
    int count = 0;
80105d9b:	c7 85 d4 fb ff ff 00 	movl   $0x0,-0x42c(%ebp)
80105da2:	00 00 00 
    int offset = 0, n;
80105da5:	c7 85 d0 fb ff ff 00 	movl   $0x0,-0x430(%ebp)
80105dac:	00 00 00 
80105daf:	90                   	nop
    while((n = readi(ip, buf, offset, sizeof(buf))) > 0) {
80105db0:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
80105db6:	68 00 02 00 00       	push   $0x200
80105dbb:	ff b5 d0 fb ff ff    	pushl  -0x430(%ebp)
80105dc1:	50                   	push   %eax
80105dc2:	ff b5 cc fb ff ff    	pushl  -0x434(%ebp)
80105dc8:	e8 93 bc ff ff       	call   80101a60 <readi>
80105dcd:	83 c4 10             	add    $0x10,%esp
80105dd0:	89 c7                	mov    %eax,%edi
80105dd2:	85 c0                	test   %eax,%eax
80105dd4:	0f 8e f6 00 00 00    	jle    80105ed0 <sys_uniq+0x220>
        int line_start = 0;
        for(int i = 0; i < n; i++) {
80105dda:	31 db                	xor    %ebx,%ebx
        int line_start = 0;
80105ddc:	31 f6                	xor    %esi,%esi
80105dde:	eb 04                	jmp    80105de4 <sys_uniq+0x134>
        for(int i = 0; i < n; i++) {
80105de0:	39 fb                	cmp    %edi,%ebx
80105de2:	74 52                	je     80105e36 <sys_uniq+0x186>
            if(buf[i] == '\n' || i == n-1) {
80105de4:	0f b6 84 1d e8 fb ff 	movzbl -0x418(%ebp,%ebx,1),%eax
80105deb:	ff 
80105dec:	89 d9                	mov    %ebx,%ecx
80105dee:	83 c3 01             	add    $0x1,%ebx
80105df1:	3c 0a                	cmp    $0xa,%al
80105df3:	74 07                	je     80105dfc <sys_uniq+0x14c>
80105df5:	8d 47 ff             	lea    -0x1(%edi),%eax
80105df8:	39 c8                	cmp    %ecx,%eax
80105dfa:	75 e4                	jne    80105de0 <sys_uniq+0x130>
                buf[i] = '\0';

                if(strcmp_kernel(buf + line_start, prev_line, ignore_case) == 0) {
80105dfc:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
80105e02:	83 ec 04             	sub    $0x4,%esp
80105e05:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
80105e0b:	01 c6                	add    %eax,%esi
80105e0d:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
                buf[i] = '\0';
80105e13:	c6 84 1d e7 fb ff ff 	movb   $0x0,-0x419(%ebp,%ebx,1)
80105e1a:	00 
                if(strcmp_kernel(buf + line_start, prev_line, ignore_case) == 0) {
80105e1b:	50                   	push   %eax
80105e1c:	56                   	push   %esi
80105e1d:	e8 de fb ff ff       	call   80105a00 <strcmp_kernel>
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	85 c0                	test   %eax,%eax
80105e27:	75 1f                	jne    80105e48 <sys_uniq+0x198>
                    count++;
80105e29:	83 85 d4 fb ff ff 01 	addl   $0x1,-0x42c(%ebp)
                        } else {
                            cprintf("%s\n", prev_line);
                        }
                    }
                    safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
                    count = 1;
80105e30:	89 de                	mov    %ebx,%esi
        for(int i = 0; i < n; i++) {
80105e32:	39 fb                	cmp    %edi,%ebx
80105e34:	75 ae                	jne    80105de4 <sys_uniq+0x134>
                }
                line_start = i + 1;  // mark the start of the next line
            }
        }
        offset += n;
80105e36:	01 9d d0 fb ff ff    	add    %ebx,-0x430(%ebp)
80105e3c:	e9 6f ff ff ff       	jmp    80105db0 <sys_uniq+0x100>
80105e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
80105e48:	8b 85 d4 fb ff ff    	mov    -0x42c(%ebp),%eax
80105e4e:	85 c0                	test   %eax,%eax
80105e50:	74 36                	je     80105e88 <sys_uniq+0x1d8>
80105e52:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
80105e58:	85 d2                	test   %edx,%edx
80105e5a:	74 05                	je     80105e61 <sys_uniq+0x1b1>
80105e5c:	83 f8 01             	cmp    $0x1,%eax
80105e5f:	74 27                	je     80105e88 <sys_uniq+0x1d8>
                        if (show_count) {
80105e61:	8b 8d e0 fb ff ff    	mov    -0x420(%ebp),%ecx
80105e67:	85 c9                	test   %ecx,%ecx
80105e69:	74 45                	je     80105eb0 <sys_uniq+0x200>
                            cprintf("%d %s\n", count, prev_line);
80105e6b:	83 ec 04             	sub    $0x4,%esp
80105e6e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80105e74:	50                   	push   %eax
80105e75:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80105e7b:	68 fc 81 10 80       	push   $0x801081fc
80105e80:	e8 2b a8 ff ff       	call   801006b0 <cprintf>
80105e85:	83 c4 10             	add    $0x10,%esp
                    safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
80105e88:	83 ec 04             	sub    $0x4,%esp
80105e8b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80105e91:	68 00 02 00 00       	push   $0x200
80105e96:	56                   	push   %esi
                    count = 1;
80105e97:	89 de                	mov    %ebx,%esi
                    safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
80105e99:	50                   	push   %eax
80105e9a:	e8 f1 e9 ff ff       	call   80104890 <safestrcpy>
80105e9f:	83 c4 10             	add    $0x10,%esp
                    count = 1;
80105ea2:	c7 85 d4 fb ff ff 01 	movl   $0x1,-0x42c(%ebp)
80105ea9:	00 00 00 
                line_start = i + 1;  // mark the start of the next line
80105eac:	eb 84                	jmp    80105e32 <sys_uniq+0x182>
80105eae:	66 90                	xchg   %ax,%ax
                            cprintf("%s\n", prev_line);
80105eb0:	83 ec 08             	sub    $0x8,%esp
80105eb3:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	68 ff 81 10 80       	push   $0x801081ff
80105ebf:	e8 ec a7 ff ff       	call   801006b0 <cprintf>
80105ec4:	83 c4 10             	add    $0x10,%esp
80105ec7:	eb bf                	jmp    80105e88 <sys_uniq+0x1d8>
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }

    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
80105ed0:	8b 85 d4 fb ff ff    	mov    -0x42c(%ebp),%eax
80105ed6:	85 c0                	test   %eax,%eax
80105ed8:	74 36                	je     80105f10 <sys_uniq+0x260>
80105eda:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
80105ee0:	85 d2                	test   %edx,%edx
80105ee2:	74 05                	je     80105ee9 <sys_uniq+0x239>
80105ee4:	83 f8 01             	cmp    $0x1,%eax
80105ee7:	74 27                	je     80105f10 <sys_uniq+0x260>
        if (show_count) {
80105ee9:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
80105eef:	85 c0                	test   %eax,%eax
80105ef1:	74 38                	je     80105f2b <sys_uniq+0x27b>
            cprintf("%d %s\n", count, prev_line);
80105ef3:	83 ec 04             	sub    $0x4,%esp
80105ef6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80105efc:	50                   	push   %eax
80105efd:	ff b5 d4 fb ff ff    	pushl  -0x42c(%ebp)
80105f03:	68 fc 81 10 80       	push   $0x801081fc
80105f08:	e8 a3 a7 ff ff       	call   801006b0 <cprintf>
80105f0d:	83 c4 10             	add    $0x10,%esp
        } else {
            cprintf("%s\n", prev_line);
        }
    }

    iunlockput(ip);
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	ff b5 cc fb ff ff    	pushl  -0x434(%ebp)
80105f19:	e8 e2 ba ff ff       	call   80101a00 <iunlockput>

    return 0;
80105f1e:	83 c4 10             	add    $0x10,%esp
80105f21:	31 c0                	xor    %eax,%eax
}
80105f23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f26:	5b                   	pop    %ebx
80105f27:	5e                   	pop    %esi
80105f28:	5f                   	pop    %edi
80105f29:	5d                   	pop    %ebp
80105f2a:	c3                   	ret    
            cprintf("%s\n", prev_line);
80105f2b:	83 ec 08             	sub    $0x8,%esp
80105f2e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
80105f34:	50                   	push   %eax
80105f35:	68 ff 81 10 80       	push   $0x801081ff
80105f3a:	e8 71 a7 ff ff       	call   801006b0 <cprintf>
80105f3f:	83 c4 10             	add    $0x10,%esp
80105f42:	eb cc                	jmp    80105f10 <sys_uniq+0x260>
        return -1;
80105f44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f49:	eb d8                	jmp    80105f23 <sys_uniq+0x273>
80105f4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop

80105f50 <sys_fork>:



int
sys_fork(void)
{
80105f50:	f3 0f 1e fb          	endbr32 
  return fork();
80105f54:	e9 d7 db ff ff       	jmp    80103b30 <fork>
80105f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_exit>:
}

int
sys_exit(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	83 ec 08             	sub    $0x8,%esp
  exit();
80105f6a:	e8 41 de ff ff       	call   80103db0 <exit>
  return 0;  // not reached
}
80105f6f:	31 c0                	xor    %eax,%eax
80105f71:	c9                   	leave  
80105f72:	c3                   	ret    
80105f73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105f80 <sys_wait>:

int
sys_wait(void)
{
80105f80:	f3 0f 1e fb          	endbr32 
  return wait();
80105f84:	e9 97 e0 ff ff       	jmp    80104020 <wait>
80105f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f90 <sys_kill>:
}

int
sys_kill(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
80105f94:	55                   	push   %ebp
80105f95:	89 e5                	mov    %esp,%ebp
80105f97:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105f9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f9d:	50                   	push   %eax
80105f9e:	6a 00                	push   $0x0
80105fa0:	e8 0b ea ff ff       	call   801049b0 <argint>
80105fa5:	83 c4 10             	add    $0x10,%esp
80105fa8:	85 c0                	test   %eax,%eax
80105faa:	78 14                	js     80105fc0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fac:	83 ec 0c             	sub    $0xc,%esp
80105faf:	ff 75 f4             	pushl  -0xc(%ebp)
80105fb2:	e8 d9 e1 ff ff       	call   80104190 <kill>
80105fb7:	83 c4 10             	add    $0x10,%esp
}
80105fba:	c9                   	leave  
80105fbb:	c3                   	ret    
80105fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fc0:	c9                   	leave  
    return -1;
80105fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fc6:	c3                   	ret    
80105fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fce:	66 90                	xchg   %ax,%ax

80105fd0 <sys_getpid>:

int
sys_getpid(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105fda:	e8 a1 d9 ff ff       	call   80103980 <myproc>
80105fdf:	8b 40 10             	mov    0x10(%eax),%eax
}
80105fe2:	c9                   	leave  
80105fe3:	c3                   	ret    
80105fe4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105feb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105fef:	90                   	nop

80105ff0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ff0:	f3 0f 1e fb          	endbr32 
80105ff4:	55                   	push   %ebp
80105ff5:	89 e5                	mov    %esp,%ebp
80105ff7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ff8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ffb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105ffe:	50                   	push   %eax
80105fff:	6a 00                	push   $0x0
80106001:	e8 aa e9 ff ff       	call   801049b0 <argint>
80106006:	83 c4 10             	add    $0x10,%esp
80106009:	85 c0                	test   %eax,%eax
8010600b:	78 23                	js     80106030 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010600d:	e8 6e d9 ff ff       	call   80103980 <myproc>
  if(growproc(n) < 0)
80106012:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106015:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106017:	ff 75 f4             	pushl  -0xc(%ebp)
8010601a:	e8 91 da ff ff       	call   80103ab0 <growproc>
8010601f:	83 c4 10             	add    $0x10,%esp
80106022:	85 c0                	test   %eax,%eax
80106024:	78 0a                	js     80106030 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106026:	89 d8                	mov    %ebx,%eax
80106028:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010602b:	c9                   	leave  
8010602c:	c3                   	ret    
8010602d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106030:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106035:	eb ef                	jmp    80106026 <sys_sbrk+0x36>
80106037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010603e:	66 90                	xchg   %ax,%ax

80106040 <sys_sleep>:

int
sys_sleep(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106048:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010604b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010604e:	50                   	push   %eax
8010604f:	6a 00                	push   $0x0
80106051:	e8 5a e9 ff ff       	call   801049b0 <argint>
80106056:	83 c4 10             	add    $0x10,%esp
80106059:	85 c0                	test   %eax,%eax
8010605b:	0f 88 86 00 00 00    	js     801060e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106061:	83 ec 0c             	sub    $0xc,%esp
80106064:	68 60 76 11 80       	push   $0x80117660
80106069:	e8 52 e5 ff ff       	call   801045c0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010606e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106071:	8b 1d a0 7e 11 80    	mov    0x80117ea0,%ebx
  while(ticks - ticks0 < n){
80106077:	83 c4 10             	add    $0x10,%esp
8010607a:	85 d2                	test   %edx,%edx
8010607c:	75 23                	jne    801060a1 <sys_sleep+0x61>
8010607e:	eb 50                	jmp    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106080:	83 ec 08             	sub    $0x8,%esp
80106083:	68 60 76 11 80       	push   $0x80117660
80106088:	68 a0 7e 11 80       	push   $0x80117ea0
8010608d:	e8 ce de ff ff       	call   80103f60 <sleep>
  while(ticks - ticks0 < n){
80106092:	a1 a0 7e 11 80       	mov    0x80117ea0,%eax
80106097:	83 c4 10             	add    $0x10,%esp
8010609a:	29 d8                	sub    %ebx,%eax
8010609c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010609f:	73 2f                	jae    801060d0 <sys_sleep+0x90>
    if(myproc()->killed){
801060a1:	e8 da d8 ff ff       	call   80103980 <myproc>
801060a6:	8b 40 24             	mov    0x24(%eax),%eax
801060a9:	85 c0                	test   %eax,%eax
801060ab:	74 d3                	je     80106080 <sys_sleep+0x40>
      release(&tickslock);
801060ad:	83 ec 0c             	sub    $0xc,%esp
801060b0:	68 60 76 11 80       	push   $0x80117660
801060b5:	e8 c6 e5 ff ff       	call   80104680 <release>
  }
  release(&tickslock);
  return 0;
}
801060ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060bd:	83 c4 10             	add    $0x10,%esp
801060c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060c5:	c9                   	leave  
801060c6:	c3                   	ret    
801060c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ce:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 60 76 11 80       	push   $0x80117660
801060d8:	e8 a3 e5 ff ff       	call   80104680 <release>
  return 0;
801060dd:	83 c4 10             	add    $0x10,%esp
801060e0:	31 c0                	xor    %eax,%eax
}
801060e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801060e5:	c9                   	leave  
801060e6:	c3                   	ret    
    return -1;
801060e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060ec:	eb f4                	jmp    801060e2 <sys_sleep+0xa2>
801060ee:	66 90                	xchg   %ax,%ax

801060f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801060f0:	f3 0f 1e fb          	endbr32 
801060f4:	55                   	push   %ebp
801060f5:	89 e5                	mov    %esp,%ebp
801060f7:	53                   	push   %ebx
801060f8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801060fb:	68 60 76 11 80       	push   $0x80117660
80106100:	e8 bb e4 ff ff       	call   801045c0 <acquire>
  xticks = ticks;
80106105:	8b 1d a0 7e 11 80    	mov    0x80117ea0,%ebx
  release(&tickslock);
8010610b:	c7 04 24 60 76 11 80 	movl   $0x80117660,(%esp)
80106112:	e8 69 e5 ff ff       	call   80104680 <release>
  return xticks;
}
80106117:	89 d8                	mov    %ebx,%eax
80106119:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010611c:	c9                   	leave  
8010611d:	c3                   	ret    

8010611e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010611e:	1e                   	push   %ds
  pushl %es
8010611f:	06                   	push   %es
  pushl %fs
80106120:	0f a0                	push   %fs
  pushl %gs
80106122:	0f a8                	push   %gs
  pushal
80106124:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106125:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106129:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010612b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010612d:	54                   	push   %esp
  call trap
8010612e:	e8 cd 00 00 00       	call   80106200 <trap>
  addl $4, %esp
80106133:	83 c4 04             	add    $0x4,%esp

80106136 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106136:	61                   	popa   
  popl %gs
80106137:	0f a9                	pop    %gs
  popl %fs
80106139:	0f a1                	pop    %fs
  popl %es
8010613b:	07                   	pop    %es
  popl %ds
8010613c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010613d:	83 c4 08             	add    $0x8,%esp
  iret
80106140:	cf                   	iret   
80106141:	66 90                	xchg   %ax,%ax
80106143:	66 90                	xchg   %ax,%ax
80106145:	66 90                	xchg   %ax,%ax
80106147:	66 90                	xchg   %ax,%ax
80106149:	66 90                	xchg   %ax,%ax
8010614b:	66 90                	xchg   %ax,%ax
8010614d:	66 90                	xchg   %ax,%ax
8010614f:	90                   	nop

80106150 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106150:	f3 0f 1e fb          	endbr32 
80106154:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106155:	31 c0                	xor    %eax,%eax
{
80106157:	89 e5                	mov    %esp,%ebp
80106159:	83 ec 08             	sub    $0x8,%esp
8010615c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106160:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106167:	c7 04 c5 a2 76 11 80 	movl   $0x8e000008,-0x7fee895e(,%eax,8)
8010616e:	08 00 00 8e 
80106172:	66 89 14 c5 a0 76 11 	mov    %dx,-0x7fee8960(,%eax,8)
80106179:	80 
8010617a:	c1 ea 10             	shr    $0x10,%edx
8010617d:	66 89 14 c5 a6 76 11 	mov    %dx,-0x7fee895a(,%eax,8)
80106184:	80 
  for(i = 0; i < 256; i++)
80106185:	83 c0 01             	add    $0x1,%eax
80106188:	3d 00 01 00 00       	cmp    $0x100,%eax
8010618d:	75 d1                	jne    80106160 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010618f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106192:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106197:	c7 05 a2 78 11 80 08 	movl   $0xef000008,0x801178a2
8010619e:	00 00 ef 
  initlock(&tickslock, "time");
801061a1:	68 1c 82 10 80       	push   $0x8010821c
801061a6:	68 60 76 11 80       	push   $0x80117660
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061ab:	66 a3 a0 78 11 80    	mov    %ax,0x801178a0
801061b1:	c1 e8 10             	shr    $0x10,%eax
801061b4:	66 a3 a6 78 11 80    	mov    %ax,0x801178a6
  initlock(&tickslock, "time");
801061ba:	e8 81 e2 ff ff       	call   80104440 <initlock>
}
801061bf:	83 c4 10             	add    $0x10,%esp
801061c2:	c9                   	leave  
801061c3:	c3                   	ret    
801061c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061cf:	90                   	nop

801061d0 <idtinit>:

void
idtinit(void)
{
801061d0:	f3 0f 1e fb          	endbr32 
801061d4:	55                   	push   %ebp
  pd[0] = size-1;
801061d5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061da:	89 e5                	mov    %esp,%ebp
801061dc:	83 ec 10             	sub    $0x10,%esp
801061df:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061e3:	b8 a0 76 11 80       	mov    $0x801176a0,%eax
801061e8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061ec:	c1 e8 10             	shr    $0x10,%eax
801061ef:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801061f3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801061f6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801061f9:	c9                   	leave  
801061fa:	c3                   	ret    
801061fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061ff:	90                   	nop

80106200 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106200:	f3 0f 1e fb          	endbr32 
80106204:	55                   	push   %ebp
80106205:	89 e5                	mov    %esp,%ebp
80106207:	57                   	push   %edi
80106208:	56                   	push   %esi
80106209:	53                   	push   %ebx
8010620a:	83 ec 1c             	sub    $0x1c,%esp
8010620d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106210:	8b 43 30             	mov    0x30(%ebx),%eax
80106213:	83 f8 40             	cmp    $0x40,%eax
80106216:	0f 84 bc 01 00 00    	je     801063d8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010621c:	83 e8 20             	sub    $0x20,%eax
8010621f:	83 f8 1f             	cmp    $0x1f,%eax
80106222:	77 08                	ja     8010622c <trap+0x2c>
80106224:	3e ff 24 85 c4 82 10 	notrack jmp *-0x7fef7d3c(,%eax,4)
8010622b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010622c:	e8 4f d7 ff ff       	call   80103980 <myproc>
80106231:	8b 7b 38             	mov    0x38(%ebx),%edi
80106234:	85 c0                	test   %eax,%eax
80106236:	0f 84 eb 01 00 00    	je     80106427 <trap+0x227>
8010623c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106240:	0f 84 e1 01 00 00    	je     80106427 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106246:	0f 20 d1             	mov    %cr2,%ecx
80106249:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010624c:	e8 0f d7 ff ff       	call   80103960 <cpuid>
80106251:	8b 73 30             	mov    0x30(%ebx),%esi
80106254:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106257:	8b 43 34             	mov    0x34(%ebx),%eax
8010625a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010625d:	e8 1e d7 ff ff       	call   80103980 <myproc>
80106262:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106265:	e8 16 d7 ff ff       	call   80103980 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010626a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010626d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106270:	51                   	push   %ecx
80106271:	57                   	push   %edi
80106272:	52                   	push   %edx
80106273:	ff 75 e4             	pushl  -0x1c(%ebp)
80106276:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106277:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010627a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010627d:	56                   	push   %esi
8010627e:	ff 70 10             	pushl  0x10(%eax)
80106281:	68 80 82 10 80       	push   $0x80108280
80106286:	e8 25 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010628b:	83 c4 20             	add    $0x20,%esp
8010628e:	e8 ed d6 ff ff       	call   80103980 <myproc>
80106293:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010629a:	e8 e1 d6 ff ff       	call   80103980 <myproc>
8010629f:	85 c0                	test   %eax,%eax
801062a1:	74 1d                	je     801062c0 <trap+0xc0>
801062a3:	e8 d8 d6 ff ff       	call   80103980 <myproc>
801062a8:	8b 50 24             	mov    0x24(%eax),%edx
801062ab:	85 d2                	test   %edx,%edx
801062ad:	74 11                	je     801062c0 <trap+0xc0>
801062af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062b3:	83 e0 03             	and    $0x3,%eax
801062b6:	66 83 f8 03          	cmp    $0x3,%ax
801062ba:	0f 84 50 01 00 00    	je     80106410 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062c0:	e8 bb d6 ff ff       	call   80103980 <myproc>
801062c5:	85 c0                	test   %eax,%eax
801062c7:	74 0f                	je     801062d8 <trap+0xd8>
801062c9:	e8 b2 d6 ff ff       	call   80103980 <myproc>
801062ce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062d2:	0f 84 e8 00 00 00    	je     801063c0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062d8:	e8 a3 d6 ff ff       	call   80103980 <myproc>
801062dd:	85 c0                	test   %eax,%eax
801062df:	74 1d                	je     801062fe <trap+0xfe>
801062e1:	e8 9a d6 ff ff       	call   80103980 <myproc>
801062e6:	8b 40 24             	mov    0x24(%eax),%eax
801062e9:	85 c0                	test   %eax,%eax
801062eb:	74 11                	je     801062fe <trap+0xfe>
801062ed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062f1:	83 e0 03             	and    $0x3,%eax
801062f4:	66 83 f8 03          	cmp    $0x3,%ax
801062f8:	0f 84 03 01 00 00    	je     80106401 <trap+0x201>
    exit();
}
801062fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106301:	5b                   	pop    %ebx
80106302:	5e                   	pop    %esi
80106303:	5f                   	pop    %edi
80106304:	5d                   	pop    %ebp
80106305:	c3                   	ret    
    ideintr();
80106306:	e8 d5 be ff ff       	call   801021e0 <ideintr>
    lapiceoi();
8010630b:	e8 b0 c5 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106310:	e8 6b d6 ff ff       	call   80103980 <myproc>
80106315:	85 c0                	test   %eax,%eax
80106317:	75 8a                	jne    801062a3 <trap+0xa3>
80106319:	eb a5                	jmp    801062c0 <trap+0xc0>
    if(cpuid() == 0){
8010631b:	e8 40 d6 ff ff       	call   80103960 <cpuid>
80106320:	85 c0                	test   %eax,%eax
80106322:	75 e7                	jne    8010630b <trap+0x10b>
      acquire(&tickslock);
80106324:	83 ec 0c             	sub    $0xc,%esp
80106327:	68 60 76 11 80       	push   $0x80117660
8010632c:	e8 8f e2 ff ff       	call   801045c0 <acquire>
      wakeup(&ticks);
80106331:	c7 04 24 a0 7e 11 80 	movl   $0x80117ea0,(%esp)
      ticks++;
80106338:	83 05 a0 7e 11 80 01 	addl   $0x1,0x80117ea0
      wakeup(&ticks);
8010633f:	e8 dc dd ff ff       	call   80104120 <wakeup>
      release(&tickslock);
80106344:	c7 04 24 60 76 11 80 	movl   $0x80117660,(%esp)
8010634b:	e8 30 e3 ff ff       	call   80104680 <release>
80106350:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106353:	eb b6                	jmp    8010630b <trap+0x10b>
    kbdintr();
80106355:	e8 26 c4 ff ff       	call   80102780 <kbdintr>
    lapiceoi();
8010635a:	e8 61 c5 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010635f:	e8 1c d6 ff ff       	call   80103980 <myproc>
80106364:	85 c0                	test   %eax,%eax
80106366:	0f 85 37 ff ff ff    	jne    801062a3 <trap+0xa3>
8010636c:	e9 4f ff ff ff       	jmp    801062c0 <trap+0xc0>
    uartintr();
80106371:	e8 4a 02 00 00       	call   801065c0 <uartintr>
    lapiceoi();
80106376:	e8 45 c5 ff ff       	call   801028c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010637b:	e8 00 d6 ff ff       	call   80103980 <myproc>
80106380:	85 c0                	test   %eax,%eax
80106382:	0f 85 1b ff ff ff    	jne    801062a3 <trap+0xa3>
80106388:	e9 33 ff ff ff       	jmp    801062c0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010638d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106390:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106394:	e8 c7 d5 ff ff       	call   80103960 <cpuid>
80106399:	57                   	push   %edi
8010639a:	56                   	push   %esi
8010639b:	50                   	push   %eax
8010639c:	68 28 82 10 80       	push   $0x80108228
801063a1:	e8 0a a3 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801063a6:	e8 15 c5 ff ff       	call   801028c0 <lapiceoi>
    break;
801063ab:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063ae:	e8 cd d5 ff ff       	call   80103980 <myproc>
801063b3:	85 c0                	test   %eax,%eax
801063b5:	0f 85 e8 fe ff ff    	jne    801062a3 <trap+0xa3>
801063bb:	e9 00 ff ff ff       	jmp    801062c0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801063c0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063c4:	0f 85 0e ff ff ff    	jne    801062d8 <trap+0xd8>
    yield();
801063ca:	e8 41 db ff ff       	call   80103f10 <yield>
801063cf:	e9 04 ff ff ff       	jmp    801062d8 <trap+0xd8>
801063d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801063d8:	e8 a3 d5 ff ff       	call   80103980 <myproc>
801063dd:	8b 70 24             	mov    0x24(%eax),%esi
801063e0:	85 f6                	test   %esi,%esi
801063e2:	75 3c                	jne    80106420 <trap+0x220>
    myproc()->tf = tf;
801063e4:	e8 97 d5 ff ff       	call   80103980 <myproc>
801063e9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063ec:	e8 af e6 ff ff       	call   80104aa0 <syscall>
    if(myproc()->killed)
801063f1:	e8 8a d5 ff ff       	call   80103980 <myproc>
801063f6:	8b 48 24             	mov    0x24(%eax),%ecx
801063f9:	85 c9                	test   %ecx,%ecx
801063fb:	0f 84 fd fe ff ff    	je     801062fe <trap+0xfe>
}
80106401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106404:	5b                   	pop    %ebx
80106405:	5e                   	pop    %esi
80106406:	5f                   	pop    %edi
80106407:	5d                   	pop    %ebp
      exit();
80106408:	e9 a3 d9 ff ff       	jmp    80103db0 <exit>
8010640d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106410:	e8 9b d9 ff ff       	call   80103db0 <exit>
80106415:	e9 a6 fe ff ff       	jmp    801062c0 <trap+0xc0>
8010641a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106420:	e8 8b d9 ff ff       	call   80103db0 <exit>
80106425:	eb bd                	jmp    801063e4 <trap+0x1e4>
80106427:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010642a:	e8 31 d5 ff ff       	call   80103960 <cpuid>
8010642f:	83 ec 0c             	sub    $0xc,%esp
80106432:	56                   	push   %esi
80106433:	57                   	push   %edi
80106434:	50                   	push   %eax
80106435:	ff 73 30             	pushl  0x30(%ebx)
80106438:	68 4c 82 10 80       	push   $0x8010824c
8010643d:	e8 6e a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106442:	83 c4 14             	add    $0x14,%esp
80106445:	68 21 82 10 80       	push   $0x80108221
8010644a:	e8 41 9f ff ff       	call   80100390 <panic>
8010644f:	90                   	nop

80106450 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106450:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106454:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106459:	85 c0                	test   %eax,%eax
8010645b:	74 1b                	je     80106478 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010645d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106462:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106463:	a8 01                	test   $0x1,%al
80106465:	74 11                	je     80106478 <uartgetc+0x28>
80106467:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010646c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010646d:	0f b6 c0             	movzbl %al,%eax
80106470:	c3                   	ret    
80106471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010647d:	c3                   	ret    
8010647e:	66 90                	xchg   %ax,%ax

80106480 <uartputc.part.0>:
uartputc(int c)
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	57                   	push   %edi
80106484:	89 c7                	mov    %eax,%edi
80106486:	56                   	push   %esi
80106487:	be fd 03 00 00       	mov    $0x3fd,%esi
8010648c:	53                   	push   %ebx
8010648d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106492:	83 ec 0c             	sub    $0xc,%esp
80106495:	eb 1b                	jmp    801064b2 <uartputc.part.0+0x32>
80106497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010649e:	66 90                	xchg   %ax,%ax
    microdelay(10);
801064a0:	83 ec 0c             	sub    $0xc,%esp
801064a3:	6a 0a                	push   $0xa
801064a5:	e8 36 c4 ff ff       	call   801028e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064aa:	83 c4 10             	add    $0x10,%esp
801064ad:	83 eb 01             	sub    $0x1,%ebx
801064b0:	74 07                	je     801064b9 <uartputc.part.0+0x39>
801064b2:	89 f2                	mov    %esi,%edx
801064b4:	ec                   	in     (%dx),%al
801064b5:	a8 20                	test   $0x20,%al
801064b7:	74 e7                	je     801064a0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064b9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064be:	89 f8                	mov    %edi,%eax
801064c0:	ee                   	out    %al,(%dx)
}
801064c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064c4:	5b                   	pop    %ebx
801064c5:	5e                   	pop    %esi
801064c6:	5f                   	pop    %edi
801064c7:	5d                   	pop    %ebp
801064c8:	c3                   	ret    
801064c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801064d0 <uartinit>:
{
801064d0:	f3 0f 1e fb          	endbr32 
801064d4:	55                   	push   %ebp
801064d5:	31 c9                	xor    %ecx,%ecx
801064d7:	89 c8                	mov    %ecx,%eax
801064d9:	89 e5                	mov    %esp,%ebp
801064db:	57                   	push   %edi
801064dc:	56                   	push   %esi
801064dd:	53                   	push   %ebx
801064de:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801064e3:	89 da                	mov    %ebx,%edx
801064e5:	83 ec 0c             	sub    $0xc,%esp
801064e8:	ee                   	out    %al,(%dx)
801064e9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801064ee:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801064f3:	89 fa                	mov    %edi,%edx
801064f5:	ee                   	out    %al,(%dx)
801064f6:	b8 0c 00 00 00       	mov    $0xc,%eax
801064fb:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106500:	ee                   	out    %al,(%dx)
80106501:	be f9 03 00 00       	mov    $0x3f9,%esi
80106506:	89 c8                	mov    %ecx,%eax
80106508:	89 f2                	mov    %esi,%edx
8010650a:	ee                   	out    %al,(%dx)
8010650b:	b8 03 00 00 00       	mov    $0x3,%eax
80106510:	89 fa                	mov    %edi,%edx
80106512:	ee                   	out    %al,(%dx)
80106513:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106518:	89 c8                	mov    %ecx,%eax
8010651a:	ee                   	out    %al,(%dx)
8010651b:	b8 01 00 00 00       	mov    $0x1,%eax
80106520:	89 f2                	mov    %esi,%edx
80106522:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106523:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106528:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106529:	3c ff                	cmp    $0xff,%al
8010652b:	74 52                	je     8010657f <uartinit+0xaf>
  uart = 1;
8010652d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106534:	00 00 00 
80106537:	89 da                	mov    %ebx,%edx
80106539:	ec                   	in     (%dx),%al
8010653a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010653f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106540:	83 ec 08             	sub    $0x8,%esp
80106543:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106548:	bb 44 83 10 80       	mov    $0x80108344,%ebx
  ioapicenable(IRQ_COM1, 0);
8010654d:	6a 00                	push   $0x0
8010654f:	6a 04                	push   $0x4
80106551:	e8 da be ff ff       	call   80102430 <ioapicenable>
80106556:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106559:	b8 78 00 00 00       	mov    $0x78,%eax
8010655e:	eb 04                	jmp    80106564 <uartinit+0x94>
80106560:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106564:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010656a:	85 d2                	test   %edx,%edx
8010656c:	74 08                	je     80106576 <uartinit+0xa6>
    uartputc(*p);
8010656e:	0f be c0             	movsbl %al,%eax
80106571:	e8 0a ff ff ff       	call   80106480 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106576:	89 f0                	mov    %esi,%eax
80106578:	83 c3 01             	add    $0x1,%ebx
8010657b:	84 c0                	test   %al,%al
8010657d:	75 e1                	jne    80106560 <uartinit+0x90>
}
8010657f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106582:	5b                   	pop    %ebx
80106583:	5e                   	pop    %esi
80106584:	5f                   	pop    %edi
80106585:	5d                   	pop    %ebp
80106586:	c3                   	ret    
80106587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010658e:	66 90                	xchg   %ax,%ax

80106590 <uartputc>:
{
80106590:	f3 0f 1e fb          	endbr32 
80106594:	55                   	push   %ebp
  if(!uart)
80106595:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
8010659b:	89 e5                	mov    %esp,%ebp
8010659d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065a0:	85 d2                	test   %edx,%edx
801065a2:	74 0c                	je     801065b0 <uartputc+0x20>
}
801065a4:	5d                   	pop    %ebp
801065a5:	e9 d6 fe ff ff       	jmp    80106480 <uartputc.part.0>
801065aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065b0:	5d                   	pop    %ebp
801065b1:	c3                   	ret    
801065b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065c0 <uartintr>:

void
uartintr(void)
{
801065c0:	f3 0f 1e fb          	endbr32 
801065c4:	55                   	push   %ebp
801065c5:	89 e5                	mov    %esp,%ebp
801065c7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065ca:	68 50 64 10 80       	push   $0x80106450
801065cf:	e8 8c a2 ff ff       	call   80100860 <consoleintr>
}
801065d4:	83 c4 10             	add    $0x10,%esp
801065d7:	c9                   	leave  
801065d8:	c3                   	ret    

801065d9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801065d9:	6a 00                	push   $0x0
  pushl $0
801065db:	6a 00                	push   $0x0
  jmp alltraps
801065dd:	e9 3c fb ff ff       	jmp    8010611e <alltraps>

801065e2 <vector1>:
.globl vector1
vector1:
  pushl $0
801065e2:	6a 00                	push   $0x0
  pushl $1
801065e4:	6a 01                	push   $0x1
  jmp alltraps
801065e6:	e9 33 fb ff ff       	jmp    8010611e <alltraps>

801065eb <vector2>:
.globl vector2
vector2:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $2
801065ed:	6a 02                	push   $0x2
  jmp alltraps
801065ef:	e9 2a fb ff ff       	jmp    8010611e <alltraps>

801065f4 <vector3>:
.globl vector3
vector3:
  pushl $0
801065f4:	6a 00                	push   $0x0
  pushl $3
801065f6:	6a 03                	push   $0x3
  jmp alltraps
801065f8:	e9 21 fb ff ff       	jmp    8010611e <alltraps>

801065fd <vector4>:
.globl vector4
vector4:
  pushl $0
801065fd:	6a 00                	push   $0x0
  pushl $4
801065ff:	6a 04                	push   $0x4
  jmp alltraps
80106601:	e9 18 fb ff ff       	jmp    8010611e <alltraps>

80106606 <vector5>:
.globl vector5
vector5:
  pushl $0
80106606:	6a 00                	push   $0x0
  pushl $5
80106608:	6a 05                	push   $0x5
  jmp alltraps
8010660a:	e9 0f fb ff ff       	jmp    8010611e <alltraps>

8010660f <vector6>:
.globl vector6
vector6:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $6
80106611:	6a 06                	push   $0x6
  jmp alltraps
80106613:	e9 06 fb ff ff       	jmp    8010611e <alltraps>

80106618 <vector7>:
.globl vector7
vector7:
  pushl $0
80106618:	6a 00                	push   $0x0
  pushl $7
8010661a:	6a 07                	push   $0x7
  jmp alltraps
8010661c:	e9 fd fa ff ff       	jmp    8010611e <alltraps>

80106621 <vector8>:
.globl vector8
vector8:
  pushl $8
80106621:	6a 08                	push   $0x8
  jmp alltraps
80106623:	e9 f6 fa ff ff       	jmp    8010611e <alltraps>

80106628 <vector9>:
.globl vector9
vector9:
  pushl $0
80106628:	6a 00                	push   $0x0
  pushl $9
8010662a:	6a 09                	push   $0x9
  jmp alltraps
8010662c:	e9 ed fa ff ff       	jmp    8010611e <alltraps>

80106631 <vector10>:
.globl vector10
vector10:
  pushl $10
80106631:	6a 0a                	push   $0xa
  jmp alltraps
80106633:	e9 e6 fa ff ff       	jmp    8010611e <alltraps>

80106638 <vector11>:
.globl vector11
vector11:
  pushl $11
80106638:	6a 0b                	push   $0xb
  jmp alltraps
8010663a:	e9 df fa ff ff       	jmp    8010611e <alltraps>

8010663f <vector12>:
.globl vector12
vector12:
  pushl $12
8010663f:	6a 0c                	push   $0xc
  jmp alltraps
80106641:	e9 d8 fa ff ff       	jmp    8010611e <alltraps>

80106646 <vector13>:
.globl vector13
vector13:
  pushl $13
80106646:	6a 0d                	push   $0xd
  jmp alltraps
80106648:	e9 d1 fa ff ff       	jmp    8010611e <alltraps>

8010664d <vector14>:
.globl vector14
vector14:
  pushl $14
8010664d:	6a 0e                	push   $0xe
  jmp alltraps
8010664f:	e9 ca fa ff ff       	jmp    8010611e <alltraps>

80106654 <vector15>:
.globl vector15
vector15:
  pushl $0
80106654:	6a 00                	push   $0x0
  pushl $15
80106656:	6a 0f                	push   $0xf
  jmp alltraps
80106658:	e9 c1 fa ff ff       	jmp    8010611e <alltraps>

8010665d <vector16>:
.globl vector16
vector16:
  pushl $0
8010665d:	6a 00                	push   $0x0
  pushl $16
8010665f:	6a 10                	push   $0x10
  jmp alltraps
80106661:	e9 b8 fa ff ff       	jmp    8010611e <alltraps>

80106666 <vector17>:
.globl vector17
vector17:
  pushl $17
80106666:	6a 11                	push   $0x11
  jmp alltraps
80106668:	e9 b1 fa ff ff       	jmp    8010611e <alltraps>

8010666d <vector18>:
.globl vector18
vector18:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $18
8010666f:	6a 12                	push   $0x12
  jmp alltraps
80106671:	e9 a8 fa ff ff       	jmp    8010611e <alltraps>

80106676 <vector19>:
.globl vector19
vector19:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $19
80106678:	6a 13                	push   $0x13
  jmp alltraps
8010667a:	e9 9f fa ff ff       	jmp    8010611e <alltraps>

8010667f <vector20>:
.globl vector20
vector20:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $20
80106681:	6a 14                	push   $0x14
  jmp alltraps
80106683:	e9 96 fa ff ff       	jmp    8010611e <alltraps>

80106688 <vector21>:
.globl vector21
vector21:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $21
8010668a:	6a 15                	push   $0x15
  jmp alltraps
8010668c:	e9 8d fa ff ff       	jmp    8010611e <alltraps>

80106691 <vector22>:
.globl vector22
vector22:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $22
80106693:	6a 16                	push   $0x16
  jmp alltraps
80106695:	e9 84 fa ff ff       	jmp    8010611e <alltraps>

8010669a <vector23>:
.globl vector23
vector23:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $23
8010669c:	6a 17                	push   $0x17
  jmp alltraps
8010669e:	e9 7b fa ff ff       	jmp    8010611e <alltraps>

801066a3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $24
801066a5:	6a 18                	push   $0x18
  jmp alltraps
801066a7:	e9 72 fa ff ff       	jmp    8010611e <alltraps>

801066ac <vector25>:
.globl vector25
vector25:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $25
801066ae:	6a 19                	push   $0x19
  jmp alltraps
801066b0:	e9 69 fa ff ff       	jmp    8010611e <alltraps>

801066b5 <vector26>:
.globl vector26
vector26:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $26
801066b7:	6a 1a                	push   $0x1a
  jmp alltraps
801066b9:	e9 60 fa ff ff       	jmp    8010611e <alltraps>

801066be <vector27>:
.globl vector27
vector27:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $27
801066c0:	6a 1b                	push   $0x1b
  jmp alltraps
801066c2:	e9 57 fa ff ff       	jmp    8010611e <alltraps>

801066c7 <vector28>:
.globl vector28
vector28:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $28
801066c9:	6a 1c                	push   $0x1c
  jmp alltraps
801066cb:	e9 4e fa ff ff       	jmp    8010611e <alltraps>

801066d0 <vector29>:
.globl vector29
vector29:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $29
801066d2:	6a 1d                	push   $0x1d
  jmp alltraps
801066d4:	e9 45 fa ff ff       	jmp    8010611e <alltraps>

801066d9 <vector30>:
.globl vector30
vector30:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $30
801066db:	6a 1e                	push   $0x1e
  jmp alltraps
801066dd:	e9 3c fa ff ff       	jmp    8010611e <alltraps>

801066e2 <vector31>:
.globl vector31
vector31:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $31
801066e4:	6a 1f                	push   $0x1f
  jmp alltraps
801066e6:	e9 33 fa ff ff       	jmp    8010611e <alltraps>

801066eb <vector32>:
.globl vector32
vector32:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $32
801066ed:	6a 20                	push   $0x20
  jmp alltraps
801066ef:	e9 2a fa ff ff       	jmp    8010611e <alltraps>

801066f4 <vector33>:
.globl vector33
vector33:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $33
801066f6:	6a 21                	push   $0x21
  jmp alltraps
801066f8:	e9 21 fa ff ff       	jmp    8010611e <alltraps>

801066fd <vector34>:
.globl vector34
vector34:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $34
801066ff:	6a 22                	push   $0x22
  jmp alltraps
80106701:	e9 18 fa ff ff       	jmp    8010611e <alltraps>

80106706 <vector35>:
.globl vector35
vector35:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $35
80106708:	6a 23                	push   $0x23
  jmp alltraps
8010670a:	e9 0f fa ff ff       	jmp    8010611e <alltraps>

8010670f <vector36>:
.globl vector36
vector36:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $36
80106711:	6a 24                	push   $0x24
  jmp alltraps
80106713:	e9 06 fa ff ff       	jmp    8010611e <alltraps>

80106718 <vector37>:
.globl vector37
vector37:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $37
8010671a:	6a 25                	push   $0x25
  jmp alltraps
8010671c:	e9 fd f9 ff ff       	jmp    8010611e <alltraps>

80106721 <vector38>:
.globl vector38
vector38:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $38
80106723:	6a 26                	push   $0x26
  jmp alltraps
80106725:	e9 f4 f9 ff ff       	jmp    8010611e <alltraps>

8010672a <vector39>:
.globl vector39
vector39:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $39
8010672c:	6a 27                	push   $0x27
  jmp alltraps
8010672e:	e9 eb f9 ff ff       	jmp    8010611e <alltraps>

80106733 <vector40>:
.globl vector40
vector40:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $40
80106735:	6a 28                	push   $0x28
  jmp alltraps
80106737:	e9 e2 f9 ff ff       	jmp    8010611e <alltraps>

8010673c <vector41>:
.globl vector41
vector41:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $41
8010673e:	6a 29                	push   $0x29
  jmp alltraps
80106740:	e9 d9 f9 ff ff       	jmp    8010611e <alltraps>

80106745 <vector42>:
.globl vector42
vector42:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $42
80106747:	6a 2a                	push   $0x2a
  jmp alltraps
80106749:	e9 d0 f9 ff ff       	jmp    8010611e <alltraps>

8010674e <vector43>:
.globl vector43
vector43:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $43
80106750:	6a 2b                	push   $0x2b
  jmp alltraps
80106752:	e9 c7 f9 ff ff       	jmp    8010611e <alltraps>

80106757 <vector44>:
.globl vector44
vector44:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $44
80106759:	6a 2c                	push   $0x2c
  jmp alltraps
8010675b:	e9 be f9 ff ff       	jmp    8010611e <alltraps>

80106760 <vector45>:
.globl vector45
vector45:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $45
80106762:	6a 2d                	push   $0x2d
  jmp alltraps
80106764:	e9 b5 f9 ff ff       	jmp    8010611e <alltraps>

80106769 <vector46>:
.globl vector46
vector46:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $46
8010676b:	6a 2e                	push   $0x2e
  jmp alltraps
8010676d:	e9 ac f9 ff ff       	jmp    8010611e <alltraps>

80106772 <vector47>:
.globl vector47
vector47:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $47
80106774:	6a 2f                	push   $0x2f
  jmp alltraps
80106776:	e9 a3 f9 ff ff       	jmp    8010611e <alltraps>

8010677b <vector48>:
.globl vector48
vector48:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $48
8010677d:	6a 30                	push   $0x30
  jmp alltraps
8010677f:	e9 9a f9 ff ff       	jmp    8010611e <alltraps>

80106784 <vector49>:
.globl vector49
vector49:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $49
80106786:	6a 31                	push   $0x31
  jmp alltraps
80106788:	e9 91 f9 ff ff       	jmp    8010611e <alltraps>

8010678d <vector50>:
.globl vector50
vector50:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $50
8010678f:	6a 32                	push   $0x32
  jmp alltraps
80106791:	e9 88 f9 ff ff       	jmp    8010611e <alltraps>

80106796 <vector51>:
.globl vector51
vector51:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $51
80106798:	6a 33                	push   $0x33
  jmp alltraps
8010679a:	e9 7f f9 ff ff       	jmp    8010611e <alltraps>

8010679f <vector52>:
.globl vector52
vector52:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $52
801067a1:	6a 34                	push   $0x34
  jmp alltraps
801067a3:	e9 76 f9 ff ff       	jmp    8010611e <alltraps>

801067a8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $53
801067aa:	6a 35                	push   $0x35
  jmp alltraps
801067ac:	e9 6d f9 ff ff       	jmp    8010611e <alltraps>

801067b1 <vector54>:
.globl vector54
vector54:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $54
801067b3:	6a 36                	push   $0x36
  jmp alltraps
801067b5:	e9 64 f9 ff ff       	jmp    8010611e <alltraps>

801067ba <vector55>:
.globl vector55
vector55:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $55
801067bc:	6a 37                	push   $0x37
  jmp alltraps
801067be:	e9 5b f9 ff ff       	jmp    8010611e <alltraps>

801067c3 <vector56>:
.globl vector56
vector56:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $56
801067c5:	6a 38                	push   $0x38
  jmp alltraps
801067c7:	e9 52 f9 ff ff       	jmp    8010611e <alltraps>

801067cc <vector57>:
.globl vector57
vector57:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $57
801067ce:	6a 39                	push   $0x39
  jmp alltraps
801067d0:	e9 49 f9 ff ff       	jmp    8010611e <alltraps>

801067d5 <vector58>:
.globl vector58
vector58:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $58
801067d7:	6a 3a                	push   $0x3a
  jmp alltraps
801067d9:	e9 40 f9 ff ff       	jmp    8010611e <alltraps>

801067de <vector59>:
.globl vector59
vector59:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $59
801067e0:	6a 3b                	push   $0x3b
  jmp alltraps
801067e2:	e9 37 f9 ff ff       	jmp    8010611e <alltraps>

801067e7 <vector60>:
.globl vector60
vector60:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $60
801067e9:	6a 3c                	push   $0x3c
  jmp alltraps
801067eb:	e9 2e f9 ff ff       	jmp    8010611e <alltraps>

801067f0 <vector61>:
.globl vector61
vector61:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $61
801067f2:	6a 3d                	push   $0x3d
  jmp alltraps
801067f4:	e9 25 f9 ff ff       	jmp    8010611e <alltraps>

801067f9 <vector62>:
.globl vector62
vector62:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $62
801067fb:	6a 3e                	push   $0x3e
  jmp alltraps
801067fd:	e9 1c f9 ff ff       	jmp    8010611e <alltraps>

80106802 <vector63>:
.globl vector63
vector63:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $63
80106804:	6a 3f                	push   $0x3f
  jmp alltraps
80106806:	e9 13 f9 ff ff       	jmp    8010611e <alltraps>

8010680b <vector64>:
.globl vector64
vector64:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $64
8010680d:	6a 40                	push   $0x40
  jmp alltraps
8010680f:	e9 0a f9 ff ff       	jmp    8010611e <alltraps>

80106814 <vector65>:
.globl vector65
vector65:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $65
80106816:	6a 41                	push   $0x41
  jmp alltraps
80106818:	e9 01 f9 ff ff       	jmp    8010611e <alltraps>

8010681d <vector66>:
.globl vector66
vector66:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $66
8010681f:	6a 42                	push   $0x42
  jmp alltraps
80106821:	e9 f8 f8 ff ff       	jmp    8010611e <alltraps>

80106826 <vector67>:
.globl vector67
vector67:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $67
80106828:	6a 43                	push   $0x43
  jmp alltraps
8010682a:	e9 ef f8 ff ff       	jmp    8010611e <alltraps>

8010682f <vector68>:
.globl vector68
vector68:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $68
80106831:	6a 44                	push   $0x44
  jmp alltraps
80106833:	e9 e6 f8 ff ff       	jmp    8010611e <alltraps>

80106838 <vector69>:
.globl vector69
vector69:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $69
8010683a:	6a 45                	push   $0x45
  jmp alltraps
8010683c:	e9 dd f8 ff ff       	jmp    8010611e <alltraps>

80106841 <vector70>:
.globl vector70
vector70:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $70
80106843:	6a 46                	push   $0x46
  jmp alltraps
80106845:	e9 d4 f8 ff ff       	jmp    8010611e <alltraps>

8010684a <vector71>:
.globl vector71
vector71:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $71
8010684c:	6a 47                	push   $0x47
  jmp alltraps
8010684e:	e9 cb f8 ff ff       	jmp    8010611e <alltraps>

80106853 <vector72>:
.globl vector72
vector72:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $72
80106855:	6a 48                	push   $0x48
  jmp alltraps
80106857:	e9 c2 f8 ff ff       	jmp    8010611e <alltraps>

8010685c <vector73>:
.globl vector73
vector73:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $73
8010685e:	6a 49                	push   $0x49
  jmp alltraps
80106860:	e9 b9 f8 ff ff       	jmp    8010611e <alltraps>

80106865 <vector74>:
.globl vector74
vector74:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $74
80106867:	6a 4a                	push   $0x4a
  jmp alltraps
80106869:	e9 b0 f8 ff ff       	jmp    8010611e <alltraps>

8010686e <vector75>:
.globl vector75
vector75:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $75
80106870:	6a 4b                	push   $0x4b
  jmp alltraps
80106872:	e9 a7 f8 ff ff       	jmp    8010611e <alltraps>

80106877 <vector76>:
.globl vector76
vector76:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $76
80106879:	6a 4c                	push   $0x4c
  jmp alltraps
8010687b:	e9 9e f8 ff ff       	jmp    8010611e <alltraps>

80106880 <vector77>:
.globl vector77
vector77:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $77
80106882:	6a 4d                	push   $0x4d
  jmp alltraps
80106884:	e9 95 f8 ff ff       	jmp    8010611e <alltraps>

80106889 <vector78>:
.globl vector78
vector78:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $78
8010688b:	6a 4e                	push   $0x4e
  jmp alltraps
8010688d:	e9 8c f8 ff ff       	jmp    8010611e <alltraps>

80106892 <vector79>:
.globl vector79
vector79:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $79
80106894:	6a 4f                	push   $0x4f
  jmp alltraps
80106896:	e9 83 f8 ff ff       	jmp    8010611e <alltraps>

8010689b <vector80>:
.globl vector80
vector80:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $80
8010689d:	6a 50                	push   $0x50
  jmp alltraps
8010689f:	e9 7a f8 ff ff       	jmp    8010611e <alltraps>

801068a4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $81
801068a6:	6a 51                	push   $0x51
  jmp alltraps
801068a8:	e9 71 f8 ff ff       	jmp    8010611e <alltraps>

801068ad <vector82>:
.globl vector82
vector82:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $82
801068af:	6a 52                	push   $0x52
  jmp alltraps
801068b1:	e9 68 f8 ff ff       	jmp    8010611e <alltraps>

801068b6 <vector83>:
.globl vector83
vector83:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $83
801068b8:	6a 53                	push   $0x53
  jmp alltraps
801068ba:	e9 5f f8 ff ff       	jmp    8010611e <alltraps>

801068bf <vector84>:
.globl vector84
vector84:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $84
801068c1:	6a 54                	push   $0x54
  jmp alltraps
801068c3:	e9 56 f8 ff ff       	jmp    8010611e <alltraps>

801068c8 <vector85>:
.globl vector85
vector85:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $85
801068ca:	6a 55                	push   $0x55
  jmp alltraps
801068cc:	e9 4d f8 ff ff       	jmp    8010611e <alltraps>

801068d1 <vector86>:
.globl vector86
vector86:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $86
801068d3:	6a 56                	push   $0x56
  jmp alltraps
801068d5:	e9 44 f8 ff ff       	jmp    8010611e <alltraps>

801068da <vector87>:
.globl vector87
vector87:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $87
801068dc:	6a 57                	push   $0x57
  jmp alltraps
801068de:	e9 3b f8 ff ff       	jmp    8010611e <alltraps>

801068e3 <vector88>:
.globl vector88
vector88:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $88
801068e5:	6a 58                	push   $0x58
  jmp alltraps
801068e7:	e9 32 f8 ff ff       	jmp    8010611e <alltraps>

801068ec <vector89>:
.globl vector89
vector89:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $89
801068ee:	6a 59                	push   $0x59
  jmp alltraps
801068f0:	e9 29 f8 ff ff       	jmp    8010611e <alltraps>

801068f5 <vector90>:
.globl vector90
vector90:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $90
801068f7:	6a 5a                	push   $0x5a
  jmp alltraps
801068f9:	e9 20 f8 ff ff       	jmp    8010611e <alltraps>

801068fe <vector91>:
.globl vector91
vector91:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $91
80106900:	6a 5b                	push   $0x5b
  jmp alltraps
80106902:	e9 17 f8 ff ff       	jmp    8010611e <alltraps>

80106907 <vector92>:
.globl vector92
vector92:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $92
80106909:	6a 5c                	push   $0x5c
  jmp alltraps
8010690b:	e9 0e f8 ff ff       	jmp    8010611e <alltraps>

80106910 <vector93>:
.globl vector93
vector93:
  pushl $0
80106910:	6a 00                	push   $0x0
  pushl $93
80106912:	6a 5d                	push   $0x5d
  jmp alltraps
80106914:	e9 05 f8 ff ff       	jmp    8010611e <alltraps>

80106919 <vector94>:
.globl vector94
vector94:
  pushl $0
80106919:	6a 00                	push   $0x0
  pushl $94
8010691b:	6a 5e                	push   $0x5e
  jmp alltraps
8010691d:	e9 fc f7 ff ff       	jmp    8010611e <alltraps>

80106922 <vector95>:
.globl vector95
vector95:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $95
80106924:	6a 5f                	push   $0x5f
  jmp alltraps
80106926:	e9 f3 f7 ff ff       	jmp    8010611e <alltraps>

8010692b <vector96>:
.globl vector96
vector96:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $96
8010692d:	6a 60                	push   $0x60
  jmp alltraps
8010692f:	e9 ea f7 ff ff       	jmp    8010611e <alltraps>

80106934 <vector97>:
.globl vector97
vector97:
  pushl $0
80106934:	6a 00                	push   $0x0
  pushl $97
80106936:	6a 61                	push   $0x61
  jmp alltraps
80106938:	e9 e1 f7 ff ff       	jmp    8010611e <alltraps>

8010693d <vector98>:
.globl vector98
vector98:
  pushl $0
8010693d:	6a 00                	push   $0x0
  pushl $98
8010693f:	6a 62                	push   $0x62
  jmp alltraps
80106941:	e9 d8 f7 ff ff       	jmp    8010611e <alltraps>

80106946 <vector99>:
.globl vector99
vector99:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $99
80106948:	6a 63                	push   $0x63
  jmp alltraps
8010694a:	e9 cf f7 ff ff       	jmp    8010611e <alltraps>

8010694f <vector100>:
.globl vector100
vector100:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $100
80106951:	6a 64                	push   $0x64
  jmp alltraps
80106953:	e9 c6 f7 ff ff       	jmp    8010611e <alltraps>

80106958 <vector101>:
.globl vector101
vector101:
  pushl $0
80106958:	6a 00                	push   $0x0
  pushl $101
8010695a:	6a 65                	push   $0x65
  jmp alltraps
8010695c:	e9 bd f7 ff ff       	jmp    8010611e <alltraps>

80106961 <vector102>:
.globl vector102
vector102:
  pushl $0
80106961:	6a 00                	push   $0x0
  pushl $102
80106963:	6a 66                	push   $0x66
  jmp alltraps
80106965:	e9 b4 f7 ff ff       	jmp    8010611e <alltraps>

8010696a <vector103>:
.globl vector103
vector103:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $103
8010696c:	6a 67                	push   $0x67
  jmp alltraps
8010696e:	e9 ab f7 ff ff       	jmp    8010611e <alltraps>

80106973 <vector104>:
.globl vector104
vector104:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $104
80106975:	6a 68                	push   $0x68
  jmp alltraps
80106977:	e9 a2 f7 ff ff       	jmp    8010611e <alltraps>

8010697c <vector105>:
.globl vector105
vector105:
  pushl $0
8010697c:	6a 00                	push   $0x0
  pushl $105
8010697e:	6a 69                	push   $0x69
  jmp alltraps
80106980:	e9 99 f7 ff ff       	jmp    8010611e <alltraps>

80106985 <vector106>:
.globl vector106
vector106:
  pushl $0
80106985:	6a 00                	push   $0x0
  pushl $106
80106987:	6a 6a                	push   $0x6a
  jmp alltraps
80106989:	e9 90 f7 ff ff       	jmp    8010611e <alltraps>

8010698e <vector107>:
.globl vector107
vector107:
  pushl $0
8010698e:	6a 00                	push   $0x0
  pushl $107
80106990:	6a 6b                	push   $0x6b
  jmp alltraps
80106992:	e9 87 f7 ff ff       	jmp    8010611e <alltraps>

80106997 <vector108>:
.globl vector108
vector108:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $108
80106999:	6a 6c                	push   $0x6c
  jmp alltraps
8010699b:	e9 7e f7 ff ff       	jmp    8010611e <alltraps>

801069a0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069a0:	6a 00                	push   $0x0
  pushl $109
801069a2:	6a 6d                	push   $0x6d
  jmp alltraps
801069a4:	e9 75 f7 ff ff       	jmp    8010611e <alltraps>

801069a9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069a9:	6a 00                	push   $0x0
  pushl $110
801069ab:	6a 6e                	push   $0x6e
  jmp alltraps
801069ad:	e9 6c f7 ff ff       	jmp    8010611e <alltraps>

801069b2 <vector111>:
.globl vector111
vector111:
  pushl $0
801069b2:	6a 00                	push   $0x0
  pushl $111
801069b4:	6a 6f                	push   $0x6f
  jmp alltraps
801069b6:	e9 63 f7 ff ff       	jmp    8010611e <alltraps>

801069bb <vector112>:
.globl vector112
vector112:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $112
801069bd:	6a 70                	push   $0x70
  jmp alltraps
801069bf:	e9 5a f7 ff ff       	jmp    8010611e <alltraps>

801069c4 <vector113>:
.globl vector113
vector113:
  pushl $0
801069c4:	6a 00                	push   $0x0
  pushl $113
801069c6:	6a 71                	push   $0x71
  jmp alltraps
801069c8:	e9 51 f7 ff ff       	jmp    8010611e <alltraps>

801069cd <vector114>:
.globl vector114
vector114:
  pushl $0
801069cd:	6a 00                	push   $0x0
  pushl $114
801069cf:	6a 72                	push   $0x72
  jmp alltraps
801069d1:	e9 48 f7 ff ff       	jmp    8010611e <alltraps>

801069d6 <vector115>:
.globl vector115
vector115:
  pushl $0
801069d6:	6a 00                	push   $0x0
  pushl $115
801069d8:	6a 73                	push   $0x73
  jmp alltraps
801069da:	e9 3f f7 ff ff       	jmp    8010611e <alltraps>

801069df <vector116>:
.globl vector116
vector116:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $116
801069e1:	6a 74                	push   $0x74
  jmp alltraps
801069e3:	e9 36 f7 ff ff       	jmp    8010611e <alltraps>

801069e8 <vector117>:
.globl vector117
vector117:
  pushl $0
801069e8:	6a 00                	push   $0x0
  pushl $117
801069ea:	6a 75                	push   $0x75
  jmp alltraps
801069ec:	e9 2d f7 ff ff       	jmp    8010611e <alltraps>

801069f1 <vector118>:
.globl vector118
vector118:
  pushl $0
801069f1:	6a 00                	push   $0x0
  pushl $118
801069f3:	6a 76                	push   $0x76
  jmp alltraps
801069f5:	e9 24 f7 ff ff       	jmp    8010611e <alltraps>

801069fa <vector119>:
.globl vector119
vector119:
  pushl $0
801069fa:	6a 00                	push   $0x0
  pushl $119
801069fc:	6a 77                	push   $0x77
  jmp alltraps
801069fe:	e9 1b f7 ff ff       	jmp    8010611e <alltraps>

80106a03 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $120
80106a05:	6a 78                	push   $0x78
  jmp alltraps
80106a07:	e9 12 f7 ff ff       	jmp    8010611e <alltraps>

80106a0c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a0c:	6a 00                	push   $0x0
  pushl $121
80106a0e:	6a 79                	push   $0x79
  jmp alltraps
80106a10:	e9 09 f7 ff ff       	jmp    8010611e <alltraps>

80106a15 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a15:	6a 00                	push   $0x0
  pushl $122
80106a17:	6a 7a                	push   $0x7a
  jmp alltraps
80106a19:	e9 00 f7 ff ff       	jmp    8010611e <alltraps>

80106a1e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a1e:	6a 00                	push   $0x0
  pushl $123
80106a20:	6a 7b                	push   $0x7b
  jmp alltraps
80106a22:	e9 f7 f6 ff ff       	jmp    8010611e <alltraps>

80106a27 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $124
80106a29:	6a 7c                	push   $0x7c
  jmp alltraps
80106a2b:	e9 ee f6 ff ff       	jmp    8010611e <alltraps>

80106a30 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a30:	6a 00                	push   $0x0
  pushl $125
80106a32:	6a 7d                	push   $0x7d
  jmp alltraps
80106a34:	e9 e5 f6 ff ff       	jmp    8010611e <alltraps>

80106a39 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a39:	6a 00                	push   $0x0
  pushl $126
80106a3b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a3d:	e9 dc f6 ff ff       	jmp    8010611e <alltraps>

80106a42 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a42:	6a 00                	push   $0x0
  pushl $127
80106a44:	6a 7f                	push   $0x7f
  jmp alltraps
80106a46:	e9 d3 f6 ff ff       	jmp    8010611e <alltraps>

80106a4b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $128
80106a4d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a52:	e9 c7 f6 ff ff       	jmp    8010611e <alltraps>

80106a57 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $129
80106a59:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a5e:	e9 bb f6 ff ff       	jmp    8010611e <alltraps>

80106a63 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $130
80106a65:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a6a:	e9 af f6 ff ff       	jmp    8010611e <alltraps>

80106a6f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $131
80106a71:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106a76:	e9 a3 f6 ff ff       	jmp    8010611e <alltraps>

80106a7b <vector132>:
.globl vector132
vector132:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $132
80106a7d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106a82:	e9 97 f6 ff ff       	jmp    8010611e <alltraps>

80106a87 <vector133>:
.globl vector133
vector133:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $133
80106a89:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106a8e:	e9 8b f6 ff ff       	jmp    8010611e <alltraps>

80106a93 <vector134>:
.globl vector134
vector134:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $134
80106a95:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106a9a:	e9 7f f6 ff ff       	jmp    8010611e <alltraps>

80106a9f <vector135>:
.globl vector135
vector135:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $135
80106aa1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106aa6:	e9 73 f6 ff ff       	jmp    8010611e <alltraps>

80106aab <vector136>:
.globl vector136
vector136:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $136
80106aad:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ab2:	e9 67 f6 ff ff       	jmp    8010611e <alltraps>

80106ab7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $137
80106ab9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106abe:	e9 5b f6 ff ff       	jmp    8010611e <alltraps>

80106ac3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $138
80106ac5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106aca:	e9 4f f6 ff ff       	jmp    8010611e <alltraps>

80106acf <vector139>:
.globl vector139
vector139:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $139
80106ad1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106ad6:	e9 43 f6 ff ff       	jmp    8010611e <alltraps>

80106adb <vector140>:
.globl vector140
vector140:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $140
80106add:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106ae2:	e9 37 f6 ff ff       	jmp    8010611e <alltraps>

80106ae7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $141
80106ae9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106aee:	e9 2b f6 ff ff       	jmp    8010611e <alltraps>

80106af3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $142
80106af5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106afa:	e9 1f f6 ff ff       	jmp    8010611e <alltraps>

80106aff <vector143>:
.globl vector143
vector143:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $143
80106b01:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b06:	e9 13 f6 ff ff       	jmp    8010611e <alltraps>

80106b0b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $144
80106b0d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b12:	e9 07 f6 ff ff       	jmp    8010611e <alltraps>

80106b17 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $145
80106b19:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b1e:	e9 fb f5 ff ff       	jmp    8010611e <alltraps>

80106b23 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $146
80106b25:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b2a:	e9 ef f5 ff ff       	jmp    8010611e <alltraps>

80106b2f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $147
80106b31:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b36:	e9 e3 f5 ff ff       	jmp    8010611e <alltraps>

80106b3b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $148
80106b3d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b42:	e9 d7 f5 ff ff       	jmp    8010611e <alltraps>

80106b47 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $149
80106b49:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b4e:	e9 cb f5 ff ff       	jmp    8010611e <alltraps>

80106b53 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $150
80106b55:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b5a:	e9 bf f5 ff ff       	jmp    8010611e <alltraps>

80106b5f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $151
80106b61:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b66:	e9 b3 f5 ff ff       	jmp    8010611e <alltraps>

80106b6b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $152
80106b6d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106b72:	e9 a7 f5 ff ff       	jmp    8010611e <alltraps>

80106b77 <vector153>:
.globl vector153
vector153:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $153
80106b79:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106b7e:	e9 9b f5 ff ff       	jmp    8010611e <alltraps>

80106b83 <vector154>:
.globl vector154
vector154:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $154
80106b85:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106b8a:	e9 8f f5 ff ff       	jmp    8010611e <alltraps>

80106b8f <vector155>:
.globl vector155
vector155:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $155
80106b91:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106b96:	e9 83 f5 ff ff       	jmp    8010611e <alltraps>

80106b9b <vector156>:
.globl vector156
vector156:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $156
80106b9d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106ba2:	e9 77 f5 ff ff       	jmp    8010611e <alltraps>

80106ba7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $157
80106ba9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bae:	e9 6b f5 ff ff       	jmp    8010611e <alltraps>

80106bb3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $158
80106bb5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bba:	e9 5f f5 ff ff       	jmp    8010611e <alltraps>

80106bbf <vector159>:
.globl vector159
vector159:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $159
80106bc1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bc6:	e9 53 f5 ff ff       	jmp    8010611e <alltraps>

80106bcb <vector160>:
.globl vector160
vector160:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $160
80106bcd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106bd2:	e9 47 f5 ff ff       	jmp    8010611e <alltraps>

80106bd7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $161
80106bd9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106bde:	e9 3b f5 ff ff       	jmp    8010611e <alltraps>

80106be3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $162
80106be5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106bea:	e9 2f f5 ff ff       	jmp    8010611e <alltraps>

80106bef <vector163>:
.globl vector163
vector163:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $163
80106bf1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106bf6:	e9 23 f5 ff ff       	jmp    8010611e <alltraps>

80106bfb <vector164>:
.globl vector164
vector164:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $164
80106bfd:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c02:	e9 17 f5 ff ff       	jmp    8010611e <alltraps>

80106c07 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $165
80106c09:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c0e:	e9 0b f5 ff ff       	jmp    8010611e <alltraps>

80106c13 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $166
80106c15:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c1a:	e9 ff f4 ff ff       	jmp    8010611e <alltraps>

80106c1f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $167
80106c21:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c26:	e9 f3 f4 ff ff       	jmp    8010611e <alltraps>

80106c2b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $168
80106c2d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c32:	e9 e7 f4 ff ff       	jmp    8010611e <alltraps>

80106c37 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $169
80106c39:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c3e:	e9 db f4 ff ff       	jmp    8010611e <alltraps>

80106c43 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $170
80106c45:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c4a:	e9 cf f4 ff ff       	jmp    8010611e <alltraps>

80106c4f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $171
80106c51:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c56:	e9 c3 f4 ff ff       	jmp    8010611e <alltraps>

80106c5b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $172
80106c5d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c62:	e9 b7 f4 ff ff       	jmp    8010611e <alltraps>

80106c67 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $173
80106c69:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c6e:	e9 ab f4 ff ff       	jmp    8010611e <alltraps>

80106c73 <vector174>:
.globl vector174
vector174:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $174
80106c75:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106c7a:	e9 9f f4 ff ff       	jmp    8010611e <alltraps>

80106c7f <vector175>:
.globl vector175
vector175:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $175
80106c81:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106c86:	e9 93 f4 ff ff       	jmp    8010611e <alltraps>

80106c8b <vector176>:
.globl vector176
vector176:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $176
80106c8d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106c92:	e9 87 f4 ff ff       	jmp    8010611e <alltraps>

80106c97 <vector177>:
.globl vector177
vector177:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $177
80106c99:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106c9e:	e9 7b f4 ff ff       	jmp    8010611e <alltraps>

80106ca3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $178
80106ca5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106caa:	e9 6f f4 ff ff       	jmp    8010611e <alltraps>

80106caf <vector179>:
.globl vector179
vector179:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $179
80106cb1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106cb6:	e9 63 f4 ff ff       	jmp    8010611e <alltraps>

80106cbb <vector180>:
.globl vector180
vector180:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $180
80106cbd:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cc2:	e9 57 f4 ff ff       	jmp    8010611e <alltraps>

80106cc7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $181
80106cc9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cce:	e9 4b f4 ff ff       	jmp    8010611e <alltraps>

80106cd3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $182
80106cd5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106cda:	e9 3f f4 ff ff       	jmp    8010611e <alltraps>

80106cdf <vector183>:
.globl vector183
vector183:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $183
80106ce1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ce6:	e9 33 f4 ff ff       	jmp    8010611e <alltraps>

80106ceb <vector184>:
.globl vector184
vector184:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $184
80106ced:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106cf2:	e9 27 f4 ff ff       	jmp    8010611e <alltraps>

80106cf7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $185
80106cf9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106cfe:	e9 1b f4 ff ff       	jmp    8010611e <alltraps>

80106d03 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $186
80106d05:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d0a:	e9 0f f4 ff ff       	jmp    8010611e <alltraps>

80106d0f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $187
80106d11:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d16:	e9 03 f4 ff ff       	jmp    8010611e <alltraps>

80106d1b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $188
80106d1d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d22:	e9 f7 f3 ff ff       	jmp    8010611e <alltraps>

80106d27 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $189
80106d29:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d2e:	e9 eb f3 ff ff       	jmp    8010611e <alltraps>

80106d33 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $190
80106d35:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d3a:	e9 df f3 ff ff       	jmp    8010611e <alltraps>

80106d3f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $191
80106d41:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d46:	e9 d3 f3 ff ff       	jmp    8010611e <alltraps>

80106d4b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $192
80106d4d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d52:	e9 c7 f3 ff ff       	jmp    8010611e <alltraps>

80106d57 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $193
80106d59:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d5e:	e9 bb f3 ff ff       	jmp    8010611e <alltraps>

80106d63 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $194
80106d65:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d6a:	e9 af f3 ff ff       	jmp    8010611e <alltraps>

80106d6f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $195
80106d71:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106d76:	e9 a3 f3 ff ff       	jmp    8010611e <alltraps>

80106d7b <vector196>:
.globl vector196
vector196:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $196
80106d7d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106d82:	e9 97 f3 ff ff       	jmp    8010611e <alltraps>

80106d87 <vector197>:
.globl vector197
vector197:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $197
80106d89:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106d8e:	e9 8b f3 ff ff       	jmp    8010611e <alltraps>

80106d93 <vector198>:
.globl vector198
vector198:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $198
80106d95:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106d9a:	e9 7f f3 ff ff       	jmp    8010611e <alltraps>

80106d9f <vector199>:
.globl vector199
vector199:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $199
80106da1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106da6:	e9 73 f3 ff ff       	jmp    8010611e <alltraps>

80106dab <vector200>:
.globl vector200
vector200:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $200
80106dad:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106db2:	e9 67 f3 ff ff       	jmp    8010611e <alltraps>

80106db7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $201
80106db9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dbe:	e9 5b f3 ff ff       	jmp    8010611e <alltraps>

80106dc3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $202
80106dc5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dca:	e9 4f f3 ff ff       	jmp    8010611e <alltraps>

80106dcf <vector203>:
.globl vector203
vector203:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $203
80106dd1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106dd6:	e9 43 f3 ff ff       	jmp    8010611e <alltraps>

80106ddb <vector204>:
.globl vector204
vector204:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $204
80106ddd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106de2:	e9 37 f3 ff ff       	jmp    8010611e <alltraps>

80106de7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $205
80106de9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106dee:	e9 2b f3 ff ff       	jmp    8010611e <alltraps>

80106df3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $206
80106df5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106dfa:	e9 1f f3 ff ff       	jmp    8010611e <alltraps>

80106dff <vector207>:
.globl vector207
vector207:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $207
80106e01:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e06:	e9 13 f3 ff ff       	jmp    8010611e <alltraps>

80106e0b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $208
80106e0d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e12:	e9 07 f3 ff ff       	jmp    8010611e <alltraps>

80106e17 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $209
80106e19:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e1e:	e9 fb f2 ff ff       	jmp    8010611e <alltraps>

80106e23 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $210
80106e25:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e2a:	e9 ef f2 ff ff       	jmp    8010611e <alltraps>

80106e2f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $211
80106e31:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e36:	e9 e3 f2 ff ff       	jmp    8010611e <alltraps>

80106e3b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $212
80106e3d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e42:	e9 d7 f2 ff ff       	jmp    8010611e <alltraps>

80106e47 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $213
80106e49:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e4e:	e9 cb f2 ff ff       	jmp    8010611e <alltraps>

80106e53 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $214
80106e55:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e5a:	e9 bf f2 ff ff       	jmp    8010611e <alltraps>

80106e5f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $215
80106e61:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e66:	e9 b3 f2 ff ff       	jmp    8010611e <alltraps>

80106e6b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $216
80106e6d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106e72:	e9 a7 f2 ff ff       	jmp    8010611e <alltraps>

80106e77 <vector217>:
.globl vector217
vector217:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $217
80106e79:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106e7e:	e9 9b f2 ff ff       	jmp    8010611e <alltraps>

80106e83 <vector218>:
.globl vector218
vector218:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $218
80106e85:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106e8a:	e9 8f f2 ff ff       	jmp    8010611e <alltraps>

80106e8f <vector219>:
.globl vector219
vector219:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $219
80106e91:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106e96:	e9 83 f2 ff ff       	jmp    8010611e <alltraps>

80106e9b <vector220>:
.globl vector220
vector220:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $220
80106e9d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ea2:	e9 77 f2 ff ff       	jmp    8010611e <alltraps>

80106ea7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $221
80106ea9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106eae:	e9 6b f2 ff ff       	jmp    8010611e <alltraps>

80106eb3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $222
80106eb5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eba:	e9 5f f2 ff ff       	jmp    8010611e <alltraps>

80106ebf <vector223>:
.globl vector223
vector223:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $223
80106ec1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ec6:	e9 53 f2 ff ff       	jmp    8010611e <alltraps>

80106ecb <vector224>:
.globl vector224
vector224:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $224
80106ecd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106ed2:	e9 47 f2 ff ff       	jmp    8010611e <alltraps>

80106ed7 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $225
80106ed9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106ede:	e9 3b f2 ff ff       	jmp    8010611e <alltraps>

80106ee3 <vector226>:
.globl vector226
vector226:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $226
80106ee5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106eea:	e9 2f f2 ff ff       	jmp    8010611e <alltraps>

80106eef <vector227>:
.globl vector227
vector227:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $227
80106ef1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ef6:	e9 23 f2 ff ff       	jmp    8010611e <alltraps>

80106efb <vector228>:
.globl vector228
vector228:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $228
80106efd:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f02:	e9 17 f2 ff ff       	jmp    8010611e <alltraps>

80106f07 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $229
80106f09:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f0e:	e9 0b f2 ff ff       	jmp    8010611e <alltraps>

80106f13 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $230
80106f15:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f1a:	e9 ff f1 ff ff       	jmp    8010611e <alltraps>

80106f1f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $231
80106f21:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f26:	e9 f3 f1 ff ff       	jmp    8010611e <alltraps>

80106f2b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $232
80106f2d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f32:	e9 e7 f1 ff ff       	jmp    8010611e <alltraps>

80106f37 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $233
80106f39:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f3e:	e9 db f1 ff ff       	jmp    8010611e <alltraps>

80106f43 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $234
80106f45:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f4a:	e9 cf f1 ff ff       	jmp    8010611e <alltraps>

80106f4f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $235
80106f51:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f56:	e9 c3 f1 ff ff       	jmp    8010611e <alltraps>

80106f5b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $236
80106f5d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f62:	e9 b7 f1 ff ff       	jmp    8010611e <alltraps>

80106f67 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $237
80106f69:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f6e:	e9 ab f1 ff ff       	jmp    8010611e <alltraps>

80106f73 <vector238>:
.globl vector238
vector238:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $238
80106f75:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106f7a:	e9 9f f1 ff ff       	jmp    8010611e <alltraps>

80106f7f <vector239>:
.globl vector239
vector239:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $239
80106f81:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106f86:	e9 93 f1 ff ff       	jmp    8010611e <alltraps>

80106f8b <vector240>:
.globl vector240
vector240:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $240
80106f8d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106f92:	e9 87 f1 ff ff       	jmp    8010611e <alltraps>

80106f97 <vector241>:
.globl vector241
vector241:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $241
80106f99:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106f9e:	e9 7b f1 ff ff       	jmp    8010611e <alltraps>

80106fa3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $242
80106fa5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106faa:	e9 6f f1 ff ff       	jmp    8010611e <alltraps>

80106faf <vector243>:
.globl vector243
vector243:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $243
80106fb1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fb6:	e9 63 f1 ff ff       	jmp    8010611e <alltraps>

80106fbb <vector244>:
.globl vector244
vector244:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $244
80106fbd:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106fc2:	e9 57 f1 ff ff       	jmp    8010611e <alltraps>

80106fc7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $245
80106fc9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106fce:	e9 4b f1 ff ff       	jmp    8010611e <alltraps>

80106fd3 <vector246>:
.globl vector246
vector246:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $246
80106fd5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106fda:	e9 3f f1 ff ff       	jmp    8010611e <alltraps>

80106fdf <vector247>:
.globl vector247
vector247:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $247
80106fe1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106fe6:	e9 33 f1 ff ff       	jmp    8010611e <alltraps>

80106feb <vector248>:
.globl vector248
vector248:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $248
80106fed:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106ff2:	e9 27 f1 ff ff       	jmp    8010611e <alltraps>

80106ff7 <vector249>:
.globl vector249
vector249:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $249
80106ff9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106ffe:	e9 1b f1 ff ff       	jmp    8010611e <alltraps>

80107003 <vector250>:
.globl vector250
vector250:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $250
80107005:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010700a:	e9 0f f1 ff ff       	jmp    8010611e <alltraps>

8010700f <vector251>:
.globl vector251
vector251:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $251
80107011:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107016:	e9 03 f1 ff ff       	jmp    8010611e <alltraps>

8010701b <vector252>:
.globl vector252
vector252:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $252
8010701d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107022:	e9 f7 f0 ff ff       	jmp    8010611e <alltraps>

80107027 <vector253>:
.globl vector253
vector253:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $253
80107029:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010702e:	e9 eb f0 ff ff       	jmp    8010611e <alltraps>

80107033 <vector254>:
.globl vector254
vector254:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $254
80107035:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010703a:	e9 df f0 ff ff       	jmp    8010611e <alltraps>

8010703f <vector255>:
.globl vector255
vector255:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $255
80107041:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107046:	e9 d3 f0 ff ff       	jmp    8010611e <alltraps>
8010704b:	66 90                	xchg   %ax,%ax
8010704d:	66 90                	xchg   %ax,%ax
8010704f:	90                   	nop

80107050 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107050:	55                   	push   %ebp
80107051:	89 e5                	mov    %esp,%ebp
80107053:	57                   	push   %edi
80107054:	56                   	push   %esi
80107055:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107057:	c1 ea 16             	shr    $0x16,%edx
{
8010705a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010705b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010705e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107061:	8b 1f                	mov    (%edi),%ebx
80107063:	f6 c3 01             	test   $0x1,%bl
80107066:	74 28                	je     80107090 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107068:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010706e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107074:	89 f0                	mov    %esi,%eax
}
80107076:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107079:	c1 e8 0a             	shr    $0xa,%eax
8010707c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107081:	01 d8                	add    %ebx,%eax
}
80107083:	5b                   	pop    %ebx
80107084:	5e                   	pop    %esi
80107085:	5f                   	pop    %edi
80107086:	5d                   	pop    %ebp
80107087:	c3                   	ret    
80107088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010708f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107090:	85 c9                	test   %ecx,%ecx
80107092:	74 2c                	je     801070c0 <walkpgdir+0x70>
80107094:	e8 97 b5 ff ff       	call   80102630 <kalloc>
80107099:	89 c3                	mov    %eax,%ebx
8010709b:	85 c0                	test   %eax,%eax
8010709d:	74 21                	je     801070c0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010709f:	83 ec 04             	sub    $0x4,%esp
801070a2:	68 00 10 00 00       	push   $0x1000
801070a7:	6a 00                	push   $0x0
801070a9:	50                   	push   %eax
801070aa:	e8 21 d6 ff ff       	call   801046d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070af:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070b5:	83 c4 10             	add    $0x10,%esp
801070b8:	83 c8 07             	or     $0x7,%eax
801070bb:	89 07                	mov    %eax,(%edi)
801070bd:	eb b5                	jmp    80107074 <walkpgdir+0x24>
801070bf:	90                   	nop
}
801070c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801070c3:	31 c0                	xor    %eax,%eax
}
801070c5:	5b                   	pop    %ebx
801070c6:	5e                   	pop    %esi
801070c7:	5f                   	pop    %edi
801070c8:	5d                   	pop    %ebp
801070c9:	c3                   	ret    
801070ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070d6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801070da:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801070e0:	89 d6                	mov    %edx,%esi
{
801070e2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801070e3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801070e9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801070ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070ef:	8b 45 08             	mov    0x8(%ebp),%eax
801070f2:	29 f0                	sub    %esi,%eax
801070f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801070f7:	eb 1f                	jmp    80107118 <mappages+0x48>
801070f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107100:	f6 00 01             	testb  $0x1,(%eax)
80107103:	75 45                	jne    8010714a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107105:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107108:	83 cb 01             	or     $0x1,%ebx
8010710b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010710d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107110:	74 2e                	je     80107140 <mappages+0x70>
      break;
    a += PGSIZE;
80107112:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107118:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010711b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107120:	89 f2                	mov    %esi,%edx
80107122:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107125:	89 f8                	mov    %edi,%eax
80107127:	e8 24 ff ff ff       	call   80107050 <walkpgdir>
8010712c:	85 c0                	test   %eax,%eax
8010712e:	75 d0                	jne    80107100 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107130:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107138:	5b                   	pop    %ebx
80107139:	5e                   	pop    %esi
8010713a:	5f                   	pop    %edi
8010713b:	5d                   	pop    %ebp
8010713c:	c3                   	ret    
8010713d:	8d 76 00             	lea    0x0(%esi),%esi
80107140:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107143:	31 c0                	xor    %eax,%eax
}
80107145:	5b                   	pop    %ebx
80107146:	5e                   	pop    %esi
80107147:	5f                   	pop    %edi
80107148:	5d                   	pop    %ebp
80107149:	c3                   	ret    
      panic("remap");
8010714a:	83 ec 0c             	sub    $0xc,%esp
8010714d:	68 4c 83 10 80       	push   $0x8010834c
80107152:	e8 39 92 ff ff       	call   80100390 <panic>
80107157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010715e:	66 90                	xchg   %ax,%ax

80107160 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	57                   	push   %edi
80107164:	56                   	push   %esi
80107165:	89 c6                	mov    %eax,%esi
80107167:	53                   	push   %ebx
80107168:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010716a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107170:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107176:	83 ec 1c             	sub    $0x1c,%esp
80107179:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010717c:	39 da                	cmp    %ebx,%edx
8010717e:	73 5b                	jae    801071db <deallocuvm.part.0+0x7b>
80107180:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107183:	89 d7                	mov    %edx,%edi
80107185:	eb 14                	jmp    8010719b <deallocuvm.part.0+0x3b>
80107187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718e:	66 90                	xchg   %ax,%ax
80107190:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107196:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107199:	76 40                	jbe    801071db <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010719b:	31 c9                	xor    %ecx,%ecx
8010719d:	89 fa                	mov    %edi,%edx
8010719f:	89 f0                	mov    %esi,%eax
801071a1:	e8 aa fe ff ff       	call   80107050 <walkpgdir>
801071a6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801071a8:	85 c0                	test   %eax,%eax
801071aa:	74 44                	je     801071f0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071ac:	8b 00                	mov    (%eax),%eax
801071ae:	a8 01                	test   $0x1,%al
801071b0:	74 de                	je     80107190 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071b7:	74 47                	je     80107200 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801071b9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801071bc:	05 00 00 00 80       	add    $0x80000000,%eax
801071c1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801071c7:	50                   	push   %eax
801071c8:	e8 a3 b2 ff ff       	call   80102470 <kfree>
      *pte = 0;
801071cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801071d3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801071d6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801071d9:	77 c0                	ja     8010719b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801071db:	8b 45 e0             	mov    -0x20(%ebp),%eax
801071de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071e1:	5b                   	pop    %ebx
801071e2:	5e                   	pop    %esi
801071e3:	5f                   	pop    %edi
801071e4:	5d                   	pop    %ebp
801071e5:	c3                   	ret    
801071e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071ed:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801071f0:	89 fa                	mov    %edi,%edx
801071f2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801071f8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801071fe:	eb 96                	jmp    80107196 <deallocuvm.part.0+0x36>
        panic("kfree");
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	68 06 7c 10 80       	push   $0x80107c06
80107208:	e8 83 91 ff ff       	call   80100390 <panic>
8010720d:	8d 76 00             	lea    0x0(%esi),%esi

80107210 <seginit>:
{
80107210:	f3 0f 1e fb          	endbr32 
80107214:	55                   	push   %ebp
80107215:	89 e5                	mov    %esp,%ebp
80107217:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010721a:	e8 41 c7 ff ff       	call   80103960 <cpuid>
  pd[0] = size-1;
8010721f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107224:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010722a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010722e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107235:	ff 00 00 
80107238:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010723f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107242:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107249:	ff 00 00 
8010724c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107253:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107256:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
8010725d:	ff 00 00 
80107260:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107267:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010726a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80107271:	ff 00 00 
80107274:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
8010727b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010727e:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80107283:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107287:	c1 e8 10             	shr    $0x10,%eax
8010728a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010728e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107291:	0f 01 10             	lgdtl  (%eax)
}
80107294:	c9                   	leave  
80107295:	c3                   	ret    
80107296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010729d:	8d 76 00             	lea    0x0(%esi),%esi

801072a0 <switchkvm>:
{
801072a0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072a4:	a1 a4 7e 11 80       	mov    0x80117ea4,%eax
801072a9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072ae:	0f 22 d8             	mov    %eax,%cr3
}
801072b1:	c3                   	ret    
801072b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072c0 <switchuvm>:
{
801072c0:	f3 0f 1e fb          	endbr32 
801072c4:	55                   	push   %ebp
801072c5:	89 e5                	mov    %esp,%ebp
801072c7:	57                   	push   %edi
801072c8:	56                   	push   %esi
801072c9:	53                   	push   %ebx
801072ca:	83 ec 1c             	sub    $0x1c,%esp
801072cd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801072d0:	85 f6                	test   %esi,%esi
801072d2:	0f 84 cb 00 00 00    	je     801073a3 <switchuvm+0xe3>
  if(p->kstack == 0)
801072d8:	8b 46 08             	mov    0x8(%esi),%eax
801072db:	85 c0                	test   %eax,%eax
801072dd:	0f 84 da 00 00 00    	je     801073bd <switchuvm+0xfd>
  if(p->pgdir == 0)
801072e3:	8b 46 04             	mov    0x4(%esi),%eax
801072e6:	85 c0                	test   %eax,%eax
801072e8:	0f 84 c2 00 00 00    	je     801073b0 <switchuvm+0xf0>
  pushcli();
801072ee:	e8 cd d1 ff ff       	call   801044c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801072f3:	e8 f8 c5 ff ff       	call   801038f0 <mycpu>
801072f8:	89 c3                	mov    %eax,%ebx
801072fa:	e8 f1 c5 ff ff       	call   801038f0 <mycpu>
801072ff:	89 c7                	mov    %eax,%edi
80107301:	e8 ea c5 ff ff       	call   801038f0 <mycpu>
80107306:	83 c7 08             	add    $0x8,%edi
80107309:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010730c:	e8 df c5 ff ff       	call   801038f0 <mycpu>
80107311:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107314:	ba 67 00 00 00       	mov    $0x67,%edx
80107319:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107320:	83 c0 08             	add    $0x8,%eax
80107323:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010732a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010732f:	83 c1 08             	add    $0x8,%ecx
80107332:	c1 e8 18             	shr    $0x18,%eax
80107335:	c1 e9 10             	shr    $0x10,%ecx
80107338:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010733e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107344:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107349:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107350:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107355:	e8 96 c5 ff ff       	call   801038f0 <mycpu>
8010735a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107361:	e8 8a c5 ff ff       	call   801038f0 <mycpu>
80107366:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010736a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010736d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107373:	e8 78 c5 ff ff       	call   801038f0 <mycpu>
80107378:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010737b:	e8 70 c5 ff ff       	call   801038f0 <mycpu>
80107380:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107384:	b8 28 00 00 00       	mov    $0x28,%eax
80107389:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010738c:	8b 46 04             	mov    0x4(%esi),%eax
8010738f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107394:	0f 22 d8             	mov    %eax,%cr3
}
80107397:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010739a:	5b                   	pop    %ebx
8010739b:	5e                   	pop    %esi
8010739c:	5f                   	pop    %edi
8010739d:	5d                   	pop    %ebp
  popcli();
8010739e:	e9 6d d1 ff ff       	jmp    80104510 <popcli>
    panic("switchuvm: no process");
801073a3:	83 ec 0c             	sub    $0xc,%esp
801073a6:	68 52 83 10 80       	push   $0x80108352
801073ab:	e8 e0 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801073b0:	83 ec 0c             	sub    $0xc,%esp
801073b3:	68 7d 83 10 80       	push   $0x8010837d
801073b8:	e8 d3 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801073bd:	83 ec 0c             	sub    $0xc,%esp
801073c0:	68 68 83 10 80       	push   $0x80108368
801073c5:	e8 c6 8f ff ff       	call   80100390 <panic>
801073ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073d0 <inituvm>:
{
801073d0:	f3 0f 1e fb          	endbr32 
801073d4:	55                   	push   %ebp
801073d5:	89 e5                	mov    %esp,%ebp
801073d7:	57                   	push   %edi
801073d8:	56                   	push   %esi
801073d9:	53                   	push   %ebx
801073da:	83 ec 1c             	sub    $0x1c,%esp
801073dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801073e0:	8b 75 10             	mov    0x10(%ebp),%esi
801073e3:	8b 7d 08             	mov    0x8(%ebp),%edi
801073e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801073e9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801073ef:	77 4b                	ja     8010743c <inituvm+0x6c>
  mem = kalloc();
801073f1:	e8 3a b2 ff ff       	call   80102630 <kalloc>
  memset(mem, 0, PGSIZE);
801073f6:	83 ec 04             	sub    $0x4,%esp
801073f9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801073fe:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107400:	6a 00                	push   $0x0
80107402:	50                   	push   %eax
80107403:	e8 c8 d2 ff ff       	call   801046d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107408:	58                   	pop    %eax
80107409:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010740f:	5a                   	pop    %edx
80107410:	6a 06                	push   $0x6
80107412:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107417:	31 d2                	xor    %edx,%edx
80107419:	50                   	push   %eax
8010741a:	89 f8                	mov    %edi,%eax
8010741c:	e8 af fc ff ff       	call   801070d0 <mappages>
  memmove(mem, init, sz);
80107421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107424:	89 75 10             	mov    %esi,0x10(%ebp)
80107427:	83 c4 10             	add    $0x10,%esp
8010742a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010742d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107430:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107433:	5b                   	pop    %ebx
80107434:	5e                   	pop    %esi
80107435:	5f                   	pop    %edi
80107436:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107437:	e9 34 d3 ff ff       	jmp    80104770 <memmove>
    panic("inituvm: more than a page");
8010743c:	83 ec 0c             	sub    $0xc,%esp
8010743f:	68 91 83 10 80       	push   $0x80108391
80107444:	e8 47 8f ff ff       	call   80100390 <panic>
80107449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107450 <loaduvm>:
{
80107450:	f3 0f 1e fb          	endbr32 
80107454:	55                   	push   %ebp
80107455:	89 e5                	mov    %esp,%ebp
80107457:	57                   	push   %edi
80107458:	56                   	push   %esi
80107459:	53                   	push   %ebx
8010745a:	83 ec 1c             	sub    $0x1c,%esp
8010745d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107460:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107463:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107468:	0f 85 99 00 00 00    	jne    80107507 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010746e:	01 f0                	add    %esi,%eax
80107470:	89 f3                	mov    %esi,%ebx
80107472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107475:	8b 45 14             	mov    0x14(%ebp),%eax
80107478:	01 f0                	add    %esi,%eax
8010747a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010747d:	85 f6                	test   %esi,%esi
8010747f:	75 15                	jne    80107496 <loaduvm+0x46>
80107481:	eb 6d                	jmp    801074f0 <loaduvm+0xa0>
80107483:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107487:	90                   	nop
80107488:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010748e:	89 f0                	mov    %esi,%eax
80107490:	29 d8                	sub    %ebx,%eax
80107492:	39 c6                	cmp    %eax,%esi
80107494:	76 5a                	jbe    801074f0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107496:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107499:	8b 45 08             	mov    0x8(%ebp),%eax
8010749c:	31 c9                	xor    %ecx,%ecx
8010749e:	29 da                	sub    %ebx,%edx
801074a0:	e8 ab fb ff ff       	call   80107050 <walkpgdir>
801074a5:	85 c0                	test   %eax,%eax
801074a7:	74 51                	je     801074fa <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801074a9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074ae:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074b8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801074be:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074c1:	29 d9                	sub    %ebx,%ecx
801074c3:	05 00 00 00 80       	add    $0x80000000,%eax
801074c8:	57                   	push   %edi
801074c9:	51                   	push   %ecx
801074ca:	50                   	push   %eax
801074cb:	ff 75 10             	pushl  0x10(%ebp)
801074ce:	e8 8d a5 ff ff       	call   80101a60 <readi>
801074d3:	83 c4 10             	add    $0x10,%esp
801074d6:	39 f8                	cmp    %edi,%eax
801074d8:	74 ae                	je     80107488 <loaduvm+0x38>
}
801074da:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801074dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074e2:	5b                   	pop    %ebx
801074e3:	5e                   	pop    %esi
801074e4:	5f                   	pop    %edi
801074e5:	5d                   	pop    %ebp
801074e6:	c3                   	ret    
801074e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ee:	66 90                	xchg   %ax,%ax
801074f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801074f3:	31 c0                	xor    %eax,%eax
}
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
      panic("loaduvm: address should exist");
801074fa:	83 ec 0c             	sub    $0xc,%esp
801074fd:	68 ab 83 10 80       	push   $0x801083ab
80107502:	e8 89 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107507:	83 ec 0c             	sub    $0xc,%esp
8010750a:	68 4c 84 10 80       	push   $0x8010844c
8010750f:	e8 7c 8e ff ff       	call   80100390 <panic>
80107514:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010751f:	90                   	nop

80107520 <allocuvm>:
{
80107520:	f3 0f 1e fb          	endbr32 
80107524:	55                   	push   %ebp
80107525:	89 e5                	mov    %esp,%ebp
80107527:	57                   	push   %edi
80107528:	56                   	push   %esi
80107529:	53                   	push   %ebx
8010752a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010752d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107530:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107533:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107536:	85 c0                	test   %eax,%eax
80107538:	0f 88 b2 00 00 00    	js     801075f0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010753e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107541:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107544:	0f 82 96 00 00 00    	jb     801075e0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010754a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107550:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107556:	39 75 10             	cmp    %esi,0x10(%ebp)
80107559:	77 40                	ja     8010759b <allocuvm+0x7b>
8010755b:	e9 83 00 00 00       	jmp    801075e3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107560:	83 ec 04             	sub    $0x4,%esp
80107563:	68 00 10 00 00       	push   $0x1000
80107568:	6a 00                	push   $0x0
8010756a:	50                   	push   %eax
8010756b:	e8 60 d1 ff ff       	call   801046d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107570:	58                   	pop    %eax
80107571:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107577:	5a                   	pop    %edx
80107578:	6a 06                	push   $0x6
8010757a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010757f:	89 f2                	mov    %esi,%edx
80107581:	50                   	push   %eax
80107582:	89 f8                	mov    %edi,%eax
80107584:	e8 47 fb ff ff       	call   801070d0 <mappages>
80107589:	83 c4 10             	add    $0x10,%esp
8010758c:	85 c0                	test   %eax,%eax
8010758e:	78 78                	js     80107608 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107590:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107596:	39 75 10             	cmp    %esi,0x10(%ebp)
80107599:	76 48                	jbe    801075e3 <allocuvm+0xc3>
    mem = kalloc();
8010759b:	e8 90 b0 ff ff       	call   80102630 <kalloc>
801075a0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075a2:	85 c0                	test   %eax,%eax
801075a4:	75 ba                	jne    80107560 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	68 c9 83 10 80       	push   $0x801083c9
801075ae:	e8 fd 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801075b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801075b6:	83 c4 10             	add    $0x10,%esp
801075b9:	39 45 10             	cmp    %eax,0x10(%ebp)
801075bc:	74 32                	je     801075f0 <allocuvm+0xd0>
801075be:	8b 55 10             	mov    0x10(%ebp),%edx
801075c1:	89 c1                	mov    %eax,%ecx
801075c3:	89 f8                	mov    %edi,%eax
801075c5:	e8 96 fb ff ff       	call   80107160 <deallocuvm.part.0>
      return 0;
801075ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075d7:	5b                   	pop    %ebx
801075d8:	5e                   	pop    %esi
801075d9:	5f                   	pop    %edi
801075da:	5d                   	pop    %ebp
801075db:	c3                   	ret    
801075dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801075e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801075e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075e9:	5b                   	pop    %ebx
801075ea:	5e                   	pop    %esi
801075eb:	5f                   	pop    %edi
801075ec:	5d                   	pop    %ebp
801075ed:	c3                   	ret    
801075ee:	66 90                	xchg   %ax,%ax
    return 0;
801075f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801075f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075fd:	5b                   	pop    %ebx
801075fe:	5e                   	pop    %esi
801075ff:	5f                   	pop    %edi
80107600:	5d                   	pop    %ebp
80107601:	c3                   	ret    
80107602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107608:	83 ec 0c             	sub    $0xc,%esp
8010760b:	68 e1 83 10 80       	push   $0x801083e1
80107610:	e8 9b 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107615:	8b 45 0c             	mov    0xc(%ebp),%eax
80107618:	83 c4 10             	add    $0x10,%esp
8010761b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010761e:	74 0c                	je     8010762c <allocuvm+0x10c>
80107620:	8b 55 10             	mov    0x10(%ebp),%edx
80107623:	89 c1                	mov    %eax,%ecx
80107625:	89 f8                	mov    %edi,%eax
80107627:	e8 34 fb ff ff       	call   80107160 <deallocuvm.part.0>
      kfree(mem);
8010762c:	83 ec 0c             	sub    $0xc,%esp
8010762f:	53                   	push   %ebx
80107630:	e8 3b ae ff ff       	call   80102470 <kfree>
      return 0;
80107635:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010763c:	83 c4 10             	add    $0x10,%esp
}
8010763f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107642:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107645:	5b                   	pop    %ebx
80107646:	5e                   	pop    %esi
80107647:	5f                   	pop    %edi
80107648:	5d                   	pop    %ebp
80107649:	c3                   	ret    
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107650 <deallocuvm>:
{
80107650:	f3 0f 1e fb          	endbr32 
80107654:	55                   	push   %ebp
80107655:	89 e5                	mov    %esp,%ebp
80107657:	8b 55 0c             	mov    0xc(%ebp),%edx
8010765a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010765d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107660:	39 d1                	cmp    %edx,%ecx
80107662:	73 0c                	jae    80107670 <deallocuvm+0x20>
}
80107664:	5d                   	pop    %ebp
80107665:	e9 f6 fa ff ff       	jmp    80107160 <deallocuvm.part.0>
8010766a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107670:	89 d0                	mov    %edx,%eax
80107672:	5d                   	pop    %ebp
80107673:	c3                   	ret    
80107674:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010767b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010767f:	90                   	nop

80107680 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107680:	f3 0f 1e fb          	endbr32 
80107684:	55                   	push   %ebp
80107685:	89 e5                	mov    %esp,%ebp
80107687:	57                   	push   %edi
80107688:	56                   	push   %esi
80107689:	53                   	push   %ebx
8010768a:	83 ec 0c             	sub    $0xc,%esp
8010768d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107690:	85 f6                	test   %esi,%esi
80107692:	74 55                	je     801076e9 <freevm+0x69>
  if(newsz >= oldsz)
80107694:	31 c9                	xor    %ecx,%ecx
80107696:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010769b:	89 f0                	mov    %esi,%eax
8010769d:	89 f3                	mov    %esi,%ebx
8010769f:	e8 bc fa ff ff       	call   80107160 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076a4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076aa:	eb 0b                	jmp    801076b7 <freevm+0x37>
801076ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076b0:	83 c3 04             	add    $0x4,%ebx
801076b3:	39 df                	cmp    %ebx,%edi
801076b5:	74 23                	je     801076da <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076b7:	8b 03                	mov    (%ebx),%eax
801076b9:	a8 01                	test   $0x1,%al
801076bb:	74 f3                	je     801076b0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076bd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076c2:	83 ec 0c             	sub    $0xc,%esp
801076c5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076c8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076cd:	50                   	push   %eax
801076ce:	e8 9d ad ff ff       	call   80102470 <kfree>
801076d3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801076d6:	39 df                	cmp    %ebx,%edi
801076d8:	75 dd                	jne    801076b7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801076da:	89 75 08             	mov    %esi,0x8(%ebp)
}
801076dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076e0:	5b                   	pop    %ebx
801076e1:	5e                   	pop    %esi
801076e2:	5f                   	pop    %edi
801076e3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801076e4:	e9 87 ad ff ff       	jmp    80102470 <kfree>
    panic("freevm: no pgdir");
801076e9:	83 ec 0c             	sub    $0xc,%esp
801076ec:	68 fd 83 10 80       	push   $0x801083fd
801076f1:	e8 9a 8c ff ff       	call   80100390 <panic>
801076f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fd:	8d 76 00             	lea    0x0(%esi),%esi

80107700 <setupkvm>:
{
80107700:	f3 0f 1e fb          	endbr32 
80107704:	55                   	push   %ebp
80107705:	89 e5                	mov    %esp,%ebp
80107707:	56                   	push   %esi
80107708:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107709:	e8 22 af ff ff       	call   80102630 <kalloc>
8010770e:	89 c6                	mov    %eax,%esi
80107710:	85 c0                	test   %eax,%eax
80107712:	74 42                	je     80107756 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107714:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107717:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010771c:	68 00 10 00 00       	push   $0x1000
80107721:	6a 00                	push   $0x0
80107723:	50                   	push   %eax
80107724:	e8 a7 cf ff ff       	call   801046d0 <memset>
80107729:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010772c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010772f:	83 ec 08             	sub    $0x8,%esp
80107732:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107735:	ff 73 0c             	pushl  0xc(%ebx)
80107738:	8b 13                	mov    (%ebx),%edx
8010773a:	50                   	push   %eax
8010773b:	29 c1                	sub    %eax,%ecx
8010773d:	89 f0                	mov    %esi,%eax
8010773f:	e8 8c f9 ff ff       	call   801070d0 <mappages>
80107744:	83 c4 10             	add    $0x10,%esp
80107747:	85 c0                	test   %eax,%eax
80107749:	78 15                	js     80107760 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010774b:	83 c3 10             	add    $0x10,%ebx
8010774e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107754:	75 d6                	jne    8010772c <setupkvm+0x2c>
}
80107756:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107759:	89 f0                	mov    %esi,%eax
8010775b:	5b                   	pop    %ebx
8010775c:	5e                   	pop    %esi
8010775d:	5d                   	pop    %ebp
8010775e:	c3                   	ret    
8010775f:	90                   	nop
      freevm(pgdir);
80107760:	83 ec 0c             	sub    $0xc,%esp
80107763:	56                   	push   %esi
      return 0;
80107764:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107766:	e8 15 ff ff ff       	call   80107680 <freevm>
      return 0;
8010776b:	83 c4 10             	add    $0x10,%esp
}
8010776e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107771:	89 f0                	mov    %esi,%eax
80107773:	5b                   	pop    %ebx
80107774:	5e                   	pop    %esi
80107775:	5d                   	pop    %ebp
80107776:	c3                   	ret    
80107777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010777e:	66 90                	xchg   %ax,%ax

80107780 <kvmalloc>:
{
80107780:	f3 0f 1e fb          	endbr32 
80107784:	55                   	push   %ebp
80107785:	89 e5                	mov    %esp,%ebp
80107787:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010778a:	e8 71 ff ff ff       	call   80107700 <setupkvm>
8010778f:	a3 a4 7e 11 80       	mov    %eax,0x80117ea4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107794:	05 00 00 00 80       	add    $0x80000000,%eax
80107799:	0f 22 d8             	mov    %eax,%cr3
}
8010779c:	c9                   	leave  
8010779d:	c3                   	ret    
8010779e:	66 90                	xchg   %ax,%ax

801077a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077a0:	f3 0f 1e fb          	endbr32 
801077a4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077a5:	31 c9                	xor    %ecx,%ecx
{
801077a7:	89 e5                	mov    %esp,%ebp
801077a9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077ac:	8b 55 0c             	mov    0xc(%ebp),%edx
801077af:	8b 45 08             	mov    0x8(%ebp),%eax
801077b2:	e8 99 f8 ff ff       	call   80107050 <walkpgdir>
  if(pte == 0)
801077b7:	85 c0                	test   %eax,%eax
801077b9:	74 05                	je     801077c0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077bb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077be:	c9                   	leave  
801077bf:	c3                   	ret    
    panic("clearpteu");
801077c0:	83 ec 0c             	sub    $0xc,%esp
801077c3:	68 0e 84 10 80       	push   $0x8010840e
801077c8:	e8 c3 8b ff ff       	call   80100390 <panic>
801077cd:	8d 76 00             	lea    0x0(%esi),%esi

801077d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801077d0:	f3 0f 1e fb          	endbr32 
801077d4:	55                   	push   %ebp
801077d5:	89 e5                	mov    %esp,%ebp
801077d7:	57                   	push   %edi
801077d8:	56                   	push   %esi
801077d9:	53                   	push   %ebx
801077da:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801077dd:	e8 1e ff ff ff       	call   80107700 <setupkvm>
801077e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801077e5:	85 c0                	test   %eax,%eax
801077e7:	0f 84 9b 00 00 00    	je     80107888 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801077ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801077f0:	85 c9                	test   %ecx,%ecx
801077f2:	0f 84 90 00 00 00    	je     80107888 <copyuvm+0xb8>
801077f8:	31 f6                	xor    %esi,%esi
801077fa:	eb 46                	jmp    80107842 <copyuvm+0x72>
801077fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107800:	83 ec 04             	sub    $0x4,%esp
80107803:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107809:	68 00 10 00 00       	push   $0x1000
8010780e:	57                   	push   %edi
8010780f:	50                   	push   %eax
80107810:	e8 5b cf ff ff       	call   80104770 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107815:	58                   	pop    %eax
80107816:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010781c:	5a                   	pop    %edx
8010781d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107820:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107825:	89 f2                	mov    %esi,%edx
80107827:	50                   	push   %eax
80107828:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010782b:	e8 a0 f8 ff ff       	call   801070d0 <mappages>
80107830:	83 c4 10             	add    $0x10,%esp
80107833:	85 c0                	test   %eax,%eax
80107835:	78 61                	js     80107898 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107837:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010783d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107840:	76 46                	jbe    80107888 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107842:	8b 45 08             	mov    0x8(%ebp),%eax
80107845:	31 c9                	xor    %ecx,%ecx
80107847:	89 f2                	mov    %esi,%edx
80107849:	e8 02 f8 ff ff       	call   80107050 <walkpgdir>
8010784e:	85 c0                	test   %eax,%eax
80107850:	74 61                	je     801078b3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107852:	8b 00                	mov    (%eax),%eax
80107854:	a8 01                	test   $0x1,%al
80107856:	74 4e                	je     801078a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107858:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010785a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010785f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107862:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107868:	e8 c3 ad ff ff       	call   80102630 <kalloc>
8010786d:	89 c3                	mov    %eax,%ebx
8010786f:	85 c0                	test   %eax,%eax
80107871:	75 8d                	jne    80107800 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107873:	83 ec 0c             	sub    $0xc,%esp
80107876:	ff 75 e0             	pushl  -0x20(%ebp)
80107879:	e8 02 fe ff ff       	call   80107680 <freevm>
  return 0;
8010787e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107885:	83 c4 10             	add    $0x10,%esp
}
80107888:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010788b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010788e:	5b                   	pop    %ebx
8010788f:	5e                   	pop    %esi
80107890:	5f                   	pop    %edi
80107891:	5d                   	pop    %ebp
80107892:	c3                   	ret    
80107893:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107897:	90                   	nop
      kfree(mem);
80107898:	83 ec 0c             	sub    $0xc,%esp
8010789b:	53                   	push   %ebx
8010789c:	e8 cf ab ff ff       	call   80102470 <kfree>
      goto bad;
801078a1:	83 c4 10             	add    $0x10,%esp
801078a4:	eb cd                	jmp    80107873 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801078a6:	83 ec 0c             	sub    $0xc,%esp
801078a9:	68 32 84 10 80       	push   $0x80108432
801078ae:	e8 dd 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801078b3:	83 ec 0c             	sub    $0xc,%esp
801078b6:	68 18 84 10 80       	push   $0x80108418
801078bb:	e8 d0 8a ff ff       	call   80100390 <panic>

801078c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078c0:	f3 0f 1e fb          	endbr32 
801078c4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078c5:	31 c9                	xor    %ecx,%ecx
{
801078c7:	89 e5                	mov    %esp,%ebp
801078c9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801078cf:	8b 45 08             	mov    0x8(%ebp),%eax
801078d2:	e8 79 f7 ff ff       	call   80107050 <walkpgdir>
  if((*pte & PTE_P) == 0)
801078d7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801078d9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801078da:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801078e1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801078e4:	05 00 00 00 80       	add    $0x80000000,%eax
801078e9:	83 fa 05             	cmp    $0x5,%edx
801078ec:	ba 00 00 00 00       	mov    $0x0,%edx
801078f1:	0f 45 c2             	cmovne %edx,%eax
}
801078f4:	c3                   	ret    
801078f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107900 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107900:	f3 0f 1e fb          	endbr32 
80107904:	55                   	push   %ebp
80107905:	89 e5                	mov    %esp,%ebp
80107907:	57                   	push   %edi
80107908:	56                   	push   %esi
80107909:	53                   	push   %ebx
8010790a:	83 ec 0c             	sub    $0xc,%esp
8010790d:	8b 75 14             	mov    0x14(%ebp),%esi
80107910:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107913:	85 f6                	test   %esi,%esi
80107915:	75 3c                	jne    80107953 <copyout+0x53>
80107917:	eb 67                	jmp    80107980 <copyout+0x80>
80107919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107920:	8b 55 0c             	mov    0xc(%ebp),%edx
80107923:	89 fb                	mov    %edi,%ebx
80107925:	29 d3                	sub    %edx,%ebx
80107927:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010792d:	39 f3                	cmp    %esi,%ebx
8010792f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107932:	29 fa                	sub    %edi,%edx
80107934:	83 ec 04             	sub    $0x4,%esp
80107937:	01 c2                	add    %eax,%edx
80107939:	53                   	push   %ebx
8010793a:	ff 75 10             	pushl  0x10(%ebp)
8010793d:	52                   	push   %edx
8010793e:	e8 2d ce ff ff       	call   80104770 <memmove>
    len -= n;
    buf += n;
80107943:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107946:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010794c:	83 c4 10             	add    $0x10,%esp
8010794f:	29 de                	sub    %ebx,%esi
80107951:	74 2d                	je     80107980 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107953:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107955:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107958:	89 55 0c             	mov    %edx,0xc(%ebp)
8010795b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107961:	57                   	push   %edi
80107962:	ff 75 08             	pushl  0x8(%ebp)
80107965:	e8 56 ff ff ff       	call   801078c0 <uva2ka>
    if(pa0 == 0)
8010796a:	83 c4 10             	add    $0x10,%esp
8010796d:	85 c0                	test   %eax,%eax
8010796f:	75 af                	jne    80107920 <copyout+0x20>
  }
  return 0;
}
80107971:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107979:	5b                   	pop    %ebx
8010797a:	5e                   	pop    %esi
8010797b:	5f                   	pop    %edi
8010797c:	5d                   	pop    %ebp
8010797d:	c3                   	ret    
8010797e:	66 90                	xchg   %ax,%ax
80107980:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107983:	31 c0                	xor    %eax,%eax
}
80107985:	5b                   	pop    %ebx
80107986:	5e                   	pop    %esi
80107987:	5f                   	pop    %edi
80107988:	5d                   	pop    %ebp
80107989:	c3                   	ret    
