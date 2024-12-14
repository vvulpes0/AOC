import java.util.Scanner;
class Day13 {
	public static void main(String[] args) {
		long partA = 0;
		long partB = 0;
		long bOff = 10000000000000L;
		Scanner in = new Scanner(System.in);
		while (in.hasNextLine()) {
			long ax = Long.parseLong(in.findInLine("[0-9]+"));
			long ay = Long.parseLong(in.findInLine("[0-9]+"));
			in.nextLine();
			long bx = Long.parseLong(in.findInLine("[0-9]+"));
			long by = Long.parseLong(in.findInLine("[0-9]+"));
			in.nextLine();
			long xc = Long.parseLong(in.findInLine("[0-9]+"));
			long yc = Long.parseLong(in.findInLine("[0-9]+"));
			in.nextLine();
			if (in.hasNextLine()) in.nextLine();
			partA += go(ax,ay,bx,by,xc,yc);
			partB += go(ax,ay,bx,by,xc + bOff,yc + bOff);
		}
		System.out.println(partA + "\t" + partB);
	}
	public static long go(long ax, long ay, long bx, long by,
	                      long xc, long yc) {
		if (ax == 0) return 0;
		long det = ax*by - ay*bx;
		if (det == 0) return -1;
		if ((ax*yc - ay*xc)%det != 0) return 0;
		long y = (ax*yc - ay*xc)/det;
		if ((xc - y*bx)%ax != 0) return 0;
		long x = (xc - y*bx)/ax;
		return 3*x + y;
	}
}
