#!/usr/bin/env awk -f
function value(x) {
	if (x == "S") { sx = i; sy = NR; return value("a") }
	if (x == "E") { ex = i; ey = NR; return value("z") }
	return index("abcdefghijklmnopqrstuvwxyz",x)
}
function min(a,b) { return a < b ? a : b }
function max(a,b) { return a > b ? a : b }
{
	for (i=1;i<=length;i++) {
		v = value(substr($0,i,1))
		heights[NR "," i] = v
		q = " "
		if (substr($0,i,1) == "S") q = "\033[38;5;255mS"
		if (substr($0,i,1) == "E") q = "\033[38;5;232mE"
	}
}
function insert(x,y,v,i) {
	distances[y "," x] = v
	for (i = -1; i <= 1; i += 2) {
		if ((y + i) "," x in heights) nopen[(y + i) "," x]
		if (y "," (x + i) in heights) nopen[y "," (x + i)]
	}
}
function update(i,j,mn,h,x,u,v,s,c) {
	for (j in open) { delete open[j]; break }
	i = int(j)
	sub("[0-9]*,","",j)
	mn = -1
	h = heights[i "," j] + 1
	for (u = 0; u <= 1; u++) {
		for (v = -1; v <= 1; v += 2) {
			x = u ? i "," (j + v) : (i + v) "," j
			if (!(x in heights && x in distances)) continue
			if (heights[x] > h) continue
			x = distances[x] + 1
			mn = (mn < 0 || x < mn) ? x : mn
		}
	}
	if (mn < 0) return
	x = i "," j
	if (!(x in distances) || mn < distances[x]) insert(j, i, mn)
}
END {
	insert(ex, ey, 0)
	do {
		delete open
		for (i in nopen) if (!(i in distances)) open[i]
		delete nopen
		do { update() } while (length(open))
		m++
	} while (length(nopen))
	printf "P6\n%d %d\n%d\n", length, NR, m
	for (i = 1; i <= NR; i++) {
		for (j = 1; j <= length; j++) {
			r = 255; g = 0
			b = heights[i "," j] - value("a")
			z = value("z") - value("a")
			b = int((b*m + z/2) / z)
			if (i "," j in distances){r=0;g=m-distances[i "," j]}
			if (m > 255) printf "%c", int(r / 256)
			printf "%c", r % 256
			if (m > 255) printf "%c", int(g / 256)
			printf "%c", g % 256
			if (m > 255) printf "%c", int(b / 256)
			printf "%c", b % 256
		}
	}
}
