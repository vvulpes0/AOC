> import Data.List (partition)
> import Data.Map (Map)
> import Data.Set (Set)
> import Debug.Trace
> import qualified Data.Map as Map
> import qualified Data.Set as Set

> type Graph = Map (Set String) [(Set String, Int)]

> main = do
>   g <- graph <$> getContents
>   putStr "A: " >> print (partA g)

> partA :: Graph -> Int
> partA = product . map Set.size . Map.keys . fst . minCut

> graph :: String -> Graph
> graph = Map.fromListWith (++) . concatMap f . lines
>     where f s = let (pre,post) = drop 1 <$> break (== ':') s
>                 in concatMap
>                    (\a -> [( Set.singleton a,[(Set.singleton pre, 1)])
>                            ,(Set.singleton pre,[(Set.singleton a, 1)])
>                           ]) $ words post

> minCut :: Graph -> (Graph,Int)
> minCut g
>     | Map.size g < 2  = (g,999999999)
>     | Map.size g == 2 = (g'', w)
>     | w < q           = (g'', w)
>     | otherwise       = (h, q)
>     where [t,s] = if Map.size g == 2 then Map.keys g
>                   else minCutPhase g (fst $ Map.findMin g) []
>           g' = merge g [t,s]
>           g'' = merge g (filter (/= t) $ Map.keys g)
>           w = sum $ fmap snd (g Map.! t)
>           (h,q) = minCut g'

> minCutPhase :: Graph -> Set String -> [Set String] -> [Set String]
> minCutPhase g seen out
>     | seen == Set.unions (Map.keys g) = out
>     | otherwise = minCutPhase g (maxi `Set.union` seen)
>                   (maxi : take 1 out)
>     where (maxi,_) = foldr1 (uncurry f) . map weight
>                      . filter ((`Set.disjoint` seen) . fst)
>                      $ Map.toAscList g
>           f k a (b,m)
>               | a > m = (k,a)
>               | otherwise = (b,m)
>           weight (k,xs) = (k, sum . map snd
>                           $ filter ((`Set.isSubsetOf` seen) . fst) xs)

> merge :: Graph -> [Set String] -> Graph
> merge g xs = insert . Map.map f . Map.withoutKeys g $ Set.fromList xs
>     where set = Set.unions xs
>           f ys = let (on,out) = partition
>                                 ((`Set.isSubsetOf` set) . fst) ys
>                  in case on of
>                       [] -> out
>                       _  -> (set, sum $ map snd on) : out
>           expand (k,ys) = map ((,) k) ys
>           insert m = flip (uncurry Map.insert) m
>                      . (,) set . map (fmap snd)
>                      . filter ((== set) . fst . snd)
>                      . concatMap (expand . fmap (take 1))
>                      $ Map.assocs m
