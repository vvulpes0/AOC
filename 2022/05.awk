#!/usr/bin/env awk -f
function move(c,n,s,d) {
	x    = substr(c[s],1,n)
	c[s] = substr(c[s],n + 1)
	c[d] = x c[d]
}
/]/ {
	n = (1+length)/4
	for (i = 1; i <= n; i++) {
		x = substr($0,4*(i-1)+2,1)
		if (x != " ") {
			crates[i] = cratesb[i] = crates[i] x
		}
	}
}
/move/ {
	for (i = 0; i < $2; i++) move(crates, 1, $4,$6)
	move(cratesb, $2, $4, $6)
}
END {
	for (i = 1; i <= length(crates); i++) {
		a = a substr(crates[i],1,1)
		b = b substr(cratesb[i],1,1)
	}
	printf "A: %s\nB: %s\n", a, b
}
