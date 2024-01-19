# generic types
type
    Box[T] = ref object
        value: T
    Container[T] = ref object
        values: seq[T]

let
    b1 = Box[int](value: 1)
    b2 = Box[string](value: "hello")
    c1 = Container[int](values: @[1,2,3])
    c2 = Container[float](values: @[1.1,2.2,3.3])

# generic procs
proc unpack[T](b: Box[T]): T = b.value
proc log[T](value: T) = echo typeof(value), ": ", repr(value)

b1.unpack.log
b1.log # b1 and c1 only work because we use "repr" to get
c1.log # a string representation from anything in log

# Concepts (experimental feature)
# Concepts a.k.a user-defined type classes define
# requirements to a type
type
    Comparable = concept a # a is a "type identifier"
        # what are the "requirements" for Comparables?
        a < a is bool
    
proc myMax(a, b: Comparable): Comparable =
    if (a < b): return b
    else: return a

echo myMax(15, 2)
echo myMax(2, 15)
# type mismatche:
# echo myMax(2, 1.5)
# echo myMax(@[1,2], @[2,3]) # there is no < for seq[int]

# Generics are invariant
# There are more experimental features (in/out) for variance