// https://beta.atcoder.jp/contests/abc081/tasks/abc081_a
import std.stdio;
import std.algorithm;
import std.conv;

void main() {
    string s;
    readf("%s\n", &s);
    writeln(s.map!(a => a == '1' ? 1 : 0).sum);
}
