#!/usr/bin/env rdmd
import std.stdio;
import std.range;
import std.algorithm;
import std.file;

struct Example {
    string input;
    string output;
}

string between(string pre, string post)(string s) {
    import std.string;
    return s.split(pre)[1].split(post)[0];
}

alias extractUrl = between!("a href", "'>");

struct Problem {
    import std.conv;
    import std.net.curl;
    import std.format : format;

    Example[][string] example;
    string[string] url;

    enum rootUrl = "https://beta.atcoder.jp";
    enum templateString = q{
import std.stdio, std.algorithm, std.range, std.format, std.numeric, std.string, std.conv, std.array;

auto readLine(T=int)() {
    return readln().split.map!(to!T).array;
}

auto readLines(T=int)() {
    size_t n;
    readf("%d\n", &n);
    auto ret = new string[n];
    foreach (i; 0 .. n) {
        ret[i] = readln().to!T;
    }
    return ret;
}

void main() {
    int a, b;
    readf("%d %d\n", &a, &b);
}
};

    void registerUrl(string s) {
        const key = s.between!("'>", "</a>");
        if (key.length == 1) {
            this.url[key] = rootUrl ~ s.between!("'", "'");
        }
    }

    auto parseExamples(string url) {
        import std.string : strip;
        string s = get(url).to!string.between!(`<div class="io-style">`, "</span>");
        s = s.find("入力例");
        string[] examples;
        while (s.canFind("入力例")) {
            // s.writeln;
            examples ~= s[0 .. (s[1..$].find("入力例").ptr - s.ptr)];
            s = s.find("</pre>");
            s = s.find("入力例");
        }
        Example[] ret;
        foreach (ex; examples) {
            auto pres =  ex.split("<pre>");
            auto i = pres[1].split("</pre>")[0].strip;
            auto o = pres[2].split("</pre>")[0].strip;
            ret ~= Example(i, o);
        }
        return ret;
    }

    this(string contest) {
        auto taskUrl = contest.format!"https://beta.atcoder.jp/contests/%s/tasks";
        get(taskUrl)
            .split("\n")
            .filter!(s => s.canFind("tasks/") && s.canFind("<a href="))
            .each!((string s) => this.registerUrl(s));

        this.url.writeln;
        foreach (k, v; this.url) {
            this.example[k] = this.parseExamples(v);
        }
    }

    auto generateTests(string key) {
        string ret = format!"/++TEST++\n\n%s\n"(this.url[key]);
        foreach (i, ex; this.example[key]) {
            ret ~= format!"\n>>> Q%d\n"(i);
            ret ~= ex.input;
            ret ~= "\n===\n";
            ret ~= ex.output;
            ret ~= "\n<<<\n";
        }
        ret ~= "\n++TEST++/\n";
        return ret;
    }

    void generateFiles(string dir) {
        foreach (k; this.example.keys) {
            auto f = File(dir ~ "/" ~ k ~ ".d", "w");
            f.write(this.generateTests(k) ~ templateString);
        }
    }
}

int main(string[] args) {
    import std.path;
    if (args.length != 2) {
        stderr.writefln!"invalid arg length: %s.length != 2"(args);
        return 1;
    }

    auto contest = args[1];
    auto dstdir = "atcoder/" ~ contest;

    if (dstdir.exists) {
        stderr.writeln("Error: " ~ dstdir ~ " already exists.");
        return 1;
    }

    mkdirRecurse(dstdir);
    Problem(contest).generateFiles(dstdir);
    return 0;
}
