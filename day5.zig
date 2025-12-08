const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(5);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const input = try parse_input(file_content);

    var i: usize = 0;
    var j: usize = 0;
    var sum: u64 = 0;
    while (i < input.ranges.items.len and j < input.ingredients.items.len) {
        const range = input.ranges.items[i];
        const ingredient = input.ingredients.items[j];
        // This range is too small. Try the next range.
        if (ingredient > range.upper) {
            i += 1;
            continue;
        }
        // We are going to consider this ingredient now.
        j += 1;
        if (ingredient < range.lower) {
            continue;
        }
        sum += 1;
    }
    return sum;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(5);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

const Range = struct {
    lower: u64,
    upper: u64, // inclusive

    pub fn less(_: void, a: Range, b: Range) bool {
        if (a.lower == b.lower) {
            return a.upper < b.upper;
        }
        return a.lower < b.lower;
    }
};
const Input = struct { ranges: std.ArrayList(Range), ingredients: std.ArrayList(u64) };

fn parse_input(s: []const u8) !Input {
    var input = Input{
        .ranges = std.ArrayList(Range).init(std.heap.page_allocator),
        .ingredients = std.ArrayList(u64).init(std.heap.page_allocator),
    };
    var lines = std.mem.splitSequence(u8, s, "\n");

    while (lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var words = std.mem.splitSequence(u8, line, "-");
        const lower = util.stringToInt(words.next().?);
        const upper = util.stringToInt(words.next().?);
        try input.ranges.append(Range{
            .lower = lower,
            .upper = upper,
        });
    }
    std.mem.sort(Range, input.ranges.items, {}, Range.less);

    while (lines.next()) |line| {
        if (line.len == 0) {
            break;
        }
        const n = util.stringToInt(line);
        try input.ingredients.append(n);
    }
    std.mem.sort(u64, input.ingredients.items, {}, comptime std.sort.asc(u64));
    return input;
}

test "problem_1_example" {
    const input = "3-5\n10-14\n16-20\n12-18\n\n1\n5\n8\n11\n17\n32\n";
    try std.testing.expectEqual(3, problem_1_impl(input));
}
test "problem_1" {
    // try std.testing.expectEqual(0, problem_1());
}
test "problem_2_example" {
    const input = "3-5\n10-14\n16-20\n12-18\n\n1\n5\n8\n11\n17\n32\n";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
