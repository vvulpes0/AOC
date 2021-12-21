> module Main where

> import Data.Bifunctor (Bifunctor,bimap,first)
> import Data.Bool (bool)
> import Data.Map.Strict (Map)
> import qualified Data.Map.Strict as Map

> type Score = Int
> type Position = Int
> type Player = (Score, Position)
> type State = (Player, Player)

> main = interact ( unlines . pure
>                 . uncurry (++) . fmap ("\t" ++)
>                 . bimap (show . uncurry doa) (show . uncurry dob)
>                 . join (,) . bimap head (head . tail) . join (,)
>                 . map (read . last . words)
>                 . lines)

> join :: Monad m => m (m b) -> m b
> join = (>>= id)
> mboth :: Bifunctor p => (a -> b) -> p a a -> p b b
> mboth = join bimap

> doa, dob :: Int -> Int -> Integer
> doa = curry (fromIntegral . flip go rolls . mboth ((,) 0))
> dob = curry ( uncurry max . mboth (sum . Map.elems)
>             . Map.partitionWithKey (flip (const ((> 20) . fst . fst)))
>             . tick True . flip Map.singleton 1 . mboth ((,) 0))

> rolls :: [Int]
> rolls = cycle [1..100]
> go :: State -> [Int] -> Int
> go = fmap ( uncurry (*)
>           . bimap ((3 *) . length) (uncurry min . mboth fst . last)
>           . join (,)
>           . takeWhile (uncurry (&&) . mboth ((<1000) . fst)))
>      . flip ( flip (scanl (flip ($)))
>             . zipWith (flip ($)) (cycle [True,False])
>             . map (flip score . sum . take 3)
>             . iterate (drop 3))

> tick :: Bool -> Map State Integer -> Map State Integer
> tick = flip ( either const h
>             . fmap (uncurry (fmap . Map.unionWith (+)))
>             . fmap (fmap ( (Map.fromListWith (+) .)
>                          . flip (concatMap . g)))
>             . uncurry (bool Right (Left . fst))
>             . first (null . snd) . join (,)
>             . fmap Map.assocs
>             . Map.partitionWithKey f)
>     where f = const . uncurry (||) . mboth ((>20) . fst)
>           g = (flip map [(3,1),(4,3),(5,6),(6,7),(7,6),(8,3),(9,1)] .)
>               . (flip <$> (uncurry bimap .) . flip bimap (*) . score)
>           h = (uncurry ($) .) . flip (.) (join (,)) . uncurry bimap
>               . (,) (tick . not)

> score :: Bool -> Int -> State -> State
> score = uncurry bool . bimap (fmap.) (first.) $ join (,)
>         ( fmap (uncurry first . fmap (join (,))) . bimap (+)
>         . fmap ((+ 1) . flip mod 10 . subtract 1) . (+))
