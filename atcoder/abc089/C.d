/++TEST++

https://beta.atcoder.jp/contests/abc089/tasks/abc089_c

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

import std.stdio, std.algorithm;

void main() {
    enum cs = "MARCH";
    size_t[char] d;
    foreach (c; cs) {
        d[c] = 0;
    }
    foreach (s; stdin.byLine) {
        if (s[0] in d) {
            ++d[s[0]];
        }
    }
    size_t ret = 0;
    foreach (i, c0; cs[0..$-2]) {
        if (d[c0] == 0) continue;
        foreach (j, c1; cs[i+1..$-1]) {
            if (d[c1] == 0) continue;
            foreach (k, c2; cs[i+1+j+1..$]) {
                if (d[c2] == 0) continue;
                ret += d[c0] * d[c1] * d[c2];
            }
        }
    }
    writeln(ret);
}

