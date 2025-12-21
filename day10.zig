const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(10);
    return problem_1_impl(file_content);
}

fn problem_1_impl(file_content: []const u8) !u64 {
    const machines = try parse_input(file_content);
    var sum: u64 = 0;
    for (machines.items) |machine| {
        var diagram = std.ArrayList(bool).init(std.heap.page_allocator);
        var min: u64 = std.math.maxInt(u64);
        var it = PowerSetIterator.new(machine.buttons.items.len);
        while (it.next()) |e| {
            var elem = e;
            diagram.items.len = 0;
            for (machine.diagram.items) |d| {
                try diagram.append(d);
            }
            // this is a candidate for the set of buttons to press
            var num_buttons: u64 = 0;
            while (elem.next()) |i| {
                num_buttons += 1;
                const button = machine.buttons.items[i];
                for (button.items) |j| {
                    diagram.items[j] = !diagram.items[j];
                }
            }
            if (contains_true(diagram.items)) {
                continue;
            }
            // Check that the diagram is off
            if (num_buttons < min) {
                min = num_buttons;
            }
        }
        sum += min;
    }
    return sum;
}

fn contains_true(s: []const bool) bool {
    for (s) |b| {
        if (b) {
            return true;
        }
    }
    return false;
}

const PowerSetIterator = struct {
    n: usize,

    fn new(set_size: usize) PowerSetIterator {
        var n: usize = 1;
        var i: usize = 0;
        while (i < set_size) : (i += 1) {
            n *= 2;
        }
        return PowerSetIterator{ .n = n };
    }

    fn next(self: *PowerSetIterator) ?PowerSetElementIterator {
        if (self.n == 0) {
            return null;
        }
        self.n -= 1;
        return PowerSetElementIterator{ .n = self.n, .m = 0 };
    }
};

const PowerSetElementIterator = struct {
    n: usize,
    m: usize,
    fn next(self: *PowerSetElementIterator) ?usize {
        while (self.n > 0) {
            const m = self.m;
            const r = self.n % 2 == 1;
            self.m += 1;
            self.n /= 2;
            if (r) {
                return m;
            }
        }
        return null;
    }
};

pub fn problem_2() !u64 {
    const file_content = try util.readInput(10);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

const Machine = struct {
    diagram: std.ArrayList(bool),
    buttons: std.ArrayList(std.ArrayList(u64)),
    joltages: std.ArrayList(u64),
};

fn parse_input(s: []const u8) !std.ArrayList(Machine) {
    var machines = std.ArrayList(Machine).init(std.heap.page_allocator);
    var lines = std.mem.splitSequence(u8, s, "\n");
    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }
        var machine = Machine{
            .diagram = std.ArrayList(bool).init(std.heap.page_allocator),
            .buttons = std.ArrayList(std.ArrayList(u64)).init(std.heap.page_allocator),
            .joltages = std.ArrayList(u64).init(std.heap.page_allocator),
        };
        const Parsing = enum { diagram, buttons, joltages, done };
        var parsing: Parsing = Parsing.diagram;
        var i: usize = 0;
        while (i < line.len) {
            const c = line[i];
            i += 1;
            switch (c) {
                '[' => {
                    std.debug.assert(parsing == Parsing.diagram);
                },
                '.', '#' => {
                    std.debug.assert(parsing == Parsing.diagram);
                    try machine.diagram.append(c == '#');
                },
                ']' => {
                    std.debug.assert(parsing == Parsing.diagram);
                    parsing = Parsing.buttons;
                },
                ' ' => {},
                '(' => {
                    std.debug.assert(parsing == Parsing.buttons);
                    var button = std.ArrayList(u64).init(std.heap.page_allocator);
                    var r: u64 = 0;
                    while (i < line.len) {
                        const d = line[i];
                        i += 1;
                        switch (d) {
                            '0'...'9' => {
                                r = r * 10 + (d - '0');
                            },
                            ',' => {
                                try button.append(r);
                                r = 0;
                            },
                            ')' => {
                                try button.append(r);
                                r = 0;
                                break;
                            },
                            else => {
                                std.debug.assert(false);
                            },
                        }
                    }
                    try machine.buttons.append(button);
                },
                '{' => {
                    std.debug.assert(parsing == Parsing.buttons);
                    parsing = Parsing.joltages;
                    var r: u64 = 0;
                    while (i < line.len) {
                        const d = line[i];
                        i += 1;
                        switch (d) {
                            '0'...'9' => {
                                r = r * 10 + (d - '0');
                            },
                            ',' => {
                                try machine.joltages.append(r);
                                r = 0;
                            },
                            '}' => {
                                try machine.joltages.append(r);
                                r = 0;
                                break;
                            },
                            else => {
                                std.debug.assert(false);
                            },
                        }
                    }
                    parsing = Parsing.done;
                },
                else => {
                    std.debug.assert(false);
                },
            }
        }
        try machines.append(machine);
    }
    return machines;
}

test "problem_1_example" {
    const input = "[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}\n[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}\n[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}\n";
    try std.testing.expectEqual(7, problem_1_impl(input));
}
test "problem_1" {
    try std.testing.expectEqual(425, problem_1());
}
test "problem_2_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
