import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.PriorityQueue;
import java.util.Scanner;
class Day18 {
	private static final int size = 70+1;
	private static final int firstN = 1024;
	public static void main(String[] args) {
		ArrayList<ArrayList<Boolean>> map = new ArrayList<ArrayList<Boolean>>();
		for (int i = 0; i < size; i++) {
			ArrayList<Boolean> bs = new ArrayList<Boolean>();
			for (int j = 0; j < size; j++) {
				bs.add(true);
			}
			map.add(bs);
		}
		Scanner in = new Scanner(System.in);
		in.useDelimiter("[^0-9]+");
		int nr = 0;
		int partA = 0;
		int x = 0;
		int y = 0;
		while (in.hasNextInt()) {
			x = in.nextInt();
			y = in.nextInt();
			map.get(y).set(x,false);
			nr++;
			Integer m = goA(map);
			if (nr == firstN) partA = m;
			if (m == null) break;
		}
		System.out.println(partA + "\t" + x + "," + y);
	}
	private static int v(int x, int y) {
		return y*size + x;
	}
	private static Integer goA(ArrayList<ArrayList<Boolean>> map) {
		Graph g = new Graph();
		for (int i = 0; i < size; i++) {
			for (int j = 0; j < size; j++) {
				g.addVertex();
			}
		}
		for (int i = 0; i < size; i++) {
			for (int j = 0; j < size; j++) {
				if (!map.get(i).get(j)) continue;
				if (i>0 && map.get(i-1).get(j)) g.addEdge(v(j,i), v(j,i-1), 1);
				if (i+1<size && map.get(i+1).get(j)) g.addEdge(v(j,i), v(j,i+1), 1);
				if (j>0 && map.get(i).get(j-1)) g.addEdge(v(j,i), v(j-1,i), 1);
				if (j+1<size && map.get(i).get(j+1)) g.addEdge(v(j,i), v(j+1,i), 1);
			}
		}
		return g.distances(v(0,0)).get(v(size-1,size-1));
	}
	private static class Graph {
		private ArrayList<HashMap<Integer,Integer>> edges;
		Graph() { edges = new ArrayList<HashMap<Integer,Integer>>(); }
		public int addVertex() {
			edges.add(new HashMap<Integer,Integer>());
			return edges.size() - 1;
		}
		public void addEdge(int p, int q, int v) {
			edges.get(p).put(q, v);
		}
		public final HashMap<Integer,Integer> get(int x) {
			return edges.get(x);
		}
		public List<Integer> distances(int source) {
			ArrayList<Integer> out = new ArrayList<Integer>();
			PriorityQueue<Integer> Q = new PriorityQueue<Integer>((a,b) -> out.get(a).compareTo(out.get(b)));
			for (int i = 0; i < edges.size(); i++) {
				out.add(i == source ? 0 : null);
			}
			Q.add(source);
			while (Q.size() != 0) {
				int u = Q.poll();
				Iterator<Integer> vs = edges.get(u).keySet().iterator();
				while (vs.hasNext()) {
					int v = vs.next();
					int alt = out.get(u) + edges.get(u).get(v);
					if (out.get(v) == null || alt < out.get(v)) {
						out.set(v, alt);
						Q.add(v);
					}
				}
			}
			return out;
		}
	}
}
