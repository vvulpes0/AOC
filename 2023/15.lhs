> module Main (main) where
> import Data.Bits ((.&.))
> import Data.Foldable (toList)
> import Data.IntMap (IntMap)
> import Data.List (foldl')
> import Data.Sequence (Seq, ViewL(..), (<|), (|>))
> import qualified Data.IntMap.Strict as IM
> import qualified Data.Sequence as Seq

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

> act :: IntMap (Seq (String,Int)) -> String -> IntMap (Seq (String,Int))
> act m s
>     | op == '=' = IM.insertWith insert (hash label) lv m
>     | otherwise = IM.insertWith delete (hash label) lv m
>     where (label,(op:v)) = break (`elem` "-=") s
>           value = read v
>           lv = pure (label, value)
>           delete _ = Seq.filter ((/= label) . fst)
>           insert _ xs
>               = let (pre,post) = Seq.breakl ((== label) . fst) xs
>                 in case Seq.viewl post of
>                      (_ :< ys) -> pre <> ((label,value) <| ys)
>                      _         -> pre |> (label,value)

> power :: (Int, Seq (String,Int)) -> Int
> power (box, ps)
>     = sum $ Seq.mapWithIndex (\a b -> (a+1)*b*(box+1)) (snd <$> ps)
