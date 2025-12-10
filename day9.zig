const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(9);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const points = try parse_input(file_content);
    var max: u64 = 0;
    var i: usize = 0;
    while (i < points.items.len) : (i += 1) {
        var j: usize = i + 1;
        while (j < points.items.len) : (j += 1) {
            const a = points.items[i];
            const b = points.items[j];
            const width = 1 + if (a.x > b.x) a.x - b.x else b.x - a.x;
            const height = 1 + if (a.y > b.y) a.y - b.y else b.y - a.y;
            const area = width * height;
            if (area > max) {
                max = area;
            }
        }
    }
    return max;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(9);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

const Point = struct { x: u64, y: u64 };

fn parse_input(s: []const u8) !std.ArrayList(Point) {
    var points = std.ArrayList(Point).init(std.heap.page_allocator);
    var lines = std.mem.splitSequence(u8, s, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var words = std.mem.splitSequence(u8, line, ",");
        try points.append(Point{
            .x = util.stringToInt(words.next().?),
            .y = util.stringToInt(words.next().?),
        });
    }
    return points;
}

test "problem_1_example" {
    const input = "7,1\n11,1\n11,7\n9,7\n9,5\n2,5\n2,3\n7,3\n";
    try std.testing.expectEqual(50, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(4761736832, problem_1());
}
test "problem_2_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
