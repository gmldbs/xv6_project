#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char* argv[])
{
    if(argc<3) {
        printf(1,"Too few arguments\n");
        exit();
    }
    else if(argc>3) {
        printf(1,"Too many arguments\n");
        exit();
    }
    int pid=atoi(argv[1]), priority=atoi(argv[2]);
    if(priority<0||priority>39||argv[2][0]=='-'){
        printf(1,"Wrong input priority\n");
        exit();
    }
        
    int result=setnice(pid,priority);
    if(result==-1) printf(1,"Cannot found process that is matched input pid\n");
    exit();
}
