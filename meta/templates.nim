import std/[macros]

template log(label: string, statements: untyped) =
    echo "<<<<<\t", label, "\t>>>>>"
    statements
    echo "<<<<<\tdone\t>>>>>"

log("hello world template"): # ":" works because untyped as last parameter
    let x = 1+2
    echo x

template `==>`(value: typed, varName: untyped) =
    # typed is "something that allready received a type"
    # e.g. a defined variable or a literal value
    # untyped is an undefined identifier
    var varName = value

42 ==> myVar
myVar += 1
myVar ==> anotherVar
echo typeof(anotherVar), " ", anotherVar

# something more usefull: read from a file and automatically close it
# in python we can do semething like that:
# with open('readme.txt') as f:
#   lines = f.readlines()
# or in java:
# try (resource-specification) { // use the resource }

template withFile(path: string, f: untyped, code: untyped) =
    block: # limite scope of f
        var f: File # injected implicite because passed as a param
        if open(f, path): # open does not throw an exception
            try:
                let useless = "I will not be injected"
                let size {.inject.} = f.getFileSize
                code
            finally:
                f.close()
        else: 
            echo "Could not open file ", path

# expandMacros: # print generated nim code

    # run this example in terminal not in vs code
    withFile("../helloworld.nim", file):
        echo "filesize:", size, " byte"
        for line in file.lines():
            echo line

# Somewhere I read a conclusion like "templates are a
# declarative, less powerfull variant of macros"