import sequtils
import sugar
import strutils
import std/setutils


# Immutability (let vs var)
# const are compile time constants
var mArr: array[3, int] = [5, 7, 9]
mArr[1] += 1
# mArr = [0,1,2]

let imArr = [5, 7, 9]
 # values are imutable too
 # imArr[1] += 1 <-- will not work

let mat = [
    [0, 0],
    [1, 1],
    [2, 2],
    ]

# inner arrays are imutable too
# mat[1][1] = 3
echo mat[1][1]

var mSeq = @['a', 'b', 'c']
mSeq[0] = 'd'

let imSeq = @['a', 'b', 'c']
# imSeq[0] = 'd'
# imSeq.add('d')


# Flexible syntax for using procs
var h = "hello"
add(h, " ")
add h, "world"
h.add("!")
h.add "\n"

echo h

# allows e.g. "chaining"
proc addd(a, b:int) : int = a + b
echo 1.addd(2).addd(3)


# pass procs as values and syntactic sugar
let numbs = @[1,3,7,2,1,6,7,9,2,33,1,5,88,3,1]
echo numbs.filter do (x: int) -> bool: x mod 2 == 0 # in nim called "do notation"
echo numbs.filter proc(x: int): bool = x mod 2 == 0
echo numbs.filter x => x mod 2 == 0 # syntactitc sugar

# implicit return in procs
proc procResult() : string # forward declaration
echo "procResult: ", procResult()

proc procResult() : string = result # result is initialized with ""

# some compile time calculations :)
const fibonacci = (
    var vals = @[1, 1]
    for i in 1..17: 
        vals = vals & (vals[^1] + vals[^2])
    vals)
echo fibonacci

const fac = (
    var x = 1
    for i in 2 .. 20:
        x *= i
    x
)
echo fac

# iterators
iterator producer(a: int, word: string): string =
    for i in 0 .. a:
        yield word

for w in producer(10, "world"):
    echo "hello ", w

# enums
type
    Direction = enum
        north, east, south, west
    Directions = set[Direction] # set known from math

proc toDirections(ds : varargs[Direction]) : Directions = ds.toSet

let d : Direction = north
echo d

let empty : Directions = {}
let n : Directions = {north}

assert north in { north, south}, "north is not in n"
assert toDirections() < n, "empty >= n"

type
    RGB = enum Red, Green, Blue
    Pixel = array[Red..Blue, 0..255]

var g: Pixel
g[Green] = 255 # 300 would not work