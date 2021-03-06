const builtin = @import("builtin");
const lib = @import("lib/index.zig");
const terminal = lib.terminal;

const MultiBoot = packed struct {
    magic: c_long,
    flags: c_long,
    checksum: c_long,
};

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

export var multiboot align(4) linksection(".multiboot") = MultiBoot {
    .magic = MAGIC,
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

export var stack_bytes: [16 * 1024]u8 align(16) linksection(".bss") = undefined;
const stack_bytes_slice = stack_bytes[0..];

export nakedcc fn _start() noreturn {
    @newStackCall(stack_bytes_slice, kmain);
    while (true) {}
}

fn kmain() void {
    terminal.initialize();
    terminal.print("zignix 0.1.0\n\n");
    terminal.print("hello, world!\n");
}

pub fn panic(msg: []const u8, error_return_trace: ?*builtin.StackTrace) noreturn {
    @setCold(true);
    terminal.print("KERNEL PANIC: ");
    terminal.print(msg);
    while (true) {}
}
