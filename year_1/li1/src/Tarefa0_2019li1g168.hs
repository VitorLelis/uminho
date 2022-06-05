-- | Este módulo define funções genéricas sobre vetores e matrizes, que serão úteis na resolução do trabalho prático.
module Tarefa0_2019li1g168 where

-- * Funções não-recursivas.

-- | Um ponto a duas dimensões dado num referencial cartesiado (distâncias aos eixos vertical e horizontal)
--
-- <<http://li1.lsd.di.uminho.pt/images/cartesiano.png cartesisano>>
-- , ou num referencial polar (distância à origem e ângulo do respectivo vector com o eixo horizontal).
--
-- <<http://li1.lsd.di.uminho.pt/images/polar.png polar>>
data Ponto = Cartesiano Double Double | Polar Double Angulo deriving Show

-- | Um ângulo em graus.
type Angulo = Double

-- ** Funções sobre vetores

-- | Um 'Vetor' na representação escalar é um 'Ponto' em relação à origem.
type Vetor = Ponto
-- ^ <<http://li1.lsd.di.uminho.pt/images/vetor.png vetor>>

-- *** Funções gerais sobre 'Vetor'es.

-- | Soma dois 'Vetor'es.
somaVetores :: Vetor -> Vetor -> Vetor
somaVetores (Cartesiano x1 y1) (Cartesiano x2 y2) = Cartesiano (x1+x2) (y1+y2)
somaVetores p1 p2 = resultado
            where
            aCart = polartoCart p1
            bCart = polartoCart p2
            resultado = somaVetores aCart bCart 

-- | Subtrai dois 'Vetor'es.
subtraiVetores :: Vetor -> Vetor -> Vetor
subtraiVetores (Cartesiano x1 y1) (Cartesiano x2 y2) = Cartesiano (x1-x2) (y1-y2)
subtraiVetores p1 p2 = resultado
            where
            aCart = polartoCart p1
            bCart = polartoCart p2
            resultado = subtraiVetores aCart bCart 


-- | Multiplica um escalar por um 'Vetor'.
multiplicaVetor :: Double -> Vetor -> Vetor
multiplicaVetor n (Cartesiano x1 y1) = Cartesiano (n*x1) (n*y1)
multiplicaVetor n p1 = resultado
                where
                aCart = polartoCart p1
                resultado = multiplicaVetor n aCart               

-- ** Funções sobre rectas.

-- | Um segmento de reta é definido por dois pontos.
type Reta = (Ponto,Ponto)

-- | Testar se dois segmentos de reta se intersetam.
polartoCart :: Ponto -> Ponto
polartoCart (Polar r a) = Cartesiano x y
            where
            ar = a * pi / 180
            x = r*(cos ar)
            y = r*(sin ar)
polartoCart p1 = p1

carttoPolar :: Ponto -> Ponto
carttoPolar (Cartesiano x y) = Polar r a
            where
            r = sqrt (x^2 + y^2)
            a = atan (y/x)
carttoPolar p1 = p1
--
-- __NB:__ Aplique as equações matemáticas bem conhecidas, como explicado por exemplo em <http://www.cs.swan.ac.uk/~cssimon/line_intersection.html>.
intersetam :: Reta -> Reta -> Bool
intersetam ((Cartesiano x1 y1), (Cartesiano x2 y2)) ((Cartesiano x3 y3), (Cartesiano x4 y4)) 
    = div /= 0 && a >= 0 && a <= 1 && b >= 0 && b <= 1
    where 
        div = (((x4 - x3) * (y1 - y2)) - (x1-x2) * (y4-y3))
        a = ((y3 - y4) * (x1 - x3) + (x4 - x3) * (y1 - y3)) / div
        b = (((y1 - y2) * (x1 - x3)) + ((x2 - x1) * (y1 - y3)))  / div

intersetam (p1r1,p2r1) (p1r2,p2r2) = resultado
        where 
        aCart = polartoCart p1r1 
        bCart = polartoCart p2r1
        cCart = polartoCart p1r2
        dCart = polartoCart p2r2
        resultado = intersetam (aCart, bCart) (cCart, dCart)


-- | Calcular o ponto de intersecao entre dois segmentos de reta.
--
-- __NB:__ Aplique as equações matemáticas bem conhecidas, como explicado por exemplo em <http://www.cs.swan.ac.uk/~cssimon/line_intersection.html>.
intersecao :: Reta -> Reta -> Ponto
intersecao (p1@(Cartesiano x1 y1),p2@(Cartesiano x2 y2)) (p3@(Cartesiano x3 y3),p4@(Cartesiano x4 y4)) = pip
  where d = (((x4 - x3) * (y1 - y2)) - (x1-x2) * (y4-y3))
        ta = ((y3 - y4) * (x1 - x3) + (x4 - x3) * (y1 - y3)) / d
        p2mp1 = subtraiVetores p2 p1
        tatpip = multiplicaVetor ta p2mp1
        pip = somaVetores p1 tatpip

intersecao (p1r1,p2r1) (p1r2,p2r2) = resultado
          where 
          aCart = polartoCart p1r1 
          bCart = polartoCart p2r1
          cCart = polartoCart p1r2
          dCart = polartoCart p2r2
          resultado = intersecao (aCart, bCart) (cCart, dCart)

          
-- ** Funções sobre listas

-- *** Funções gerais sobre listas.
--
-- Funções não disponíveis no 'Prelude', mas com grande utilidade.

-- | Verifica se o indice pertence à lista.
--
-- __Sugestão:__ use a função 'length' que calcula tamanhos de listas
eIndiceListaValido :: Int -> [a] -> Bool 
eIndiceListaValido _ [] = False
eIndiceListaValido n (h:t) = if n < (length (h:t)) && (n>=0) then True
                             else False


-- ** Funções sobre matrizes.

-- *** Funções gerais sobre matrizes.

-- | A dimensão de um mapa dada como um par (/número de linhas/,/número de colunhas/).
type DimensaoMatriz = (Int,Int)

-- | Uma posição numa matriz dada como um par (/linha/,/colunha/).
-- As coordenadas são dois números naturais e começam com (0,0) no canto superior esquerdo, com as linhas incrementando para baixo e as colunas incrementando para a direita:
--
-- <<http://li1.lsd.di.uminho.pt/images/posicaomatriz.png posicaomatriz>>
type PosicaoMatriz = (Int,Int)

-- | Uma matriz é um conjunto de elementos a duas dimensões.
--
-- Em notação matemática, é geralmente representada por:
--
-- <<https://upload.wikimedia.org/wikipedia/commons/d/d8/Matriz_organizacao.png matriz>>
type Matriz a = [[a]]

-- | Calcula a dimensão de uma matriz.
--
-- __NB:__ Note que não existem matrizes de dimensão /m * 0/ ou /0 * n/, e que qualquer matriz vazia deve ter dimensão /0 * 0/.
--
-- __Sugestão:__ relembre a função 'length', referida anteriormente.
dimensaoMatriz :: Matriz a -> DimensaoMatriz
dimensaoMatriz [] = (0,0)
dimensaoMatriz a@(x:xs) | length x == 0 = (0,0)
                        | otherwise = (length a , length x) 

-- | Verifica se a posição pertence à matriz.
ePosicaoMatrizValida :: PosicaoMatriz -> Matriz a -> Bool 
ePosicaoMatrizValida (_,_) [] = False
ePosicaoMatrizValida (m,n) a@(x:xs) | eIndiceListaValido m a == True = eIndiceListaValido n x
                                    | otherwise = False

-- * Funções recursivas.

-- ** Funções sobre ângulos

-- | Normaliza um ângulo na gama [0..360).
--  Um ângulo pode ser usado para representar a rotação
--  que um objecto efectua. Normalizar um ângulo na gama [0..360)
--  consiste, intuitivamente, em extrair a orientação do
--  objecto que resulta da aplicação de uma rotação. Por exemplo, é verdade que:
--
-- prop> normalizaAngulo 360 = 0
-- prop> normalizaAngulo 390 = 30
-- prop> normalizaAngulo 720 = 0
-- prop> normalizaAngulo (-30) = 330

normalizaAngulo :: Angulo -> Angulo
normalizaAngulo a | 0 <= a && a < 360 = a
                  | a >= 360 = normalizaAngulo (a-360)
                  | a > (-360) && a < 0 = 360 + a
                  | a <= (-360) = normalizaAngulo (a + 360)
                  
-- ** Funções sobre listas.

-- | Devolve o elemento num dado índice de uma lista.
--
-- __Sugestão:__ Não use a função (!!) :: [a] -> Int -> a :-)
encontraIndiceLista :: Int -> [a] -> a
encontraIndiceLista 0 l = head l
encontraIndiceLista n (h:t) | n > 0 = encontraIndiceLista (n-1) t

-- | Modifica um elemento num dado índice.
--
-- __NB:__ Devolve a própria lista se o elemento não existir.
atualizaIndiceLista :: Int -> a -> [a] -> [a]
atualizaIndiceLista _ _ [] = []
atualizaIndiceLista 0 e (x:xs) = e:xs
atualizaIndiceLista i e (x:xs) = x : (atualizaIndiceLista (i-1) e xs)

-- ** Funções sobre matrizes.

-- | Devolve o elemento numa dada 'Posicao' de uma 'Matriz'.
encontraPosicaoMatriz :: PosicaoMatriz -> Matriz a -> a
encontraPosicaoMatriz (m,n) [] = error "nao tem posicao"
encontraPosicaoMatriz (m,n) (x:xs) | m > length (x:xs) || n > length x = error "posicao inexistente"
encontraPosicaoMatriz (m,n) a = encontraIndiceLista n (encontraIndiceLista m a) 

-- | Modifica um elemento numa dada 'Posicao'
--
-- __NB:__ Devolve a própria 'Matriz' se o elemento não existir.
atualizaPosicaoMatriz :: PosicaoMatriz -> a -> Matriz a -> Matriz a
atualizaPosicaoMatriz (_,_) x [] = [[]]
atualizaPosicaoMatriz  (m,n) e (x:xs) | m == 0 = (atualizaIndiceLista n e x):xs
                                      | otherwise = [x] ++ atualizaPosicaoMatriz ((m-1),n) e xs 