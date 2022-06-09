#include <stdio.h>
#include <unistd.h> /* chamadas ao sistema: defs e decls essenciais */
#include <sys/wait.h>

/*
Implemente um programa que simule o comando ls -l | wc -l no terminal atraves de pipes
*/
void my_pipe(){
    int pd[2]; // pipe
    int status[2];

    pipe(pd); // operação pipe

    switch (fork())
    {
    case -1:
        perror("Erro\n");
        break;
    
    case 0:
        close(pd[0]);

        dup2(pd[1],1);
        close(pd[1]);

        execlp("ls", "ls", "-l", NULL);
        _exit(0);
        break;

    default:
        close(pd[1]);
        wait(&status[0]);

        if(fork() == 0){
            close(pd[1]);

            dup2(pd[0],0);
            close(pd[0]);

            execlp("wc", "wc", "-l", NULL);
            _exit(0);
        }

        else{
            close(pd[0]);
            pid_t terminated_pid = wait(&status[1]);
        }
        break;
    }
}