> import Data.Char (isDigit)
> import Data.Either (isLeft, isRight)
> import Data.Maybe (catMaybes)
> import Data.Set (Set)
> import qualified Data.Set as Set

> headMaybe :: [a] -> Maybe a
> headMaybe (x:_) = Just x
> headMaybe _ = Nothing

> data Zipper a = Zip {pre :: [a], at :: Maybe a, post :: [a]}
> instance Functor Zipper where
>     fmap f z = Zip (f <$> pre z) (f <$> at z) (f <$> post z)
> type Grid a = Zipper (Zipper a)
> data Node a = Node {nid :: Int, dat :: a, neighbours :: Set (Node a)}
> instance Eq (Node a) where a == b = nid a == nid b
> instance Ord (Node a) where compare a b = compare (nid a) (nid b)
> type Cell = Maybe (Node (Either Char Integer))

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
> mkZip :: String -> Zipper (Zipper Char)
> mkZip = down . Zip [] Nothing . map (down . Zip [] Nothing) . lines

> get :: [Grid (Maybe a) -> Grid (Maybe a)] -> Grid (Maybe a) -> [a]
> get locs z = catMaybes . catMaybes $ map (cursor . ($ z)) locs
> aroundNum, around' :: Grid (Maybe a) -> Grid Char -> [a]
> aroundNum seek source
>     = get [left, left . down, left . up] seek ++ around' seek source
> around' seek source
>     | maybe False isDigit $ cursor r
>         = get [up, down] seek ++ around' (right seek) r
>     | otherwise = get [up, right . up, right, right . down, down] seek
>     where r = right source

> graph :: Grid Char -> Set (Node (Either Char Integer))
> graph source = let z = down . Zip [] Nothing $ ggraph 0 z source
>                in Set.fromList . catMaybes . concat . flatten
>                   $ fmap flatten z
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
>         Nothing   -> (i, [])
>         Just '.'  -> (Nothing :) <$> graphRow i rsk rso
>         Just c
>             -> if not (isDigit c) && not ('.' == c)
>                then (Just (Node i (Left c)
>                            (Set.fromList $ get near seek)) :)
>                     <$> graphRow (i+1) rsk rso
>                else if maybe False isDigit . cursor $ left source
>                     then (((=<<) id . cursor $ left seek) :)
>                          <$> graphRow i rsk rso
>                     else (Just (Node i (Right n)
>                                 (Set.fromList $ aroundNum seek source))
>                          :)
>                          <$> graphRow (i+1) rsk rso
>     where near = [ right, right . up, up, left . up
>                  , left, left . down, down, right . down]
>           rsk = right seek
>           rso = right source
>           n = maybe 0 (read . takeWhile isDigit . rest) (at source)
>           rest z = maybe (post z) (:post z) (at z)

> main = do
>   g <- Set.toList . graph . mkZip <$> getContents
>   putStr "A: " >> print (partA g)
>   putStr "B: " >> print (partB g)
>   --putStr $ display g

> partA :: [Node (Either Char Integer)] -> Integer
> partA = sum . map (either (const 0) id . dat)
>         . filter (\x -> isRight (dat x)
>                   && any (isLeft . dat) (neighbours x))

> partB :: [Node (Either Char Integer)] -> Integer
> partB = sum . map ( product . map (either (const 1) id . dat)
>                   . Set.toList . neighbours)
>         . filter ((== 2) . Set.size
>                  . Set.filter (isRight . dat) . neighbours)
>         . filter (either (== '*') (const False) . dat)

> display :: [Node (Either Char Integer)] -> String
> display nodes
>     = unlines
>       ( "graph {"
>       : "node [style=filled]"
>       : map label nodes
>       ++ connections
>       ++ ["}"])
>     where baseLabel c s n = show (nid n) ++ " [label=" ++ s
>                             ++ ", fillcolor=" ++ show c ++ "]"
>           label n = case dat n of
>                       Left x  -> baseLabel "#ccc" (show [x]) n
>                       Right x -> baseLabel "#fff" (show x) n
>           connections = [ show (nid x) ++ " -- " ++ show (nid y)
>                         | x <- nodes
>                         , y <- nodes
>                         , nid x < nid y
>                         , y `Set.member` neighbours x
>                         ]
