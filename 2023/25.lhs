> import Data.Map (Map, (!), adjust, keysSet)
> import Data.Set (Set, (\\), delete, empty, toList, union, unions)
> import qualified Data.Map as Map
> import qualified Data.Set as Set

> type Graph = Map String (Set String)

> main = do
>   g <- graph <$> getContents
>   putStr "A: " >> print (partA g)

> partA :: Graph -> Int
> partA g = prod $ size (iterate f g !! 3)
>     where ((s,e), m) = boundaries g
>           m' = iterate (spring g s e) m !! 6
>           f gr = deleteLongest gr m'
>           size gr = Map.size . snd
>                     $ bfs gr Map.empty (Set.take 1 $ keysSet gr) 0
>           prod x = x * (Map.size g - x)

> graph :: String -> Graph
> graph = Map.fromListWith union . concatMap f . lines
>     where f s = let (pre,post) = drop 1 <$> break (== ':') s
>                 in concatMap
>                    (\a -> [ (a,Set.singleton pre)
>                           , (pre,Set.singleton a)
>                           ]) $ words post

> boundaries :: Graph -> ((String,String), Map String Double)
> boundaries g = ((near, far), m)
>     where near     = furthest g empty (Set.take 1 $ keysSet g)
>           (far, m) = bfs g Map.empty (Set.singleton near) 0

> deleteLongest :: Graph -> Map String Double -> Graph
> deleteLongest g m = adjust (delete p) q $ adjust (delete q) p g
>     where (p,q) = snd . maximum . concatMap (uncurry expand)
>                   $ Map.assocs g
>           expand k = map (\x -> (abs (m!k - m!x), (k,x))) . toList

> spring :: Graph -> String -> String -> Map String Double
>        -> Map String Double
> spring g start end m = Map.mapWithKey f g
>     where f k a
>               | k == start || k == end = m!k
>               | otherwise = mean a
>           mean xs = (sum . map weight $ toList xs)
>                     / fromIntegral (Set.size xs + extra xs)
>           weight k
>               | k == end = 5*(m!k)
>               | otherwise = m!k
>           extra = (4*) . Set.size
>                   . Set.filter (\x -> x == start || x == end)

> furthest :: Graph -> Set String -> Set String -> String
> furthest g closed open
>     | Set.null open = error "empty open set"
>     | Set.null next = Set.findMin open
>     | otherwise = furthest g (closed `union` open) next
>     where next = (unions . map (g !) $ toList open) \\ closed

> bfs :: Graph -> Map String Double -> Set String -> Int
>     -> (String, Map String Double)
> bfs g closed open d
>     | Set.null open = error "empty open set"
>     | Set.null next = (Set.findMin open, w')
>     | otherwise = bfs g w' next $! d+1
>     where w' = Map.fromSet (const (fromIntegral d)) open
>                `Map.union` closed
>           next = (unions . map (g !) $ toList open) \\ keysSet closed
