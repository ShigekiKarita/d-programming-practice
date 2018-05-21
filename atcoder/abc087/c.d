/++TEST++
>>> Q1
5
3 2 2 4 1
1 2 2 2 1
===
14
<<<

>>> Q2
4
1 1 1 1
1 1 1 1
===
5
<<<

>>> Q3
7
3 3 4 5 4 5 3
5 3 4 4 2 3 2
===
29
<<<

>>> Q4
1
2
3
===
5
<<<
++TEST++/

import std.stdio;
import std.algorithm;
import std.array;
import std.conv;

void main() {
    size_t n;
    string s1, s2;
    readf("%d\n%s\n%s\n", &n, &s1, &s2);
    auto a1 = s1.split.map!(to!int).array;
    auto a2 = s2.split.map!(to!int).array;
    foreach (i; 1..n) {
        a1[i] += a1[i-1];
        a2[n-i-1] += a2[n-i];
    }
    a1[] += a2[];
    sort(a1);
    writeln(a1[n-1]);
}
