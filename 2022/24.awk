#!/usr/bin/env awk -f
(NR == 1) { sr = -1; sc = index($0, ".") - 2; w = length - 2; next }
/##/ { er = NR-2; ec = index($0, ".") - 2; h = NR - 2; next }
/#/ {
	for (i = 2; i <= length - 1; i++) {
		x = substr($0,i,1)
		if      (x == ">") br[NR-2] = br[NR-2] " " ( i-2) " "
		else if (x == "<") bl[NR-2] = bl[NR-2] " " ( i-2) " "
		else if (x == "^") bu[ i-2] = bu[ i-2] " " (NR-2) " "
		else if (x == "v") bd[ i-2] = bd[ i-2] " " (NR-2) " "
	}
}
function hit(d,bs,m,db,v,  i,t,x) {
	return !!index(bs, " " ((m+(v - (d%m)*db)%m)%m) " ")
}
function extend(d,r,c,  dr,dc,i,nr,nc) {
	split("-1 0 0 0 1",dr)
	split("0 -1 0 1 0",dc)
	for (i in dr) {
		nr = r + dr[i]
		nc = c + dc[i]
		if (nc < 0 || nc >= w) continue
		if (nr < 0 || nr >= h) {
			if ((nr!=sr||nc!=sc)&&(nr!=er||nc!=ec)) continue
		}
		if (nr ":" nc in nopen) continue
		if (hit(d+1,br[nr],w, 1,nc)) continue
		if (hit(d+1,bl[nr],w,-1,nc)) continue
		if (hit(d+1,bu[nc],h,-1,nr)) continue
		if (hit(d+1,bd[nc],h, 1,nr)) continue
		nopen[nr ":" nc]
		if (nr ":" nc in distance) continue
		distance[nr ":" nc] = d + 1
	}
}
function search(d,  i,t) {
	delete nopen
	for (i in open) {
		split(i,t,":")
		extend(d,t[1],t[2])
	}
	delete open
	for (i in nopen) open[i]
}
END {
	distance[sr ":" sc] = 0
	open[sr ":" sc]
	while (!(er ":" ec in open)) search(d++)
	print "A:",d
	delete open
	open[er ":" ec]
	while (!(sr ":" sc in open)) search(d++)
	delete open
	open[sr ":" sc]
	while (!(er ":" ec in open)) search(d++)
	print "B:",d
}
