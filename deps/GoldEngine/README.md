# GOLD Parser 5.0 for Free Pascal and Lazarus

## Description
[GOLD Parser](http://goldparser.org/) is a multi-language parsing system.
A developer can write a grammar in GOLD Meta Language (a mixture of BNF, Regular Expressions and set notations).
That grammar is parsed in the language-independent (although Windows-only) Builder, which makes a binary file containing a definition of the grammar.
Then the grammar is sent to a language-dependent Engine which accepts a source file and generates a parse tree which gets processed by the final program the developer writes.

Ever since its creation in 2001, developers have implemented the engine in Delphi, which was very popular at that time.
It is also available for C, C++, C#, Java, D, Python, Turbo Pascal, Visual Basic 6 and even Assembly.

In 2011, version 5 of GOLD Parser was released, bringing a new family of engines with it.
These engines feature an improved parsing algorithm, a new grammar file format and some extra features like lexical groups in grammars.
However, that new engine was available only for .NET and Java, forcing developers of other languages to either continue using the legacy engine, or migrate their projects to another language.
So, I decided to port the Java engine source code to Free Pascal, a cross-platform free and open source Object Pascal compiler.
That new engine can take advantage of all the new features of the version 5.0 of the GOLD Parser.

## How to use

You have to create a descendant of the `TAbstractGOLDParser` class and call the `Parse` method until it returns `prACCEPT`.
Take a look at [the example program](https://gitlab.com/teo-tsirpanis/gold-parser-lazarus/-/tree/master/example) for more information.
The engine can read both legacy Compiled Grammar Tables (CGT) and the newer GOLD Parser 5.0 Enhanced Grammar Tables (EGT) files.

> __Note:__ There used to be a legacy GOLD Parser 1.0-only engine in this repository that was almost a straight copy-paste of a Delphi one. This engine is no longer supported. You can still access it by [browsing the repository at an earlier time](https://gitlab.com/teo-tsirpanis/gold-parser-lazarus/-/tree/431d14811db615cab923ea34cd692bcefba83a0d/).

## Project status

The engine is in maintenance mode. No new features will be added; only bug fixes.
There will be however some occasional minor breaking changes that remedy [obvious API bad designs](https://gitlab.com/teo-tsirpanis/gold-parser-lazarus/-/commit/79b07bbdc17a6489f3ea32329fdf9e3f3b6b05b3).

Those interested can take a look at [Farkle](https://teo-tsirpanis.github.io/Farkle/), an actively developed parser library for .NET that started as a GOLD Parser engine and evolved into something bigger, autonomous and very different.

## License

The engine is a port of [Ralph Iden's Engine implementation for Java](https://github.com/ridencww/goldengine) and is licensed under the 3-Clause BSD license.

In the past it was licensed under other permissive free software licenses but these were either obscure or incompatible with the 3-Clause BSD, which is used because this project is a derivative of the Java engine.

## 3rd party libraries used

The engine uses the [GContnrs generic container library](http://yann.merignac.free.fr/unit-gcontnrs.html). Because of that dependency, it's not Delphi-compatible.
