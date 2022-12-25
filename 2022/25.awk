#!/usr/bin/env awk -f
function s2d(s,  i,t)
{
	t = 0
	for (i = 1; i <= length(s); i++) {
		t = 5*t + index("=-012",substr(s,i,1)) - 3
	}
	return t
}
function d2s(s,  t,x) {
	if (!s) return 0
	while (s) {
		t = s%5
		if (t > 2) { s += 5; t -= 5 }
		x = substr("=-012",t + 3,1) x
		s = int(s/5)
	}
	return x
}
{ a += s2d($0) }
END { print d2s(a) }
