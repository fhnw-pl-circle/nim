# [Nim](https://nim-lang.org/)

Nim is a statically typed, compiled, general purpose programming language.

## Run the examples

**Dev container**
When using VS Code one can simply run the dev container. 

*Note:* if you want to run the gui [app](./app) uncomment the content of `feature` in [devcontainer.json](.devcontainer/devcontainer.json) and change the import statement in the [Dockerfile](.devcontainer/Dockerfile) (see comments there).

**Manual installation**
Download and install *choosenim* (a rustup inspired tool for managing Nim and its package manager nimble) from the official [website](https://nim-lang.org/install.html). Then install Nim version 2.0.2 (might cause trouble on windows, if so use 2.0.0, the examples should work as well).

**Run an example**

Run `nim r --outdir=build [EXAMPLE].nim` (`r` = compile and run). E.g. `nim r --outdir=build helloworld.nim`

Tor run a nimble package with a dependency (e.g. ./app directory) run `nimble run -y` (`-y` will accept download of dependency).

## Presentation

Hello world in Nim: `echo "hello world`.

1. Basics
    1. [intro](./01_basics/basics.nim)
    1. [objects and tuples](./01_basics/objects.nim)
    1. [OOP](./01_basics/oop.nim)
1. Concurrency
    1. [Parallel](./02_concurrent/parallel.nim)
    1. [Async](./02_concurrent/async.nim)
1. Meta programming
    1. [Generics](./03_meta/generics.nim)
    1. [Templates](./03_meta/templates.nim)
    1. [Macro](./03_meta/macros.nim) (just a short intro)
1. Some more interesting stuff (just a short overview over more topics)
    1. [Memory](./04_more/memory.nim)
    1. [Effect system](./04_more/effects.nim)

## Resources

* 💻 [Nim Manual](https://nim-lang.org/docs/manual.html)

* 📖 [Nim in Action](https://learning.oreilly.com/library/view/nim-in-action/9781617293436/) (free on O'Reilly with FHNW account)

* 💻 [Nim by Example](https://nim-by-example.github.io/)