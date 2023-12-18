main=print.(\a->(sum$map(f)a,sum$map(f.g)a)).lines=<<getContents
f=(\(a,b)->read[a,b]::Int).(\a->head$zip a$reverse a).filter(`elem`['1'..'9'])
g(a:b)|null b=a:b|null z=a:g b|True=snd(head z):fst(head z)++g b
       where z=filter(and.zipWith(==)(a:b++cycle"\0").fst)h
h=zip["one","two","three","four","five","six","seven","eight","nine"]['1'..]
