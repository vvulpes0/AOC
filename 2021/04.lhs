> module Main where

> import Data.Bifunctor (bimap)
> import Data.List (partition,transpose)
> import Data.Maybe (isJust, isNothing)

> type Board = [[Maybe Int]]

> main = interact (\s -> unlines $ map show [doa s, dob s])

> doa, dob :: String -> Int
> doa = score . head . uncurry updateSeq . parse
> dob = score . last . uncurry updateSeq . parse

> score :: (Int, [Board]) -> Int
> score (l, bs)
>     = maybe 0 id . fmap ((*l) . sum) . sequence
>       . filter (isJust) . concat . concat $ take 1 bs

> parse :: String -> ([Int], [Board])
> parse = bimap f parseBoards . splitAt 1 . lines
>     where f x = read ('[' : concat x ++ "]")

> parseBoards :: [String] -> [Board]
> parseBoards xs
>     | null xs = []
>     | otherwise = uncurry (:) $ bimap parseBoard parseBoards p
>     where p = break null $ dropWhile null xs

> parseBoard :: [String] -> Board
> parseBoard = map (map (Just . read) . words)

> won :: Board -> Bool
> won b = any (all isNothing) b || any (all isNothing) (transpose b)

> update :: Int -> Board -> Board
> update x b = map (map f) b
>     where f y = if y == Just x then Nothing else y

> updateSeq :: [Int] -> [Board] -> [(Int, [Board])]
> updateSeq [] bs = []
> updateSeq (x:xs) bs
>     | null ws = updateSeq xs bs'
>     | otherwise = (x, ws) : updateSeq xs ls
>     where (ws,ls) = partition won bs'
>           bs' = map (update x) bs
