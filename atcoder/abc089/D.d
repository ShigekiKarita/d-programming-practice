/++TEST++

https://beta.atcoder.jp/contests/abc089/tasks/abc089_d

>>> Q0
3 3 2
1 4 3
2 5 7
8 9 6
1
4 8
===
5
<<<

>>> Q1
4 2 3
3 7
1 4
5 2
6 8
2
2 2
2 2
===
0
0
<<<

>>> Q2
5 5 4
13 25 7 15 17
16 22 20 2 9
14 11 12 1 19
10 6 23 8 18
3 21 5 24 4
3
13 13
2 10
13 13
===
0
5
0
<<<

++TEST++/

import std.stdio, std.algorithm, std.range, std.format, std.numeric, std.string, std.conv, std.array;

auto readLine(T=int)() {
    return readln.split.map!(to!T);
}

void main() {
    int h, w, d;
    readf("%d %d %d\n", &h, &w, &d);
    int[300][300] _a;
    auto sa = _a[0..h][0..w];
    foreach (i; 0 .. h) {
        foreach (j, a; readLine.enumerate) {
            // writeln(j);
            sa[i][j] = a;
        }
    }
    writeln(sa);
    int q;
    readf("%d\n", q);
    int[10000] _l, _r;
    auto sl = _l[0..q];
    auto sr = _r[0..q];
    foreach (i; 0 .. q) {
        readf("%d %d\n", &sl[i], &sr[i]);
    }
}

