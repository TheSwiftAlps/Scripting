#!/usr/bin/swift -target x86_64-macosx10.12

// Written at SwiftAlps 2016 by Robert-Hein and Roger.

import Foundation

let separator = "%%"
let currentPath = FileManager.default.currentDirectoryPath
let platform = "platform=iOS\(separator)Simulator,OS=10.1,name=iPhone\(separator)7"
let sdk = "iphonesimulator10.1"

func shell(_ command: String) {
    var arguments = command.components(separatedBy: " ")
    arguments = arguments.map { $0.replacingOccurrences(of: separator, with: " ") }
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = arguments
    process.launch()
    process.waitUntilExit()
}

print("Enter project name:")

if let userInput = readLine() {
    shell("xcodebuild -project \(currentPath)/\(userInput)/\(userInput).xcodeproj -scheme \(userInput) -sdk \(sdk) -destination \(platform) clean build test")
}
