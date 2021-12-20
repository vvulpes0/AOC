> module Main where

> import Data.Bifunctor (first, bimap)
> import Data.List (intercalate)
> import Data.Set (Set)
> import qualified Data.Set as Set

> main = interact (f . ticks)
>     where f xs = unlines . pure . intercalate "\t"
>                  $ map (show . countLit . (xs!!)) [2,50]

> type Range a = (a,a)

> type Board = (Range Int, Range Int, Bool, Set (Int,Int))
> def :: Board -> Bool
> def (_,_,b,_) = b

> ticks s = iterate (tick e) b
>     where (e, b) = getRepr s

> countLit :: Board -> Int
> countLit = Set.size <$> (\(_,_,_,p) -> p)

> getRepr :: String -> ([Bool], Board)
> getRepr = bimap (f . concat) (g . dropWhile null) . splitAt 1 . lines
>     where f = map (== '#')
>           g ls = ( (0, length ls - 1)
>                  , (0, length (concat $ take 1 ls) - 1)
>                  , False
>                  , Set.fromAscList
>                  . concatMap (\(a,xs) -> map ((,) a) xs)
>                  . filter (not . null . snd)
>                  . enumerate
>                  $ map (map fst . filter snd . enumerate . f) ls
>                  )
>           enumerate = zip [0..]

> tick :: [Bool] -> Board -> Board
> tick e brd@(xr, yr, df, p)
>          = ((a-1,b+1),(c-1,d+1),d',p')
>     where ((a,b),(c,d)) = getRange $ Set.toList p
>           rs = [a-1 .. b+1]
>           cs = [c-1 .. d+1]
>           p' = Set.fromAscList $ filter ((e!!) . uncurry (window brd))
>                [(r,x) | r <- rs, x <- cs]
>           d' = (e!!) . sum $ zipWith (flip ($)) (map (2^) [0..])
>                (replicate 9 (if df then id else const 0))


> window :: Board -> Int -> Int -> Int
> window b r c = unbits $ concatMap (\x -> map (m . (,) x) cs) rs
>     where rs = [r+1,r,r-1]
>           cs = [c+1,c,c-1]
>           (rx,ry,_,p) = b
>           f x i = if i then x else (if def b then 1 else 0)
>           m (x,y) = Set.member (x,y) p
>                     || (def b && not (inRange x rx))
>                     || (def b && not (inRange y ry))

> unbits :: [Bool] -> Int
> unbits = sum . zipWith (flip ($)) (map (2^) [0..])
>          . map (\x -> if x then id else const 0)

> inRange :: Ord a => a -> Range a -> Bool
> inRange a (m,n) = m <= a && a <= n

> getRange :: Ord a => [(a,a)] -> (Range a, Range a)
> getRange = bimap (minmax . map fst) (minmax . map snd) . (>>= id) (,)

> minmax :: Ord a => [a] -> Range a
> minmax (x:xs)
>     | null xs = (x, x)
>     | otherwise = bimap (min x) (max x) $ minmax xs
> minmax [] = error "empty list"
