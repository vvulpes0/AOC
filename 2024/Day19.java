import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.regex.Pattern;
import java.util.Scanner;
import java.util.StringJoiner;
class Day19 {
	private static HashMap<String,Long>W = new HashMap<String,Long>();
	private static HashSet<String>P = new HashSet<String>();

	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		P.addAll(Arrays.asList(in.nextLine().split(", ")));
		in.nextLine();
		StringJoiner regex = new StringJoiner("|","^(",")*$");
		Iterator<String> xs = P.iterator();
		while (xs.hasNext()) regex.add(xs.next());
		Pattern pattern = Pattern.compile(regex.toString());
		int partA = 0;
		long partB = 0;
		while (in.hasNextLine()) {
			String s = in.nextLine();
			if (!pattern.matcher(s).matches()) continue;
			partA++;
			partB += countWays(s);
		}
		System.out.println(partA + "\t" + partB);
	}
	private static long countWays(String x) {
		if (W.containsKey(x)) return W.get(x);
		Iterator<String> ss = P.iterator();
		long n = 0;
		while (ss.hasNext()) {
			String s = ss.next();
			if (x.equals(s)) {
				n++;
			} else if (x.startsWith(s)) {
				n += countWays(x.substring(s.length()));
			}
		}
		W.put(x, n);
		return n;
	}
}
