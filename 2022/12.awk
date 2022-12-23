#!/usr/bin/env awk -f
function value(x) {
	if (x == "S") { sx = i; sy = NR; return value("a") }
	if (x == "E") { ex = i; ey = NR; return value("z") }
	return index("abcdefghijklmnopqrstuvwxyz",x)
}
{ for (i=1;i<=length;i++) heights[NR "," i] = value(substr($0,i,1)) }
function insert(x,y,v,i) {
	distances[y "," x] = v
	sawa = sawa || (heights[y "," x] == value("a"))
	for (i = -1; i <= 1; i += 2) {
		if ((y + i) "," x in heights) nopen[(y + i) "," x]
		if (y "," (x + i) in heights) nopen[y "," (x + i)]
	}
}
function update(i,j,mn,h,x,u,v) {
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
function empty(a, i) { for (i in a) return 0; return 1 }
END {
	insert(ex, ey, 0)
	do {
		if (!sawa) b++
		delete open
		for (i in nopen) if (!(i in distances)) open[i]
		delete nopen
		do { update() } while (!empty(open))
	} while (!empty(nopen))
	printf "A: %s\nB: %s\n", distances[sy "," sx], b
}
