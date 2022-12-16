#!/usr/bin/env awk -f
BEGIN {FS="[ ,;=]*"}
{ rates[$2] = $6 }
{ tunnels[$2] = $11 }
{ for (i = 12; i <= NF; i++) tunnels[$2] = tunnels[$2] " " $i }
($6 != 0) { destinations[$2] = 2**length(destinations) }
function fill(src,n,d,  i,post) {
	split(tunnels[n], post, " ")
	distances[src ":" n] = d
	for (i in post) if (!(src ":" post[i] in distances)) nopen[post[i]]
}
function bfs(  sources,d,i,j) {
	sources["AA"];
	for (i in destinations) sources[i]
	for (i in sources) {
		d = 0
		open[i]
		do {
			for (j in open) fill(i, j, d)
			d++
			delete open
			for (j in nopen) open[j]
			delete nopen
		} while (length(open))
	}
}
function insert(p,v) { if (!(p in valves && valves[p]>=v)) valves[p]=v }
function search(loc,open,t,maxv,path,c,  d,i,j,so,v,x) {
	if (!length(open)) { if (c) insert(path, maxv); return maxv }
	x = 0
	for (i in open) {
		if (!(loc ":" i in distances)) continue
		d = distances[loc ":" i] + 1
		if (t - d < 1) { if (c) insert(path, maxv); continue }
		v = (t - d) * rates[i]
		delete so
		for (j in open) if (j != i) so[j]
		x = max(x, search(i,so,t-d,maxv+v,path+destinations[i],c))
	}
	return max(maxv, x)
}
function max(a,b) { return a > b ? a : b }
function overlap(a,b) {
	while (a && b) {
		if (a % 2 && b % 2) return 1
		a = int(a / 2)
		b = int(b / 2)
	}
	return 0
}
END {
	bfs()
	print "A:",search("AA", destinations, 30, 0, "")
	search("AA", destinations, 26, 0, "", 1)
	for (i in valves) { vv[length(vv)] = i }
	mv = length(vv)
	for (i = 0; i < mv - 1; i++) {
		for (j = i + 1; j < mv; j++ ) {
			if (overlap(vv[i],vv[j])) continue
			b = max(b, valves[vv[i]] + valves[vv[j]])
		}
	}
	print "B:",b
}
