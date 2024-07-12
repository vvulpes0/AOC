#!/usr/bin/env awk -f
BEGIN { FS="[ ()>,-][ ()>,-]*" }
{
	weights[$1] = $2
	children[$1] = NF - 2 - (NF == 3)
	for (i = 3; NF != 3 && i <= NF; i++) {
		parent[$i] = $1
		children[$1 "," (i-3)] = $i
	}
}
function weight(x,i,s) {
	if (x in cache) return cache[x]
	s = weights[x]
	for (i = 0; i < children[x]; i++) {
		s += weight(children[x "," i])
	}
	cache[x] = s
	return s
}
function fix(r,i,m,w) {
	for (i = 0; i < children[r]; i++) {
		m[weight(children[r "," i])]++
	}
	w = -1
	for (i in m) { if (m[i] == 1) { w = i ; break } }
	if (w < 0) {
		w = weight(parent[r]) - weight(r) - weights[parent[r]]
		w /= children[parent[r]] - 1
		for (i in m) { w -= i * m[i] }
		return w
	}
	for (i = 0; i < children[r]; i++) {
		if (weight(children[r "," i]) == w) break
	}
	return fix(children[r "," i])
}
END {
	for (i in parent) { break }
	while (i in parent) { i = parent[i] }
	print i, fix(i)
}
