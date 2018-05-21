/++TEST++

// TODO support multiple answers

>>> Q1
9 45000
===
0 9 0
<<<

>>> Q2
20 196000
===
-1 -1 -1
<<<

>>> Q3
1000 1234000
===
14 27 959
<<<

++TEST++/

import std.array;
import std.algorithm;
import std.range;
import std.stdio;


void main() {
    int n, y;
    readf("%d %d\n", &n, &y);
    foreach (i; 0 .. y / 10000 + 1) {
        foreach (j; 0 .. min(y / 5000 + 1, n - i + 1)) {
            auto k = n - i - j;
            if (i * 10000 + j * 5000 + k * 1000 == y) {
                writefln("%d %d %d", i, j, k);
                return;
            }
        }
    }
    writeln("-1 -1 -1");
}
