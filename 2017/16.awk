#!/usr/bin/env awk -f
BEGIN {
	RS = "[,\n]"
	split("bcdefghijklmnop",X,"")
	X[0]="a"
	p = length(X)
}
{ D[NR] = $0 }
function dance(i,j,n,s) {
	for (j = 1; j <= NR; j++) {
		s = D[j]
		action = substr(s,1,1)
		if (action == "s") {
			base = (((base - substr(s,2))%p)+p)%p
		} else if (action == "x") {
			split(substr(s,2),n,"/")
			t = X[(base+n[1])%p]
			X[(base+n[1])%p] = X[(base+n[2])%p]
			X[(base+n[2])%p] = t
		} else if (action == "p") {
			split(substr(s,2),n,"/")
			for (i = 0; i < p; i++) {
				     if (X[i] == n[1]) X[i] = n[2]
				else if (X[i] == n[2]) X[i] = n[1]
			}
		}
	}
}
function stand(i,s) {
	s = ""
	for (i = 0; i < p; i++) { s = s X[(base+i)%p] }
	return s
}
END {
	cache[stand()] = n++
	dance()
	printf "%s\t",stand()
	while (!(stand() in cache)) { cache[stand()] = n++; dance() }
	cyc = n - cache[stand()]
	for (i=(1000000000-cache[stand()])%cyc; i > 0; i--) { dance() }
	print stand()
}
