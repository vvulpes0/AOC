> main :: IO ()
> main = getContents >>=
>        (\x -> putStr "A: " >> partA x >> putStr "B: " >> partB x)

> splitOn :: Char -> String -> [String]
> splitOn _ [] = []
> splitOn c s = uncurry (:) . fmap (splitOn c . drop 1) $ break (== c) s

> data Game = Game { gid :: Int, rgbs :: [(Int,Int,Int)] }
>             deriving (Eq, Ord, Read, Show)

> parseGame :: String -> Game
> parseGame s = Game { gid = read (drop 5 pre)
>                    , rgbs = map parseHand $ splitOn ';' post
>                    }
>     where (pre,post) = fmap (drop 1) $ break (== ':') s

> parseHand :: String -> (Int, Int, Int)
> parseHand s = foldr f (0,0,0) (map words $ splitOn ',' s)
>     where f (n:"red"  :_) (r,g,b) = (r + read n, g, b)
>           f (n:"green":_) (r,g,b) = (r, g + read n, b)
>           f (n:"blue" :_) (r,g,b) = (r, g, b + read n)

> valid r g b = all f . rgbs
>     where f (r', g', b') = r' <= r && g' <= g && b' <= b

> partA :: String -> IO ()
> partA = print . sum . map gid . filter (valid 12 13 14)
>         . map parseGame . lines

> optimal :: Game -> (Int, Int, Int)
> optimal = foldr f (0,0,0) . rgbs
>     where f (r,g,b) (ar,ag,ab) = (max r ar, max g ag, max b ab)

> power :: (Int, Int, Int) -> Int
> power (r,g,b) = r*g*b

> partB :: String -> IO ()
> partB = print . sum . map (power . optimal . parseGame). lines
