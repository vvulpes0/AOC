> module Main (main) where
> import Data.List (transpose, partition)
> import Data.Map (Map)
> import qualified Data.Map.Strict as Map

> main :: IO ()
> main = do
>   ls <- transpose . lines <$> getContents
>   putStr "A: " >> print (sum $ map (load . roll 'O') ls)
>   let (s,e,xs) = findRep Map.empty 0 ls
>       n = (1000000000 - s) `mod` (e - s)
>   putStr "B: " >> print (sum . map load $ apply n spin xs)

> load :: String -> Int
> load s = sum . map fst . filter ((== 'O') . snd) $ zip [n,n-1 ..] s
>     where n = length s

> roll :: Char -> String -> String
> roll c [] = []
> roll c xs = pre' ++ roll c post
>     where (pre, post) = breakAfter (== '#') xs
>           pre' = uncurry (++) $ partition (== c) pre

> spin :: [String] -> [String]
> spin = transpose . map (roll '.')   -- east
>        . transpose . map (roll '.') -- south
>        . transpose . map (roll 'O') -- west
>        . transpose . map (roll 'O') -- north

> findRep :: Map [Int] Int -> Int -> [String] -> (Int,Int,[String])
> findRep m d xs
>     = maybe ((findRep m' $! d+1) (spin xs)) f (m Map.!? h)
>     where m' = Map.insert h d m
>           f x = (x, d, xs)
>           h = compact $ concat xs

> compact :: String -> [Int]
> compact [] = []
> compact xs = f . fmap (span (== 'O')) $ break (== 'O') xs
>     where f (a, (b, c)) = length a : length b : compact c

> apply :: Int -> (a -> a) -> a -> a
> apply 0 _ = id
> apply n f = f . (apply $! n-1) f

> breakAfter :: (a -> Bool) -> [a] -> ([a],[a])
> breakAfter f [] = ([],[])
> breakAfter f (x:xs)
>     | f x = ([x], xs)
>     | otherwise = let (a,b) = breakAfter f xs in (x:a, b)
