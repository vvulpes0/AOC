> import Data.Array (Array,(!),bounds,listArray)
> import Data.Map.Strict (Map,(!?),fromListWith)
> import Data.Set (Set,(\\),empty,insert,singleton)
> import qualified Data.Set as Set

> type Pos = (Int,Int)

> main :: IO ()
> main = do
>   m <- mkarray <$> getContents
>   putStr "A: " >> print (solve neighboursA m)
>   putStr "B: " >> print (solve neighboursB m)

> solve :: (Array Pos Char -> Pos -> Set Pos) -> Array Pos Char -> Int
> solve ns m = maybe (-1) id $ longDFS (graph ns m) target empty (0,1)
>     where target = fmap (subtract 1) . snd $ bounds m

> mkarray :: String -> Array Pos Char
> mkarray xs = listArray ((0,0),(lx,lx)) $ concat ls
>     where ls = lines xs
>           lx = length ls - 1

> graph :: (Array Pos Char -> Pos -> Set Pos) -> Array Pos Char
>          -> Map Pos [(Pos, Int)]
> graph neighbours m = fromListWith (++) $ handle empty [(0,1)]
>     where target = fmap (subtract 1) . snd $ bounds m
>           search seen at p d
>               = case Set.toList (neighbours m p \\ seen) of
>                   (_:_:_) -> [(at,[(p,d)])]
>                   [x] -> search (insert p seen) at x $! d+1
>                   _ -> if p == target then [(at,[(p,d)])] else []
>           handle _ [] = []
>           handle done (x:xs)
>               | x `Set.member` done = handle done xs
>               | otherwise = edges ++ handle (insert x done) nexts
>               where edges = concatMap f . Set.toList $ neighbours m x
>                     nexts = xs ++ concatMap (map fst . snd) edges
>                     f n = search (singleton x) x n 1

> longDFS :: Map Pos [(Pos, Int)] -> Pos -> Set Pos -> Pos -> Maybe Int
> longDFS g target seen at
>     | at == target = Just 0
>     | otherwise = case g !? at of
>                     Just xs -> f xs
>                     _ -> Nothing
>     where f xs = foldr max Nothing
>                  . map (\(p,d) -> (+d) <$> longDFS g target seen' p)
>                  $ filter ((`Set.notMember` seen) . fst) xs
>           seen' = insert at seen

> neighboursA :: Array Pos Char -> Pos -> Set Pos
> neighboursA m (r,c)
>     = case m!(r,c) of
>         '.' -> f [(r-1,c),(r,c-1),(r,c+1),(r+1,c)]
>         '>' -> f [(r,c+1)]
>         '^' -> f [(r-1,c)]
>         '<' -> f [(r,c-1)]
>         'v' -> f [(r+1,c)]
>         _   -> empty
>     where f = Set.fromDistinctAscList . filter good
>           (_,(_,bound)) = bounds m
>           good (a,b) = a >= 0 && b >= 0 && a <= bound && b <= bound
>                        && m!(a,b) /= '#'

> neighboursB :: Array Pos Char -> Pos -> Set Pos
> neighboursB m (r,c)
>     = case m!(r,c) of
>         '#' -> empty
>         _   -> f [(r-1,c),(r,c-1),(r,c+1),(r+1,c)]
>     where f = Set.fromDistinctAscList . filter good
>           (_,(_,bound)) = bounds m
>           good (a,b) = a >= 0 && b >= 0 && a <= bound && b <= bound
>                        && m!(a,b) /= '#'
