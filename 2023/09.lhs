> main :: IO ()
> main = do
>   p <- map (map read . words) . lines <$> getContents
>   putStr "A: " >> print (partA p)
>   putStr "B: " >> print (partB p)

> extrapolateWith :: (Int->Int->Int) -> (Int->Int->Int) -> [Int] -> Int
> extrapolateWith f g (x:xs)
>     | all (== x) xs = x
>     | otherwise
>         = let d = extrapolateWith f g $ zipWith g (x:xs) xs in f x d

> partA, partB :: [[Int]] -> Int
> partA = sum . map (extrapolateWith (+) (-) . reverse)
> partB = sum . map (extrapolateWith (-) subtract)
