const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !void {
    const allocator = std.heap.page_allocator; // Or another suitable allocator

    // Define the path to the file you want to read
    const file_path = "data/day1.txt";

    // Read the file's content into a byte slice
    const file_content = try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
    defer allocator.free(file_content); // Remember to free the allocated memory

    // Now, 'file_content' holds the entire file as a byte slice.
    // You can print it or process it further.
    std.debug.print("File content:\n{s}\n", .{file_content});

    var sum: u32 = 50;
    var num_zeros: u32 = 0;
    var iter = std.mem.splitSequence(u8, file_content, "\n");
    while (iter.next()) |entry| {
        if (entry.len != 0) {
            const i = util.stringToInt(entry[1..]) % 100;
            std.debug.print("Line content: \"{s}\" {d} sum {d}\n", .{ entry, i, sum });
            if (entry[0] == 'R') {
                sum = (sum + i) % 100;
            }
            if (entry[0] == 'L') {
                sum = (sum + 100 - i) % 100;
            }
            if (sum == 0) {
                num_zeros += 1;
            }
        }
    }
    std.debug.print("Answer: {d}\n", .{num_zeros});

    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // Don't forget to flush!
}

pub fn problem_2() !void {
    const allocator = std.heap.page_allocator; // Or another suitable allocator

    // Define the path to the file you want to read
    const file_path = "data/day1.txt";

    // Read the file's content into a byte slice
    const file_content = try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
    defer allocator.free(file_content); // Remember to free the allocated memory

    // Now, 'file_content' holds the entire file as a byte slice.
    // You can print it or process it further.
    std.debug.print("File content:\n{s}\n", .{file_content});

    var sum: u32 = 50;
    var num_zeros: u32 = 0;
    var iter = std.mem.splitSequence(u8, file_content, "\n");
    while (iter.next()) |entry| {
        if (entry.len != 0) {
            const i = util.stringToInt(entry[1..]);
            std.debug.print("Line content: \"{s}\" {d} sum {d}\n", .{ entry, i, sum });
            if (entry[0] == 'R') {
                num_zeros += (sum + i) / 100;
                sum = (sum + i) % 100;
            }
            if (entry[0] == 'L') {
                sum = (100 - sum) % 100;
                num_zeros += (sum + i) / 100;
                sum = (sum + i) % 100;
                sum = (100 - sum) % 100;
            }
        }
    }
    std.debug.print("Answer: {d}\n", .{num_zeros});

    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // Don't forget to flush!
}
