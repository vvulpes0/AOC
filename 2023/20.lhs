> import Data.List (partition,sort)
> import Data.Map.Strict (Map, (!),(!?), adjust)
> import qualified Data.Map.Strict as Map

> data Module = FF | Conj | Other deriving (Eq, Ord, Read, Show)

> parse :: String -> Map String (Module, [String])
> parse = Map.fromList . map parseLine . lines
> parseLine :: String -> (String, (Module, [String]))
> parseLine s = case words $ filter (/= ',') s of
>                 (('%':n):_:xs) -> (n, (FF, xs))
>                 (('&':n):_:xs) -> (n, (Conj, xs))
>                 (n:_:xs)       -> (n, (Other, xs))
>                 _              -> error "bad input"

> main :: IO ()
> main = do
>   p <- parse <$> getContents
>   putStr "A: " >> print (uncurry (*) $ partA p)
>   putStr "B: " >> print (partB p)

> partA :: Map String (Module,[String]) -> (Int,Int)
> partA m = snd (iterate f (Map.empty, (0,0)) !! 1000)
>     where f (lasts, p) = let (nexts, p') = act m lasts
>                          in (nexts, psum p p')
>           psum (a,b) (c,d) = (a+c,b+d)

> partB :: Map String (Module,[String]) -> Int
> partB types = foldr lcm 1 $ map (unbits . f) chains
>     where unbits = foldr (\a b -> 2*b + fromEnum a) 0
>           chains = snd $ types Map.! "broadcaster"
>           isFF = (==FF) . fst . (Map.!) types
>           f chain = let (ff,conj) = partition (isFF) . snd
>                                     $ types Map.! chain
>                     in (not $ null conj) :
>                        case ff of
>                          [x] -> f x
>                          _   -> []


"True" will be High, "False" Low

> act :: Map String (Module,[String]) -> Map String Bool
>     -> (Map String Bool, (Int,Int))
> act types ls = go ls [(False,"broadcaster")]
>     where go lasts [] = (lasts,(0,0))
>           go lasts t@((i,x):xs)
>               = let (last', next) = act1 types lasts (i,x)
>                     (a,(p,q)) = go last' (xs++next)
>                 in (a, (if not i then p+1 else p, if i then q+1 else q))

> act1 :: Map String (Module,[String]) -> Map String Bool
>      -> (Bool,String)
>      -> (Map String Bool, [(Bool,String)])
> act1 types lasts' (input,name)
>     | typ == FF && input = (lasts, [])
>     | typ == FF = (adjust not name lasts, map ((,) b) nexts)
>     | typ == Conj && all last preds
>         = (adjust (const False) name lasts, map ((,) False) nexts)
>     | typ == Conj
>         = (adjust (const True) name lasts, map ((,) True) nexts)
>     | otherwise
>         = (adjust (const input) name lasts, map ((,) input) nexts)
>     where (typ,nexts) = maybe (Other,[]) id (types !? name)
>           lasts = Map.insertWith (flip const) name False lasts'
>           last x = Map.findWithDefault False x lasts'
>           preds = Map.keys $ Map.filter (name`elem`) (snd <$> types)
>           b = not $ last name
