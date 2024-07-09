#include <algorithm>
#include <iostream>
#include <memory>
#include <numeric>
#include <sstream>
#include <vector>
std::vector<std::vector<int> > mktable(void) {
	auto table{std::vector<std::vector<int> >()};
	auto next{std::vector<int >()};
	std::string line;
	std::string last = "";
	std::string name = "";
	int i = -1;
	int j = 0;
	while (std::getline(std::cin, line)) {
		name = line.substr(0, line.find(" "));
		if (name != last) {
			i+= 1;
			j = 0;
			if (next.size() != 0) table.push_back(next);
			next.clear();
		}
		if ( i == j ) next.push_back(0);
		std::stringstream stream(line);
		std::string word;
		stream >> word;
		stream >> word;
		stream >> word;
		if (word == "lose") {
			stream >> word;
			next.push_back(-std::stoi(word));
		} else {
			stream >> word;
			next.push_back(std::stoi(word));
		}
		last = name;
		j += 1;
	}
	next.push_back(0);
	table.push_back(next);
	return table;
}
int compute(std::vector<std::vector<int> > const &table,
            std::vector<int> const pos) {
	int happiness = 0;
	int const p = pos.size();
	for (int i = 0; i < pos.size(); ++i) {
		happiness += table[pos[i]][pos[(i + 1)%p]];
		happiness += table[pos[i]][pos[(i + p - 1)%p]];
	}
	return happiness;
}
int partA(std::vector<std::vector<int> > const &table) {
	int happiness = INT_MIN;
	std::vector<int> pos(table.size());
	std::iota(pos.begin(), pos.end(), 0);
	while (pos[0] == 0) {
		happiness = std::max(happiness, compute(table,pos));
		std::next_permutation(pos.begin(), pos.end());
	}
	return happiness;
}
int partB(std::vector<std::vector<int> > &table) {
	for (int i = 0; i < table.size(); ++i) {
		table[i].push_back(0);
	}
	table.push_back(std::vector<int>(table.size() + 1));
	return partA(table);
}
int main() {
	std::vector<std::vector<int> > tbl = mktable();
	std::cout << partA(tbl) << " ";
	std::cout << partB(tbl) << std::endl;
	return 0;
}
