#include <limits.h>
#include <stdio.h>

#define MIN(a,b) (((a) < (b)) ? (a) : (b))

int risk[500][500];
int p[500][500];

int update_risks(int[500][500], int, int);

int
main(void)
{
	int c;
	int i = 0;
	int j = 0;
	int m = 0;
	int n = 0;
	int w = 0;
	int h = 0;
	while ((c = getchar()) != EOF)
	{
		if ('0' <= c && c <= '9') {
			p[i][j] = c - '0';
			++j;
			continue;
		}
		w = j;
		++i;
		j = 0;
	}
	h = i;
	for (i=0; i < h; ++i)
	{
		for (j=0; j < w; ++j)
		{
			risk[i][j] = INT_MAX;
		}
	}
	risk[h-1][w-1] = p[h-1][w-1];
	while (update_risks(risk, w, h)) {;}
	printf("%d\t",risk[0][0]-p[0][0]);

	for (m = 0; m < 5; ++m)
	{
		for (n = 0; n < 5; ++n)
		{
			for (i = 0; i < h; ++i)
			{
				for (j = 0; j < w; ++j)
				{
					p[m*h+i][n*w+j] = p[i][j] + m + n;
					p[m*h+i][n*w+j] -= 1;
					p[m*h+i][n*w+j] %= 9;
					p[m*h+i][n*w+j] += 1;
				}
			}
		}
	}
	h *= 5;
	w *= 5;
	for (i=0; i < h; ++i)
	{
		for (j=0; j < w; ++j)
		{
			risk[i][j] = INT_MAX;
		}
	}
	risk[h-1][w-1] = p[h-1][w-1];

	while (update_risks(risk, w, h)) {;}
	printf("%d\n",risk[0][0]-p[0][0]);
	return 0;
}

int
update_risks(int r[500][500], int w, int h)
{
	int i;
	int j;
	int n;
	int c = 0;
	for (i = h - 1; i >= 0; --i)
	{
		for (j = w - 1; j >= 0; --j)
		{
			if (i == w - 1 && j == w - 1) { continue; }
			n = INT_MAX;
			if (j > 0) { n = MIN(n,r[i][j-1]); }
			if (i > 0) { n = MIN(n,r[i-1][j]); }
			if (j < w - 1) { n = MIN(n,r[i][j+1]); }
			if (i < h - 1) { n = MIN(n,r[i+1][j]); }
			if (n < INT_MAX)
			{
				n += p[i][j];
				c |= (r[i][j] != n);
				r[i][j] = n;
			}
		}
	}
	return c;
}
