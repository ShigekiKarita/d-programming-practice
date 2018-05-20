#!rdmd
import std.stdio;
import std.file : dirEntries, SpanMode, tempDir, readText, exists;
import std.path : dirName, baseName, stripExtension, buildPath;
import std.algorithm : each, filter, startsWith;
import std.string : replace, split;
import std.conv : to;

enum usage = `USAGE: rdmd judge.d ./foo/bar.d

NOTE: you must have question & answer txt like

./foo/bar.q1 ./foo/bar.a1
./foo/bar.q2 ./foo/bar.a2
...
`;

size_t readGcBytes(string path) {
    size_t ret = 0;
    foreach (line; File(path).byLine) {
        if (line.startsWith("bytes allocated")) continue;
        ret += line.split()[0].to!size_t;
    }
    return ret;
}

int main(string[] args) {
    if (args.length != 2) {
        writeln(usage);
        return 1;
    }
    if (!args[1].exists) {
        writeln(args[1] ~ ": not found");
        writeln(usage);
        return 1;
    }
    
    immutable codeName = args[1];
    immutable problem = codeName.replace(".d", "");
    immutable bname = problem.baseName.stripExtension;
    immutable dname = problem.dirName;
    void check(in string qfile) {
        import std.process : spawnProcess, wait;
        import std.datetime.stopwatch;
        writefln("- judging %s", qfile);
        immutable qbase = qfile.baseName;
        immutable abase = qbase.replace(".q", ".a");
        immutable afile = dname.buildPath(abase);
        /*
          see: https://beta.atcoder.jp/contests/practice/rule
          D (DMD64 v2.070.1)	dmd -m64 -w -O -release -inline ./Main.d
          D (LDC 0.17.0)	ldc2 -O ./Main.d -of ./a.out
         */
        auto cmd = ["rdmd", "-m64", "-profile=gc", codeName];
        auto sout = File(tempDir.buildPath(qbase ~ ".out"), "w");
        auto serr = File(tempDir.buildPath(qbase ~ ".err"), "w");
        auto swatch = StopWatch(AutoStart.yes);
        immutable result = wait(spawnProcess(cmd, File(qfile), sout, serr));
        immutable time = swatch.peek();
        assert(result == 0, ">>> ERROR\n" ~ serr.name.readText);
        immutable answer = sout.name.readText;
        immutable expected = afile.readText;
        immutable passed = answer == expected;
        writefln("- passed: %s", passed);
        if (!passed) {
            write("> answer:\n", answer);
            write("> expected:\n", expected);
        }
        writefln("- time: %s", time);
        enum gclog = "profilegc.log";
        if (gclog.exists) {
            writefln("- memory: %d bytes", gclog.readGcBytes);
        }
        writeln(serr.name.readText);
        writeln("---------------------");        
    }

    writefln("====== running %s ======", bname);
    dname.dirEntries(SpanMode.shallow)
        .filter!(f => f.baseName.startsWith(bname ~ ".q"))
        .each!check;
    return 0;
}
