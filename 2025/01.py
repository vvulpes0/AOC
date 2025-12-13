import sys
def main():
    p = 50
    a = 0
    b = 0
    for line in sys.stdin:
        line = line.strip()
        m = int(line[1:])
        b += m//100
        m %= 100
        if line[0] == 'L':
            if m >= p and p != 0:
                b += 1
            p = p - m
        elif line[0] == 'R':
            p = p + m
            if p >= 100:
                b += 1
        p = (p + 100)%100
        if p == 0:
            a += 1
    print(a,b,sep='\t')
if __name__ == '__main__':
    main()
