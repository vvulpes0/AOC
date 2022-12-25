#!/usr/bin/env awk -f
{ enc[NR-1] = $0 + 0; pred[NR-1] = NR-2; succ[NR-1] = NR }
function mix( i,j,n,x) {
	for (i = 0; i < NR; i++) {
		succ[pred[i]] = succ[i]
		pred[succ[i]] = pred[i]
		n = succ[i]
		x = 1
		j = ((enc[i]%(NR-1))+(NR-1))%(NR-1)
		if (j > (NR-1)/2) {x = 0; j = (NR-1)-j}
		for (j;j;j--) n = x ? succ[n] : pred[n]
		pred[i] = pred[n]
		succ[pred[i]] = i
		succ[i] = n
		pred[n] = i
	}
}
function ind(x) { return enc[shf[x%NR]]}
function grove() { return ind(1000)+ind(2000)+ind(3000) }
END {
	succ[NR-1] = 0
	pred[0] = NR-1
	mix()
	for (n in enc) if (enc[n] == 0) break
	for (i = 0; i < NR; i++) { shf[i] = n; n = succ[n] }
	print "A:",grove()
	for (i in enc) {
		enc[i] *= 811589153
		succ[i] = (i == (NR - 1) ? 0 : i + 1)
		pred[i] = (i == 0 ? NR - 1 : i - 1)
	}
	for (i = 0; i < 10; i++) mix()
	for (i = 0; i < NR; i++) { shf[i] = n; n = succ[n] }
	x = grove()
	b = ""
	while (x) {
		b = (x%10) b
		x = int(x/10)
	}
	print "B:",b
}
