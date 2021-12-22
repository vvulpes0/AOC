> module Main (main) where

> import Control.Parallel.Strategies
> import Data.Bifunctor (bimap)
> import Data.List (foldl')
> import Data.Maybe (catMaybes,isNothing)

Types
=====

A Range here is a closed interval of Int.
A Cuboid is an x-, y-, and z-range in that order.

> type Range = (Int,Int)
> lo = fst
> hi = snd
> type Cuboid = (Range, Range, Range)
> xr (x,_,_) = x
> yr (_,y,_) = y
> zr (_,_,z) = z



> main = interact (uncurry f . bimap doa dob . join (,) . parse)
>     where f a b = unlines [show a ++ "\t" ++ show b]

> doa,dob :: [(Bool,Cuboid)] -> Integer
> dob = sum . map volume . go []
> doa = sum . map volume . go [] . catMaybes . map f
>     where f (b,x) = (,) b <$> overlap (r,r,r) x
>           r = (-50,50)

> roverlap :: Range -> Range -> Maybe Range
> roverlap a b
>     | uncurry (>) c = Nothing
>     | otherwise     = Just c
>     where c = (max (lo a) (lo b), min (hi a) (hi b))

> rsplit :: Range -> Range -> (Maybe Range, Maybe Range, Maybe Range)
> rsplit a b = ( join $ roverlap a <$> f (lo a) (lo b - 1)
>              , roverlap a b
>              , join $ roverlap a <$> f (hi b + 1) (hi a) )
>     where f x y = if y < x then Nothing else Just (x,y)

> overlap :: Cuboid -> Cuboid -> Maybe Cuboid
> overlap a b = (,,) <$> r xr <*> r yr <*> r zr
>     where r f = roverlap (f a) (f b)

> volume :: Cuboid -> Integer
> volume = product . map size . flip map [xr,yr,zr] . flip ($)
>     where size = fromIntegral . (+) 1 . uncurry subtract

> parse :: String -> [(Bool, Cuboid)]
> parse = map parseLine . lines

> parseLine :: String -> (Bool, Cuboid)
> parseLine = f . words . map (\c -> if elem c "=,." then ' ' else c)
>     where f (b:_:xm:xx:_:ym:yx:_:zm:zx:_)
>               = ( b == "on"
>                 , ( (read xm, read xx)
>                   , (read ym, read yx)
>                   , (read zm, read zx)))
>           f _ = error "unreadable line"

> go :: [Cuboid] -> [(Bool,Cuboid)] -> [Cuboid]
> go = flip (.) (map f) . foldl' (flip ($))
>     where f (b,x) = (if b then (x:) else id) . concatMap (csplit x)

> -- |Split the second cuboid argument based on overlap with the first.
> -- The overlapping portion is not included.
> -- If there is no overlap at all, the original is returned.
> csplit :: Cuboid -> Cuboid -> [Cuboid]
> csplit b a
>     | isNothing (overlap a b) = pure a
>     | otherwise
>         = catMaybes
>           $ ((,,) <$> xl <*> pure (yr a) <*> pure (zr a))
>           : ((,,) <$> xc <*> yl <*> pure (zr a))
>           : ((,,) <$> xc <*> yc <*> zl)
>           : ((,,) <$> xc <*> yc <*> zh)
>           : ((,,) <$> xc <*> yh <*> pure (zr a))
>           : ((,,) <$> xh <*> pure (yr a) <*> pure (zr a))
>           : []
>     where (xl,xc,xh) = rsplit (xr a) (xr b)
>           (yl,yc,yh) = rsplit (yr a) (yr b)
>           (zl,zc,zh) = rsplit (zr a) (zr b)


General utilities
=================

> join :: (Monad m) => m (m b) -> m b
> join = (>>= id)
