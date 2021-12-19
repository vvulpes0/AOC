> module Main where

> import Data.Bifunctor (bimap, first)
> import Data.List (permutations)
> import Data.Map.Strict (Map,(!))
> import Data.Maybe (catMaybes)
> import Data.Set (Set)
> import qualified Data.Map.Strict as Map
> import qualified Data.Set as Set

> data P3 a = P3 a a a
>         deriving (Eq, Ord, Read, Show)

> p3 :: (Int, Int, Int) -> P3 Int
> p3 (a,b,c) = P3 a b c

> main = interact (f . Map.fromList . getInput . lines)
>     where f s = let m = assignTasks s
>                 in unlines [show (doa s m) ++ "\t" ++ show (dob s m)]

> doa :: Map Int (Set (P3 Int)) -> Map Int [Task] -> Int
> doa s m = Set.size $ align s m

> dob :: Map Int (Set (P3 Int)) -> Map Int [Task] -> Int
> dob s m = Set.findMax . Set.map (uncurry f) $ Set.cartesianProduct p p
>     where o = Set.singleton (P3 0 0 0)
>           p = align (Map.map (const o) s) m
>           f a b = sumv (abs (a - b))
>           sumv (P3 a b c) = a + b + c

> type Task = (P3 (P3 Int), P3 Int)

> align :: Map Int (Set (P3 Int)) -> Map Int [Task] -> Set (P3 Int)
> align s p = Set.unions
>             . map (uncurry (flip doTasks) . first (p!))
>             $ Map.assocs s

> doTasks :: Set (P3 Int) -> [Task] -> Set (P3 Int)
> doTasks x [] = x
> doTasks x ((o, t):xs)
>     = doTasks (translate t (Set.map (orient o) x)) xs

> assignTasks :: Map Int (Set (P3 Int)) -> Map Int [Task]
> assignTasks m = assignTasks' m (Map.singleton 0 [])

> assignTasks' :: Map Int (Set (P3 Int))
>              -> Map Int [Task] -> Map Int [Task]
> assignTasks' s p
>     | null k = p
>     | otherwise = assignTasks' s (Map.union p p')
>     where as = Map.assocs p
>           k = filter (`notElem` Map.keys p) $ Map.keys s
>           f v a = fmap (: snd a) $ check (s ! fst a) v
>           g v = (v, take 1 . catMaybes $ map (f (s ! v)) as)
>           p' = Map.fromList . map (fmap head)
>                . filter (not . null . snd) $ map g k


> check :: (Num a, Ord a) => Set (P3 a) -> Set (P3 a)
>       -> Maybe (P3 (P3 a), P3 a)
> check a b = fmap f . maybeHead
>             . filter (not . Set.null . snd)
>             . zip orientations
>             $ map (\o -> overlay a $ Set.map (orient o) b) orientations
>     where f (o, ps) = (o, Set.findMin ps)
>           maybeHead (x:_) = Just x
>           maybeHead _ = Nothing

> orient :: Num a => P3 (P3 a) -> P3 a -> P3 a
> orient (P3 x y z) p = P3 (dotP x p) (dotP y p) (dotP z p)
>     where dotP a b = sumv (a * b)
>           sumv (P3 a b c) = a + b + c

> orientations :: Num a => [P3 (P3 a)]
> orientations
>     = (map f
>        [ [[ 1,  0,  0], [ 0,  1,  0], [ 0,  0,  1]]
>        , [[ 1,  0,  0], [ 0,  0,  1], [ 0, -1,  0]]
>        , [[ 1,  0,  0], [ 0, -1,  0], [ 0,  0, -1]]
>        , [[ 1,  0,  0], [ 0,  0, -1], [ 0,  1,  0]]
>        , [[ 0,  1,  0], [-1,  0,  0], [ 0,  0,  1]]
>        , [[ 0,  1,  0], [ 0,  0,  1], [ 1,  0,  0]]
>        , [[ 0,  1,  0], [ 1,  0,  0], [ 0,  0, -1]]
>        , [[ 0,  1,  0], [ 1,  0,  0], [ 0, -1,  0]]
>        , [[-1,  0,  0], [ 0, -1,  0], [ 0,  0,  1]]
>        , [[-1,  0,  0], [ 0,  0, -1], [ 0, -1,  0]]
>        , [[-1,  0,  0], [ 0,  1,  0], [ 0,  0, -1]]
>        , [[-1,  0,  0], [ 0,  0,  1], [ 0,  1,  0]]
>        , [[ 0, -1,  0], [ 1,  0,  0], [ 0,  0,  1]]
>        , [[ 0, -1,  0], [ 0,  0, -1], [ 1,  0,  0]]
>        , [[ 0, -1,  0], [-1,  0,  0], [ 0,  0, -1]]
>        , [[ 0, -1,  0], [ 0,  0,  1], [-1,  0,  0]]
>        , [[ 0,  0,  1], [ 0,  1,  0], [-1,  0,  0]]
>        , [[ 0,  0,  1], [ 1,  0,  0], [ 0,  1,  0]]
>        , [[ 0,  0,  1], [ 0, -1,  0], [ 1,  0,  0]]
>        , [[ 0,  0,  1], [-1,  0,  0], [ 0, -1,  0]]
>        , [[ 0,  0, -1], [ 0, -1,  0], [-1,  0,  0]]
>        , [[ 0,  0, -1], [-1,  0,  0], [ 0,  1,  0]]
>        , [[ 0,  0, -1], [ 0,  1,  0], [ 1,  0,  0]]
>        , [[ 0,  0, -1], [ 1,  0,  0], [ 0, -1,  0]]])
>     where f ((a:b:c:_):(d:e:g:_):(h:i:j:_):[])
>               = P3 (P3 a b c) (P3 d e g) (P3 h i j)

> overlay :: (Num a, Ord a) => Set (P3 a) -> Set (P3 a) -> Set (P3 a)
> overlay a b = Set.filter sufficient deltas
>     where deltas = Set.map (uncurry subtract) $ Set.cartesianProduct a b
>           join p = Set.intersection a (translate p b)
>           sufficient p = Set.size (join p) >= 12

> translate :: (Num a, Ord a) => P3 a -> Set (P3 a) -> Set (P3 a)
> translate x = Set.map (subtract x)

> getInput :: [String] -> [(Int,Set (P3 Int))]
> getInput [] = []
> getInput xs = uncurry (:)
>               . bimap f (getInput . dropWhile null)
>               $ break null xs
>     where f (y:ys) = ( read . concat . take 1 . drop 2 $ words y
>                      , Set.fromList
>                        $ map (p3 . read . ('(':) . (++")")) ys
>                      )

> instance Num a => Num (P3 a) where
>     (P3 a b c) + (P3 x y z) = P3 (a+x) (b+y) (c+z)
>     (P3 a b c) - (P3 x y z) = P3 (a-x) (b-y) (c-z)
>     (P3 a b c) * (P3 x y z) = P3 (a*x) (b*y) (c*z)
>     negate (P3 a b c) = P3 (negate a) (negate b) (negate c)
>     abs (P3 a b c) = P3 (abs a) (abs b) (abs c)
>     signum (P3 a b c) = P3 (signum a) (signum b) (signum c)
>     fromInteger x = P3 (fromInteger x) (fromInteger x) (fromInteger x)
