> module Main (main) where
> import Data.Bool (bool)
> import Data.List (scanl', tails, transpose)

> main = do
>   f <- dists . lines <$> getContents
>   putStr "A: " >> print (f 2)
>   putStr "B: " >> print (f 1000000)

> dists :: [String] -> Int -> Int
> dists ls = sum . map (uncurry manhattan) . pairs
>            . uncurry (galaxies ls) . weight ls

> manhattan :: Num a => (a,a) -> (a,a) -> a
> manhattan (a,b) (c,d) = abs (c-a) + abs (d-b)

> pairs :: [a] -> [(a,a)]
> pairs xs = concat $ zipWith (map . (,)) xs (drop 1 $ tails xs)

> weight :: [String] -> Int -> ([Int],[Int])
> weight xs r = (f xs, f $ transpose xs)
>     where f = scanl' (+) 0 . map (bool 1 r . all (== '.'))

> galaxies :: [String] -> [Int] -> [Int] -> [(Int,Int)]
> galaxies xs rows cols = concat . zipWith (map . (,)) rows $ map g xs
>     where g = map fst . filter ((== '#') . snd) . zip cols
