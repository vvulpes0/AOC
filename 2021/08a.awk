#!/usr/bin/env awk -f
BEGIN {
	FS=" [|] "
}

{
	split($2,r," ")
	for (i in r) {
		i = length(r[i])
		if (i == 2 || i == 3 || i == 4 || i == 7) {
			++a
		}
	}
}

END {
	print a
}
