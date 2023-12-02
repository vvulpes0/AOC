> main :: IO ()
> main = getContents >>=
>        (\x -> putStr "A: " >> partA x >> putStr "B: " >> partB x)

> partA :: String -> IO ()
> partA s = print . sum . map f $ lines s
>     where f xs = let digits = filter (`elem` "0123456789") xs
>                  in case zip digits (reverse digits) of
>                       ((a,b):_) -> read [a,b] :: Integer
>                       _ -> 0

> partB :: String -> IO ()
> partB s = print . sum . map f $ lines s
>     where f xs = let digits = emitDigits xs
>                  in case zip digits (reverse digits) of
>                       ((a,b):_) -> 10*a + b
>                       _ -> 0

> emitDigits :: String -> [Int]
> emitDigits xs@('o':'n':'e':_) = 1 : emitDigits (drop 1 xs)
> emitDigits xs@('t':'w':'o':_) = 2 : emitDigits (drop 1 xs)
> emitDigits xs@('t':'h':'r':'e':'e':_) = 3 : emitDigits (drop 1 xs)
> emitDigits xs@('f':'o':'u':'r':_) = 4 : emitDigits (drop 1 xs)
> emitDigits xs@('f':'i':'v':'e':_) = 5 : emitDigits (drop 1 xs)
> emitDigits xs@('s':'i':'x':_) = 6 : emitDigits (drop 1 xs)
> emitDigits xs@('s':'e':'v':'e':'n':_) = 7 : emitDigits (drop 1 xs)
> emitDigits xs@('e':'i':'g':'h':'t':_) = 8 : emitDigits (drop 1 xs)
> emitDigits xs@('n':'i':'n':'e':_) = 9 : emitDigits (drop 1 xs)
> emitDigits (x:xs)
>     | x `elem` "0123456789" = read [x] : emitDigits xs
>     | otherwise = emitDigits xs
> emitDigits _ = []
