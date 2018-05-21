/++TEST++
>>> Q1
2
2
2
100
===
2
<<<

>>> Q2
5
1
0
150
===
0
<<<

>>> Q3
30
40
50
6000
===
213
<<<

++TEST++/

import std.stdio;

void main() {
    int a, b, c, x;
    readf("%d\n%d\n%d\n%d\n", &a, &b, &c, &x);
    int ans = 0;
    foreach  (i; 0 .. a+1) {
        foreach (j; 0 .. b+1) {
            foreach (k; 0 .. c+1) {
                if (x - (500 * i + 100 * j + 50 * k) == 0) {
                    ++ans;
                }
            }
        }
    }
    writeln(ans);
}
