> module Main (main) where
> import Data.Maybe (catMaybes)
> import Data.Set (Set)
> import qualified Data.Set as Set

> main :: IO ()
> main = do
>   (a,b) <- solve <$> getContents
>   putStr "A: " >> print a >> putStr "B: " >> print b

> solve :: String -> (Int, Int)
> solve s = (d `div` 2, length i)
>     where source = mkZip . embiggen $ lines s
>           z  = down . Zip [] Nothing $ ggraph 0 z source
>           g  = Set.fromList . concat . flatten $ fmap flatten z
>           (d, nodes) = maximalSDist g
>           rg = down . Zip [] Nothing $ regraph nodes 0 rg z
>           g' = Set.fromList . concat . flatten $ fmap flatten rg
>           o  = outside Set.empty $ Set.filter ((== Just True) . dat) g'
>           fl = concat . unembiggen . map flatten $ flatten rg
>           i  = filter (\n -> dat n == Nothing && Set.notMember n o) fl

> data Zipper a = Zip {pre :: [a], at :: Maybe a, post :: [a]}
> instance Functor Zipper where
>     fmap f z = Zip (f <$> pre z) (f <$> at z) (f <$> post z)
> type Grid a = Zipper (Zipper a)
> data Node a = Node {nid :: Int, dat :: a, neighbours :: Set (Node a)}
> instance Eq (Node a) where a == b = nid a == nid b
> instance Ord (Node a) where compare a b = compare (nid a) (nid b)
> type Cell = Node Char

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

> get :: [Grid a -> Grid a] -> Grid a -> [a]
> get locs z = catMaybes $ map (cursor . ($ z)) locs

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
>         Just x   -> c x <$> graphRow (succ i) rsk rso
>     where c x = (Node i x (Set.fromList
>                           $ get (connections x) seek) :)
>           rso = right source
>           rsk = right seek
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

> maximalSDist :: Set (Node Char) -> (Int, Set (Node Char))
> maximalSDist = (\x -> bfsDepth 0 x x) . Set.filter ((== 'S') . dat)
> bfsDepth :: Int -> Set (Node Char) -> Set (Node Char)
>          -> (Int, Set (Node Char))
> bfsDepth d seen open
>     | next `Set.isSubsetOf` seen = (d, seen)
>     | otherwise = d `seq` bfsDepth (d+1)
>                   (Set.union next seen) (Set.difference next seen)
>     where next = Set.unions $ Set.map neighbours open

> embiggen :: [String] -> [String]
> embiggen = embiggenVert . map embiggenHorz
> embiggenVert :: [String] -> [String]
> embiggenVert [] = []
> embiggenVert (x:xs) = map (const '.') x : embiggen' (x:xs)
>     where embiggen' (x:y:xs) = x : zipWith f x y : embiggen' (y:xs)
>           embiggen' (y:[]) = y : [map (const '.') y]
>           embiggen' [] = []
>           f x y = if [x,y] `elem` cat "|7FS" "|LJS"
>                   then '|' else '.'
> embiggenHorz :: String -> String
> embiggenHorz s = '.' : embiggen' s
>     where embiggen' (x:y:xs) = x : f x y : embiggen' (y:xs)
>           embiggen' (y:[]) = y : "."
>           embiggen' [] = []
>           f x y = if [x,y] `elem` cat "-LFS" "-J7S"
>                   then '-' else '.'
> unembiggen :: [[a]] -> [[a]]
> unembiggen = map so2 . so2
>     where so2 :: [b] -> [b]
>           so2 (x:y:xs) = y : so2 xs
>           so2 _ = []

> cat :: [a] -> [a] -> [[a]]
> cat xs ys = [[x,y] | x <- xs, y <- ys]

> regraph :: Set (Node a) -> Int -> Grid (Node (Maybe Bool))
>         -> Grid (Node a) -> [Zipper (Node (Maybe Bool))]
> regraph loop i seek source
>     = case at source of
>         Nothing -> []
>         _ -> down (Zip [] Nothing cs)
>              : regraph loop j (down seek) (down source)
>     where (j, cs) = regraphRow loop i seek source
> regraphRow :: Set (Node a) -> Int -> Grid (Node (Maybe Bool))
>            -> Grid (Node a) -> (Int, [Node (Maybe Bool)])
> regraphRow loop i seek source
>     = case cursor source of
>         Nothing -> (i, [])
>         Just n -> (j, mknode n : cs)
>       where (j, cs) = regraphRow loop (succ i)
>                       (right seek) (right source)
>             mknode n
>                 | n `Set.member` loop
>                     = Node i (Just False) Set.empty
>                 | any ((== Nothing) . cursor . ($ source))
>                   [right, up, left, down]
>                       = Node i (Just True) $ gns
>                 | otherwise = Node i Nothing $ gns
>             gns = Set.fromList $ get near seek
>             near = (if good right then (right:) else id)
>                    $ (if good up then (up:) else id)
>                    $ (if good left then (left:) else id)
>                    $ (if good down then (down:) else id)
>                    $ []
>             good g = maybe False (`Set.notMember` loop)
>                      . cursor $ g source

> outside :: Set (Node (Maybe Bool)) -> Set (Node (Maybe Bool))
>         -> Set (Node (Maybe Bool))
> outside closed open
>     | next `Set.isSubsetOf` closed = closed
>     | otherwise = outside
>                   (Set.union next closed) (Set.difference next closed)
>     where next = Set.unions . map neighbours $ Set.toList open
