#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

var http = HTTP(port: 8080)
http.start()
