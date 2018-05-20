import std.stdio;

void main() {
    int a, b, c;
    string s;
    readf("%d\n%d %d\n%s\n", &a, &b, &c, &s);
    writef("%d %s\n", a + b + c, s);
}
