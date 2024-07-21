#include <stdio.h>
#define SIZE 300
#define SERIAL 7139
static int grid[SIZE*SIZE];
static void
init(void)
{
	int r;
	for (int i = 0; i < SIZE; ++i) {
		for (int j = 0; j < SIZE; ++j) {
			r = j+1+10;
			r = ((r*(SERIAL + r*(i+1)))/100%10) - 5;
			grid[SIZE*i+j] = r;
		}
	}
}
static void
part_a(void) {
	int x;
	int y;
	int maxx;
	int maxy;
	int maxs = 0;
	int i;
	int j;
	int s = 0;
	for (y = 0; y < SIZE - 2; ++y) {
		for (x = 0; x < SIZE - 2; ++x) {
			s = 0;
			for (i = 0; i < 3; ++i) {
				for (j = 0; j < 3; ++j) {
					s += grid[(y+i)*SIZE+(x+j)];
				}
			}
			if (s > maxs) {
				maxx = x;
				maxy = y;
				maxs = s;
			}
		}
	}
	printf("%d,%d\t",maxx+1,maxy+1);
}
static void
part_b(void) {
	int x;
	int y;
	int q;
	int maxx;
	int maxy;
	int maxq;
	int maxs;
	int i;
	int s;
	int qq;
	for (y = 0; y < SIZE; ++y) {
		for (x = 0; x < SIZE; ++x) {
			s = 0;
			qq = SIZE - x;
			qq = SIZE - y < qq ? SIZE - y : qq;
			for (q = 1; q < qq; ++q) {
				for (i = 0; i < q; ++i) {
					s += grid[(y+q-1)*SIZE+(x+i)];
				}
				for (i = 0; i < q - 1; ++i) {
					s += grid[(y+i)*SIZE+(x+q-1)];
				}
				if (s > maxs) {
					maxx = x;
					maxy = y;
					maxq = q;
					maxs = s;
				}
			}
		}
	}
	printf("%d,%d,%d\n",maxx+1,maxy+1,maxq);
}
int
main(void)
{
	init();
	part_a();
	part_b();
	return 0;
}
