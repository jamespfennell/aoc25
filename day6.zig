const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(6);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const problems = try parse_input(file_content);
    var sum: u64 = 0;
    for (problems.items) |problem| {
        if (problem.op == '+') {
            for (problem.nums.items) |num| {
                sum += num;
            }
        } else {
            var product: u64 = 1;
            for (problem.nums.items) |num| {
                product *= num;
            }
            sum += product;
        }
    }
    return sum;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(6);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

const Problem = struct {
    op: u8,
    nums: std.ArrayList(u64),
};

fn parse_input(s: []const u8) !std.ArrayList(Problem) {
    var problems = std.ArrayList(Problem).init(std.heap.page_allocator);
    var lines = std.mem.splitSequence(u8, s, "\n");
    while (lines.next()) |line| {
        var it = std.mem.splitScalar(u8, line, ' ');
        var i: usize = 0;
        while (it.next()) |word| {
            if (word.len == 0) {
                continue;
            }
            if (problems.items.len <= i) {
                try problems.append(Problem{
                    .op = 0,
                    .nums = std.ArrayList(u64).init(std.heap.page_allocator),
                });
            }
            if (word[0] == '*' or word[0] == '+') {
                problems.items[i].op = word[0];
            } else {
                try problems.items[i].nums.append(util.stringToInt(word));
            }
            i += 1;
        }
    }
    return problems;
}

test "problem_1_example" {
    const input = "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314 \n *   +   *   +  ";
    try std.testing.expectEqual(4277556, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(4951502530386, problem_1());
}
test "problem_2_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
