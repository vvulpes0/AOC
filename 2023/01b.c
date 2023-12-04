#include <stdio.h>

static int a1;
static int an;
static int b1;
static int bn;
static int q;

enum States
{
	BASE,
	O,
	ON,
	T,
	TW,
	TH,
	THR,
	THRE,
	F,
	FO,
	FOU,
	FI,
	FIV,
	S,
	SI,
	SE,
	SEV,
	SEVE,
	E,
	EI,
	EIG,
	EIGH,
	N,
	NI,
	NIN,
};

static inline void
setAB(int v)
{
	if (!a1) a1 = v;
	if (!b1) b1 = v;
	an = bn = v;
}

static inline void
setB(int v)
{
	if (!b1) b1 = v;
	bn = v;
}

int
main(void)
{
	int a = 0;
	int b = 0;
	do {
		int const i = fgetc(stdin);
		if ('\n' == i)
		{
			a += 10*a1 + an;
			b += 10*b1 + bn;
			q = BASE;
			a1 = b1 = 0;
			continue;
		}
		if ('0' < i && i <= '9')
		{
			setAB(i - '0');
			q = BASE;
			continue;
		}
		switch (q)
		{
		case BASE:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case O:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = ON; break;
			case 'o': break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case ON:
			switch (i) {
			case 'e': setB(1); q = E; break;
			case 'f': q = F; break;
			case 'i': q = NI; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case T:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'h': q = TH; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': break;
			case 'w': q = TW; break;
			default: q = BASE; break;
			}
			break;
		case TW:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': setB(2); q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case TH:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 'r': q = THR; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case THR:
			switch (i) {
			case 'e': q = THRE; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case THRE:
			switch (i) {
			case 'e': setB(3); q = E; break;
			case 'f': q = F; break;
			case 'i': q = EI; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case F:
			switch (i) {
			case 'e': q = E; break;
			case 'f': break;
			case 'i': q = FI; break;
			case 'n': q = N; break;
			case 'o': q = FO; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case FO:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = ON; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			case 'u': q = FOU; break;
			default: q = BASE; break;
			}
			break;
		case FOU:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 'r': setB(4); q = BASE; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case FI:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			case 'v': q = FIV; break;
			default: q = BASE; break;
			}
			break;
		case FIV:
			switch (i) {
			case 'e': setB(5); q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case S:
			switch (i) {
			case 'e': q = SE; break;
			case 'f': q = F; break;
			case 'i': q = SI; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case SI:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			case 'x': setB(6); q = BASE; break;
			default: q = BASE; break;
			}
			break;
		case SE:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'i': q = EI; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			case 'v': q = SEV; break;
			default: q = BASE; break;
			}
			break;
		case SEV:
			switch (i) {
			case 'e': q = SEVE; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case SEVE:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'i': q = EI; break;
			case 'n': setB(7); q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case E:
			switch (i) {
			case 'e': break;
			case 'f': q = F; break;
			case 'i': q = EI; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case EI:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'g': q = EIG; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case EIG:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'h': q = EIGH; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case EIGH:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': setB(8); q = T; break;
			default: q = BASE; break;
			}
			break;
		case N:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'i': q = NI; break;
			case 'n': break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case NI:
			switch (i) {
			case 'e': q = E; break;
			case 'f': q = F; break;
			case 'n': q = NIN; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		case NIN:
			switch (i) {
			case 'e': setB(9); q = E; break;
			case 'f': q = F; break;
			case 'i': q = NI; break;
			case 'n': q = N; break;
			case 'o': q = O; break;
			case 's': q = S; break;
			case 't': q = T; break;
			default: q = BASE; break;
			}
			break;
		default: break;
		}
	} while (!feof(stdin));
	printf("A: %d\nB: %d\n", a, b);
}
