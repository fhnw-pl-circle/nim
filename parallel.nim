import threadpool
import math
import std/os
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

    parallel: # there are some limitations what can be done inside this block
        for i in 0..values.high:
            values[i] = spawn longRunningCalculation(values[i])
    
    # for i in 0..values.high:
    #     values[i] = longRunningCalculation(values[i])

    echo sum(values)