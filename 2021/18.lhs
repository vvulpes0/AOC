> module Main where

> import Data.Bifunctor (first)
> import Data.Char (isDigit,isSpace)

> main = interact (f . readFNs)
>     where f x = unlines [show (doa x) ++ "\t" ++ show (dob x)]

> doa, dob :: [FN] -> Int
> doa = magnitude 4 [] . foldl1 add
> dob xs = maximum $ map (magnitude 4 []) [add x y | x <- xs, y <- xs]

> type FN = [(Int,Int)]

> readFNs :: String -> [FN]
> readFNs "" = []
> readFNs xs = uncurry (:) ((readFNs . f) <$> readFN (-1) xs)
>     where f = dropWhile isSpace

> readFN :: Int -> String -> (FN,String)
> readFN _ [] = ([],[])
> readFN d (x:xs)
>     | x == '[' = readFN (d+1) xs
>     | x == ']' = if d == 0 then ([],xs) else readFN (d-1) xs
>     | isDigit x = f $ span isDigit (x:xs)
>     | otherwise = readFN d xs
>     where f (n,s) = first ((read n, d) :) $ readFN d s

> add :: FN -> FN -> FN
> add a b = explode [] $ map (fmap succ) a ++ map (fmap succ) b

> explode :: FN -> FN -> FN
> explode p [] = split [] $ reverse p
> explode p (x:s)
>     | snd x < 4 = explode (x:p) s
>     | otherwise = explode (f (x:p)) ((0,pred $ snd x) : f s)
>     where f (y:z:ys) = (fst y + fst z, snd z) : ys
>           f ys = drop 1 ys

> split :: FN -> FN -> FN
> split p [] = reverse p
> split p (x:s)
>     | fst x > 9 = explode [] (reverse p ++ x' ++ s)
>     | otherwise = split (x:p) s
>     where m = div (fst x) 2
>           x' = map (flip (,) (succ $ snd x)) [m, fst x - m]

> magnitude :: Int -> FN -> FN -> Int
> magnitude d p (x:y:xs)
>     | snd x == d = magnitude d ((m, pred d) : p) xs
>     | otherwise  = magnitude d (x:p) (y:xs)
>     where m = 3 * fst x + 2 * fst y
> magnitude d [] (x:[]) = fst x
> magnitude d p xs = magnitude (pred d) [] (reverse p ++ xs)
