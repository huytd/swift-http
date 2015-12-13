#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public class HTTP {
  public var   serverSocket : Int32 = 0
  public var  serverAddress : sockaddr_in?
  var     bufferSize : Int = 1024

  func sockaddr_cast(p: UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<sockaddr> {
    return UnsafeMutablePointer<sockaddr>(p)
  }

  public func send_http(socket: Int32, _ output: String, content_type: String = "text/html; charset=UTF-8", status_code: String = "200 OK") {
    let contentLength = output.utf8.count

    send_http_header(socket, code: status_code, content_length: "\(contentLength)", type: content_type)
    echo(socket, output)

    print("Response sent: '\(output)' - Length: \(contentLength)")

  }

  public func send_http_header(socket: Int32, code: String = "200 OK", server_name: String = "Swift Web Server", content_length: String, type: String = "text-plain") {
    echo(socket, "HTTP/1.1 \(code)\n")
    echo(socket, "Server: \(server_name)\n")
    echo(socket, "Content-length: \(content_length)\n")
    echo(socket, "Content-type: \(type)\n")
    echo(socket, "Connection: close\n")
    echo(socket, "\r\n")
  } 

  public func echo(socket: Int32, _ output: String) {
   output.withCString { (bytes) in
      #if os(Linux)
      let flags = Int32(MSG_NOSIGNAL)
      #else
      let flags = Int32(0)
      #endif
      send(socket, bytes, Int(strlen(bytes)), flags)
   }
  }

  public init(port: UInt16) {
    #if os(Linux)
    serverSocket = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
    #else
    serverSocket = socket(AF_INET, Int32(SOCK_STREAM), 0)
    #endif
    if (serverSocket > 0) {
      print("Socket init: OK")
    }

    #if os(Linux)
    serverAddress = sockaddr_in(
      sin_family: sa_family_t(AF_INET),
      sin_port: port.htons(),
      sin_addr: in_addr(s_addr: in_addr_t(0)),
      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
    )
    #else
    serverAddress = sockaddr_in(
      sin_len: __uint8_t(sizeof(sockaddr_in)),
      sin_family: sa_family_t(AF_INET),
      sin_port: port.htons(),
      sin_addr: in_addr(s_addr: in_addr_t(0)),
      sin_zero: (0, 0, 0, 0, 0, 0, 0, 0)
    )
    #endif

    setsockopt(serverSocket, SOL_SOCKET, SO_RCVBUF, &bufferSize, socklen_t(sizeof(Int)))

    #if !os(Linux)
    var noSigPipe : Int32 = 1
    setsockopt(serverSocket, SOL_SOCKET, SO_NOSIGPIPE, &noSigPipe, socklen_t(sizeofValue(noSigPipe)))
    #endif

    let serverBind = bind(serverSocket, sockaddr_cast(&serverAddress), socklen_t(UInt8(sizeof(sockaddr_in))))
    if (serverBind >= 0) {
      print("Server started at port \(port)")
    }
  }
}

extension CUnsignedShort {
  func htons() -> CUnsignedShort { return (self << 8) + (self >> 8); }
}
