> module Main (main) where
> import Data.Maybe (catMaybes)
> import Data.IntSet (IntSet)
> import Data.Set (Set)
> import qualified Data.Set as Set
> import qualified Data.IntSet as IS

> main :: IO ()
> main = do
>   (a,b) <- solve <$> getContents
>   putStr "A: " >> print a >> putStr "B: " >> print b

> solve :: String -> (Int, Int)
> solve s = (d, i)
>     where source = mkZip $ lines s
>           z = down . Zip [] Nothing $ ggraph 0 z source
>           grid = flatten $ fmap flatten z
>           (d, nodes) = maximalSDist . Set.fromDistinctAscList
>                        . catMaybes $ concat grid
>           i = pip nodes grid

> data Zipper a = Zip {pre :: [a], at :: Maybe a, post :: [a]}
> instance Functor Zipper where
>     fmap f z = Zip (f <$> pre z) (f <$> at z) (f <$> post z)
> type Grid a = Zipper (Zipper a)
> data Node a = Node {nid :: Int, dat :: a, neighbours :: Set (Node a)}
> instance Eq (Node a) where a == b = nid a == nid b
> instance Ord (Node a) where compare a b = compare (nid a) (nid b)
> type Cell = Maybe (Node (Bool, Bool)) -- start / verti barrier

> flatten :: Zipper a -> [a]
> flatten z = reverse (pre z) ++ (maybe id (:) (at z)) (post z)
> down, up :: Zipper a -> Zipper a
> up z = case pre z of
>            (x:xs) -> Zip xs (Just x) . maybe (post z) (:post z) $ at z
>            _      -> Zip [] Nothing  . maybe (post z) (:post z) $ at z
> down z = case post z of
>            (x:xs) -> Zip (maybe (pre z) (:pre z) (at z)) (Just x) xs
>            _      -> Zip (maybe (pre z) (:pre z) (at z)) Nothing []
> right, left :: Grid a -> Grid a
> right z = fmap down z
> left  z = fmap up z
> cursor :: Grid a -> Maybe a
> cursor z = (=<<) id . fmap at $ at z
> mkZip :: [String] -> Zipper (Zipper Char)
> mkZip = down . Zip [] Nothing . map (down . Zip [] Nothing)

> get :: [Grid (Maybe a) -> Grid (Maybe a)] -> Grid (Maybe a) -> [a]
> get locs z = catMaybes . catMaybes $ map (cursor . ($ z)) locs

> ggraph :: Int -> Grid Cell -> Grid Char -> [Zipper Cell]
> ggraph i seek source
>     = case at source of
>         Nothing -> []
>         _ -> down (Zip [] Nothing cs)
>              : ggraph j (down seek) (down source)
>     where (j, cs) = graphRow i seek source
> graphRow :: Int -> Grid Cell -> Grid Char -> (Int, [Cell])
> graphRow i seek source
>     = case cursor source of
>         Nothing -> (i, [])
>         Just '.' -> (Nothing :) <$> graphRow i rsk rso
>         Just x   -> c x <$> graphRow (succ i) rsk rso
>     where c x = (Just (Node i (x == 'S', isBarrier x)
>                        (Set.fromList $ get (connections x) seek)) :)
>           rso = right source
>           rsk = right seek
>           isBarrier x
>               = x `elem` "LJ|" -- spse 1/4 way into cell
>                 || (x == 'S'   -- S only barrier if equiv~ barrier
>                     && cursor (up source) `elem` map Just "|7F")
>           connections x
>               = catMaybes
>                 [ if ((\y -> [x,y]) <$> cursor (right source)) `elem`
>                      map Just (cat "-LFS" "-J7S")
>                   then Just right else Nothing
>                 , if ((\y -> [y,x]) <$> cursor (up source)) `elem`
>                      map Just (cat "|7FS" "|LJS")
>                   then Just up else Nothing
>                 , if ((\y -> [y,x]) <$> cursor (left source)) `elem`
>                      map Just (cat "-LFS" "-J7S")
>                   then Just left else Nothing
>                 , if ((\y -> [x,y]) <$> cursor (down source)) `elem`
>                      map Just (cat "|7FS" "|LJS")
>                   then Just down else Nothing
>                 ]

> maximalSDist :: Set (Node (Bool, t)) -> (Int, IntSet)
> maximalSDist = (\x -> bfsDepth 0 x x) . Set.filter (fst . dat)
> bfsDepth :: Int -> Set (Node a) -> Set (Node a) -> (Int, IntSet)
> bfsDepth d seen open
>     | next `Set.isSubsetOf` seen
>         = (d, IS.fromDistinctAscList . map nid $ Set.toAscList seen)
>     | otherwise = d `seq` bfsDepth (d+1)
>                   (Set.union next seen) (Set.difference next seen)
>     where next = Set.unions $ Set.map neighbours open

> pip :: IntSet -> [[Cell]] -> Int
> pip loop = sum . map (pipRow loop 0 False)
> pipRow :: IntSet -> Int -> Bool -> [Cell] -> Int
> pipRow loop d inside (x:xs)
>     = case x of
>         Nothing -> pipRow loop d' inside xs
>         Just n  -> if nid n `IS.member` loop
>                    then pipRow loop d (inside /= snd (dat n)) xs
>                    else pipRow loop d' inside xs
>     where d' = d `seq` if inside then d+1 else d
> pipRow _ d _ _ = d

> cat :: [a] -> [a] -> [[a]]
> cat xs ys = [[x,y] | x <- xs, y <- ys]
