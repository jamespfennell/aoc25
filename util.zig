const std = @import("std");

pub const Coords = struct { i: usize, j: usize };

pub const AdjacentCoordsIter = struct {
    i_upper: usize,
    j_upper: usize,
    i: usize,
    j: usize,
    state: usize,

    pub fn new(i_upper: usize, j_upper: usize, i: usize, j: usize) AdjacentCoordsIter {
        return AdjacentCoordsIter{
            .i_upper = i_upper,
            .j_upper = j_upper,
            .i = i,
            .j = j,
            .state = 0,
        };
    }
    pub fn next(self: *AdjacentCoordsIter) ?Coords {
        while (true) {
            const state = self.state;
            self.state += 1;
            switch (state) {
                0 => {
                    if (self.i > 0 and self.j > 0) {
                        return Coords{ .i = self.i - 1, .j = self.j - 1 };
                    }
                },
                1 => {
                    if (self.i > 0) {
                        return Coords{ .i = self.i - 1, .j = self.j };
                    }
                },
                2 => {
                    if (self.i > 0 and self.j + 1 < self.j_upper) {
                        return Coords{ .i = self.i - 1, .j = self.j + 1 };
                    }
                },
                3 => {
                    if (self.j > 0) {
                        return Coords{ .i = self.i, .j = self.j - 1 };
                    }
                },
                4 => {
                    if (self.j + 1 < self.j_upper) {
                        return Coords{ .i = self.i, .j = self.j + 1 };
                    }
                },
                5 => {
                    if (self.i + 1 < self.i_upper and self.j > 0) {
                        return Coords{ .i = self.i + 1, .j = self.j - 1 };
                    }
                },
                6 => {
                    if (self.i + 1 < self.i_upper) {
                        return Coords{ .i = self.i + 1, .j = self.j };
                    }
                },
                7 => {
                    if (self.i + 1 < self.i_upper and self.j + 1 < self.j_upper) {
                        return Coords{ .i = self.i + 1, .j = self.j + 1 };
                    }
                },
                else => {
                    return null;
                },
            }
        }
    }
};

pub fn readInput(day: u32) ![]u8 {
    const allocator = std.heap.page_allocator;
    var b: [30]u8 = undefined;
    const file_path = try std.fmt.bufPrint(&b, "data/day{d}.txt", .{day});
    return try std.fs.cwd().readFileAlloc(allocator, file_path, std.math.maxInt(usize));
}

pub fn stringToInt(s: []const u8) u64 {
    var r: u64 = 0;
    for (s) |c| {
        if (c < '0' or c > '9') {
            break;
        }
        r = r * 10 + (c - '0');
    }
    return r;
}

pub const Max = struct {
    value: u8,
    index: usize,
};

pub fn max(i: []const u8) Max {
    var m = Max{ .value = 0, .index = 0 };
    for (i, 0..) |elem, index| {
        if (elem > m.value) {
            m = Max{ .value = elem, .index = index };
        }
    }
    return m;
}

pub fn ten_to_pow(e: u64) u64 {
    var d = e;
    if (d == 0) {
        return 1;
    }
    var r: u64 = 10;
    while (d > 1) {
        r *= 10;
        d -= 1;
    }
    return r;
}
