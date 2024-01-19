import std/[os]

type 
    Thing = ref object
        v: int

proc newThing(v: int): Thing =
    var t = Thing(v: v) # implicit allocation
    # same as 
    # var t: Thing = new Thing
    # t.v = v
    return t

proc one() =
    var
        t1 = newThing(1)
        t2 = newThing(2)
    echo t1[].v # [] to dereference
    echo t2.v # field access dereferences implicit

type
    Node {.acyclic.} = ref object
        next: Node
        prev {.cursor.}: Node # this reference will not be counted
        data: int

proc newList(ints: varargs[int]): Node =
    result = Node(data: ints[0])
    var prev = result
    for i in ints[1..ints.high]:
        var next = Node(data: i, prev: prev)
        prev.next = next
        prev = next
    return result

proc two() = 
    var list = newList(1,2,3,4)

    list = newList(1)
    sleep(3)
    echo list.data

one()

for i in 0..20:
    two()
    echo GC_getStatistics()
