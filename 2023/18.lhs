> module Main (main) where
> type Pos = (Int, Int)

> main :: IO ()
> main = do
>   plan <- parse <$> getContents
>   putStr "A: " >> print (partA plan)
>   putStr "B: " >> print (partB plan)

> partA, partB :: [(Char,Int,String)] -> Int
> partA p = area $ dig (0,0) plan
>     where plan = map (\(a,b,_) -> (a,b)) p
> partB p = area $ dig (0,0) plan
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

> dig :: Pos -> [(Char,Int)] -> [Pos]
> dig _ [] = []
> dig (x,y) ((c,i):xs)
>     | c == 'R' = let x' = x + i in (x,y) : dig (x',y) xs
>     | c == 'U' = let y' = y - i in (x,y) : dig (x,y') xs
>     | c == 'L' = let x' = x - i in (x,y) : dig (x',y) xs
>     | c == 'D' = let y' = y + i in (x,y) : dig (x,y') xs
>     | otherwise = error "bad direction"

This combines the Shoelace Formula and Pick's Theorem

> area :: [Pos] -> Int
> area ps = shoelace + (perimeter ps `div` 2) + 1
>     where f _ [a,b,c] = snd b * (fst a - fst c)
>           f _ _ = error "impossible nontriad"
>           shoelace = flip div 2 . abs . sum . zipWith f ps
>                      . map (take 3) . iterate (drop 1) $ cycle ps
>           perimeter (x:y:xs) = abs (fst x-fst y) + abs (snd x-snd y)
>                                + perimeter (y:xs)
>           perimeter (y:[]) = fst y + snd y
>           perimeter _ = 0
