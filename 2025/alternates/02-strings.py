import sys
def main():
    a = b = 0
    rs = next(sys.stdin).strip().split(',')
    for r in rs:
        lo,hi = [int(x) for x in r.split('-')]
        for x in range(lo, hi + 1):
            sx = str(x)
            n = len(sx)
            mid = n // 2
            js = [i for i in range(1,mid + 1) if sx[i] == sx[0] and n%i == 0]
            offset = 1
            while js != []:
                new = []
                for j in js:
                    if j + offset >= len(sx):
                        a += x if n%2==0 and j == mid else 0
                        b += x
                        new = []
                        break
                    if sx[j + offset] == sx[offset]:
                        new.append(j)
                js = new
                offset += 1
    print(a, b, sep='\t')
if __name__ == '__main__':
    main()
