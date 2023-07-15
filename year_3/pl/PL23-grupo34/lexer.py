import ply.lex as lex

# Tokens so small that don't deserve a unique rule (at least they have a good personality)
literals = [',','{','}','=','\'','[',']','.']

# List of token names
tokens = [
    'DATETIME',
    'TIME',
    'HEX',
    'OCT',
    'BIN',
    'FLOAT',
    'INT',
    'INFINITY',
    'NAN',
    'BOOL',
    'WORD',
    'LITERALMULT',
    'QUOTEMULT',
    'LITERALS',
    'STRING',
]

t_WORD = r'[a-zA-Z_\-0-9]+'

def t_LITERALMULT(t):
    r"'''.*'''"
    t.value = str(t.value)[3:-3]
    return t

def t_QUOTEMULT(t):
    r'""".*"""'
    t.value = str(t.value)[3:-3]
    return t

def t_STRING(t):
    r'"[^"]*"'
    t.value = str(t.value)[1:-1]
    return t

def t_LITERALS(t):
    r"'[^']*'"
    t.value = str(t.value)[1:-1]
    return t

def t_DATETIME(t):
    r'\d{4}-\d{2}-\d{2}([Tt]\d{2}:\d{2}:\d{2}([Zz]|(\.\d{6})?((\+|-)\d{2}:\d{2})?))?' # as said in RFC3339 "NOTE: Per [ABNF] and ISO8601, the "T" and "Z" characters in this syntax may alternatively be lower case "t" or "z" respectively."
    t.value = str(t.value).replace("T"," ").replace("Z","+00:00")
    return t

def t_TIME(t):
    r'\d{2}:\d{2}:\d{2}([Zz]|(\.\d{6})?((\+|-)\d{2}:\d{2})?)' #isto depois tem de ser convertido em string para o json
    t.value = str(t.value).replace("T"," ").replace("Z","+00:00")
    return t

def t_BOOL(t):
    r'(true|false)'
    if t.value == "true":
        t.value = bool(True)
    elif t.value == "false":
        t.value = bool(False)
    return t

def t_OCT(t):
    r'0o[0-7_]+'
    filtered = ''.join((filter(lambda x: x != '_', t.value)))
    t.value = int(filtered,8)
    return t

def t_BIN(t):
    r'0b[01_]+'
    filtered = ''.join((filter(lambda x: x != '_', t.value)))
    t.value = int(filtered,2)
    return t

def t_HEX(t):
    r'0x[A-Fa-f0-9_]+'
    filtered = ''.join((filter(lambda x: x != '_', t.value)))
    t.value = int(filtered,16)
    return t

def t_FLOAT(t):
    r'(\+|-)?((\d+_?)+([eE](\+|-)?(\d+_?)+)|(\d+_?)+\.(\d+_?)+([eE](\+|-)?(\d+_?)+)?)'
    t.value = float(str(t.value).replace("_",""))
    return t

def t_INT(t):
    r'(\+|-)?\d+'
    t.value = int(t.value)
    return t

def t_INFINITY(t):
    r'(\+|-)?inf'
    t.value = float(t.value)
    return t

def t_NAN(t):
    r'(\+|-)?nan'
    t.value = float(t.value)
    return t

t_ignore  = ' \t'

def t_ignore_COMMENT(t):
    r'\#.*\n'
    pass

def t_error(t):
    t.lexer.skip(1)

lexer = lex.lex()