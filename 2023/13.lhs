> import Data.Bits
> import Data.List (transpose)
> type Zipper a = ([a],[a])

> main :: IO ()
> main = do
>   patterns <- chop (fmap (drop 1) . break null) . lines <$> getContents
>   putStr "A: " >> print (sum $ map (getP findMirror) patterns)
>   putStr "B: " >> print (sum $ map (getP findSmudge) patterns)

> chop :: ([a] -> (b,[a])) -> [a] -> [b]
> chop f xs = if null xs then [] else uncurry (:) ((chop f) <$> f xs)

> getP :: ([Int] -> Maybe Int) -> [String] -> Int
> getP go ls = maybe (maybe 0 id . f $ transpose ls) (*100) (f ls)
>      where f = go . map mkNum

> mkNum :: String -> Int
> mkNum xs = f xs 0
>     where f [] d = d
>           f ('.':xs) d = f xs $! 2*d
>           f ('#':xs) d = f xs $! 2*d + 1

> findMirror :: [Int] -> Maybe Int
> findMirror xs = f (splitAt 1 xs) 1
>     where f (a,[]) _ = Nothing
>           f (a,b:bs) n
>               = if and $ zipWith (==) a (b:bs)
>                 then Just n
>                 else f (b:a,bs) $! n+1

> findSmudge :: [Int] -> Maybe Int
> findSmudge xs = f (splitAt 1 xs) 1
>     where f (a,[]) _ = Nothing
>           f (a,b:bs) n
>               = if g a (b:bs)
>                 then Just n
>                 else f (b:a,bs) $! n+1
>           g xs ys
>               = case filter (uncurry (/=)) $ zip xs ys of
>                   [(x,y)] -> let o = xor x y in (o .&. (o-1)) == 0
>                   _       -> False
