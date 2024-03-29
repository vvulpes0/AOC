#!/usr/bin/env awk -f
(NR == 1) { ncols = length }
(/./||/#/) {
	for (i = 1; i <= length; i++) {
		x = substr($0,i,1)
		if (x != "." && x != "#") continue
		dot[NR ":" i]
		sa++
		if (!(NR in cmn)) cmn[NR] = i
		if (!(i in rmn)) rmn[i] = NR
		cmx[NR] = i
		rmx[i] = NR
		if (x != "#") continue
		wall[NR ":" i]
	}
	nrows++
}
function move(i, nr,nc) {
	for (i; i; i--) {
		nc = c + (f == 0) - (f == 2)
		nr = r + (f == 1) - (f == 3)
		if (nc < cmn[r]) { nc = cmx[r] }
		if (nc > cmx[r]) { nc = cmn[r] }
		if (nr < rmn[c]) { nr = rmx[c] }
		if (nr > rmx[c]) { nr = rmn[c] }
		if (nr ":" nc in wall) return
		c = nc
		r = nr
	}
}
function trywrap(d,d1,d2,r,c,  x,p,t) {
	if (!(d1 ":" r ":" c in out)) return 0
	p = out[d1 ":" r ":" c]
	t = (face[d1 ":" r ":" c] + d2) % 4
	if (!(t ":" p in out)) return 0
	x = p
	p = out[t ":" p]
	t = face[t ":" x]
	out[d ":" r ":" c] = p
	face[d ":" r ":" c] = (t+2+d2) % 4
	out[(t+d2)%4 ":" p] = r ":" c
	face[(t+d2)%4 ":" p] = (d + 2) % 4
	changed = 1
	return 1
}
function foldnet(r,c,  i,done,dc,dr,p) {
	for (i = 0; i < 4; i++) {
		dc = (i == 0) - (i == 2)
		dr = (i == 1) - (i == 3)
		p = (r+dr) ":" (c+dc)
		if (!(i ":" r ":" c in out)) {
			done = 0
			if (p in present) {
				changed = done = 1
				out[i ":" r ":" c] = p
				face[i ":" r ":" c] = i
				out[(i+2)%4 ":" p] = r ":" c
				face[(i+2)%4 ":" p] = (i+2)%4
			}
			if (!done) done = trywrap(i,(i+3)%4,1,r,c)
			if (!done) done = trywrap(i,(i+1)%4,3,r,c)
		}
	}
}
function move3(i, ncr,ncc,nr,nc,nf,tmp) {
	for (i; i; i--) {
		ncr = cellr; ncc = cellc; nf = f3
		nc = c3 + (f3 == 0) - (f3 == 2)
		nr = r3 + (f3 == 1) - (f3 == 3)
		if (nc <= 0) {
			nf = face[2 ":" cellr ":" cellc]
			split(out[2 ":" cellr ":" cellc],tmp,":")
			ncr = tmp[1]; ncc = tmp[2]
			if      (nf == 0) { nc = 1; nr = size+1-nr }
			else if (nf == 1) { nc = nr; nr = 1 }
			else if (nf == 2) { nc = size }
			else              { nc = size+1-nr; nr = size }
		} else if (nc > size) {
			nf = face[0 ":" cellr ":" cellc]
			split(out[0 ":" cellr ":" cellc],tmp,":")
			ncr = tmp[1]; ncc = tmp[2]
			if      (nf == 0) { nc = 1 }
			else if (nf == 1) { nc = size+1-nr; nr = 1 }
			else if (nf == 2) { nc = size; nr = size+1-nr }
			else              { nc = nr; nr = size }
		} else if (nr <= 0) {
			nf = face[3 ":" cellr ":" cellc]
			split(out[3 ":" cellr ":" cellc],tmp,":")
			ncr = tmp[1]; ncc = tmp[2]
			if      (nf == 0) { nr = nc; nc = 1 }
			else if (nf == 1) { nc = size+1-nc; nr = 1 }
			else if (nf == 2) { nr = size+1-nc; nc = size }
			else              { nr = size }
		} else if (nr > size) {
			nf = face[1 ":" cellr ":" cellc]
			split(out[1 ":" cellr ":" cellc],tmp,":")
			ncr = tmp[1]; ncc = tmp[2]
			if      (nf == 0) { nr = size+1-nc; nc = 1 }
			else if (nf == 1) { nr = 1 }
			else if (nf == 2) { nr = nc; nc = size }
			else              { nc = size+1-nc; nr = size }
		}
		if ((ncr*size + nr) ":" (ncc*size + nc) in wall) return
		cellc = ncc
		cellr = ncr
		c3 = nc
		r3 = nr
		f3 = nf
	}
}
END {
	size = sqrt(sa / 6)
	for (i in dot) {
		split(i,p,":")
		present[int((p[1]-1)/size) ":" int((p[2]-1)/size)]
	}
	delete dot
	do {
		changed = 0
		for (i in present) { split(i,p,":"); foldnet(p[1],p[2]) }
	} while (changed)

	c = cmn[1]; r = rmn[c]; f = 0
	cellr = (r-1)/size
	cellc = (c-1)/size
	r3 = c3 = 1
	moves = $0
	x = int(moves)
	move(x); move3(x)
	sub("^[0-9][0-9]*","",moves)
	while (moves != "") {
		x = substr(moves,1,1)
		f += (x == "R") + 3*(x == "L")
		f %= 4
		f3 += (x == "R") + 3*(x == "L")
		f3 %= 4
		sub(".","",moves)
		x = int(moves)
		move(x); move3(x)
		sub("^[0-9][0-9]*","",moves)
	}
	print "A:",1000*r + 4*c + f
	print "B:",1000*(cellr*size+r3) + 4*(cellc*size+c3) + f3
}
