import ply.yacc as yacc
import json
import sys
from lexer import tokens
from dict_to_json import dict_to_json

def p_root(p):
    'root : toml'
    
    p[0] = dict()
    for key,value in p[1]:
        if key in p[0].keys():
            if isinstance(p[0][key],dict):
                p[0][key].update(value)
            elif isinstance(p[0][key],list):
                p[0][key].append(value)
        else:
            p[0][key] = value

def p_toml_table(p):
    'toml : table'
    p[0] = [p[1]]

def p_toml_arraytable(p):
    'toml : arraytable'
    key , value = p[1]

    p[0] = [] + [(key,[value])]

def p_toml_empty(p):
    'toml : empty'
    p[0] = []

def p_toml_toml_attributes(p):
    'toml : toml attributes'
    p[0] = [] + p[1] + p[2]

def p_toml_toml_table(p):
    'toml : toml table'
    p[0] = p[1] + [p[2]]

def p_toml_toml_arraytable(p):
    'toml : toml arraytable'
    p[0] = p[1] + [p[2]]

def p_table(p):
    "table : header attributes"
    aux = dict()
    for key,value in p[2]:
        if key in aux.keys():
            aux[key].update(value)
        else:
            aux[key] = value
    
    if len(p[1]) > 1:
        last = { (p[1])[-1] : aux }
        p[1].reverse()
        for key in p[1][1:len(p[1])-1]:
            last = { key : last }
        p[0] = ( (p[1])[-1] , last )
    else:
        p[0] = ( (p[1])[0] , aux )

def p_arraytable(p):
    "arraytable : '[' header ']' attributes"
    aux = dict()
    for key,value in p[4]:
        if key in aux.keys():
            aux[key].update(value)
        else:
            aux[key] = value
    
    if len(p[2]) > 1:
        last = { (p[2])[-1] : aux }
        p[2].reverse()
        for key in p[2][1:len(p[2])-1]:
            last = { key : last }
        p[0] = ( (p[2])[-1] , last )
    else:
        p[0] = ( (p[2])[0] , aux )

def p_table_empty(p):
    "table : header empty"
    p[0] = ( p[1][0] , {} )

def p_arraytable_empty(p):
    "arraytable : '[' header ']' empty"
    p[0] = ( p[2][0] , {} )
    

def p_attributes(p):
    'attributes : attributes attribute'
    p[0] = []
    for elem in p[1]:
        p[0].append(elem)
    p[0].append(p[2])

def p_attributes_single(p):
    'attributes : attribute'
    p[0] = [ p[1] ]

def p_attribute(p):
    "attribute : key '=' value"
    if len(p[1]) > 1:
        last = { p[1][-1] : p[3] }
        p[1].reverse()
        for key in p[1][1:len(p[1])-1]:
            last = { key : last }
        p[0] = ( p[1][-1] , last )
    else:
        p[0] = ( p[1][0] , p[3] )

def p_key(p):
    "key : key '.' simplekey"
    p[0] = []
    for elem in p[1]:
        p[0].append(elem)
    p[0].append(p[3])

def p_key_simplekey(p):
    "key : simplekey"
    p[0] = [ p[1] ]

def p_simplekey(p):
    '''simplekey    : WORD
                    | STRING'''
    p[0] = p[1]

def p_header(p):
    "header   : '[' key ']'"
    p[0] = p[2]

def p_value(p):
    '''value : term
             | array
             | inlinetable'''
    p[0] = p[1]

def p_term(p):
    '''term : INT
            | LITERALMULT
            | QUOTEMULT
            | STRING
            | LITERALS
            | FLOAT
            | DATETIME
            | TIME
            | BOOL
            | OCT
            | BIN
            | HEX
            | INFINITY
            | NAN'''
    p[0] = p[1]

def p_array(p):
    "array : '[' array_elements ']'"
    p[0] = [ ]
    for elem in p[2]:
            p[0].append(elem)

def p_inlinetable(p):
    "inlinetable : '{' inline_attributes '}'"
    aux = dict()
    for key,value in p[2]:
        aux[key] = value
    p[0] = aux

def p_inline_attributes(p):
    '''inline_attributes : inline_attributes ',' attribute '''
    p[0] = []
    for elem in p[1]:
        p[0].append(elem)
    p[0].append(p[3])

def p_inline_attributes_single(p):
    'inline_attributes : attribute'
    p[0] = [ p[1] ]

def p_inline_attributes_empty(p):
    'inline_attributes : empty'
    p[0] = []

def p_array_elements(p):
    '''array_elements : array_elements ',' value '''
    p[0] = []
    for elem in p[1]:
        p[0].append(elem)
    p[0].append(p[3])

def p_array_elements_single(p):
    'array_elements : value'
    p[0] = [ p[1] ]

def p_array_elements_empty(p):
    'array_elements : empty'
    p[0] = []

def p_empty(p):
    "empty :"
    pass

def p_error(p):
    print("Syntax error in input!",p)
    parser.success=False

parser = yacc.yacc()
parser.success=True
parser.last_table = ""

def convert(input_path,indent=2):
    source = ""
    f = open(input_path,encoding="utf-8")
    
    for linha in f:
        source += linha

    ast = parser.parse(source)

    result = json.dumps(ast,indent=2)
    # if parser.success == True:
    #     result = dict_to_json(ast)
    # else:
    #     result = ""
    #print(result)

    return ( parser.success , result )

def main():
    args = sys.argv
    if len(args) == 1:
        print("erro: ficheiro de entrada não definido")
        print("uso: python converter_gic.py <path do ficheiro TOML>")
    else:
        path = args[1]
        (success, result) = convert(path)
            
        if success:
            print('Parsing completed!')
            toml_output = path.replace(".toml",".json")
            f = open(toml_output, "w")
            f.write(result)
            f.close()
            print("Resultado da conversão guardado em:", path)
        else:
            print('Parsing failed!')

if __name__ == "__main__":
    main()