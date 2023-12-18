> import Data.List (partition)
> import Data.Set (Set)
> import qualified Data.Set as Set

> type Pos = (Int, Int)

> type Range = (Int, Int) -- Start:Len
> data Line = Horizontal {pos :: Int, range::Range}
>           | Vertical {pos :: Int, range :: Range}
>             deriving (Eq, Ord, Read, Show)
> isVertical (Vertical _ _) = True
> isVertical _ = False
> len :: Line -> Int
> len = snd . range
> ray r (Vertical _ (s, x)) = r >= s && r < s+x
> ray r (Horizontal y _) = r == y

> main :: IO ()
> main = do
>   plan <- parse <$> getContents
>   putStr "A: " >> print (partA plan)
>   putStr "B: " >> print (partB plan)

> partA, partB :: [(Char,Int,String)] -> Int
> partA p = size mins maxes dug
>     where plan = map (\(a,b,_) -> (a,b)) p
>           ((mins,maxes),dug) = dig 0 0 (0,0) plan
> partB p = size mins maxes dug
>     where plan = map (\(_,_,c) -> fixup c) p
>           ((mins,maxes),dug) = dig 0 0 (0,0) plan

> fixup :: String -> (Char, Int)
> fixup [a,b,c,d,e,f]
>     = ( "RDLU" !! (fromEnum f - fromEnum '0')
>       , read ("0x" ++ [a,b,c,d,e])
>       )

> printGrid :: Pos -> Pos -> [Pos] -> IO ()
> printGrid (minX,minY) (maxX,maxY) ps
>     = putStr $ unlines $
>       ["P1",unwords[show (maxX-minX+1),show (maxY-minY+1)]] ++
>       [ [ if (x,y) `elem` ps then '1' else '0'
>         | x <- [minX..maxX]
>         ]
>       | y <- [minY..maxY]
>       ]

> parse :: String -> [(Char,Int,String)]
> parse = map parseRow . lines
> parseRow :: String -> (Char,Int,String)
> parseRow = f . words
>     where f [[c],n,s] = (c, read n, take 6 . drop 2 $ s)
>           f _ = error "bad input"

> dig :: Int -> Int -> Pos -> [(Char,Int)] -> ((Int,Int), [Line])
> dig minY maxY _ [] = ((minY,maxY), [])
> dig minY maxY (x,y) ((c,i):xs)
>     | c == 'R' = let x' = x + i
>                  in (Horizontal y (x+1, i-1) :)
>                     <$> dig minY maxY (x',y) xs
>     | c == 'U' = let y' = y - i
>                  in (Vertical x (y', i+1) :)
>                     <$> dig (min minY y') maxY (x,y') xs
>     | c == 'L' = let x' = x - i
>                  in (Horizontal y (x'+1, i-1) :)
>                     <$> dig minY maxY (x',y) xs
>     | c == 'D' = let y' = y + i
>                  in (Vertical x (y, i+1) :)
>                     <$> dig minY (max maxY y') (x,y') xs
>     | otherwise = error "bad direction"

> size :: Int -> Int -> [Line] -> Int
> size minY maxY ls = sum (map f [minY..maxY])
>     where (vs,hs) = partition isVertical ls
>           f  = sizeR (Set.fromList vs) (Set.fromList hs)

> sizeR :: Set Line -> Set Line -> Int -> Int
> sizeR vs hs y
>     = sum . map snd .
>       merge (map expand hereH) . go . Set.toAscList
>       $ Set.filter (\v -> ray y v && ray (y-1) v) vs
>     where go (a:b:xs) = (pos a, pos b - pos a + 1) : go xs
>           go _ = []
>           hereH = Set.toAscList $ Set.filter (ray y) hs
>           merge xs [] = xs
>           merge [] zs = zs
>           merge ((x,lx):xs) ((z,lz):zs)
>               | x+lx > z+lz = add (merge (post:xs) zs)
>               | x+lx < z+lz = add (merge xs (post:zs))
>               | otherwise   = add (merge xs zs)
>               where (pre,int,post) = intersect (x,lx) (z,lz)
>                     addPre = if snd pre > 0 then (pre:) else id
>                     addInt = if snd int > 0 then (int:) else id
>                     add = addPre . addInt
>           expand x = let (a,b) = range x in (a-1,b+2)


> intersect :: Range -> Range -> (Range, Range, Range)
> intersect a b = ( (x, min lx (y-x))
>                 , (y, intend-y)
>                 , (pstart, pend-pstart))
>     where (x,lx) = min a b
>           (y,ly) = max a b
>           intend = min (y+ly) (x+lx)
>           pend   = max (x+lx) (y+ly)
>           pstart = max y intend
