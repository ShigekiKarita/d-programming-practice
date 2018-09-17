/++TEST++

>>> Q0
6
G W Y P Y W
===
Four
<<<

>>> Q1
9
G W W G P W P G G
===
Three
<<<

>>> Q2
8
P Y W G Y W Y Y
===
Four
<<<

++TEST++/

import std.stdio, std.algorithm, std.range, std.format, std.numeric, std.string, std.conv, std.array;

auto readArray(T=int)(string s) {
    return s.split.map!(to!T).array;
}

void main() {
    int a, b;
    readf("%d %d\n", &a, &b);
}
    