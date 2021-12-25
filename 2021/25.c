#include <stdio.h>
#include <stdlib.h>

#define WIDTH 139
#define HEIGHT 137

_Bool update(char * const * const);

int
main(void)
{
	char **a = malloc(HEIGHT*sizeof(*a));
	int i;
	int j;
	for (i = 0; i < HEIGHT; ++i)
	{
		a[i] = malloc(WIDTH*sizeof(**a));
		for (j = 0; j < WIDTH; ++j)
		{
			a[i][j] = getchar();
			if (a[i][j] == '.') { a[i][j] = 0; }
			if (a[i][j] == '>') { a[i][j] = 1; }
			if (a[i][j] == 'v') { a[i][j] = 2; }
		}
		while (getchar() != '\n' && !feof(stdin)) {;}
	}
	i = 1;
	while (update(a)) { ++i; }
	printf("%d\n",i);
	for (i = 0; i < HEIGHT; ++i)
	{
		free(a[i]);
		a[i] = NULL;
	}
	free(a);
	a = NULL;
	return 0;
}

_Bool
update(char * const * const a)
{
	int i;
	int j;
	_Bool m = 0;
	_Bool c = 0;
	for (i = 0; i < HEIGHT; ++i)
	{
		c = a[i][0] == 0 && a[i][WIDTH - 1] == 1;
		for (j = WIDTH - 1; j > 0; --j)
		{
			if (a[i][j] == 0 && a[i][j-1] == 1)
			{
				a[i][j] = 1;
				--j;
				a[i][j] = 0;
				m = 1;
			}
		}
		if (c) { a[i][0] = 1; a[i][WIDTH - 1] = 0; m = 1;}
	}
	for (j = 0; j < WIDTH; ++j)
	{
		c = a[0][j] == 0 && a[HEIGHT - 1][j] == 2;
		for (i = HEIGHT - 1; i > 0; --i)
		{
			if (a[i][j] == 0 && a[i-1][j] == 2)
			{
				a[i][j] = 2;
				--i;
				a[i][j] = 0;
				m = 1;
			}
		}
		if (c) { a[0][j] = 2; a[HEIGHT - 1][j] = 0; m = 1;}
	}
	return m;
}
