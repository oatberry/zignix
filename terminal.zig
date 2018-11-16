const mem = @import("mem.zig");
const vga = @import("vga.zig");

var row = usize(0);
var column = usize(0);
var color = vga.entryColor(vga.Color.light_green, vga.Color.black);

var lines = comptime blk: {
    var slices: [vga.HEIGHT][] volatile u16 = undefined;
    var i: usize = 0;
    var j: usize = 0;
    while (i < vga.HEIGHT) {
        slices[i] = vga.OUTPUT[j..j + vga.WIDTH];
        j += vga.WIDTH;
        i += 1;
    }
    break :blk slices;
};

// zero out buffer
pub fn initialize() void {
    for (lines) |line, y| {
        for (line) |col, x| {
            @inlineCall(putchar_at, ' ', color, x, y);
        }
    }
}

fn newline() void {
    column = 0;
    if (row < vga.HEIGHT - 1) {
        row += 1;
    } else {
        scroll();
    }
}

fn scroll() void {
    var i = usize(0);
    while (i < lines.len - 1) : (i += 1) {
        @inlineCall(mem.volatile_copy, u16, lines[i], lines[i+1]);
    }

    for (lines[vga.HEIGHT - 1]) |x| {
        @inlineCall(putchar_at, ' ', color, x, vga.HEIGHT);
    }
}

fn set_color(new_color: u8) void {
    color = new_color;
}

fn putchar_at(c: u8, new_color: u8, x: usize, y: usize) void {
    const index = y * vga.WIDTH + x;
    vga.OUTPUT[index] = vga.entry(c, new_color);
}

pub fn putchar(c: u8) void {
    if (c == '\n') {
        newline();
        return;
    }

    putchar_at(c, color, column, row);
    column += 1;
    if (column >= vga.WIDTH) {
        newline();
    }
}

pub fn write(data: []const u8) void {
    for (data) |c| putchar(c);
}
