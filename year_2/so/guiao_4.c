#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/wait.h> /* chamadas wait*() e macros relacionadas */

/*
Implemente um programa que redireciona o output do comando ls 
em um ficheiro e no final imprima "Terminei"
*/
void ls_save(char* file_path){
    int fd, status;
    pid_t pid;

    fd = open(file_path, O_WRONLY | O_CREAT, 0777);

    dup2(fd, 1);

    pid = fork();

    if (pid == 0){
        execlp("ls", "ls","-l", NULL);
        _exit(0);
    }

    else{
        wait(&status);
        printf("Terminei\n");
    }
}