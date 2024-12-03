import java.util.regex.Pattern;
import java.util.Scanner;
class Day03 {
	public static void main(String[] args) {
		Pattern p = Pattern.compile(
			"don't[(][)]|do[(][)]|mul[(][0-9][0-9]*,[0-9][0-9]*[)]");
		Scanner in = new Scanner(System.in);
		long nonB = 0;
		long sum = 0;
		long sumB = 0;
		while (in.hasNextLine()) {
			Scanner xin = new Scanner(in.nextLine());
			String s = xin.findInLine(p);
			while (s != null) {
				if (s.startsWith("don't()")) {
					nonB = 1;
				} else if (s.startsWith("do()")) {
					nonB = 0;
				} else {
					Scanner mul = new Scanner(s);
					mul.useDelimiter("[(,)]");
					mul.skip("mul[(]");
					long x = mul.nextLong();
					long y = mul.nextLong();
					sum += x*y;
					sumB += x*y*(1-nonB);
				}
				s = xin.findInLine(p);
			}
		}
		System.out.print(sum);
		System.out.print("\t");
		System.out.println(sumB);
	}
}
