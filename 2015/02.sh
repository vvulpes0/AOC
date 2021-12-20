#!/bin/sh
a=0
b=0
while IFS="x" read x y z; do
	if [ "$y" -lt "$x" ]; then
		t="$x"
		x="$y"
		y="$t"
	fi
	if [ "$z" -lt "$y" ]; then
		t="$y"
		y="$z"
		z="$t"
	fi
	if [ "$y" -lt "$x" ]; then
		t="$x"
		x="$y"
		y="$t"
	fi
	a=$((a + 3*(x*y) + 2*(x*z) + 2*(y*z)))
	b=$((b + 2*(x+y) + (x*y*z)))
done
printf "%d\t%d\n" "$a" "$b"
