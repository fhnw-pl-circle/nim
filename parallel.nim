import threadpool
import math
import std/[os, locks, strutils]
{.experimental: "parallel".}

# BASICS
# Threads are os threads (as far as I understand it...)
block basics:
    proc sayHi(): void {.thread.} = # procs started in a new thread "should" have the thread pragma
        echo "hi from ", getThreadId()
        sleep(1000)

    echo "start another thread from ", getThreadId()
    var thread: Thread[void]
    createThread(thread, sayHi) # create and run

    echo "join..."
    joinThread(thread)
    echo "joined..."

    proc sayHi(i: int): void {.thread.} = # max 1 parameter, must not return something
        echo "hi from [", i, "] ", getThreadId()

    echo "start 7 threads from ", getThreadId()
    var threads: array[7, Thread[int]] # int is NOT the return but the parameter type

    for (i, t) in threads.mpairs:
        createThread(t, sayHi, i)

    joinThreads(threads)

# NO SHARED HEAP
# each thread has its own heap and its own GC
block noSharedHeap:
    var data = @["hello", "world"]

    # Thiw will not compile:
    # proc showData(): void {.thread.} = echo data[0]

    # just remove pragma want help either:
    # proc showData(): void = echo data[0]
    # var thread: Thread[void]
    # createThread(thread, showData)

    # communication via channels
    # 1:1 communication (not 1:many)
    var
        channel: Channel[string] # actually there still seams to be a process wide shared heap https://nim-lang.org/docs/system.html#example-passing-channels-safely
        sender: Thread[void]
        receiver: Thread[void]
        receiver2: Thread[void]

    channel.open(10) # max amount of items in channel
    createThread receiver, proc(){.thread.} = 
        var msg = channel.recv()
        echo "received: ", msg
        msg = channel.recv()
        echo "received: ", msg
    
    createThread sender, proc(){.thread.} = 
        sleep(500)
        for w in "hello from other channel".split(' '):
            channel.send(w)

    joinThreads(receiver, receiver2, sender)


# THREADPOOL
block threadpool:
    # same example as above but using a threadpool
    proc sayHi(i: int): void {.thread.} =
        echo "hi from [", i, "] ", getThreadId()

    echo "start 7 threads using a threadpool"
    for i in 0..6:
        spawn sayHi(i) # alt. syntax: spawn(sayHi(i))

    sync()

    # but using spwan we can get return values:
    proc producer(word: string, n: int): seq[string] {.thread.} =
        for i in 0..n:
            result.add(word)
        result

    # FlowVar is like a promise/future/task in other languages
    var firsts: FlowVar[seq[string]] = spawn producer("first", 5)
    var seconds = spawn producer("second", 10)

    echo ^firsts # ^ blocks untill the result is there
    echo ^seconds

    # experimental "parallel" provides a simpler way for
    # parallelzing  e.g. list operations where every item gets
    # processed individually (disjoint check) https://nim-lang.org/docs/manual_experimental.html#parallel-amp-spawn-parallel-statement
    proc longRunningCalculation(num: int): int =
        sleep(3)
        return num + 1

    var values : array[1000, int]

    # from sequential to parallel
    # for i in 0..values.high:
    #     values[i] = longRunningCalculation(values[i])

    parallel: # there are some limitations what can be done inside this block
        for i in 0..values.high:
            values[i] = spawn longRunningCalculation(values[i])
    
    echo sum(values)

# SHARED HEAP
# Since Nim 2 there is some confusion: since the new default memory management strategy
# "ORC" seams to have a shared heap: https://nim-lang.org/docs/mm.html
block sharedHeap:
    # running this file with the old GC "--mm:markAndSweep" will segfault
    # But running it with new orc and arc will work fine
    type 
        RefBox = ref object
            data: int

    var
        r = RefBox()
        s: string = "hello"
        p: ptr string = s.addr()

        t1: Thread[void]
        t2: Thread[void]

    createThread(t1, proc() {.thread.} =
        p[].add(" world")
        # will still not work (not GC safe):
        # r[].data = 100
    )
    joinThread(t1)
    createThread(t2, proc() {.thread.} =
        echo "t2\t", p[]
    )
    joinThread(t2)
    echo "t0\t", s