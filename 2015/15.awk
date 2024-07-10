#!/usr/bin/env awk -f
BEGIN { FS="[ ,]*" }
{ C[NR] = $3; D[NR] = $5; F[NR] = $7; T[NR] = $9; X[NR] = $11 }
END {
	a=b=0
	for (i=1; i<97; i++) {
		for (j=1; j<98-i; j++) {
			for (k=1; k<99-i-j; k++) {
				l=100-i-j-k
				cx=C[1]*i+C[2]*j+C[3]*k+C[4]*l
				dx=D[1]*i+D[2]*j+D[3]*k+D[4]*l
				fx=F[1]*i+F[2]*j+F[3]*k+F[4]*l
				tx=T[1]*i+T[2]*j+T[3]*k+T[4]*l
				xx=X[1]*i+X[2]*j+X[3]*k+X[4]*l
				cx=cx>0?cx:0
				dx=dx>0?dx:0
				fx=fx>0?fx:0
				tx=tx>0?tx:0
				v = cx*dx*fx*tx
				a = v>a?v:a
				b = (xx==500 && v>b)?v:b
			}
		}
	}
	print a,b
}
