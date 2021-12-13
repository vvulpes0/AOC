> module Main where

> import Data.List (partition,transpose)

> doa s = show $ (unbits $ gamma xs) * (unbits $ epsilon xs)
>     where xs = lines s

> dob s = show $ (unbits . debin $ o2 xs) * (unbits . debin $ co2 xs)
>     where xs = lines s

> main = interact (\s -> unlines [doa s, dob s])

> unbits = sum . map fst . filter snd . zip (map (2^) [0..]) . reverse

> epsilon = map not . gamma

> gamma = map (uncurry (>=) . ls . partition (== '1')) . transpose

> ls x = (length $ fst x, length $ snd x)

> debin = map (== '1')

> o2 xs
>     | null xs = []
>     | length xs == 1 = head xs
>     | otherwise = v : next
>     where mcv = uncurry (>=) . ls . partition (== '1') $ map head xs
>           v = if mcv then '1' else '0'
>           next = o2 . map (drop 1) $ filter ((== v) . head) xs

> co2 xs
>     | null xs = []
>     | length xs == 1 = head xs
>     | otherwise = v : next
>     where mcv = uncurry (>=) . ls . partition (== '1') $ map head xs
>           v = if mcv then '0' else '1'
>           next = co2 . map (drop 1) $ filter ((== v) . head) xs
