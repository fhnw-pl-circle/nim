import std/[macros]

# macros add genereted Nim code to the execution
macro calc(): int =
    # AST of 5 * (5 + 10)
    let node = newStmtList(
        infix(
            newIntLitNode(5),
            "*",
            newPar(
                infix(
                    newIntLitNode(5),
                    "+",
                    newIntLitNode(10)
                )
            )
        )
    )
    echo repr(node)
    return node

echo calc()
# dumpTree: 5*(5+10)