import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.Set;
class Day05 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		HashMap<Integer,HashSet<Integer>> before
			= new HashMap<Integer,HashSet<Integer>>();
		String s = in.nextLine();
		int partA = 0;
		int partB = 0;
		while (s.length() != 0) {
			Scanner xin = new Scanner(s).useDelimiter("[|]");
			int x = xin.nextInt();
			int y = xin.nextInt();
			before.putIfAbsent(y, new HashSet<Integer>());
			before.get(y).add(x);
			s = in.nextLine();
			xin.close();
		}
		while (in.hasNextLine()) {
			s = in.nextLine();
			Scanner xin = new Scanner(s).useDelimiter(",");
			ArrayList<Integer> xs = new ArrayList<Integer>();
			while (xin.hasNextInt()) {
				xs.add(xin.nextInt());
			}
			if (toposort(before, xs)) {
				partA += xs.get(xs.size() / 2);
			} else {
				partB += xs.get(xs.size() / 2);
			}
			xin.close();
		}
		System.out.println(partA + "\t" + partB);
		in.close();
	}
	static boolean valid(Map<Integer,HashSet<Integer>> g,
	                     List<Integer> xs) {
		for (int i = 0; i < xs.size(); i++) {
			HashSet<Integer> s = g.get(xs.get(i));
			if (s == null) s = new HashSet<Integer>();
			for (int j = i + 1; j < xs.size(); j++) {
				if (s.contains(xs.get(j))) return false;
			}
		}
		return true;
	}
	static boolean toposort(Map<Integer,HashSet<Integer>> g,
	                        List<Integer> xs) {
		boolean swapped = false;
		boolean go = true;
		while (go) {
			go = false;
			for (int i = 0; !go && i < xs.size(); i++) {
				HashSet<Integer> s = g.get(xs.get(i));
				if (s==null) s = new HashSet<Integer>();
				for (int j=i+1;!go && j<xs.size();j++) {
					if (s.contains(xs.get(j))) {
						go = true;
						swapped = true;
						int t = xs.get(j);
						xs.set(j,xs.get(i));
						xs.set(i,t);
					}
				}
			}
		}
		return !swapped;
	}
}
