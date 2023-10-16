#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "spinlock.h"
#include "ps_stat.h"


#define DEFAULT_LINES 14
#define BUFSIZE 512

extern struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

int
sys_getticks(void)
{
    return ticks; // Return current ticks since boot
}

int
sys_cps(void)
{
  return cps();
}

int
sys_chpr(void)
{
  int pid, pr;
  if(argint(0, &pid) < 0)
    return -1;
  if(argint(1, &pr) < 0)
    return -1;

  return chpr(pid, pr);
}




int sys_ps(void) {
    struct proc *p;
    cprintf("Name\tpid\tstatus\tStart time\tend time\ttotal time\tpriority\n");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
	cprintf("%s\t", p->name);
        cprintf("%d\t", p->pid);
        switch(p->state) {
            case UNUSED: cprintf("UNUSED"); break;
	    case EMBRYO: cprintf("EMBRYO"); break;
            case RUNNING: cprintf("RUNNING"); break;
            case SLEEPING: cprintf("SLEEPING"); break;
            case RUNNABLE: cprintf("RUNNABLE"); break;
            case ZOMBIE: cprintf("ZOMBIE"); break;
        }
        cprintf("\t%d\t%d\t%d\t%d\n", p->start_time,p->end_time,p->total_time,p->priority);
    }

    return 0;
}


int sys_waitx(int* waittime, int* runtime)
{
    struct proc *p;
    int havekids, pid;

    // Use argptr to safely get arguments from user space
    if(argptr(0, (void*)&waittime, sizeof(waittime)) < 0)
        return -1;

    if(argptr(1, (void*)&runtime, sizeof(runtime)) < 0)
        return -1;

    acquire(&ptable.lock);
    for(;;) {
        havekids = 0;
        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
            if(p->parent != myproc())
                continue;
            havekids = 1;
            if(p->state == ZOMBIE) {
                pid = p->pid;

                // Calculate wait time and runtime
                *waittime = p->end_time - p->creation_time - p->total_time;
                *runtime = p->total_time;

                // Update the history of unused processes before releasing
                p->last_3_unused[p->last_index].pid = p->pid;
                strncpy(p->last_3_unused[p->last_index].name, p->name, sizeof(p->name));
                p->last_3_unused[p->last_index].start_time = p->start_time;
                p->last_3_unused[p->last_index].total_time = p->total_time;

                p->last_index = (p->last_index + 1) % 3;  // Ensure it cycles between 0-2

                // Release process resources
                kfree(p->kstack);
                p->state = UNUSED;
                p->parent = 0;
                p->killed = 0;
                release(&ptable.lock);
                return pid;
            }
        }

        if(!havekids || myproc()->killed) {
            release(&ptable.lock);
            return -1;
        }

        // Keep waiting
        sleep(myproc(), &ptable.lock);
    }
}



int tolower_kernel(int c) {
    if (c >= 'A' && c <= 'Z') {
        return c + 'a' - 'A';
    }
    return c;
}

int strcmp_kernel(const char *s1, const char *s2, int ignore_case) {
    if (ignore_case) {
        while (*s1 && tolower_kernel(*s1) == tolower_kernel(*s2)) {
            s1++;
            s2++;
        }
        return tolower_kernel(*(const unsigned char *)s1) - tolower_kernel(*(const unsigned char *)s2);
    } else {
        while (*s1 && (*s1 == *s2)) {
            s1++;
            s2++;
        }
        return *(const unsigned char *)s1 - *(const unsigned char *)s2;
    }
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
    int ignore_case = 0, show_count = 0, show_only_duplicated = 0;
    int count = 0;

    // Fetching the flags first (assuming flags are passed as additional arguments to sys_uniq)
    if (argint(0, &ignore_case) < 0 || argint(1, &show_count) < 0 || argint(2, &show_only_duplicated) < 0)
        return -1;

    // Fetch filename after flags
    if(argstr(3, &filename1) < 0)
        return -1;

    // Fetch inode for filename1
    if((ip = namei(filename1)) == 0)
        return -1;

    ilock(ip);

    cprintf("Uniq command is getting executed in kernel mode\n");

    while((n = readi(ip, buf, offset, sizeof(buf))) > 0) {
        int line_start = 0;
        for(int i = 0; i < n; i++) {
            if(buf[i] == '\n' || i == n-1) {
                buf[i] = '\0';

                if(strcmp_kernel(buf + line_start, prev_line, ignore_case) == 0) {
                    count++;
                } else {
                    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
                        if (show_count) {
                            cprintf("%d %s\n", count, prev_line);
                        } else {
                            cprintf("%s\n", prev_line);
                        }
                    }
                    safestrcpy(prev_line, buf + line_start, sizeof(prev_line));
                    count = 1;
                }
                line_start = i + 1;  // mark the start of the next line
            }
        }
        offset += n;
    }

    if (count > 0 && (!show_only_duplicated || (show_only_duplicated && count > 1))) {
        if (show_count) {
            cprintf("%d %s\n", count, prev_line);
        } else {
            cprintf("%s\n", prev_line);
        }
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
