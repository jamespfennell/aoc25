const std = @import("std");
const util = @import("util.zig");

pub fn problem_1() !u64 {
    const file_content = try util.readInput(8);
    return problem_1_impl(file_content, 1000);
}

fn problem_1_impl(file_content: []const u8, iterations: usize) !u64 {
    const points = try parse_input(file_content);
    var point_to_cluster = std.AutoHashMap(u64, u64).init(std.heap.page_allocator);
    var clusters = std.AutoHashMap(u64, u64).init(std.heap.page_allocator);
    for (points.items, 0..) |_, i| {
        try point_to_cluster.put(i, i);
        try clusters.put(i, 1);
    }

    var pairs = std.ArrayList(Pair).init(std.heap.page_allocator);
    var i: usize = 0;
    while (i + 1 < points.items.len) : (i += 1) {
        var j: usize = i + 1;
        while (j < points.items.len) : (j += 1) {
            const a = points.items[i];
            const b = points.items[j];
            try pairs.append(Pair{
                .a = i,
                .b = j,
                .d_squared = a.d_squared(b),
            });
        }
    }
    std.mem.sort(Pair, pairs.items, {}, compare_pairs);

    i = 0;
    while (i < iterations) : (i += 1) {
        const pair = pairs.items[i];
        const cluster_a = point_to_cluster.get(pair.a).?;
        const cluster_b = point_to_cluster.get(pair.b).?;
        if (cluster_a == cluster_b) {
            continue;
        }
        // merge cluster_a and cluster_b
        try clusters.put(cluster_a, clusters.get(cluster_a).? + clusters.get(cluster_b).?);
        _ = clusters.remove(cluster_b);
        var iterator = point_to_cluster.iterator();
        while (iterator.next()) |entry| {
            if (entry.value_ptr.* == cluster_b) {
                entry.value_ptr.* = cluster_a;
            }
        }
    }

    const a = extract_max_value(&clusters);
    const b = extract_max_value(&clusters);
    const c = extract_max_value(&clusters);

    return a * b * c;
}

fn extract_max_value(m: *std.AutoHashMap(u64, u64)) u64 {
    var max: u64 = 0;
    var max_key: u64 = 0;
    var iterator = m.iterator();
    while (iterator.next()) |entry| {
        if (entry.value_ptr.* > max) {
            max = entry.value_ptr.*;
            max_key = entry.key_ptr.*;
        }
    }
    _ = m.remove(max_key);
    return max;
}

pub fn problem_2() !u64 {
    const file_content = try util.readInput(8);
    return problem_2_impl(file_content);
}

fn problem_2_impl(file_content: []const u8) !u64 {
    _ = file_content;
    return 0;
}

const Pair = struct { a: usize, b: usize, d_squared: u64 };

fn compare_pairs(i: void, a: Pair, b: Pair) bool {
    _ = i;
    return a.d_squared < b.d_squared;
}

const Point = struct {
    x: u64,
    y: u64,
    z: u64,

    fn d_squared(self: Point, other: Point) u64 {
        return self.x * self.x + other.x * other.x - 2 * self.x * other.x +
            self.y * self.y + other.y * other.y - 2 * self.y * other.y +
            self.z * self.z + other.z * other.z - 2 * self.z * other.z;
    }
};

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
            .z = util.stringToInt(words.next().?),
        });
    }
    return points;
}

test "problem_1_example" {
    const input = "162,817,812\n57,618,57\n906,360,560\n592,479,940\n352,342,300\n466,668,158\n542,29,236\n431,825,988\n739,650,466\n52,470,668\n216,146,977\n819,987,18\n117,168,530\n805,96,715\n346,949,466\n970,615,88\n941,993,340\n862,61,35\n984,92,344\n425,690,689";
    try std.testing.expectEqual(40, problem_1_impl(input, 10));
}
test "problem_1" {
    try std.testing.expectEqual(32103, problem_1());
}
test "problem_2_example" {
    const input = "";
    try std.testing.expectEqual(0, problem_2_impl(input));
}
test "problem_2" {
    try std.testing.expectEqual(0, problem_2());
}
