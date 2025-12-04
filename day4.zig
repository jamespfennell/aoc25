const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(4);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(4);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

test "problem_1_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(0, problem_1());
}
test "problem_2_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
