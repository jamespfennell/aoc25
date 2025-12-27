const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(11);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const label_to_out = try parse_input(file_content);
    const ordered = try top_sort(label_to_out);
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
const WaysOut = struct {
    dac_only: u64,
    fft_only: u64,
    dac_and_fft: u64,
    neither: u64,

    fn update(self: *WaysOut, label: Label, other: WaysOut) void {
        if (std.mem.eql(u8, &label, &Label{ 'd', 'a', 'c' })) {
            self.dac_only += other.dac_only + other.neither;
            self.dac_and_fft += other.fft_only + other.dac_and_fft;
        } else if (std.mem.eql(u8, &label, &Label{ 'f', 'f', 't' })) {
            self.fft_only += other.fft_only + other.neither;
            self.dac_and_fft += other.dac_only + other.dac_and_fft;
        } else {
            self.dac_only += other.dac_only;
            self.fft_only += other.fft_only;
            self.dac_and_fft += other.dac_and_fft;
            self.neither += other.neither;
        }
    }
};

fn problem_2_impl(file_content: []const u8) !u64 {
    const label_to_out = try parse_input(file_content);
    const ordered = try top_sort(label_to_out);
    var label_to_ways_out = std.AutoHashMap(Label, WaysOut).init(std.heap.page_allocator);
    var iter = std.mem.reverseIterator(ordered.items);
    while (iter.next()) |label| {
        if (std.mem.eql(u8, &label, &Label{ 'o', 'u', 't' })) {
            try label_to_ways_out.put(label, WaysOut{
                .dac_only = 0,
                .fft_only = 0,
                .neither = 1,
                .dac_and_fft = 0,
            });
        } else {
            try label_to_ways_out.put(label, WaysOut{
                .dac_only = 0,
                .fft_only = 0,
                .neither = 0,
                .dac_and_fft = 0,
            });
        }
        const p = label_to_ways_out.getPtr(label).?;
        if (label_to_out.get(label)) |outs| {
            for (outs.items) |out| {
                p.update(label, label_to_ways_out.get(out).?);
            }
        }
    }
    const svr = Label{ 's', 'v', 'r' };
    return label_to_ways_out.get(svr).?.dac_and_fft;
}

fn top_sort(label_to_out: std.AutoHashMap(Label, std.ArrayList(Label))) !std.ArrayList(Label) {
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
    return ordered;
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
    const input = "svr: aaa bbb\naaa: fft\nfft: ccc\nbbb: tty\ntty: ccc\nccc: ddd eee\nddd: hub\nhub: fff\neee: dac\ndac: fff\nfff: ggg hhh\nggg: out\nhhh: out\n";
    try std.testing.expectEqual(2, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(401398751986160, problem_2());
}
