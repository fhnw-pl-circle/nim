import std/strformat

# BASICS

type
    Person* = object # * makrs visibility outside the module
        name*: string
        age*: int8
        # speak: proc(word: string)

let simon = Person(
    name: "Simon",
    age: 25,
    # speak: (w: string) => echo w
)

# OBJECTS VS TUPLES

type
    TA = tuple
        a: string
        b: int
    TB = tuple
        a: string
        b: int
    OA = object
        a: string
        b: int
    OB = object
        a: string
        b: int

var ta : TA
ta = (a: "a", b: 12)
var tb : TB = (a: "a", b: 12)
# var tb : TB = (b: 12, a: "a") <-- type mismatch
echo ta, " ", tb, " ", ta == tb
tb.a = "b"
ta = tb
echo ta

# btw. unpacking tuples is possible:
let (x, _) = ta # one must unpack all "fields"

var oa = OA(a: "a", b: 42)
var ob = OB(a: "a", b: 42)
echo oa, " ", ob, " " 

# type mismatches:
# oa == ob 
# oa = ob
