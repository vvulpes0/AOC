> import Data.List (partition)
> import Data.Ratio

> main :: IO ()
> main = do
>   p <- parse <$> getContents
>   putStr "A: " >> print (partA p)
>   putStr "B: " >> print (partB p)

> parse :: String -> [((Int,Int,Int),(Int,Int,Int))]
> parse = map parseLine . lines
> parseLine :: String -> ((Int,Int,Int),(Int,Int,Int))
> parseLine s = (pos,vel)
>     where (pre,post) = drop 1 <$> break (== '@') s
>           f = read . fst . break (==',')
>           pos = case words pre of
>                   [x,y,z] -> (f x, f y, f z)
>                   _ -> error "bad position"
>           vel = case words post of
>                   [x,y,z] -> (f x, f y, f z)
>                   _ -> error "bad velocity"

> partA :: [((Int,Int,Int),(Int,Int,Int))] -> Int
> partA = length . filter inRange
>         . map (\(a,b) -> intersectXY (xy a) (xy b)) . pairs
>     where xy ((a,b,_),(d,e,_)) = ((a,b),(d,e))
>           inRange = maybe False (\a -> test (fst a) && test (snd a))
>           test a = a>=200000000000000 && a<=400000000000000

> partB :: [((Int,Int,Int),(Int,Int,Int))] -> Int
> partB = floor . sum . take 3 . column 6 . rref . eqnset

> pairs :: [a] -> [(a,a)]
> pairs [] = []
> pairs (x:xs) = map ((,)x) xs ++ pairs xs

> intersectXY :: ((Int,Int),(Int,Int)) -> ((Int,Int),(Int,Int))
>             -> Maybe (Rational,Rational)
> intersectXY ((x1,y1),(vx1,vy1)) ((x2,y2),(vx2,vy2))
>     | denom == 0     = Nothing
>     | t < 0 || u < 0 = Nothing
>     | otherwise      = Just ( fromIntegral x1 + t*fromIntegral vx1
>                             , fromIntegral y1 + t*fromIntegral vy1)
>     where denom = fromIntegral (vx1*vy2 - vy1*vx2)
>           t = (fromIntegral ((x2-x1)*vy2 - (y2-y1)*vx2)/denom)
>           u = (fromIntegral ((x2-x1)*vy1 - (y2-y1)*vx1)/denom)

> eqnset :: [((Int,Int,Int),(Int,Int,Int))] -> [[Rational]]
> eqnset (t:x:y:z:_) = concatMap (eqns t) [x,y,z]
>     where eqns ((px0,py0,pz0),(vx0,vy0,vz0))
>                ((px1,py1,pz1),(vx1,vy1,vz1))
>               = map (map (\a -> fromIntegral a % 1))
>                 [ [ vy0-vy1, vx1-vx0, 0, py1-py0, px0-px1, 0
>                   , px0*vy0 - px1*vy1 - py0*vx0 + py1*vx1 ]
>                 , [ 0, vz0-vz1, vy1-vy0, 0, pz1-pz0, py0-py1
>                   , py0*vz0 - py1*vz1 - pz0*vy0 + pz1*vy1 ]
>                 ]

A solver for a set of linear equations:

> rref :: (Eq a, Fractional a) => [[a]] -> [[a]]
> rref xs = foldr rref' xs . reverse . zipWith const [0..]
>           . concat $ take 1 xs

> rref' :: (Eq a, Fractional a) => Int -> [[a]] -> [[a]]
> rref' n xs
>     | null $ drop n xs = xs
>     | otherwise = splatter n . divrow n $ roll n n xs

> roll :: (Eq a, Num a) => Int -> Int -> [[a]] -> [[a]]
> roll _ _ [] = []
> roll n 0 (x:xs)
>     | x !! n /= 0 = x:xs
>     | otherwise = nz ++ x:z
>     where (nz, z) = partition ((/= 0) . (!!n)) xs
> roll n m (x:xs) = x : roll n (m-1) xs

> divrow :: (Eq a, Fractional a) => Int -> [[a]] -> [[a]]
> divrow _ [] = []
> divrow 0 (x:xs)
>     = case filter (/= 0) x of
>         (p:_) -> map (/p) x : xs
>         _     -> x:xs
> divrow n (x:xs) = x : divrow (n-1) xs

> splatter :: (Eq a, Fractional a) => Int -> [[a]] -> [[a]]
> splatter n xs
>     | x!!n == 0 = xs
>     | otherwise = map reduce pre ++ x : map reduce post
>     where (pre,(x:post)) = splitAt n xs
>           reduce row = let m = row!!n / x!!n
>                        in zipWith (\a b -> a - m*b) row x

> column :: Int -> [[a]] -> [a]
> column n = concatMap (take 1 . drop n)
