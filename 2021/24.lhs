> module Main (main) where

> import Data.List (intercalate,sort)

> main = interact (f . pairs . getRepr . lines)
>     where f x = unlines . pure . intercalate "\t"
>                 $ map (show . construct) [maximize x, minimize x]

> getRepr :: [String] -> ([Integer],[Integer],[Integer])
> getRepr [] = ([],[],[])
> getRepr xs = uncurry g $ getRepr <$> ((f d, f a, f s), xs''')
>     where (d:a:[],xs') = splitAt 2 $ drop 4 xs
>           (s:[],xs'') = splitAt 1 $ drop 9 xs'
>           f = (read :: String -> Integer) . last . words
>           g (m,n,o) (x,y,z) = (m:x, n:y, o:z)
>           xs''' = drop 2 xs''

> pairs :: ([Integer],[Integer],[Integer]) -> [(Integer,Integer,Integer)]
> pairs = pairs' 0 []
> pairs' :: Integer -> [(Integer,Integer)]
>        -> ([Integer],[Integer],[Integer])
>        -> [(Integer,Integer,Integer)]
> pairs' n s ((d:ds),(a:as),(b:bs))
>     | d == 1    = pairs' (n+1) ((n,b):s) (ds,as,bs)
>     | otherwise = case s of
>                     ((m,t):s') -> (n,m,t+a) : pairs' (n+1) s' (ds,as,bs)
>                     _ -> error "empty stack"
> pairs' _ _ _ = []

> construct :: [(Integer,Integer)] -> Integer
> construct = foldl g 0 . map snd . sort
>     where g a n = 10 * a + n

> maximize,minimize :: [(Integer,Integer,Integer)] -> [(Integer,Integer)]
> maximize [] = []
> maximize ((b,a,d):xs)
>     | d < 0 = (a,9) : (b,9+d) : maximize xs
>     | otherwise = (a,9-d) : (b,9) : maximize xs
> minimize [] = []
> minimize ((b,a,d):xs)
>     | d < 0 = (a,1-d) : (b,1) : minimize xs
>     | otherwise = (a,1) : (b,1+d) : minimize xs
