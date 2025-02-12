const std = @import("std");
const ProcessPriority = enum { Low, Normal, High, Realtime };
const Render = enum { OpenGl, Zink };
const LaunchArgs = struct {
    path: struct {
        // Minecraft资源文件所在目录
        mc: []const u8,
        // minecraft.jar路径
        jar: []const u8,
        // Java可执行文件路径
        java: []const u8,
    },
    fullscreen: bool = false,
    solution: [2] u16,
    maxMem: usize, // 以mb为单位
    minMem: usize,
    use: struct {
        // Linux & FreeBSD only.
        SysGLFW: bool = false,
        SysOpenAL: bool = false,
    } = .{},
    env: []const u8 = "",
    jvm_args: []const u8 = "",
    priority: ProcessPriority = ProcessPriority.Normal,
    render: Render = Render.OpenGl,
    };

pub fn getScript(alloc: std.mem.Allocator, args:LaunchArgs) ![]const u8 {
    return try std.fmt.allocPrint(alloc,
        \\{s}
        \\cd {s}
        \\{s}{s}
        , .{
        try getEnv(alloc, args.env, args.render),
        args.path.mc,

        // JVM参数部分
        "-Dfile.encoding=UTF-8 -Dstdout.encoding=UTF-8 -Dstderr.encoding=UTF-8",

    });
}

fn getEnv(alloc: std.mem.Allocator, env: []const u8, render: Render) ![]const u8 {
    return try std.mem.concat(alloc, u8, &[_][]const u8{
        env, "\n",
        switch (render) {
            Render.Zink => \\
                           \\
        }
    });
}
