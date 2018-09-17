/++TEST++
>>> Q1
1234
150
100
===
84
<<<

>>> Q2
1000
108
108
===
28
<<<

>>> Q3
579
123
456
===
0
<<<

>>> Q4
7477
549
593
===
405
<<<
++TEST++/

import std.stdio;
import std.algorithm;
import std.array;
import std.conv;

void main() {
    int x, a, b;
    readf("%d\n%d\n%d\n", &x, &a, &b);
    writeln((x - a) % b);
}
