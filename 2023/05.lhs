> import Data.List (foldl')
> type Trans = [(Int,Int,Int)]
> main :: IO ()
> main = do
>   dat <- parse <$> getContents
>   putStr "A: " >> print (partA dat)
>   putStr "B: " >> print (partB dat)

> chop :: ([a] -> (b,[a])) -> [a] -> [b]
> chop f xs = if null xs then [] else uncurry (:) ((chop f) <$> f xs)

> parse :: String -> ([Trans], [Int])
> parse = f . lines
>     where f (x:xs) = (chop readMap xs, g x)
>           f _ = error "empty"
>           g = map read . drop 1 . words
> readMap :: [String] -> (Trans, [String])
> readMap = (\(xs,r) -> (map f xs, r)) . break null . drop 2
>     where f x = case map read (words x) of
>                   (a:b:c:_) -> (a,b,c)
>                   _ -> error "invalid input"

> handle :: (Trans -> a -> [a]) -> [Trans] -> [a] -> [a]
> handle f ts xs = foldl' (\b t -> concatMap (f t) b) xs ts

> partA :: ([Trans], [Int]) -> Int
> partA = minimum . uncurry (handle shift)
>     where shift ((a,b,c):ts) x
>               | x >= b && x < b+c = [x + a - b]
>               | otherwise = shift ts x
>           shift _ x = [x]

> partB :: ([Trans], [Int]) -> Int
> partB = minimum . map fst . uncurry (handle splitMap) . fmap pairs
>     where pairs (x:y:xs) = (x,y) : pairs xs
>           pairs _ = []
> splitMap :: Trans -> (Int,Int) -> [(Int,Int)]
> splitMap ((a,b,c):ms) (seed,len)
>     = maybe id ((:) . f) at $ concatMap (splitMap ms) rest
>     where (pre,at,post) = rangeInt (seed,len) (b,c)
>           rest = (maybe id (:) pre) (maybe [] pure post)
>           f (x,y) = (x + a - b, y)
> splitMap _ p = [p]
> rangeInt :: (Int,Int) -> (Int,Int)
>          -> (Maybe (Int,Int), Maybe (Int,Int), Maybe (Int,Int))
> rangeInt (a,b) (c,d)
>     = ( if a >= c then Nothing else Just (a, min (a+b) c - a)
>       , if a >= c+d || a+b <= c then Nothing
>         else let s = max a c in Just (s, min (a+b) (c+d) - s)
>       , if a + b <= c + d then Nothing
>         else let s = max a (c+d) in Just (s, a + b - s)
>       )
