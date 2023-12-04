> import Data.Set (Set)
> import qualified Data.Set as Set

> type Card = (Int, (Set Int, Set Int))

> main :: IO ()
> main = do
>   (a,b) <- process 0 0 (repeat 1) . map readCard . lines <$> getContents
>   putStr "A: " >> print a
>   putStr "B: " >> print b

> process :: Int -> Integer -> [Integer] -> [Card] -> (Int, Integer)
> process a b _ [] = (a,b)
> process a b (m:ms) ((cid,(win,have)):xs)
>     | i == 0    = process a (b + m) ms' xs
>     | otherwise = process (a + 2^(i - 1)) (b + m) ms' xs
>     where i   = Set.size $ Set.intersection win have
>           ms' = let (pre,post) = splitAt i ms
>                 in map (+ m) pre ++ post

> readCard :: String -> (Int, (Set Int, Set Int))
> readCard s = ( read . concat . drop 1 $ words cid
>              , (mkset win, mkset have))
>     where (cid,part) = fmap (drop 1) $ break (== ':') s
>           (win,have) = fmap (drop 1) $ break (== '|') part
>           mkset x = Set.fromList . map read $ words x
