{- Cyber-Physical Computation 2022/2023 - Recalling Haskell.
 - Why Haskell? We will use Haskell in this course to implement 
 - programming languages and respective semantics.
 - Goal: Solve the exercises listed below.
-}

module LectureCPC where

-- Basic functions and conditionals -- 

-- Implement the function that returns 
-- the maximum of two integers.
max' :: (Int,Int) -> Int
max' (x,y) = if x >= y then x else y 

-- Implement the function that returns 
-- the maximum of three integers.
max3 :: (Int,(Int,Int)) -> Int
max3 (x, t)= max' (x,max' t)

-- Implement the function that scales 
-- a 2-dimensional real vector by a 
-- real number.
scaleV :: (Double, (Double,Double)) -> (Double, Double)
scaleV (scalar, (x,y)) = (scalar * x , scalar * y)

-- Implement the function that adds up
-- two 2-dimensional real vectors
addV :: ((Double,Double),(Double,Double)) -> (Double, Double)
addV ((x1,y1),(x2,y2)) = (x1 + x2 , y1 +y2)

-- Type Synonims
type TMatrix = ((Double,Double),(Double,Double))
type TVector = (Double,Double)

multM :: (TMatrix,TVector) -> TVector
multM = undefined
--------------------------------------

-- Recursion ------------------------- 

-- Implement the function that calculates
-- the factorial of an integer
fact :: Int -> Int
fact 0 = 1
fact n = n * fact (n-1)

-- Implement the function that return the length
-- of a given list
len :: [a] -> Int
len [] = 0
len (_:t) = 1 + len t

-- Implement the function that removes all
-- the even numbers from a given list
odds :: [Int] -> [Int]
odds [] = []
odds (h : t) | h % 2 == 0 = [h] ++ odds t  
             | otherwise = odds t

-- Implement Caesar Cypher with shift=3
-- https://en.wikipedia.org/wiki/Caesar_cipher
-- Suggestion: add "import Data.Char", and use
-- the functions "chr" and "ord"
ecode :: String -> String
ecode = undefined

dcode :: String -> String
dcode = undefined

-- Implement the QuickSort algorithm
qSort :: [Int] -> [Int]
qSort [] = [] 
qSort (h:t) = ( qSort (filter (h >) t )) ++ [h] 
        ++ (qSort ( filter (h <=) t ) )

-- Implement the solution to the Hanoi problem
hanoi :: Int -> a -> a -> a -> [(a,a)]
hanoi 0 a b c = []
hanoi n a b c = ( hanoi (n-1) a c b ) ++ [(a,c)] ++
        ( hanoi (n-1) b a c )
-----------------------------------------

-- Datatypes ----------------------------

-- The datatype of leaf trees
data LTree a = Leaf a | Fork (LTree a, LTree a) deriving Show

-- Implement the function that increments all values
-- in a given leaf tree
incr :: LTree Int -> LTree Int
incr (Leaf n) = Leaf n+1 
incr Fork (left,right) = Fork (incr left, incr right)

-- Implement the function that counts the number of leafs
-- in a leaf tree 
count :: LTree Int -> Int
count Leaf _ = 1
count Fork (left,right) = count left + count right

-- The datatype of binary trees
data BTree a = Empty | Node a (BTree a, BTree a) deriving Show

-- Implement the function that increments all values
-- in a given binary tree
bincr :: BTree Int -> BTree Int
bincr Empty = Empty
bincr Node n (left,right) = Node n+1 (bincr left, bincr right)

-- Implement the function that counts the number of leafs
-- in a leaf tree 
bcount :: BTree Int -> Int
bcount Node _ (Empty,Empty) = 1
bcount Node _ (left,right) = bcount left + bcount right

-- The datatype of "full" trees
data FTree a b = Tip a | Join b (FTree a b, FTree a b) deriving Show

-- Implement the function that sends a full tree into a leaf tree
fTree2LTree :: FTree a b -> LTree a
fTree2LTree Tip a = Leaf a
fTree2LTree Join _ (left, right) = Fork (fTree2LTree left, fTree2LTree right)

-- Implement the function that sends a full tree into a binary tree
fTree2BTree :: FTree a b -> BTree b 
fTree2BTree Tip _ = Empty
fTree2BTree Join b (left,right) = Node b (fTree2BTree left, fTree2BTree right) 

-- Implement the semantics of the following very simple programming 
-- language of Arithmetic Expressions
data Vars = X1 | X2
data Ops = Sum | Mult
type AExp = FTree (Either Vars Int) Ops
type AState = Vars -> Int

semA :: (AExp, AState) -> Int 
semA ((Tip (Left var)), state) = state var
semA ((Tip (Right int)), _) = int 
semA ((Join Sum (l,r)), state) = semA (l,state) + semA (r,state) 
semA ((Join Mult (l,r)), state) = semA (l,state) * semA (r,state)