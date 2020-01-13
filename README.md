<p align="center">
    <img src="Logo.png" width="400" max-width="90%" alt=“SwiftShogi” />
</p>

<p align="center">
    <a href="https://github.com/hedjirog/SwiftShogi/actions">
        <img src="https://github.com/hedjirog/SwiftShogi/workflows/CI/badge.svg" alt="Workflow Status" />
    </a>
    <a href="https://swift.org/download/">
        <img src="https://img.shields.io/badge/swift-5.1-orange.svg" alt="Swift Version" />
    </a>
    <img src="https://img.shields.io/badge/platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS%20%7C%20Linux-333333.svg?style=flat" alt="Platforms" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/swiftpm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <a href="https://twitter.com/hedjirog">
        <img src="https://img.shields.io/badge/twitter-@hedjirog-blue.svg?style=flat" alt="Twitter: @hedjirog" />
    </a>
</p>

## Features

- [x] Game management
- [x] Board representation
- [x] Move generation / validation
- [x] SFEN parsing
- [ ] KIF parsing
- [ ] Pretty printing

## Installation

Add the SwiftShogi package to your target dependencies in `Package.swift`:

```swift
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(
            url: "https://github.com/hedjirog/SwiftShogi",
            from: "0.1.0"
        ),
    ]
)
```

Then run the `swift build` command to build your project.

## License

MIT

## Contact

Jiro Nagashima ([@hedjirog](https://twitter.com/hedjirog))
