#!/bin/sh
noweave -delay -filter btdefn -t4 -index - <aoc2025.nw | cpif aoc2025.tex
latexmk -pdf -auxdir=obj aoc2025
for file in 01s.py $(seq -f '%02.0f.py' 1 12); do
	notangle -filter btdefn -t4 -R"${file}" aoc2025.nw \
	| sed 's@\t@    @g' \
	| cpif "${file}"
done
