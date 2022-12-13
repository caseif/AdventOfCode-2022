const std = @import("std");

const MAGIC_CYCLES = [_]u32{ 19, 59, 99, 139, 179, 219 }; // problem uses 1-indexing, we use 0

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var stream = buf_reader.reader();
    var buf: [16]u8 = undefined;

    var screen_buf: [41 * 6]u8 = undefined;

    var cur_cycle: usize = 0;
    var acc_val: i32 = 1;
    var sum: i32 = 0;

    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var op_add: i32 = 0;
        var cycle_add: i32 = 0;

        if (std.mem.eql(u8, line, "noop")) {
            cycle_add = 1;
        } else {
            cycle_add = 2;
            var line_arr = std.mem.split(u8, line, " ");
            _ = line_arr.next();
            var operand: i32 = 0;
            if (line_arr.next()) |v| {
                operand = try std.fmt.parseInt(i32, v, 10);
            }
            op_add = operand;
        }

        var i: usize = 0;
        while (i < cycle_add) : (i += 1) {
            var pix_x: usize = @mod(cur_cycle, 40);
            var pix_y: usize = @divTrunc(cur_cycle, 40);
            var buf_off: usize = (pix_y * 41) + pix_x; // to account for newlines

            if ((acc_val == @intCast(i32, pix_x) - 1)
                    or (acc_val == pix_x)
                    or (acc_val == pix_x + 1)) {
                screen_buf[buf_off] = '#';
            } else {
                screen_buf[buf_off] = '.';
            }
            if (pix_x == 39) {
                screen_buf[buf_off + 1] = '\n';
            }

            for (MAGIC_CYCLES) |magic| {
                if (magic == cur_cycle) {
                    sum += @intCast(i32, cur_cycle) * acc_val;
                }
            }

            cur_cycle += 1;
        }

        acc_val += op_add;
    }

    std.debug.print("Part A: {d}\n", .{ sum });

    std.debug.print("Part B:\n{s}\n", .{ screen_buf });
}
