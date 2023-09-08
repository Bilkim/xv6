
_uniq:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }

    close(fd);
}

int main(int argc, char *argv[]) {
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  17:	8b 31                	mov    (%ecx),%esi
  19:	8b 59 04             	mov    0x4(%ecx),%ebx
    if (argc < 2 || argc > 3) {
  1c:	8d 46 fe             	lea    -0x2(%esi),%eax
  1f:	83 f8 01             	cmp    $0x1,%eax
  22:	76 14                	jbe    38 <main+0x38>
        printf(2, "Usage: %s <filename1> [<filename2>]\n", argv[0]);
  24:	50                   	push   %eax
  25:	ff 33                	pushl  (%ebx)
  27:	68 3c 0a 00 00       	push   $0xa3c
  2c:	6a 02                	push   $0x2
  2e:	e8 8d 06 00 00       	call   6c0 <printf>
        exit();
  33:	e8 1b 05 00 00       	call   553 <exit>
    }

    printf(1, "Uniq command is getting executed in user mode.\n");
  38:	51                   	push   %ecx
  39:	51                   	push   %ecx
  3a:	68 64 0a 00 00       	push   $0xa64
  3f:	6a 01                	push   $0x1
  41:	e8 7a 06 00 00       	call   6c0 <printf>

    process_file(argv[1]);
  46:	58                   	pop    %eax
  47:	ff 73 04             	pushl  0x4(%ebx)
  4a:	e8 31 01 00 00       	call   180 <process_file>
    if(argc == 3) {
  4f:	83 c4 10             	add    $0x10,%esp
  52:	83 fe 03             	cmp    $0x3,%esi
  55:	74 13                	je     6a <main+0x6a>
        process_file(argv[2]);
    }
     
    if(argc == 2) {
        uniq(argv[1]);
  57:	83 ec 0c             	sub    $0xc,%esp
  5a:	ff 73 04             	pushl  0x4(%ebx)
  5d:	e8 91 05 00 00       	call   5f3 <uniq>
  62:	83 c4 10             	add    $0x10,%esp
    } else if(argc == 3) {
        uniq(argv[1]);
        uniq(argv[2]);
    }
    exit();
  65:	e8 e9 04 00 00       	call   553 <exit>
        process_file(argv[2]);
  6a:	83 ec 0c             	sub    $0xc,%esp
  6d:	ff 73 08             	pushl  0x8(%ebx)
  70:	e8 0b 01 00 00       	call   180 <process_file>
        uniq(argv[1]);
  75:	58                   	pop    %eax
  76:	ff 73 04             	pushl  0x4(%ebx)
  79:	e8 75 05 00 00       	call   5f3 <uniq>
        uniq(argv[2]);
  7e:	5a                   	pop    %edx
  7f:	ff 73 08             	pushl  0x8(%ebx)
  82:	e8 6c 05 00 00       	call   5f3 <uniq>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	eb d9                	jmp    65 <main+0x65>
  8c:	66 90                	xchg   %ax,%ax
  8e:	66 90                	xchg   %ax,%ax

00000090 <remove_trailing_newline>:
void remove_trailing_newline(char *str) {
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	53                   	push   %ebx
  98:	83 ec 10             	sub    $0x10,%esp
  9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int len = strlen(str);
  9e:	53                   	push   %ebx
  9f:	e8 cc 02 00 00       	call   370 <strlen>
    while (len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r')) {
  a4:	83 c4 10             	add    $0x10,%esp
  a7:	85 c0                	test   %eax,%eax
  a9:	7e 26                	jle    d1 <remove_trailing_newline+0x41>
  ab:	8d 44 03 ff          	lea    -0x1(%ebx,%eax,1),%eax
  af:	eb 13                	jmp    c4 <remove_trailing_newline+0x34>
  b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        str[len - 1] = '\0';
  b8:	c6 00 00             	movb   $0x0,(%eax)
    while (len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r')) {
  bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  be:	39 d8                	cmp    %ebx,%eax
  c0:	74 0f                	je     d1 <remove_trailing_newline+0x41>
  c2:	89 d0                	mov    %edx,%eax
  c4:	0f b6 10             	movzbl (%eax),%edx
  c7:	80 fa 0a             	cmp    $0xa,%dl
  ca:	74 ec                	je     b8 <remove_trailing_newline+0x28>
  cc:	80 fa 0d             	cmp    $0xd,%dl
  cf:	74 e7                	je     b8 <remove_trailing_newline+0x28>
}
  d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  d4:	c9                   	leave  
  d5:	c3                   	ret    
  d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  dd:	8d 76 00             	lea    0x0(%esi),%esi

000000e0 <strcmp_custom>:
int strcmp_custom(const char *s1, const char *s2) {
  e0:	f3 0f 1e fb          	endbr32 
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	53                   	push   %ebx
  e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while (*s1 != '\0' && *s2 != '\0' && *s1 == *s2) {
  ee:	0f be 03             	movsbl (%ebx),%eax
  f1:	0f be 11             	movsbl (%ecx),%edx
  f4:	84 c0                	test   %al,%al
  f6:	75 1d                	jne    115 <strcmp_custom+0x35>
  f8:	eb 26                	jmp    120 <strcmp_custom+0x40>
  fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 100:	84 d2                	test   %dl,%dl
 102:	74 15                	je     119 <strcmp_custom+0x39>
 104:	0f be 43 01          	movsbl 0x1(%ebx),%eax
        s1++;
 108:	83 c3 01             	add    $0x1,%ebx
        s2++;
 10b:	83 c1 01             	add    $0x1,%ecx
    while (*s1 != '\0' && *s2 != '\0' && *s1 == *s2) {
 10e:	0f be 11             	movsbl (%ecx),%edx
 111:	84 c0                	test   %al,%al
 113:	74 0b                	je     120 <strcmp_custom+0x40>
 115:	38 d0                	cmp    %dl,%al
 117:	74 e7                	je     100 <strcmp_custom+0x20>
    return *s1 - *s2;
 119:	29 d0                	sub    %edx,%eax
}
 11b:	5b                   	pop    %ebx
 11c:	5d                   	pop    %ebp
 11d:	c3                   	ret    
 11e:	66 90                	xchg   %ax,%ax
 120:	31 c0                	xor    %eax,%eax
 122:	5b                   	pop    %ebx
 123:	5d                   	pop    %ebp
    return *s1 - *s2;
 124:	29 d0                	sub    %edx,%eax
}
 126:	c3                   	ret    
 127:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 12e:	66 90                	xchg   %ax,%ax

00000130 <strncpy_custom>:
void strncpy_custom(char *dest, const char *src, int n) {
 130:	f3 0f 1e fb          	endbr32 
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	57                   	push   %edi
 138:	8b 4d 08             	mov    0x8(%ebp),%ecx
 13b:	8b 7d 0c             	mov    0xc(%ebp),%edi
 13e:	56                   	push   %esi
 13f:	53                   	push   %ebx
 140:	8b 5d 10             	mov    0x10(%ebp),%ebx
    for (i = 0; i < n && src[i] != '\0'; i++) {
 143:	89 ce                	mov    %ecx,%esi
 145:	85 db                	test   %ebx,%ebx
 147:	7e 1c                	jle    165 <strncpy_custom+0x35>
 149:	31 c0                	xor    %eax,%eax
 14b:	eb 0d                	jmp    15a <strncpy_custom+0x2a>
 14d:	8d 76 00             	lea    0x0(%esi),%esi
        dest[i] = src[i];
 150:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    for (i = 0; i < n && src[i] != '\0'; i++) {
 153:	83 c0 01             	add    $0x1,%eax
 156:	39 c3                	cmp    %eax,%ebx
 158:	74 16                	je     170 <strncpy_custom+0x40>
 15a:	0f b6 14 07          	movzbl (%edi,%eax,1),%edx
 15e:	8d 34 01             	lea    (%ecx,%eax,1),%esi
 161:	84 d2                	test   %dl,%dl
 163:	75 eb                	jne    150 <strncpy_custom+0x20>
    dest[i] = '\0';
 165:	c6 06 00             	movb   $0x0,(%esi)
}
 168:	5b                   	pop    %ebx
 169:	5e                   	pop    %esi
 16a:	5f                   	pop    %edi
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    
 16d:	8d 76 00             	lea    0x0(%esi),%esi
 170:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
    dest[i] = '\0';
 173:	c6 06 00             	movb   $0x0,(%esi)
}
 176:	5b                   	pop    %ebx
 177:	5e                   	pop    %esi
 178:	5f                   	pop    %edi
 179:	5d                   	pop    %ebp
 17a:	c3                   	ret    
 17b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop

00000180 <process_file>:
void process_file(char *filename) {
 180:	f3 0f 1e fb          	endbr32 
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	57                   	push   %edi
 188:	56                   	push   %esi
 189:	53                   	push   %ebx
 18a:	81 ec 24 04 00 00    	sub    $0x424,%esp
 190:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int fd = open(filename, O_RDONLY); // Open the file for reading
 193:	6a 00                	push   $0x0
 195:	53                   	push   %ebx
 196:	e8 f8 03 00 00       	call   593 <open>
    if (fd < 0) {
 19b:	83 c4 10             	add    $0x10,%esp
    int fd = open(filename, O_RDONLY); // Open the file for reading
 19e:	89 85 e0 fb ff ff    	mov    %eax,-0x420(%ebp)
    if (fd < 0) {
 1a4:	85 c0                	test   %eax,%eax
 1a6:	0f 88 25 01 00 00    	js     2d1 <process_file+0x151>
    char prev_line[BUFSIZE] = ""; // Initialize with an empty string
 1ac:	8d bd ec fd ff ff    	lea    -0x214(%ebp),%edi
 1b2:	b9 7f 00 00 00       	mov    $0x7f,%ecx
 1b7:	31 c0                	xor    %eax,%eax
 1b9:	c7 85 e8 fd ff ff 00 	movl   $0x0,-0x218(%ebp)
 1c0:	00 00 00 
 1c3:	f3 ab                	rep stos %eax,%es:(%edi)
 1c5:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi
 1cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1cf:	90                   	nop
        int n = read(fd, buf, BUFSIZE);
 1d0:	83 ec 04             	sub    $0x4,%esp
 1d3:	68 00 02 00 00       	push   $0x200
 1d8:	56                   	push   %esi
 1d9:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 1df:	e8 87 03 00 00       	call   56b <read>
        if (n <= 0) {
 1e4:	83 c4 10             	add    $0x10,%esp
        int n = read(fd, buf, BUFSIZE);
 1e7:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
        if (n <= 0) {
 1ed:	85 c0                	test   %eax,%eax
 1ef:	0f 8e c3 00 00 00    	jle    2b8 <process_file+0x138>
        for (int i = 0; i < n; i++) {
 1f5:	31 ff                	xor    %edi,%edi
        int line_start = 0;
 1f7:	31 c0                	xor    %eax,%eax
 1f9:	eb 0d                	jmp    208 <process_file+0x88>
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop
        for (int i = 0; i < n; i++) {
 200:	39 bd e4 fb ff ff    	cmp    %edi,-0x41c(%ebp)
 206:	74 c8                	je     1d0 <process_file+0x50>
            if (buf[i] == '\n') {
 208:	0f b6 14 3e          	movzbl (%esi,%edi,1),%edx
 20c:	83 c7 01             	add    $0x1,%edi
 20f:	80 fa 0a             	cmp    $0xa,%dl
 212:	75 ec                	jne    200 <process_file+0x80>
                if (strcmp_custom(buf + line_start, prev_line) != 0) {
 214:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
                buf[i] = '\0'; // Null-terminate the line
 217:	c6 84 3d e7 fb ff ff 	movb   $0x0,-0x419(%ebp,%edi,1)
 21e:	00 
    while (*s1 != '\0' && *s2 != '\0' && *s1 == *s2) {
 21f:	ba 01 00 00 00       	mov    $0x1,%edx
 224:	0f b6 85 e8 fd ff ff 	movzbl -0x218(%ebp),%eax
 22b:	0f b6 0b             	movzbl (%ebx),%ecx
 22e:	84 c9                	test   %cl,%cl
 230:	75 1d                	jne    24f <process_file+0xcf>
 232:	eb 74                	jmp    2a8 <process_file+0x128>
 234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 238:	84 c0                	test   %al,%al
 23a:	74 6c                	je     2a8 <process_file+0x128>
 23c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
 240:	83 c2 01             	add    $0x1,%edx
 243:	0f b6 84 15 e7 fd ff 	movzbl -0x219(%ebp,%edx,1),%eax
 24a:	ff 
 24b:	84 c9                	test   %cl,%cl
 24d:	74 59                	je     2a8 <process_file+0x128>
 24f:	38 c1                	cmp    %al,%cl
 251:	74 e5                	je     238 <process_file+0xb8>
                    printf(1, "%s\n", buf + line_start);
 253:	83 ec 04             	sub    $0x4,%esp
 256:	53                   	push   %ebx
 257:	68 36 0a 00 00       	push   $0xa36
 25c:	6a 01                	push   $0x1
 25e:	e8 5d 04 00 00       	call   6c0 <printf>
                    remove_trailing_newline(buf + line_start);
 263:	89 1c 24             	mov    %ebx,(%esp)
 266:	e8 25 fe ff ff       	call   90 <remove_trailing_newline>
    for (i = 0; i < n && src[i] != '\0'; i++) {
 26b:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 271:	89 d8                	mov    %ebx,%eax
 273:	83 c4 10             	add    $0x10,%esp
 276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 27d:	8d 76 00             	lea    0x0(%esi),%esi
 280:	0f b6 08             	movzbl (%eax),%ecx
 283:	89 d3                	mov    %edx,%ebx
 285:	84 c9                	test   %cl,%cl
 287:	74 12                	je     29b <process_file+0x11b>
        dest[i] = src[i];
 289:	88 0a                	mov    %cl,(%edx)
    for (i = 0; i < n && src[i] != '\0'; i++) {
 28b:	8d 53 01             	lea    0x1(%ebx),%edx
 28e:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 291:	83 c0 01             	add    $0x1,%eax
 294:	39 d3                	cmp    %edx,%ebx
 296:	75 e8                	jne    280 <process_file+0x100>
 298:	8d 5d e8             	lea    -0x18(%ebp),%ebx
    dest[i] = '\0';
 29b:	c6 03 00             	movb   $0x0,(%ebx)
                line_start = i + 1;
 29e:	89 f8                	mov    %edi,%eax
 2a0:	e9 5b ff ff ff       	jmp    200 <process_file+0x80>
 2a5:	8d 76 00             	lea    0x0(%esi),%esi
                if (strcmp_custom(buf + line_start, prev_line) != 0) {
 2a8:	38 c1                	cmp    %al,%cl
 2aa:	75 a7                	jne    253 <process_file+0xd3>
                line_start = i + 1;
 2ac:	89 f8                	mov    %edi,%eax
 2ae:	e9 4d ff ff ff       	jmp    200 <process_file+0x80>
 2b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2b7:	90                   	nop
    close(fd);
 2b8:	83 ec 0c             	sub    $0xc,%esp
 2bb:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 2c1:	e8 b5 02 00 00       	call   57b <close>
 2c6:	83 c4 10             	add    $0x10,%esp
}
 2c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2cc:	5b                   	pop    %ebx
 2cd:	5e                   	pop    %esi
 2ce:	5f                   	pop    %edi
 2cf:	5d                   	pop    %ebp
 2d0:	c3                   	ret    
        printf(2, "Error opening %s\n", filename);
 2d1:	83 ec 04             	sub    $0x4,%esp
 2d4:	53                   	push   %ebx
 2d5:	68 28 0a 00 00       	push   $0xa28
 2da:	6a 02                	push   $0x2
 2dc:	e8 df 03 00 00       	call   6c0 <printf>
        return;
 2e1:	83 c4 10             	add    $0x10,%esp
}
 2e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2e7:	5b                   	pop    %ebx
 2e8:	5e                   	pop    %esi
 2e9:	5f                   	pop    %edi
 2ea:	5d                   	pop    %ebp
 2eb:	c3                   	ret    
 2ec:	66 90                	xchg   %ax,%ax
 2ee:	66 90                	xchg   %ax,%ax

000002f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2f5:	31 c0                	xor    %eax,%eax
{
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	53                   	push   %ebx
 2fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 300:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 304:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 307:	83 c0 01             	add    $0x1,%eax
 30a:	84 d2                	test   %dl,%dl
 30c:	75 f2                	jne    300 <strcpy+0x10>
    ;
  return os;
}
 30e:	89 c8                	mov    %ecx,%eax
 310:	5b                   	pop    %ebx
 311:	5d                   	pop    %ebp
 312:	c3                   	ret    
 313:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000320 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	53                   	push   %ebx
 328:	8b 4d 08             	mov    0x8(%ebp),%ecx
 32b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 32e:	0f b6 01             	movzbl (%ecx),%eax
 331:	0f b6 1a             	movzbl (%edx),%ebx
 334:	84 c0                	test   %al,%al
 336:	75 19                	jne    351 <strcmp+0x31>
 338:	eb 26                	jmp    360 <strcmp+0x40>
 33a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 340:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 344:	83 c1 01             	add    $0x1,%ecx
 347:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 34a:	0f b6 1a             	movzbl (%edx),%ebx
 34d:	84 c0                	test   %al,%al
 34f:	74 0f                	je     360 <strcmp+0x40>
 351:	38 d8                	cmp    %bl,%al
 353:	74 eb                	je     340 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 355:	29 d8                	sub    %ebx,%eax
}
 357:	5b                   	pop    %ebx
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    
 35a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 360:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 362:	29 d8                	sub    %ebx,%eax
}
 364:	5b                   	pop    %ebx
 365:	5d                   	pop    %ebp
 366:	c3                   	ret    
 367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 36e:	66 90                	xchg   %ax,%ax

00000370 <strlen>:

uint
strlen(const char *s)
{
 370:	f3 0f 1e fb          	endbr32 
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 37a:	80 3a 00             	cmpb   $0x0,(%edx)
 37d:	74 21                	je     3a0 <strlen+0x30>
 37f:	31 c0                	xor    %eax,%eax
 381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 388:	83 c0 01             	add    $0x1,%eax
 38b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 38f:	89 c1                	mov    %eax,%ecx
 391:	75 f5                	jne    388 <strlen+0x18>
    ;
  return n;
}
 393:	89 c8                	mov    %ecx,%eax
 395:	5d                   	pop    %ebp
 396:	c3                   	ret    
 397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 3a0:	31 c9                	xor    %ecx,%ecx
}
 3a2:	5d                   	pop    %ebp
 3a3:	89 c8                	mov    %ecx,%eax
 3a5:	c3                   	ret    
 3a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ad:	8d 76 00             	lea    0x0(%esi),%esi

000003b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3b0:	f3 0f 1e fb          	endbr32 
 3b4:	55                   	push   %ebp
 3b5:	89 e5                	mov    %esp,%ebp
 3b7:	57                   	push   %edi
 3b8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 3bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3be:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c1:	89 d7                	mov    %edx,%edi
 3c3:	fc                   	cld    
 3c4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 3c6:	89 d0                	mov    %edx,%eax
 3c8:	5f                   	pop    %edi
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    
 3cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3cf:	90                   	nop

000003d0 <strchr>:

char*
strchr(const char *s, char c)
{
 3d0:	f3 0f 1e fb          	endbr32 
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 3de:	0f b6 10             	movzbl (%eax),%edx
 3e1:	84 d2                	test   %dl,%dl
 3e3:	75 16                	jne    3fb <strchr+0x2b>
 3e5:	eb 21                	jmp    408 <strchr+0x38>
 3e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ee:	66 90                	xchg   %ax,%ax
 3f0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3f4:	83 c0 01             	add    $0x1,%eax
 3f7:	84 d2                	test   %dl,%dl
 3f9:	74 0d                	je     408 <strchr+0x38>
    if(*s == c)
 3fb:	38 d1                	cmp    %dl,%cl
 3fd:	75 f1                	jne    3f0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 3ff:	5d                   	pop    %ebp
 400:	c3                   	ret    
 401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 408:	31 c0                	xor    %eax,%eax
}
 40a:	5d                   	pop    %ebp
 40b:	c3                   	ret    
 40c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000410 <gets>:

char*
gets(char *buf, int max)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	57                   	push   %edi
 418:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 419:	31 f6                	xor    %esi,%esi
{
 41b:	53                   	push   %ebx
 41c:	89 f3                	mov    %esi,%ebx
 41e:	83 ec 1c             	sub    $0x1c,%esp
 421:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 424:	eb 33                	jmp    459 <gets+0x49>
 426:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 42d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 430:	83 ec 04             	sub    $0x4,%esp
 433:	8d 45 e7             	lea    -0x19(%ebp),%eax
 436:	6a 01                	push   $0x1
 438:	50                   	push   %eax
 439:	6a 00                	push   $0x0
 43b:	e8 2b 01 00 00       	call   56b <read>
    if(cc < 1)
 440:	83 c4 10             	add    $0x10,%esp
 443:	85 c0                	test   %eax,%eax
 445:	7e 1c                	jle    463 <gets+0x53>
      break;
    buf[i++] = c;
 447:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 44b:	83 c7 01             	add    $0x1,%edi
 44e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 451:	3c 0a                	cmp    $0xa,%al
 453:	74 23                	je     478 <gets+0x68>
 455:	3c 0d                	cmp    $0xd,%al
 457:	74 1f                	je     478 <gets+0x68>
  for(i=0; i+1 < max; ){
 459:	83 c3 01             	add    $0x1,%ebx
 45c:	89 fe                	mov    %edi,%esi
 45e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 461:	7c cd                	jl     430 <gets+0x20>
 463:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 465:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 468:	c6 03 00             	movb   $0x0,(%ebx)
}
 46b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46e:	5b                   	pop    %ebx
 46f:	5e                   	pop    %esi
 470:	5f                   	pop    %edi
 471:	5d                   	pop    %ebp
 472:	c3                   	ret    
 473:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 477:	90                   	nop
 478:	8b 75 08             	mov    0x8(%ebp),%esi
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	01 de                	add    %ebx,%esi
 480:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 482:	c6 03 00             	movb   $0x0,(%ebx)
}
 485:	8d 65 f4             	lea    -0xc(%ebp),%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5f                   	pop    %edi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    
 48d:	8d 76 00             	lea    0x0(%esi),%esi

00000490 <stat>:

int
stat(const char *n, struct stat *st)
{
 490:	f3 0f 1e fb          	endbr32 
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	56                   	push   %esi
 498:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 499:	83 ec 08             	sub    $0x8,%esp
 49c:	6a 00                	push   $0x0
 49e:	ff 75 08             	pushl  0x8(%ebp)
 4a1:	e8 ed 00 00 00       	call   593 <open>
  if(fd < 0)
 4a6:	83 c4 10             	add    $0x10,%esp
 4a9:	85 c0                	test   %eax,%eax
 4ab:	78 2b                	js     4d8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 4ad:	83 ec 08             	sub    $0x8,%esp
 4b0:	ff 75 0c             	pushl  0xc(%ebp)
 4b3:	89 c3                	mov    %eax,%ebx
 4b5:	50                   	push   %eax
 4b6:	e8 f0 00 00 00       	call   5ab <fstat>
  close(fd);
 4bb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 4be:	89 c6                	mov    %eax,%esi
  close(fd);
 4c0:	e8 b6 00 00 00       	call   57b <close>
  return r;
 4c5:	83 c4 10             	add    $0x10,%esp
}
 4c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 4cb:	89 f0                	mov    %esi,%eax
 4cd:	5b                   	pop    %ebx
 4ce:	5e                   	pop    %esi
 4cf:	5d                   	pop    %ebp
 4d0:	c3                   	ret    
 4d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 4d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 4dd:	eb e9                	jmp    4c8 <stat+0x38>
 4df:	90                   	nop

000004e0 <atoi>:

int
atoi(const char *s)
{
 4e0:	f3 0f 1e fb          	endbr32 
 4e4:	55                   	push   %ebp
 4e5:	89 e5                	mov    %esp,%ebp
 4e7:	53                   	push   %ebx
 4e8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4eb:	0f be 02             	movsbl (%edx),%eax
 4ee:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4f1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4f9:	77 1a                	ja     515 <atoi+0x35>
 4fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4ff:	90                   	nop
    n = n*10 + *s++ - '0';
 500:	83 c2 01             	add    $0x1,%edx
 503:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 506:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 50a:	0f be 02             	movsbl (%edx),%eax
 50d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 510:	80 fb 09             	cmp    $0x9,%bl
 513:	76 eb                	jbe    500 <atoi+0x20>
  return n;
}
 515:	89 c8                	mov    %ecx,%eax
 517:	5b                   	pop    %ebx
 518:	5d                   	pop    %ebp
 519:	c3                   	ret    
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000520 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 520:	f3 0f 1e fb          	endbr32 
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	57                   	push   %edi
 528:	8b 45 10             	mov    0x10(%ebp),%eax
 52b:	8b 55 08             	mov    0x8(%ebp),%edx
 52e:	56                   	push   %esi
 52f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 532:	85 c0                	test   %eax,%eax
 534:	7e 0f                	jle    545 <memmove+0x25>
 536:	01 d0                	add    %edx,%eax
  dst = vdst;
 538:	89 d7                	mov    %edx,%edi
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 540:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 541:	39 f8                	cmp    %edi,%eax
 543:	75 fb                	jne    540 <memmove+0x20>
  return vdst;
}
 545:	5e                   	pop    %esi
 546:	89 d0                	mov    %edx,%eax
 548:	5f                   	pop    %edi
 549:	5d                   	pop    %ebp
 54a:	c3                   	ret    

0000054b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 54b:	b8 01 00 00 00       	mov    $0x1,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <exit>:
SYSCALL(exit)
 553:	b8 02 00 00 00       	mov    $0x2,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <wait>:
SYSCALL(wait)
 55b:	b8 03 00 00 00       	mov    $0x3,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <pipe>:
SYSCALL(pipe)
 563:	b8 04 00 00 00       	mov    $0x4,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <read>:
SYSCALL(read)
 56b:	b8 05 00 00 00       	mov    $0x5,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <write>:
SYSCALL(write)
 573:	b8 10 00 00 00       	mov    $0x10,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <close>:
SYSCALL(close)
 57b:	b8 15 00 00 00       	mov    $0x15,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <kill>:
SYSCALL(kill)
 583:	b8 06 00 00 00       	mov    $0x6,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <exec>:
SYSCALL(exec)
 58b:	b8 07 00 00 00       	mov    $0x7,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <open>:
SYSCALL(open)
 593:	b8 0f 00 00 00       	mov    $0xf,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <mknod>:
SYSCALL(mknod)
 59b:	b8 11 00 00 00       	mov    $0x11,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <unlink>:
SYSCALL(unlink)
 5a3:	b8 12 00 00 00       	mov    $0x12,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <fstat>:
SYSCALL(fstat)
 5ab:	b8 08 00 00 00       	mov    $0x8,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <link>:
SYSCALL(link)
 5b3:	b8 13 00 00 00       	mov    $0x13,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <mkdir>:
SYSCALL(mkdir)
 5bb:	b8 14 00 00 00       	mov    $0x14,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    

000005c3 <chdir>:
SYSCALL(chdir)
 5c3:	b8 09 00 00 00       	mov    $0x9,%eax
 5c8:	cd 40                	int    $0x40
 5ca:	c3                   	ret    

000005cb <dup>:
SYSCALL(dup)
 5cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 5d0:	cd 40                	int    $0x40
 5d2:	c3                   	ret    

000005d3 <getpid>:
SYSCALL(getpid)
 5d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d8:	cd 40                	int    $0x40
 5da:	c3                   	ret    

000005db <sbrk>:
SYSCALL(sbrk)
 5db:	b8 0c 00 00 00       	mov    $0xc,%eax
 5e0:	cd 40                	int    $0x40
 5e2:	c3                   	ret    

000005e3 <sleep>:
SYSCALL(sleep)
 5e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e8:	cd 40                	int    $0x40
 5ea:	c3                   	ret    

000005eb <uptime>:
SYSCALL(uptime)
 5eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <uniq>:
SYSCALL(uniq)
 5f3:	b8 16 00 00 00       	mov    $0x16,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <head>:
SYSCALL(head)
 5fb:	b8 17 00 00 00       	mov    $0x17,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    
 603:	66 90                	xchg   %ax,%ax
 605:	66 90                	xchg   %ax,%ax
 607:	66 90                	xchg   %ax,%ax
 609:	66 90                	xchg   %ax,%ax
 60b:	66 90                	xchg   %ax,%ax
 60d:	66 90                	xchg   %ax,%ax
 60f:	90                   	nop

00000610 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	57                   	push   %edi
 614:	56                   	push   %esi
 615:	53                   	push   %ebx
 616:	83 ec 3c             	sub    $0x3c,%esp
 619:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 61c:	89 d1                	mov    %edx,%ecx
{
 61e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 621:	85 d2                	test   %edx,%edx
 623:	0f 89 7f 00 00 00    	jns    6a8 <printint+0x98>
 629:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 62d:	74 79                	je     6a8 <printint+0x98>
    neg = 1;
 62f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 636:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 638:	31 db                	xor    %ebx,%ebx
 63a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 63d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 640:	89 c8                	mov    %ecx,%eax
 642:	31 d2                	xor    %edx,%edx
 644:	89 cf                	mov    %ecx,%edi
 646:	f7 75 c4             	divl   -0x3c(%ebp)
 649:	0f b6 92 9c 0a 00 00 	movzbl 0xa9c(%edx),%edx
 650:	89 45 c0             	mov    %eax,-0x40(%ebp)
 653:	89 d8                	mov    %ebx,%eax
 655:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 658:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 65b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 65e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 661:	76 dd                	jbe    640 <printint+0x30>
  if(neg)
 663:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 666:	85 c9                	test   %ecx,%ecx
 668:	74 0c                	je     676 <printint+0x66>
    buf[i++] = '-';
 66a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 66f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 671:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 676:	8b 7d b8             	mov    -0x48(%ebp),%edi
 679:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 67d:	eb 07                	jmp    686 <printint+0x76>
 67f:	90                   	nop
 680:	0f b6 13             	movzbl (%ebx),%edx
 683:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 686:	83 ec 04             	sub    $0x4,%esp
 689:	88 55 d7             	mov    %dl,-0x29(%ebp)
 68c:	6a 01                	push   $0x1
 68e:	56                   	push   %esi
 68f:	57                   	push   %edi
 690:	e8 de fe ff ff       	call   573 <write>
  while(--i >= 0)
 695:	83 c4 10             	add    $0x10,%esp
 698:	39 de                	cmp    %ebx,%esi
 69a:	75 e4                	jne    680 <printint+0x70>
    putc(fd, buf[i]);
}
 69c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5f                   	pop    %edi
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret    
 6a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 6a8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 6af:	eb 87                	jmp    638 <printint+0x28>
 6b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6bf:	90                   	nop

000006c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6c0:	f3 0f 1e fb          	endbr32 
 6c4:	55                   	push   %ebp
 6c5:	89 e5                	mov    %esp,%ebp
 6c7:	57                   	push   %edi
 6c8:	56                   	push   %esi
 6c9:	53                   	push   %ebx
 6ca:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6cd:	8b 75 0c             	mov    0xc(%ebp),%esi
 6d0:	0f b6 1e             	movzbl (%esi),%ebx
 6d3:	84 db                	test   %bl,%bl
 6d5:	0f 84 b4 00 00 00    	je     78f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 6db:	8d 45 10             	lea    0x10(%ebp),%eax
 6de:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6e1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6e4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 6e6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6e9:	eb 33                	jmp    71e <printf+0x5e>
 6eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ef:	90                   	nop
 6f0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6f3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6f8:	83 f8 25             	cmp    $0x25,%eax
 6fb:	74 17                	je     714 <printf+0x54>
  write(fd, &c, 1);
 6fd:	83 ec 04             	sub    $0x4,%esp
 700:	88 5d e7             	mov    %bl,-0x19(%ebp)
 703:	6a 01                	push   $0x1
 705:	57                   	push   %edi
 706:	ff 75 08             	pushl  0x8(%ebp)
 709:	e8 65 fe ff ff       	call   573 <write>
 70e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 711:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 714:	0f b6 1e             	movzbl (%esi),%ebx
 717:	83 c6 01             	add    $0x1,%esi
 71a:	84 db                	test   %bl,%bl
 71c:	74 71                	je     78f <printf+0xcf>
    c = fmt[i] & 0xff;
 71e:	0f be cb             	movsbl %bl,%ecx
 721:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 724:	85 d2                	test   %edx,%edx
 726:	74 c8                	je     6f0 <printf+0x30>
      }
    } else if(state == '%'){
 728:	83 fa 25             	cmp    $0x25,%edx
 72b:	75 e7                	jne    714 <printf+0x54>
      if(c == 'd'){
 72d:	83 f8 64             	cmp    $0x64,%eax
 730:	0f 84 9a 00 00 00    	je     7d0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 736:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 73c:	83 f9 70             	cmp    $0x70,%ecx
 73f:	74 5f                	je     7a0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 741:	83 f8 73             	cmp    $0x73,%eax
 744:	0f 84 d6 00 00 00    	je     820 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74a:	83 f8 63             	cmp    $0x63,%eax
 74d:	0f 84 8d 00 00 00    	je     7e0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 753:	83 f8 25             	cmp    $0x25,%eax
 756:	0f 84 b4 00 00 00    	je     810 <printf+0x150>
  write(fd, &c, 1);
 75c:	83 ec 04             	sub    $0x4,%esp
 75f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 763:	6a 01                	push   $0x1
 765:	57                   	push   %edi
 766:	ff 75 08             	pushl  0x8(%ebp)
 769:	e8 05 fe ff ff       	call   573 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 76e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 771:	83 c4 0c             	add    $0xc,%esp
 774:	6a 01                	push   $0x1
 776:	83 c6 01             	add    $0x1,%esi
 779:	57                   	push   %edi
 77a:	ff 75 08             	pushl  0x8(%ebp)
 77d:	e8 f1 fd ff ff       	call   573 <write>
  for(i = 0; fmt[i]; i++){
 782:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 786:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 789:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 78b:	84 db                	test   %bl,%bl
 78d:	75 8f                	jne    71e <printf+0x5e>
    }
  }
}
 78f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 792:	5b                   	pop    %ebx
 793:	5e                   	pop    %esi
 794:	5f                   	pop    %edi
 795:	5d                   	pop    %ebp
 796:	c3                   	ret    
 797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 79e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 7a0:	83 ec 0c             	sub    $0xc,%esp
 7a3:	b9 10 00 00 00       	mov    $0x10,%ecx
 7a8:	6a 00                	push   $0x0
 7aa:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 7ad:	8b 45 08             	mov    0x8(%ebp),%eax
 7b0:	8b 13                	mov    (%ebx),%edx
 7b2:	e8 59 fe ff ff       	call   610 <printint>
        ap++;
 7b7:	89 d8                	mov    %ebx,%eax
 7b9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7bc:	31 d2                	xor    %edx,%edx
        ap++;
 7be:	83 c0 04             	add    $0x4,%eax
 7c1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 7c4:	e9 4b ff ff ff       	jmp    714 <printf+0x54>
 7c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 7d0:	83 ec 0c             	sub    $0xc,%esp
 7d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7d8:	6a 01                	push   $0x1
 7da:	eb ce                	jmp    7aa <printf+0xea>
 7dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 7e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7e3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7e6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 7e8:	6a 01                	push   $0x1
        ap++;
 7ea:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 7ed:	57                   	push   %edi
 7ee:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 7f1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7f4:	e8 7a fd ff ff       	call   573 <write>
        ap++;
 7f9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7fc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7ff:	31 d2                	xor    %edx,%edx
 801:	e9 0e ff ff ff       	jmp    714 <printf+0x54>
 806:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 80d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 810:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 813:	83 ec 04             	sub    $0x4,%esp
 816:	e9 59 ff ff ff       	jmp    774 <printf+0xb4>
 81b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 81f:	90                   	nop
        s = (char*)*ap;
 820:	8b 45 d0             	mov    -0x30(%ebp),%eax
 823:	8b 18                	mov    (%eax),%ebx
        ap++;
 825:	83 c0 04             	add    $0x4,%eax
 828:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 82b:	85 db                	test   %ebx,%ebx
 82d:	74 17                	je     846 <printf+0x186>
        while(*s != 0){
 82f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 832:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 834:	84 c0                	test   %al,%al
 836:	0f 84 d8 fe ff ff    	je     714 <printf+0x54>
 83c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 83f:	89 de                	mov    %ebx,%esi
 841:	8b 5d 08             	mov    0x8(%ebp),%ebx
 844:	eb 1a                	jmp    860 <printf+0x1a0>
          s = "(null)";
 846:	bb 94 0a 00 00       	mov    $0xa94,%ebx
        while(*s != 0){
 84b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 84e:	b8 28 00 00 00       	mov    $0x28,%eax
 853:	89 de                	mov    %ebx,%esi
 855:	8b 5d 08             	mov    0x8(%ebp),%ebx
 858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 85f:	90                   	nop
  write(fd, &c, 1);
 860:	83 ec 04             	sub    $0x4,%esp
          s++;
 863:	83 c6 01             	add    $0x1,%esi
 866:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 869:	6a 01                	push   $0x1
 86b:	57                   	push   %edi
 86c:	53                   	push   %ebx
 86d:	e8 01 fd ff ff       	call   573 <write>
        while(*s != 0){
 872:	0f b6 06             	movzbl (%esi),%eax
 875:	83 c4 10             	add    $0x10,%esp
 878:	84 c0                	test   %al,%al
 87a:	75 e4                	jne    860 <printf+0x1a0>
 87c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 87f:	31 d2                	xor    %edx,%edx
 881:	e9 8e fe ff ff       	jmp    714 <printf+0x54>
 886:	66 90                	xchg   %ax,%ax
 888:	66 90                	xchg   %ax,%ax
 88a:	66 90                	xchg   %ax,%ax
 88c:	66 90                	xchg   %ax,%ax
 88e:	66 90                	xchg   %ax,%ax

00000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	f3 0f 1e fb          	endbr32 
 894:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 895:	a1 18 0e 00 00       	mov    0xe18,%eax
{
 89a:	89 e5                	mov    %esp,%ebp
 89c:	57                   	push   %edi
 89d:	56                   	push   %esi
 89e:	53                   	push   %ebx
 89f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8a2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 8a4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a7:	39 c8                	cmp    %ecx,%eax
 8a9:	73 15                	jae    8c0 <free+0x30>
 8ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
 8b0:	39 d1                	cmp    %edx,%ecx
 8b2:	72 14                	jb     8c8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b4:	39 d0                	cmp    %edx,%eax
 8b6:	73 10                	jae    8c8 <free+0x38>
{
 8b8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ba:	8b 10                	mov    (%eax),%edx
 8bc:	39 c8                	cmp    %ecx,%eax
 8be:	72 f0                	jb     8b0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c0:	39 d0                	cmp    %edx,%eax
 8c2:	72 f4                	jb     8b8 <free+0x28>
 8c4:	39 d1                	cmp    %edx,%ecx
 8c6:	73 f0                	jae    8b8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 8cb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 8ce:	39 fa                	cmp    %edi,%edx
 8d0:	74 1e                	je     8f0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 8d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8d5:	8b 50 04             	mov    0x4(%eax),%edx
 8d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8db:	39 f1                	cmp    %esi,%ecx
 8dd:	74 28                	je     907 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8df:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 8e1:	5b                   	pop    %ebx
  freep = p;
 8e2:	a3 18 0e 00 00       	mov    %eax,0xe18
}
 8e7:	5e                   	pop    %esi
 8e8:	5f                   	pop    %edi
 8e9:	5d                   	pop    %ebp
 8ea:	c3                   	ret    
 8eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8ef:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 8f0:	03 72 04             	add    0x4(%edx),%esi
 8f3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f6:	8b 10                	mov    (%eax),%edx
 8f8:	8b 12                	mov    (%edx),%edx
 8fa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8fd:	8b 50 04             	mov    0x4(%eax),%edx
 900:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 903:	39 f1                	cmp    %esi,%ecx
 905:	75 d8                	jne    8df <free+0x4f>
    p->s.size += bp->s.size;
 907:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 90a:	a3 18 0e 00 00       	mov    %eax,0xe18
    p->s.size += bp->s.size;
 90f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 912:	8b 53 f8             	mov    -0x8(%ebx),%edx
 915:	89 10                	mov    %edx,(%eax)
}
 917:	5b                   	pop    %ebx
 918:	5e                   	pop    %esi
 919:	5f                   	pop    %edi
 91a:	5d                   	pop    %ebp
 91b:	c3                   	ret    
 91c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000920 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 920:	f3 0f 1e fb          	endbr32 
 924:	55                   	push   %ebp
 925:	89 e5                	mov    %esp,%ebp
 927:	57                   	push   %edi
 928:	56                   	push   %esi
 929:	53                   	push   %ebx
 92a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 930:	8b 3d 18 0e 00 00    	mov    0xe18,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 936:	8d 70 07             	lea    0x7(%eax),%esi
 939:	c1 ee 03             	shr    $0x3,%esi
 93c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 93f:	85 ff                	test   %edi,%edi
 941:	0f 84 a9 00 00 00    	je     9f0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 947:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 949:	8b 48 04             	mov    0x4(%eax),%ecx
 94c:	39 f1                	cmp    %esi,%ecx
 94e:	73 6d                	jae    9bd <malloc+0x9d>
 950:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 956:	bb 00 10 00 00       	mov    $0x1000,%ebx
 95b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 95e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 965:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 968:	eb 17                	jmp    981 <malloc+0x61>
 96a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 970:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 972:	8b 4a 04             	mov    0x4(%edx),%ecx
 975:	39 f1                	cmp    %esi,%ecx
 977:	73 4f                	jae    9c8 <malloc+0xa8>
 979:	8b 3d 18 0e 00 00    	mov    0xe18,%edi
 97f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 981:	39 c7                	cmp    %eax,%edi
 983:	75 eb                	jne    970 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 985:	83 ec 0c             	sub    $0xc,%esp
 988:	ff 75 e4             	pushl  -0x1c(%ebp)
 98b:	e8 4b fc ff ff       	call   5db <sbrk>
  if(p == (char*)-1)
 990:	83 c4 10             	add    $0x10,%esp
 993:	83 f8 ff             	cmp    $0xffffffff,%eax
 996:	74 1b                	je     9b3 <malloc+0x93>
  hp->s.size = nu;
 998:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 99b:	83 ec 0c             	sub    $0xc,%esp
 99e:	83 c0 08             	add    $0x8,%eax
 9a1:	50                   	push   %eax
 9a2:	e8 e9 fe ff ff       	call   890 <free>
  return freep;
 9a7:	a1 18 0e 00 00       	mov    0xe18,%eax
      if((p = morecore(nunits)) == 0)
 9ac:	83 c4 10             	add    $0x10,%esp
 9af:	85 c0                	test   %eax,%eax
 9b1:	75 bd                	jne    970 <malloc+0x50>
        return 0;
  }
}
 9b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 9b6:	31 c0                	xor    %eax,%eax
}
 9b8:	5b                   	pop    %ebx
 9b9:	5e                   	pop    %esi
 9ba:	5f                   	pop    %edi
 9bb:	5d                   	pop    %ebp
 9bc:	c3                   	ret    
    if(p->s.size >= nunits){
 9bd:	89 c2                	mov    %eax,%edx
 9bf:	89 f8                	mov    %edi,%eax
 9c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 9c8:	39 ce                	cmp    %ecx,%esi
 9ca:	74 54                	je     a20 <malloc+0x100>
        p->s.size -= nunits;
 9cc:	29 f1                	sub    %esi,%ecx
 9ce:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 9d1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 9d4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 9d7:	a3 18 0e 00 00       	mov    %eax,0xe18
}
 9dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 9df:	8d 42 08             	lea    0x8(%edx),%eax
}
 9e2:	5b                   	pop    %ebx
 9e3:	5e                   	pop    %esi
 9e4:	5f                   	pop    %edi
 9e5:	5d                   	pop    %ebp
 9e6:	c3                   	ret    
 9e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ee:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 9f0:	c7 05 18 0e 00 00 1c 	movl   $0xe1c,0xe18
 9f7:	0e 00 00 
    base.s.size = 0;
 9fa:	bf 1c 0e 00 00       	mov    $0xe1c,%edi
    base.s.ptr = freep = prevp = &base;
 9ff:	c7 05 1c 0e 00 00 1c 	movl   $0xe1c,0xe1c
 a06:	0e 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a09:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 a0b:	c7 05 20 0e 00 00 00 	movl   $0x0,0xe20
 a12:	00 00 00 
    if(p->s.size >= nunits){
 a15:	e9 36 ff ff ff       	jmp    950 <malloc+0x30>
 a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 a20:	8b 0a                	mov    (%edx),%ecx
 a22:	89 08                	mov    %ecx,(%eax)
 a24:	eb b1                	jmp    9d7 <malloc+0xb7>
