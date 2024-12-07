import java.util.ArrayList;
import java.util.Scanner;
class Day07 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		long partA = 0;
		long partB = 0;
		while (in.hasNextLine()) {
			Scanner xin = new Scanner(in.nextLine())
				.useDelimiter("(\\s|:)+");
			long t = xin.nextLong();
			long x = xin.nextLong();
			ArrayList<Long> xs = new ArrayList<Long>();
			while (xin.hasNextLong()) xs.add(xin.nextLong());
			if (goa(x,0,t,xs)) partA += t;
			if (gob(x,0,t,xs)) partB += t;
			xin.close();
		}
		in.close();
		System.out.println(partA + "\t" + partB);
	}
	static boolean goa(long x,int i,long t,ArrayList<Long> xs) {
		if (i == xs.size()) return (x == t);
		if (x > t) return false;
		long min = x;
		long max = x;
		for (int j = i; j < xs.size(); j++) {
			long y = xs.get(j);
			if (y < 2) {
				min *= y;
				max += y;
			} else {
				min += y;
				max *= y;
			}
		}
		if (min <= t && t <= max) {
			return (goa(x*xs.get(i), i+1, t, xs) ||
			        goa(x+xs.get(i), i+1, t, xs));
		}
		return false;
	}
	static long pow(long a, long b) {
		long x = 1;
		for (;b != 0;) {
			x *= (b%2 == 0) ? 1 : a;
			a *= a;
			b /= 2;
		}
		return x;
	}
	static long concat(long x, long y) {
		return x*pow(10,Math.round(0.5+Math.log10(y))) + y;
	}
	static boolean gob(long x,int i,long t,ArrayList<Long> xs) {
		if (i == xs.size()) return (x == t);
		if (x > t) return false;
		long min = x;
		long max = x;
		for (int j = i; j < xs.size(); j++) {
			long y = xs.get(j);
			if (y < 2) {
				min *= y;
				max = concat(max, y);
			} else if (max * y < concat(max, y)) {
				min += y;
				max = concat(max, y);
			} else {
				min += y;
				max *= y;
			}
		}
		if (min <= t && t <= max) {
			return (gob(concat(x,xs.get(i)), i+1, t, xs) ||
			        gob(x*xs.get(i), i+1, t, xs) ||
			        gob(x+xs.get(i), i+1, t, xs));
		}
		return false;
	}
}
