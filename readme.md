# [Nim](https://nim-lang.org/)

Nim is a statically typed, compiled, general purpose programming language.

## Run the examples

**Dev container**
When using VS Code one can simply run the dev container. 

*Note:* if you want to run the gui [app](./app) uncomment the content of `feature` in [devcontainer.json](.devcontainer/devcontainer.json) and change the import statement in the [Dockerfile](.devcontainer/Dockerfile) (see comments there).

**Manual installation**
Download and install *choosenim* (a rustup inspired tool for managing Nim and its package manager nimble) from the official [website](https://nim-lang.org/install.html). Then install Nim version 2.0.2 (might cause trouble on windows, if so use 2.0.0, the examples should work as well).
