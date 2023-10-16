#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    int start_ticks, end_ticks, runtime, waittime;
    int total_waittime = 0, total_turnaround = 0;
    int x, z;
    // User Mode
    start_ticks = getticks();
    if (fork() == 0) {
        exec("uniq", argv);
        exit();
    } else {
        waitx(&waittime, &runtime);
    }
    end_ticks = getticks();
    total_waittime += waittime;
    total_turnaround += runtime + waittime;

    printf(1, "\nUser Mode Statistics for uniq:\n");
    printf(1, "Start Time: %d\nEnd Time: %d\n", start_ticks, end_ticks);
    printf(1, "Wait Time: %d\nRun Time: %d\n", waittime, runtime);

    // Kernel Mode
    start_ticks = getticks();
    if (fork() == 0) {
        uniq(0, 0, 0, "example");
        exit();
    } else {
        waitx(&waittime, &runtime);
    }
    end_ticks = getticks();
    total_waittime += waittime;
    total_turnaround += runtime + waittime;

    printf(1, "\nKernel Mode Statistics for uniq:\n");
    printf(1, "Start Time: %d\nEnd Time: %d\n", start_ticks, end_ticks);
    printf(1, "Wait Time: %d\nRun Time: %d\n", waittime, runtime);

    // Averages across both user and kernel modes
    printf(1, "\nAverage Wait Time across both modes: %d\n", total_waittime / 2);
    printf(1, "Average Turnaround Time across both modes: %d\n", total_turnaround / 2);

    // [Additional CPU Load]
    for(z = 0; z < 40000000000; z+=1){
        x = x + 3.14*89.64; //Useless calculation to consume CPU Time
    }
    exit();
}
