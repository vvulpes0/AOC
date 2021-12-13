#!/usr/bin/env awk -f
/,/ { p[$0] = $0 }

/fold/ {
	numfolds = numfolds + 1
	split($0,z,"=")
	b = match($0,/x/) ? 1 : 2
	for (i in p) {
		split(i,y,",")
		if (y[b] > z[2]) {
			y[b] = 2 * z[2] - y[b]
		}
		a = y[1] "," y[2]
		delete p[i]
		p[a] = a
	}
	if (numfolds == 1) {
		print length(p) > "/dev/stderr"
	}
}

END {
	for (i in p) {
		split(i,x,",")
		mx = (x[1] > mx) ? x[1] : mx
		my = (x[2] > my) ? x[2] : my
	}
	printf "P2\n%d %d\n1\n",mx + 1,my + 1
	for (i=0; i <= my; ++i) {
		for (j=0; j <= mx; ++j) {
			printf "%d ", ((j "," i) in p) ? 1 : 0
		}
		printf "\n"
	}
}
