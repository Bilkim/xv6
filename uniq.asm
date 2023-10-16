
_uniq:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
        }
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
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 18             	sub    $0x18,%esp
  18:	8b 19                	mov    (%ecx),%ebx
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
    int file_start = 1;  // Default index of the first filename in argv[]

    // Parsing flags
    if (argc > 1 && argv[1][0] == '-') {
  1d:	83 fb 01             	cmp    $0x1,%ebx
  20:	0f 8e 9a 00 00 00    	jle    c0 <main+0xc0>
  26:	8b 57 04             	mov    0x4(%edi),%edx
    int file_start = 1;  // Default index of the first filename in argv[]
  29:	be 01 00 00 00       	mov    $0x1,%esi
    if (argc > 1 && argv[1][0] == '-') {
  2e:	80 3a 2d             	cmpb   $0x2d,(%edx)
  31:	74 63                	je     96 <main+0x96>
    if (argc < file_start + 1) {
        printf(2, "Usage: %s [-icd] <filename1> [<filename2>]\n", argv[0]);
        exit();
    }

    printf(1, "Uniq command is getting executed in user mode.\n");
  33:	50                   	push   %eax
  34:	50                   	push   %eax
  35:	68 c4 0c 00 00       	push   $0xcc4
  3a:	6a 01                	push   $0x1
  3c:	e8 bf 08 00 00       	call   900 <printf>

    process_file(argv[file_start]);
  41:	8d 0c b5 00 00 00 00 	lea    0x0(,%esi,4),%ecx
  48:	8d 14 0f             	lea    (%edi,%ecx,1),%edx
  4b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  4e:	59                   	pop    %ecx
  4f:	ff 32                	pushl  (%edx)
  51:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  54:	e8 97 02 00 00       	call   2f0 <process_file>
    if(argc == file_start + 2) {
  59:	31 c0                	xor    %eax,%eax
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	83 ee 01             	sub    $0x1,%esi
  61:	0f 95 c0             	setne  %al
  64:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  67:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  6a:	83 c0 03             	add    $0x3,%eax
  6d:	39 d8                	cmp    %ebx,%eax
  6f:	0f 84 9a 00 00 00    	je     10f <main+0x10f>
        process_file(argv[file_start + 1]);
    }


    // Call the sys_uniq system call here
    uniq(ignore_case, show_count, show_only_duplicated, argv[file_start]);
  75:	ff 32                	pushl  (%edx)
    if(argc == file_start + 2) {
        uniq(ignore_case, show_count, show_only_duplicated, argv[file_start + 1]);
  77:	ff 35 b8 10 00 00    	pushl  0x10b8
  7d:	ff 35 bc 10 00 00    	pushl  0x10bc
  83:	ff 35 c0 10 00 00    	pushl  0x10c0
  89:	e8 85 07 00 00       	call   813 <uniq>
  8e:	83 c4 10             	add    $0x10,%esp
    }

    exit();
  91:	e8 dd 06 00 00       	call   773 <exit>
        for (int j = 1; argv[1][j]; j++) {
  96:	0f be 42 01          	movsbl 0x1(%edx),%eax
  9a:	84 c0                	test   %al,%al
  9c:	74 4a                	je     e8 <main+0xe8>
  9e:	83 c2 02             	add    $0x2,%edx
            switch (argv[1][j]) {
  a1:	3c 64                	cmp    $0x64,%al
  a3:	74 5e                	je     103 <main+0x103>
  a5:	3c 69                	cmp    $0x69,%al
  a7:	74 4e                	je     f7 <main+0xf7>
  a9:	3c 63                	cmp    $0x63,%al
  ab:	74 27                	je     d4 <main+0xd4>
                    printf(2, "Unknown option: -%c\n", argv[1][j]);
  ad:	53                   	push   %ebx
  ae:	50                   	push   %eax
  af:	68 81 0c 00 00       	push   $0xc81
  b4:	6a 02                	push   $0x2
  b6:	e8 45 08 00 00       	call   900 <printf>
                    exit();
  bb:	e8 b3 06 00 00       	call   773 <exit>
        printf(2, "Usage: %s [-icd] <filename1> [<filename2>]\n", argv[0]);
  c0:	56                   	push   %esi
  c1:	ff 37                	pushl  (%edi)
  c3:	68 98 0c 00 00       	push   $0xc98
  c8:	6a 02                	push   $0x2
  ca:	e8 31 08 00 00       	call   900 <printf>
        exit();
  cf:	e8 9f 06 00 00       	call   773 <exit>
                case 'c': show_count = 1; break;
  d4:	c7 05 bc 10 00 00 01 	movl   $0x1,0x10bc
  db:	00 00 00 
        for (int j = 1; argv[1][j]; j++) {
  de:	0f be 02             	movsbl (%edx),%eax
  e1:	83 c2 01             	add    $0x1,%edx
  e4:	84 c0                	test   %al,%al
  e6:	75 b9                	jne    a1 <main+0xa1>
    if (argc < file_start + 1) {
  e8:	83 fb 02             	cmp    $0x2,%ebx
  eb:	74 d3                	je     c0 <main+0xc0>
        file_start = 2;  // If flags were passed, first filename will start from index 2 in argv[]
  ed:	be 02 00 00 00       	mov    $0x2,%esi
  f2:	e9 3c ff ff ff       	jmp    33 <main+0x33>
                case 'i': ignore_case = 1; break;
  f7:	c7 05 c0 10 00 00 01 	movl   $0x1,0x10c0
  fe:	00 00 00 
 101:	eb db                	jmp    de <main+0xde>
                case 'd': show_only_duplicated = 1; break;
 103:	c7 05 b8 10 00 00 01 	movl   $0x1,0x10b8
 10a:	00 00 00 
 10d:	eb cf                	jmp    de <main+0xde>
        process_file(argv[file_start + 1]);
 10f:	8d 5c 0f 04          	lea    0x4(%edi,%ecx,1),%ebx
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	ff 33                	pushl  (%ebx)
 118:	e8 d3 01 00 00       	call   2f0 <process_file>
    uniq(ignore_case, show_count, show_only_duplicated, argv[file_start]);
 11d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 120:	ff 32                	pushl  (%edx)
 122:	ff 35 b8 10 00 00    	pushl  0x10b8
 128:	ff 35 bc 10 00 00    	pushl  0x10bc
 12e:	ff 35 c0 10 00 00    	pushl  0x10c0
 134:	e8 da 06 00 00       	call   813 <uniq>
        uniq(ignore_case, show_count, show_only_duplicated, argv[file_start + 1]);
 139:	83 c4 20             	add    $0x20,%esp
 13c:	ff 33                	pushl  (%ebx)
 13e:	e9 34 ff ff ff       	jmp    77 <main+0x77>
 143:	66 90                	xchg   %ax,%ax
 145:	66 90                	xchg   %ax,%ax
 147:	66 90                	xchg   %ax,%ax
 149:	66 90                	xchg   %ax,%ax
 14b:	66 90                	xchg   %ax,%ax
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <tolower>:
int tolower(int c) {
 150:	f3 0f 1e fb          	endbr32 
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15a:	5d                   	pop    %ebp
    if (c >= 'A' && c <= 'Z') {
 15b:	8d 48 bf             	lea    -0x41(%eax),%ecx
        return c + 'a' - 'A';
 15e:	8d 50 20             	lea    0x20(%eax),%edx
 161:	83 f9 1a             	cmp    $0x1a,%ecx
 164:	0f 42 c2             	cmovb  %edx,%eax
}
 167:	c3                   	ret    
 168:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 16f:	90                   	nop

00000170 <remove_trailing_newline>:
void remove_trailing_newline(char *str) {
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	53                   	push   %ebx
 178:	83 ec 10             	sub    $0x10,%esp
 17b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int len = strlen(str);
 17e:	53                   	push   %ebx
 17f:	e8 0c 04 00 00       	call   590 <strlen>
    while (len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r')) {
 184:	83 c4 10             	add    $0x10,%esp
 187:	85 c0                	test   %eax,%eax
 189:	7e 26                	jle    1b1 <remove_trailing_newline+0x41>
 18b:	8d 44 03 ff          	lea    -0x1(%ebx,%eax,1),%eax
 18f:	eb 13                	jmp    1a4 <remove_trailing_newline+0x34>
 191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        str[len - 1] = '\0';
 198:	c6 00 00             	movb   $0x0,(%eax)
    while (len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r')) {
 19b:	8d 50 ff             	lea    -0x1(%eax),%edx
 19e:	39 d8                	cmp    %ebx,%eax
 1a0:	74 0f                	je     1b1 <remove_trailing_newline+0x41>
 1a2:	89 d0                	mov    %edx,%eax
 1a4:	0f b6 10             	movzbl (%eax),%edx
 1a7:	80 fa 0a             	cmp    $0xa,%dl
 1aa:	74 ec                	je     198 <remove_trailing_newline+0x28>
 1ac:	80 fa 0d             	cmp    $0xd,%dl
 1af:	74 e7                	je     198 <remove_trailing_newline+0x28>
}
 1b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    
 1b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1bd:	8d 76 00             	lea    0x0(%esi),%esi

000001c0 <strcmp_custom>:
int strcmp_custom(const char *s1, const char *s2) {
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	57                   	push   %edi
 1c8:	56                   	push   %esi
 1c9:	53                   	push   %ebx
 1ca:	83 ec 0c             	sub    $0xc,%esp
 1cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1d0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
    if (ignore_case) {
 1d3:	8b 35 c0 10 00 00    	mov    0x10c0,%esi
 1d9:	0f be 01             	movsbl (%ecx),%eax
 1dc:	0f be 13             	movsbl (%ebx),%edx
 1df:	85 f6                	test   %esi,%esi
 1e1:	75 42                	jne    225 <strcmp_custom+0x65>
 1e3:	eb 79                	jmp    25e <strcmp_custom+0x9e>
 1e5:	8d 76 00             	lea    0x0(%esi),%esi
 1e8:	8d 78 bf             	lea    -0x41(%eax),%edi
        while (*s1 && *s2) {
 1eb:	84 d2                	test   %dl,%dl
 1ed:	0f 84 85 00 00 00    	je     278 <strcmp_custom+0xb8>
        return c + 'a' - 'A';
 1f3:	8d 70 20             	lea    0x20(%eax),%esi
 1f6:	83 ff 1a             	cmp    $0x1a,%edi
 1f9:	89 75 e8             	mov    %esi,-0x18(%ebp)
 1fc:	0f 43 f0             	cmovae %eax,%esi
 1ff:	89 75 ec             	mov    %esi,-0x14(%ebp)
    if (c >= 'A' && c <= 'Z') {
 202:	8d 72 bf             	lea    -0x41(%edx),%esi
 205:	89 75 f0             	mov    %esi,-0x10(%ebp)
        return c + 'a' - 'A';
 208:	8d 72 20             	lea    0x20(%edx),%esi
 20b:	83 7d f0 1a          	cmpl   $0x1a,-0x10(%ebp)
 20f:	0f 43 f2             	cmovae %edx,%esi
            if (tolower(*s1) != tolower(*s2))
 212:	3b 75 ec             	cmp    -0x14(%ebp),%esi
 215:	75 79                	jne    290 <strcmp_custom+0xd0>
        while (*s1 && *s2) {
 217:	0f be 41 01          	movsbl 0x1(%ecx),%eax
 21b:	0f be 53 01          	movsbl 0x1(%ebx),%edx
            s1++;
 21f:	83 c1 01             	add    $0x1,%ecx
            s2++;
 222:	83 c3 01             	add    $0x1,%ebx
        while (*s1 && *s2) {
 225:	84 c0                	test   %al,%al
 227:	75 bf                	jne    1e8 <strcmp_custom+0x28>
    if (c >= 'A' && c <= 'Z') {
 229:	8d 42 bf             	lea    -0x41(%edx),%eax
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        return tolower(*s1) - tolower(*s2);
 22f:	31 c0                	xor    %eax,%eax
        return c + 'a' - 'A';
 231:	83 7d f0 1a          	cmpl   $0x1a,-0x10(%ebp)
 235:	8d 4a 20             	lea    0x20(%edx),%ecx
 238:	0f 42 d1             	cmovb  %ecx,%edx
}
 23b:	83 c4 0c             	add    $0xc,%esp
 23e:	5b                   	pop    %ebx
 23f:	5e                   	pop    %esi
        return *s1 - *s2;
 240:	29 d0                	sub    %edx,%eax
}
 242:	5f                   	pop    %edi
 243:	5d                   	pop    %ebp
 244:	c3                   	ret    
 245:	8d 76 00             	lea    0x0(%esi),%esi
        while (*s1 != '\0' && *s2 != '\0' && *s1 == *s2) {
 248:	38 d0                	cmp    %dl,%al
 24a:	75 24                	jne    270 <strcmp_custom+0xb0>
 24c:	84 d2                	test   %dl,%dl
 24e:	74 20                	je     270 <strcmp_custom+0xb0>
 250:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
 254:	0f be 53 01          	movsbl 0x1(%ebx),%edx
            s1++;
 258:	83 c1 01             	add    $0x1,%ecx
            s2++;
 25b:	83 c3 01             	add    $0x1,%ebx
        while (*s1 != '\0' && *s2 != '\0' && *s1 == *s2) {
 25e:	84 c0                	test   %al,%al
 260:	75 e6                	jne    248 <strcmp_custom+0x88>
}
 262:	83 c4 0c             	add    $0xc,%esp
        return *s1 - *s2;
 265:	89 f0                	mov    %esi,%eax
}
 267:	5b                   	pop    %ebx
        return *s1 - *s2;
 268:	29 d0                	sub    %edx,%eax
}
 26a:	5e                   	pop    %esi
 26b:	5f                   	pop    %edi
 26c:	5d                   	pop    %ebp
 26d:	c3                   	ret    
 26e:	66 90                	xchg   %ax,%ax
 270:	0f be f0             	movsbl %al,%esi
 273:	eb ed                	jmp    262 <strcmp_custom+0xa2>
 275:	8d 76 00             	lea    0x0(%esi),%esi
        return tolower(*s1) - tolower(*s2);
 278:	31 d2                	xor    %edx,%edx
        return c + 'a' - 'A';
 27a:	89 c1                	mov    %eax,%ecx
 27c:	83 c0 20             	add    $0x20,%eax
 27f:	83 ff 1a             	cmp    $0x1a,%edi
 282:	0f 43 c1             	cmovae %ecx,%eax
}
 285:	83 c4 0c             	add    $0xc,%esp
 288:	5b                   	pop    %ebx
 289:	5e                   	pop    %esi
        return *s1 - *s2;
 28a:	29 d0                	sub    %edx,%eax
}
 28c:	5f                   	pop    %edi
 28d:	5d                   	pop    %ebp
 28e:	c3                   	ret    
 28f:	90                   	nop
        return c + 'a' - 'A';
 290:	83 ff 1a             	cmp    $0x1a,%edi
 293:	0f 42 45 e8          	cmovb  -0x18(%ebp),%eax
 297:	eb 98                	jmp    231 <strcmp_custom+0x71>
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002a0 <strncpy_custom>:
void strncpy_custom(char *dest, const char *src, int n) {
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	57                   	push   %edi
 2a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
 2ae:	56                   	push   %esi
 2af:	53                   	push   %ebx
 2b0:	8b 5d 10             	mov    0x10(%ebp),%ebx
    for (i = 0; i < n && src[i] != '\0'; i++) {
 2b3:	89 ce                	mov    %ecx,%esi
 2b5:	85 db                	test   %ebx,%ebx
 2b7:	7e 1c                	jle    2d5 <strncpy_custom+0x35>
 2b9:	31 c0                	xor    %eax,%eax
 2bb:	eb 0d                	jmp    2ca <strncpy_custom+0x2a>
 2bd:	8d 76 00             	lea    0x0(%esi),%esi
        dest[i] = src[i];
 2c0:	88 14 01             	mov    %dl,(%ecx,%eax,1)
    for (i = 0; i < n && src[i] != '\0'; i++) {
 2c3:	83 c0 01             	add    $0x1,%eax
 2c6:	39 c3                	cmp    %eax,%ebx
 2c8:	74 16                	je     2e0 <strncpy_custom+0x40>
 2ca:	0f b6 14 07          	movzbl (%edi,%eax,1),%edx
 2ce:	8d 34 01             	lea    (%ecx,%eax,1),%esi
 2d1:	84 d2                	test   %dl,%dl
 2d3:	75 eb                	jne    2c0 <strncpy_custom+0x20>
    dest[i] = '\0';
 2d5:	c6 06 00             	movb   $0x0,(%esi)
}
 2d8:	5b                   	pop    %ebx
 2d9:	5e                   	pop    %esi
 2da:	5f                   	pop    %edi
 2db:	5d                   	pop    %ebp
 2dc:	c3                   	ret    
 2dd:	8d 76 00             	lea    0x0(%esi),%esi
 2e0:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
    dest[i] = '\0';
 2e3:	c6 06 00             	movb   $0x0,(%esi)
}
 2e6:	5b                   	pop    %ebx
 2e7:	5e                   	pop    %esi
 2e8:	5f                   	pop    %edi
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    
 2eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2ef:	90                   	nop

000002f0 <process_file>:
void process_file(char *filename) {
 2f0:	f3 0f 1e fb          	endbr32 
 2f4:	55                   	push   %ebp
 2f5:	89 e5                	mov    %esp,%ebp
 2f7:	57                   	push   %edi
 2f8:	56                   	push   %esi
 2f9:	53                   	push   %ebx
 2fa:	81 ec 24 04 00 00    	sub    $0x424,%esp
 300:	8b 5d 08             	mov    0x8(%ebp),%ebx
    int fd = open(filename, O_RDONLY);
 303:	6a 00                	push   $0x0
 305:	53                   	push   %ebx
 306:	e8 a8 04 00 00       	call   7b3 <open>
    if (fd < 0) {
 30b:	83 c4 10             	add    $0x10,%esp
    int fd = open(filename, O_RDONLY);
 30e:	89 85 dc fb ff ff    	mov    %eax,-0x424(%ebp)
    if (fd < 0) {
 314:	85 c0                	test   %eax,%eax
 316:	0f 88 cd 01 00 00    	js     4e9 <process_file+0x1f9>
    char prev_line[BUFSIZE] = "";
 31c:	8d bd ec fd ff ff    	lea    -0x214(%ebp),%edi
 322:	b9 7f 00 00 00       	mov    $0x7f,%ecx
 327:	31 c0                	xor    %eax,%eax
 329:	c7 85 e8 fd ff ff 00 	movl   $0x0,-0x218(%ebp)
 330:	00 00 00 
 333:	f3 ab                	rep stos %eax,%es:(%edi)
    int count = 0;
 335:	8d b5 e8 fb ff ff    	lea    -0x418(%ebp),%esi
 33b:	c7 85 e0 fb ff ff 00 	movl   $0x0,-0x420(%ebp)
 342:	00 00 00 
 345:	8d 76 00             	lea    0x0(%esi),%esi
        int n = read(fd, buf, BUFSIZE);
 348:	83 ec 04             	sub    $0x4,%esp
 34b:	68 00 02 00 00       	push   $0x200
 350:	56                   	push   %esi
 351:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
 357:	e8 2f 04 00 00       	call   78b <read>
        if (n <= 0) {
 35c:	83 c4 10             	add    $0x10,%esp
        int n = read(fd, buf, BUFSIZE);
 35f:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
        if (n <= 0) {
 365:	85 c0                	test   %eax,%eax
 367:	0f 8e e3 00 00 00    	jle    450 <process_file+0x160>
        for (int i = 0; i < n; i++) {
 36d:	31 ff                	xor    %edi,%edi
        int line_start = 0;
 36f:	31 c0                	xor    %eax,%eax
 371:	eb 0d                	jmp    380 <process_file+0x90>
 373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 377:	90                   	nop
        for (int i = 0; i < n; i++) {
 378:	39 bd e4 fb ff ff    	cmp    %edi,-0x41c(%ebp)
 37e:	74 c8                	je     348 <process_file+0x58>
            if (buf[i] == '\n') {
 380:	0f b6 14 3e          	movzbl (%esi,%edi,1),%edx
 384:	83 c7 01             	add    $0x1,%edi
 387:	80 fa 0a             	cmp    $0xa,%dl
 38a:	75 ec                	jne    378 <process_file+0x88>
                if (strcmp_custom(buf + line_start, prev_line) == 0) {
 38c:	83 ec 08             	sub    $0x8,%esp
 38f:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
 392:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
                buf[i] = '\0';
 398:	c6 84 3d e7 fb ff ff 	movb   $0x0,-0x419(%ebp,%edi,1)
 39f:	00 
                if (strcmp_custom(buf + line_start, prev_line) == 0) {
 3a0:	50                   	push   %eax
 3a1:	53                   	push   %ebx
 3a2:	e8 19 fe ff ff       	call   1c0 <strcmp_custom>
 3a7:	83 c4 10             	add    $0x10,%esp
 3aa:	85 c0                	test   %eax,%eax
 3ac:	75 12                	jne    3c0 <process_file+0xd0>
                    count++;
 3ae:	83 85 e0 fb ff ff 01 	addl   $0x1,-0x420(%ebp)
                    count = 1;
 3b5:	89 f8                	mov    %edi,%eax
 3b7:	eb bf                	jmp    378 <process_file+0x88>
 3b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
                    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
 3c0:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
 3c6:	85 c0                	test   %eax,%eax
 3c8:	74 38                	je     402 <process_file+0x112>
 3ca:	8b 15 b8 10 00 00    	mov    0x10b8,%edx
 3d0:	85 d2                	test   %edx,%edx
 3d2:	74 05                	je     3d9 <process_file+0xe9>
 3d4:	83 f8 01             	cmp    $0x1,%eax
 3d7:	74 29                	je     402 <process_file+0x112>
                        if (show_count) {
 3d9:	a1 bc 10 00 00       	mov    0x10bc,%eax
 3de:	85 c0                	test   %eax,%eax
 3e0:	0f 84 ca 00 00 00    	je     4b0 <process_file+0x1c0>
                            printf(1, "%d %s\n", count, prev_line);
 3e6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 3ec:	50                   	push   %eax
 3ed:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 3f3:	68 7a 0c 00 00       	push   $0xc7a
 3f8:	6a 01                	push   $0x1
 3fa:	e8 01 05 00 00       	call   900 <printf>
 3ff:	83 c4 10             	add    $0x10,%esp
                    remove_trailing_newline(buf + line_start);
 402:	83 ec 0c             	sub    $0xc,%esp
 405:	53                   	push   %ebx
 406:	e8 65 fd ff ff       	call   170 <remove_trailing_newline>
    for (i = 0; i < n && src[i] != '\0'; i++) {
 40b:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
 411:	89 d8                	mov    %ebx,%eax
 413:	83 c4 10             	add    $0x10,%esp
 416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 41d:	8d 76 00             	lea    0x0(%esi),%esi
 420:	0f b6 08             	movzbl (%eax),%ecx
 423:	89 d3                	mov    %edx,%ebx
 425:	84 c9                	test   %cl,%cl
 427:	74 12                	je     43b <process_file+0x14b>
        dest[i] = src[i];
 429:	88 0a                	mov    %cl,(%edx)
    for (i = 0; i < n && src[i] != '\0'; i++) {
 42b:	8d 53 01             	lea    0x1(%ebx),%edx
 42e:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 431:	83 c0 01             	add    $0x1,%eax
 434:	39 d3                	cmp    %edx,%ebx
 436:	75 e8                	jne    420 <process_file+0x130>
 438:	8d 5d e8             	lea    -0x18(%ebp),%ebx
    dest[i] = '\0';
 43b:	c6 03 00             	movb   $0x0,(%ebx)
                    count = 1;
 43e:	89 f8                	mov    %edi,%eax
 440:	c7 85 e0 fb ff ff 01 	movl   $0x1,-0x420(%ebp)
 447:	00 00 00 
                line_start = i + 1;
 44a:	e9 29 ff ff ff       	jmp    378 <process_file+0x88>
 44f:	90                   	nop
            if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
 450:	8b 85 e0 fb ff ff    	mov    -0x420(%ebp),%eax
 456:	85 c0                	test   %eax,%eax
 458:	74 35                	je     48f <process_file+0x19f>
 45a:	8b 1d b8 10 00 00    	mov    0x10b8,%ebx
 460:	85 db                	test   %ebx,%ebx
 462:	74 05                	je     469 <process_file+0x179>
 464:	83 f8 01             	cmp    $0x1,%eax
 467:	74 26                	je     48f <process_file+0x19f>
                if (show_count) {
 469:	8b 0d bc 10 00 00    	mov    0x10bc,%ecx
 46f:	85 c9                	test   %ecx,%ecx
 471:	74 5b                	je     4ce <process_file+0x1de>
                    printf(1, "%d %s\n", count, prev_line);
 473:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 479:	50                   	push   %eax
 47a:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
 480:	68 7a 0c 00 00       	push   $0xc7a
 485:	6a 01                	push   $0x1
 487:	e8 74 04 00 00       	call   900 <printf>
 48c:	83 c4 10             	add    $0x10,%esp
    close(fd);
 48f:	83 ec 0c             	sub    $0xc,%esp
 492:	ff b5 dc fb ff ff    	pushl  -0x424(%ebp)
 498:	e8 fe 02 00 00       	call   79b <close>
 49d:	83 c4 10             	add    $0x10,%esp
}
 4a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5f                   	pop    %edi
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    
 4a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop
                            printf(1, "%s\n", prev_line);
 4b0:	83 ec 04             	sub    $0x4,%esp
 4b3:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 4b9:	50                   	push   %eax
 4ba:	68 7d 0c 00 00       	push   $0xc7d
 4bf:	6a 01                	push   $0x1
 4c1:	e8 3a 04 00 00       	call   900 <printf>
 4c6:	83 c4 10             	add    $0x10,%esp
 4c9:	e9 34 ff ff ff       	jmp    402 <process_file+0x112>
                    printf(1, "%s\n", prev_line);
 4ce:	83 ec 04             	sub    $0x4,%esp
 4d1:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 4d7:	50                   	push   %eax
 4d8:	68 7d 0c 00 00       	push   $0xc7d
 4dd:	6a 01                	push   $0x1
 4df:	e8 1c 04 00 00       	call   900 <printf>
 4e4:	83 c4 10             	add    $0x10,%esp
 4e7:	eb a6                	jmp    48f <process_file+0x19f>
        printf(2, "Error opening %s\n", filename);
 4e9:	83 ec 04             	sub    $0x4,%esp
 4ec:	53                   	push   %ebx
 4ed:	68 68 0c 00 00       	push   $0xc68
 4f2:	6a 02                	push   $0x2
 4f4:	e8 07 04 00 00       	call   900 <printf>
        return;
 4f9:	83 c4 10             	add    $0x10,%esp
}
 4fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4ff:	5b                   	pop    %ebx
 500:	5e                   	pop    %esi
 501:	5f                   	pop    %edi
 502:	5d                   	pop    %ebp
 503:	c3                   	ret    
 504:	66 90                	xchg   %ax,%ax
 506:	66 90                	xchg   %ax,%ax
 508:	66 90                	xchg   %ax,%ax
 50a:	66 90                	xchg   %ax,%ax
 50c:	66 90                	xchg   %ax,%ax
 50e:	66 90                	xchg   %ax,%ax

00000510 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 510:	f3 0f 1e fb          	endbr32 
 514:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 515:	31 c0                	xor    %eax,%eax
{
 517:	89 e5                	mov    %esp,%ebp
 519:	53                   	push   %ebx
 51a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 51d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 520:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 524:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 527:	83 c0 01             	add    $0x1,%eax
 52a:	84 d2                	test   %dl,%dl
 52c:	75 f2                	jne    520 <strcpy+0x10>
    ;
  return os;
}
 52e:	89 c8                	mov    %ecx,%eax
 530:	5b                   	pop    %ebx
 531:	5d                   	pop    %ebp
 532:	c3                   	ret    
 533:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000540 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 540:	f3 0f 1e fb          	endbr32 
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	53                   	push   %ebx
 548:	8b 4d 08             	mov    0x8(%ebp),%ecx
 54b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 54e:	0f b6 01             	movzbl (%ecx),%eax
 551:	0f b6 1a             	movzbl (%edx),%ebx
 554:	84 c0                	test   %al,%al
 556:	75 19                	jne    571 <strcmp+0x31>
 558:	eb 26                	jmp    580 <strcmp+0x40>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 560:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 564:	83 c1 01             	add    $0x1,%ecx
 567:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 56a:	0f b6 1a             	movzbl (%edx),%ebx
 56d:	84 c0                	test   %al,%al
 56f:	74 0f                	je     580 <strcmp+0x40>
 571:	38 d8                	cmp    %bl,%al
 573:	74 eb                	je     560 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 575:	29 d8                	sub    %ebx,%eax
}
 577:	5b                   	pop    %ebx
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    
 57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 580:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 582:	29 d8                	sub    %ebx,%eax
}
 584:	5b                   	pop    %ebx
 585:	5d                   	pop    %ebp
 586:	c3                   	ret    
 587:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58e:	66 90                	xchg   %ax,%ax

00000590 <strlen>:

uint
strlen(const char *s)
{
 590:	f3 0f 1e fb          	endbr32 
 594:	55                   	push   %ebp
 595:	89 e5                	mov    %esp,%ebp
 597:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 59a:	80 3a 00             	cmpb   $0x0,(%edx)
 59d:	74 21                	je     5c0 <strlen+0x30>
 59f:	31 c0                	xor    %eax,%eax
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5a8:	83 c0 01             	add    $0x1,%eax
 5ab:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 5af:	89 c1                	mov    %eax,%ecx
 5b1:	75 f5                	jne    5a8 <strlen+0x18>
    ;
  return n;
}
 5b3:	89 c8                	mov    %ecx,%eax
 5b5:	5d                   	pop    %ebp
 5b6:	c3                   	ret    
 5b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5be:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 5c0:	31 c9                	xor    %ecx,%ecx
}
 5c2:	5d                   	pop    %ebp
 5c3:	89 c8                	mov    %ecx,%eax
 5c5:	c3                   	ret    
 5c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5cd:	8d 76 00             	lea    0x0(%esi),%esi

000005d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5d0:	f3 0f 1e fb          	endbr32 
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	57                   	push   %edi
 5d8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5db:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5de:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e1:	89 d7                	mov    %edx,%edi
 5e3:	fc                   	cld    
 5e4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5e6:	89 d0                	mov    %edx,%eax
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    
 5eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5ef:	90                   	nop

000005f0 <strchr>:

char*
strchr(const char *s, char c)
{
 5f0:	f3 0f 1e fb          	endbr32 
 5f4:	55                   	push   %ebp
 5f5:	89 e5                	mov    %esp,%ebp
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5fe:	0f b6 10             	movzbl (%eax),%edx
 601:	84 d2                	test   %dl,%dl
 603:	75 16                	jne    61b <strchr+0x2b>
 605:	eb 21                	jmp    628 <strchr+0x38>
 607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 60e:	66 90                	xchg   %ax,%ax
 610:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 614:	83 c0 01             	add    $0x1,%eax
 617:	84 d2                	test   %dl,%dl
 619:	74 0d                	je     628 <strchr+0x38>
    if(*s == c)
 61b:	38 d1                	cmp    %dl,%cl
 61d:	75 f1                	jne    610 <strchr+0x20>
      return (char*)s;
  return 0;
}
 61f:	5d                   	pop    %ebp
 620:	c3                   	ret    
 621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 628:	31 c0                	xor    %eax,%eax
}
 62a:	5d                   	pop    %ebp
 62b:	c3                   	ret    
 62c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000630 <gets>:

char*
gets(char *buf, int max)
{
 630:	f3 0f 1e fb          	endbr32 
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	57                   	push   %edi
 638:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 639:	31 f6                	xor    %esi,%esi
{
 63b:	53                   	push   %ebx
 63c:	89 f3                	mov    %esi,%ebx
 63e:	83 ec 1c             	sub    $0x1c,%esp
 641:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 644:	eb 33                	jmp    679 <gets+0x49>
 646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 650:	83 ec 04             	sub    $0x4,%esp
 653:	8d 45 e7             	lea    -0x19(%ebp),%eax
 656:	6a 01                	push   $0x1
 658:	50                   	push   %eax
 659:	6a 00                	push   $0x0
 65b:	e8 2b 01 00 00       	call   78b <read>
    if(cc < 1)
 660:	83 c4 10             	add    $0x10,%esp
 663:	85 c0                	test   %eax,%eax
 665:	7e 1c                	jle    683 <gets+0x53>
      break;
    buf[i++] = c;
 667:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 66b:	83 c7 01             	add    $0x1,%edi
 66e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 671:	3c 0a                	cmp    $0xa,%al
 673:	74 23                	je     698 <gets+0x68>
 675:	3c 0d                	cmp    $0xd,%al
 677:	74 1f                	je     698 <gets+0x68>
  for(i=0; i+1 < max; ){
 679:	83 c3 01             	add    $0x1,%ebx
 67c:	89 fe                	mov    %edi,%esi
 67e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 681:	7c cd                	jl     650 <gets+0x20>
 683:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 685:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 688:	c6 03 00             	movb   $0x0,(%ebx)
}
 68b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 68e:	5b                   	pop    %ebx
 68f:	5e                   	pop    %esi
 690:	5f                   	pop    %edi
 691:	5d                   	pop    %ebp
 692:	c3                   	ret    
 693:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 697:	90                   	nop
 698:	8b 75 08             	mov    0x8(%ebp),%esi
 69b:	8b 45 08             	mov    0x8(%ebp),%eax
 69e:	01 de                	add    %ebx,%esi
 6a0:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 6a2:	c6 03 00             	movb   $0x0,(%ebx)
}
 6a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6a8:	5b                   	pop    %ebx
 6a9:	5e                   	pop    %esi
 6aa:	5f                   	pop    %edi
 6ab:	5d                   	pop    %ebp
 6ac:	c3                   	ret    
 6ad:	8d 76 00             	lea    0x0(%esi),%esi

000006b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 6b0:	f3 0f 1e fb          	endbr32 
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	56                   	push   %esi
 6b8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6b9:	83 ec 08             	sub    $0x8,%esp
 6bc:	6a 00                	push   $0x0
 6be:	ff 75 08             	pushl  0x8(%ebp)
 6c1:	e8 ed 00 00 00       	call   7b3 <open>
  if(fd < 0)
 6c6:	83 c4 10             	add    $0x10,%esp
 6c9:	85 c0                	test   %eax,%eax
 6cb:	78 2b                	js     6f8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 6cd:	83 ec 08             	sub    $0x8,%esp
 6d0:	ff 75 0c             	pushl  0xc(%ebp)
 6d3:	89 c3                	mov    %eax,%ebx
 6d5:	50                   	push   %eax
 6d6:	e8 f0 00 00 00       	call   7cb <fstat>
  close(fd);
 6db:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6de:	89 c6                	mov    %eax,%esi
  close(fd);
 6e0:	e8 b6 00 00 00       	call   79b <close>
  return r;
 6e5:	83 c4 10             	add    $0x10,%esp
}
 6e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6eb:	89 f0                	mov    %esi,%eax
 6ed:	5b                   	pop    %ebx
 6ee:	5e                   	pop    %esi
 6ef:	5d                   	pop    %ebp
 6f0:	c3                   	ret    
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 6f8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6fd:	eb e9                	jmp    6e8 <stat+0x38>
 6ff:	90                   	nop

00000700 <atoi>:

int
atoi(const char *s)
{
 700:	f3 0f 1e fb          	endbr32 
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	53                   	push   %ebx
 708:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 70b:	0f be 02             	movsbl (%edx),%eax
 70e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 711:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 714:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 719:	77 1a                	ja     735 <atoi+0x35>
 71b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 71f:	90                   	nop
    n = n*10 + *s++ - '0';
 720:	83 c2 01             	add    $0x1,%edx
 723:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 726:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 72a:	0f be 02             	movsbl (%edx),%eax
 72d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 730:	80 fb 09             	cmp    $0x9,%bl
 733:	76 eb                	jbe    720 <atoi+0x20>
  return n;
}
 735:	89 c8                	mov    %ecx,%eax
 737:	5b                   	pop    %ebx
 738:	5d                   	pop    %ebp
 739:	c3                   	ret    
 73a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000740 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 740:	f3 0f 1e fb          	endbr32 
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	57                   	push   %edi
 748:	8b 45 10             	mov    0x10(%ebp),%eax
 74b:	8b 55 08             	mov    0x8(%ebp),%edx
 74e:	56                   	push   %esi
 74f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 752:	85 c0                	test   %eax,%eax
 754:	7e 0f                	jle    765 <memmove+0x25>
 756:	01 d0                	add    %edx,%eax
  dst = vdst;
 758:	89 d7                	mov    %edx,%edi
 75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 760:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 761:	39 f8                	cmp    %edi,%eax
 763:	75 fb                	jne    760 <memmove+0x20>
  return vdst;
}
 765:	5e                   	pop    %esi
 766:	89 d0                	mov    %edx,%eax
 768:	5f                   	pop    %edi
 769:	5d                   	pop    %ebp
 76a:	c3                   	ret    

0000076b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 76b:	b8 01 00 00 00       	mov    $0x1,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <exit>:
SYSCALL(exit)
 773:	b8 02 00 00 00       	mov    $0x2,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <wait>:
SYSCALL(wait)
 77b:	b8 03 00 00 00       	mov    $0x3,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <pipe>:
SYSCALL(pipe)
 783:	b8 04 00 00 00       	mov    $0x4,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <read>:
SYSCALL(read)
 78b:	b8 05 00 00 00       	mov    $0x5,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <write>:
SYSCALL(write)
 793:	b8 10 00 00 00       	mov    $0x10,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <close>:
SYSCALL(close)
 79b:	b8 15 00 00 00       	mov    $0x15,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <kill>:
SYSCALL(kill)
 7a3:	b8 06 00 00 00       	mov    $0x6,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <exec>:
SYSCALL(exec)
 7ab:	b8 07 00 00 00       	mov    $0x7,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <open>:
SYSCALL(open)
 7b3:	b8 0f 00 00 00       	mov    $0xf,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <mknod>:
SYSCALL(mknod)
 7bb:	b8 11 00 00 00       	mov    $0x11,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <unlink>:
SYSCALL(unlink)
 7c3:	b8 12 00 00 00       	mov    $0x12,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <fstat>:
SYSCALL(fstat)
 7cb:	b8 08 00 00 00       	mov    $0x8,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <link>:
SYSCALL(link)
 7d3:	b8 13 00 00 00       	mov    $0x13,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <mkdir>:
SYSCALL(mkdir)
 7db:	b8 14 00 00 00       	mov    $0x14,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <chdir>:
SYSCALL(chdir)
 7e3:	b8 09 00 00 00       	mov    $0x9,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <dup>:
SYSCALL(dup)
 7eb:	b8 0a 00 00 00       	mov    $0xa,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <getpid>:
SYSCALL(getpid)
 7f3:	b8 0b 00 00 00       	mov    $0xb,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <sbrk>:
SYSCALL(sbrk)
 7fb:	b8 0c 00 00 00       	mov    $0xc,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <sleep>:
SYSCALL(sleep)
 803:	b8 0d 00 00 00       	mov    $0xd,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <uptime>:
SYSCALL(uptime)
 80b:	b8 0e 00 00 00       	mov    $0xe,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <uniq>:
SYSCALL(uniq)
 813:	b8 16 00 00 00       	mov    $0x16,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <head>:
SYSCALL(head)
 81b:	b8 17 00 00 00       	mov    $0x17,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <waitx>:
SYSCALL(waitx)
 823:	b8 18 00 00 00       	mov    $0x18,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <getticks>:
SYSCALL(getticks)
 82b:	b8 19 00 00 00       	mov    $0x19,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    

00000833 <ps>:
SYSCALL(ps)
 833:	b8 1a 00 00 00       	mov    $0x1a,%eax
 838:	cd 40                	int    $0x40
 83a:	c3                   	ret    

0000083b <cps>:
SYSCALL(cps)
 83b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 840:	cd 40                	int    $0x40
 842:	c3                   	ret    

00000843 <chpr>:
SYSCALL(chpr)
 843:	b8 1c 00 00 00       	mov    $0x1c,%eax
 848:	cd 40                	int    $0x40
 84a:	c3                   	ret    
 84b:	66 90                	xchg   %ax,%ax
 84d:	66 90                	xchg   %ax,%ax
 84f:	90                   	nop

00000850 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 850:	55                   	push   %ebp
 851:	89 e5                	mov    %esp,%ebp
 853:	57                   	push   %edi
 854:	56                   	push   %esi
 855:	53                   	push   %ebx
 856:	83 ec 3c             	sub    $0x3c,%esp
 859:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 85c:	89 d1                	mov    %edx,%ecx
{
 85e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 861:	85 d2                	test   %edx,%edx
 863:	0f 89 7f 00 00 00    	jns    8e8 <printint+0x98>
 869:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 86d:	74 79                	je     8e8 <printint+0x98>
    neg = 1;
 86f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 876:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 878:	31 db                	xor    %ebx,%ebx
 87a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 87d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 880:	89 c8                	mov    %ecx,%eax
 882:	31 d2                	xor    %edx,%edx
 884:	89 cf                	mov    %ecx,%edi
 886:	f7 75 c4             	divl   -0x3c(%ebp)
 889:	0f b6 92 fc 0c 00 00 	movzbl 0xcfc(%edx),%edx
 890:	89 45 c0             	mov    %eax,-0x40(%ebp)
 893:	89 d8                	mov    %ebx,%eax
 895:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 898:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 89b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 89e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 8a1:	76 dd                	jbe    880 <printint+0x30>
  if(neg)
 8a3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 8a6:	85 c9                	test   %ecx,%ecx
 8a8:	74 0c                	je     8b6 <printint+0x66>
    buf[i++] = '-';
 8aa:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 8af:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 8b1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 8b6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 8b9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 8bd:	eb 07                	jmp    8c6 <printint+0x76>
 8bf:	90                   	nop
 8c0:	0f b6 13             	movzbl (%ebx),%edx
 8c3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 8c6:	83 ec 04             	sub    $0x4,%esp
 8c9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 8cc:	6a 01                	push   $0x1
 8ce:	56                   	push   %esi
 8cf:	57                   	push   %edi
 8d0:	e8 be fe ff ff       	call   793 <write>
  while(--i >= 0)
 8d5:	83 c4 10             	add    $0x10,%esp
 8d8:	39 de                	cmp    %ebx,%esi
 8da:	75 e4                	jne    8c0 <printint+0x70>
    putc(fd, buf[i]);
}
 8dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8df:	5b                   	pop    %ebx
 8e0:	5e                   	pop    %esi
 8e1:	5f                   	pop    %edi
 8e2:	5d                   	pop    %ebp
 8e3:	c3                   	ret    
 8e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8e8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 8ef:	eb 87                	jmp    878 <printint+0x28>
 8f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ff:	90                   	nop

00000900 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 900:	f3 0f 1e fb          	endbr32 
 904:	55                   	push   %ebp
 905:	89 e5                	mov    %esp,%ebp
 907:	57                   	push   %edi
 908:	56                   	push   %esi
 909:	53                   	push   %ebx
 90a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 90d:	8b 75 0c             	mov    0xc(%ebp),%esi
 910:	0f b6 1e             	movzbl (%esi),%ebx
 913:	84 db                	test   %bl,%bl
 915:	0f 84 b4 00 00 00    	je     9cf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 91b:	8d 45 10             	lea    0x10(%ebp),%eax
 91e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 921:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 924:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 926:	89 45 d0             	mov    %eax,-0x30(%ebp)
 929:	eb 33                	jmp    95e <printf+0x5e>
 92b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 92f:	90                   	nop
 930:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 933:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 938:	83 f8 25             	cmp    $0x25,%eax
 93b:	74 17                	je     954 <printf+0x54>
  write(fd, &c, 1);
 93d:	83 ec 04             	sub    $0x4,%esp
 940:	88 5d e7             	mov    %bl,-0x19(%ebp)
 943:	6a 01                	push   $0x1
 945:	57                   	push   %edi
 946:	ff 75 08             	pushl  0x8(%ebp)
 949:	e8 45 fe ff ff       	call   793 <write>
 94e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 951:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 954:	0f b6 1e             	movzbl (%esi),%ebx
 957:	83 c6 01             	add    $0x1,%esi
 95a:	84 db                	test   %bl,%bl
 95c:	74 71                	je     9cf <printf+0xcf>
    c = fmt[i] & 0xff;
 95e:	0f be cb             	movsbl %bl,%ecx
 961:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 964:	85 d2                	test   %edx,%edx
 966:	74 c8                	je     930 <printf+0x30>
      }
    } else if(state == '%'){
 968:	83 fa 25             	cmp    $0x25,%edx
 96b:	75 e7                	jne    954 <printf+0x54>
      if(c == 'd'){
 96d:	83 f8 64             	cmp    $0x64,%eax
 970:	0f 84 9a 00 00 00    	je     a10 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 976:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 97c:	83 f9 70             	cmp    $0x70,%ecx
 97f:	74 5f                	je     9e0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 981:	83 f8 73             	cmp    $0x73,%eax
 984:	0f 84 d6 00 00 00    	je     a60 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 98a:	83 f8 63             	cmp    $0x63,%eax
 98d:	0f 84 8d 00 00 00    	je     a20 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 993:	83 f8 25             	cmp    $0x25,%eax
 996:	0f 84 b4 00 00 00    	je     a50 <printf+0x150>
  write(fd, &c, 1);
 99c:	83 ec 04             	sub    $0x4,%esp
 99f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 9a3:	6a 01                	push   $0x1
 9a5:	57                   	push   %edi
 9a6:	ff 75 08             	pushl  0x8(%ebp)
 9a9:	e8 e5 fd ff ff       	call   793 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 9ae:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 9b1:	83 c4 0c             	add    $0xc,%esp
 9b4:	6a 01                	push   $0x1
 9b6:	83 c6 01             	add    $0x1,%esi
 9b9:	57                   	push   %edi
 9ba:	ff 75 08             	pushl  0x8(%ebp)
 9bd:	e8 d1 fd ff ff       	call   793 <write>
  for(i = 0; fmt[i]; i++){
 9c2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 9c6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9c9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 9cb:	84 db                	test   %bl,%bl
 9cd:	75 8f                	jne    95e <printf+0x5e>
    }
  }
}
 9cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9d2:	5b                   	pop    %ebx
 9d3:	5e                   	pop    %esi
 9d4:	5f                   	pop    %edi
 9d5:	5d                   	pop    %ebp
 9d6:	c3                   	ret    
 9d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9de:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 9e0:	83 ec 0c             	sub    $0xc,%esp
 9e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 9e8:	6a 00                	push   $0x0
 9ea:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9ed:	8b 45 08             	mov    0x8(%ebp),%eax
 9f0:	8b 13                	mov    (%ebx),%edx
 9f2:	e8 59 fe ff ff       	call   850 <printint>
        ap++;
 9f7:	89 d8                	mov    %ebx,%eax
 9f9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9fc:	31 d2                	xor    %edx,%edx
        ap++;
 9fe:	83 c0 04             	add    $0x4,%eax
 a01:	89 45 d0             	mov    %eax,-0x30(%ebp)
 a04:	e9 4b ff ff ff       	jmp    954 <printf+0x54>
 a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 a10:	83 ec 0c             	sub    $0xc,%esp
 a13:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a18:	6a 01                	push   $0x1
 a1a:	eb ce                	jmp    9ea <printf+0xea>
 a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 a20:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a23:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a26:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 a28:	6a 01                	push   $0x1
        ap++;
 a2a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 a2d:	57                   	push   %edi
 a2e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 a31:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a34:	e8 5a fd ff ff       	call   793 <write>
        ap++;
 a39:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a3c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a3f:	31 d2                	xor    %edx,%edx
 a41:	e9 0e ff ff ff       	jmp    954 <printf+0x54>
 a46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a4d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 a50:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a53:	83 ec 04             	sub    $0x4,%esp
 a56:	e9 59 ff ff ff       	jmp    9b4 <printf+0xb4>
 a5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a5f:	90                   	nop
        s = (char*)*ap;
 a60:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a63:	8b 18                	mov    (%eax),%ebx
        ap++;
 a65:	83 c0 04             	add    $0x4,%eax
 a68:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a6b:	85 db                	test   %ebx,%ebx
 a6d:	74 17                	je     a86 <printf+0x186>
        while(*s != 0){
 a6f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 a72:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 a74:	84 c0                	test   %al,%al
 a76:	0f 84 d8 fe ff ff    	je     954 <printf+0x54>
 a7c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a7f:	89 de                	mov    %ebx,%esi
 a81:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a84:	eb 1a                	jmp    aa0 <printf+0x1a0>
          s = "(null)";
 a86:	bb f4 0c 00 00       	mov    $0xcf4,%ebx
        while(*s != 0){
 a8b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a8e:	b8 28 00 00 00       	mov    $0x28,%eax
 a93:	89 de                	mov    %ebx,%esi
 a95:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a9f:	90                   	nop
  write(fd, &c, 1);
 aa0:	83 ec 04             	sub    $0x4,%esp
          s++;
 aa3:	83 c6 01             	add    $0x1,%esi
 aa6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 aa9:	6a 01                	push   $0x1
 aab:	57                   	push   %edi
 aac:	53                   	push   %ebx
 aad:	e8 e1 fc ff ff       	call   793 <write>
        while(*s != 0){
 ab2:	0f b6 06             	movzbl (%esi),%eax
 ab5:	83 c4 10             	add    $0x10,%esp
 ab8:	84 c0                	test   %al,%al
 aba:	75 e4                	jne    aa0 <printf+0x1a0>
 abc:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 abf:	31 d2                	xor    %edx,%edx
 ac1:	e9 8e fe ff ff       	jmp    954 <printf+0x54>
 ac6:	66 90                	xchg   %ax,%ax
 ac8:	66 90                	xchg   %ax,%ax
 aca:	66 90                	xchg   %ax,%ax
 acc:	66 90                	xchg   %ax,%ax
 ace:	66 90                	xchg   %ax,%ax

00000ad0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad0:	f3 0f 1e fb          	endbr32 
 ad4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad5:	a1 c4 10 00 00       	mov    0x10c4,%eax
{
 ada:	89 e5                	mov    %esp,%ebp
 adc:	57                   	push   %edi
 add:	56                   	push   %esi
 ade:	53                   	push   %ebx
 adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ae2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 ae4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae7:	39 c8                	cmp    %ecx,%eax
 ae9:	73 15                	jae    b00 <free+0x30>
 aeb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 aef:	90                   	nop
 af0:	39 d1                	cmp    %edx,%ecx
 af2:	72 14                	jb     b08 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af4:	39 d0                	cmp    %edx,%eax
 af6:	73 10                	jae    b08 <free+0x38>
{
 af8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afa:	8b 10                	mov    (%eax),%edx
 afc:	39 c8                	cmp    %ecx,%eax
 afe:	72 f0                	jb     af0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b00:	39 d0                	cmp    %edx,%eax
 b02:	72 f4                	jb     af8 <free+0x28>
 b04:	39 d1                	cmp    %edx,%ecx
 b06:	73 f0                	jae    af8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 b08:	8b 73 fc             	mov    -0x4(%ebx),%esi
 b0b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 b0e:	39 fa                	cmp    %edi,%edx
 b10:	74 1e                	je     b30 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b12:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b15:	8b 50 04             	mov    0x4(%eax),%edx
 b18:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b1b:	39 f1                	cmp    %esi,%ecx
 b1d:	74 28                	je     b47 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b1f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 b21:	5b                   	pop    %ebx
  freep = p;
 b22:	a3 c4 10 00 00       	mov    %eax,0x10c4
}
 b27:	5e                   	pop    %esi
 b28:	5f                   	pop    %edi
 b29:	5d                   	pop    %ebp
 b2a:	c3                   	ret    
 b2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b2f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 b30:	03 72 04             	add    0x4(%edx),%esi
 b33:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b36:	8b 10                	mov    (%eax),%edx
 b38:	8b 12                	mov    (%edx),%edx
 b3a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b3d:	8b 50 04             	mov    0x4(%eax),%edx
 b40:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b43:	39 f1                	cmp    %esi,%ecx
 b45:	75 d8                	jne    b1f <free+0x4f>
    p->s.size += bp->s.size;
 b47:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b4a:	a3 c4 10 00 00       	mov    %eax,0x10c4
    p->s.size += bp->s.size;
 b4f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b52:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b55:	89 10                	mov    %edx,(%eax)
}
 b57:	5b                   	pop    %ebx
 b58:	5e                   	pop    %esi
 b59:	5f                   	pop    %edi
 b5a:	5d                   	pop    %ebp
 b5b:	c3                   	ret    
 b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b60 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b60:	f3 0f 1e fb          	endbr32 
 b64:	55                   	push   %ebp
 b65:	89 e5                	mov    %esp,%ebp
 b67:	57                   	push   %edi
 b68:	56                   	push   %esi
 b69:	53                   	push   %ebx
 b6a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b70:	8b 3d c4 10 00 00    	mov    0x10c4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b76:	8d 70 07             	lea    0x7(%eax),%esi
 b79:	c1 ee 03             	shr    $0x3,%esi
 b7c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 b7f:	85 ff                	test   %edi,%edi
 b81:	0f 84 a9 00 00 00    	je     c30 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b87:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 b89:	8b 48 04             	mov    0x4(%eax),%ecx
 b8c:	39 f1                	cmp    %esi,%ecx
 b8e:	73 6d                	jae    bfd <malloc+0x9d>
 b90:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 b96:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b9b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 b9e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 ba5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 ba8:	eb 17                	jmp    bc1 <malloc+0x61>
 baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 bb2:	8b 4a 04             	mov    0x4(%edx),%ecx
 bb5:	39 f1                	cmp    %esi,%ecx
 bb7:	73 4f                	jae    c08 <malloc+0xa8>
 bb9:	8b 3d c4 10 00 00    	mov    0x10c4,%edi
 bbf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bc1:	39 c7                	cmp    %eax,%edi
 bc3:	75 eb                	jne    bb0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 bc5:	83 ec 0c             	sub    $0xc,%esp
 bc8:	ff 75 e4             	pushl  -0x1c(%ebp)
 bcb:	e8 2b fc ff ff       	call   7fb <sbrk>
  if(p == (char*)-1)
 bd0:	83 c4 10             	add    $0x10,%esp
 bd3:	83 f8 ff             	cmp    $0xffffffff,%eax
 bd6:	74 1b                	je     bf3 <malloc+0x93>
  hp->s.size = nu;
 bd8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 bdb:	83 ec 0c             	sub    $0xc,%esp
 bde:	83 c0 08             	add    $0x8,%eax
 be1:	50                   	push   %eax
 be2:	e8 e9 fe ff ff       	call   ad0 <free>
  return freep;
 be7:	a1 c4 10 00 00       	mov    0x10c4,%eax
      if((p = morecore(nunits)) == 0)
 bec:	83 c4 10             	add    $0x10,%esp
 bef:	85 c0                	test   %eax,%eax
 bf1:	75 bd                	jne    bb0 <malloc+0x50>
        return 0;
  }
}
 bf3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 bf6:	31 c0                	xor    %eax,%eax
}
 bf8:	5b                   	pop    %ebx
 bf9:	5e                   	pop    %esi
 bfa:	5f                   	pop    %edi
 bfb:	5d                   	pop    %ebp
 bfc:	c3                   	ret    
    if(p->s.size >= nunits){
 bfd:	89 c2                	mov    %eax,%edx
 bff:	89 f8                	mov    %edi,%eax
 c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 c08:	39 ce                	cmp    %ecx,%esi
 c0a:	74 54                	je     c60 <malloc+0x100>
        p->s.size -= nunits;
 c0c:	29 f1                	sub    %esi,%ecx
 c0e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 c11:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 c14:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 c17:	a3 c4 10 00 00       	mov    %eax,0x10c4
}
 c1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c1f:	8d 42 08             	lea    0x8(%edx),%eax
}
 c22:	5b                   	pop    %ebx
 c23:	5e                   	pop    %esi
 c24:	5f                   	pop    %edi
 c25:	5d                   	pop    %ebp
 c26:	c3                   	ret    
 c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c2e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 c30:	c7 05 c4 10 00 00 c8 	movl   $0x10c8,0x10c4
 c37:	10 00 00 
    base.s.size = 0;
 c3a:	bf c8 10 00 00       	mov    $0x10c8,%edi
    base.s.ptr = freep = prevp = &base;
 c3f:	c7 05 c8 10 00 00 c8 	movl   $0x10c8,0x10c8
 c46:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c49:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 c4b:	c7 05 cc 10 00 00 00 	movl   $0x0,0x10cc
 c52:	00 00 00 
    if(p->s.size >= nunits){
 c55:	e9 36 ff ff ff       	jmp    b90 <malloc+0x30>
 c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 c60:	8b 0a                	mov    (%edx),%ecx
 c62:	89 08                	mov    %ecx,(%eax)
 c64:	eb b1                	jmp    c17 <malloc+0xb7>
