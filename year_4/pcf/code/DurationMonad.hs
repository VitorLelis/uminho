module DurationMonad where

-- Defining a monad (the duration monad) --

-- Data type representing a computation with a duration --
data Duration a = Duration (Int, a) deriving Show

-- Extracts the duration from a Duration computation --
getDuration :: Duration a -> Int
getDuration (Duration (d,x)) = d

-- Extracts the value from a Duration computation --
getValue :: Duration a -> a
getValue (Duration (d,x)) = x

-- Functor instance for Duration --
-- Applies a function to the value inside a Duration computation, leaving the duration unchanged
instance Functor Duration where
  fmap f (Duration (i,x)) = Duration (i,f x)

-- Applicative instance for Duration --
  -- Combines two Duration computations, summing their durations and applying the function from the first to the value of the second
instance Applicative Duration where
  pure x = (Duration (0,x))
  (Duration (i,f)) <*> (Duration (j, x)) = (Duration (i+j, f x))
  
-- Monad instance for Duration --
-- Sequentially composes two Duration computations, summing their durations and applying the second computation to the result of the first
instance Monad Duration where
    (Duration (i,x)) >>= k = Duration (i + (getDuration (k x)), getValue (k x))
    return x = (Duration (0,x))

-- Waits for 1 second in a Duration computation --
wait1 :: Duration a -> Duration a
wait1 (Duration (d,x)) = Duration (d+1,x)

-- Waits for specified number of seconds in a Duration computation
wait :: Int -> Duration a -> Duration a
wait i (Duration (d,x)) = Duration (i + d, x) 
