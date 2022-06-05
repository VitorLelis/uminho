import Data.Char
data Movimento = Norte | Sul | Este | Oeste deriving Show
data Posicao = Pos Int Int deriving Show
data Semaforo = Verde | Amarelo | Vermelho deriving Show

{-1. Apresente uma definição recursiva da função (pré-definida) enumFromTo :: Int -> Int ->
[Int] que constrói a lista dos números inteiros compreendidos entre dois limites.
Por exemplo, enumFromTo 1 5 corresponde à lista [1,2,3,4,5]-}

enumerar :: Int -> Int -> [Int]  
enumerar a b | a == b = [a]
             | a > b = reverse (enumerar b a)
             | otherwise = a : (enumerar (a+1) b)

{-2. Apresente uma definição recursiva da função (pré-definida) enumFromThenTo :: Int -> Int
-> Int -> [Int] que constrói a lista dos números inteiros compreendidos entre dois limites
e espaçados de um valor constante.
Por exemplo, enumFromThenTo 1 3 10 corresponde à lista [1,3,5,7,9].-}

deAte :: Int -> Int -> Int -> [Int]
deAte a b c = if a <= c then auxDeAte a b c else reverse (auxDeAte c b a) 

auxDeAte :: Int -> Int -> Int -> [Int]
auxDeAte a b c | a >= c =[]
               | a == b = enumerar a c
               | otherwise = a : (auxDeAte b (b+r) c)
               where r = b-a

{-3. Apresente uma definição recursiva da função (pré-definida) (++) ::
que concatena duas listas.
[a] -> [a] -> [a]
Por exemplo, (++) [1,2,3] [10,20,30] corresponde à lista [1,2,3,10,20,30].-}

somaListas :: [a] -> [a] -> [a]
somaListas [] b = b
somaListas (x:xs) b = x : (somaListas xs b)

{-4. Apresente uma definição recursiva da função (pré-definida) (!!) :: [a] -> Int -> a que
dada uma lista e um inteiro, calcula o elemento da lista que se encontra nessa posição (assume-
se que o primeiro elemento se encontra na posição 0).
Por exemplo, (!!)
[10,20,30] 1 corresponde a 20.
Ignore os casos em que a função não se encontra definida (i.e., em que a posição fornecida não
corresponde a nenhuma posição válida da lista).-}

posicaoLista :: [a] -> Int -> a
posicaoLista (x:xs) n | n == 0 = x
                      | otherwise = posicaoLista xs (n-1)

{-5. Apresente uma definição recursiva da função (pré-definida) reverse :: [a] -> [a] que
dada uma lista calcula uma lista com os elementos dessa lista pela ordem inversa.
Por exemplo, reverse [10,20,30] corresponde a [30,20,10].-}

reverter :: [a] -> [a] 
reverter [] = []
reverter x = last x : reverter (init x) 

{-6. Apresente uma definição recursiva da função (pré-definida) take :: Int -> [a] -> [a] que
dado um inteiro n e uma lista l calcula a lista com os (no máximo) n primeiros elementos de
l.
A lista resultado só terá menos de que n elementos se a lista l tiver menos do que n elementos.
Nesse caso a lista calculada é igual à lista fornecida.
Por exemplo, take 2 [10,20,30] corresponde a [10,20].-}

pegar :: Int -> [a] -> [a]
pegar 0 l = l
pegar n [] = []
pegar n (x:xs) | n == 1 = [x]
               | otherwise = x : pegar (n-1) xs

{-7. Apresente uma definição recursiva da função (pré-definida) drop :: Int -> [a] -> [a] que
dado um inteiro n e uma lista l calcula a lista sem os (no máximo) n primeiros elementos de
l.
Se a lista fornecida tiver n elementos ou menos, a lista resultante será vazia.
Por exemplo, drop 2 [10,20,30] corresponde a [30].-}

largar :: Int -> [a] -> [a]
largar 0 l = l
largar n [] = []
largar n  (x:xs) = largar (n-1) xs

{-8. Apresente uma definição recursiva da função (pré-definida) zip ::
constói uma lista de pares a partir de duas listas.
[a] -> [b] -> [(a,b)]
Por exemplo, zip [1,2,3] [10,20,30,40] corresponde a [(1,10),(2,20),(3,30)].-}

zipar :: [a] -> [b] -> [(a,b)]
zipar [] [] = []
zipar [a] [] = []
zipar [] [b] = []
zipar (a:as) (b:bs) = (a,b) : zipar as bs

{-9. Apresente uma definição recursiva da função (pré-definida) elem ::
Bool que testa se um elemento ocorre numa lista.
Eq a => a -> [a] ->
Por exemplo, elem 20 [10,20,30] corresponde a True enquanto que elem 2 [10,20,30]
corresponde a False.-}

elemPert :: Eq a => a -> [a] -> Bool
elemPert a [] = False
elemPert a (x:xs) = if a == x then True else elemPert a xs

{-10. Apresente uma definição recursiva da função (pré-definida) replicate :: Int -> a ->
[a] que dado um inteiro n e um elemento x constói uma lista com n elementos, todos iguais
a x.
Por exemplo, replicate 3 10 corresponde a [10,10,10].-}

replicar :: Int -> a -> [a]
replicar n x | n == 1 = [x]
             | otherwise = x : replicar (n-1) x

{-11. Apresente uma definição recursiva da função (pré-definida) intersperse :: a -> [a] ->
[a] que dado um elemento e uma lista, constrói uma lista em que o elemento fornecido é
intercalado entre os elementos da lista fornecida.
Por exemplo, intersperce 1 [10,20,30] corresponde a [10,1,20,1,30].-}

intercalar :: a -> [a] -> [a]
intercalar y [x] = [x]
intercalar y (x:xs) = x : y : (intercalar y xs)

{-12. Apresente uma definição recursiva da função (pré-definida) group ::
agrupa elementos iguais e consecutivos de uma lista.
Eq a => [a] -> [[a]] que
Por exemplo, group [1,2,2,3,4,4,4,5,4] corresponde a [[1],[2,2],[3],[4,4,4],[5],[4]].-}

agrupar :: Eq a => [a] -> [[a]]
agrupar [] = []
agrupar (x:xs) = (x:takeWhile (==x) xs) : agrupar (dropWhile (==x) xs)

{-13. Apresente uma definição recursiva da função (pré-definida) concat ::
concatena as listas de uma lista.
[[a]] -> [a] que
Por exemplo, concat [[1],[2,2],[3],[4,4,4],[5],[4]] corresponde a [1,2,2,3,4,4,4,5,4].-}

conCat ::  [[a]] -> [a]
conCat [x] = x
conCat (x:xs) = x ++ conCat xs

{-14. Apresente uma definição recursiva da função (pré-definida) inits ::
calcula a lista dos prefixos de uma lista.
[a] -> [[a]] que
Por exemplo, inits [11,21,13] corresponde a [[],[11],[11,21],[11,21,13]].-}

inits :: [a] -> [[a]]
inits [] = [[]]
inits l = inits (init l) ++ [l]

{-15. Apresente uma definição recursiva da função (pré-definida) tails ::
calcula a lista dos sufixos de uma lista.
[a] -> [[a]] que
Por exemplo, tails [1,2,3] corresponde a [[1,2,3],[2,3],[3],[]].-}

caudas :: [a] -> [[a]]
caudas [] = [[]]
caudas (x:xs) = (x:xs) : (caudas xs)

{-16. Apresente uma definição recursiva da função (pré-definida) isPrefixOf ::
-> [a] -> Bool que testa se uma lista é prefixo de outra.
Eq a => [a]
Por exemplo, isPrefixOf [10,20] [10,20,30] corresponde a True enquanto que isPrefixOf
[10,30] [10,20,30] corresponde a False.-}

prefixo :: Eq a => [a]-> [a] -> Bool
prefixo _ [] = False
prefixo [] a = True
prefixo (x:xs) (y:ys) | x==y = prefixo xs ys
                      | otherwise = False

{-17. Apresente uma definição recursiva da função (pré-definida) isSuffixOf ::
-> [a] -> Bool que testa se uma lista é sufixo de outra.
Eq a => [a]
Por exemplo, isSuffixOf [20,30] [10,20,30] corresponde a True enquanto que isSuffixOf
[10,30] [10,20,30] corresponde a False.-}

sufixo :: Eq a => [a]-> [a] -> Bool
sufixo _ [] = False
sufixo [] a = True
sufixo x y = prefixo (reverse x) (reverse y)

{-18. Apresente uma definição recursiva da função (pré-definida) isSubsequenceOf :: Eq a =>
[a] -> [a] -> Bool que testa se os elementos de uma lista ocorrem noutra pela mesma
ordem relativa.
Por exemplo, isSubsequenceOf [20,40] [10,20,30,40] corresponde a True enquanto que
isSubsequenceOf [40,20] [10,20,30,40] corresponde a False.-}

sequencia :: Eq a => [a] -> [a] -> Bool
sequencia _ [] = False
sequencia [] a = True
sequencia (x:xs) (y:ys) | x == y = sequencia xs ys
                        | otherwise = sequencia (x:xs) ys

{-19. Apresente uma definição recursiva da função (pré-definida) elemIndices :: Eq a => a ->
[a] -> [Int] que calcula a lista de posições em que um dado elemento ocorre numa lista.
Por exemplo, elemIndices 3 [1,2,3,4,3,2,3,4,5] corresponde a [2,4,6].-}

indicedoElem :: Eq a => Int -> a -> [a] -> [Int]
indicedoElem _ _ [] = []
indicedoElem n a (x:xs) | a == x = n : indicedoElem (n+1) a xs
                        | otherwise = indicedoElem (n+1) a xs

elemInd :: Eq a => a -> [a] -> [Int]
elemInd _ [] = []
elemInd a (x:xs) = indicedoElem 0 a (x:xs)

{-20. Apresente uma definição recursiva da função (pré-definida) nub :: Eq a => [a] -> [a] que
calcula uma lista com os mesmos elementos da recebida, sem repetições.
Por exemplo, nub [1,2,1,2,3,1,2] corresponde a [1,2,3].-}

remover :: Eq a => a -> [a] -> [a]
remover x [] = []
remover x (h:t) | x == h = remover x t
                | otherwise = h : remover x t

nub :: Eq a => [a] -> [a]
nub [] = []
nub (x:xs) = x : nub(remover x xs)

{-21. Apresente uma definição recursiva da função (pré-definida) delete :: Eq a => a -> [a]
-> [a] que retorna a lista resultante de remover (a primeira ocorrência de) um dado elemento
de uma lista.
Por exemplo, delete 2 [1,2,1,2,3,1,2] corresponde a [1,1,2,3,1,2]. Se não existir nen-
huma ocorrência a função deverá retornar a lista recebida.-}

deletar :: Eq a => a -> [a]-> [a]
deletar _ [] = []
deletar a (x:xs) | a == x = xs
                 | otherwise = x : deletar a xs

{-22. Apresente uma definição recursiva da função (pré-definida) (\\):: Eq a => [a] -> [a]
-> [a] que retorna a lista resultante de remover (as primeiras ocorrências) dos elementos da
segunda lista da primeira.
Por exemplo, (\\)[1,2,3,4,5,1] [1,5] corresponde a [2,3,4,1].-}

deletarLista :: Eq a => [a] -> [a]-> [a]
deletarLista [] _ = []
deletarLista l [] = l
deletarLista  (x:xs) (h:t) |x == h = deletarLista xs t
                           | otherwise = x : deletarLista xs (h:t) 

{-23. Apresente uma definição recursiva da função (pré-definida) union :: Eq a => [a] -> [a]
-> [a] que retorna a lista resultante de acrescentar à primeira lista os elementos da segunda
que não ocorrem na primeira.
Por exemplo, union [1,1,2,3,4] [1,5] corresponde a [1,1,2,3,4,5].-}

union :: Eq a => [a] -> [a] -> [a]
union l [] = l
union [] l = l
union (x:xs) (y:ys) | elemPert y (x:xs) = union (x:xs) ys
                    | otherwise = union (x:xs) ys ++ [y]

{-24. Apresente uma definição recursiva da função (pré-definida) intersect :: Eq a => [a] ->
[a] -> [a] que retorna a lista resultante de remover da primeira lista os elementos que não
pertencem à segunda.
Por exemplo, intersect [1,1,2,3,4] [1,3,5] corresponde a [1,1,3].-}

myintersect :: Eq a => [a] ->[a] -> [a]
myintersect _ [] = []
myintersect [] _ = []
myintersect (x:xs) (y:ys) | x == y = x : myintersect xs (y:ys)
                          | otherwise = myintersect (x:xs) ys

{-25. Apresente uma definição recursiva da função (pré-definida) insert :: Ord a => a -> [a]
-> [a] que dado um elemento e uma lista ordenada retorna a lista resultante de inserir
ordenadamente esse elemento na lista.
Por exemplo, insert 25 [1,20,30,40] corresponde a [1,20,25,30,40].-}

inserir :: Ord a => a -> [a]-> [a]
inserir x [] = [x]
inserir x (h:t) | x <= h = x:(h:t)
                | otherwise = h : inserir x t

{-26. Apresente uma definição recursiva da função (pré-definida) unwords ::
junta todas as strings da lista numa só, separando-as por um espaço.
[String] -> String que
Por exemplo, unwords ["Programacao", "Funcional"] corresponde a "Programacao Funcional".-}

unword ::  [String] -> String
unword [] = []
unword (x:xs) = x ++ (' ' : unword xs)

{-27. Apresente uma definição recursiva da função (pré-definida) unlines :: [String] -> String que
junta todas as strings da lista numa só, separando-as pelo caracter ’\n’.
Por exemplo, unlines ["Prog", "Func"] corresponde a "Prog\nFunc\n".-}

unline :: [String] -> String
unline [] = []
unline (x:xs) = x ++ ('\n' : unline xs)

{-28. Apresente uma definição recursiva da função pMaior :: Ord a => [a] -> Int que dada
uma lista não vazia, retorna a posição onde se encontra o maior elemento da lista. As posições
da lista começam em 0, i.e., a função deverá retornar 0 se o primeiro elemento da lista for o
maior.-}

maiorLista :: Ord a => [a] -> a
maiorLista [x] = x
maiorLista (x:y:z) | x >= y = maiorLista (x:z)
                   | otherwise = maiorLista (y:z)


maior :: Ord a => [a] -> Int
maior [x] = 0
maior l@(x:xs) | maiorLista l == x = 0
               | otherwise = 1 + maior xs 


{-29. Apresente uma definição recursiva da função temRepetidos ::
testa se uma lista tem elementos repetidos.
Eq a => [a] -> Bool que
Por exemplo, temRepetidos [11,21,31,21] corresponde a True enquanto que temRepetidos
[11,2,31,4] corresponde a False.-}

ocorRepet :: Eq a => [a] -> Bool
ocorRepet [] = False
ocorRepet [x] = False
ocorRepet (x:y:z) | x == y = True  
                  | otherwise = ocorRepet (x:z)


temRepet :: Eq a => [a] -> Bool
temRepet [] = False
temRepet [x] = False
temRepet (x:xs) | ocorRepet (x:xs) = True
                | otherwise = ocorRepet xs 


{-30. Apresente uma definição recursiva da função algarismos ::
mina a lista dos algarismos de uma dada lista de caracteres.
[Char] -> [Char] que deter-
Por exemplo, algarismos "123xp5" corresponde a "1235".-}

algarismos :: [Char] -> [Char]
algarismos [] = []
algarismos (x:xs) | elemPert x "0123456789" = x : algarismos xs
                  | otherwise = algarismos xs

{-31. Apresente uma definição recursiva da função posImpares :: [a] -> [a] que determina os
elementos de uma lista que ocorrem em posições ı́mpares. Considere que o primeiro elemento
da lista ocorre na posição 0 e por isso par.
Por exemplo, posImpares [10,11,7,5] corresponde a [11,5].-}

posImpares :: [a] -> [a]
posImpares [] = []
posImpares (x:y:z) = y : posImpares z

{-32. Apresente uma definição recursiva da função posPares :: [a] -> [a] que determina os
elementos de uma lista que ocorrem em posições pares. Considere que o primeiro elemento da
lista ocorre na posição 0 e por isso par.
Por exemplo, posPares [10,11,7,5] corresponde a [10,7].-}

posPares :: [a] -> [a]
posPares [] = []
posPares (x:y:z) = x : posPares z

{-33. Apresente uma definição recursiva da função isSorted ::
se uma lista está ordenada por ordem crescente.
Ord a => [a] -> Bool que testa
Por exemplo, isSorted [1,2,2,3,4,5] corresponde a True, enquanto que isSorted [1,2,4,3,4,5]
corresponde a False.-}

isSorted ::  Ord a => [a] -> Bool
isSorted [x] = True
isSorted (x:xs) | x <= head xs = isSorted xs
                | otherwise = False

{-34. Apresente uma definição recursiva da função iSort :: Ord a => [a] -> [a] que calcula
o resultado de ordenar uma lista. Assuma, se precisar, que existe definida a função insert
:: Ord a => a -> [a] -> [a] que dado um elemento e uma lista ordenada retorna a lista
resultante de inserir ordenadamente esse elemento na lista.-}

mySort :: Ord a => [a] -> [a]
mySort [] = []
mySort [x] = [x]
mySort (x:xs) = inserir x (mySort xs)

{-35. Apresente uma definição recursiva da função menor :: String -> String -> Bool que
dadas duas strings, retorna True se e só se a primeira for menor do que a segunda, segundo
a ordem lexicográfica (i.e., do dicionário)
Por exemplo, menor "sai" "saiu" corresponde a True enquanto que menor "programacao"
"funcional" corresponde a False.-}

menorString :: String -> String -> Bool
menorString _ [] = False
menorString [] _ = True
menorString (x:xs) (y:ys) | x > y = False
                          | x < y = True
                          | otherwise = menorString xs ys

{-36. Considere que se usa o tipo [(a,Int)] para representar multi-conjuntos de elementos de a.
Considere ainda que nestas listas não há pares cuja primeira componente coincida, nem cuja
segunda componente seja menor ou igual a zero.
Defina a função elemMSet :: Eq a => a -> [(a,Int)] -> Bool que testa se um elemento
pertence a um multi-conjunto.
Por exemplo, elemMSet ’a’ [(’b’,2), (’a’,4), (’c’,1)] corresponde a True enquanto
que elemMSet ’d’ [(’b’,2), (’a’,4), (’c’,1)] corresponde a False.-}

analisaPar :: (a,Int) -> Bool
analisaPar (x,y) = if y > 0 then True else False

elemMSet :: Eq a => a -> [(a,Int)] -> Bool
elemMSet x [] = False
elemMSet x (h:t) | x == fst h = analisaPar h
                 | otherwise = elemMSet x t

{-37. Considere que se usa o tipo [(a,Int)] para representar multi-conjuntos de elementos de a.
Considere ainda que nestas listas não há pares cuja primeira componente coincida, nem cuja
segunda componente seja menor ou igual a zero.
Defina a função lengthMSet ::
conjunto.
[(a,Int)] -> Int que calcula o tamanho de um multi-
Por exemplo, lengthMSet [(’b’,2), (’a’,4), (’c’,1)] corresponde a 7.-}

lengthMSet :: [(a,Int)] -> Int
lengthMSet [] = 0
lengthMSet (x:xs) | analisaPar x = snd x + lengthMSet xs
                  | otherwise = lengthMSet xs

{-38. Considere que se usa o tipo [(a,Int)] para representar multi-conjuntos de elementos de a.
Considere ainda que nestas listas não há pares cuja primeira componente coincida, nem cuja
segunda componente seja menor ou igual a zero.
Defina a função converteMSet ::
lista dos seus elementos
[(a,Int)] -> [a] que converte um multi-conjuto na
Por exemplo, converteMSet [(’b’,2), (’a’,4), (’c’,1)] corresponde a "bbaaaac".-}

repetePar :: (a,Int) -> [a]
repetePar (a,n) = if analisaPar (a,n) == True then a:repetePar (a,(n-1)) else []


converteMSet :: [(a,Int)] -> [a]
converteMSet [] = []
converteMSet (h:t) = repetePar h ++ converteMSet t

{-39. Considere que se usa o tipo [(a,Int)] para representar multi-conjuntos de elementos de a.
Considere ainda que nestas listas não há pares cuja primeira componente coincida, nem cuja
segunda componente seja menor ou igual a zero.
Defina a função insereMSet :: Eq a => a -> [(a,Int)] -> [(a,Int)] que acrescenta
um elemento a um multi-conjunto.
Por exemplo, insereMSet ’c’ [(’b’,2), (’a’,4), (’c’,1)] corresponde a [(’b’,2),
(’a’,4), (’c’,2)].-}

insereMSet :: Eq a => a -> [(a,Int)] -> [(a,Int)]
insereMSet a [] = [(a,1)]
insereMSet a (h:t) | a == fst h = (fst h, (snd h + 1)) : t
                   | otherwise = h : insereMSet a t

{-40. Considere que se usa o tipo [(a,Int)] para representar multi-conjuntos de elementos de a.
Considere ainda que nestas listas não há pares cuja primeira componente coincida, nem cuja
segunda componente seja menor ou igual a zero.
Defina a função removeMSet :: Eq a => a -> [(a,Int)] -> [(a,Int)] que remove um
elemento a um multi-conjunto. Se o elemento não existir, deve ser retornado o multi-conjunto
recebido.
Por exemplo, removeMSet ’c’ [(’b’,2), (’a’,4), (’c’,1)] corresponde a [(’b’,2),
(’a’,4)].-}

removeMSet :: Eq a => a -> [(a,Int)] -> [(a,Int)]  
removeMSet a [] = []
removeMSet a (h:t) | a == fst h && snd h > 1 = (fst h , (snd h - 1)) : t 
                   | a == fst h && snd h <= 1 = t 
                   | otherwise = h : removeMSet a t 

{-41. Considere que se usa o tipo [(a,Int)] para representar multi-conjuntos de elementos de a.
Considere ainda que nestas listas não há pares cuja primeira componente coincida, nem cuja
segunda componente seja menor ou igual a zero.
Defina a função constroiMSet :: Ord a => [a] -> [(a,Int)] dada uma lista ordenada
por ordem crescente, calcula o multi-conjunto dos seus elementos.
Por exemplo, constroiMSet "aaabccc" corresponde a [(’a’,3), (’b’,1), (’c’,3)].-}

constroiMSet :: Ord a => [a] -> [(a,Int)]
constroiMSet [] = []
constroiMSet [x] = [(x,1)]
constroiMSet (h:t) = reverse (insereMSet h (constroiMSet t))

{-44. Considere o seguinte tipo para representar movimentos de um robot.
5
[Either
[Maybe a] -> [a]data Movimento = Norte | Sul | Este | Oeste
deriving Show
Defina a função posicao :: (Int,Int) -> [Movimento] -> (Int,Int) que, dada uma
posição inicial (coordenadas) e uma lista de movimentos, calcula a posição final do robot
depois de efectuar essa sequência de movimentos.-}

posicao :: (Int,Int) -> [Movimento] -> (Int,Int)
posicao (x,y) [] = (x,y)
posicao (x,y) (h:t) = posicao (case h of Norte -> (x,y+1)
                                         Sul   -> (x,y-1)
                                         Este  -> (x+1,y)
                                         Oeste -> (x-1,y)) t

{-45. Considere o seguinte tipo para representar movimentos de um robot.
data Movimento = Norte | Sul | Este | Oeste
deriving Show
Defina a função caminho :: (Int,Int) -> (Int,Int) -> [Movimento] que, dadas as posições
inicial e final (coordenadas) do robot, produz uma lista de movimentos suficientes para que o
robot passe de uma posição para a outra.-}

caminho :: (Int,Int) -> (Int,Int) -> [Movimento]
caminho (xi,yi) (xf,yf) 
      | xi < xf =  Este : caminho (xi+1,yi) (xf,yf)
      | xi > xf = Oeste : caminho (xi-1,yi) (xf,yf)
      | yi < yf = Norte : caminho (xi,yi+1) (xf,yf)
      | yi > yf = Sul   : caminho (xi,yi-1) (xf,yf)
      | otherwise = []

{-46. Considere o seguinte tipo para representar movimentos de um robot.
data Movimento = Norte | Sul | Este | Oeste
deriving Show
Defina a função vertical :: [Movimento] -> Bool que, testa se uma lista de movimentos
só é composta por movimentos verticais (Norte ou Sul).-}

vertical :: [Movimento] -> Bool
vertical [] = True
vertical (h:t) = case h of Este -> False
                           Oeste -> False
                           otherwise -> vertical t

{-47. Considere o seguinte tipo para representar a posição de um robot numa grelha.
data Posicao = Pos Int Int
deriving Show
Defina a função maisCentral :: [Posicao] -> Posicao que, dada uma lista não vazia de
posições, determina a que está mais perto da origem (note que as coordenadas de cada ponto
são números inteiros).-}

maisCentral :: [Posicao] -> Posicao
maisCentral [x] = x
maisCentral (x:y:z) | vetor x <= vetor y = maisCentral (x:z)
                    | otherwise = maisCentral (y:z)

vetor ::  Posicao -> Int
vetor (Pos x y) = x^2 + y^2

{-49. Considere o seguinte tipo para representar a posição de um robot numa grelha.
data Posicao = Pos Int Int
deriving Show
Defina a função mesmaOrdenada :: [Posicao] -> Bool que testa se todas as posições de
uma dada lista têm a mesma ordenada.-}

mesmaOrdenada :: [Posicao] -> Bool
mesmaOrdenada [(Pos x y)] = True
mesmaOrdenada ((Pos x y):(Pos xt yt):t) = y == yt && mesmaOrdenada ((Pos xt yt):t)

{-50. Considere o seguinte tipo para representar o estado de um semáforo.
data Semaforo = Verde | Amarelo | Vermelho
deriving Show
Defina a função interseccaoOK :: [Semaforo] -> Bool que testa se o estado dos semáforos
de um cruzamento é seguro, i.e., não há mais do que semáforo não vermelho.-}

interseccaoOK :: [Semaforo] -> Bool
interseccaoOK [] = True
interseccaoOK (h:t) | contarNaoVermelho (h:t) >= 2 = False
                    | otherwise = True

contarNaoVermelho :: [Semaforo] -> Int
contarNaoVermelho [] = 0
contarNaoVermelho (x:xs) = case x of  Vermelho -> contarNaoVermelho xs
                                      otherwise -> 1 + contarNaoVermelho xs 
