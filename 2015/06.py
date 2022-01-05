#!/usr/bin/env python3
# -*- python-indent-offset: 4; tab-width: 4; indent-tabs-mode: t; -*-

import re
import sys

def main():
	state=dict()
	stateb=dict()
	for line in sys.stdin:
		line = line.rstrip()
		command(state, line)
		commandb(stateb, line)
	print(sum(state.values()), sum(stateb.values()), sep="\t")

def command(state : dict, c : str) -> None:
	nums = list(map(int, re.findall(r"\d+", c)))
	toggling = c.find("toggle") >= 0
	newstate = True if c.find("on") >= 0 else False
	for i in range(nums[0], nums[2]+1):
		for j in range(nums[1], nums[3]+1):
			if toggling:
				state[(i,j)] = not state.get((i,j),False)
				continue
			state[(i,j)] = newstate

def commandb(state : dict, c : str) -> None:
	nums = list(map(int, re.findall(r"\d+", c)))
	add = 2 if c.find("toggle") >= 0 else 1 if c.find("on") >= 0 else -1
	for i in range(nums[0], nums[2]+1):
		for j in range(nums[1], nums[3]+1):
			state[(i,j)] = max(state.get((i,j),0) + add, 0)

if __name__ == "__main__":
	main()
