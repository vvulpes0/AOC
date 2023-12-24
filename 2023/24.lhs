> main :: IO ()
> main = do
>   p <- parse <$> getContents
>   putStr "A: " >> print (partA p)

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

> pairs :: [a] -> [(a,a)]
> pairs [] = []
> pairs (x:xs) = map ((,)x) xs ++ pairs xs

> intersectXY :: ((Int,Int),(Int,Int)) -> ((Int,Int),(Int,Int))
>             -> Maybe (Double,Double)
> intersectXY ((x1,y1),(vx1,vy1)) ((x2,y2),(vx2,vy2))
>     | denom == 0     = Nothing
>     | t < 0 || u < 0 = Nothing
>     | otherwise      = Just ( fromIntegral x1 + t*fromIntegral vx1
>                             , fromIntegral y1 + t*fromIntegral vy1)
>     where denom = fromIntegral (vx1*vy2 - vy1*vx2)
>           t = (fromIntegral ((x2-x1)*vy2 - (y2-y1)*vx2)/denom)
>           u = (fromIntegral ((x2-x1)*vy1 - (y2-y1)*vx1)/denom)
