> import Data.Ratio
> import Data.Map.Lazy (Map, (!))
> import qualified Data.Map.Lazy as Map

Avoid Data.Complex because you can't add Complex Rational there
and I don't want floats!

> data Complex a = a :+ a deriving (Eq, Ord, Read, Show)
> realPart,imagPart :: Complex a -> a
> realPart (a :+ _) = a
> imagPart (_ :+ b) = b

> instance Num a => Num (Complex a) where
>     a + b = (realPart a + realPart b) :+ (imagPart a + imagPart b)
>     a - b = (realPart a - realPart b) :+ (imagPart a - imagPart b)
>     a * b = (realPart a * realPart b - imagPart a * imagPart b)
>             :+ (realPart a * imagPart b + imagPart a * realPart b)
>     negate a = negate (realPart a) :+ negate (imagPart a)
>     abs a = error "unimplemented"
>     signum a = error "unimplemented"
>     fromInteger a = fromInteger a :+ 0
> instance Fractional a => Fractional (Complex a) where
>     (a :+ b) / (c :+ d) =
>         ((a*c + b*d)/(c*c+d*d)) :+ ((b*c-a*d)/(c*c+d*d))
>     fromRational x = fromRational x :+ 0

> main :: IO ()
> main = out =<< (f . parse) <$> getContents
>     where f m = ( (toInteger . round . realPart . (! "root")
>                   $ interpret m)
>                 , (g . (! "root") . interpret
>                   . Map.insert "root" rm
>                   $ Map.insert "humn" (Leaf (0 :+ 1)) m)
>                 )
>               where rm = case (m ! "root") of
>                            Tree a b _ -> Tree a b (-)
>                            _ -> Leaf 0
>           g x = toInteger . round . negate $ realPart x / imagPart x
>           out (a,b) = putStr $ unlines ["A: "++show a,"B: "++show b]

> type N = Complex Rational
> data Tree = Leaf N | Tree String String (N -> N -> N)

> interpret :: Map String Tree -> Map String N
> interpret m = m'
>     where m' = Map.map eval m
>           eval (Leaf n) = n
>           eval (Tree a b o) = o (m' ! a) (m' ! b)

> parse :: String -> Map String Tree
> parse = Map.fromList . map parseLine . lines . filter (/= ':')

> parseLine :: String -> (String, Tree)
> parseLine s = case words s of
>                 (n : a : "+" : b : _) -> (n, Tree a b (+))
>                 (n : a : "-" : b : _) -> (n, Tree a b (-))
>                 (n : a : "*" : b : _) -> (n, Tree a b (*))
>                 (n : a : "/" : b : _) -> (n, Tree a b (/))
>                 (n : a : o : b : _) -> error "unknown operator"
>                 (n : i : _) -> (n, Leaf . fromIntegral $ read i)
>                 _ -> error "unknown line type"
