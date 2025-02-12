const std = @import("std");
const l = @import("utils.zig");
const Chameleon = @import("chameleon");

pub fn print(cmd: []const u8) !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    const msg = get_msg(cmd);
    try stdout.print("{s}", .{msg});
    try bw.flush();
}

fn get_msg(cmd: []const u8) []const u8 {
    if (l.strcmp(cmd, "all")) {
        return "";
    }
    return "";
}
