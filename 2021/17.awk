#!/usr/bin/env awk -f
# int() truncates, we want actual floor and ceiling
function floor(x) {
	if (x > 0) {
		return int(x)
	}
	return (x == int(x)) ? x : int(x) - 1
}
function ceiling(x) {
	if (x < 0) {
		return int(x)
	}
	return (x == int(x)) ? x : int(x) + 1
}
# lefter and righter solve dragless(v,n)=p for n
function lefter(v,p) {
	return ((2*v+1) - sqrt((2*v+1)^2-8*p)) / 2
}
function righter(v,p) {
	return ((2*v+1) + sqrt((2*v+1)^2-8*p)) / 2
}
# dragless computes the vth triangular number minus the (v-n)'th.
# this is exactly the movement in the y direction
function dragless(v,n) {
	return n*(2*v-n+1)/2
}
# dragged is dragless with n capped to v
# the peak value is retained once reached
# this is the movement in the x direction
function dragged(v,n) {
	return dragless(v,(n > v) ? v : n)
}

BEGIN {
	FS="[=,]"
	OFS="\t"
}
{
	split($2,x,/\.\./);
	split($4,y,/\.\./);
	u = 0
	g = 0
	s = (y[1] < 0) ? -y[1] : y[2]
	# solve x[1] = t*(t+1)/2 for t, this is minimal x-velocity
	t = ceiling((sqrt(1 + 8*x[1]) - 1)/2)
	for (v = -s; v < s; v = v+1) {
		m = floor(lefter(v,y[2]))
		n = floor(righter(v,y[1]))
		for (j = t; j <= x[2]; ++j)
		{
			b = 0
			c = ceiling(lefter(v,y[1]))
			for (i = (c > 0) ? c : 0;
			     i <= m && m > 0; ++i)
			{
				if (i < 0) { continue; }
				a = dragged(j,i)
				if (x[1] > a || a > x[2]) { continue; }
				g += 1
				b = 1
				u = v
				break
			}
			if (b) { continue; }
			c = ceiling(righter(v,y[2]))
			for (i = (c > 0) ? c : 0;
			     i <= n && n > 0; ++i)
			{
				if (i < 0) { continue; }
				a = dragged(j,i)
				if (x[1] > a || a > x[2]) { continue; }
				g += 1
				u = v
				break
			}
		}
	}
	print dragless(u,u),g
}
