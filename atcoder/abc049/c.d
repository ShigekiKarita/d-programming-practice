/++TEST++
>>> Q1
erasedream
===
YES
<<<

>>> Q2
dreameraser
===
YES
<<<

>>> Q3
dreamerer
===
NO
<<<
++TEST++/

import std.stdio;
import std.string;
import core.stdc.stdlib;


enum vocab = ["dream", "dreamer", "erase", "eraser"];

void solve(string s) {
    if (s == "") {
        writeln("YES");
        exit(0);
    }

    foreach (v; vocab) {
        if (s.startsWith(v)) {
            solve(s[v.length .. $]);
        }
    }
}

void main() {
    string s;
    readf("%s\n", &s);
    solve(s);
    writeln("NO");
}
