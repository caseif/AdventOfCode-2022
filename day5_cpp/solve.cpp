#include <fstream>
#include <regex>
#include <sstream>
#include <string>
#include <vector>

#include <cassert>

static std::vector<std::string> stacks_a = {
    "RNPG",
    "TJBLCSVH",
    "TDBMNL",
    "RVPSB",
    "GCQSWMVH",
    "WQSCDBJ",
    "FQL",
    "WMHTDLFV",
    "LPBVMJF"
};

static std::vector<std::string> stacks_b = stacks_a;

void move_crates_a(size_t src_index, size_t dest_index, size_t count) {
    auto src = stacks_a[src_index];
    auto dest = stacks_a[dest_index];

    auto src_begin = src.length() - count;
    auto crates = src.substr(src_begin, src.length());
    std::reverse(crates.begin(), crates.end());
    stacks_a[dest_index] = dest + crates;
    stacks_a[src_index] = src.substr(0, src_begin);
}

void move_crates_b(size_t src_index, size_t dest_index, size_t count) {
    auto src = stacks_b[src_index];
    auto dest = stacks_b[dest_index];

    auto src_begin = src.length() - count;
    auto crates = src.substr(src_begin, src.length());
    stacks_b[dest_index] = dest + crates;
    stacks_b[src_index] = src.substr(0, src_begin);
}

int main(int argc, char **argv) {
    std::ifstream infile("input.txt");

    std::regex line_regex("move (\\d+) from (\\d+) to (\\d+)");

    std::string line;
    while (std::getline(infile, line)) {
        std::smatch line_match;
        assert(std::regex_match(line, line_match, line_regex));
        auto count = std::stoi(line_match[1].str());
        auto src = std::stoi(line_match[2].str()) - 1;
        auto dest = std::stoi(line_match[3].str()) - 1;

        move_crates_a(src, dest, count);
        move_crates_b(src, dest, count);
    }

    printf("Part A: ");
    for (auto stack : stacks_a) {
        printf("%c", stack.at(stack.length() - 1));
    }
    printf("\n");

    printf("Part B: ");
    for (auto stack : stacks_b) {
        printf("%c", stack.at(stack.length() - 1));
    }
    printf("\n");

    return 0;
}
