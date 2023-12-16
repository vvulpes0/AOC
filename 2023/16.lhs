> module Main (main) where
> import Data.List (foldl')
> import Data.Maybe (catMaybes)
> import Data.Set (Set)
> import qualified Data.Set as Set
> import qualified Data.IntSet as IS

> import GHC.Conc

> main :: IO ()
> main = do
>   (start, g) <- graph . mkZip . lines <$> getContents
>   putStr "A: " >> print (partA start)
>   putStr "B: " >> print (partB g)

> partA :: Node Bool -> Int
> partA = Set.size . Set.map ((`div` 4) . nid)
>         . bfs Set.empty . Set.singleton

> partB :: Set (Node Bool) -> Int
> partB = maximum . go . filter dat . Set.toList
>     where go xs = parmap (maximum . map partA) $ chunks 8 xs
>           parmap f [] = []
>           parmap f (x:xs)
>               = let o = f x
>                     r = parmap f xs
>                 in o `par` r `pseq` o : r

> bfs :: Set (Node a) -> Set (Node a) -> Set (Node a)
> bfs closed open
>     | open `Set.isSubsetOf` closed = closed
>     | otherwise = bfs co next
>     where co = closed `Set.union` open
>           next = Set.unions (Set.map neighbours open)
>                  `Set.difference` co

> data Zipper a = Zip {pre :: [a], at :: Maybe a, post :: [a]}
> instance Functor Zipper where
>     fmap f z = Zip (f <$> pre z) (f <$> at z) (f <$> post z)
> type Grid a = Zipper (Zipper a)
> data Node a = Node {nid :: Int, dat :: a, neighbours :: Set (Node a)}
> instance Eq (Node a) where a == b = nid a == nid b
> instance Ord (Node a) where compare a b = compare (nid a) (nid b)
> type Cell = (Node Bool, Node Bool, Node Bool, Node Bool)

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

> get :: Ord b => [(a -> b, Grid a -> Grid a)] -> Grid a -> Set b
> get locs z = Set.fromList . catMaybes
>              $ map (uncurry fmap . fmap (cursor . ($ z))) locs

> east, north, south, west :: (a,a,a,a) -> a
> east  (x,_,_,_) = x
> north (_,x,_,_) = x
> west  (_,_,x,_) = x
> south (_,_,_,x) = x

> graph :: Grid Char -> (Node Bool, Set (Node Bool))
> graph source
>     = let z = down . Zip [] Nothing $ ggraph 0 z source
>       in case concatMap f . concat . flatten $ fmap flatten z of
>            xs@(x:_) -> (x, Set.fromList xs)
>            _ -> error "no nodes"
>     where f (a,b,c,d) = [a,b,c,d]
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
>         Nothing  -> (i, [])
>         Just x   -> (go x :) <$> graphRow (i + 4) rsk rso
>     where f (a,b,c,d)
>               = ( Node i wallW $ get a seek
>                 , Node (i+1) wallS $ get b seek
>                 , Node (i+2) wallE $ get c seek
>                 , Node (i+3) wallN $ get d seek
>                 )
>           wallW = maybe True (const False) . cursor $ left source
>           wallS = maybe True (const False) . cursor $ down source
>           wallE = maybe True (const False) . cursor $ right source
>           wallN = maybe True (const False) . cursor $ up source
>           go '.'  = f ([er], [nu], [wl], [sd])
>           go '/'  = f ([nu], [er], [sd], [wl])
>           go '\\' = f ([sd], [wl], [nu], [er])
>           go '|'  = f ([nu,sd], [nu], [nu,sd], [sd])
>           go '-'  = f ([er], [er,wl], [wl], [er,wl])
>           go _    = error "bad char in grid"
>           er = (east, right)
>           nu = (north, up)
>           wl = (west, left)
>           sd = (south, down)
>           rso = right source
>           rsk = right seek

> chunks :: Int -> [a] -> [[a]]
> chunks _ [] = []
> chunks n xs = uncurry (:) . fmap (chunks n) $ splitAt n xs
