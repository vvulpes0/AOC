> module Main where

> import Data.IntMap.Strict (IntMap)
> import Data.List (intercalate)
> import qualified Data.IntMap.Strict as IntMap

> main = interact (unlines . pure . f . iterate tick . getRepr)
>     where f xs = intercalate "\t" $ map (show . sum . (xs!!)) [80,256]

> getRepr :: String -> [Int]
> getRepr s = map (\k -> IntMap.findWithDefault 0 k m) [0..8]
>     where ns = map read $ wordsSep "," s
>           m = foldr (\k -> IntMap.insertWith (+) k 1) IntMap.empty $ ns

> tick :: [Int] -> [Int]
> tick [] = []
> tick (x:xs) = zipWith (+) [0, 0, 0, 0, 0, 0, x, 0, 0]
>               . drop 1 $ cycle (x:xs)

> wordsSep :: String -> String -> [String]
> wordsSep s x
>     | null x = []
>     | otherwise = uncurry (:) $ wordsSep s <$> chunk (`elem` s) x
>     where chunk f = break f . dropWhile f
