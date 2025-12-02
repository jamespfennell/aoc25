const std = @import("std");

pub fn readInput(day: u32) ![]u8 {
    const allocator = std.heap.page_allocator;
    var b: [30]u8 = undefined;
    const file_path = try std.fmt.bufPrint(&b, "data/day{d}.txt", .{day});
    return try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
}

pub fn stringToInt(s: []const u8) u32 {
    var r: u32 = 0;
    for (s) |c| {
        r = r * 10 + (c - '0');
    }
    return r;
}
