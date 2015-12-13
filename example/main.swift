import Foundation

#if os(Linux)
    import Glibc
#else
    import Darwin.C
#endif

import http

let environment = NSProcessInfo.processInfo().environment
var port = environment["PORT"]
if port == nil || port!.isEmpty {
    port = "8080"
}
let portInt = UInt16(port!)

let server = HTTP(port: portInt!)

while (true) {
  if (listen(server.serverSocket, 10) < 0) {
    exit(1)
  }

  let clientSocket = accept(server.serverSocket, nil, nil)

  let msg = "Hello World"
  let contentLength = msg.utf8.count

  server.echo(clientSocket, "HTTP/1.1 200 OK\n")
  server.echo(clientSocket, "Server: Swift Web Server\n")
  server.echo(clientSocket, "Content-length: \(contentLength)\n")
  server.echo(clientSocket, "Content-type: text-plain\n")
  server.echo(clientSocket, "Connection: close\n")
  server.echo(clientSocket, "\r\n")

  server.echo(clientSocket, msg)

  print("Response sent: '\(msg)' - Length: \(contentLength)")

  shutdown(clientSocket, Int32(SHUT_RDWR))
  close(clientSocket)
}
