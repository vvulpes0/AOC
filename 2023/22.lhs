> import Data.List (sortOn)
> import Data.Map (Map, (!))
> import qualified Data.Map as Map
> import qualified Data.Set as Set

> main :: IO ()
> main = do
>   supps <- parse <$> getContents
>   putStr "A: " >> print (partA supps)
>   putStr "B: " >> print (partB supps)

> partA, partB :: Map Brick [Brick] -> Int
> partA supps = Map.size supps - Set.size (Map.foldr f Set.empty supps)
>     where f [y] = Set.insert y
>           f _   = id
> partB supps = sum $ Map.mapWithKey (\k _ -> falls supps k) supps

> falls :: Map Brick [Brick] -> Brick -> Int
> falls m b = Map.size (Map.filter id cache) - 1
>     where cache = Map.mapWithKey go m
>           go k a
>               | k == b    = True
>               | null a    = False
>               | otherwise = all (cache !) a

> directSupp :: Map Brick [Brick] -> Map Brick [Brick]
> directSupp supps = Map.mapWithKey f supps
>     where hs = height hs supps
>           f k a = let x = hs ! k - (zc $ snd k) + (zc $ fst k) - 1
>                   in filter ((== x) . (hs !)) a

> height :: Map Brick Int -> Map Brick [Brick] -> Map Brick Int
> height hs supps = Map.mapWithKey f supps
>     where f k bs = h k + foldr max 0 (map (hs !) bs)
>           h k = zc (snd k) - zc (fst k) + 1

> below :: [Brick] -> Map Brick [Brick]
> below = Map.fromList . go . sortOn (negate . zc . snd)
>     where go (x:xs) = (x, filter (supports x) xs) : go xs
>           go _ = []

> supports :: Brick -> Brick -> Bool
> supports x y = zc (snd y) < zc (fst x) && over xc && over yc
>     where over r | r (fst x) <= r (fst y)
>                     = r (snd x) >= r (fst y)
>                  | otherwise = r (snd y) >= r (fst x)

> type Pos = (Int,Int,Int)
> type Brick = (Pos,Pos)
> xc, yc, zc :: Pos -> Int
> xc (x,_,_) = x
> yc (_,y,_) = y
> zc (_,_,z) = z
> parse :: String -> Map Brick [Brick]
> parse = directSupp . below . map parseLine . lines
> parseLine :: String -> Brick
> parseLine s = (parseCoord pre, parseCoord post)
>     where (pre,post) = drop 1 <$> break (=='~') s
>           parseCoord t = case splitOn ',' t of
>                            [x,y,z] -> (read x,read y,read z)
>                            _ -> error "bad coord"

> chop :: ([a] -> (b,[a])) -> [a] -> [b]
> chop f xs = if null xs then [] else uncurry (:) (chop f <$> f xs)
> splitOn :: Eq a => a -> [a] -> [[a]]
> splitOn x = chop (fmap (drop 1) . break (== x))
