#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

public class HTTP {
  var   serverSocket : Int32 = 0
  var  serverAddress : sockaddr_in?
  var     bufferSize : Int = 1024

  func sockaddr_cast(p: UnsafeMutablePointer<Void>) -> UnsafeMutablePointer<sockaddr> {
    return UnsafeMutablePointer<sockaddr>(p)
  }

  func echo(socket: Int32, _ output: String) {
   output.withCString { (bytes) in
       send(socket, bytes, Int(strlen(bytes)), 0)
   }
}

  init(port: UInt16) {
    serverSocket = socket(AF_INET, Int32(SOCK_STREAM.rawValue), 0)
    if (serverSocket > 0) {
      print("Socket init: OK")
    }

    serverAddress = sockaddr_in(
      sin_family: sa_family_t(AF_INET),
      sin_port: htons(port),
      sin_addr: in_addr(s_addr: in_addr_t(0)),
      sin_zero: (UInt8(0),UInt8(0),UInt8(0),UInt8(0),UInt8(0),UInt8(0),UInt8(0),UInt8(0))
    )

    setsockopt(serverSocket, SOL_SOCKET, SO_RCVBUF, &bufferSize, socklen_t(sizeof(Int)))

    let serverBind = bind(serverSocket, sockaddr_cast(&serverAddress), socklen_t(UInt8(sizeof(sockaddr_in))))
    if (serverBind >= 0) {
      print("Server started at port \(port)")
    }
  }

  func start() {
    while (true) {
      if (listen(serverSocket, 10) < 0) {
        exit(1)
      }

      let clientSocket = accept(serverSocket, nil, nil)

      let msg = "Hello World"
      let contentLength = msg.utf8.count

      echo(clientSocket, "HTTP/1.1 200 OK\n")
      echo(clientSocket, "Server: Swift Web Server\n")
      echo(clientSocket, "Content-length: \(contentLength)\n")
      echo(clientSocket, "Content-type: text-plain\n")
      echo(clientSocket, "\r\n")

      echo(clientSocket, msg)

      print("Response sent: '\(msg)' - Length: \(contentLength)")

      close(clientSocket)
    }
  }
}
