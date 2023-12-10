# AOC

This is an archive of my, rarely optimized, solutions to the
[Advent of Code][1] programming challenges.

## Reporting
For each day's challenge, there is a corresponding source file or two.
The file `timings.csv` reports puzzles by year, day, and part.
If `Part` is equal to `X` then both parts are solved at the same time
by a single source file, and only one timing is given.
Otherwise, each part is solved separately and each is timed alone.
A part 2 line will still appear, sans timing, to contain its answer.

Timings are taken from an Apple Mac Mini (M1, 2020)
or Apple Macbook Air (M2, 2022)
with 8-core ARM processor and 16GB of RAM.
The methodology is not particularly precise,
I just run something like the following until a stable value appears:

```sh
time ./06 < 06.txt
```

## License

Although it is unlikely to be useful,
all code contained in this repository is licensed under the MIT license.
See `LICENSE` for details.
Puzzle inputs are not provided here (those don't belong to me).

[1]:  https://adventofcode.com/
