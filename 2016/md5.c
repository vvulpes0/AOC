#include <string.h>
#include <stdint.h>

static int const s[] = {
	7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
	5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
	4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
	6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,
};
static uint_fast32_t const K[] = {
	0xd76aa478U, 0xe8c7b756U, 0x242070dbU, 0xc1bdceeeU,
	0xf57c0fafU, 0x4787c62aU, 0xa8304613U, 0xfd469501U,
	0x698098d8U, 0x8b44f7afU, 0xffff5bb1U, 0x895cd7beU,
	0x6b901122U, 0xfd987193U, 0xa679438eU, 0x49b40821U,
	0xf61e2562U, 0xc040b340U, 0x265e5a51U, 0xe9b6c7aaU,
	0xd62f105dU, 0x02441453U, 0xd8a1e681U, 0xe7d3fbc8U,
	0x21e1cde6U, 0xc33707d6U, 0xf4d50d87U, 0x455a14edU,
	0xa9e3e905U, 0xfcefa3f8U, 0x676f02d9U, 0x8d2a4c8aU,
	0xfffa3942U, 0x8771f681U, 0x6d9d6122U, 0xfde5380cU,
	0xa4beea44U, 0x4bdecfa9U, 0xf6bb4b60U, 0xbebfbc70U,
	0x289b7ec6U, 0xeaa127faU, 0xd4ef3085U, 0x04881d05U,
	0xd9d4d039U, 0xe6db99e5U, 0x1fa27cf8U, 0xc4ac5665U,
	0xf4292244U, 0x432aff97U, 0xab9423a7U, 0xfc93a039U,
	0x655b59c3U, 0x8f0ccc92U, 0xffeff47dU, 0x85845dd1U,
	0x6fa87e4fU, 0xfe2ce6e0U, 0xa3014314U, 0x4e0811a1U,
	0xf7537e82U, 0xbd3af235U, 0x2ad7d2bbU, 0xeb86d391U,
};

static uint_fast32_t const a0 = 0x67452301U;
static uint_fast32_t const b0 = 0xefcdab89U;
static uint_fast32_t const c0 = 0x98badcfeU;
static uint_fast32_t const d0 = 0x10325476U;

/** md5 **
 * msg : a null-terminated string message
 * out : a caller-owned 32-byte char array
*/
void md5(char const * restrict msg, char * restrict out) {
	char buf[64];
	uint_fast32_t blocks[16];
	int len=strnlen(msg,56);
	int i;
	int j;
	uint_fast32_t A = a0;
	uint_fast32_t B = b0;
	uint_fast32_t C = c0;
	uint_fast32_t D = d0;
	uint_fast32_t F;
	int g;
	/* Prepare blocks */
	strncpy(buf, msg, sizeof(buf)-8);
	buf[len] = 0x80;
	for (i=len+1; i<sizeof(buf); ++i) {
		buf[i] = 0;
	}
	len *= 8;
	for (i=0; i<8; ++i) {
		buf[56+i] = len%256;
		len /= 256;
	}
	/* manually emblock in case of big-endian systems */
	for (i=0; i<sizeof(blocks)/sizeof(*blocks); ++i) {
		blocks[i]=0;
		for (j=4; j>0; --j) {
			blocks[i]*=256;
			blocks[i]+=(unsigned char)(buf[4*i+j-1]);
		}
	}
	for (i = 0; i < 64; ++i) {
		if (i < 16) {
			F = (B&C) | (D&~B);
			g = i;
		} else if (i < 32) {
			F = (D&B) | (C&~D);
			g = (5*i + 1)&0xF;
		} else if (i < 48) {
			F = B^C^D;
			g = (3*i + 5)&0xF;
		} else {
			F = C^(B|~D);
			g = (7*i)&0xF;
		}
		F = F + A + K[i] + blocks[g];
		A = D;
		D = C;
		C = B;
		B = B + ((F<<s[i])|((F&0xffffffffU)>>(32-s[i])));
	}
	blocks[0]=A+a0; blocks[1]=B+b0; blocks[2]=C+c0; blocks[3]=D+d0;
	for (i = 0; i < 4; ++i) {
		for (j = 0; j < 4; ++j) {
			F = blocks[i]&0xff;
			A = (F>>4)&0xf;
			B = F&0xf;
			out[8*i+2*j+0] = A<10?A+'0':A+'a'-10;
			out[8*i+2*j+1] = B<10?B+'0':B+'a'-10;
			blocks[i]>>=8;
		}
	}
}
