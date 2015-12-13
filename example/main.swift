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

  let msg = "<h1>Hello World</h1>"
//  server.send_http(clientSocket, msg, content_type: "text-plain")//sends plain text
  server.send_http(clientSocket, msg)//defaults to html
  shutdown(clientSocket, Int32(SHUT_RDWR))
  close(clientSocket)
}
