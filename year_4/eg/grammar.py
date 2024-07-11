grammar = """
//Regras Semanticas
start: (expressao SC)+
expressao: atribuicao 
         |declaracao
         | inicializacao
         | operacao 
         | condicional 
         | ciclo

declaracao: tipo var
inicializacao: tipo var EQ [objeto|operacao]
atribuicao: var EQ [objeto|operacao]
operacao: termo operador termo
        | termo operador (operacao)+ 

condicional: alternativa 
           | casos
alternativa: IF PE condicao PD CE (expressao SC)* CD 
		   | IF PE condicao PD CE expressao* CD SC ELSE CE expressao* CD
casos: MATCH PE var PD CE CASE objeto DP expressao* CASE UDS DP expressao* CD

ciclo: enquanto 
     | repete 
     | percorre
enquanto: WHILE PE condicao PD CE (expressao SC)* CD 
repete: DO CE expressao* CD WHILE PE condicao PD
percorre: FOR var IN conjunto CE expressao* CD

condicao: int 
        | bool 
        | operacao 
        | var
bool: TRUE 
    | FALSE

int : NUMBER

string: STR

tuplo: PE objeto [VIR objeto]* PD

array: PRE  PRD 
     | PRE objeto PRD 
     | PRE objeto (VIR objeto)* PRD

lista: PRE PRD 
     | PRE objeto lista* PRD

set: CE CD 
   | CE objeto CD 
   | CE objeto VIR objeto* CD

dict: CE key DP objeto (VIR key DP objeto)* CD
key: int
   | string

objeto: int
    | bool 
    | string 
    | tuplo 
    | array 
    | lista 
    | set
    | dict

var: /[a-zA-Z]\w*/ 

termo: var
     | int

conjunto: array 
        | set 
        | lista
        | dict
        | var
     
operador: PLUS 
        | MINUS 
        | MULT
        | DIV
        | MOD 
        | EQUAL 
        | DIFF 
        | LESS 
        | GREAT 
        | LEQUAL 
        | GEQUAL

tipo: INT
    | BOOL
    | STRING
    | TUPLO 
    | ARRAY 
    | LISTA 
    | SET
    | DICT

//Regras Lexicograficas
EQ: "="
DP: ":"
PE: "("
PD: ")"
PRE: "["
PRD: "]"
VIR: ","
CE: "{"
CD: "}"
UDS: "_"
IF: "if"
ELSE: "else"
CASE: "case"
INT: "int"
BOOL: "bool" 
STRING: "string"
TUPLO: "tuplo" 
ARRAY: "array" 
LISTA: "lista" 
SET: "set"
DICT: "dict"
PLUS: "+" 
MINUS: "-" 
MULT: "*" 
DIV: "/" 
MOD: "%" 
EQUAL: "==" 
DIFF: "!=" 
LESS: "<" 
GREAT: ">" 
LEQUAL:"<=" 
GEQUAL:">="
NUMBER: /\-?\d+/
STR: /\"\w+\"/
SC: ";" 
TRUE: "TRUE"
FALSE: "FALSE"
MATCH: "match"
WHILE: "while"
DO: "do"
FOR: "for"
IN: "in"

%import common.WS_INLINE
%ignore WS_INLINE
%ignore "\\n"
"""