import std/[asyncdispatch, httpclient]

proc asyncRequest(): Future[void] {.async.} = 
    var client = newAsyncHttpClient()
    try:
        let future = client.getContent("http://example.com/")
        echo "await response..."
        let res = await future
        echo "response: ", res
    finally:
        client.close()

proc asyncRequest2(): Future[string] {.async.} =
    var client = newAsyncHttpClient()
    defer: 
        echo "I am done here..."
        client.close()

    return await client.getContent("http://example.com/") 
        
waitFor asyncRequest() # no await outside async procs
echo waitFor asyncRequest2()

# Further this article might be intressting: https://peterme.net/asynchronous-programming-in-nim.html