> module Main (main) where
> import Data.IntMap.Strict (IntMap)
> import Data.IntSet (IntSet)
> import qualified Data.IntMap.Strict as IM
> import qualified Data.IntSet as IS

> main :: IO ()
> main = do
>   source <- lines <$> getContents
>   let bound = length source -- assume square
>   putStr "A: " >> print (partA bound $ mkmap source)
>   putStr "B: " >> print (partB bound $ mkmap source)

> partA :: Int -> IntMap Char -> Int
> partA bound m
>     = IM.size . IM.filter id $ bfsDepth bound plots 64 IM.empty start
>     where plots = IM.keysSet $ IM.filter (/= '#') m
>           start = IM.keysSet $ IM.filter (== 'S') m

> partB :: Int -> IntMap Char -> Int
> partB bound m
>     = full_odd*n_odd + full_even*n_even
>       + efill (f c 0) (bound-1) -- east corner
>       + efill (f (bound-1) c) (bound-1) -- north corner
>       + efill (f c (bound-1)) (bound-1) -- west corner
>       + efill (f 0 c) (bound-1) -- south corner
>       + ((r_full+1) -- small unfulls
>         *(efill (f (bound-1) 0) (bound`div`2 - 1)
>          + efill (f (bound-1) (bound-1)) (bound`div`2 - 1)
>          + efill (f 0 0) (bound`div`2 - 1)
>          + efill (f 0 (bound-1)) (bound`div`2 - 1)
>          ))
>       + (r_full -- large unfulls
>         *(efill (f (bound-1) 0) (3*bound`div`2 - 1)
>          + efill (f (bound-1) (bound-1)) (3*bound`div`2 - 1)
>          + efill (f 0 0) (3*bound`div`2 - 1)
>          + efill (f 0 (bound-1)) (3*bound`div`2 - 1)
>          ))
>     where plots = IM.keysSet $ IM.filter (/= '#') m
>           f y x = y*bound + x
>           c = bound `div` 2
>           start = f c c -- assume central
>           n = 26501365
>           r_full = n `div` bound - 1
>           full_odd  = (>>= id) (*) (r_full `div` 2 * 2 + 1)
>           full_even = (>>= id) (*) ((r_full + 1) `div` 2 * 2)
>           fill p x = bfsDepth bound plots x IM.empty (IS.singleton p)
>           efill p x = IM.size . IM.filter id $ fill p x
>           (n_even,n_odd) = (\p -> (IM.size $ fst p, IM.size $ snd p))
>                            . IM.partition id $ fill start (2*bound)

> mkmap :: [String] -> IntMap Char
> mkmap = IM.fromDistinctAscList . concat . zipWith f [0..]
>     where f r s = zipWith (\c x -> (r*length s+c,x)) [0..] s

> bfsDepth :: Int -> IntSet -> Int -> IntMap Bool -> IntSet
>          -> IntMap Bool
> bfsDepth bound plots d dists open
>     | d < 0     = dists
>     | otherwise = (bfsDepth bound plots $! d-1) dists' nexts
>     where f  = IS.filter (`IS.member` plots) . neighbours bound
>           n' = IS.foldr (\a b -> f a `IS.union` b) IS.empty open
>           nexts = IS.filter (`IM.notMember` dists) n'
>           dists' = dists `IM.union` IM.fromSet (const (even d)) open

> neighbours :: Int -> Int -> IntSet
> neighbours bound i
>     = IS.fromList . map f $ filter good
>       [(r,c+1),(r-1,c),(r,c-1),(r+1,c)]
>     where (r,c) = i `divMod` bound
>           f (a,b) = a*bound + b
>           good (a,b) = a>=0 && b>=0 && a<bound && b<bound
