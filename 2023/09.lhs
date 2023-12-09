> main :: IO ()
> main = do
>   p <- map (map read . words) . lines <$> getContents
>   putStr "A: " >> print (partA p)
>   putStr "B: " >> print (partB p)

> extrapolate :: [Int] -> Int
> extrapolate (x:xs)
>     | all (== x) xs = x
>     | otherwise
>         = let d = extrapolate $ zipWith (-) (x:xs) xs in x + d

> partA, partB :: [[Int]] -> Int
> partA = sum . map (extrapolate . reverse)
> partB = sum . map extrapolate
