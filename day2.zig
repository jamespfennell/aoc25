const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(2);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const ranges = try parse_input(file_content);
    var sum: u64 = 0;
    for (ranges.items) |range| {
        const lower_digits = num_digits(range.lower);
        const upper_digits = num_digits(range.upper);
        if (upper_digits - lower_digits > 1) {
            @panic("can't handle this kind of input");
        }
        if (lower_digits % 2 == 1 and upper_digits % 2 == 1) {
            // Range only contains numbers with odd numbers of digits -> can't be any doubles.
            continue;
        }
        var digits: u64 = 0;
        var lower: u64 = 0;
        var upper: u64 = 0;
        if (lower_digits % 2 == 1) {
            digits = upper_digits;
            lower = util.ten_to_pow(upper_digits - 1);
            upper = range.upper;
        } else if (upper_digits % 2 == 1) {
            digits = lower_digits;
            lower = range.lower;
            upper = util.ten_to_pow(lower_digits) - 1;
        } else {
            digits = lower_digits;
            lower = range.lower;
            upper = range.upper;
        }

        // doubles with the specified number of digits are evenly divisible by divisor
        // 1/2 digits * 11
        // 2/4 digits * 101
        // 3/6 digits * 1001
        // 4/8 digits * 10001
        const divisor: u64 = util.ten_to_pow(digits / 2) + 1;
        const n = sum_evenly_divisible(lower, upper, divisor);
        sum += n;

        std.debug.print("Range: {d}-{d}.\n", .{ range.lower, range.upper });
        std.debug.print("Range*: {d}-{d}.\n", .{ lower, upper });
        std.debug.print("n: {d}.\n", .{n});
    }
    return sum;
}
pub fn problem_2() !u64 {
    const file_content = try util.readInput(2);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    // 1 digit times 11 or 111 or 1111 or 11111
    // 2 digit times 101 or 10101 or 1010101 ...
    // 3 digit times 1001 or 1001001 or 1001001001
    // 4 digit times 10001 or 100010001...

    const ranges = try parse_input(file_content);
    var sum: u64 = 0;
    for (ranges.items) |range| {
        var n: u64 = range.lower;
        while (n <= range.upper) {
            // test if n has repeated digits
            const digits = num_digits(n);
            var num_repeating_digits: u64 = 1;
            // we divide digits by 2 because the digits must repeat at least once.
            while (num_repeating_digits <= digits / 2) {
                // how many times
                const num_repeats = digits / num_repeating_digits;
                if (num_repeating_digits * num_repeats != digits) {
                    num_repeating_digits += 1;
                    continue;
                }
                const base = util.ten_to_pow(num_repeating_digits);
                const repeating_digits = n % base;
                var j: u64 = 0;
                var n_new: u64 = 0;
                while (j < num_repeats) {
                    n_new = n_new * base + repeating_digits;
                    j += 1;
                }
                if (n_new == n) {
                    sum += n;
                    break;
                }
                // test if n consists of num_repeating_digits repeated k times
                num_repeating_digits += 1;
            }
            n += 1;
        }
    }
    return sum;
}

const Range = struct {
    lower: u64,
    upper: u64,
};

fn parse_input(s: []const u8) !std.ArrayList(Range) {
    var list = std.ArrayList(Range).init(std.heap.page_allocator);
    var ranges_iter = std.mem.splitSequence(u8, s, ",");
    while (ranges_iter.next()) |entry| {
        if (entry.len == 0) {
            continue;
        }
        var bounds_iter = std.mem.splitSequence(u8, entry, "-");
        const lower_s = if (bounds_iter.next()) |lower_s| lower_s else {
            continue;
        };
        const lower = util.stringToInt(lower_s);
        const upper_s = if (bounds_iter.next()) |upper_s| upper_s else {
            continue;
        };
        const upper = util.stringToInt(upper_s);
        try list.append(Range{ .lower = lower, .upper = upper });
    }
    return list;
}

pub fn num_digits(n: u64) u64 {
    var m: u64 = n;
    var d: u64 = 0;
    while (m > 0) {
        d += 1;
        m /= 10;
    }
    return d;
}

// Sum of the numbers in the range [lower, upper] that are evenly divisible by divisor.
pub fn sum_evenly_divisible(lower: u64, upper: u64, divisor: u64) u64 {
    std.debug.print("test: [{d},{d}] {d}.\n", .{ lower, upper, divisor });
    // l is the smallest number in >= lower that is evenly divisible by divisor.
    const l = (lower - 1) + divisor - (lower - 1) % divisor;
    // u is the largest number in <= upper] that is evenly divisible by divisor.
    const u = upper - upper % divisor;
    if (l > u) {
        return 0;
    }
    const n = (u - l) / divisor + 1;
    return l * n + divisor * n * (n - 1) / 2;
}

test "problem_1_example" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(1227775554, problem_1_impl(input));
}

test "problem_1" {
    try std.testing.expectEqual(34826702005, problem_1());
}

test "problem_2_example" {
    const input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124";
    try std.testing.expectEqual(4174379265, problem_2_impl(input));
}

test "problem_2" {
    try std.testing.expectEqual(43287141963, problem_2());
}
