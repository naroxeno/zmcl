// 该文件封装了一些常用函数方便使用。
const std = @import("std");
pub fn strcmp(str1:[]const u8, str2:[]const u8) bool {
    return std.mem.eql(u8, str1, str2);
}
