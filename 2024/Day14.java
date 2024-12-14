import java.util.ArrayList;
import java.util.Iterator;
import java.util.Scanner;
class Day14 {
	static final int w = 101;
	static final int h = 103;
	public static void main(String[] args) {
		ArrayList<Robot> robots = new ArrayList<Robot>();
		Scanner in = new Scanner(System.in);
		int q1 = 0;
		int q2 = 0;
		int q3 = 0;
		int q4 = 0;
		while (in.hasNextLine()) {
			int x = Integer.parseInt(in.findInLine("[-0-9]+"));
			int y = Integer.parseInt(in.findInLine("[-0-9]+"));
			int vx = Integer.parseInt(in.findInLine("[-0-9]+"));
			int vy = Integer.parseInt(in.findInLine("[-0-9]+"));
			Robot r = new Robot(x,y,vx,vy);
			robots.add(r);
			int nx = r.move(100).x;
			int ny = r.move(100).y;
			in.nextLine();
			if (nx < (w-1)/2 && ny < (h-1)/2) q1++;
			if (nx > (w-1)/2 && ny < (h-1)/2) q2++;
			if (nx < (w-1)/2 && ny > (h-1)/2) q3++;
			if (nx > (w-1)/2 && ny > (h-1)/2) q4++;
		}
		int xbase = -1;
		int ybase = -1;
		int mindx = -1;
		int mindy = -1;
		for (int t = 0; t < Math.max(w,h); t++) {
			int ux = 0;
			int uy = 0;
			Iterator<Robot> i = robots.iterator();
			while (i.hasNext()) {
				Robot r = i.next().move(t);
				ux += r.x;
				uy += r.y;
			}
			ux /= robots.size();
			uy /= robots.size();
			int xdist = 0;
			int ydist = 0;
			i = robots.iterator();
			while (i.hasNext()) {
				Robot r = i.next().move(t);
				xdist += Math.abs(r.x - ux);
				ydist += Math.abs(r.y - uy);
			}
			xdist /= robots.size();
			ydist /= robots.size();
			if (mindx < 0 || xdist < mindx) {
				xbase = t;
				mindx = xdist;
			}
			if (mindy < 0 || ydist < mindy) {
				ybase = t;
				mindy = ydist;
			}
		}
		int d = ybase - xbase;
		int p = 51*w*d + xbase;
		int partB = (1 - p/(w*h))*w*h + p;
		partB = ((partB%(w*h)) + (w*h))%(w*h);
		System.out.println(q1*q2*q3*q4 + "\t" + partB);
	}
	static class Robot {
		public final int x;
		public final int y;
		public final int vx;
		public final int vy;
		Robot(int x, int y, int vx, int vy) {
			this.x = x;
			this.y = y;
			this.vx = vx;
			this.vy = vy;
		}
		Robot move(int t) {
			return new Robot(((x+t*vx)%w + w)%w,
			                 ((y+t*vy)%h + h)%h,
			                 vx,
			                 vy);
		}
	}
}
