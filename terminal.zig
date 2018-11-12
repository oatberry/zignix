const mem = @import("mem.zig");

var row = usize(0);
var column = usize(0);
var color = vga_entry_color(VgaColor.light_grey, VgaColor.black);

const VGA_WIDTH = 80;
const VGA_HEIGHT = 25;
const bufferlen = VGA_WIDTH * VGA_HEIGHT;
const buffer = @intToPtr([*]volatile u16, 0xB8000);
var lines: [VGA_HEIGHT][]volatile u16 = undefined;

pub fn initialize() void {
    // set up lines slice
    var i = usize(0);
    var j = usize(0);
    while (i < VGA_HEIGHT) {
        lines[i] = buffer[j..j+VGA_WIDTH];
        j += VGA_WIDTH;
        i += 1;
    }

    // zero out buffer
    for (lines) |line, y| {
        for (line) |col, x| {
            @inlineCall(putchar_at, ' ', color, x, y);
        }
    }
}

fn newline() void {
    column = 0;
    if (row < VGA_HEIGHT-1) {
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

    for (lines[VGA_HEIGHT-1]) |x| {
        @inlineCall(putchar_at, ' ', color, x, VGA_HEIGHT);
    }
}

fn set_color(new_color: u8) void {
    color = new_color;
}

fn putchar_at(c: u8, new_color: u8, x: usize, y: usize) void {
    const index = y * VGA_WIDTH + x;
    buffer[index] = vga_entry(c, new_color);
}

pub fn putchar(c: u8) void {
    if (c == '\n') {
        newline();
        return;
    }

    putchar_at(c, color, column, row);
    column += 1;
    if (column >= VGA_WIDTH) {
        newline();
    }
}

pub fn write(data: []const u8) void {
    for (data) |c| putchar(c);
}

const VgaColor = enum(u8).{
    black = 0,
    blue = 1,
    green = 2,
    cyan = 3,
    red = 4,
    magenta = 5,
    brown = 6,
    light_grey = 7,
    dark_grey = 8,
    light_blue = 9,
    light_green = 10,
    light_cyan = 11,
    light_red = 12,
    light_magenta = 13,
    light_brown = 14,
    white = 15,
};

fn vga_entry_color(fg: VgaColor, bg: VgaColor) u8 {
    return @enumToInt(fg) | (@enumToInt(bg) << 4);
}

fn vga_entry(char: u8, colorcode: u8) u16 {
    return u16(char) | (u16(colorcode) << 8);
}
