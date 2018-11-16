pub const WIDTH = 80;
pub const HEIGHT = 25;
pub const LENGTH = WIDTH * HEIGHT;
pub const OUTPUT = @intToPtr([*]volatile u16, 0xB8000);

pub const Color = enum(u8) {
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

pub fn entryColor(fg: Color, bg: Color) u8 {
    return @enumToInt(fg) | (@enumToInt(bg) << 4);
}

pub fn entry(char: u8, colorcode: u8) u16 {
    return u16(char) | (u16(colorcode) << 8);
}
