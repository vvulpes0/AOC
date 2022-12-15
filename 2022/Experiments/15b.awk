#!/usr/bin/env awk -f
BEGIN { FS="[=,:]" }
function min(a,b) { return a < b ? a : b }
function max(a,b) { return a > b ? a : b }
function abs(x) { return x < 0 ? -x : x }
function dist(x1,y1,x2,y2) { return abs(y2-y1) + abs(x2-x1) }
function overlap(m1,x1,m2,x2) { return m1<m2?m2<=x1:m2<m1?m1<=x2:1 }
function merge(rs, mins, maxs, i, j, t) {
	for (i in rs) {
		split(i, temp, ",")
		mins[length(mins)] = temp[1]
		maxs[length(maxs)] = temp[2]
	}
	for (i = 0; i < length(mins); i++) {
		for (j = i + 1; j < length(mins); j++) {
			if (mins[i] < mins[j]) continue
			if (mins[i]==mins[j] && maxs[i]<=maxs[j]) continue
			t = mins[i]
			mins[i] = mins[j]
			mins[j] = t
			t = maxs[i]
			maxs[i] = maxs[j]
			maxs[j] = t
		}
	}
	for (i = 0; i < length(mins) - 1; i++) {
		if (!overlap(mins[i],maxs[i],mins[i+1],maxs[i+1])) continue
		maxs[i] = max(maxs[i], maxs[i+1])
		for (j = i + 1; j < length(mins) - 1; j++) {
			mins[j] = mins[j + 1]
			maxs[j] = maxs[j + 1]
		}
		delete mins[length(mins) - 1]
		delete maxs[length(maxs) - 1]
		i--
	}
	delete rs
	for (i = 0; i < length(mins); i++) rs[mins[i] "," maxs[i]]
}
function dorow(y,s,temp,dx,dy,rm,rx) {
	for (s in sens) {
		split(s, temp, ",")
		dy = abs(temp[2] - y)
		dx = sens[s] - dy
		if (dx < 0) continue
		rm = temp[1] - dx
		rx = temp[1] + dx
		ranges[rm "," rx]
		merge(ranges)
	}
}
{ d = dist($2, $4, $6, $8); beac[$6 "," $8]; sens[$2 "," $4] = d }
END {
	a = 0
	y = 2000000
	dorow(y)
	for (i in beac) {
		split(i, temp, ",")
		if (temp[2] == y) a--
	}
	for (i in ranges) {
		split(i, temp, ",")
		a += temp[2] - temp[1] + 1
	}
	print "A:",a
	w = 4000000
	for (i = w; i >= 0; i--) {
		c = 0
		delete ranges
		dorow(i)
		for (x in ranges) {
			split(x, temp, ",")
			if (!overlap(temp[1],temp[2],0,w)) continue
			c += min(temp[2],w) - max(temp[1],0) + 1
			if (temp[1] > 0)  f[1] = temp[1] - 1
			if (temp[2] <= w) f[1] = temp[2] + 1
		}
		if (c > w) continue
		f[2] = i
		break
	}
	print "B:", f[1] * 4000000 + f[2]
}
