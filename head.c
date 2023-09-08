#include "types.h"
#include "user.h"
#include "fcntl.h"

#define DEFAULT_LINES 14
#define BUFSIZE 512

void process_input(int fd, int nlines) {
    char buf[BUFSIZE];
    int i, lines = 0;

    while(lines < nlines) {
        int count = read(fd, buf, BUFSIZE);
        if(count <= 0) {
            break;  // End of file or error
        }

        for(i = 0; i < count && lines < nlines; i++) {
            write(1, &buf[i], 1);  // Write the character to stdout
            if(buf[i] == '\n') {
                lines++;
            }
        }
    }
}

int main(int argc, char *argv[]) {
    printf(1, "Head command is getting executed in user mode.\n");

    int nlines = DEFAULT_LINES;
    int arg_start = 1;
    

    if(argc > 1 && argv[1][0] == '-') {
        nlines = atoi(&argv[1][1]);
        arg_start = 2;
    }

    if(arg_start == argc) {
        process_input(0, nlines);  // Read from standard input
    } else {
        for(int i = arg_start; i < argc; i++) {
            if(argc > 2) {
                printf(1, "==> %s <==\n", argv[i]);  // Print filename if more than one file is provided
            }

            int fd = open(argv[i], O_RDONLY);
            if(fd < 0) {
                printf(2, "head: cannot open %s for reading\n", argv[i]);
                continue;
            }
            process_input(fd, nlines);
            close(fd);
        }
    }
     if(argc == 2 && argv[1][0] == '-'){
	printf(1, "==> %s <==\n", argv[2]);
        head(argv[2], nlines);

    } else if (argc > 2 && argv[1][0] == '-' ){
	printf(1, "==> %s <==\n", argv[2]);
        head(argv[2], nlines);
	printf(1, "==> %s <==\n", argv[3]);
	head(argv[3], nlines);

    }

    exit();
}
