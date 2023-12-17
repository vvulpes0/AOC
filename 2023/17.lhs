> module Main (main) where
> import Data.IntMap.Strict (IntMap)
> import Data.Map.Strict (Map)
> import Data.Set (Set)
> import qualified Data.IntMap.Strict as IM
> import qualified Data.Map.Strict as Map
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

> swap :: (a,b) -> (b,a)
> swap (a,b) = (b,a)

> weights :: [String] -> IntMap Weight
> weights = IM.fromList . zip [0..] . map f . concat
>     where f x = fromEnum x - fromEnum '0'

> path :: Int -> Int -> IntMap Weight -> Int -> Int -> Int
> path lo hi m br bc
>     = dijkstra lo hi m br bc w open IM.! key (br-1) (bc-1)
>     where starts = [(0,0,1,0,0),(0,0,0,1,0)]
>           w = Map.fromList $ map (flip (,) 0) starts
>           open = Set.fromList $ map ((,) 0) starts
>           key r c = r*bc + c

> dijkstra :: Int -> Int -> IntMap Weight -> Int -> Int
>          -> Map State Weight -> Set (Weight, State) -> IntMap Weight
> dijkstra lo hi m br bc w open
>     | Set.null open = foldr collapse IM.empty $ Map.assocs w
>     | otherwise = dijkstra lo hi m br bc w' (next `Set.union` rest)
>     where collapse  (k,a) b = IM.insertWith min (key k) a b
>           collapse' (x,s) b
>               | dist s >= lo = Map.insertWith min s x b
>               | otherwise    = b
>           key (a,b,_,_,_) = a*bc + b
>           dist (_,_,_,_,x) = x
>           ((sw,state),rest) = Set.deleteFindMin open
>           f x = (m IM.! key x) + sw
>           next = Set.map (\x -> (f x, x))
>                  . Set.filter (`Map.notMember` w)
>                  $ neighbours lo hi br bc state
>           w' = foldr collapse' w next

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
