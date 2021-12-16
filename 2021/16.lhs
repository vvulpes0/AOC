> module Main where

> import Data.Bifunctor (first)

> main :: IO ()
> main = interact (f . fst . getInput)
>     where f x = unlines [show (doa x) ++ "\t" ++ show (dob x)]

> doa :: Packet -> Int
> doa = sumVersions
> dob :: Packet -> Integer
> dob = evaluate

> data Packet = Packet
>     { version :: Int
>     , pdata :: Entry
>     } deriving (Eq, Ord, Read, Show)
> data Entry = Literal Integer
>            | Operator Int Bool [Packet]
>              deriving (Eq, Ord, Read, Show)

> packets :: Entry -> [Packet]
> packets (Operator _ _ ps) = ps
> packets _ = []

> value :: Entry -> Integer
> value (Literal x) = x
> value (Operator i _ ps)
>     | i == 0 = sum vs
>     | i == 1 = product vs
>     | i == 2 = minimum vs
>     | i == 3 = maximum vs
>     | i == 5 = f (>) vs
>     | i == 6 = f (<) vs
>     | i == 7 = f (==) vs
>     | otherwise = error "undefined operator"
>     where vs = map evaluate ps
>           f g (a:b:_) = if g a b then 1 else 0

> getInput = parsePacket . concatMap bits . filter (`elem` hex)

> hex = "0123456789ABCDEF"

> bits c = reverse
>          . map ((== 1) . flip mod 2)
>          . take 4 . iterate (`div` 2)
>          . length . fst
>          $ break (== c) hex

> unbits :: Integral a => [Bool] -> a
> unbits = sum . zipWith (*) (map (2^) [0..]) . reverse . map f
>     where f x = if x then 1 else 0

> parsePacket :: [Bool] -> (Packet, [Bool])
> parsePacket bs = first (Packet (unbits v)) o
>     where (h,r)  = splitAt 6 bs
>           (v,t') = splitAt 3 h
>           t = unbits t'
>           o | t == 4 = parseLiteral r
>             | otherwise = parseOperator t r

> parseLiteral :: [Bool] -> (Entry, [Bool])
> parseLiteral bs = parseLiteral' 0 bs

> parseLiteral' :: Integer -> [Bool] -> (Entry, [Bool])
> parseLiteral' a (b : xs)
>     | b = parseLiteral' a' r
>     | otherwise = (Literal a', r)
>     where a' = 16 * a + unbits n
>           (n, r) = splitAt 4 xs

> parseOperator :: Int -> [Bool] -> (Entry, [Bool])
> parseOperator i (b : xs) = (Operator i b (fst f), snd f)
>     where f | b = uncurry parsePackets . first (Just . unbits)
>                   $ splitAt 11 xs
>             | otherwise = first (fst . parsePackets Nothing)
>                           . uncurry splitAt
>                           . first unbits
>                           $ splitAt 15 xs

> parsePackets :: Maybe Integer -> [Bool] -> ([Packet], [Bool])
> parsePackets n bs
>     | n == Just 0 || null (drop 6 bs) = ([], bs)
>     | otherwise = uncurry f
>                   (parsePackets (subtract 1 <$> n) <$> parsePacket bs)
>     where f p (ps, bs') = (p:ps, bs')

> sumVersions :: Packet -> Int
> sumVersions p = version p + sum (map sumVersions . packets $ pdata p)

> evaluate :: Packet -> Integer
> evaluate = value . pdata
