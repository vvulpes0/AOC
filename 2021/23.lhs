> module Main (main) where

> import Data.Bifunctor (bimap, first)
> import Data.List (intercalate,transpose)
> import Data.Map.Lazy (Map, (!), (!?))
> import Data.Maybe (catMaybes,isNothing)
> import qualified Data.Map.Lazy as Map

> type Board = (Int,([Maybe Int],[[Int]]))

> main = interact (uncurry f . bimap doa dob . (>>= id) (,) . getRooms)
>     where f a b = unlines [show a ++ "\t" ++ show b]

> doa,dob :: [[Int]] -> Int
> doa = maybe (-1) id . solve . (,) 2 . (,) (replicate 7 Nothing)
> dob = maybe (-1) id . solve . (,) 4 . (,) (replicate 7 Nothing) . f
>     where f = zipWith g [[3,3],[2,1],[1,0],[0,2]]
>           g c = uncurry (++) . fmap (c ++) . splitAt 1

> getRooms :: String -> [[Int]]
> getRooms = filter (not . null) . map f . transpose . lines
>     where f = map (subtract (fromEnum 'A') . fromEnum)
>               . filter (`elem` "ABCD")
> 

> showBoard :: Board -> String
> showBoard (s,(h,r))
>     = unlines
>       ( [ replicate (length h' + 2) '#'
>         , '#' : map f h' ++ "#"
>         ]
>       ++ (uncurry (++)
>           (bimap (map sr') (map sr) . splitAt 1 . transpose $ map e r))
>       ++ ["  " ++ replicate (2 * length r + 1) '#' ++ "  "])
>     where f = maybe '.' (toEnum . (+ fromEnum 'A'))
>           h' = uncurry (++) . fmap (flip g r) $ splitAt 2 h
>           g [] r' = []
>           g xs [] = xs
>           g (x:xs) (r':rs) = Nothing : x : g xs rs
>           e = reverse . take s . (++ replicate s Nothing)
>               . map Just . reverse
>           sr  x = "  #" ++ intercalate "#" (map (pure . f) x) ++ "#  "
>           sr' x = "###" ++ intercalate "#" (map (pure . f) x) ++ "###"

> solved :: Board -> Bool
> solved = uncurry (&&)
>          . bimap (all isNothing) (and . zipWith (all . (==)) [0..])
>          . snd

> solve :: Board -> Maybe Int
> solve b = solve' b Map.empty ! b

> solve' :: Board -> Map Board (Maybe Int) -> Map Board (Maybe Int)
> solve' b m
>     | Map.member b m = m
>     | solved b  = Map.insert b (Just 0) m
>     | null n    = Map.insert b Nothing  m
>     | otherwise = Map.insert b c        m'
>     where n  = nextStates b
>           n'  = case filter (solved . fst) n of
>                   [] -> n
>                   xs -> filter ((<= (minimum $ map snd xs)) . snd) n
>           f (s,i) = maybe Nothing (fmap (i +)) (m' !? s)
>           c  = case catMaybes $ map f n of
>                  [] -> Nothing
>                  xs -> Just $ minimum xs
>           m' = foldr solve' m $ map fst n

> nextStates :: Board -> [(Board,Int)]
> nextStates (s,(h,r)) = nextStates' s [] ph h' r
>     where (ph, h') = first reverse $ splitAt 2 h

> nextStates' :: Int -> [[Int]] -> [Maybe Int] -> [Maybe Int] -> [[Int]]
>             -> [(Board, Int)]
> nextStates' s pr ph h r
>     = e r ++ o r
>       ++ case r of
>            (a:as) -> case h of
>                        (b:bs) -> nextStates' s (a:pr) (b:ph) bs as
>                        _ -> []
>            _ -> []
>     where e [] = []
>           e (a:as)
>               | (all . (==)) n a = lenter ++ renter
>               | otherwise = []
>               where n = length pr
>                     f = span isNothing
>                     lenter = let (b,y) = f ph
>                                  ph' = b ++ (Nothing : drop 1 y)
>                                  c = 2 * length b + 1 + s - length a
>                                      - (if length b == length ph - 1
>                                         then 1 else 0)
>                              in if [Just n] == take 1 y
>                                 then [(( s,
>                                          ( reverse ph' ++ h
>                                          , reverse pr ++ ((n:a) : as)))
>                                       , 10^n * c)]
>                                 else []
>                     renter = let (b,y) = f h
>                                  h' = b ++ (Nothing : drop 1 y)
>                                  c = 2 * length b + 1 + s - length a
>                                      - (if length b == length h - 1
>                                         then 1 else 0)
>                              in if [Just n] == take 1 y
>                                 then [(( s,
>                                          ( reverse ph ++ h'
>                                          , reverse pr ++ ((n:a) : as)))
>                                       , 10^n * c)]
>                                 else []
>           o [] = []
>           o ([]:_) = []
>           o ((a:as):bs)
>               | (all . (==)) (length pr) (a:as) = []
>               | otherwise = map (first f) x
>               where c = s - length as
>                     x = map (fmap (* (10^a)) . fmap (+ c))
>                         $ propogateWithCost ph h a
>                     f y = (s,(y, reverse pr ++ (as:bs)))

> propogateWithCost :: [Maybe Int] -> [Maybe Int] -> Int
>                   -> [([Maybe Int], Int)]
> propogateWithCost as bs x = uncurry (++)
>                             . bimap (flip zip ca) (flip zip cb)
>                             $ propogate as bs x
>     where f xs
>               | null xs   = []
>               | otherwise = xs ++ [last xs + 1]
>           ca = f $ take (length as - 1) [1,3..]
>           cb = f $ take (length bs - 1) [1,3..]

> propogate :: [Maybe Int] -> [Maybe Int] -> Int
>           -> ([[Maybe Int]], [[Maybe Int]])
> propogate as bs x = ( map reverse (propogate' bs as x)
>                     , propogate' as bs x )

> propogate' :: [Maybe Int] -> [Maybe Int] -> Int -> [[Maybe Int]]
> propogate' a [] _ = []
> propogate' a (b:bs) x
>     | isNothing b = (reverse a ++ (Just x:bs)) : propogate' (b:a) bs x
>     | otherwise   = []
