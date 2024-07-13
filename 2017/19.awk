#!/usr/bin/env awk -f
{ grid[NR] = " " $0 " " }
END {
	grid[0] = grid[1]; gsub("."," ",grid[0]); grid[NR+1] = grid[0]
	vr = 1; vc = 0; good = 1; r = 1; c = match(grid[r],"[^ ]")
	B = 0;
	while (good) {
		B++
		x = substr(grid[r],c,1)
		if (match(x,"[a-zA-Z]")) { A = A x }
		y = substr(grid[r+vr],c+vc,1)
		if (y != " ") { r += vr; c += vc; continue }
		y = substr(grid[r+vc],c-vr,1)
		if (y != " ") {t=vr;vr=vc;vc=-t;r+=vr;c+=vc;continue}
		y = substr(grid[r-vc],c+vr,1)
		if (y != " ") {t=vr;vr=-vc;vc=t;r+=vr;c+=vc;continue}
		good = 0
	}
	print A,B
}
