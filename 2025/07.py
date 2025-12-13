import sys

def main():
    line = next(sys.stdin).strip()
    xs = {line.index('S'): 1}
    w = len(line)
    a = 0
    for line in sys.stdin:
        line = line.strip()
        newxs = dict()
        for x,t in xs.items():
            if line[x] == '^':
                a += 1
                newxs[x - 1] = newxs.get(x - 1, 0) + t
                newxs[x + 1] = newxs.get(x + 1, 0) + t
            else:
                newxs[x] = newxs.get(x, 0) + t
            xs = newxs
    b = sum(xs.values())
    print(a,b,sep='\t')

if __name__ == '__main__':
    main()
