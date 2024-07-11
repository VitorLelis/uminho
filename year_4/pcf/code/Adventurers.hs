{-# LANGUAGE FlexibleInstances #-}
module Adventurers where

import DurationMonad

-- The list of adventurers
data Adventurer = P1 | P2 | P5 | P10 deriving (Show,Eq)
-- Adventurers + the lantern
type Objects = Either Adventurer () 

-- The time that each adventurer needs to cross the bridge
getTimeAdv :: Adventurer -> Int
getTimeAdv P1 = 1
getTimeAdv P2 = 2
getTimeAdv P5 = 5
getTimeAdv P10 = 10

{-- The state of the game, i.e. the current position of each adventurer
+ the lantern. The function (const False) represents the initial state of the
game, with all adventurers and the lantern on the left side of the bridge.
Similarly, the function (const True) represents the end state of the game, with
all adventurers and the lantern on the right side of the bridge.  
--}
type State = Objects -> Bool

instance Show State where
  show s = (show . (fmap show)) [s (Left P1),
                                 s (Left P2),
                                 s (Left P5),
                                 s (Left P10),
                                 s (Right ())]

instance Eq State where
  (==) s1 s2 = and [s1 (Left P1) == s2 (Left P1),
                    s1 (Left P2) == s2 (Left P2),
                    s1 (Left P5) == s2 (Left P5),
                    s1 (Left P10) == s2 (Left P10),
                    s1 (Right ()) == s2 (Right ())]


-- The initial state of the game
gInit :: State
gInit = const False

-- Final state of the game
gFinal :: State
gFinal = const True

-- Changes the state of the game for a given object
changeState :: Objects -> State -> State
changeState a s = let v = s a in (\x -> if x == a then not v else s x)

-- Changes the state of the game for a list of objects 
mChangeState :: [Objects] -> State -> State
mChangeState os s = foldr changeState s os
                               
{-- For a given state of the game, the function presents all the
possible moves that the adventurers can make.  --}
allValidPlays :: State -> ListDur State
allValidPlays s = manyChoice $ map (makeMove s) (validPairs s)

-- Generates valid pairs of adventurers based on the side of the lantern
validPairs :: State -> [(Adventurer, Adventurer)]
validPairs s | s (Right ()) = map (\a -> (a,a)) advsOnLanternSide -- One should return
             | otherwise    = makePairs advsOnLanternSide -- Two can cross
  where
    advsOnLanternSide = filter (\a -> s (Left a) == s (Right ())) [P1, P2, P5, P10]

-- Creates a move based on a pair of adventurers and the current state
makeMove :: State -> (Adventurer, Adventurer) -> ListDur State
makeMove s (a1, a2) = LD [Duration (moveTime, newState)]
  where
    moveTime = max (getTimeAdv a1) (getTimeAdv a2)
    newState = stateChange s (a1,a2)

-- Change the state dependong on the side of the Lantern
stateChange :: State -> (Adventurer, Adventurer) -> State
stateChange s (a1,a2) | s (Right ()) = mChangeState [Left a1, Right ()] s -- One return
                      | otherwise    = mChangeState [Left a1, Left a2, Right ()] s -- Two cross

{-- For a given number n and initial state, the function calculates
all possible n-sequences of moves that the adventures can make --}
exec :: Int -> State -> ListDur State
exec 0 s = return s
exec n s = do
  s' <- allValidPlays s
  exec (n-1) s'

{-- Is it possible for all adventurers to be on the other side
in <=17 min and not exceeding 5 moves ? --}
leq17 :: Bool
leq17 = any (\(Duration (t, s)) -> t <= 17 && all (\obj -> s obj) allObjs) validPlays
  where
    allObjs = [Right (), Left P1, Left P2, Left P5, Left P10]
    validPlays = remLD $ exec 5 gInit

{-- Is it possible for all adventurers to be on the other side
in < 17 min ? --}
l17 :: Bool
l17 = any (\(Duration (t, s)) -> t < 17 && all (\obj -> s obj) allObjs) validPlays
  where
    allObjs = [Right (), Left P1, Left P2, Left P5, Left P10]
    validPlays = remLD $ exec 5 gInit

--------------------------------------------------------------------------
{-- Implementation of the monad used for the problem of the adventurers.
Recall the Knight's quest --}

data ListDur a = LD [Duration a] deriving Show

remLD :: ListDur a -> [Duration a]
remLD (LD x) = x

instance Functor ListDur where
   fmap f = let f' = (fmap f) in
     LD . (map f') . remLD

instance Applicative ListDur where
   pure x = LD [Duration (0,x)]
   l1 <*> l2 = LD $ do x <- remLD l1
                       y <- remLD l2
                       return $ do f <- x; a <- y; return (f a)

instance Monad ListDur where
   return = pure
   l >>= k = LD $ do x <- remLD l
                     g x where
                       g(Duration (i,x)) = let u = (remLD (k x))
                          in map (\(Duration (i',x)) -> Duration (i + i', x)) u

manyChoice :: [ListDur a] -> ListDur a
manyChoice = LD . concat . (map remLD)

--------- List Utils ----------

-- Returns all elements as lists --
toLists :: [a] -> [[a]]
toLists [] = [[]]
toLists as = map (\a -> [a]) as

-- Returns list of pairs as list of lists --
rmPairs :: [(a,a)] -> [[a]]
rmPairs [] = [[]]
rmPairs ((a1,a2) : ps) = [a1,a2] : rmPairs ps

-- Returns all possible combinations of pairs in a list of elements, except pairs where the elements are equal --
makePairs :: (Eq a) => [a] -> [(a,a)]
makePairs as = normalize $ do a1 <- as; a2 <- as; [(a1,a2)]

-- Keeps only the pairs where elements are different --
normalize :: (Eq a) => [(a,a)] -> [(a,a)]
normalize l = removeSw $ filter p1 l where
  p1 (x,y) = if x /= y then True else False

-- Removes duplicate pairs with switched order of appearance --
removeSw :: (Eq a) => [(a,a)] -> [(a,a)]
removeSw [] = []
removeSw ((a,b):xs) = if elem (b,a) xs then removeSw xs else (a,b):(removeSw xs)
