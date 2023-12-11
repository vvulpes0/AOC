> import Data.List (transpose, scanl')

> main = do
>   ls <- lines <$> getContents
>   putStr "A: " >> print (dists 2 ls)
>   putStr "B: " >> print (dists 1000000 ls)

> dists :: Int -> [String] -> Int
> dists w ls = sum . map (uncurry manhattan) . pairs
>              . uncurry (galaxies ls) $ weight w ls

> manhattan :: Num a => (a,a) -> (a,a) -> a
> manhattan (a,b) (c,d) = abs (c-a) + abs (d-b)

> pairs :: [a] -> [(a,a)]
> pairs (x:xs) = map ((,) x) xs ++ pairs xs
> pairs _ = []

> weight :: Int -> [String] -> ([Int],[Int])
> weight r xs = (rows, cols)
>     where rows = map f xs
>           cols = map f (transpose xs)
>           f line = if all (== '.') line then r else 1

> galaxies :: [String] -> [Int] -> [Int] -> [(Int,Int)]
> galaxies xs rows cols
>     = concat . zipWith f (scanl' (+) 0 rows) $ map g xs
>     where f i row = map ((,) i) row
>           g s = map fst . filter ((== '#') . snd)
>                 $ zip (scanl' (+) 0 cols) s
