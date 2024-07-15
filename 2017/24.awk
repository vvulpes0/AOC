#!/usr/bin/env awk -f
BEGIN { FS = "/" }
{
	comp[NR] = $0
	N[$1] = N[$1]","NR
	if ($1 != $2) N[$2] = N[$2]","NR
	if ($1 == 0) Z[NR] = $2
	if ($2 == 0) Z[NR] = $1
	score[NR] = $1 + $2
}
function dfs(n,last,seen,max,i,T,X) {
	# print "starting dfs:",n,last,seen
	i=split(seen,X,":")
	if (i > maxlength) { delete valid; maxlength = i }
	if (i == maxlength) { valid[seen] }
	max = 0
	split(N[n],X,",")
	for (i = 1; i <= length(X); i++) {
		if (match(seen, ":" X[i] ":")) continue
		split(comp[X[i]],T,"/")
		p = T[1] == n ? T[2] : T[1]
		p = dfs(p,n,":" X[i] seen)
		max = p>max ? p : max
	}
	return max + n + last
}
function PartA(m,t) {
	m = 0
	for (i in Z) { t = dfs(Z[i],0,":"i":"); m = t>m ? t : m }
	return m
}
END {
	for (i in N) sub("^,*","",N[i])
	A = PartA()
	B = 0
	for (i in valid) {
		n = split(i,X,":")
		s = 0; for (j = 2; j <= n-1; j++) s += score[X[j]]
		B = s>B ? s : B
	}
	print A,B
}
