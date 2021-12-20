> module Main where

> import Data.Bifunctor (first, bimap)
> import Data.List (intercalate)
> import Data.IntMap (IntMap)
> import Data.IntSet (IntSet)
> import qualified Data.IntMap as IntMap
> import qualified Data.IntSet as IntSet

> main = interact (f . ticks)
>     where f xs = unlines . pure . intercalate "\t"
>                  $ map (show . countLit . (xs!!)) [2,50]

> type Range a = (a,a)

> type Board = (Range Int, Range Int, Bool, [(Int,IntSet)])
> rr,cr :: Board -> Range Int
> rr (r,_,_,_) = r
> cr (_,c,_,_) = c
> def :: Board -> Bool
> def (_,_,b,_) = b
> points :: Board -> [(Int,IntSet)]
> points (_,_,_,p) = p

> ticks s = iterate (tick e) b
>     where (e, b) = getRepr s

> countLit :: Board -> Int
> countLit = sum . map (IntSet.size . snd) . points

> getRepr :: String -> ([Bool], Board)
> getRepr = bimap (f . concat) (g . dropWhile null) . splitAt 1 . lines
>     where f = map (== '#')
>           g ls = ( (0, length ls - 1)
>                  , (0, length (concat $ take 1 ls) - 1)
>                  , False
>                  , enumerate
>                  $ map ( IntSet.fromAscList . map fst
>                        . filter snd . enumerate . f) ls
>                  )
>           enumerate = zip [0..]

> tick :: [Bool] -> Board -> Board
> tick e b = tick' (subtract 1 . fst $ rr b) e b

> tick' :: Int -> [Bool] -> Board -> Board
> tick' r e b
>     | r > r2 + 1 = (expand $ rr b,expand $ cr b,d',[])
>     | otherwise  = f (r,ps') . tick' (r + 1) e
>                   $ (rr b, cr b, def b, dropWhile ((< r) . fst) ps)
>     where (r1,r2) = rr b
>           f x (a, b, c, d) = (a, b, c, x:d)
>           ps = points b
>           cs = uncurry enumFromTo . expand $ cr b
>           expand (a,b) = (a - 1, b + 1)
>           d' = (if def b then last else head) e
>           rm = IntMap.fromAscList $ takeWhile ((<= r + 1) . fst) ps
>           ps' = IntSet.fromAscList
>                 $ filter ((e!!) . window (rr b) (cr b) (def b) rm r) cs

> window :: Range Int -> Range Int -> Bool -> IntMap IntSet
>        -> Int -> Int -> Int
> window rr cr d b r c = unbits $ concatMap (\x -> map (m . (,) x) cs) rs
>     where rs = [r+1,r,r-1]
>           cs = [c+1,c,c-1]
>           f x i = if i then x else unbits [d]
>           m (y,x) = maybe False (IntSet.member x) (IntMap.lookup y b)
>                     || (d && not (inRange x cr))
>                     || (d && not (inRange y rr))

> unbits :: [Bool] -> Int
> unbits = sum . zipWith (flip ($)) (map (2^) [0..])
>          . map (\x -> if x then id else const 0)

> inRange :: Ord a => a -> Range a -> Bool
> inRange a (m,n) = m <= a && a <= n
