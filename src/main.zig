const std = @import("std");
const lib = @import("zmcl_lib");
const Chameleon = @import("chameleon");
const help = @import("help.zig");
const i18n = @import("i18n.zig");
const json = @import("json");
const Sys = enum {
    Linux, Mac, Windows, FreeBSD
};

pub fn main() !void {
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
        // 拿到一个allocator
        const gpa_alloc = gpa.allocator();
        // defer 用于执行general_purpose_allocator善后工作
        defer {
            const deinit_status = gpa.deinit();
            if (deinit_status == .leak) @panic("ALLOCATOR DEINIT FAIL!");
        }
        // 对通用内存分配器进行一层包裹
        var arena = std.heap.ArenaAllocator.init(gpa_alloc);
        // defer 最后释放内存
        defer arena.deinit();
    const arena_alloc = arena.allocator();

    // Get command line args
    const args = try std.process.argsAlloc(arena_alloc);
    defer std.process.argsFree(arena_alloc, args);
    if (args.len == 1) {
        try help.print("all");
        exit(1);
    }

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // Don't forget to flush!
    try test_json(arena_alloc);
}

fn exit(exit_code: u8) void {
    std.process.exit(exit_code);
}

fn test_json(alloc: std.mem.Allocator) !void {
    const value = try json.parse(
        \\{
        \\  "foo": [
        \\    null,
        \\    true,
        \\    false,
        \\    "bar",
        \\    {
        \\      "baz": -13e+37
        \\    }
        \\  ]
        \\}
        , alloc);
    const bazObj = value.get("foo").get(4);

    bazObj.print(null);
    try std.testing.expectEqual(bazObj.get("baz").float(), -13e+37);
}
