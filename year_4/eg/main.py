from lark import Lark
from lark.visitors import Interpreter
from grammar import grammar
from json2html import *
import pygraphviz as pgv
import re

# Instalar pygraphviz do (https://github.com/pygraphviz/pygraphviz/tree/main)

regex = re.compile("for | {")

p = Lark(grammar) # cria um objeto parser

simple_test="""
int x = TRUE;
int y = 0;

if(x){ y = y +1; x = FALSE; };

while(y<52){y = y*2;};
"""

nested_if = """
bool t = TRUE;
bool f = FALSE;

if (f == FALSE) {if(t != FALSE) {s = {TRUE}; };};
"""

nested_loop= """
int y; 

y = 5;

int x = 10 + 23; 
int z = y + x;


while(y < x) {while (z >= 20) { z=z-1; y=y+1;}; };
"""

nested_both = """
int x = 10 + 23; 
while(x >= 10) { if(x == 11) {x = x-1;};};
"""

advanced_test = """
int y; 
int x = 10 + 23; 

y = 10;
z + 10;

int x = 2;
int z = y + x;

bool t = TRUE;
bool f = FALSE;

string w = "Hello";

array a = [1,2,3];

lista l = [1,"List",TRUE];

lista vl = [];

dict d = {1: "oi", "teste" : [1,2,3]};

set s = {};

if (t) {x + 1; y-1;};

if (f == FALSE) {if(t != FALSE) {s = {TRUE}; };};

while(z == 20){x * 2; t = FALSE;};

for i in [3,5,6]{x = z + i};

for i in l {y = x / i};

while(x < y) {while (t == TRUE) { z-1; }; };

while(x >= 10) { if(x == 11) {x-1;};};
"""

tests = [simple_test,nested_if,nested_loop,nested_both,advanced_test]

prompt = """Qual teste deseja?
0 -> Simples
1 -> Cond. Entrelaçado
2 -> Ciclo Entrelaçado
3 -> Ciclo com Cond.
4 -> Avançado
"""

choice = int(input(prompt))

test = tests[choice]

tree = p.parse(test) # retorna uma tree

def get_original_sentence(node):
    if isinstance(node, str):
        return node.value
    
    if hasattr(node, 'children'):
        return ' '.join(get_original_sentence(child) for child in node.children)
    
    return ''

class InterpreterIntervalos(Interpreter):
    def __init__(self):
        self.symbols = {
            'vars' : {}, 
            'types' : {},
            'instructions' : {
                'assign' : 0,
                'read_write' : 0,
                'conditional' : 0,
                'cycle' : 0
            },
            'errors': {
                'redeclarations' : 0,
                'not_declared' : 0
            },
            'nested_control': 0,
            'complex_ifs' : []
        }
        self.graph = pgv.AGraph(directed=True,strict=True)

    def start(self,tree):
        self.graph.add_node("START",color="green")
        self.graph.add_node("COND_AUX")
        self.graph.add_node("END_COND")
        self.graph.add_node("END_LOOP")
        
        self.visit_children(tree)

        self.graph.add_node("END",color="red")

        nodes = self.graph.nodes()[4:]

        last_node = "START"
        cond_buffer = list()
        cond_run = False
        loop_buffer = list()
        loop_run = False
 
        for n in nodes:  
            self.graph.add_edge(last_node,n)

            if cond_run:
                self.graph.add_edge(last_node,n)
                for cb in cond_buffer:
                    self.graph.add_edge(cb,n,label="False")
                cond_buffer = list()
                cond_run = False

            if loop_run:
                self.graph.delete_edge(last_node,n)
                for lb in loop_buffer:
                    self.graph.add_edge(lb,n,label="False")
                loop_buffer = list()
                loop_run = False
            
            if self.graph.has_edge(n,"COND_AUX"):
                self.graph.delete_edge(n,"COND_AUX")
                cond_buffer.append(n)
            
            if self.graph.has_edge(n,"END_COND"):
                self.graph.delete_edge(n,"END_COND")
                cond_run = True
            
            if self.graph.has_edge(n,n):
                self.graph.delete_edge(n,n)
                loop_buffer.append(n)
            
            if self.graph.has_edge(n,"END_LOOP"):
                self.graph.delete_edge(n,"END_LOOP")
                loop_run = True
            
            last_node = n
        
        self.graph.delete_node("COND_AUX")
        self.graph.delete_node("END_COND")
        self.graph.delete_node("END_LOOP")

        #print(self.graph.string())
        self.graph.layout("dot")
        self.graph.draw("graph.png")
        
        return self.symbols
    
    def expressao(self, tree): 
        self.visit_children(tree)

    def declaracao(self,tree):

        # ---------- Tabela ----------- 

        var_type = tree.children[0].children[0].value
        var_name = tree.children[1].children[0].value
        
        # tratar variavel
        if var_name in self.symbols['vars'].keys():
            self.symbols['errors']['redeclarations'] += 1
            self.symbols['vars'][var_name]['redeclaration?'] = True

        else:
            self.symbols['vars'][var_name] = {
                'type': var_type,
                'declaration?': True,
                'redeclaration?': False,
                'inicialization?': False,
                'used': 0
            }

            # tratar tipo
            if var_type in self.symbols['types'].keys():
                self.symbols['types'][var_type] += 1
            else:
                self.symbols['types'][var_type] = 1

        # ---------- Grafo ----------- 

        original_sentence = get_original_sentence(tree)
        self.graph.add_node(original_sentence)

    def inicializacao(self,tree):

        # ---------- Tabela ----------- 

        var_type = tree.children[0].children[0].value
        var_name = tree.children[1].children[0].value
        
        # tratar variavel
        if var_name in self.symbols['vars'].keys():
            self.symbols['errors']['redeclarations'] += 1
            self.symbols['vars'][var_name]['redeclaration?'] = True

        else:
            self.symbols['vars'][var_name] = {
                'type': var_type,
                'declaration?': True,
                'redeclaration?': False,
                'inicialization?': True,
                'used': 0
            }
            
            # tratar tipo
            if var_type in self.symbols['types'].keys():
                self.symbols['types'][var_type] += 1
            else:
                self.symbols['types'][var_type] = 1

        # ---------- Grafo ----------- 

        original_sentence = get_original_sentence(tree)
        self.graph.add_node(original_sentence)

        size = self.graph.number_of_nodes()

        self.visit(tree.children[3])

        extra = self.graph.nodes()[size:]
        self.graph.remove_nodes_from(extra)

    def atribuicao(self,tree):

        # ---------- Tabela ----------- 

        self.symbols['instructions']['assign'] +=1

        var_name = tree.children[0].children[0].value

        if var_name not in self.symbols['vars'].keys():
            self.symbols['errors']['not_declared'] += 1
        
        else:
            self.symbols['vars'][var_name]['used'] += 1

        # ---------- Grafo ----------- 

        original_sentence = get_original_sentence(tree)
        self.graph.add_node(original_sentence)

        size = self.graph.number_of_nodes()

        self.visit(tree.children[2])

        extra = self.graph.nodes()[size:]
        self.graph.remove_nodes_from(extra)

    def operacao(self, tree):

        # ---------- Tabela -----------

        self.symbols['instructions']['read_write'] += 1
        self.visit_children(tree)
        
        # ---------- Grafo -----------

        original_sentence = get_original_sentence(tree)
        self.graph.add_node(original_sentence)

    def condicional(self, tree):

        # ---------- Tabela -----------

        self.symbols['instructions']['conditional'] += 1
        
        cond_control = [t.data for t in tree.find_data('condicional')]

        cycle_control = [t.data for t in tree.find_data('ciclo')]

        if len(cond_control) == 2:
            original_sentence = get_original_sentence(tree)
            self.symbols['complex_ifs'].append(original_sentence)
        
        if len(cond_control) > 1 or len(cycle_control) > 0:
            self.symbols['nested_control'] += 1

        # ---------- Grafo -----------

        last_size = self.graph.number_of_nodes()
        
        self.visit_children(tree)

        cond_body = self.graph.nodes()[last_size:]
        cond_pairs = list(zip(cond_body,cond_body[1:]))

        x,y = cond_pairs[0]
        self.graph.add_edge(x,y,label = "True")
        
        for i,j in cond_pairs[1:]:
            self.graph.add_edge(i,j)

        self.graph.add_edge(cond_body[-1],"END_COND")


    def ciclo(self, tree):

        # ---------- Tabela -----------

        self.symbols['instructions']['cycle'] += 1

        cond_control = [t.data for t in tree.find_data('condicional')]

        cycle_control = [t.data for t in tree.find_data('ciclo')]
        
        if len(cond_control) > 0 or len(cycle_control) > 1:
            self.symbols['nested_control'] += 1
        
        # ---------- Grafo -----------

        original_sentence = get_original_sentence(tree)

        loop_body = list()

        if original_sentence.startswith('for'):
            condition = regex.split(original_sentence)[1]
            self.graph.add_node(condition,shape="diamond")
            self.graph.add_edge(condition, condition)
            loop_body.append(condition)

        last_size = self.graph.number_of_nodes()

        self.visit_children(tree)

        loop_body += self.graph.nodes()[last_size:]
        loop_pairs = list(zip(loop_body,loop_body[1:]))

        x,y = loop_pairs[0]
        self.graph.add_edge(x,y,label = "True")

        last_loop = x
        
        for i,j in loop_pairs:
            if self.graph.has_edge(i,i):
                self.graph.add_edge(i,last_loop, label = "False")
                self.graph.delete_edge(i,i)
                last_loop = i
            if self.graph.has_edge(i,"COND_AUX"):
                self.graph.delete_edge(i,"COND_AUX")
                self.graph.add_edge(i,last_loop,label="False")
            if self.graph.has_edge(j,"END_LOOP"):
                self.graph.delete_edge(j,"END_LOOP")
            if self.graph.has_edge(j,"END_COND"):
                self.graph.delete_edge(j,"END_COND")
            self.graph.add_edge(i,j)

        if self.graph.has_edge(j,x):
            self.graph.delete_edge(j,x)
        self.graph.add_edge(x,x)
        self.graph.add_edge(j,last_loop)
        self.graph.add_edge(j,"END_LOOP")

    
    def condicao(self,tree):
        original_sentence = get_original_sentence(tree)
        self.graph.add_node(original_sentence,shape="diamond")
        self.graph.add_edge(original_sentence, "COND_AUX")
    
    def var(self, tree):
        var_name = tree.children[0].value
        if var_name not in self.symbols['vars'].keys():
            self.symbols['vars'][var_name] = {
                'type': '',
                'declaration?': False,
                'redeclaration?': False,
                'inicialization?': False,
                'used': 0
            }

            self.symbols['errors']['not_declared'] += 1
        
        self.symbols['vars'][var_name]['used'] += 1


data = InterpreterIntervalos().visit(tree)

f = open("result.html",'w')
f.write(f"<h2>Código</h2><code>{test}</code>")
f.write("<h2>Tabela</h2>")
f.write(json2html.convert(json=data))
f.write('<h2>Grafo</h2><img src="graph.png" alt="CFG">')
f.close()