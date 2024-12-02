import java.util.ArrayList;
import java.util.Scanner;
class Day02 {
	public static int cmp(int a, int b) {
		if (a < b) { return -1; }
		if (a > b) { return  1; }
		return 0;
	}
	public static boolean checkB(ArrayList<Integer> xs,
	                             int dir,
	                             boolean unsafe) {
		for (int i = 0; unsafe && i < xs.size(); i++) {
			unsafe = false;
			for (int j = 1; !unsafe && j < xs.size(); j++) {
				if (j == 1 && i == 0) continue;
				if (j == i) continue;
				int k = j - 1;
				if (j - 1 == i) k--;
				int d = Math.abs(xs.get(j) - xs.get(k));
				if (cmp(xs.get(j),xs.get(k)) != dir) {
					unsafe = true;
				}
				if (d < 1 || d > 3) unsafe = true;
			}
		}
		return !unsafe;
	}
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int safeA = 0;
		int safeB = 0;
		while (in.hasNextLine()) {
			Scanner xin = new Scanner(in.nextLine());
			ArrayList<Integer> xs = new ArrayList<Integer>();
			while (xin.hasNextInt()) {
				xs.add(xin.nextInt());
			}
			boolean unsafe = false;
			int dir = 0;
			for (int i = 1; i < xs.size(); i++) {
				int j = i - 1;
				dir += cmp(xs.get(i),xs.get(j));
			}
			dir = cmp(dir,0);
			for (int i = 1; !unsafe && i < xs.size(); i++) {
				int j = i - 1;
				int d = Math.abs(xs.get(i) - xs.get(j));
				if (cmp(xs.get(i),xs.get(j)) != dir) {
					unsafe = true;
				}
				if (d < 1 || d > 3) { unsafe = true; }
			}
			if (!unsafe) { safeA++; }
			if (checkB(xs,dir,unsafe)) { safeB++; }
		}
		System.out.print(safeA);
		System.out.print("\t");
		System.out.println(safeB);
	}
}
