#include<stdio.h>
#include<sys/stat.h>
#include<sys/types.h>
#include<stdlib.h>
#include<dirent.h>
#include<unistd.h> 
#include<fcntl.h>
#include<string.h>

int main(){
    
    //created d1
    mkdir("d1", 0777);
    chdir("d1");
    mkdir("d2", 0777);    
    mkdir("d3", 0777);
    mkdir("d4", 0777);


    char data[] = "ye hai sample data\n";
    char data2[] = "ye hai second sample data\n";

    int filedescriptor;
    int filedescriptor2;

    filedescriptor = open("f1.txt", O_WRONLY|O_CREAT|O_APPEND,0777);
    write(filedescriptor, data, strlen(data));
    close(filedescriptor);

    filedescriptor2 = open("f2.txt", O_WRONLY|O_CREAT|O_APPEND,0777);
    write(filedescriptor2, data, strlen(data2));
    close(filedescriptor2);
}   