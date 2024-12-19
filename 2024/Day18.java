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
		Partition<Integer> mapp = new Partition<Integer>();
		mapp.add(-1); // TOP
		mapp.add(-2); // LEFT
		mapp.add(-3); // RIGHT
		mapp.add(-4); // BOTTOM
		for (int i = 0; i < size; i++) {
			ArrayList<Boolean> bs = new ArrayList<Boolean>();
			for (int j = 0; j < size; j++) {
				bs.add(true);
				mapp.add(v(j,i));
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
			if (x == 0) mapp.union(v(x,y), -2);
			if (x+1 == size) mapp.union(v(x,y), -3);
			if (y == 0) mapp.union(v(x,y), -1);
			if (y+1 == size) mapp.union(v(x,y), -4);
			if (y>0 && !map.get(y-1).get(x))
				mapp.union(v(x,y), v(x,y-1));
			if (y+1<size && !map.get(y+1).get(x))
				mapp.union(v(x,y), v(x,y+1));
			if (x>0 && !map.get(y).get(x-1))
				mapp.union(v(x,y), v(x-1,y));
			if (x+1<size && !map.get(y).get(x+1))
				mapp.union(v(x,y), v(x+1,y));
			nr++;
			if (nr == firstN) partA = goA(map);
			if (mapp.get(-1) == mapp.get(-2)) break;
			if (mapp.get(-1) == mapp.get(-4)) break;
			if (mapp.get(-2) == mapp.get(-3)) break;
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
	static class Partition<E> {
		private HashMap<E,E> parents;
		Partition() { parents = new HashMap<E,E>(); }
		boolean add(E e) {
			if (parents.containsKey(e)) return false;
			parents.put(e,e);
			return true;
		}
		void clear() { parents.clear(); }
		boolean isEmpty() { return parents.isEmpty(); }
		E get(E e) {
			E p = parents.get(e);
			if (p == null || p == e) return p;
			parents.put(e,get(p));
			return parents.get(e);
		}
		boolean union(E x, E y) {
			add(x);
			add(y);
			if (get(x) == get(y)) return false;
			parents.put(get(y),get(x));
			return true;
		}
	}
}
