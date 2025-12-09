const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(7);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    var lines = std.mem.splitSequence(u8, file_content, "\n");

    var active = std.ArrayList(bool).init(std.heap.page_allocator);
    const first_line = lines.next().?;
    for (first_line) |c| {
        try active.append(c == 'S');
    }
    var num_splits: u64 = 0;
    while (lines.next()) |line| {
        var next_active = active.items[0];
        for (line, 0..) |c, i| {
            const this_active = next_active;
            if (i + 1 < active.items.len) {
                next_active = active.items[i + 1];
            }
            if (this_active and c == '^') {
                num_splits += 1;
                if (i > 0) {
                    active.items[i - 1] = true;
                }
                active.items[i] = false;
                if (i + 1 < active.items.len) {
                    active.items[i + 1] = true;
                }
            }
        }
    }
    return num_splits;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(7);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

test "problem_1_example" {
    const input = ".......S.......\n...............\n.......^.......\n...............\n......^.^......\n...............\n.....^.^.^.....\n...............\n....^.^...^....\n...............\n...^.^...^.^...\n...............\n..^...^.....^..\n...............\n.^.^.^.^.^...^.\n...............\n";
    try std.testing.expectEqual(21, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(1499, problem_1());
}
test "problem_2_example" {
    const input = ".......S.......\n...............\n.......^.......\n...............\n......^.^......\n...............\n.....^.^.^.....\n...............\n....^.^...^....\n...............\n...^.^...^.^...\n...............\n..^...^.....^..\n...............\n.^.^.^.^.^...^.\n...............\n";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
