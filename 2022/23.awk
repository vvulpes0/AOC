#!/usr/bin/env awk -f
BEGIN {
	split("224 7 148 41",test)
	split("-1 1 0 0",dr)
	split("0 0 -1 1",dc)
	FS=""
}
{ for (i = 1; i <= NF; i++) if ($i == "#") elf[NR ":" i] }
function empty(a,  i) { for (i in a) return 0; return 1 }
function attempt(r,c,nr,nc) {
	if (nr ":" nc in taker) {
		delete target[taker[nr ":" nc]]
		taker[nr ":" nc] = ""
	} else {
		target[r ":" c] = nr ":" nc
		taker[nr ":" nc] = r ":" c
	}
}
function propose(r,c,  e,i,j) {
	e = 0
	for (i = -1; i<2; i++) {
		for (j = -1; j<2; j+=1+(i==0)) e=2*e+(r+i ":" c+j in elf)
	}
	if (!e) return
	for (i = 1; i <= 4; i++) {
		j = (i-1+base)%4+1
		if (overlap(e,test[j])) continue
		attempt(r,c,r+dr[j],c+dc[j])
		break
	}
}
function overlap(a,b) {
	while (a && b) {
		if (a%2 && b%2) return 1
		a = int(a/2)
		b = int(b/2)
	}
	return 0
}
function move(  e,i) {
	delete nelf
	delete target
	delete taker
	for (e in elf) {
		split(e,tmp,":")
		propose(tmp[1],tmp[2])
	}
	for (e in elf) {
		if (!(e in target)) { nelf[e]; continue }
		if (taker[target[e]] == "") { nelf[e]; continue }
		nelf[target[e]]
	}
	delete elf
	for (e in nelf) elf[e]
	base++
}
function min(a,b) { return a=="" ? b : a < b ? a : b }
function max(a,b) { return a=="" ? b : a > b ? a : b }
END {
	for (i = 0; i < 10 && (!i || !empty(target)); i++) { move(); b++ }
	for (e in elf) {
		split(e,tmp,":")
		minr=min(minr,tmp[1])
		maxr=max(maxr,tmp[1])
		minc=min(minc,tmp[2])
		maxc=max(maxc,tmp[2])
		a++
	}
	print "A:",(maxr-minr+1)*(maxc-minc+1)-a
	while (!empty(target)) { move(); b++ }
	print "B:",b
}
