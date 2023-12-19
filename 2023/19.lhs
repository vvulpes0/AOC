> module Main (main) where
> import Data.Bifunctor (bimap)
> import Data.Char (isDigit)
> import Data.Map (Map)
> import qualified Data.Map as Map

> type XMAS = (Int, Int, Int, Int)
> type Range = (Int,Int)
> type XMASR = (Range,Range,Range,Range)

> main :: IO ()
> main = do
>   (m,xs) <- parse <$> getContents
>   putStr "A: " >> print (partA m xs)
>   putStr "B: " >> print (partB m)

> partA :: Map String [(Maybe (Int,Bool,Int), Either Bool String)]
>       -> [XMAS] -> Int
> partA m = sum . map sumup . filter (act m "in")

> act :: Map String [(Maybe (Int,Bool,Int), Either Bool String)]
>     -> String -> XMAS -> Bool
> act m s x = go (m Map.! s)
>     where go [] = error "out of steps"
>           go ((f,out):rest)
>               | getOp f x = case out of
>                               Left  b -> b
>                               Right t -> act m t x
>               | otherwise = go rest

> partB :: Map String [(Maybe (Int,Bool,Int), Either Bool String)] -> Int
> partB m = actB m "in" ((1,4000),(1,4000),(1,4000),(1,4000))

> actB :: Map String [(Maybe (Int,Bool,Int), Either Bool String)]
>      -> String -> XMASR -> Int
> actB m s = go (m Map.! s)
>     where go [] _ = error "out of steps in B"
>           go ((f,out):rest) x
>               = case f of
>                   Nothing
>                       -> case out of
>                            Left b  -> if b then countupR x else 0
>                            Right t -> actB m t x
>                   Just (i,b,n)
>                       -> let (sat,unsat) = splitFor i b n x
>                          in maybe 0 (go rest) unsat
>                             + case out of
>                                 Left True  -> maybe 0 countupR sat
>                                 Left False -> 0
>                                 Right t    -> maybe 0 (actB m t) sat

> splitFor :: Int -> Bool -> Int -> XMASR -> (Maybe XMASR, Maybe XMASR)
> splitFor i b n (ar,br,cr,dr)
>     | i == 1    = go (\r -> (r,br,cr,dr)) ar
>     | i == 2    = go (\r -> (ar,r,cr,dr)) br
>     | i == 3    = go (\r -> (ar,br,r,dr)) cr
>     | otherwise = go (\r -> (ar,br,cr,r)) dr
>     where go g r = bimap (fmap g) (fmap g) $ f r
>           f (x,y)
>               | b = ( if y > n then Just (max x (n+1), y) else Nothing
>                     , if x <= n then Just (x, min y n) else Nothing
>                     )
>               | otherwise
>                   = ( if x < n then Just (x, min y (n-1)) else Nothing
>                     , if y >= n then Just (max x n, y) else Nothing
>                     )

> parse :: String -> ( Map String [(Maybe (Int,Bool,Int)
>                                  , Either Bool String)]
>                    , [XMAS])
> parse = bimap (Map.fromList . map workflow) (map ratings . drop 1)
>         . break null . lines

> workflow :: String ->
>             (String, [(Maybe (Int,Bool,Int),Either Bool String)])
> workflow s = (name, map f steps)
>     where (name,s') = fmap (init . drop 1) $ break (== '{') s
>           steps = splitOn ',' s'
>           g "A" = Left True
>           g "R" = Left False
>           g  w  = Right w
>           f x = case drop 1 <$> break (== ':') x of
>                   (w,[]) -> (Nothing, g w)
>                   (t,action) -> (Just $ parseStep t, g action)

> parseStep :: String -> (Int,Bool,Int)
> parseStep (d:op:n) = (readD d, op == '>', read n)
>     where readD 'x' = 1
>           readD 'm' = 2
>           readD 'a' = 3
>           readD  _  = 4
> parseStep _ = error "bad step"

> getOp :: Maybe (Int, Bool, Int) -> XMAS -> Bool
> getOp (Just (p, b, n)) = (if b then (<) else (>)) n . (parts!!(p-1))
>     where parts = [four1, four2, four3, four4]
> getOp _ = const True

> ratings :: String -> XMAS
> ratings z = (read x, read m, read a, read s)
>     where (x,z')   = span isDigit $ dropWhile (not . isDigit) z
>           (m,z'')  = span isDigit $ dropWhile (not . isDigit) z'
>           (a,z''') = span isDigit $ dropWhile (not . isDigit) z''
>           (s,_)    = span isDigit $ dropWhile (not . isDigit) z'''

> four1, four2, four3, four4 :: (a,a,a,a) -> a
> four1 (a,_,_,_) = a
> four2 (_,a,_,_) = a
> four3 (_,_,a,_) = a
> four4 (_,_,_,a) = a
> sumup :: XMAS -> Int
> sumup (a,b,c,d) = a+b+c+d
> countupR :: XMASR -> Int
> countupR (ar,br,cr,dr) = (c ar*c br * c cr * c dr)
>     where c (x,y) = y - x + 1

> chop :: ([a] -> (b,[a])) -> [a] -> [b]
> chop f xs = if null xs then [] else uncurry (:) (chop f <$> f xs)
> splitOn :: Eq a => a -> [a] -> [[a]]
> splitOn x = chop (fmap (drop 1) . break (==x))
