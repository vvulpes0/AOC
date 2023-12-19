main=print.(\a->(f$map reverse$a,f a)).map(map read.words).lines=<<getContents
f=sum.map g where g(x:xs)|all(==x)xs=x|True=x+g(zipWith(-)(x:xs)xs)
