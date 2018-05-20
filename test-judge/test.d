import std.stdio;

void main() {
    int a, b, c;
    string s;
    readf("%d\n%d %d\n%s\n", &a, &b, &c, &s);
    auto x = new int[30];
    writef("%d %s\n", a + b + c, s);
}
