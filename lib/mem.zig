const assert = @import("debug.zig").assert;

pub fn copy(comptime T: type, dest: []T, source: []const T) void {
    @setRuntimeSafety(false);
    assert(dest.len >= source.len);

    for (source) |s, i| {
        dest[i] = s;
    }
}

pub fn volatile_copy(
    comptime T : type,
    dest       : []volatile T,
    source     : []const volatile T
) void {
    @setRuntimeSafety(false);
    assert(dest.len >= source.len);

    for (source) |s, i| {
        dest[i] = s;
    }
}
