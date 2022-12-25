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
		mins[nrange] = temp[1]
		maxs[nrange++] = temp[2]
	}
	for (i = 0; i < nrange; i++) {
		for (j = i + 1; j < nrange; j++) {
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
	for (i = 0; i < nrange - 1; i++) {
		if (!overlap(mins[i],maxs[i],mins[i+1],maxs[i+1])) continue
		maxs[i] = max(maxs[i], maxs[i+1])
		for (j = i + 1; j < nrange - 1; j++) {
			mins[j] = mins[j + 1]
			maxs[j] = maxs[j + 1]
		}
		delete mins[nrange - 1]
		delete maxs[nrange - 1]
		nrange--
		i--
	}
	delete rs
	for (i = 0; i < nrange; i++) rs[mins[i] "," maxs[i]]
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
	for (i in beac)   { split(i,temp,","); a -= (temp[2] == y) }
	for (i in ranges) { split(i,temp,","); a += temp[2]-temp[1]+1 }
	print "A:",a
	for (s in sens) {
		split(s,ss,",")
		for (t in sens) {
			split(t,tt,",")
			if (ss[1] > tt[1]) continue
			if (ss[1] == tt[1] && ss[2]>tt[2]) continue
			d = sens[s] + sens[t] + 2
			if (dist(ss[1],ss[2],tt[1],tt[2]) != d) continue
			lm = tt[2]<ss[2]?1:-1
			m[nm++] = lm
			b[nb++] = ss[2]-lm*(sens[s]+1+ss[1])
			break;
		}
	}
	w = 4000000
	done = 0
	for (i = 0; i < nm && !done; i++) {
		for (j = i + 1; j < nm && !done; j++) {
			mm = m[i] - m[j]
			bb = b[j] - b[i]
			if (mm == 0) continue
			x = bb/mm
			if (x < 0 || x > w) continue
			y = m[i] * x + b[i]
			if (y < 0 || y > w) continue
			sensed = 0
			for (s in sens) {
				split(s,temp,",")
				if (dist(x,y,temp[1],temp[2])<=sens[s]) {
					sensed = 1
					break
				}
			}
			done = !sensed
		}
	}
	print "B:", 4*x+int(y/1000000) (y%1000000)
}
