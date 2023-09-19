#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
    int start_ticks, end_ticks, runtime, waittime;

    // Get the starting tick count for uniq
    start_ticks = getticks();

    // Execute uniq command
    if (fork() == 0) {
        exec("uniq", argv);
        exit();
    } else {
        waitx(&waittime, &runtime);
    }

    // Get the ending tick count for uniq
    end_ticks = getticks();

    printf(1, "\n");
    printf(1, "Statistics for uniq:\n");
    printf(1, "Start Time: %d\nEnd Time: %d\nTotal Time: %d\n", start_ticks - (runtime + waittime), end_ticks, runtime + waittime);

    // Get the starting tick count for head
    start_ticks = getticks();

    // Execute head command
    if (fork() == 0) {
        exec("head", argv);
        exit();
    } else {
        waitx(&waittime, &runtime);
    }

    // Get the ending tick count for head
    end_ticks = getticks();

    printf(1, "\n");

    printf(1, "Statistics for head:\n");
    printf(1, "Start Time: %d\nEnd Time: %d\nTotal Time: %d\n", start_ticks - (runtime + waittime), end_ticks, runtime + waittime);

    exit();
}
