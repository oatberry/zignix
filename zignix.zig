const builtin = @import("builtin");
const terminal = @import("terminal.zig");

const MultiBoot = packed struct.{
    magic: c_long,
    flags: c_long,
    checksum: c_long,
};

const ALIGN = 1 << 0;
const MEMINFO = 1 << 1;
const MAGIC = 0x1BADB002;
const FLAGS = ALIGN | MEMINFO;

export var multiboot align(4) section(".multiboot") = MultiBoot.{
    .magic = MAGIC,
    .flags = FLAGS,
    .checksum = -(MAGIC + FLAGS),
};

export var stack_bytes: [16 * 1024]u8 align(16) section(".bss") = undefined;
const stack_bytes_slice = stack_bytes[0..];

export nakedcc fn _start() noreturn {
    @newStackCall(stack_bytes_slice, kmain);
    while (true) {}
}

fn kmain() void {
    terminal.initialize();
    terminal.write("hellOS 0.1.0\n\n");
    var i = u8(0);
    while (true) {
        terminal.putchar(i);
        terminal.write(" Hello, world!\n");
        if (i == 255) {
            i = 0;
        } else {
            i += 1;
        }
    }
}

pub fn panic(msg: []const u8, error_return_trace: ?*builtin.StackTrace) noreturn {
    @setCold(true);
    terminal.write("KERNEL PANIC: ");
    terminal.write(msg);
    while (true) {}
}
