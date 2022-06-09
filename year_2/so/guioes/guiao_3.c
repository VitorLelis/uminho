#include <stdio.h>
#include <unistd.h> /* chamadas ao sistema: defs e decls essenciais */
#include <sys/wait.h> /* chamadas wait*() e macros relacionadas */

/*
Implemente um programa que execute o comando ls -l
*/
void my_ls(){
    printf("Imprimindo...\n");

    sleep(1);

    execlp("ls", "ls","-l", NULL);
}

/*
Implemente um programa semelhante ao anterior que execute o mesmo comando 
mas agora no contexto de um processo filho.
*/
void child_ls(){
    int status;
    pid_t pid = fork();

    if (pid == 0){
        printf("Sou o filho\n");
        execlp("ls", "ls","-l", NULL);
        _exit(0);
    }

    else{
        wait(&status);
        printf("Sou o pai\n");
    }
}