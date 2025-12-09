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
    var rows = std.ArrayList([]const u8).init(std.heap.page_allocator);
    var lines = std.mem.splitSequence(u8, file_content, "\n");
    var width: usize = 0;
    while (lines.next()) |line| {
        if (line.len > width) {
            width = line.len;
        }
        try rows.append(line);
    }

    var col = std.ArrayList(u8).init(std.heap.page_allocator);
    var i: usize = 0;
    var result: u64 = 0;
    var inner_result: u64 = 0;
    var current_op: u8 = ' ';
    while (i < width) : (i += 1) {
        try col.resize(0);
        for (rows.items) |row| {
            if (i < row.len and row[i] != ' ') {
                try col.append(row[i]);
            }
        }
        if (col.items.len == 0) {
            continue;
        }
        const last_char = col.items[col.items.len - 1];
        if (last_char == '*' or last_char == '+') {
            current_op = last_char;
            _ = col.pop();
            result += inner_result;
            if (last_char == '*') {
                inner_result = 1;
            } else {
                inner_result = 0;
            }
        }
        const n = util.stringToInt(col.items);
        if (current_op == '*') {
            inner_result *= n;
        } else {
            inner_result += n;
        }
    }
    return result + inner_result;
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
    const input = "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314 \n*   +   *   +  ";
    try std.testing.expectEqual(4277556, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(4951502530386, problem_1());
}
test "problem_2_example" {
    const input = "123 328  51 64 \n 45 64  387 23 \n  6 98  215 314 \n*   +   *   +  ";
    try std.testing.expectEqual(3263827, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(8486156119946, problem_2());
}
