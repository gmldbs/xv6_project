#include "types.h"
#include "user.h"
#include "param.h"
#include "fcntl.h"

int main(int argc, char** argv) {
	printf(1, "mmap test \n");
	int i;
	int size = 8192;
	int fd = open("README", O_RDWR);
	char* text = (char*)mmap(0, size, PROT_READ, MAP_PRIVATE, fd, 0);							  //File example
	char* text2 = (char*)mmap(0, size, PROT_WRITE|PROT_READ, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);  //ANONYMOUS example
	char* text3 = (char*)mmap(4096, size, PROT_WRITE|PROT_READ, MAP_PRIVATE|MAP_POPULATE|MAP_FIXED, fd, 0); // FIXED example
	for (i = 0; i < size; i++) 
		printf(1, "%c", text[i]);
	printf(1,"\n============file mmap end==========\n\n\n\n");
    munmap((uint)text2);
    if((uint)text2==0) printf(1,"mmap fault\n");
    else
    {text2[0] = 's';
	text2[4096] = 'Y';
	for (i = 0; i < size; i++) 
		printf(1, "%c", text2[i]);
    }
	printf(1,"\n============anonymous mmap end==========\n");
    if((uint)text3==0) printf(1,"fixed mmap fault\n");
    else{
        for(int i=0;i<size;i++)
        {
            printf(1,"%c",text3[i]);
        }
    }
    printf(1,"\n============Fixed mmap end==============\n");
	munmap((uint)text);
	//munmap((uint)text2);
    munmap((uint)text3);

	exit();
}
