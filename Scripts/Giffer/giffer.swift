#!/usr/bin/swift -target x86_64-macosx10.12 -F /Library/Frameworks -F ./Gif

import Foundation
import GifMaker
import AppKit

if CommandLine.arguments.count == 1 {
    print("usage here")

    exit(1)
}

let inputFolder = CommandLine.arguments[1]
let destinationPath = CommandLine.arguments[2]
let duration = Double(CommandLine.arguments[3]) ?? 0.5

let gm = STGIFMaker(destinationPath: destinationPath, loop: true)!

let images = try! FileManager.default.contentsOfDirectory(atPath: inputFolder).filter { n in n.hasSuffix("jpeg") }

for i in images {
    let image = NSImage(contentsOfFile: inputFolder.appending("/\(i)"))!
    gm.append(image: image, duration: duration)
}

exit(gm.write())
