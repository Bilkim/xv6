#include "types.h"
#include "user.h"
#include "fcntl.h"

#define BUFSIZE 512

int ignore_case = 0, show_count = 0, show_only_duplicated = 0;

int tolower(int c) {
    if (c >= 'A' && c <= 'Z') {
        return c + 'a' - 'A';
    }
    return c;
}

void remove_trailing_newline(char *str) {
    int len = strlen(str);
    while (len > 0 && (str[len - 1] == '\n' || str[len - 1] == '\r')) {
        str[len - 1] = '\0';
        len--;
    }
}

int strcmp_custom(const char *s1, const char *s2) {
    if (ignore_case) {
        while (*s1 && *s2) {
            if (tolower(*s1) != tolower(*s2))
                break;
            s1++;
            s2++;
        }
        return tolower(*s1) - tolower(*s2);
    } else {
        while (*s1 != '\0' && *s2 != '\0' && *s1 == *s2) {
            s1++;
            s2++;
        }
        return *s1 - *s2;
    }
}

void strncpy_custom(char *dest, const char *src, int n) {
    int i;
    for (i = 0; i < n && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
}

void process_file(char *filename) {
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
        printf(2, "Error opening %s\n", filename);
        return;
    }

    char buf[BUFSIZE];
    char prev_line[BUFSIZE] = "";
    int count = 0;

    while (1) {
        int n = read(fd, buf, BUFSIZE);
        if (n <= 0) {
            if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
                if (show_count) {
                    printf(1, "%d %s\n", count, prev_line);
                } else {
                    printf(1, "%s\n", prev_line);
                }
            }
            break;
        }

        int line_start = 0;
        for (int i = 0; i < n; i++) {
            if (buf[i] == '\n') {
                buf[i] = '\0';
                if (strcmp_custom(buf + line_start, prev_line) == 0) {
                    count++;
                } else {
                    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
                        if (show_count) {
                            printf(1, "%d %s\n", count, prev_line);
                        } else {
                            printf(1, "%s\n", prev_line);
                        }
                    }
                    remove_trailing_newline(buf + line_start);
                    strncpy_custom(prev_line, buf + line_start, BUFSIZE);
                    count = 1;
                }
                line_start = i + 1;
            }
        }
    }
    close(fd);
}

int main(int argc, char *argv[]) {
    int file_start = 1;  // Default index of the first filename in argv[]

    // Parsing flags
    if (argc > 1 && argv[1][0] == '-') {
        for (int j = 1; argv[1][j]; j++) {
            switch (argv[1][j]) {
                case 'i': ignore_case = 1; break;
                case 'c': show_count = 1; break;
                case 'd': show_only_duplicated = 1; break;
                default:
                    printf(2, "Unknown option: -%c\n", argv[1][j]);
                    exit();
            }
        }
        file_start = 2;  // If flags were passed, first filename will start from index 2 in argv[]
    }

    if (argc < file_start + 1) {
        printf(2, "Usage: %s [-icd] <filename1> [<filename2>]\n", argv[0]);
        exit();
    }

    printf(1, "Uniq command is getting executed in user mode.\n");

    process_file(argv[file_start]);
    if(argc == file_start + 2) {
        process_file(argv[file_start + 1]);
    }


    // Call the sys_uniq system call here
    uniq(ignore_case, show_count, show_only_duplicated, argv[file_start]);
    if(argc == file_start + 2) {
        uniq(ignore_case, show_count, show_only_duplicated, argv[file_start + 1]);
    }

    exit();
}

