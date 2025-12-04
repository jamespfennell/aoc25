const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(3);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const banks = try parse_input(file_content);
    var total: u64 = 0;
    for (banks.items) |bank| {
        const a = util.max(bank.items[0 .. bank.items.len - 1]);
        const b = util.max(bank.items[a.index + 1 .. bank.items.len]);
        total += a.value * 10 + b.value;
    }
    return total;
}
pub fn problem_2() !u64 {
    const file_content = try util.readInput(3);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    const banks = try parse_input(file_content);
    var total: u64 = 0;
    for (banks.items) |bank| {
        var i: usize = 0;
        var start: usize = 0;
        while (i < 12) : (i += 1) {
            const m = util.max(bank.items[start .. bank.items.len - (11 - i)]);
            start += m.index + 1;
            total += util.ten_to_pow(11 - i) * m.value;
        }
    }
    return total;
}

const Range = struct {
    lower: u64,
    upper: u64,
};

fn parse_input(s: []const u8) !std.ArrayList(std.ArrayList(u8)) {
    var banks = std.ArrayList(std.ArrayList(u8)).init(std.heap.page_allocator);
    var lines = std.mem.splitSequence(u8, s, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        var bank = std.ArrayList(u8).init(std.heap.page_allocator);
        for (line) |c| {
            try bank.append(c - '0');
        }
        try banks.append(bank);
    }
    return banks;
}

test "problem_1_example" {
    const input = "987654321111111\n811111111111119\n234234234234278\n818181911112111\n";
    try std.testing.expectEqual(357, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(17766, problem_1());
}
test "problem_2_example" {
    const input = "987654321111111\n811111111111119\n234234234234278\n818181911112111\n";
    try std.testing.expectEqual(3121910778619, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(176582889354075, problem_2());
}
