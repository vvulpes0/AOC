#include <stdio.h>
#include <string.h>

int
main(int argc, char** argv)
{
	unsigned long fish[9];
	unsigned long t;
	int c;
	int i;
	int j;
	memset(fish, 0, sizeof(fish));
	while ((c = getchar()) != EOF)
	{
		if ('0' <= c && c <= '9')
		{
			++(fish[c - '0']);
		}
	}
	for (i = 0; i < 256; ++i)
	{
		if (i == 80)
		{
			t = 0;
			for (j = 0; j < 9; ++j)
			{
				t += fish[j];
			}
			printf("%lu\t", t);
		}
		t = fish[0];
		for (j = 0; j < 8; ++j)
		{
			fish[j] = fish[j+1];
		}
		fish[6] += t;
		fish[8] = t;
	}
	t = 0;
	for (j = 0; j < 9; ++j)
	{
		t += fish[j];
	}
	printf("%lu\n", t);
	return 0;
}
