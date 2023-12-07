> import Data.List (sortOn,nub)

> main :: IO ()
> main = do
>   hands <- parse <$> getContents
>   putStr "A: " >> print (value "23456789TJQKA" id hands)
>   putStr "B: " >> print (value "J23456789TQKA" (filter (/= 'J')) hands)

> parse :: String -> [(String,Integer)]
> parse = map ((\ ~(x:y:[]) -> (x, read y)) . words) . lines

> value :: String -> (String -> String) -> [(String,Integer)] -> Integer
> value v f = sum . zipWith (\a b -> a * snd b) [1..]
>             . sortOn (\(a,b) -> (classify $ f a, map (indexOf v) a, b))
>     where indexOf (p:ps) x = if x == p then 0 else 1 + indexOf ps x
>           indexOf [] _ = 0

> data Hand = High|One|Two|Three|Full|Four|Five deriving (Eq,Ord)
> classify :: String -> Hand
> classify hand = [Five, Five, ff, tt, One, High] !! length (nub hand)
>     where ff = if length hand - 1 `elem` c then Four else Full
>           tt = if length hand < 5 || 3 `elem` c then Three else Two
>           c  = map (\x -> length $ filter (== x) hand) hand
