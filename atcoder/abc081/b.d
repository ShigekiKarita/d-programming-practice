/++TEST++
>>> Q1
3
8 12 40
===
2
<<<

>>> Q2
4
5 6 8 10
===
8
<<<

>>> Q3
6
382253568 723152896 37802240 379425024 404894720 471526144
===
8
<<<
++TEST++/

// TODO
/// TEST https://beta.atcoder.jp/contests/abc081/tasks/abc081_b
import std.stdio;
import std.string;
import std.conv;
import std.algorithm;
import std.array;

int count2(int x) {
    int ret = 0;
    while (x % 2 == 0) {
        ++ret;
        x /= 2;
    }
    return ret;
}

void main() {
    size_t n;
    string s;
    readf("%d\n%s\n", &n, &s);
    auto c = s.split().map!(a => a.to!int.count2).reduce!min;
    writeln(c);
}
