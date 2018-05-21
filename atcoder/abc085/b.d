/++TEST++

>>> Q1
4
10
8
8
6
===
3
<<<

>>> Q2
3
15
15
15
===
1
<<<

>>> Q3
7
50
30
50
100
50
80
30
===
4
<<<

++TEST++/

import std.array;
import std.algorithm;
import std.range;
import std.stdio;

void main() {
    int n;
    readf("%d\n", &n);
    int[] d;
    d.length = n;
    for (int i = 0; i < n; ++i) {
        readf("%d\n", &d[i]);
    }
    writeln(d.sort.uniq.count!"true");
}
