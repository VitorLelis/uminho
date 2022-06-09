#include <stdio.h>
#include <unistd.h> /* chamadas ao sistema: defs e decls essenciais */
#include <sys/wait.h> /* chamadas wait*() e macros relacionadas */

/*
Implemente um programa que crie um processo filho. 
Pai e filho devem imprimir o seu identificador de
processo e o do seu pai. O pai deve ainda imprimir o PID do seu filho.
*/
void filho_unico(){
    pid_t pid = fork();
    int status;

    if (pid == 0){
        printf("Sou o processo: %d\n", getpid());
        printf("Meu pai: %d\n", getppid());
    }

    else{
        sleep(1);
        printf("Sou o processo: %d\n", getpid());
        printf("Meu pai: %d\n", getppid());
        printf("Meu filho: %d\n", pid);
    }
}

/*
Implemente um programa que crie dez processos filhos que deverao executar sequencialmente. 
Para este efeito, os filhos podem imprimir o seu PID e o do seu pai, e finalmente, 
terminarem a sua execucao com um valor de saida igual ao seu numero de ordem 
*/
void muitos_filhos(int n){
    int i, status[n];
    pid_t pid, p2;

    for (i = 0; i < n; i++){
        pid = fork();
        if (pid == 0){
            printf("Filho numero %d\n", i);
            printf("Sou o processo: %d\n", getpid());
            printf("Meu pai era o: %d", getppid());
            _exit(i);
        }
        else{
            sleep(1);
            p2 = wait(&status[i]);
            printf("%d já foi\n", p2);
        }
    }
}