> module Main (main) where
> import Data.Bits ((.&.))
> import Data.IntMap (IntMap)
> import Data.List (foldl')
> import qualified Data.IntMap.Strict as IM

> main = do
>   steps <- splitOn ',' . concat . lines <$> getContents
>   putStr "A: " >> print (sum $ map hash steps)
>   let b = sum . map power . IM.assocs $ foldl' act IM.empty steps
>   putStr "B: " >> print b

> chop :: ([a] -> (b,[a])) -> [a] -> [b]
> chop f xs = if null xs then [] else uncurry (:) (chop f <$> f xs)

> splitOn :: Eq a => a -> [a] -> [[a]]
> splitOn x = chop (fmap (drop 1) . break (== x))

> hash :: String -> Int
> hash = foldl' (\b a -> (17*(b + fromEnum a) .&. 255)) 0

> act :: IntMap [(String,Int)] -> String -> IntMap [(String,Int)]
> act m s
>     | op == '=' = IM.insertWith insert (hash label) [(label,value)] m
>     | otherwise = IM.insertWith delete (hash label) [(label,value)] m
>     where (label,(op:v)) = break (`elem` "-=") s
>           value = read v
>           delete _ = filter ((/= label) . fst)
>           insert _ xs
>               = let (pre,post) = break ((== label) . fst) xs
>                 in case post of
>                      (_:ys) -> pre ++ (label,value) : ys
>                      _      -> (label,value) : pre

> power :: (Int, [(String,Int)]) -> Int
> power (box, ps) = sum . map (*(box+1))
>                   $ zipWith (*) (reverse $ map snd ps) [1..]
