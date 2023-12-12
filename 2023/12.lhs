> module Main (main) where

> import Data.Bool (bool)
> import Data.List (tails)
> import qualified Data.IntMap as IM

> main :: IO ()
> main = do
>   input <- map parseLine . lines <$> getContents
>   putStr "A: " >> print (sum $ map (uncurry arrangements) input)
>   putStr "B: " >> print (sum $ map examine input)

> splitOn :: Eq a => a -> [a] -> [[a]]
> splitOn _ [] = []
> splitOn x xs = uncurry (:) ((splitOn x . drop 1) <$> break (== x) xs)

> parseLine :: String -> (String, [Int])
> parseLine = fmap (map read . splitOn ',' . drop 1) . break (== ' ')

> examine :: (String, [Int]) -> Int
> examine = uncurry arrangements . expand
>     where expand (s, ns) = ( s ++ '?':s ++ '?':s ++ '?':s ++ '?':s
>                            , ns ++ ns ++ ns ++ ns ++ ns
>                            )

> arrangements :: String -> [Int] -> Int
> arrangements s ns = m IM.! i s ns
>     where f t  [] = if any (== '#') t then 0 else 1
>           f "" _  = 0
>           f t@(x:xs) (n:nn)
>               = bool 0 (m IM.! i (dropWhile (== '.') xs) (n:nn))
>                     (x `elem` ".?")
>                 + bool 0 (m IM.! i (drop n xs) nn) (has n t)
>           ln = length ns + 1
>           i x y = length x * ln + length y
>           m = IM.fromList
>               [(i x y, f x y) | x <- tails s, y <- tails ns]

> has :: Int -> String -> Bool
> has n [] = n == 0
> has 0 (x:_) = x `elem` ".?"
> has n (x:xs) = x `elem` "#?" && has (n-1) xs
