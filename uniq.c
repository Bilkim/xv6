#include "types.h"
#include "user.h"
#include "fcntl.h"

#define BUFSIZE 512

void remove_trailing_newline(char *str) {
    int len = strlen(str);
    while (len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r')) {
        str[len - 1] = '\0';
        len--;
    }
}

int strcmp_custom(const char *s1, const char *s2) {
    while (*s1 != '\0' && *s2 != '\0' && *s1 == *s2) {
        s1++;
        s2++;
    }
    return *s1 - *s2;
}

void strncpy_custom(char *dest, const char *src, int n) {
    int i;
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
}

void process_file(char *filename) {
    int fd = open(filename, O_RDONLY); // Open the file for reading
    if (fd < 0) {
        printf(2, "Error opening %s\n", filename);
        return;
    }

    char buf[BUFSIZE];
    char prev_line[BUFSIZE] = ""; // Initialize with an empty string

    while (1) {
        int n = read(fd, buf, BUFSIZE);
        if (n <= 0) {
            break;
        }

        int line_start = 0;
        for (int i = 0; i < n; i++) {
            if (buf[i] == '\n') {
                buf[i] = '\0'; // Null-terminate the line
                if (strcmp_custom(buf + line_start, prev_line) != 0) {
                    printf(1, "%s\n", buf + line_start);
                    remove_trailing_newline(buf + line_start);
                    strncpy_custom(prev_line, buf + line_start, BUFSIZE);
                }
                line_start = i + 1;
            }
        }
    }

    close(fd);
}

int main(int argc, char *argv[]) {
    if (argc < 2 || argc > 3) {
        printf(2, "Usage: %s <filename1> [<filename2>]\n", argv[0]);
        exit();
    }

    printf(1, "Uniq command is getting executed in user mode.\n");

    process_file(argv[1]);
    if(argc == 3) {
        process_file(argv[2]);
    }
     
    if(argc == 2) {
        uniq(argv[1]);
    } else if(argc == 3) {
        uniq(argv[1]);
        uniq(argv[2]);
    }
    exit();
}
