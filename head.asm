
_head:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
            }
        }
    }
}

int main(int argc, char *argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 20             	sub    $0x20,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
    printf(1, "Head command is getting executed in user mode.\n");
  1d:	68 58 09 00 00       	push   $0x958
  22:	6a 01                	push   $0x1
  24:	e8 c7 05 00 00       	call   5f0 <printf>

    int nlines = DEFAULT_LINES;
    int arg_start = 1;
    

    if(argc > 1 && argv[1][0] == '-') {
  29:	83 c4 10             	add    $0x10,%esp
  2c:	83 fe 01             	cmp    $0x1,%esi
  2f:	0f 8e a9 00 00 00    	jle    de <main+0xde>
  35:	8b 47 04             	mov    0x4(%edi),%eax
  38:	80 38 2d             	cmpb   $0x2d,(%eax)
  3b:	0f 84 e8 00 00 00    	je     129 <main+0x129>
    int nlines = DEFAULT_LINES;
  41:	c7 45 e0 0e 00 00 00 	movl   $0xe,-0x20(%ebp)
    int arg_start = 1;
  48:	bb 01 00 00 00       	mov    $0x1,%ebx
  4d:	eb 37                	jmp    86 <main+0x86>
  4f:	90                   	nop
        for(int i = arg_start; i < argc; i++) {
            if(argc > 2) {
                printf(1, "==> %s <==\n", argv[i]);  // Print filename if more than one file is provided
            }

            int fd = open(argv[i], O_RDONLY);
  50:	83 ec 08             	sub    $0x8,%esp
  53:	6a 00                	push   $0x0
  55:	50                   	push   %eax
  56:	e8 68 04 00 00       	call   4c3 <open>
            if(fd < 0) {
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	85 c0                	test   %eax,%eax
  60:	78 4e                	js     b0 <main+0xb0>
                printf(2, "head: cannot open %s for reading\n", argv[i]);
                continue;
            }
            process_input(fd, nlines);
  62:	83 ec 08             	sub    $0x8,%esp
  65:	ff 75 e0             	pushl  -0x20(%ebp)
        for(int i = arg_start; i < argc; i++) {
  68:	83 c3 01             	add    $0x1,%ebx
            process_input(fd, nlines);
  6b:	50                   	push   %eax
  6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  6f:	e8 1c 01 00 00       	call   190 <process_input>
            close(fd);
  74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  77:	89 04 24             	mov    %eax,(%esp)
  7a:	e8 2c 04 00 00       	call   4ab <close>
  7f:	83 c4 10             	add    $0x10,%esp
        for(int i = arg_start; i < argc; i++) {
  82:	39 de                	cmp    %ebx,%esi
  84:	7e 46                	jle    cc <main+0xcc>
            if(argc > 2) {
  86:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  89:	83 fe 02             	cmp    $0x2,%esi
  8c:	74 c2                	je     50 <main+0x50>
                printf(1, "==> %s <==\n", argv[i]);  // Print filename if more than one file is provided
  8e:	83 ec 04             	sub    $0x4,%esp
  91:	50                   	push   %eax
  92:	68 aa 09 00 00       	push   $0x9aa
  97:	6a 01                	push   $0x1
  99:	e8 52 05 00 00       	call   5f0 <printf>
  9e:	8b 04 9f             	mov    (%edi,%ebx,4),%eax
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	eb aa                	jmp    50 <main+0x50>
  a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ad:	8d 76 00             	lea    0x0(%esi),%esi
                printf(2, "head: cannot open %s for reading\n", argv[i]);
  b0:	83 ec 04             	sub    $0x4,%esp
  b3:	ff 34 9f             	pushl  (%edi,%ebx,4)
        for(int i = arg_start; i < argc; i++) {
  b6:	83 c3 01             	add    $0x1,%ebx
                printf(2, "head: cannot open %s for reading\n", argv[i]);
  b9:	68 88 09 00 00       	push   $0x988
  be:	6a 02                	push   $0x2
  c0:	e8 2b 05 00 00       	call   5f0 <printf>
                continue;
  c5:	83 c4 10             	add    $0x10,%esp
        for(int i = arg_start; i < argc; i++) {
  c8:	39 de                	cmp    %ebx,%esi
  ca:	7f ba                	jg     86 <main+0x86>
        }
    }
     if(argc == 2 && argv[1][0] == '-'){
  cc:	83 fe 02             	cmp    $0x2,%esi
  cf:	74 2e                	je     ff <main+0xff>
	printf(1, "==> %s <==\n", argv[2]);
        head(argv[2], nlines);

    } else if (argc > 2 && argv[1][0] == '-' ){
  d1:	8b 47 04             	mov    0x4(%edi),%eax
  d4:	80 38 2d             	cmpb   $0x2d,(%eax)
  d7:	74 71                	je     14a <main+0x14a>
	printf(1, "==> %s <==\n", argv[3]);
	head(argv[3], nlines);

    }

    exit();
  d9:	e8 a5 03 00 00       	call   483 <exit>
    if(arg_start == argc) {
  de:	75 f9                	jne    d9 <main+0xd9>
        process_input(0, nlines);  // Read from standard input
  e0:	52                   	push   %edx
  e1:	52                   	push   %edx
  e2:	6a 0e                	push   $0xe
  e4:	6a 00                	push   $0x0
  e6:	e8 a5 00 00 00       	call   190 <process_input>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	eb e9                	jmp    d9 <main+0xd9>
  f0:	50                   	push   %eax
  f1:	50                   	push   %eax
  f2:	ff 75 e0             	pushl  -0x20(%ebp)
  f5:	6a 00                	push   $0x0
  f7:	e8 94 00 00 00       	call   190 <process_input>
  fc:	83 c4 10             	add    $0x10,%esp
     if(argc == 2 && argv[1][0] == '-'){
  ff:	8b 47 04             	mov    0x4(%edi),%eax
 102:	80 38 2d             	cmpb   $0x2d,(%eax)
 105:	75 d2                	jne    d9 <main+0xd9>
	printf(1, "==> %s <==\n", argv[2]);
 107:	51                   	push   %ecx
 108:	ff 77 08             	pushl  0x8(%edi)
 10b:	68 aa 09 00 00       	push   $0x9aa
 110:	6a 01                	push   $0x1
 112:	e8 d9 04 00 00       	call   5f0 <printf>
        head(argv[2], nlines);
 117:	5b                   	pop    %ebx
 118:	5e                   	pop    %esi
 119:	ff 75 e0             	pushl  -0x20(%ebp)
 11c:	ff 77 08             	pushl  0x8(%edi)
 11f:	e8 07 04 00 00       	call   52b <head>
 124:	83 c4 10             	add    $0x10,%esp
 127:	eb b0                	jmp    d9 <main+0xd9>
        nlines = atoi(&argv[1][1]);
 129:	83 ec 0c             	sub    $0xc,%esp
 12c:	83 c0 01             	add    $0x1,%eax
 12f:	50                   	push   %eax
 130:	e8 db 02 00 00       	call   410 <atoi>
    if(arg_start == argc) {
 135:	83 c4 10             	add    $0x10,%esp
        nlines = atoi(&argv[1][1]);
 138:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(arg_start == argc) {
 13b:	83 fe 02             	cmp    $0x2,%esi
 13e:	74 b0                	je     f0 <main+0xf0>
        arg_start = 2;
 140:	bb 02 00 00 00       	mov    $0x2,%ebx
 145:	e9 3c ff ff ff       	jmp    86 <main+0x86>
	printf(1, "==> %s <==\n", argv[2]);
 14a:	51                   	push   %ecx
 14b:	ff 77 08             	pushl  0x8(%edi)
 14e:	68 aa 09 00 00       	push   $0x9aa
 153:	6a 01                	push   $0x1
 155:	e8 96 04 00 00       	call   5f0 <printf>
        head(argv[2], nlines);
 15a:	5b                   	pop    %ebx
 15b:	5e                   	pop    %esi
 15c:	8b 75 e0             	mov    -0x20(%ebp),%esi
 15f:	56                   	push   %esi
 160:	ff 77 08             	pushl  0x8(%edi)
 163:	e8 c3 03 00 00       	call   52b <head>
	printf(1, "==> %s <==\n", argv[3]);
 168:	83 c4 0c             	add    $0xc,%esp
 16b:	ff 77 0c             	pushl  0xc(%edi)
 16e:	68 aa 09 00 00       	push   $0x9aa
 173:	6a 01                	push   $0x1
 175:	e8 76 04 00 00       	call   5f0 <printf>
	head(argv[3], nlines);
 17a:	58                   	pop    %eax
 17b:	5a                   	pop    %edx
 17c:	56                   	push   %esi
 17d:	ff 77 0c             	pushl  0xc(%edi)
 180:	e8 a6 03 00 00       	call   52b <head>
 185:	83 c4 10             	add    $0x10,%esp
 188:	e9 4c ff ff ff       	jmp    d9 <main+0xd9>
 18d:	66 90                	xchg   %ax,%ax
 18f:	90                   	nop

00000190 <process_input>:
void process_input(int fd, int nlines) {
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	56                   	push   %esi
 199:	53                   	push   %ebx
 19a:	81 ec 1c 02 00 00    	sub    $0x21c,%esp
    while(lines < nlines) {
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	85 c0                	test   %eax,%eax
 1a5:	7e 5f                	jle    206 <process_input+0x76>
    int i, lines = 0;
 1a7:	31 ff                	xor    %edi,%edi
 1a9:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
 1af:	90                   	nop
        int count = read(fd, buf, BUFSIZE);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	68 00 02 00 00       	push   $0x200
 1b8:	53                   	push   %ebx
 1b9:	ff 75 08             	pushl  0x8(%ebp)
 1bc:	e8 da 02 00 00       	call   49b <read>
        if(count <= 0) {
 1c1:	83 c4 10             	add    $0x10,%esp
        int count = read(fd, buf, BUFSIZE);
 1c4:	89 85 e4 fd ff ff    	mov    %eax,-0x21c(%ebp)
        if(count <= 0) {
 1ca:	85 c0                	test   %eax,%eax
 1cc:	7e 38                	jle    206 <process_input+0x76>
        for(i = 0; i < count && lines < nlines; i++) {
 1ce:	39 7d 0c             	cmp    %edi,0xc(%ebp)
 1d1:	7e 33                	jle    206 <process_input+0x76>
 1d3:	31 f6                	xor    %esi,%esi
 1d5:	8d 76 00             	lea    0x0(%esi),%esi
            write(1, &buf[i], 1);  // Write the character to stdout
 1d8:	83 ec 04             	sub    $0x4,%esp
 1db:	8d 04 33             	lea    (%ebx,%esi,1),%eax
 1de:	6a 01                	push   $0x1
 1e0:	50                   	push   %eax
 1e1:	6a 01                	push   $0x1
 1e3:	e8 bb 02 00 00       	call   4a3 <write>
                lines++;
 1e8:	31 c0                	xor    %eax,%eax
            if(buf[i] == '\n') {
 1ea:	83 c4 10             	add    $0x10,%esp
                lines++;
 1ed:	80 3c 33 0a          	cmpb   $0xa,(%ebx,%esi,1)
 1f1:	0f 94 c0             	sete   %al
        for(i = 0; i < count && lines < nlines; i++) {
 1f4:	83 c6 01             	add    $0x1,%esi
                lines++;
 1f7:	01 c7                	add    %eax,%edi
        for(i = 0; i < count && lines < nlines; i++) {
 1f9:	39 b5 e4 fd ff ff    	cmp    %esi,-0x21c(%ebp)
 1ff:	7e 0f                	jle    210 <process_input+0x80>
 201:	3b 7d 0c             	cmp    0xc(%ebp),%edi
 204:	7c d2                	jl     1d8 <process_input+0x48>
}
 206:	8d 65 f4             	lea    -0xc(%ebp),%esp
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5f                   	pop    %edi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    
 20e:	66 90                	xchg   %ax,%ax
    while(lines < nlines) {
 210:	3b 7d 0c             	cmp    0xc(%ebp),%edi
 213:	7c 9b                	jl     1b0 <process_input+0x20>
 215:	eb ef                	jmp    206 <process_input+0x76>
 217:	66 90                	xchg   %ax,%ax
 219:	66 90                	xchg   %ax,%ax
 21b:	66 90                	xchg   %ax,%ax
 21d:	66 90                	xchg   %ax,%ax
 21f:	90                   	nop

00000220 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 220:	f3 0f 1e fb          	endbr32 
 224:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 225:	31 c0                	xor    %eax,%eax
{
 227:	89 e5                	mov    %esp,%ebp
 229:	53                   	push   %ebx
 22a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 22d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 230:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 234:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 237:	83 c0 01             	add    $0x1,%eax
 23a:	84 d2                	test   %dl,%dl
 23c:	75 f2                	jne    230 <strcpy+0x10>
    ;
  return os;
}
 23e:	89 c8                	mov    %ecx,%eax
 240:	5b                   	pop    %ebx
 241:	5d                   	pop    %ebp
 242:	c3                   	ret    
 243:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000250 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 250:	f3 0f 1e fb          	endbr32 
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	53                   	push   %ebx
 258:	8b 4d 08             	mov    0x8(%ebp),%ecx
 25b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 25e:	0f b6 01             	movzbl (%ecx),%eax
 261:	0f b6 1a             	movzbl (%edx),%ebx
 264:	84 c0                	test   %al,%al
 266:	75 19                	jne    281 <strcmp+0x31>
 268:	eb 26                	jmp    290 <strcmp+0x40>
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 270:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 274:	83 c1 01             	add    $0x1,%ecx
 277:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 27a:	0f b6 1a             	movzbl (%edx),%ebx
 27d:	84 c0                	test   %al,%al
 27f:	74 0f                	je     290 <strcmp+0x40>
 281:	38 d8                	cmp    %bl,%al
 283:	74 eb                	je     270 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 285:	29 d8                	sub    %ebx,%eax
}
 287:	5b                   	pop    %ebx
 288:	5d                   	pop    %ebp
 289:	c3                   	ret    
 28a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 290:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 292:	29 d8                	sub    %ebx,%eax
}
 294:	5b                   	pop    %ebx
 295:	5d                   	pop    %ebp
 296:	c3                   	ret    
 297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strlen>:

uint
strlen(const char *s)
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2aa:	80 3a 00             	cmpb   $0x0,(%edx)
 2ad:	74 21                	je     2d0 <strlen+0x30>
 2af:	31 c0                	xor    %eax,%eax
 2b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2b8:	83 c0 01             	add    $0x1,%eax
 2bb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2bf:	89 c1                	mov    %eax,%ecx
 2c1:	75 f5                	jne    2b8 <strlen+0x18>
    ;
  return n;
}
 2c3:	89 c8                	mov    %ecx,%eax
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    
 2c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ce:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 2d0:	31 c9                	xor    %ecx,%ecx
}
 2d2:	5d                   	pop    %ebp
 2d3:	89 c8                	mov    %ecx,%eax
 2d5:	c3                   	ret    
 2d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2dd:	8d 76 00             	lea    0x0(%esi),%esi

000002e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2e0:	f3 0f 1e fb          	endbr32 
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	57                   	push   %edi
 2e8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2eb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f1:	89 d7                	mov    %edx,%edi
 2f3:	fc                   	cld    
 2f4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2f6:	89 d0                	mov    %edx,%eax
 2f8:	5f                   	pop    %edi
 2f9:	5d                   	pop    %ebp
 2fa:	c3                   	ret    
 2fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ff:	90                   	nop

00000300 <strchr>:

char*
strchr(const char *s, char c)
{
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 30e:	0f b6 10             	movzbl (%eax),%edx
 311:	84 d2                	test   %dl,%dl
 313:	75 16                	jne    32b <strchr+0x2b>
 315:	eb 21                	jmp    338 <strchr+0x38>
 317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31e:	66 90                	xchg   %ax,%ax
 320:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 324:	83 c0 01             	add    $0x1,%eax
 327:	84 d2                	test   %dl,%dl
 329:	74 0d                	je     338 <strchr+0x38>
    if(*s == c)
 32b:	38 d1                	cmp    %dl,%cl
 32d:	75 f1                	jne    320 <strchr+0x20>
      return (char*)s;
  return 0;
}
 32f:	5d                   	pop    %ebp
 330:	c3                   	ret    
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 338:	31 c0                	xor    %eax,%eax
}
 33a:	5d                   	pop    %ebp
 33b:	c3                   	ret    
 33c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000340 <gets>:

char*
gets(char *buf, int max)
{
 340:	f3 0f 1e fb          	endbr32 
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	57                   	push   %edi
 348:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 349:	31 f6                	xor    %esi,%esi
{
 34b:	53                   	push   %ebx
 34c:	89 f3                	mov    %esi,%ebx
 34e:	83 ec 1c             	sub    $0x1c,%esp
 351:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 354:	eb 33                	jmp    389 <gets+0x49>
 356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 360:	83 ec 04             	sub    $0x4,%esp
 363:	8d 45 e7             	lea    -0x19(%ebp),%eax
 366:	6a 01                	push   $0x1
 368:	50                   	push   %eax
 369:	6a 00                	push   $0x0
 36b:	e8 2b 01 00 00       	call   49b <read>
    if(cc < 1)
 370:	83 c4 10             	add    $0x10,%esp
 373:	85 c0                	test   %eax,%eax
 375:	7e 1c                	jle    393 <gets+0x53>
      break;
    buf[i++] = c;
 377:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 37b:	83 c7 01             	add    $0x1,%edi
 37e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 381:	3c 0a                	cmp    $0xa,%al
 383:	74 23                	je     3a8 <gets+0x68>
 385:	3c 0d                	cmp    $0xd,%al
 387:	74 1f                	je     3a8 <gets+0x68>
  for(i=0; i+1 < max; ){
 389:	83 c3 01             	add    $0x1,%ebx
 38c:	89 fe                	mov    %edi,%esi
 38e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 391:	7c cd                	jl     360 <gets+0x20>
 393:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 395:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 398:	c6 03 00             	movb   $0x0,(%ebx)
}
 39b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 39e:	5b                   	pop    %ebx
 39f:	5e                   	pop    %esi
 3a0:	5f                   	pop    %edi
 3a1:	5d                   	pop    %ebp
 3a2:	c3                   	ret    
 3a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a7:	90                   	nop
 3a8:	8b 75 08             	mov    0x8(%ebp),%esi
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	01 de                	add    %ebx,%esi
 3b0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 3b2:	c6 03 00             	movb   $0x0,(%ebx)
}
 3b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b8:	5b                   	pop    %ebx
 3b9:	5e                   	pop    %esi
 3ba:	5f                   	pop    %edi
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    
 3bd:	8d 76 00             	lea    0x0(%esi),%esi

000003c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	56                   	push   %esi
 3c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c9:	83 ec 08             	sub    $0x8,%esp
 3cc:	6a 00                	push   $0x0
 3ce:	ff 75 08             	pushl  0x8(%ebp)
 3d1:	e8 ed 00 00 00       	call   4c3 <open>
  if(fd < 0)
 3d6:	83 c4 10             	add    $0x10,%esp
 3d9:	85 c0                	test   %eax,%eax
 3db:	78 2b                	js     408 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 3dd:	83 ec 08             	sub    $0x8,%esp
 3e0:	ff 75 0c             	pushl  0xc(%ebp)
 3e3:	89 c3                	mov    %eax,%ebx
 3e5:	50                   	push   %eax
 3e6:	e8 f0 00 00 00       	call   4db <fstat>
  close(fd);
 3eb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ee:	89 c6                	mov    %eax,%esi
  close(fd);
 3f0:	e8 b6 00 00 00       	call   4ab <close>
  return r;
 3f5:	83 c4 10             	add    $0x10,%esp
}
 3f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3fb:	89 f0                	mov    %esi,%eax
 3fd:	5b                   	pop    %ebx
 3fe:	5e                   	pop    %esi
 3ff:	5d                   	pop    %ebp
 400:	c3                   	ret    
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 408:	be ff ff ff ff       	mov    $0xffffffff,%esi
 40d:	eb e9                	jmp    3f8 <stat+0x38>
 40f:	90                   	nop

00000410 <atoi>:

int
atoi(const char *s)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	53                   	push   %ebx
 418:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 41b:	0f be 02             	movsbl (%edx),%eax
 41e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 421:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 424:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 429:	77 1a                	ja     445 <atoi+0x35>
 42b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 42f:	90                   	nop
    n = n*10 + *s++ - '0';
 430:	83 c2 01             	add    $0x1,%edx
 433:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 436:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 43a:	0f be 02             	movsbl (%edx),%eax
 43d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 440:	80 fb 09             	cmp    $0x9,%bl
 443:	76 eb                	jbe    430 <atoi+0x20>
  return n;
}
 445:	89 c8                	mov    %ecx,%eax
 447:	5b                   	pop    %ebx
 448:	5d                   	pop    %ebp
 449:	c3                   	ret    
 44a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000450 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 450:	f3 0f 1e fb          	endbr32 
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	57                   	push   %edi
 458:	8b 45 10             	mov    0x10(%ebp),%eax
 45b:	8b 55 08             	mov    0x8(%ebp),%edx
 45e:	56                   	push   %esi
 45f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 462:	85 c0                	test   %eax,%eax
 464:	7e 0f                	jle    475 <memmove+0x25>
 466:	01 d0                	add    %edx,%eax
  dst = vdst;
 468:	89 d7                	mov    %edx,%edi
 46a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 470:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 471:	39 f8                	cmp    %edi,%eax
 473:	75 fb                	jne    470 <memmove+0x20>
  return vdst;
}
 475:	5e                   	pop    %esi
 476:	89 d0                	mov    %edx,%eax
 478:	5f                   	pop    %edi
 479:	5d                   	pop    %ebp
 47a:	c3                   	ret    

0000047b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 47b:	b8 01 00 00 00       	mov    $0x1,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <exit>:
SYSCALL(exit)
 483:	b8 02 00 00 00       	mov    $0x2,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <wait>:
SYSCALL(wait)
 48b:	b8 03 00 00 00       	mov    $0x3,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <pipe>:
SYSCALL(pipe)
 493:	b8 04 00 00 00       	mov    $0x4,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <read>:
SYSCALL(read)
 49b:	b8 05 00 00 00       	mov    $0x5,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <write>:
SYSCALL(write)
 4a3:	b8 10 00 00 00       	mov    $0x10,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <close>:
SYSCALL(close)
 4ab:	b8 15 00 00 00       	mov    $0x15,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <kill>:
SYSCALL(kill)
 4b3:	b8 06 00 00 00       	mov    $0x6,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <exec>:
SYSCALL(exec)
 4bb:	b8 07 00 00 00       	mov    $0x7,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <open>:
SYSCALL(open)
 4c3:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <mknod>:
SYSCALL(mknod)
 4cb:	b8 11 00 00 00       	mov    $0x11,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <unlink>:
SYSCALL(unlink)
 4d3:	b8 12 00 00 00       	mov    $0x12,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <fstat>:
SYSCALL(fstat)
 4db:	b8 08 00 00 00       	mov    $0x8,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <link>:
SYSCALL(link)
 4e3:	b8 13 00 00 00       	mov    $0x13,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <mkdir>:
SYSCALL(mkdir)
 4eb:	b8 14 00 00 00       	mov    $0x14,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <chdir>:
SYSCALL(chdir)
 4f3:	b8 09 00 00 00       	mov    $0x9,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <dup>:
SYSCALL(dup)
 4fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <getpid>:
SYSCALL(getpid)
 503:	b8 0b 00 00 00       	mov    $0xb,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <sbrk>:
SYSCALL(sbrk)
 50b:	b8 0c 00 00 00       	mov    $0xc,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <sleep>:
SYSCALL(sleep)
 513:	b8 0d 00 00 00       	mov    $0xd,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <uptime>:
SYSCALL(uptime)
 51b:	b8 0e 00 00 00       	mov    $0xe,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <uniq>:
SYSCALL(uniq)
 523:	b8 16 00 00 00       	mov    $0x16,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <head>:
SYSCALL(head)
 52b:	b8 17 00 00 00       	mov    $0x17,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    
 533:	66 90                	xchg   %ax,%ax
 535:	66 90                	xchg   %ax,%ax
 537:	66 90                	xchg   %ax,%ax
 539:	66 90                	xchg   %ax,%ax
 53b:	66 90                	xchg   %ax,%ax
 53d:	66 90                	xchg   %ax,%ax
 53f:	90                   	nop

00000540 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	56                   	push   %esi
 545:	53                   	push   %ebx
 546:	83 ec 3c             	sub    $0x3c,%esp
 549:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 54c:	89 d1                	mov    %edx,%ecx
{
 54e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 551:	85 d2                	test   %edx,%edx
 553:	0f 89 7f 00 00 00    	jns    5d8 <printint+0x98>
 559:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 55d:	74 79                	je     5d8 <printint+0x98>
    neg = 1;
 55f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 566:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 568:	31 db                	xor    %ebx,%ebx
 56a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 56d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 570:	89 c8                	mov    %ecx,%eax
 572:	31 d2                	xor    %edx,%edx
 574:	89 cf                	mov    %ecx,%edi
 576:	f7 75 c4             	divl   -0x3c(%ebp)
 579:	0f b6 92 c0 09 00 00 	movzbl 0x9c0(%edx),%edx
 580:	89 45 c0             	mov    %eax,-0x40(%ebp)
 583:	89 d8                	mov    %ebx,%eax
 585:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 588:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 58b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 58e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 591:	76 dd                	jbe    570 <printint+0x30>
  if(neg)
 593:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 596:	85 c9                	test   %ecx,%ecx
 598:	74 0c                	je     5a6 <printint+0x66>
    buf[i++] = '-';
 59a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 59f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5ad:	eb 07                	jmp    5b6 <printint+0x76>
 5af:	90                   	nop
 5b0:	0f b6 13             	movzbl (%ebx),%edx
 5b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5b6:	83 ec 04             	sub    $0x4,%esp
 5b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5bc:	6a 01                	push   $0x1
 5be:	56                   	push   %esi
 5bf:	57                   	push   %edi
 5c0:	e8 de fe ff ff       	call   4a3 <write>
  while(--i >= 0)
 5c5:	83 c4 10             	add    $0x10,%esp
 5c8:	39 de                	cmp    %ebx,%esi
 5ca:	75 e4                	jne    5b0 <printint+0x70>
    putc(fd, buf[i]);
}
 5cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    
 5d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5df:	eb 87                	jmp    568 <printint+0x28>
 5e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop

000005f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	57                   	push   %edi
 5f8:	56                   	push   %esi
 5f9:	53                   	push   %ebx
 5fa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5fd:	8b 75 0c             	mov    0xc(%ebp),%esi
 600:	0f b6 1e             	movzbl (%esi),%ebx
 603:	84 db                	test   %bl,%bl
 605:	0f 84 b4 00 00 00    	je     6bf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 60b:	8d 45 10             	lea    0x10(%ebp),%eax
 60e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 611:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 614:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 616:	89 45 d0             	mov    %eax,-0x30(%ebp)
 619:	eb 33                	jmp    64e <printf+0x5e>
 61b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop
 620:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 623:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 628:	83 f8 25             	cmp    $0x25,%eax
 62b:	74 17                	je     644 <printf+0x54>
  write(fd, &c, 1);
 62d:	83 ec 04             	sub    $0x4,%esp
 630:	88 5d e7             	mov    %bl,-0x19(%ebp)
 633:	6a 01                	push   $0x1
 635:	57                   	push   %edi
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 65 fe ff ff       	call   4a3 <write>
 63e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 641:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 644:	0f b6 1e             	movzbl (%esi),%ebx
 647:	83 c6 01             	add    $0x1,%esi
 64a:	84 db                	test   %bl,%bl
 64c:	74 71                	je     6bf <printf+0xcf>
    c = fmt[i] & 0xff;
 64e:	0f be cb             	movsbl %bl,%ecx
 651:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 654:	85 d2                	test   %edx,%edx
 656:	74 c8                	je     620 <printf+0x30>
      }
    } else if(state == '%'){
 658:	83 fa 25             	cmp    $0x25,%edx
 65b:	75 e7                	jne    644 <printf+0x54>
      if(c == 'd'){
 65d:	83 f8 64             	cmp    $0x64,%eax
 660:	0f 84 9a 00 00 00    	je     700 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 666:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 66c:	83 f9 70             	cmp    $0x70,%ecx
 66f:	74 5f                	je     6d0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 671:	83 f8 73             	cmp    $0x73,%eax
 674:	0f 84 d6 00 00 00    	je     750 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67a:	83 f8 63             	cmp    $0x63,%eax
 67d:	0f 84 8d 00 00 00    	je     710 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 683:	83 f8 25             	cmp    $0x25,%eax
 686:	0f 84 b4 00 00 00    	je     740 <printf+0x150>
  write(fd, &c, 1);
 68c:	83 ec 04             	sub    $0x4,%esp
 68f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 693:	6a 01                	push   $0x1
 695:	57                   	push   %edi
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 05 fe ff ff       	call   4a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 69e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6a1:	83 c4 0c             	add    $0xc,%esp
 6a4:	6a 01                	push   $0x1
 6a6:	83 c6 01             	add    $0x1,%esi
 6a9:	57                   	push   %edi
 6aa:	ff 75 08             	pushl  0x8(%ebp)
 6ad:	e8 f1 fd ff ff       	call   4a3 <write>
  for(i = 0; fmt[i]; i++){
 6b2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6b9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6bb:	84 db                	test   %bl,%bl
 6bd:	75 8f                	jne    64e <printf+0x5e>
    }
  }
}
 6bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c2:	5b                   	pop    %ebx
 6c3:	5e                   	pop    %esi
 6c4:	5f                   	pop    %edi
 6c5:	5d                   	pop    %ebp
 6c6:	c3                   	ret    
 6c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6d0:	83 ec 0c             	sub    $0xc,%esp
 6d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6d8:	6a 00                	push   $0x0
 6da:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6dd:	8b 45 08             	mov    0x8(%ebp),%eax
 6e0:	8b 13                	mov    (%ebx),%edx
 6e2:	e8 59 fe ff ff       	call   540 <printint>
        ap++;
 6e7:	89 d8                	mov    %ebx,%eax
 6e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ec:	31 d2                	xor    %edx,%edx
        ap++;
 6ee:	83 c0 04             	add    $0x4,%eax
 6f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6f4:	e9 4b ff ff ff       	jmp    644 <printf+0x54>
 6f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 700:	83 ec 0c             	sub    $0xc,%esp
 703:	b9 0a 00 00 00       	mov    $0xa,%ecx
 708:	6a 01                	push   $0x1
 70a:	eb ce                	jmp    6da <printf+0xea>
 70c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 710:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 713:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 716:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 718:	6a 01                	push   $0x1
        ap++;
 71a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 71d:	57                   	push   %edi
 71e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 721:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 724:	e8 7a fd ff ff       	call   4a3 <write>
        ap++;
 729:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 72c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 72f:	31 d2                	xor    %edx,%edx
 731:	e9 0e ff ff ff       	jmp    644 <printf+0x54>
 736:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 73d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 740:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 743:	83 ec 04             	sub    $0x4,%esp
 746:	e9 59 ff ff ff       	jmp    6a4 <printf+0xb4>
 74b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
        s = (char*)*ap;
 750:	8b 45 d0             	mov    -0x30(%ebp),%eax
 753:	8b 18                	mov    (%eax),%ebx
        ap++;
 755:	83 c0 04             	add    $0x4,%eax
 758:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 75b:	85 db                	test   %ebx,%ebx
 75d:	74 17                	je     776 <printf+0x186>
        while(*s != 0){
 75f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 762:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 764:	84 c0                	test   %al,%al
 766:	0f 84 d8 fe ff ff    	je     644 <printf+0x54>
 76c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 76f:	89 de                	mov    %ebx,%esi
 771:	8b 5d 08             	mov    0x8(%ebp),%ebx
 774:	eb 1a                	jmp    790 <printf+0x1a0>
          s = "(null)";
 776:	bb b6 09 00 00       	mov    $0x9b6,%ebx
        while(*s != 0){
 77b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 77e:	b8 28 00 00 00       	mov    $0x28,%eax
 783:	89 de                	mov    %ebx,%esi
 785:	8b 5d 08             	mov    0x8(%ebp),%ebx
 788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 78f:	90                   	nop
  write(fd, &c, 1);
 790:	83 ec 04             	sub    $0x4,%esp
          s++;
 793:	83 c6 01             	add    $0x1,%esi
 796:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 799:	6a 01                	push   $0x1
 79b:	57                   	push   %edi
 79c:	53                   	push   %ebx
 79d:	e8 01 fd ff ff       	call   4a3 <write>
        while(*s != 0){
 7a2:	0f b6 06             	movzbl (%esi),%eax
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	84 c0                	test   %al,%al
 7aa:	75 e4                	jne    790 <printf+0x1a0>
 7ac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7af:	31 d2                	xor    %edx,%edx
 7b1:	e9 8e fe ff ff       	jmp    644 <printf+0x54>
 7b6:	66 90                	xchg   %ax,%ax
 7b8:	66 90                	xchg   %ax,%ax
 7ba:	66 90                	xchg   %ax,%ax
 7bc:	66 90                	xchg   %ax,%ax
 7be:	66 90                	xchg   %ax,%ax

000007c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c0:	f3 0f 1e fb          	endbr32 
 7c4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c5:	a1 a4 0c 00 00       	mov    0xca4,%eax
{
 7ca:	89 e5                	mov    %esp,%ebp
 7cc:	57                   	push   %edi
 7cd:	56                   	push   %esi
 7ce:	53                   	push   %ebx
 7cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7d2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7d4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d7:	39 c8                	cmp    %ecx,%eax
 7d9:	73 15                	jae    7f0 <free+0x30>
 7db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
 7e0:	39 d1                	cmp    %edx,%ecx
 7e2:	72 14                	jb     7f8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	39 d0                	cmp    %edx,%eax
 7e6:	73 10                	jae    7f8 <free+0x38>
{
 7e8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ea:	8b 10                	mov    (%eax),%edx
 7ec:	39 c8                	cmp    %ecx,%eax
 7ee:	72 f0                	jb     7e0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	39 d0                	cmp    %edx,%eax
 7f2:	72 f4                	jb     7e8 <free+0x28>
 7f4:	39 d1                	cmp    %edx,%ecx
 7f6:	73 f0                	jae    7e8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7f8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7fb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7fe:	39 fa                	cmp    %edi,%edx
 800:	74 1e                	je     820 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 802:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 805:	8b 50 04             	mov    0x4(%eax),%edx
 808:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 80b:	39 f1                	cmp    %esi,%ecx
 80d:	74 28                	je     837 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 80f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 811:	5b                   	pop    %ebx
  freep = p;
 812:	a3 a4 0c 00 00       	mov    %eax,0xca4
}
 817:	5e                   	pop    %esi
 818:	5f                   	pop    %edi
 819:	5d                   	pop    %ebp
 81a:	c3                   	ret    
 81b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 81f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 820:	03 72 04             	add    0x4(%edx),%esi
 823:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 12                	mov    (%edx),%edx
 82a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 82d:	8b 50 04             	mov    0x4(%eax),%edx
 830:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 833:	39 f1                	cmp    %esi,%ecx
 835:	75 d8                	jne    80f <free+0x4f>
    p->s.size += bp->s.size;
 837:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 83a:	a3 a4 0c 00 00       	mov    %eax,0xca4
    p->s.size += bp->s.size;
 83f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 842:	8b 53 f8             	mov    -0x8(%ebx),%edx
 845:	89 10                	mov    %edx,(%eax)
}
 847:	5b                   	pop    %ebx
 848:	5e                   	pop    %esi
 849:	5f                   	pop    %edi
 84a:	5d                   	pop    %ebp
 84b:	c3                   	ret    
 84c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000850 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 850:	f3 0f 1e fb          	endbr32 
 854:	55                   	push   %ebp
 855:	89 e5                	mov    %esp,%ebp
 857:	57                   	push   %edi
 858:	56                   	push   %esi
 859:	53                   	push   %ebx
 85a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 85d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 860:	8b 3d a4 0c 00 00    	mov    0xca4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 866:	8d 70 07             	lea    0x7(%eax),%esi
 869:	c1 ee 03             	shr    $0x3,%esi
 86c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 86f:	85 ff                	test   %edi,%edi
 871:	0f 84 a9 00 00 00    	je     920 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 877:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 879:	8b 48 04             	mov    0x4(%eax),%ecx
 87c:	39 f1                	cmp    %esi,%ecx
 87e:	73 6d                	jae    8ed <malloc+0x9d>
 880:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 886:	bb 00 10 00 00       	mov    $0x1000,%ebx
 88b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 88e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 895:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 898:	eb 17                	jmp    8b1 <malloc+0x61>
 89a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 8a2:	8b 4a 04             	mov    0x4(%edx),%ecx
 8a5:	39 f1                	cmp    %esi,%ecx
 8a7:	73 4f                	jae    8f8 <malloc+0xa8>
 8a9:	8b 3d a4 0c 00 00    	mov    0xca4,%edi
 8af:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8b1:	39 c7                	cmp    %eax,%edi
 8b3:	75 eb                	jne    8a0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8b5:	83 ec 0c             	sub    $0xc,%esp
 8b8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8bb:	e8 4b fc ff ff       	call   50b <sbrk>
  if(p == (char*)-1)
 8c0:	83 c4 10             	add    $0x10,%esp
 8c3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8c6:	74 1b                	je     8e3 <malloc+0x93>
  hp->s.size = nu;
 8c8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8cb:	83 ec 0c             	sub    $0xc,%esp
 8ce:	83 c0 08             	add    $0x8,%eax
 8d1:	50                   	push   %eax
 8d2:	e8 e9 fe ff ff       	call   7c0 <free>
  return freep;
 8d7:	a1 a4 0c 00 00       	mov    0xca4,%eax
      if((p = morecore(nunits)) == 0)
 8dc:	83 c4 10             	add    $0x10,%esp
 8df:	85 c0                	test   %eax,%eax
 8e1:	75 bd                	jne    8a0 <malloc+0x50>
        return 0;
  }
}
 8e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8e6:	31 c0                	xor    %eax,%eax
}
 8e8:	5b                   	pop    %ebx
 8e9:	5e                   	pop    %esi
 8ea:	5f                   	pop    %edi
 8eb:	5d                   	pop    %ebp
 8ec:	c3                   	ret    
    if(p->s.size >= nunits){
 8ed:	89 c2                	mov    %eax,%edx
 8ef:	89 f8                	mov    %edi,%eax
 8f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8f8:	39 ce                	cmp    %ecx,%esi
 8fa:	74 54                	je     950 <malloc+0x100>
        p->s.size -= nunits;
 8fc:	29 f1                	sub    %esi,%ecx
 8fe:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 901:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 904:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 907:	a3 a4 0c 00 00       	mov    %eax,0xca4
}
 90c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 90f:	8d 42 08             	lea    0x8(%edx),%eax
}
 912:	5b                   	pop    %ebx
 913:	5e                   	pop    %esi
 914:	5f                   	pop    %edi
 915:	5d                   	pop    %ebp
 916:	c3                   	ret    
 917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 920:	c7 05 a4 0c 00 00 a8 	movl   $0xca8,0xca4
 927:	0c 00 00 
    base.s.size = 0;
 92a:	bf a8 0c 00 00       	mov    $0xca8,%edi
    base.s.ptr = freep = prevp = &base;
 92f:	c7 05 a8 0c 00 00 a8 	movl   $0xca8,0xca8
 936:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 939:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 93b:	c7 05 ac 0c 00 00 00 	movl   $0x0,0xcac
 942:	00 00 00 
    if(p->s.size >= nunits){
 945:	e9 36 ff ff ff       	jmp    880 <malloc+0x30>
 94a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 950:	8b 0a                	mov    (%edx),%ecx
 952:	89 08                	mov    %ecx,(%eax)
 954:	eb b1                	jmp    907 <malloc+0xb7>
