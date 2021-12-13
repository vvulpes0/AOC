> module Main where

> import Data.Char (isLower)
> import Data.List (partition)
> import Data.Map.Strict (Map)
> import Data.Set (Set)
> import qualified Data.Map as Map
> import qualified Data.Set as Set

> main = interact (\s -> let g = graph s in show (doA g, doB g) ++ "\n")

> doA = length . flip (paths True) "start"
> doB = length . flip (paths False) "start"

> type Graph a = Map a (Set a)

> conns :: String -> [(String,String)]
> conns = f . map ((\(a:b:_) -> (a,b)) . words . dehyp) . lines
>     where dehyp = map (\x -> if x == '-' then ' ' else x)
>           f [] = []
>           f (x:xs) = x : (snd x, fst x) : f xs

> graph :: String -> Map String (Set String)
> graph = Map.fromList . graph' . conns

> graph' :: Ord a => [(a,a)] -> [(a, Set a)]
> graph' [] = []
> graph' (x:xs) = (fst x, Set.fromList $ map snd y) : graph' r
>     where (y, r) = partition ((== (fst x)) . fst) (x:xs)

> delete :: Ord a => a -> Graph a -> Graph a
> delete x = Map.map (Set.delete x) . Map.delete x

> paths :: Bool -> Graph String -> String -> [[String]]
> paths _ _ "end" = [["end"]]
> paths b g x
>     | x == "start" || b = next b g'
>     | otherwise = Set.toList $ Set.fromList
>                   (next False g' ++ next True g)
>     where g' = if any isLower $ take 1 x
>                then delete x g
>                else g
>           ns = maybe [] id (Set.toList <$> Map.lookup x g)
>           next y h = map (x:) $ concatMap (paths y h) ns
