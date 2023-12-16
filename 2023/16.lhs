> import Data.IntMap.Strict (IntMap, (!?))
> import Data.Set (Set, difference, empty, singleton, size, union)
> import qualified Data.IntMap.Strict as IM
> import qualified Data.Set as Set

> import GHC.Conc

> type Pos = (Int, Int, Int, Int)

> main :: IO ()
> main = do
>   ls@(x:_) <- lines <$> getContents
>   let br = length ls
>       bc = length x
>       m  = findMirrors ls
>   putStr "A: " >> print (partA m br bc (0,0,0,1))
>   putStr "B: " >> print (partB m br bc)

> partA :: IntMap Char -> Int -> Int -> Pos -> Int
> partA m br bc = size . Set.map coords . bfs m br bc empty . singleton

> partB :: IntMap Char -> Int -> Int -> Int
> partB m br bc = maximum . parmap (partA m br bc) $ n ++ e ++ w ++ s
>     where e = [(  i ,  0 , 0, 1) | i <- [0..br-1]]
>           n = [(br-1,  i ,-1, 0) | i <- [0..bc-1]]
>           w = [(  i ,bc-1, 0,-1) | i <- [0..br-1]]
>           s = [(  0 ,  i , 1, 0) | i <- [0..bc-1]]

> coords :: (a,b,c,d) -> (a,b)
> coords (a,b,_,_) = (a,b)

> bfs :: IntMap Char -> Int -> Int -> Set Pos -> Set Pos -> Set Pos
> bfs m br bc closed open
>     | Set.null open = closed
>     | otherwise = bfs m br bc clopen (difference next clopen)
>     where next = Set.foldr combine Set.empty open
>           clopen = union open closed
>           combine a b = Set.fromDistinctAscList (filter good $ f a)
>                         `union` b
>           good (r, c, _, _) = r >= 0 && c >= 0 && r < br && c < bc
>           f (r, c, dr, dc)
>               = case m !? (r*bc + c) of
>                   Just '/'  -> [(r - dc, c - dr, -dc, -dr)]
>                   Just '\\' -> [(r + dc, c + dr, dc, dr)]
>                   Just '|'  -> if dc /= 0
>                                then [(r-1, c, -1, 0), (r+1, c, 1, 0)]
>                                else [(r + dr, c + dc, dr, dc)]
>                   Just '-'  -> if dr /= 0
>                                then [(r, c-1, 0, -1), (r, c+1, 0, 1)]
>                                else [(r + dr, c + dc, dr, dc)]
>                   _         -> [(r + dr, c + dc, dr, dc)]

> findMirrors :: [String] -> IntMap Char
> findMirrors = foldr f IM.empty . zip [0..] . concat
>     where f (i,a) b = if a `elem` "\\/|-" then IM.insert i a b else b

> parmap :: (a -> b) -> [a] -> [b]
> parmap f (x:xs) = o `par` r `pseq` o:r
>     where o = f x
>           r = parmap f xs
> parmap _ _ = []
