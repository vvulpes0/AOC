> import Data.Map (Map)
> import qualified Data.Map as Map

> main :: IO ()
> main = do
>   p <- parse <$> getContents
>   putStr "A: " >> print (uncurry partA p)
>   putStr "B: " >> print (uncurry partB p)

> parse :: String -> (String, Map String (String, String))
> parse s = ( cycle $ concat path
>           , Map.fromList $ map (f . filter (`notElem` "=(,)")) next)
>     where (path,next) = drop 1 <$> break null (lines s)
>           f x = case words x of
>                   [a,b,c] -> (reverse a, (reverse b,reverse c))
>                   _ -> error "bad input"

> find :: (String -> Bool) -> String -> Map String (String, String)
>      -> Integer -> String -> Integer
> find f (x:xs) m d s
>     | f s = d
>     | x == 'L' = d `seq` find f xs m (d+1) (fst $ m Map.! s)
>     | x == 'R' = d `seq` find f xs m (d+1) (snd $ m Map.! s)
>     | otherwise = error "invalid path"
> find _ [] _ _ _ = error "empty path"

> partA, partB :: String -> Map String (String, String) -> Integer
> partA path m = find (== "ZZZ") path m 0 "AAA"
> partB path m = foldr lcm 1 . map (find ((== "Z") . take 1) path m 0)
>                . filter ((== "A") . take 1) $ Map.keys m
