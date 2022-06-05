#include <stdio.h>

typedef struct lligada {
int valor;
struct lligada *prox;
} *LInt;

typedef struct nodo {
int valor;
struct nodo *esq, *dir;
} *ABin;

/*1. Apresente uma definição não recursiva da função int length (LInt) que calcula o compri-
mento de uma lista ligada. (https://codeboard.io/projects/16161)*/

int length (LInt l){
    int c = 0;
    
    while (l != NULL)
    {
        c++;
        l = l->prox;
    }
    return c;
}

/*2. Apresente uma definição não recursiva da função void freeL (LInt) que liberta o espaço
ocupado por uma lista.*/

void freeL (LInt l){
	LInt ant;
	while(l!=NULL){
		ant = l;
		l=l->prox;
		free(ant);
	}
}

/*3. Apresente uma definição não recursiva da função void imprimeL (LInt) que imprime no
ecran os elementos de uma lista (um por linha).*/

void imprimeL (LInt l){
	while(l!=NULL){
		printf("%d\n",l->valor);
		l=l->prox;
	}
}

/*4. Apresente uma definição não recursiva da função LInt reverseL (LInt) que inverte uma
lista (sem criar uma nova lista). (https://codeboard.io/projects/16243)*/

LInt reverseL (LInt l){
	LInt ant=NULL,aux=NULL;
	while(l!=NULL){
		aux = l;
		l=l->prox;
		aux->prox=ant;
		ant=aux;
	}
	return aux;
}

/*5. Apresente uma definição não recursiva da função void insertOrd (LInt *, int) que in-
sere ordenadamente um elemento numa lista ordenada. (https://codeboard.io/projects/
16244)*/

void insertOrd (LInt *l,int x){
	LInt new;
	while((*l)!=NULL && (*l)->valor<x)
		l=&((*l)->prox);
		new = (LInt) malloc(sizeof(struct lligada));
		new->valor=x;
		new->prox = *l;
	*l=new;
}

/*6. Apresente uma definição não recursiva da função int removeOneOrd (LInt *, int) que
remove um elemento de uma lista ordenada. Retorna 1 caso o elemento a remover não exista,
0 no outro caso. (https://codeboard.io/projects/16245)*/

int removeOneOrd (LInt *l, int x){
int i = 1;
LInt p;

    while((*l) != NULL)
    {
        if ((*l)->valor == x)
        {
            p = (*l)->prox;
            i = 0;
            (*l) = p;
        }
        else l = &((*l)->prox);
    }
    
    return i;
}

/*7. Defina uma função merge (LInt *r, LInt a, LInt b) que junta duas listas ordenadas (a
e b) numa única lista ordenada (r). (https://codeboard.io/projects/16246)*/

void merge (LInt *r, LInt l1, LInt l2){
	while(l1 || l2){
		if((!l1) || l2 && l1->valor > l2->valor){
			*r=l2;
			r=&(l2->prox);
			l2=l2->prox;
		}
		else{
		    *r=l1;
			r=&(l1->prox);
			l1=l1->prox;
			
		}
	}
}

/*8. Defina uma função void splitQS (LInt l, int x, LInt *mx, LInt *Mx) que, dada uma
lista ligada l e um inteiro x, parte a lista em duas (retornando os endereços dos primeiros
elementos da lista em *mx e *Mx): uma com os elementos de l menores do que x e a outra com
os restantes. Note que esta função não deverá criar cópias dos elementos da lista. (https:
//codeboard.io/projects/16247)*/

void splitQS (LInt l, int x, LInt *mx, LInt *Mx){
    
    while(l)
    {
        if (l->valor < x)
        {
            (*mx) = l;
            mx = &((*mx)->prox);
        }
        else
        {
            (*Mx) = l;
            Mx = &((*Mx)->prox);
        }
        l = l->prox;
    }
    *mx = 0;
    *Mx = 0;
}

/*10. Apresente uma definição não recursiva da função int removeAll (LInt *, int) que remove
todas as ocorrências de um dado inteiro de uma lista, retornando o número de células removi-
das. (https://codeboard.io/projects/16249)*/

int removeAll (LInt *l, int x){
    LInt lis;
    int r = 0;
    
    while(*l)
    {
        if ((*l)->valor == x)
        {
            lis = (*l)->prox;
            free(*l);
            (*l) = lis;
            r++;
        }
        else l = &((*l)->prox);
    }
    
    return r;
}

/*11. Apresente uma definição da função int removeDups (LInt *) que remove os valores repeti-
dos de uma lista (deixando apenas a primeira ocorrência). (https://codeboard.io/projects/
16250)*/

int removeAll (LInt *l, int x){
    LInt lis;
    int r = 0;
    
    while(*l)
    {
        if ((*l)->valor == x)
        {
            lis = (*l)->prox;
            free(*l);
            (*l) = lis;
            r++;
        }
        else l = &((*l)->prox);
    }
    
    return r;
}

int removeDups (LInt *l){
    int i = 0;
    
    while(*l)
    {
        i += removeAll(&((*l)->prox),(*l)->valor);
        l = &((*l)->prox);
    }
    
    return i;
}

/*12. Apresente uma definição da função int removeMaiorL (LInt *) que remove (a primeira
ocorrência) o maior elemento de uma lista não vazia, retornando o valor desse elemento.
(https://codeboard.io/projects/16251)*/

int removeMaiorL (LInt *l){
    int maior;
     LInt *d, p;
     
    for (d = l; *d; d = &((*d)->prox)) 
        if ((*l)->valor < (*d)->valor) l = d;
    
    maior = (*l)->valor;
    p = (*l)->prox;
    free(*l);
    *l = p;
    
    return maior;
}

/*13. Apresente uma definição não recursiva da função void init (LInt *) que remove o último
elemento de uma lista não vazia (libertando o correspondente espaço). (https://codeboard.
io/projects/16252)*/

void init (LInt *l){

    while (*l)
    {
        if (!((*l)->prox))
        {
            free (*l);
            (*l)=NULL;
        }
        else l = &((*l)->prox);
    }
}

/*14. Apresente uma definição não recursiva da função void appendL (LInt *, int) que acres-
centa um elemento no fim da lista. (https://codeboard.io/projects/16253)*/

void appendL (LInt *l, int x){
    LInt n, *i;
    
    n = malloc (sizeof(struct lligada));
    n->valor = x;
    n->prox = NULL;
    
    if (!(*l)) *l=n;
    
    else
    {
        for (i = l; (*i)->prox; i = &((*i)->prox));
        (*i)->prox = n;
    }
}

/*15. Apresente uma definição da função void concatL (LInt *a, LInt b) que acrescenta a lista
b à lista *a. (https://codeboard.io/projects/16254)*/

void concatL (LInt *a, LInt b){
    
    while (*a) a = &((*a)->prox);
     *a = b;
}

/*16. Apresente uma definição da função LInt cloneL (LInt) que cria uma nova lista ligada com
os elementos pela ordem em que aparecem na lista argumento.*/

LInt cloneL (LInt l){
	LInt new;
  
	if(l==NULL) new=NULL;
	
  while(l!=NULL)
  {
	  new = malloc(sizeof(struct lligada));
	  new->valor = l->valor;
	  new->prox = cloneL(l->prox);
  }
    return new;
}

/*18. Defina uma função int maximo (LInt l) que calcula qual o maior valor armazenado numa
lista não vazia. (https://codeboard.io/projects/16257)*/

int maximo (LInt l){
    int max;
    
    max = l->valor;
    
    while(l)
    {
        if(l->valor > max) max = l->valor;
        l = l->prox;
    }
    
    return max;
}

/*19. Apresente uma definição iterativa da função int take (int n, LInt *l) que, dado um in-
teiro n e uma lista ligada de inteiros l, apaga de l todos os nodos para além do n-ésimo
(libertando o respectivo espaço). Se a lista tiver n ou menos nodos, a função não altera a
lista.
A função deve retornar o comprimento final da lista. (https://codeboard.io/projects/
16258)*/

int take (int n, LInt *l){
    int i;
    LInt p;
    
    for(i = 0; *l && i < n; i++) l = &((*l)->prox);
    while(*l)
    {
        p = (*l)->prox;
        free(*l);
        *l = p;
    }
    
    return i;
}

/*20. Apresente uma definição iterativa da função int drop (int n, LInt *l) que, dado um in-
teiro n e uma lista ligada de inteiros l, apaga de l os n primeiros elementos da lista (libertando
o respectivo espaço). Se a lista tiver n ou menos nodos, a função liberta a totalidade da lista.
A função deve retornar o número de elementos removidos. (https://codeboard.io/projects/
16259)*/

int drop (int n, LInt *l){
    LInt tmp;
    
    if (!(*l) || n == 0) return 0;
    else 
    {
        tmp = (*l)->prox;
        free(*l);
        *l = tmp;
        return 1 + drop (n-1, l);
    }
}

/*21. O tipo LInt pode ser usado ainda para implementar listas circulares. Defina uma função LInt
Nforward (LInt l, int N) que, dada uma lista circular dá como resultado o endereço do
elemento da lista que está N posições à frente. (https://codeboard.io/projects/16260)*/

LInt NForward (LInt l, int N){
    int i;
    
    for (i = 0; i < N; i++) l = l->prox;
    return l;
}

/*22. Defina uma função int listToArray (LInt l, int v[], int N) que, dada uma lista l,
preenche o array v com os elementos da lista.
A função deverá preencher no máximo N elementos e retornar o número de elementos preenchi-
dos. (https://codeboard.io/projects/16261)*/

int listToArray (LInt l, int v[], int N){
int i;

    for (i = 0; l && i < N;i++)
    {
        v[i] = l->valor;
        l = l->prox;
    }
    
    return i;
}

/*23. Defina uma função LInt arrayToList (int v[], int N) que constrói uma lista com os
elementos de um array, pela mesma ordem em que aparecem no array.. (https://codeboard.
io/projects/16262)*/

LInt arrayToList (int v[],int N){
	LInt new;
	int i;
	if(N>0){
		new=malloc(sizeof(struct lligada));
		new->valor = v[0];
		new->prox = arrayToList(v+1,N-1);
	}
	else new=NULL;
	return new;
}

/*24. Defina uma função LInt somasAcL (LInt l) que, dada uma lista de inteiros, constrói uma
nova lista de inteiros contendo as somas acumuladas da lista original (que deverá permanecer
inalterada).
Por exemplo, se a lista l tiver os valores [1,2,3,4] a lista contruı́da pela invocação de
somasAcL (l) deverá conter os valores [1,3,6,10]. (https://codeboard.io/projects/16263)*/

LInt somasAcL (LInt l) {
    int soma = 0;
    LInt r, *new = &r;
    
    while (l)
    {
        *new = malloc (sizeof(struct lligada));
        soma += l->valor;
        (*new)->valor = soma;
        l = l->prox;
        new=&((*new)->prox);
    }
    *new = NULL;
    return r;
}

/*28. Apresente uma definição da função int altura (ABin) que calcula a altura de uma árvore
binária. (https://codeboard.io/projects/16220)*/

int max(int a, int b)
{
    if (a >= b) return a;
    else return b;
}

int altura (ABin a){
    int r = 0;
    
    if (!a) r = 0;
    
    else r = 1 + max(altura(a->esq),altura(a->dir));
    
    return r;
}

/*29. Defina uma função ABin cloneAB (ABin) que cria uma cópia de uma árvore. (https://
codeboard.io/projects/16267)*/

ABin cloneAB (ABin a) {
    ABin r;
    
    if (!a) r = NULL;
    
    else
    {
        r = malloc(sizeof(struct nodo));
        r->valor = a->valor;
        r->esq = cloneAB(a->esq);
        r->dir = cloneAB(a->dir);   
    }
    
    return r;
}

/*30. Defina uma função void mirror (ABin *) que inverte uma árvore (sem criar uma nova
árvore). (https://codeboard.io/projects/16268)*/

void mirror (ABin *a) {
    ABin p;
    
    if (*a)
    {
        p = (*a)->esq;
        (*a)->esq = (*a)->dir;
        (*a)->dir = p;
        
        mirror(&((*a)->esq));
        mirror(&((*a)->dir));
    }
}

/*34. Apresente uma definição da função int depth (ABin a, int x) que calcula o nı́vel (menor)
a que um elemento está numa árvore binária (-1 caso não exista). (https://codeboard.io/projects/16273)*/

int depth (ABin a, int x) {
    int r = -1, e, d;
    
    if (a)
    {
        if (a->valor == x) r = 1;
        else
        {
            e = depth(a->esq, x);
            d = depth(a->dir, x);
            
            if (e > 0 && d > 0) r = 1 + (e < d ? e : d);
            else
            {
                if (e > 0) r = 1 + e;
                if (d > 0) r = 1 + d;
            }
        }
        
    }
     return r;
}

/*35. Defina uma função int freeAB (ABin a) que liberta o espaço ocupado por uma árvore
binária, retornando o número de nodos libertados. (https://codeboard.io/projects/16274)*/

int freeAB (ABin a) {
    int soma;
    
    if(!a) soma = 0;
    
    else 
    {
        soma = 1 + freeAB(a->esq) + freeAB(a->dir);
        free(a);
    }
    
    return soma;
}

/*36. Defina uma função int pruneAB (ABin *a, int l) que remove (libertando o espaço respec-
tivo) todos os elementos da árvore *a que estão a uma profundidade superior a l, retornando
o número de elementos removidos.
Assuma que a profundidade da raı́z da árvore é 1, e por isso a invocação pruneAB(&a,0)
corresponde a remover todos os elementos da árvore a. (https://codeboard.io/projects/16275)*/

int pruneAB (ABin *a, int l) {
    int r = 0;
    
    if(*a)
    {
        r += pruneAB(&((*a)->esq), l-1);
        r += pruneAB(&((*a)->dir), l-1);
        
        if (l <= 0)
        {
            r++;
            *a = NULL;
        }
    }
    
    return r;
 }

/*37. Defina uma função int iguaisAB (ABin a, ABin b) que testa se duas árvores são iguais
(têm os mesmos elementos e a mesma forma). (https://codeboard.io/projects/16276)*/

 int menor(int x, int y)
{
    if (x<=y) return x;
    
    else return y;
}

int iguaisAB (ABin a, ABin b) {
int r = 1;

    if (a && b)
    {
        if (a->valor != b->valor) r = 0;
        else r = menor(iguaisAB(a->dir,b->dir),iguaisAB(a->esq,b->esq));
    }
    
    if ((!a && b) || (a && !b)) r = 0;
    
    return r;
}

/*41. Defina uma função ABin somasAcA (ABin a) que, dada uma árvore de inteiros, calcula a
árvore das somas acumuladas dessa árvore.
A árvore calculada deve ter a mesma forma da árvore recebida como argumento e em cada
nodo deve conter a soma dos elementos da sub-árvore que aı́ se inicia. (https://codeboard.io/projects/16280)*/

ABin somasAcA (ABin a) {
    ABin new = NULL;
    
    if (a)
    {
        new = malloc (sizeof(struct nodo));
        new->valor = a->valor;
        new->esq = somasAcA(a->esq); 
        new->dir = somasAcA(a->dir);
        if (new->esq) new->valor += new->esq->valor;
        if (new->dir) new->valor += new->dir->valor;
    }
    
    return new;
}

/*42. Apresente uma definição da função int contaFolhas (ABin a) que dada uma árvore binária
de inteiros, conta quantos dos seus nodos são folhas, i.e., que não têm nenhum descendente.
(https://codeboard.io/projects/16281)*/

int contaFolhas (ABin a) {
    int soma = 0;
    
    if (!a) soma = 0;
    else
    {
        if (!(a->esq) && !(a->dir)) soma = 1;
        else 
        {
            soma += contaFolhas(a->esq);
            soma += contaFolhas(a->dir);
        }
    }
    return soma;
}

/*43. Defina uma função ABin cloneMirror (ABin a) que cria uma árvore nova, com o resultado
de inverter a árvore (efeito de espelho). (https://codeboard.io/projects/16282)*/

ABin cloneMirror (ABin a) {
    ABin new = malloc(sizeof (struct nodo));
    
    if (!a) new = NULL;
    else
    {
        new->valor = a->valor;
        new->esq = cloneMirror(a->dir);
        new->dir = cloneMirror(a->esq);
    }
    
    return new;
}

/*45. Apresente uma definição não recursiva da função int lookupAB (ABin a, int x) que testa
se um elemento pertence a uma árvore binária de procura. (https://codeboard.io/projects/16284)*/

int max(int x, int y)
{
    int r;
    r = x > y ? x : y;
    return r;
}
 
 
int lookupAB (ABin a, int x) {
    int r = 0;
    
    if (a)
    {
        if (a->valor == x) r = 1;
        else r = max(lookupAB (a->esq, x),lookupAB (a->dir, x));
    }
    return r;
}

/*46. Apresente uma definição da funçãoint depthOrd (ABin a, int x) que calcula o nı́vel a que
um elemento está numa árvore binária de procura (-1 caso não exista). (https://codeboard.
io/projects/16285)*/

int depthOrd (ABin a, int x) {
   int r = -1, aux;
   
   if (a)
   {
       if (a->valor == x) r = 1;
       else 
       {
           aux = a->valor > x ? depthOrd(a->esq, x) : depthOrd(a->dir, x);
           if (aux > 0) r = 1 + aux;
       }
   }
   return r;
}

/*47. Apresente uma definição não recursiva da função int maiorAB (ABin) que calcula o maior
elemento de uma árvore binária de procura não vazia. (https://codeboard.io/projects/16286)*/

int maiorAB (ABin a) {
    while (a->dir) a = a->dir;
    
    return a->valor;
}

/*48. Defina uma função void removeMaiorA (ABin *) que remove o maior elemento de uma
árvore binária de procura. (https://codeboard.io/projects/16287)*/

void removeMaiorA (ABin *a) {
    ABin l;
    
    if(a){
      
      while((*a)->dir) a = &((*a)->dir);
    
      l=(*a)->esq;
      
      free(*a);
      
      *a=l;
    }
}

/*49. Apresente uma definição da função int quantosMaiores (ABin a, int x) que, dada uma
árvore binária de procura de inteiros e um inteiro, conta quantos elementos da árvore são
maiores que o inteiro dado. (https://codeboard.io/projects/16288)*/

int quantosMaiores (ABin a, int x) {
    int soma = 0;
    
    if (!a) soma = 0;
    
    else
    {
        if (a->valor > x) soma = 1;
    
        soma += quantosMaiores(a->esq,x);
        soma += quantosMaiores(a->dir,x);
        
    }
    
    return soma;
}