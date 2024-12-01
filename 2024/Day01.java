import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Scanner;
class Day01 {
	public static int findFirst(BigInteger a,
	                            ArrayList<BigInteger> xs) {
		// invariant: if present, first occurrence is
		// at or beyond index m,
		// but certainly within the next n-m indices;
		// otherwise (if n-m < 0) not present
		int m = 0;
		int n = xs.size();
		while (m < n) {
			int j = (m + n) / 2;
			BigInteger b = xs.get(j);
			if (b.equals(a)) {
				n = j;
				if (j > m && xs.get(j - 1).equals(a)) {
					n = j - 1;
				}
			} else if (b.compareTo(a) < 0) {
				m = j + 1;
			} else {
				n = j - 1;
			}
		}
		if (m == n) {
			return m;
		}
		return -1;
	}

	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		ArrayList<BigInteger> left = new ArrayList<BigInteger>();
		ArrayList<BigInteger> right = new ArrayList<BigInteger>();
		BigInteger partA = BigInteger.ZERO;
		BigInteger partB = BigInteger.ZERO;
		while (in.hasNextBigInteger()) {
			left.add(in.nextBigInteger());
			right.add(in.nextBigInteger());
		}
		left.sort(Comparator.naturalOrder());
		right.sort(Comparator.naturalOrder());
		for (int i = 0; i < left.size(); i++) {
			partA = partA.add((left.get(i)
			                   .subtract(right.get(i))
			                   ).abs());
			BigInteger a = left.get(i);
			int m = findFirst(a, right);
			if (m < 0) {
				continue;
			}
			int n = m;
			while (n<right.size() && right.get(n).equals(a)) {
				n++;
			}
			partB = partB.add(a.multiply(BigInteger
			                             .valueOf(n - m)));
		}
		System.out.print(partA);
		System.out.print("\t");
		System.out.println(partB);
	}
}
