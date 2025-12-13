import sys
def parse(lines):
    pieces = []
    needs = []
    for line in lines:
        line = line.strip()
        if len(line) == 0:
            continue
        elif line[-1] == ':':
            pieces.append(0)
        elif ':' not in line:
            pieces[-1] += line.count('#')
        else:
            size,vs = line.split(':')
            w,h = [int(x) for x in size.split('x')]
            vs = tuple(int(x) for x in vs.split())
            needs.append((w,h,vs))
    return pieces, needs

def main():
    pieces, needs = parse(sys.stdin)
    a = 0
    for w,h,vs in needs:
        if sum(map(lambda x,y: x*y, pieces, vs)) <= w*h:
            if sum(vs)*9 > (w - w%3)*(h - h%3):
                print('warning: may need a real solution')
            a += 1
    print(a,sep='\t')

if __name__ == '__main__':
    main()
