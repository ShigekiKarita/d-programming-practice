/++TEST++

>>> Q0
5
MASHIKE
RUMOI
OBIRA
HABORO
HOROKANAI
===
2
<<<

>>> Q1
4
ZZ
ZZZ
Z
ZZZZZZZZZZ
===
0
<<<

>>> Q2
5
CHOKUDAI
RNG
MAKOTO
AOKI
RINGO
===
7
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
    