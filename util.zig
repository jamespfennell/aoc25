pub fn stringToInt(s: []const u8) u32 {
    var r: u32 = 0;
    for (s) |c| {
        r = r * 10 + (c - '0');
    }
    return r;
}
