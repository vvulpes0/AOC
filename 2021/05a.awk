#!/usr/bin/env awk -f
BEGIN {
	FS=",| -> "
}
($1 == $3) {
	a = ($2 < $4) ? $2 : $4
	b = ($2 < $4) ? $4 : $2
	for (i = a; i <= b; i++) {
		place[$1 "," i] += 1
	}
	next
}
($2 == $4) {
	a = ($1 < $3) ? $1 : $3
	b = ($1 < $3) ? $3 : $1
	for (i = a; i <= b; i++) {
		place[i "," $2] += 1
	}
	next
}
END {
	a = 0
	for (x in place) {
		if (place[x] > 1) {a += 1}
	}
	print a
}
