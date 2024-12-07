import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
class Day04 {
	public static void main(String[] args) {
		Scanner in = new Scanner(System.in);
		ArrayList<String> grid = new ArrayList<String>();
		while (in.hasNextLine()) {
			grid.add(in.nextLine());
		}
		in.close();
		int csize = grid.get(0).length();
		int partA = 0;
		int partB = 0;
		for (int r = 0; r < grid.size(); r++) {
			for (int c = 0; c < csize; c++) {
				partA += find(grid, r, c,  1,  0)?1:0;
				partA += find(grid, r, c,  1,  1)?1:0;
				partA += find(grid, r, c,  0,  1)?1:0;
				partA += find(grid, r, c, -1,  1)?1:0;
				partA += find(grid, r, c, -1,  0)?1:0;
				partA += find(grid, r, c, -1, -1)?1:0;
				partA += find(grid, r, c,  0, -1)?1:0;
				partA += find(grid, r, c,  1, -1)?1:0;
				partB += findB(grid,r,c,-1,-1,-1, 1)?1:0;
				partB += findB(grid,r,c,-1,-1, 1,-1)?1:0;
				partB += findB(grid,r,c,-1, 1, 1, 1)?1:0;
				partB += findB(grid,r,c, 1,-1, 1, 1)?1:0;
			}
		}
		System.out.println(partA + "\t" + partB);
	}
	static boolean find(List<String> g,int r,int c,int dr,int dc) {
		try {
			if (g.get(r+0*dr).charAt(c+0*dc) != 'X')
				return false;
			if (g.get(r+1*dr).charAt(c+1*dc) != 'M')
				return false;
			if (g.get(r+2*dr).charAt(c+2*dc) != 'A')
				return false;
			if (g.get(r+3*dr).charAt(c+3*dc) != 'S')
				return false;
		} catch (IndexOutOfBoundsException e) {
			return false;
		}
		return true;
	}
	static boolean findB(List<String> g, int r, int c,
	                     int dr0, int dc0, int dr1, int dc1) {
		try {
			if (g.get(r).charAt(c) != 'A')
				return false;
			if (g.get(r+dr0).charAt(c+dc0) != 'M')
				return false;
			if (g.get(r+dr1).charAt(c+dc1) != 'M')
				return false;
			if (g.get(r-dr0).charAt(c-dc0) != 'S')
				return false;
			if (g.get(r-dr1).charAt(c-dc1) != 'S')
				return false;
		} catch (IndexOutOfBoundsException e) {
			return false;
		}
		return true;
	}
}
