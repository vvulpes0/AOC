> module Main (main) where

> import Data.Bool (bool)
> import Data.List (tails)
> import qualified Data.IntMap as IM

> main :: IO ()
> main = do
>   input <- map parseLine . lines <$> getContents
>   let (a,b) = unzip $ map (uncurry examine) input
>   putStr "A: " >> print (sum a)
>   putStr "B: " >> print (sum b)

> parseLine :: String -> (String, [Int])
> parseLine = fmap (read . ('[':) . (++"]")) . break (== ' ')

> examine :: String -> [Int] -> (Int, Int)
> examine s ns = arrangements (length s) (length ns)
>                (s ++ '?':s ++ '?':s ++ '?':s ++ '?':s)
>                (ns ++ ns ++ ns ++ ns ++ ns)

> arrangements :: Int -> Int -> String -> [Int] -> (Int, Int)
> arrangements ols oln s ns
>     = let big  = m IM.! i 0 0
>           smol = m IM.! i (ls - ols) (ln - oln - 1)
>       in smol `seq` big `seq` (smol, big)
>     where f _ _ t  [] = if any (== '#') t then 0 else 1
>           f _ _ "" _  = 0
>           f a b t@(x:_) (n:_)
>               = bool 0 (m IM.! i a b) (x `elem` ".?")
>                 + bool 0 (m IM.! i (min ls (a+n)) (b+1)) (has n t)
>           ls = length s
>           ln = length ns + 1
>           i x y = x*ln + y
>           m = IM.fromList
>               [ (i a b, f (a+1) b x y)
>               | (a, x) <- zip [0..] $ tails s
>               , (b, y) <- zip [0..] $ tails ns]

> has :: Int -> String -> Bool
> has n [] = n == 0
> has 0 (x:_) = x `elem` ".?"
> has n (x:xs) = x `elem` "#?" && has (n-1) xs
