#!/usr/bin/env rdmd
import std.stdio;
import std.file : dirEntries, SpanMode, tempDir, readText, exists;
import std.path : dirName, baseName, stripExtension, buildPath;
import std.algorithm : each, filter, startsWith;
import std.string : replace, split, strip;
import std.conv : to;

enum usage = `USAGE: rdmd judge.d ./foo/bar.d

NOTE: you must have question & answer txt like

./foo/bar.q1 ./foo/bar.a1
./foo/bar.q2 ./foo/bar.a2
...
`;

bool allPass = true;

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

    immutable codePath = args[1];
    immutable problem = codePath.replace(".d", "");
    immutable bname = problem.baseName.stripExtension;
    immutable dname = problem.dirName;
    void check(in string qfile, string afile="") {
        import std.process : spawnProcess, wait;
        import std.datetime.stopwatch;
        immutable qbase = qfile.baseName;
        immutable abase = qbase.replace(".q", ".a");
        if (afile == "") {
            afile = dname.buildPath(abase);
        }
        writefln("- judging %s vs %s", qfile, afile);
        /*
          see: https://beta.atcoder.jp/contests/practice/rule
          D (DMD64 v2.070.1)	dmd -m64 -w -O -release -inline ./Main.d
          D (LDC 0.17.0)	ldc2 -O ./Main.d -of ./a.out
         */
        auto cmd = ["rdmd", "-g", "-m64", "-w", "-profile=gc", codePath];
        auto sout = File(tempDir.buildPath(qbase ~ ".out"), "w");
        auto serr = File(tempDir.buildPath(qbase ~ ".err"), "w");
        auto swatch = StopWatch(AutoStart.yes);
        immutable result = wait(spawnProcess(cmd, File(qfile), sout, serr));
        immutable time = swatch.peek();
        immutable answer = sout.name.readText;
        immutable expected = afile.readText;
        immutable passed = answer == expected;
        immutable color = passed ? 2 : 1; // green or red
        writefln!"- \x1b[1m\x1b[3%smresult: %s\x1b[m"(color, passed ? "AC" : "WA");
        if (!passed) {
            allPass = false;
            write("> answer:\n", answer);
            write("> expected:\n", expected);
        }
        writefln("- time: %s", time);
        enum gclog = "profilegc.log";
        if (gclog.exists) {
            writefln("- memory: %d bytes", gclog.readGcBytes);
        }
        writeln(serr.name.readText);
        assert(result == 0, ">>> ERROR\n" ~ serr.name.readText);
        writeln("---------------------");
    }

    writefln("====== running %s ======", bname);
    dname.dirEntries(SpanMode.shallow)
        .filter!(f => f.baseName.startsWith(bname ~ ".q"))
        .each!check;


    void checkTest(string testPath) {
        if (!testPath.exists) return;
        writeln("testing: ", testPath);
        File qfile, afile;
        bool isQ = true;
        bool isReading = false;
        foreach (line; File(testPath).byLine) {
            if (line.startsWith(">>>")) {
                auto ls = line.split();
                auto name = ls.length == 1 ? "temp" : ls[1];
                qfile = File(tempDir.buildPath(name ~ ".q"), "w");
                afile = File(tempDir.buildPath(name ~ ".a"), "w");
                isQ = true;
                isReading = true;
            } else if (line.startsWith("===")) {
                isQ = false;
            } else if (line.startsWith("<<<")) {
                afile.close();
                qfile.close();
                isReading = false;
                check(qfile.name, afile.name);
                // TODO remove?
            } else if (isReading) {
                // NOTE need strip?
                if (isQ) qfile.writeln(line.strip);
                else afile.writeln(line.strip);
            }
        }
    }

    File testFile;
    foreach (line; File(codePath).byLine) {
        if (line.startsWith("/++TEST++")) {
            testFile = File(tempDir.buildPath(bname ~ ".test"), "w");
        } else if (testFile.isOpen) {
            if (line.startsWith("++TEST++/")) {
                testFile.close();
            } else {
                testFile.writeln(line.strip);
            }
        }
    }
    checkTest(testFile.name);

    immutable tpath = dname.buildPath(bname ~ ".test");
    checkTest(tpath);

    return allPass ? 0 : 1;
}
