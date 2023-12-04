#include <stdio.h>
#include <string.h>

static int buf[5];
static int a1;
static int an;
static int b1;
static int bn;

#define OFF(x,y) ((x + sizeof(buf) + y)%sizeof(buf))

static inline void
setAB(int value)
{
	if (!a1) a1 = value;
	an = value;
	if (!b1) b1 = value;
	bn = value;
}
static inline void
setB(int value)
{
	if (!b1) b1 = value;
	bn = value;
}

int
main(void)
{
	int i = 0;
	int a = 0;
	int b = 0;
	do {
		buf[i] = fgetc(stdin);
		switch (buf[i])
		{
		case '\n':
			memset(buf, 0, sizeof(buf));
			a += 10*a1 + an;
			b += 10*b1 + bn;
			a1 = b1 = 0;
			continue;
		case '0':
		case '1':
		case '2':
		case '3':
		case '4':
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			setAB(buf[i] - '0');
			break;
		case 'e':
			switch (buf[OFF(i,-1)])
			{
			case 'e':
				if (buf[OFF(i,-2)] == 'r'
				    && buf[OFF(i,-3)] == 'h'
				    && buf[OFF(i,-4)] == 't')
					setB(3);
				break;
			case 'n':
				switch (buf[OFF(i,-2)])
				{
				case 'i':
					if (buf[OFF(i,-3)] == 'n')
						setB(9);
					break;
				case 'o':
					setB(1);
					break;
				}
			case 'v':
				if (buf[OFF(i,-2)] == 'i'
				    && buf[OFF(i,-3)] == 'f')
					setB(5);
				break;
			default:
				break;
			}
		case 'n':
			if (buf[OFF(i,-1)] == 'e'
			    && buf[OFF(i,-2)] == 'v'
			    && buf[OFF(i,-3)] == 'e'
			    && buf[OFF(i,-4)] == 's')
				setB(7);
			break;
		case 'o':
			if (buf[OFF(i,-1)] == 'w'
			    && buf[OFF(i,-2)] == 't')
				setB(2);
			break;
		case 'r':
			if (buf[OFF(i,-1)] == 'u'
			    && buf[OFF(i,-2)] == 'o'
			    && buf[OFF(i,-3)] == 'f')
				setB(4);
			break;
		case 't':
			if (buf[OFF(i,-1)] == 'h'
			    && buf[OFF(i,-2)] == 'g'
			    && buf[OFF(i,-3)] == 'i'
			    && buf[OFF(i,-4)] == 'e')
				setB(8);
			break;
		case 'x':
			if (buf[OFF(i,-1)] == 'i'
			    && buf[OFF(i,-2)] == 's')
				setB(6);
			break;
		default:
			break;
		}
		i = OFF(i,1);
	} while (!feof(stdin));
	printf("A: %d\nB: %d\n", a, b);
}
