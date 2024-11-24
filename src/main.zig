const std = @import("std");
const zap = @import("zap");
const print = std.debug.print;

fn on_request(r: zap.Request) void {
    if (r.path) |the_path| {
        print("PATH: {s}\n", .{the_path});
    }
    if (r.query) |the_query| {
        print("QUERY: {s}\n", .{the_query});
    }

    r.sendBody("<html><body><h1>Hello from ZAP!!!</h1></body></html>") catch return;
}

pub fn main() !void {
    var listener = zap.HttpListener.init(.{
        .port = 3000,
        .on_request = on_request,
        .log = true,
    });
    try listener.listen();

    print("Listening on 0.0.0.0:3000\n", .{});

    // start worker threads
    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}
