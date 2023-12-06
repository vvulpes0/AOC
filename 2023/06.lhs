> main :: IO ()
> main = do
>   s <- getContents
>   putStr "A: " >> print (partA s)
>   putStr "B: " >> print (partB s)

> partA :: String -> Integer
> partA s = f . map (map read . drop 1 . words) $ lines s
>     where f (x:y:_) = product . map beat $ zip x y

> partB :: String -> Integer
> partB s = f . map (read . concat . drop 1 . words) $ lines s
>     where f (x:y:_) = beat (x,y)

> beat :: (Integer,Integer) -> Integer
> beat (t,d) = high - low + 1
>     where surd = (sqrt . fromIntegral) (t^2 - 4*d)
>           low = (ceiling ((fromIntegral t - surd) / 2))
>           high = (floor ((fromIntegral t + surd) / 2))
