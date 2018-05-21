/++TEST++
>>> Q1
2
3 1 2
6 1 1
===
Yes
<<<

>>> Q2
1
2 100 100
===
No
<<<

>>> Q3
2
5 1 1
100 1 1
===
No
<<<
++TEST++/

import std.stdio;

struct Point {
    int t, x, y;
}

auto iabs(T)(T i) {
    return i >= 0 ? i : -i;
}

bool findPath(Point prev, Point next) {
    auto td = next.t - prev.t;
    auto xd = iabs(next.x - prev.x);
    auto yd = iabs(next.y - prev.y);
    if (td < xd + yd) return false;
    else return (xd + yd - td) % 2 == 0;
}

void main() {
    size_t n;
    readf("%d\n", &n);
    auto prev = Point(0, 0, 0);
    foreach (i; 0..n) {
        Point next;
        with (next) {
            readf("%d %d %d\n", &t, &x, &y);
        }
        if (!findPath(prev, next)) {
            writeln("No");
            return;
        }
        prev = next;
    }
    writeln("Yes");
}
