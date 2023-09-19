#ifndef PS_STAT_H
#define PS_STAT_H

//Struct definition for process statistics
struct ps_stat {
    int pid;
    char state[16];      // Assuming a string representation of the state, with a reasonable max size.
    int start_time;
    int total_time;
    char name[16];       // Assuming the process name has a maximum size of 15 + null terminator.
};


int psinfo(struct ps_stat* ps);

// Static inline function to convert state to a string representation
static inline char* state_string(int state) {
    switch(state) {
        case UNUSED:    return "UNUSED";
        case EMBRYO:    return "EMBRYO";
        case SLEEPING:  return "SLEEP";
        case RUNNABLE:  return "RUNNABLE";
        case RUNNING:   return "RUNNING";
        case ZOMBIE:    return "ZOMBIE";
        default:        return "???";
    }
}

#endif // PS_STAT_H

