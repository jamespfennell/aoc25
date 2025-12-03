const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(1);
    const instructions = try parse_input(file_content);
    defer instructions.deinit();

    var sum: u64 = 50;
    var num_zeros: u64 = 0;
    for (instructions.items) |item| {
        switch (item.direction) {
            Direction.left => {
                sum = (sum + 100 - (item.distance % 100)) % 100;
            },
            Direction.right => {
                sum = (sum + item.distance) % 100;
            },
        }
        if (sum == 0) {
            num_zeros += 1;
        }
    }
    return num_zeros;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(1);
    const instructions = try parse_input(file_content);
    defer instructions.deinit();

    var sum: u64 = 50;
    var num_zeros: u64 = 0;
    for (instructions.items) |item| {
        switch (item.direction) {
            Direction.left => {
                sum = (100 - sum) % 100;
                num_zeros += (sum + item.distance) / 100;
                sum = (sum + item.distance) % 100;
                sum = (100 - sum) % 100;
            },
            Direction.right => {
                num_zeros += (sum + item.distance) / 100;
                sum = (sum + item.distance) % 100;
            },
        }
    }
    return num_zeros;
}

const Direction = enum { left, right };

const Instruction = struct {
    direction: Direction,
    distance: u64,
};

fn parse_input(s: []const u8) !std.ArrayList(Instruction) {
    var list = std.ArrayList(Instruction).init(std.heap.page_allocator);
    var iter = std.mem.splitSequence(u8, s, "\n");
    while (iter.next()) |entry| {
        if (entry.len == 0) {
            continue;
        }
        const direction = if (entry[0] == 'L') Direction.left else Direction.right;
        const distance = util.stringToInt(entry[1..]);
        try list.append(Instruction{ .direction = direction, .distance = distance });
    }
    return list;
}

test "problem_1" {
    try std.testing.expectEqual(1081, problem_1());
}

test "problem_2" {
    try std.testing.expectEqual(6689, problem_2());
}
