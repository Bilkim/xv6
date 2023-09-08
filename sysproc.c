#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"


#define DEFAULT_LINES 14
#define BUFSIZE 512

int strcmp_kernel(const char *s1, const char *s2) {
    while (*s1 && (*s1 == *s2)) {
        s1++;
        s2++;
    }
    return *(const unsigned char *)s1 - *(const unsigned char *)s2;
}

int atoi(const char *s) {
    int n = 0;
    while ('0' <= *s && *s <= '9') {
        n = n*10 + *s++ - '0';
    }
    return n;
}




int sys_head(void) {
    char *filename1;
    int lines_to_show;
    struct inode *ip;
    char buf[BUFSIZE];
    int offset = 0, n, lines_printed = 0;

    if(argstr(0, &filename1) < 0)
        return -1;

    if(argint(1, &lines_to_show) < 0)
        lines_to_show = 10;  // Default value if no second argument is provided

    // Fetch inode for filename1
    if((ip = namei(filename1)) == 0)
        return -1;

    ilock(ip);

    cprintf("Head command is getting executed in kernel mode\n");

    int line_start = 0;
    while((n = readi(ip, buf, offset, sizeof(buf) - 1)) > 0 && lines_printed < lines_to_show) { // Added condition to stop once we've printed enough lines
        buf[n] = '\0'; // Ensure null termination
        
        for(int i = 0; i < n; i++) {
            if(buf[i] == '\n' || i == n-1) {
                buf[i] = '\0'; // Null-terminate the line
                
                cprintf("%s\n", buf + line_start);
                lines_printed++;

                if (lines_printed >= lines_to_show) {
                    break;  // Exit if we've printed enough lines
                }
                
                line_start = i + 1;  // Mark the start of the next line
            }
        }

        // If buffer doesn't end with a newline, adjust offset
        if (buf[n-1] != '\n') {
            offset -= (n - line_start);
        } else {
            offset += n;
        }
        line_start = 0; // Reset line start for the next buffer read
    }

    iunlockput(ip);

    return 0;
}




int sys_uniq(void) {
    char *filename1;
    struct inode *ip;
    char buf[BUFSIZE];
    char prev_line[BUFSIZE] = {0};
    int offset = 0, n;

    if(argstr(0, &filename1) < 0)
        return -1;

    // Fetch inode for filename1
    if((ip = namei(filename1)) == 0)
        return -1;

    ilock(ip);

    cprintf("Uniq command is getting executed in kernel mode\n");  // Added this line

    while((n = readi(ip, buf, offset, sizeof(buf))) > 0) {
    int line_start = 0;
    for(int i = 0; i < n; i++) {
        if(buf[i] == '\n' || i == n-1) {
            buf[i] = '\0'; // Null-terminate the line

            if(strcmp_kernel(buf + line_start, prev_line) != 0) {
                cprintf("%s\n", buf + line_start);
                safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
            }
            line_start = i + 1;  // mark the start of the next line
        }
     }
    offset += n;
   }


    iunlockput(ip);


    return 0;
}


int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
