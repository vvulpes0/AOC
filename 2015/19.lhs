> import Data.Bifunctor (bimap,first)
> import Data.Char (isUpper)
> import Data.List (isPrefixOf)
> import Data.Map.Strict (Map)
> import Data.Maybe (isNothing)
> import Data.Set (Set)
> import qualified Data.Map.Strict as Map
> import qualified Data.Set as Set
> main = print =<<
>        bimap (Set.size . uncurry partA . parse)
>              ( (\(tfm,target) ->
>                maybe (-1) id . Map.lookup "e"
>              $ partB tfm 0 target Map.empty)
>              . parseB)
>        . (>>= id) (,)
>        <$> getContents
> parse = bimap
>         ( Map.fromListWith (++)
>         . map ( fmap ((:[]) . drop 4)
>               . break (== ' ')))
>         (concat . drop 1)
>         . break null . lines
> parseB = bimap
>          (map ((\(a,b) -> (b,a)) . fmap (drop 4) . break (== ' ')))
>          (concat . drop 1)
>          . break null . lines
> breakElem :: String -> (String,String)
> breakElem "" = ("","")
> breakElem (x:xs) = first (x:) $ break isUpper xs
> partA :: Map String [String] -> String -> Set String
> partA tfm s
>     | null s = Set.empty
>     | otherwise = Set.fromList (map (++ rest) poss)
>                   `Set.union`
>                   Set.mapMonotonic (elem++) (partA tfm rest)
>     where (elem,rest) = breakElem s
>           poss = maybe [] id $ Map.lookup elem tfm
> contractions :: [(String,String)] -> String -> Set String
> contractions _ "" = Set.empty
> contractions tfm s@(x:rest)
>     | otherwise = Set.fromList
>                   (map (\p -> snd p ++ drop (length$fst p) s) doable)
>                   `Set.union`
>                   Set.mapMonotonic (x:) (contractions tfm rest)
>     where doable = filter ((`isPrefixOf` s) . fst) tfm

> partB :: [(String,String)] -> Int -> String ->
>          Map String Int -> Map String Int
> partB _ d "e" m = Map.insertWith min "e" d m
> partB tfm d s m
>     | "e" `Map.member` m = m -- try just bailing after first sight
>     | maybe False (d >=) cached = m
>     | otherwise = foldr (partB tfm (d+1)) m' $ contractions tfm s
>     where cached = Map.lookup s m
>           m' = Map.insertWith min s d m
