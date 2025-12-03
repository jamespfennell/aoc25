const day_1 = @import("day1.zig");
const day_2 = @import("day2.zig");
const day_3 = @import("day3.zig");
const std = @import("std");
const util = @import("util.zig");

pub fn main() !void {
    var args = std.process.args();
    const program_name = args.next();
    _ = program_name;
    const day = if (args.next()) |s| util.stringToInt(s) else {
        std.debug.print("Error: day must be provided as a command line argument.\n", .{});
        return;
    };
    const problem = if (args.next()) |s| util.stringToInt(s) else {
        std.debug.print("Error: problem must be provided as a command line argument.\n", .{});
        return;
    };
    if (problem != 1 and problem != 2) {
        std.debug.print("Error: problem must be either 1 or 2; got {d}.\n", .{problem});
        return;
    }
    std.debug.print("Day: {d}; problem: {d}.\n", .{ day, problem });
    const solution = switch (day) {
        1 => try solve(problem, day_1),
        2 => try solve(problem, day_2),
        3 => try solve(problem, day_3),
        else => {
            std.debug.print("Error: invalid day {d}.\n", .{day});
            return;
        },
    };
    std.debug.print("Solution: {d}.\n", .{solution});
}

fn solve(
    problem: u64,
    comptime t: type,
) !u64 {
    if (problem == 1) {
        return t.problem_1();
    } else {
        return t.problem_2();
    }
}
