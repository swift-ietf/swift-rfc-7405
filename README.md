# swift-rfc-7405

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The case-sensitive string-literal extension to ABNF of RFC 7405.

## Standard Reference

- **RFC**: 7405
- **Title**: Case-Sensitive String Support in ABNF

## Installation

Add the package to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-7405.git", from: "0.1.4")
]
```

Add the product to a target that needs it:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 7405", package: "swift-rfc-7405")
    ]
)
```

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
