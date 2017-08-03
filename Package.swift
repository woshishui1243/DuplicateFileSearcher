// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "DuplicateFileSearcher",
    dependencies: [
        .Package(url: "https://github.com/jatoben/CommandLine.git","3.0.0-pre1"),
        .Package(url: "https://github.com/onevcat/Rainbow.git","2.0.1"),
        .Package(url: "https://github.com/kylef/PathKit.git","0.8.0")
    ]
)
