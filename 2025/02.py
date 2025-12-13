import sys

# All intervals are clopen [a,b)

# Invalid IDs are numbers n whose string representations
# match xx+ for some number x.  From this we derive:
# * There are no invalid 1-digit IDs
# * Invalid  2-digit IDs are multiples of 11
# * Invalid  3-digit IDs are multiples of 111
# * Invalid  4-digit IDs are multiples of 1111       OR 101
# * Invalid  5-digit IDs are multiples of 11111
# * Invalid  6-digit IDs are multiples of 111111     OR 10101     OR 1001
# * Invalid  7-digit IDs are multiples of 1111111
# * Invalid  8-digit IDs are multiples of 11111111   OR 1010101   OR 10001
# * Invalid  9-digit IDs are multiples of 111111111  OR 1001001
# * Invalid 10-digit IDs are multiples of 1111111111 OR 101010101 OR 100001
# All-nines is biggest and is a multiple of all of them. Quotients are:
# 99/11 = 9, 999/111 = 9, 9999/1111 = 9, 9999/101 = 99, ...
# Right, biggest is d copies of 9, quotient is the k-digit repeated element
# This is (10^d - 1) / (10^k - 1)
def M(d, k):
    return (10**d - 1)//(10**k - 1)

# So split the given range by length;
# for each subrange we can sum up all the multiples of the M's in the range.
# We have the range [a,b).
# The smallest multiple of M at least a is M*((a + M - 1)//M).
# The largest multiple of M less than b is M*((b - 1)//M).
# So lo=(a + M - 1)//M and hi=(b - 1)//M bound the multipliers;
# all multiples between are also included.
# Sum from lo to hi is (sum from 1 to hi) - (sum from 1 to (lo - 1))
# = hi*(hi + 1)//2 - lo*(lo - 1)//2
# = (hi*(hi + 1) - lo*(lo - 1))//2
# And finally multiply by M to get back the result.
def sumin(r, m):
    lo = (r.start + m - 1)//m
    hi = (r.stop - 1)//m
    return 0 if lo > hi else m*(hi*(hi + 1) - lo*(lo - 1))//2

# But! Whenever x divides y, M(d, y) divides M(d, x)
# So when we count multiples of M(d, y),
# we are recounting the multiples of M(d, x)
# Consider 8-digit numbers;
# * every 1-digit repeat is a 2-digit repeat and a 4-digit repeat
# * every 2-digit repeat is a 4-digit repeat
# So we want to subtract the 1's from the 2's and the 4's.
# And we also want to subtract the 2's from the 4's.
# We have to do this in the right order, though:
# Need the 2's to be correct (excluding 1's) before subtracting from the 4's,
# else we'd be undercounting the 1's!
def go(r):
    n = len(str(r.start))
    ds = [x for x in range(1, n) if n%x == 0]
    a = b = 0
    sums = dict((d, sumin(r, M(n, d))) for d in ds)
    if n%2 == 0:
        a = sums[n//2]
    for d in ds:
        for x in [x for x in ds if x < d and d%x == 0]:
            sums[d] -= sums[x]
    b = sum(sums.values())
    return a, b

# We do have to split the range for it to work though.
def split(r):
    out = []
    i = r.start
    while i < r.stop:
        n = min(10**len(str(i)), r.stop)
        out.append(range(i, n))
        i = n
    return out

def suminvalid(full):
    a = b = 0
    for r in split(full):
        da, db = go(r)
        a += da
        b += db
    return a, b

def main():
    a = b = 0
    for r in next(sys.stdin).strip().split(','):
        lo, hi = [int(x) for x in r.split('-')]
        da, db = suminvalid(range(lo, hi + 1))
        a += da
        b += db
    print(a, b, sep='\t')

if __name__ == '__main__':
    main()
