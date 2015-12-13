import PackageDescription

let package = Package(
    name: "swift-http",
    targets: [
      Target(
        name: "example",
        dependencies: [
          .Target(name: "http")
        ]
      ),
      
      Target(
        name: "http"
      )
    ]
)
