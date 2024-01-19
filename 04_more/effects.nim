# exceptions
proc doesRaise() {.raises: [IOError].} =
    raise newException(IOError, "test")

try:
    doesRaise()
except IOError as e:
    echo "surprise, there's an exception: ", e.msg
    
    
# noSideEffect

var x = 20

proc withEffect(): int =
    x += 2
    return x

proc myPlus(a, b: int): int {.noSideEffect.} = 
    # x += 2 # accesses global state
    # echo "hi" # calls `.sideEffect` 'echo'
    # discard withEffect() # sideEffect is "infered"
    a + b

proc myMinus(a, b: int): int {.noSideEffect.} = 
    let y = myPlus(1,2) # myPlus has no side effect
    a - b

# func is sugar for noSideEffect
func myMul(a,b: int):int = a*b

echo myPlus(20, 22)
echo myMinus(10,4)
echo myMul(2,4)

# gcsafe effect
# must not access any global variable that
# contains GC'ed memory (string, seq, ref)
var s = "hello world"
var i = 12

proc gcSafe(): void {.gcsafe.} =
    # echo s
    i += 3
    echo i

gcSafe()