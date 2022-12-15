#!/usr/bin/env awk -f
function value(x) {
	if (x == "S") { sx = i; sy = NR; return value("a") }
	if (x == "E") { ex = i; ey = NR; return value("z") }
	return index("abcdefghijklmnopqrstuvwxyz",x)
}
function min(a,b) { return a < b ? a : b }
function max(a,b) { return a > b ? a : b }
BEGIN{printf "\033[H\033[J"}
{
	for (i=1;i<=length;i++) {
		v = value(substr($0,i,1))
		heights[NR "," i] = v
		q = " "
		if (substr($0,i,1) == "S") q = "\033[38;5;255mS"
		if (substr($0,i,1) == "E") q = "\033[38;5;232mE"
		printf "\033[48;5;%dm%s", min(255,max(232,v+230)), q
	}
	printf "\n"
}
function insert(x,y,v,i) {
	distances[y "," x] = v
	printf "\033[%d;%dH",y,x
	printf "\033[3"
	for (i = -1; i <= 1; i += 2) {
		if ((y + i) "," x in heights) nopen[(y + i) "," x]
		if (y "," (x + i) in heights) nopen[y "," (x + i)]
	}
}
function update(i,j,mn,h,x,u,v,s,c) {
	for (j in open) { delete open[j]; break }
	i = int(j)
	sub("[0-9]*,","",j)
	printf "\033[%d;%dH\033[31m*",i,j
	printf "\033[%d;%dH\033[0m\n",NR,1
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
	for (x = 0; x < 250000; x++);
	s = " "
	if (i == sy && j == sx) s = "\033[38;5;255mS"
	if (i == ey && j == ex) s = "\033[38;5;232mE"
	c = min(255,max(232,heights[i "," j]+230))
	printf "\033[%d;%dH\033[48;5;%dm%s",i,j,c,s
	printf "\033[%d;%dH\033[0m\n",NR,1
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
	} while (length(nopen))
	my = sy
	mx = sx
	while (my != ey || mx != ex) {
		v = distances[my "," mx]
		for (i in distances) {
			if (distances[i] != v - 1) continue
			split(i,p,",")
			if (p[1] != my && p[2] != mx) continue
			if (p[1] == my && p[2] == mx) continue
			if (p[1] == my && (p[2]-mx<0?mx-p[2]:p[2]-mx)>1)
				continue
			if (p[2] == mx && (p[1]-my<0?my-p[1]:p[1]-my)>1)
				continue
			printf "\033[%d;%dH\033[42m ",my,mx
			printf "\033[%d;%dH\033[0m\n",NR,1
			my = p[1]
			mx = p[2]
			break
		}
		for (i = 0; i < 1000000; i++);
	}
	printf "\033[%d;%dH\033[42m ",my,mx
	printf "\033[%d;1H\033[0m", NR + 1
	print "A:",distances[sy "," sx]
}
