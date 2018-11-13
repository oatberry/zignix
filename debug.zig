const builtin = @import("builtin");

pub fn assert(ok: bool) void {
    if (!ok) {
        if (builtin.is_test) {
            @panic("assertion failure");
        }

        unreachable;
    }
}
