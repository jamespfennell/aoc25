const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(4);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const input = try parse_input(file_content);
    const n = input.items.len;
    const m = input.items[0].items.len;
    var i: usize = 0;
    var total: u64 = 0;
    while (i < n) : (i += 1) {
        var j: usize = 0;
        while (j < m) : (j += 1) {
            if (!input.items[i].items[j]) {
                continue;
            }
            var adjacent: usize = 0;
            var iter = util.AdjacentCoordsIter.new(n, m, i, j);

            while (iter.next()) |coords| {
                if (input.items[coords.i].items[coords.j]) {
                    adjacent += 1;
                }
            }
            if (adjacent < 4) {
                total += 1;
            }
        }
    }
    return total;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(4);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

fn parse_input(s: []const u8) !std.ArrayList(std.ArrayList(bool)) {
    var banks = std.ArrayList(std.ArrayList(bool)).init(std.heap.page_allocator);
    var lines = std.mem.splitSequence(u8, s, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var bank = std.ArrayList(bool).init(std.heap.page_allocator);
        for (line) |c| {
            try bank.append(c == '@');
        }
        try banks.append(bank);
    }
    return banks;
}

test "problem_1_example" {
    const input = "..@@.@@@@.\n@@@.@.@.@@\n@@@@@.@.@@\n@.@@@@..@.\n@@.@@@@.@@\n.@@@@@@@.@\n.@.@.@.@@@\n@.@@@.@@@@\n.@@@@@@@@.\n@.@.@@@.@.\n";
    try std.testing.expectEqual(13, problem_1_impl(input));
}

test "problem_1" {
    try std.testing.expectEqual(1320, problem_1());
}
test "problem_2_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
