import math
import sys
def rectarea(p,q):
    return (abs(q[0]-p[0])+1)*(abs(q[1]-p[1])+1)
def isvalid(p,q,horz,vert):
    x1,x2 = sorted((p[0],q[0]))
    y1,y2 = sorted((p[1],q[1]))
    for x,ya,yb in vert:
        if x >= x2:
            break
        if x > x1 and y1 < yb and y2 > ya:
            return False
    for y,xa,xb in horz:
        if y >= y2:
            break
        if y > y1 and x1 < xb and x2 > xa:
            return False
    return True
def main():
    red = [tuple(int(p) for p in line.split(',')) for line in sys.stdin]
    pairs = [(x,y) for x in red for y in red if y>x]
    a = max(rectarea(*p) for p in pairs)
    horz = []
    vert = []
    for i in range(len(red)):
        if red[i-1][0] == red[i][0]:
            vert.append((red[i][0],*sorted([red[i-1][1],red[i][1]])))
        else:
            horz.append((red[i][1],*sorted([red[i-1][0],red[i][0]])))
    vert.sort()
    horz.sort()
    b = 0
    for p,q in pairs:
        r = rectarea(p,q)
        if r > b and isvalid(p,q,horz,vert):
            b = r
    print(a,b,sep='\t')
if __name__ == '__main__':
    main()
