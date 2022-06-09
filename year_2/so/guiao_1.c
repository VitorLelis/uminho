#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h> /* chamadas ao sistema: defs e decls essenciais */
#include <fcntl.h> /* O_RDONLY, O_WRONLY, O_CREAT, O_* */

#define SIZE 1024

/*
Implemente em C um programa mycp com funcionalidade similar ao comando cp
*/

void mycp(char* origin, char* destiny){
    int fd_ori = open(origin, O_RDONLY);
    int fd_dest = open (destiny, O_CREAT | O_WRONLY, 0777);

    char* buf[SIZE];

    while(read(fd_ori, buf, SIZE) > 0)
        write(fd_dest, buf, SIZE);
}

/*
Implemente em C um programa mycat com funcionalidade similar ao comando cat, que le do seu
stdin e escreve para o seu stdout
*/

void mycat(){
    char* buffer[SIZE];

    int res = 0;

    while((res = read(0,buffer, SIZE)) != 0){
        write(1,buffer, res);
    }
}