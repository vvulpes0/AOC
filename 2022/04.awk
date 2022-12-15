#!/usr/bin/env awk -f
BEGIN { FS="[-,]" }
($1<=$3?$2>=$3:$4>=$1) { b++; a += $1<$3?$4<=$2:$3<$1?$2<=$4:1 }
END { printf "A: %s\nB: %s\n",a,b }
