#!/usr/bin/env awk -f
function cd(s) {
	if (s ~ /^\//) { dir = "/" }
	split(s,components,"/")
	for (i = 1; i <= length(components); i++) {
		if (components[i] == "..") {
			sub("/[^/]*$","",dir)
			continue
		}
		dir = (dir != "/" ? dir "/" : dir) components[i]
	}
	if (dir == "") dir = "/"
}
(/^[$]/ && flag) { ls[dir] = 1; flag = 0 }
/^[$] cd/ { cd($3) }
/^[$] ls/ { flag = 1 }
/^[$]/ { next }
/^dir/ { next }
{
	if (ls[dir]) next
	sizes[dir] += $1
	temp = dir
	while (index(temp,"/")) {
		recsizes[temp] += $1
		sub("/[^/]*$","",temp)
	}
	if (dir != "/") recsizes["/"] += $1
}
END {
	b = recsizes["/"]
	for (i in recsizes) {
		x = recsizes[i]
		a += x <= 100000 ? x : 0
		if (x >= b) continue
		if (70000000 - recsizes["/"] + x >= 30000000) b = x
	}
	printf "A: %s\nB: %s\n", a, b
}
