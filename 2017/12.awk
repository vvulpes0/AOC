#!/usr/bin/env awk -f
BEGIN { FS="<->" }
{ conn[0+$1] = $2 }
function dfs(x,i,A) {
	if (x in seen) { return }
	seen[x] = x
	split(conn[x],A,",")
	for (i in A) { dfs(0+A[i]) }
}
END {
	dfs(0)
	partA = length(seen) # scc from dfs
	delete seen
	partB = 0
	while (length(conn) != 0) { # discard one scc at a time
		partB += 1
		for (i in conn) { break }
		dfs(i)
		for (i in seen) { delete conn[i] }
		delete seen
	}
	print partA, partB
}
