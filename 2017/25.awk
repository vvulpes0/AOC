#!/usr/bin/env awk -f
BEGIN      { FS = "[[:space:].:-]*"     }
/^Begin/   { istate = $4                }
/^Perform/ { target = 0+$6              }
/^In/      { s = $3                     }
/If/       { v = $7                     }
/Write/    { W[s","v] = $5              }
/Move/     { M[s","v] = $7=="left"?-1:1 }
/Continue/ { C[s","v] = $5              }
END {
	q = istate
	c = 0
	for (i = 0; i < target; i++ ) {
		x     = q","0+T[c]
		T[c]  = W[x]
		c    += M[x]
		q     = C[x]
	}
	for (i in T) a += (T[i] == 1)
	print a
}
