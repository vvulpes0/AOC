#!/usr/bin/env awk -f
{
	sub("^#","",$0)
	gsub(":","",$0)
	split($3,P,",")
	split($4,S,"x")
	C[$1] = P[1]" "P[2]" "S[1]" "S[2]
	for (i = 0; i < S[1]; i++) {
		for (j = 0; j < S[2]; j++) {
			F[(P[1]+i)","(P[2]+j)] += 1
		}
	}
	
}
function overlap(p1,len1,p2,len2) {
	if (p1 > p2) return overlap(p2,len2,p1,len1)
	return p1+len1 > p2
}
function PartA(a,i) {
	# at this input size, brute-force is feasible
	# and simpler than computing overlaps
	# and splitting remainders back into rects
	a = 0;
	for (i in F) a += F[i]>1
	return a
}
function PartB(i,j,m,P,T,X,Y) {
	for (i in C) P[i]
	for (i = 2; i <= NR; i++) {
		split(C[i],X)
		killed = 0
		for (j = 1; j < i; j++) {
			split(C[j],Y)
			if (!overlap(X[1],X[3],Y[1],Y[3])) continue
			if (!overlap(X[2],X[4],Y[2],Y[4])) continue
			delete P[j]
			killed = 1
		}
		if (killed) delete P[i]
	}
	for (i in P) break
	return i
}
END {
	print PartA(),PartB()
}
