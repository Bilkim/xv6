
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
  1d:	68 78 09 00 00       	push   $0x978
  22:	6a 01                	push   $0x1
  24:	e8 e7 05 00 00       	call   610 <printf>

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
  92:	68 ca 09 00 00       	push   $0x9ca
  97:	6a 01                	push   $0x1
  99:	e8 72 05 00 00       	call   610 <printf>
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
  b9:	68 a8 09 00 00       	push   $0x9a8
  be:	6a 02                	push   $0x2
  c0:	e8 4b 05 00 00       	call   610 <printf>
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
 10b:	68 ca 09 00 00       	push   $0x9ca
 110:	6a 01                	push   $0x1
 112:	e8 f9 04 00 00       	call   610 <printf>
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
 14e:	68 ca 09 00 00       	push   $0x9ca
 153:	6a 01                	push   $0x1
 155:	e8 b6 04 00 00       	call   610 <printf>
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
 16e:	68 ca 09 00 00       	push   $0x9ca
 173:	6a 01                	push   $0x1
 175:	e8 96 04 00 00       	call   610 <printf>
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

00000533 <waitx>:
SYSCALL(waitx)
 533:	b8 18 00 00 00       	mov    $0x18,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <getticks>:
SYSCALL(getticks)
 53b:	b8 19 00 00 00       	mov    $0x19,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <ps>:
SYSCALL(ps)
 543:	b8 1a 00 00 00       	mov    $0x1a,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <cps>:
SYSCALL(cps)
 54b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <chpr>:
SYSCALL(chpr)
 553:	b8 1c 00 00 00       	mov    $0x1c,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    
 55b:	66 90                	xchg   %ax,%ax
 55d:	66 90                	xchg   %ax,%ax
 55f:	90                   	nop

00000560 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	57                   	push   %edi
 564:	56                   	push   %esi
 565:	53                   	push   %ebx
 566:	83 ec 3c             	sub    $0x3c,%esp
 569:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 56c:	89 d1                	mov    %edx,%ecx
{
 56e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 571:	85 d2                	test   %edx,%edx
 573:	0f 89 7f 00 00 00    	jns    5f8 <printint+0x98>
 579:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 57d:	74 79                	je     5f8 <printint+0x98>
    neg = 1;
 57f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 586:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 588:	31 db                	xor    %ebx,%ebx
 58a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 590:	89 c8                	mov    %ecx,%eax
 592:	31 d2                	xor    %edx,%edx
 594:	89 cf                	mov    %ecx,%edi
 596:	f7 75 c4             	divl   -0x3c(%ebp)
 599:	0f b6 92 e0 09 00 00 	movzbl 0x9e0(%edx),%edx
 5a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 5a3:	89 d8                	mov    %ebx,%eax
 5a5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 5a8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 5ab:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 5ae:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 5b1:	76 dd                	jbe    590 <printint+0x30>
  if(neg)
 5b3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 5b6:	85 c9                	test   %ecx,%ecx
 5b8:	74 0c                	je     5c6 <printint+0x66>
    buf[i++] = '-';
 5ba:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 5bf:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 5c1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 5c6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 5c9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 5cd:	eb 07                	jmp    5d6 <printint+0x76>
 5cf:	90                   	nop
 5d0:	0f b6 13             	movzbl (%ebx),%edx
 5d3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5d6:	83 ec 04             	sub    $0x4,%esp
 5d9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5dc:	6a 01                	push   $0x1
 5de:	56                   	push   %esi
 5df:	57                   	push   %edi
 5e0:	e8 be fe ff ff       	call   4a3 <write>
  while(--i >= 0)
 5e5:	83 c4 10             	add    $0x10,%esp
 5e8:	39 de                	cmp    %ebx,%esi
 5ea:	75 e4                	jne    5d0 <printint+0x70>
    putc(fd, buf[i]);
}
 5ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ef:	5b                   	pop    %ebx
 5f0:	5e                   	pop    %esi
 5f1:	5f                   	pop    %edi
 5f2:	5d                   	pop    %ebp
 5f3:	c3                   	ret    
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5f8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5ff:	eb 87                	jmp    588 <printint+0x28>
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop

00000610 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 610:	f3 0f 1e fb          	endbr32 
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	57                   	push   %edi
 618:	56                   	push   %esi
 619:	53                   	push   %ebx
 61a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 61d:	8b 75 0c             	mov    0xc(%ebp),%esi
 620:	0f b6 1e             	movzbl (%esi),%ebx
 623:	84 db                	test   %bl,%bl
 625:	0f 84 b4 00 00 00    	je     6df <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 62b:	8d 45 10             	lea    0x10(%ebp),%eax
 62e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 631:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 634:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 636:	89 45 d0             	mov    %eax,-0x30(%ebp)
 639:	eb 33                	jmp    66e <printf+0x5e>
 63b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 63f:	90                   	nop
 640:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 643:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 648:	83 f8 25             	cmp    $0x25,%eax
 64b:	74 17                	je     664 <printf+0x54>
  write(fd, &c, 1);
 64d:	83 ec 04             	sub    $0x4,%esp
 650:	88 5d e7             	mov    %bl,-0x19(%ebp)
 653:	6a 01                	push   $0x1
 655:	57                   	push   %edi
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 45 fe ff ff       	call   4a3 <write>
 65e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 661:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 664:	0f b6 1e             	movzbl (%esi),%ebx
 667:	83 c6 01             	add    $0x1,%esi
 66a:	84 db                	test   %bl,%bl
 66c:	74 71                	je     6df <printf+0xcf>
    c = fmt[i] & 0xff;
 66e:	0f be cb             	movsbl %bl,%ecx
 671:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 674:	85 d2                	test   %edx,%edx
 676:	74 c8                	je     640 <printf+0x30>
      }
    } else if(state == '%'){
 678:	83 fa 25             	cmp    $0x25,%edx
 67b:	75 e7                	jne    664 <printf+0x54>
      if(c == 'd'){
 67d:	83 f8 64             	cmp    $0x64,%eax
 680:	0f 84 9a 00 00 00    	je     720 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 686:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 68c:	83 f9 70             	cmp    $0x70,%ecx
 68f:	74 5f                	je     6f0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 691:	83 f8 73             	cmp    $0x73,%eax
 694:	0f 84 d6 00 00 00    	je     770 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69a:	83 f8 63             	cmp    $0x63,%eax
 69d:	0f 84 8d 00 00 00    	je     730 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6a3:	83 f8 25             	cmp    $0x25,%eax
 6a6:	0f 84 b4 00 00 00    	je     760 <printf+0x150>
  write(fd, &c, 1);
 6ac:	83 ec 04             	sub    $0x4,%esp
 6af:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6b3:	6a 01                	push   $0x1
 6b5:	57                   	push   %edi
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 e5 fd ff ff       	call   4a3 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 6be:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 6c1:	83 c4 0c             	add    $0xc,%esp
 6c4:	6a 01                	push   $0x1
 6c6:	83 c6 01             	add    $0x1,%esi
 6c9:	57                   	push   %edi
 6ca:	ff 75 08             	pushl  0x8(%ebp)
 6cd:	e8 d1 fd ff ff       	call   4a3 <write>
  for(i = 0; fmt[i]; i++){
 6d2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6d6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6db:	84 db                	test   %bl,%bl
 6dd:	75 8f                	jne    66e <printf+0x5e>
    }
  }
}
 6df:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6e2:	5b                   	pop    %ebx
 6e3:	5e                   	pop    %esi
 6e4:	5f                   	pop    %edi
 6e5:	5d                   	pop    %ebp
 6e6:	c3                   	ret    
 6e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ee:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6f8:	6a 00                	push   $0x0
 6fa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6fd:	8b 45 08             	mov    0x8(%ebp),%eax
 700:	8b 13                	mov    (%ebx),%edx
 702:	e8 59 fe ff ff       	call   560 <printint>
        ap++;
 707:	89 d8                	mov    %ebx,%eax
 709:	83 c4 10             	add    $0x10,%esp
      state = 0;
 70c:	31 d2                	xor    %edx,%edx
        ap++;
 70e:	83 c0 04             	add    $0x4,%eax
 711:	89 45 d0             	mov    %eax,-0x30(%ebp)
 714:	e9 4b ff ff ff       	jmp    664 <printf+0x54>
 719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	b9 0a 00 00 00       	mov    $0xa,%ecx
 728:	6a 01                	push   $0x1
 72a:	eb ce                	jmp    6fa <printf+0xea>
 72c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 730:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 736:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 738:	6a 01                	push   $0x1
        ap++;
 73a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 73d:	57                   	push   %edi
 73e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 741:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 744:	e8 5a fd ff ff       	call   4a3 <write>
        ap++;
 749:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 74c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 74f:	31 d2                	xor    %edx,%edx
 751:	e9 0e ff ff ff       	jmp    664 <printf+0x54>
 756:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 760:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 763:	83 ec 04             	sub    $0x4,%esp
 766:	e9 59 ff ff ff       	jmp    6c4 <printf+0xb4>
 76b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 76f:	90                   	nop
        s = (char*)*ap;
 770:	8b 45 d0             	mov    -0x30(%ebp),%eax
 773:	8b 18                	mov    (%eax),%ebx
        ap++;
 775:	83 c0 04             	add    $0x4,%eax
 778:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 77b:	85 db                	test   %ebx,%ebx
 77d:	74 17                	je     796 <printf+0x186>
        while(*s != 0){
 77f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 782:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 784:	84 c0                	test   %al,%al
 786:	0f 84 d8 fe ff ff    	je     664 <printf+0x54>
 78c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 78f:	89 de                	mov    %ebx,%esi
 791:	8b 5d 08             	mov    0x8(%ebp),%ebx
 794:	eb 1a                	jmp    7b0 <printf+0x1a0>
          s = "(null)";
 796:	bb d6 09 00 00       	mov    $0x9d6,%ebx
        while(*s != 0){
 79b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 79e:	b8 28 00 00 00       	mov    $0x28,%eax
 7a3:	89 de                	mov    %ebx,%esi
 7a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7af:	90                   	nop
  write(fd, &c, 1);
 7b0:	83 ec 04             	sub    $0x4,%esp
          s++;
 7b3:	83 c6 01             	add    $0x1,%esi
 7b6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7b9:	6a 01                	push   $0x1
 7bb:	57                   	push   %edi
 7bc:	53                   	push   %ebx
 7bd:	e8 e1 fc ff ff       	call   4a3 <write>
        while(*s != 0){
 7c2:	0f b6 06             	movzbl (%esi),%eax
 7c5:	83 c4 10             	add    $0x10,%esp
 7c8:	84 c0                	test   %al,%al
 7ca:	75 e4                	jne    7b0 <printf+0x1a0>
 7cc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 7cf:	31 d2                	xor    %edx,%edx
 7d1:	e9 8e fe ff ff       	jmp    664 <printf+0x54>
 7d6:	66 90                	xchg   %ax,%ax
 7d8:	66 90                	xchg   %ax,%ax
 7da:	66 90                	xchg   %ax,%ax
 7dc:	66 90                	xchg   %ax,%ax
 7de:	66 90                	xchg   %ax,%ax

000007e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e0:	f3 0f 1e fb          	endbr32 
 7e4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e5:	a1 c4 0c 00 00       	mov    0xcc4,%eax
{
 7ea:	89 e5                	mov    %esp,%ebp
 7ec:	57                   	push   %edi
 7ed:	56                   	push   %esi
 7ee:	53                   	push   %ebx
 7ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7f2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7f4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f7:	39 c8                	cmp    %ecx,%eax
 7f9:	73 15                	jae    810 <free+0x30>
 7fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7ff:	90                   	nop
 800:	39 d1                	cmp    %edx,%ecx
 802:	72 14                	jb     818 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 804:	39 d0                	cmp    %edx,%eax
 806:	73 10                	jae    818 <free+0x38>
{
 808:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	8b 10                	mov    (%eax),%edx
 80c:	39 c8                	cmp    %ecx,%eax
 80e:	72 f0                	jb     800 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 810:	39 d0                	cmp    %edx,%eax
 812:	72 f4                	jb     808 <free+0x28>
 814:	39 d1                	cmp    %edx,%ecx
 816:	73 f0                	jae    808 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 818:	8b 73 fc             	mov    -0x4(%ebx),%esi
 81b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 81e:	39 fa                	cmp    %edi,%edx
 820:	74 1e                	je     840 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 822:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 825:	8b 50 04             	mov    0x4(%eax),%edx
 828:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 82b:	39 f1                	cmp    %esi,%ecx
 82d:	74 28                	je     857 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 82f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 831:	5b                   	pop    %ebx
  freep = p;
 832:	a3 c4 0c 00 00       	mov    %eax,0xcc4
}
 837:	5e                   	pop    %esi
 838:	5f                   	pop    %edi
 839:	5d                   	pop    %ebp
 83a:	c3                   	ret    
 83b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 83f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 840:	03 72 04             	add    0x4(%edx),%esi
 843:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 846:	8b 10                	mov    (%eax),%edx
 848:	8b 12                	mov    (%edx),%edx
 84a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 853:	39 f1                	cmp    %esi,%ecx
 855:	75 d8                	jne    82f <free+0x4f>
    p->s.size += bp->s.size;
 857:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 85a:	a3 c4 0c 00 00       	mov    %eax,0xcc4
    p->s.size += bp->s.size;
 85f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 862:	8b 53 f8             	mov    -0x8(%ebx),%edx
 865:	89 10                	mov    %edx,(%eax)
}
 867:	5b                   	pop    %ebx
 868:	5e                   	pop    %esi
 869:	5f                   	pop    %edi
 86a:	5d                   	pop    %ebp
 86b:	c3                   	ret    
 86c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000870 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 870:	f3 0f 1e fb          	endbr32 
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	57                   	push   %edi
 878:	56                   	push   %esi
 879:	53                   	push   %ebx
 87a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 880:	8b 3d c4 0c 00 00    	mov    0xcc4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 886:	8d 70 07             	lea    0x7(%eax),%esi
 889:	c1 ee 03             	shr    $0x3,%esi
 88c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 88f:	85 ff                	test   %edi,%edi
 891:	0f 84 a9 00 00 00    	je     940 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 897:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 899:	8b 48 04             	mov    0x4(%eax),%ecx
 89c:	39 f1                	cmp    %esi,%ecx
 89e:	73 6d                	jae    90d <malloc+0x9d>
 8a0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 8a6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8ab:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 8ae:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 8b5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 8b8:	eb 17                	jmp    8d1 <malloc+0x61>
 8ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 8c2:	8b 4a 04             	mov    0x4(%edx),%ecx
 8c5:	39 f1                	cmp    %esi,%ecx
 8c7:	73 4f                	jae    918 <malloc+0xa8>
 8c9:	8b 3d c4 0c 00 00    	mov    0xcc4,%edi
 8cf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d1:	39 c7                	cmp    %eax,%edi
 8d3:	75 eb                	jne    8c0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8d5:	83 ec 0c             	sub    $0xc,%esp
 8d8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8db:	e8 2b fc ff ff       	call   50b <sbrk>
  if(p == (char*)-1)
 8e0:	83 c4 10             	add    $0x10,%esp
 8e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8e6:	74 1b                	je     903 <malloc+0x93>
  hp->s.size = nu;
 8e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8eb:	83 ec 0c             	sub    $0xc,%esp
 8ee:	83 c0 08             	add    $0x8,%eax
 8f1:	50                   	push   %eax
 8f2:	e8 e9 fe ff ff       	call   7e0 <free>
  return freep;
 8f7:	a1 c4 0c 00 00       	mov    0xcc4,%eax
      if((p = morecore(nunits)) == 0)
 8fc:	83 c4 10             	add    $0x10,%esp
 8ff:	85 c0                	test   %eax,%eax
 901:	75 bd                	jne    8c0 <malloc+0x50>
        return 0;
  }
}
 903:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 906:	31 c0                	xor    %eax,%eax
}
 908:	5b                   	pop    %ebx
 909:	5e                   	pop    %esi
 90a:	5f                   	pop    %edi
 90b:	5d                   	pop    %ebp
 90c:	c3                   	ret    
    if(p->s.size >= nunits){
 90d:	89 c2                	mov    %eax,%edx
 90f:	89 f8                	mov    %edi,%eax
 911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 918:	39 ce                	cmp    %ecx,%esi
 91a:	74 54                	je     970 <malloc+0x100>
        p->s.size -= nunits;
 91c:	29 f1                	sub    %esi,%ecx
 91e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 921:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 924:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 927:	a3 c4 0c 00 00       	mov    %eax,0xcc4
}
 92c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 92f:	8d 42 08             	lea    0x8(%edx),%eax
}
 932:	5b                   	pop    %ebx
 933:	5e                   	pop    %esi
 934:	5f                   	pop    %edi
 935:	5d                   	pop    %ebp
 936:	c3                   	ret    
 937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 93e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 940:	c7 05 c4 0c 00 00 c8 	movl   $0xcc8,0xcc4
 947:	0c 00 00 
    base.s.size = 0;
 94a:	bf c8 0c 00 00       	mov    $0xcc8,%edi
    base.s.ptr = freep = prevp = &base;
 94f:	c7 05 c8 0c 00 00 c8 	movl   $0xcc8,0xcc8
 956:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 959:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 95b:	c7 05 cc 0c 00 00 00 	movl   $0x0,0xccc
 962:	00 00 00 
    if(p->s.size >= nunits){
 965:	e9 36 ff ff ff       	jmp    8a0 <malloc+0x30>
 96a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 970:	8b 0a                	mov    (%edx),%ecx
 972:	89 08                	mov    %ecx,(%eax)
 974:	eb b1                	jmp    927 <malloc+0xb7>
