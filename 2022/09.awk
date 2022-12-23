#!/usr/bin/env awk -f
function abs(x) { return x < 0 ? -x : x }
function update(n,f) {
	for (n = 0; n < 10; n++) {
		if (abs(x[n] - x[n+1]) <= 1 && abs(y[n] - y[n+1]) <= 1)
			continue
		f = (x[n] != x[n+1]) && (y[n] != y[n+1])
		if (f || (x[n] == x[n+1] && abs(y[n] - y[n+1]) > 1)) {
			y[n+1] += (y[n] - y[n+1]) / abs(y[n] - y[n+1])
		}
		if (f || (y[n] == y[n+1] && abs(x[n] - x[n+1]) > 1)) {
			x[n+1] += (x[n] - x[n+1]) / abs(x[n] - x[n+1])
		}
	}
	a[x[1] "," y[1]] = 1
	b[x[9] "," y[9]] = 1
}
BEGIN { for (i = 0; i < 10; i++) { x[i] = y[i] = 0 } update() }
/R/   { for (i = 0; i < $2; i++) { x[0]++; update() } }
/U/   { for (i = 0; i < $2; i++) { y[0]--; update() } }
/L/   { for (i = 0; i < $2; i++) { x[0]--; update() } }
/D/   { for (i = 0; i < $2; i++) { y[0]++; update() } }
END {
	for (i in a) la++
	for (i in b) lb++
	printf "A: %s\nB: %s\n", la, lb
}
