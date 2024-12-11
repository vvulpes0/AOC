import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
class Day09 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		int maxid = -1;
		String s = in.nextLine();
		in.close();
		ArrayList<Integer> diskA = new ArrayList<Integer>();
		ArrayList<Integer> diskB = new ArrayList<Integer>();
		ArrayList<Integer> sizeB = new ArrayList<Integer>();
		int blank = 0;
		for (int i = 0; i < s.length(); i++) {
			int n = Character.getNumericValue(s.charAt(i));
			diskB.add((i%2 == 0) ? i/2 : -1);
			sizeB.add(n);
			if (i%2 == 0) maxid++;
			for (int j = 0; j < n; j++) {
				diskA.add((i%2 == 0) ? i/2 : -1);
				blank += i%2;
			}
		}
		System.out.print(partA(diskA, blank) + "\t");
		System.out.println(partB(diskB, sizeB, maxid));
	}
	static long partA(List<Integer> diskA, int blank) {
		int i = 0;
		while (blank > 0) {
			while (diskA.get(i) >= 0) i++;
			diskA.set(i, diskA.remove(diskA.size() - 1));
			blank--;
			while (diskA.get(diskA.size() - 1) < 0) {
				diskA.remove(diskA.size() - 1);
				blank--;
			}
		}
		long out = 0;
		for (i = 0; i < diskA.size(); i++) {
			out += (long)i * diskA.get(i);
		}
		return out;
	}
	static long partB(List<Integer> diskB, List<Integer> sizeB, int maxid) {
		for (int i = maxid; i > 0; i--) {
			int j = 0;
			int k = 0;
			for (; diskB.get(j) != i; j++);
			for (;
			     ((diskB.get(k)>=0
			       || sizeB.get(k)<sizeB.get(j))
			      && k < j);
			     k++);
			if (k != j) {
				diskB.set(k,diskB.get(j));
				diskB.set(j, -1);
				if (sizeB.get(j) < sizeB.get(k)) {
					int t = sizeB.get(k) - sizeB.get(j);
					sizeB.set(k, sizeB.get(j));
					diskB.add(k+1,-1);
					sizeB.add(k+1,t);
				}
			}
			for (j = 0; j < diskB.size() - 1; j++) {
				if (diskB.get(j) < 0 & diskB.get(j+1) < 0) {
					sizeB.set(j, sizeB.get(j) + sizeB.get(j+1));
					sizeB.remove(j+1);
					diskB.remove(j+1);
					j--;
				}
			}
		}
		long out = 0;
		int i = 0;
		for (int j = 0; j < diskB.size(); j++) {
			for (int k = 0; k < sizeB.get(j); k++) {
				if (diskB.get(j) >= 0) {
					out += (long)i*diskB.get(j);
				}
				i++;
			}
		}
		return out;
	}
}
