import sys

def deoverlap(r,rs):
    newrs = []
    a,b = r
    for (x,y) in rs:
        if x < a:
            newrs.append((x,min(y,a-1)))
        if y > b:
            newrs.append((max(x,b+1),y))
    return newrs

def main():
    hadblank = False
    ranges = []
    a = 0
    b = 0
    for line in sys.stdin:
        line = line.strip()
        if line == '':
            hadblank = True
        elif not hadblank:
            r = tuple(int(i) for i in line.split('-'))
            ranges = deoverlap(r,ranges)
            ranges.append(r)
        else:
            v = int(line)
            a += 1 if any(v in range(x,y+1) for (x,y) in ranges) else 0
    b = sum(y - x + 1 for x,y in ranges)
    print(a,b,sep='\t')

if __name__ == '__main__':
    main()
