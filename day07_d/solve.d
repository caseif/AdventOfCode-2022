import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.format;
import std.stdio;

const string CMD_PREFIX = "$";
const string CD_PREFIX = "$ cd ";
const string LS_CMD = "$ ls";
const string DIR_PREFIX = "dir";
const string PARENT_MAGIC = "..";

const string ROOT_DIR_NAME = "/";

const uint PART_A_THRESHOLD = 100000;
const uint PART_B_THRESHOLD = 30000000;

const uint FS_SIZE = 70000000;

enum CommandType {
    Ls,
    Cd
}

class Node {
    DirectoryNode parent;
    string name;

    this(DirectoryNode parent, string name) {
        this.parent = parent;
        this.name = name;
    }

    abstract uint get_size();

    abstract string get_path();
}

class DirectoryNode : Node {
    Node[string] children;

    this(DirectoryNode parent, string name) {
        super(parent, name);
    }

    override uint get_size() {
        uint sum = 0;
        foreach (child; this.children.byValue()) {
            sum += child.get_size();
        }

        return sum;
    }

    override string get_path() {
        if (this.parent is null) {
            return this.name;
        } else {
            return format("%s%s/", this.parent.get_path(), this.name);
        }
    }
}

class FileNode : Node {
    uint size;

    this(DirectoryNode parent, string name, uint size) {
        super(parent, name);
        this.size = size;
    }

    override uint get_size() {
        return this.size;
    }

    override string get_path() {
        return format("%s%s", this.parent.get_path(), this.name);
    }
}

string readlnWithoutLf(File file) {
    auto line = file.readln();
    if (line.length == 0) {
        return line;
    }
    return line[0..line.length - 1];
}

void main() {
    auto file = File("input.txt", "r");

    auto root_dir = new DirectoryNode(null, ROOT_DIR_NAME);
    DirectoryNode[] all_dirs = [root_dir];

    DirectoryNode cur_dir = root_dir;

    // we're going to skip the first line to simplify the code and just assume
    // we start in the root dir
    auto line = readlnWithoutLf(file);
    assert(line.startsWith(CMD_PREFIX));

    line = readlnWithoutLf(file);

    // each loop iteration assumes the next line has already been read into the
    // `line` variable
    while (!file.eof) {
        if (line.startsWith(CD_PREFIX)) {
            auto target_name = line[CD_PREFIX.length..line.length];

            if (target_name == PARENT_MAGIC) {
                cur_dir = cur_dir.parent;
            } else {
                cur_dir = cast(DirectoryNode)cur_dir.children[target_name];
            }

            line = readlnWithoutLf(file);
        } else if (line == LS_CMD) {
            while (!(line = readlnWithoutLf(file)).startsWith(CMD_PREFIX) && line != "") {
                auto split = line.split(" ");
                auto node_name = split[1];

                if (split[0] == DIR_PREFIX) {
                    // it's a directory
                    auto node = new DirectoryNode(cur_dir, node_name);
                    cur_dir.children[node_name] = node;
                    all_dirs ~= node;
                } else {
                    // it's a file
                    uint file_size = split[0].to!uint;
                    auto node = new FileNode(cur_dir, node_name, file_size);
                    cur_dir.children[node_name] = node;
                }
            }
        } else {
            assert(false);
        }
    }

    file.close();

    uint part_a_sum = 0;
    foreach (dir; all_dirs) {
        auto dir_size = dir.get_size();
        if (dir_size <= PART_A_THRESHOLD) {
            part_a_sum += dir.get_size();
        }
    }

    writefln("Part A: %u", part_a_sum);

    auto avail_space = FS_SIZE - root_dir.get_size();
    auto required_space = PART_B_THRESHOLD - avail_space;

    DirectoryNode[] part_b_dirs;
    foreach (dir; all_dirs) {
        auto dir_size = dir.get_size();
        if (dir_size >= required_space) {
            part_b_dirs ~= dir;
        }
    }

    part_b_dirs.sort!((a, b) => a.get_size() < b.get_size());

    writefln("Part B: %u", part_b_dirs[0].get_size());
}
