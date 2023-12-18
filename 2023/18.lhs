> module Main (main) where
> type Pos = (Int, Int)

> main :: IO ()
> main = do
>   plan <- parse <$> getContents
>   putStr "A: " >> print (partA plan)
>   putStr "B: " >> print (partB plan)

> partA, partB :: [(Char,Int,String)] -> Int
> partA p = uncurry area $ dig (0,0) plan
>     where plan = map (\(a,b,_) -> (a,b)) p
> partB p = uncurry area $ dig (0,0) plan
>     where plan = map (\(_,_,c) -> fixup c) p

> fixup :: String -> (Char, Int)
> fixup [a,b,c,d,e,f]
>     = ( "RDLU" !! (fromEnum f - fromEnum '0')
>       , read ("0x" ++ [a,b,c,d,e])
>       )
> fixup _ = error "bad colour"

> parse :: String -> [(Char,Int,String)]
> parse = map parseRow . lines
> parseRow :: String -> (Char,Int,String)
> parseRow = f . words
>     where f [[c],n,s] = (c, read n, take 6 . drop 2 $ s)
>           f _ = error "bad input"

> dig :: Pos -> [(Char,Int)] -> (Int, [Pos])
> dig _ [] = (0, [])
> dig (x,y) ((c,i):xs)
>     | c == 'R' = f (x+i, y)
>     | c == 'U' = f (x  , y-i)
>     | c == 'L' = f (x-i, y)
>     | c == 'D' = f (x  , y+i)
>     | otherwise = error "bad direction"
>     where f (a,b) = let (p,out) = dig (a,b) xs in (p+i, (a,b):out)

This combines the Shoelace Formula and Pick's Theorem

> area :: Int -> [Pos] -> Int
> area boundary ps = shoelace + (boundary `div` 2) + 1
>     where f _ [a,b,c] = snd b * (fst a - fst c)
>           f _ _ = error "impossible nontriad"
>           shoelace = flip div 2 . abs . sum . zipWith f ps
>                      . map (take 3) . iterate (drop 1) $ cycle ps
