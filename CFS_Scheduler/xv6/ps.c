#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char* argv[])
{
    if(argc<2) {
        printf(1,"few arguments\n");
        exit();
    }
    else if(argc>2) {
        printf(1,"many arguments\n");
        exit();
    }
    if(argv[1][0]=='-') {
        printf(1,"wrong input priority\n");
        exit();
    }
    int pid=atoi(argv[1]);
    ps(pid);
    exit();
}
