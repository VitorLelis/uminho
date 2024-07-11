# Trabalho Prático Final

## RPCW 2023/2024

### Autores:
Jéssica Fernandes - A93318

Vitor Lelis - PG54273

[Repositório Original](https://github.com/MFJess/WildWise).

## 1. Introdução
Este relatório consiste na documentação do processo de desenvolvimento do trabalho prático da UC de Representação e Processamento de Conhecimento na Web, do ano letivo 2023/2024.

Este projeto consiste em escolher um domínio ontológico sobre o qual devemos construir uma aplicação que permita não só a consulta mas também a gestão de informação.

O primeiro passo será escolher o domínio sobre o qual irá incidir a ontologia e a aplicação. De seguida, recolher a informação necessária, convertendo-a numa ontologia, para posteriormente construir queries que respondam às necessidades do utilizador. Por fim, construir a aplicação que permitirá a interação.

Neste documento procederemos a explicar o processo executado para cada uma das etapas acima enumeradas.

Quanto à estrutura do projeto, criamos duas pastas:
- `data`, para tudo o que é relacionado à recolha e tratamento de dados, incluindo:
    - scripts de processamento de dados e povoamento da ontologia - na sub-pasta `scripts`
    - ficheiros de texto - na sub-pasta `text-files`
    - o ficheiro `animals.json` resultante da recolha de dados sobre todos os animais
    - a ontologia final `animals.ttl`
- `app`, onde está construída a app em si, incluindo as queries.

## 2. Implementação

### 2.1. Escolha do Domínio e Recolha de Dados
O tema escolhido foi animais. Decidimos que seria um tema fascinante devido à imensa riqueza de informações que podemos explorar, graças à enorme diversidade de animais e às suas características únicas. 

Essa diversidade permite-nos comparar e agrupá-los de diversas formas consoante as suas semelhanças e diferenças, revelando aspectos surpreendentes e enriquecedores sobre o mundo animal.

Escolhido o domínio do problema pudemos definir a informação que pretendemos recolher. Encontramos um *site* chamado API Ninjas, onde existem diversas categorias sobre as quais podemos fazer consultas, incluindo animais. Basta inserir o nome de um animal e conseguimos um json contendo todo o tipo de características de todos os animais que correspondem à pesquisa realizada.

É necessário então recolher uma lista de nomes de animais para serem inseridos na API. Estes nomes foram conseguidos no *site* All Animals A-Z List.

Assim, foi criado um script `data-api.py` para recolher informação de todos os animais cujos nomes estão no ficheiro `animals.txt` (resultado da passagem do ficheiro `all_animals.txt` pelo script `no_duplicates.py`).
Da execução deste *script* resultou o `animals.json`, que será utilizado para povoar a nossa ontologia.

### 2.2. Criação da Ontologia
Ao analisar o `animals.json`, deparamo-nos com diversas características relevantes, tendo selecionando as seguintes para fazer parte da nossa ontologia:
- Nome;
- Nome Científico;
- Reino;
- Família;
- Ordem;
- Classe;
- Género;
- Filo;
- Comprimento;
- Altura;
- Peso;
- Tipo de Pele;
- Cor(es);
- Dieta;
- Presas;
- Predadores;
- Tempo de Gestação;
- Tempo de Incubação;
- Esperança de Vida;
- Número de Espécies;
- Habitat(s);
- Localização/ões.

Analisando todas estas características decidimos torná-las em 5 classes diferentes:
- Animal
- Taxonomia
- Cor
- Localização
- Habitat classe.

#### 2.2.1. Classe Animal
A classe **Animal** terá a si associada *data properties* que representam as características mais básicas e  específicas de cada animal, assim como as que mais variam. Ppor exemplo, as mais ligadas à aparência, números, medidas e estatísticas. No fundo as que menos podem ser partilhadas entre animais diferentes.

Assim, as *data properties* da classe **Animal** serão:
- idAnimal
- nomeAnimal
- comprimento
- altura
- peso
- tipoPele
- dieta
- presas
- predadores
- gestacao 
- incubacao
- tempoVida
- nrEspecies

#### 2.2.2. Classe Taxonomia
Sabemos que as características taxonómicas tomam os mesmos valores para animais da mesma espécie, o que traduz para "Animais da mesma espécie estão associados à mesma taxonomia." Assim, decidimos criar uma classe **Taxonomia**, cujas *data properties* são precisamente todas as características taxonómicas do animal.

- nomeCientifico
- reino
- familia
- ordem
- classe
- genero
- filo

Desta forma podemos ter mais do que um animal associado à mesma taxonomia sem repetições nas *data properties* de ambos.

#### 2.2.3. Classe Cor
Notamos que as cores eram um pouco mais complexas de serem tratadas, pois, além de cada animal poder possuir mais do que uma, a forma como aparecem é uma string em que são separadas por letras maiúsculas no início de cada uma. Exemplo: "BrownRedOlive".

Assim, como cada animal tem 1 ou mais cores, e vários animais partilham da mesma cor, decidimos criar uma classe **Cor** que se relacionará com a classe **Animal** para representar as cores que um animal apresenta, em vez de criar apenas um atributo "cor" na classe **Animal**.

Esta classe é identificada apenas por duas *data properties* muito simples:
- idCor
- nomeCor

#### 2.2.4. Classe Habitat
Pelo mesmo motivo pelo qual separamos a **Cor** como uma classe, fizémo-lo com a classe **Habitat**. Um animal pode viver em diversos habitats diferentes, e animais diferentes têm habitats em comum. Assim fizemos com que animais e habitats se relacionassem através de uma *object property* em vez de tornar o habitat uma *data property* de **Animal**.

No `animals.json`, o habitat de um animal está representado numa string que pode variar um pouco a sua forma.

Exemplos:
"Forests, scrublands, savannas, and grasslands"
"Wetlands, shrublands, gardens, woodlands"
"Hardwood and conifer forests"

Por isso, no *script* do povoamento, tivemos de fazer algum tratamento das strings com regex para conseguir extrair apenas as palavras pretendidas.

Esta classe apresenta também apenas 2 *data properties*:
- idHabitat
- nomeHabitat

#### 2.2.5. Classe Localização
As localizações funcionam da mesma forma que os habitats, apenas com uma ligeira diferença devida à forma como o `animals.json` está construído. 
- name
- taxonomy
- **locations**_
- characteristics
    - **location**
    - ...

Existem, portanto, localizações registadas em dois campos, e por vezes, repetidas. 

Além disto, as localizações presentes em **locations** estão guardadas numa lista em que cada elemento é uma única localização. Já em **location**, as localizações estão guardadas numa string da mesma forma que os exemplos visto anteriormente na classe **Habitat**.

Além de extrair de formas diferentes as localizações de ambos os campos, juntamo-los e eliminamos as localizações repetidas.

Esta foi a informação mais complexa de ser extraída.

Mais uma vez, uma localização tem apenas duas *data properties* relevantes:
- idLocalizacao
- nomeLocalizacao

----

#### Object Properties
Depois de definir todas as classes e as suas *data properties*, definimos as quatro *object properties*, que representarão as relações entre **Animal** e cada uma das restantes classes.
- identificadoPor: relaciona a classe **Animal** com a classe **Taxonomia**
- existeEm: relaciona a classe **Animal** com a classe **Localização**
- habitaEm: relaciona a classe **Animal** com a classe **Habitat**
- coloracao: relaciona a classe **Animal** com a classe **Cor**

----

Gostaríamos ainda de destacar as *data properties* da classe **Animal** - **dieta**, **presas** e **predadores**.

#### **Dieta**

Inicialmente, pensamos em tornar a dieta de um animal muito específica, criando uma classe **Dieta**, e três subclasses **Carnivoro**, **Herbivoro** e **Omnivoro**. Cada dieta teria um **idDieta** e um **nomeDieta**.

Desta forma, poderíamos guardar as dietas dos animais de acordo com o seguinte exemplo:

O sapo é um animal insetívoro.

**Sapo** relaciona-se com **Insetivoro**, que é uma instância da subclasse **Carnivoro** da classe **Dieta**.

Isto permitir-nos-ia classificar e consultar os animais associados a cada uma das três dietas principais, e ainda assim guardar a dieta mais específica.

No entanto, depois de uma rápida análise ao ficheiro json, percebemos que os dados extraídos em relação à dieta não são tão específicos, existindo apenas as opções Carnivoro, Herbivoro e Omnivoro. 
Cada animal apresenta apenas uma desses três tipos de dietas. 

Assim, revertemos a dieta para apenas uma *data property* do **Animal**.


#### **Presas** e **Predadores**

Inicialmente, tínhamos em mente relacionar os animais através de duas *object properties* `temPresa` e `temPredador`.

Um animal 1 que estivesse relacionado com um animal 2 através de `presa` significaria que animal 1 teria como presa o animal 2. A *object property* `temPredador` funcionaria de forma análoga.

Desta forma, poderíamos relacionar todos os animais uns com os outros, podendo cada animal ter zero, uma ou mais presas e predadores.

Assim que vimos o json, percebemos que esta informação não estaria representada da forma como gostaríamos.

Exemplo de predadores: "Tiger, Snakes, Birds of Prey".

Este formato, não sendo específico o suficiente, não nos dá informação para relacionar os animais como idealizado.

### 2.3. Construção de Queries
Uma vez criada a ontologia, o passo seguinte foi criar as queries relevantes à interação que pretendemos obter na app.

Para começar, pensamos na informação que gostaríamos de poder consultar, e como iriamos apresentá-la.

Pensamos em agrupar os animais de acordo com as suas características taxonómicas, tipo de dieta, cor, e até localizações onde têm origem.

Decidimos que seria necessário criar queries SPARQL para conseguir as seguintes informações:
- lista de todos os animais;
- todas as informações de um animal;
- lista de todos os reinos;
- lista de todos os filos;
- lista de todas as classes;
- lista de todas as famílias;
- lista de todas as ordens;
- lista de todos os generos;
- lista de todas as localizações;
- lista de todos os habitats;
- lista de todas as cores;
- lista de todos os animais de um dado reino;
- lista de todos os animais de um dado filo;
- lista de todos os animais de uma dada classe;
- lista de todos os animais de uma dada família;
- lista de todos os animais de uma dada ordem;
- lista de todos os animais de um dado genero;
- lista de todos os animais de uma dada localizacao;
- lista de todos os animais de um dado habitat;
- lista de todos os animais de uma dada cor.

### 2.4. Implementação da App

Para a criação da App, optou-se por utilizar tecnologias como Python e o sua *framework* Flask. O objetivo da aplicação foi representar visualmente o resultado das queries de uma forma que fosse fácil de compreender e navegar.

Além de se criar diferentes páginas para cada tipo de consulta, foi também desenvolvida uma página de formulário que permite a adição de um novo elemento à ontologia, permitindo a sua expansão sem perder a coesão.

O funcionamento da aplicação consiste em realizar queries ao servidor do `GraphDB` e, a partir do resultado, preencher um template HTML com as informações corretas sobre a consulta atual.

### 2.5. Testar a Aplicação

Para testar a aplicação, é necessário primeiro instalar os módulos necessários, garantir que a ontologia esteja num repositório no `GraphDB`, mudar para a diretoria correta e finalmente executar a aplicação. Os passos são os seguintes:

1. Instale os módulos:
```bash
pip install -r requirements.txt
# OU
pip3 install -r requirements.txt
```
2. Crie um Docker Container local do `GraphDB` e faça-o correr em `localhost` na porta `7200`;

3. Dentro da aplicação do `GraphDB`, crie um repositório chamado `animals` e importe o ficheiro `animals.ttl`. Este ficheiro contém a ontologia criada para a aplicação.

4. Navegue para a diretoria da aplicação:
```bash
cd app/
```

5. Execute a aplicação:
```bash
python3 app.py
```