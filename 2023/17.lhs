> module Main (main) where
> import Data.IntMap.Strict (IntMap)
> import Data.Set (Set)
> import qualified Data.IntMap.Strict as IM
> import qualified Data.Set as Set

> type Weight = Int
> type State = (Int, Int, Int, Int, Int)

> main :: IO ()
> main = do
>   ls@(x:_) <- lines <$> getContents
>   let br = length ls
>       bc = length x
>       m  = weights ls
>   putStr "A: " >> print (path 1 3 m br bc)
>   putStr "B: " >> print (path 4 10 m br bc)

> weights :: [String] -> IntMap Weight
> weights = IM.fromList . zip [0..] . map f . concat
>     where f x = fromEnum x - fromEnum '0'

> path :: Int -> Int -> IntMap Weight -> Int -> Int -> Int
> path lo hi m br bc = dijkstra lo hi m br bc starts open
>     where starts = Set.fromList [(0,0,1,0,0),(0,0,0,1,0)]
>           open = Set.mapMonotonic ((,) 0) starts

> dijkstra :: Int -> Int -> IntMap Weight -> Int -> Int
>          -> Set State -> Set (Weight, State) -> Int
> dijkstra lo hi m br bc seen open
>     | Set.null open = -1
>     | key state == br*bc - 1 && dist state >= lo = sw
>     | otherwise = dijkstra lo hi m br bc seen' (next `Set.union` rest)
>     where collapse (_,s) b
>               | dist s >= lo = Set.insert s b
>               | otherwise    = b
>           key (a,b,_,_,_) = a*bc + b
>           dist (_,_,_,_,x) = x
>           ((sw,state),rest) = Set.deleteFindMin open
>           f x = (m IM.! key x) + sw
>           next = Set.map (\x -> (f x, x))
>                  . Set.filter (`Set.notMember` seen)
>                  $ neighbours lo hi br bc state
>           seen' = foldr collapse seen next

> neighbours :: Int -> Int -> Int -> Int -> State -> Set State
> neighbours lo hi br bc (r,c,dr,dc,d)
>     | d >= lo   = Set.fromList $ filter good
>                   [ (r + dr, c + dc,  dr,  dc, d + 1)
>                   , (r - dc, c - dr, -dc, -dr, 1)
>                   , (r + dc, c + dr,  dc,  dr, 1)
>                   ]
>     | otherwise = Set.fromList $ filter good
>                   [ (r + dr, c + dc,  dr,  dc, d + 1) ]
>     where good (a,b,_,_,x)
>               = x <= hi && a >= 0 && a < br && b >= 0 && b < bc
