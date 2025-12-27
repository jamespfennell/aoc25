const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(11);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const label_to_out = try parse_input(file_content);

    var label_to_num_in = std.AutoHashMap(Label, usize).init(std.heap.page_allocator);
    {
        var iter = label_to_out.iterator();
        while (iter.next()) |entry| {
            if (!label_to_num_in.contains(entry.key_ptr.*)) {
                try label_to_num_in.put(entry.key_ptr.*, 0);
            }
            for (entry.value_ptr.*.items) |v| {
                if (!label_to_num_in.contains(v)) {
                    try label_to_num_in.put(v, 0);
                }
                label_to_num_in.getPtr(v).?.* += 1;
            }
        }
    }

    var terminals = std.ArrayList(Label).init(std.heap.page_allocator);
    {
        var iter = label_to_num_in.iterator();
        while (iter.next()) |entry| {
            if (entry.value_ptr.* == 0) {
                try terminals.append(entry.key_ptr.*);
            }
        }
    }

    var ordered = std.ArrayList(Label).init(std.heap.page_allocator);
    while (terminals.popOrNull()) |n| {
        try ordered.append(n);
        if (label_to_out.get(n)) |out| {
            for (out.items) |v| {
                const p = label_to_num_in.getPtr(v).?;
                p.* -= 1;
                if (p.* == 0) {
                    try terminals.append(v);
                }
            }
        }
    }

    var label_to_ways_out = std.AutoHashMap(Label, u64).init(std.heap.page_allocator);
    var iter = std.mem.reverseIterator(ordered.items);
    while (iter.next()) |label| {
        if (std.mem.eql(u8, &label, &Label{ 'o', 'u', 't' })) {
            try label_to_ways_out.put(label, 1);
        } else {
            try label_to_ways_out.put(label, 0);
        }
        const p = label_to_ways_out.getPtr(label).?;
        if (label_to_out.get(label)) |outs| {
            for (outs.items) |out| {
                p.* += label_to_ways_out.get(out).?;
            }
        }
    }
    const you = Label{ 'y', 'o', 'u' };
    return label_to_ways_out.get(you).?;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(11);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

const Label = [3]u8;

fn parse_input(s: []const u8) !std.AutoHashMap(Label, std.ArrayList(Label)) {
    var map = std.AutoHashMap(Label, std.ArrayList(Label)).init(std.heap.page_allocator);
    var lines = std.mem.splitSequence(u8, s, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        const key = Label{ line[0], line[1], line[2] };
        var out = std.ArrayList(Label).init(std.heap.page_allocator);
        var raw_labels = std.mem.splitSequence(u8, line[5..], " ");
        while (raw_labels.next()) |raw_label| {
            try out.append(Label{ raw_label[0], raw_label[1], raw_label[2] });
        }
        try map.put(key, out);
    }
    return map;
}

test "problem_1_example" {
    const input = "aaa: you hhh\nyou: bbb ccc\nbbb: ddd eee\nccc: ddd eee fff\nddd: ggg\neee: out\nfff: out\nggg: out\nhhh: ccc fff iii\niii: out\n";
    try std.testing.expectEqual(5, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(782, problem_1());
}
test "problem_2_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
