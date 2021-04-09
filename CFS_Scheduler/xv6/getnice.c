#include "types.h"
#include "user.h"
#include "stat.h"
#include "fcntl.h"

int main(int argc, char* argv[])
{
    if(argc<2) {
        printf(1,"Too few arguments\n");
        exit();
    }
    else if(argc>2) {
        printf(1,"Too many arguments\n");
        exit();
    }
    int pid=atoi(argv[1]);
    int nice=getnice(pid);
    if(nice==-1) printf(1,"Cannot found process which is matched input pid\n");
    else printf(1,"nice = %d\n",nice);
    exit();
}
