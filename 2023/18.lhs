> module Main (main) where
> type Pos = (Int, Int)

> main :: IO ()
> main = do
>   (planA,planB) <- unzip . parse <$> getContents
>   putStr "A: " >> print (solve planA)
>   putStr "B: " >> print (solve planB)

> solve :: [(Char,Int)] -> Int
> solve = uncurry area . dig (0,0)

> fixup :: String -> (Char, Int)
> fixup [a,b,c,d,e,f]
>     = ( "RDLU" !! (fromEnum f - fromEnum '0')
>       , read ("0x" ++ [a,b,c,d,e])
>       )
> fixup _ = error "bad colour"

> parse :: String -> [((Char,Int),(Char,Int))]
> parse = map (f . words) . lines
>     where f [[c],n,s] = ((c, read n), fixup . take 6 . drop 2 $ s)
>           f _ = error "bad input"

> dig :: Pos -> [(Char,Int)] -> (Int, [Pos])
> dig _ [] = (0, [])
> dig (x,y) ((c,i):xs)
>     | c == 'R' = f (x+i, y  )
>     | c == 'U' = f (x  , y-i)
>     | c == 'L' = f (x-i, y  )
>     | c == 'D' = f (x  , y+i)
>     | otherwise = error "bad direction"
>     where f (a,b) = let (p,out) = dig (a,b) xs in (p+i, (x,y):out)

This combines the Shoelace Formula and Pick's Theorem

> area :: Int -> [Pos] -> Int
> area boundary ps = shoelace + (boundary `div` 2) + 1
>     where f _ (a,b,c) = snd b * (fst a - fst c)
>           triads = let c = cycle ps in zip3 c (drop 1 c) (drop 2 c)
>           shoelace = flip div 2 . abs . sum $ zipWith f ps triads
