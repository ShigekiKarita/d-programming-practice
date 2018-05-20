// https://beta.atcoder.jp/contests/abc086/tasks/abc086_a
import std.stdio;

void main() {
    int a, b;
    readf("%d %d", &a, &b);
    writeln(a * b % 2 == 0 ? "Even" : "Odd");
}
