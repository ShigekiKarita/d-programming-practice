/++TEST++

>>> Q1
2
3 1
===
2
<<<

>>> Q2
3
2 7 4
===
5
<<<

>>> Q3
4
20 18 2 18
===
18
<<<

++TEST++/

import std.stdio;
import std.algorithm;
import std.array;
import std.conv;
import std.range;

void main() {
    size_t n;
    string s;
    readf("%d\n%s\n", &n, &s);
    auto a = s.split.map!(to!int).array;
    assert(a.length == n);
    sort!"a > b"(a);
    int alice, bob;
    foreach (i, e; a) {
        if (i % 2 == 0) alice += e;
        else bob += e;
    }
    writeln(alice - bob);
}
