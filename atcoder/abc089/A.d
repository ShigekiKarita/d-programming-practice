/++TEST++

>>> Q0
8
===
2
<<<

>>> Q1
2
===
0
<<<

>>> Q2
9
===
3
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
    