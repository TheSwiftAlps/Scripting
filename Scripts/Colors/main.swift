#!/usr/bin/swift -target x86_64-macosx10.12 -F /Library/Frameworks -F Frameworks

import Foundation
import Stencil
import Darwin

func returnWithError(_ error: String) -> Never {
    fputs("\(error)\n", __stderrp)
    exit(0)
}

let args = CommandLine.arguments
var jsonFileName = "colors.json"
var outputFileName: String?

if args.count > 1 {
    jsonFileName = args[1]
}

if args.count > 2 {
    outputFileName = args[2]
}

// reading file
let currentPath = FileManager.default.currentDirectoryPath
var jsonURL = URL(fileURLWithPath: currentPath)
jsonURL.appendPathComponent(jsonFileName)

// parsing json
let json: [String:String] 
do {
    let data = try Data.init(contentsOf: jsonURL)
    guard let parsedJson = try JSONSerialization.jsonObject(with: data) as? [String:String] else {
        returnWithError("Can't parse to JSON'")
    }
    json = parsedJson
} catch let error {
    returnWithError("reading error \(error)")    
}
 
let context = Context(dictionary: ["colors": json.map { (key, value) in
    ["name": key, "hex": value]
}])

do {
  let template = try Template(path: "colorstemplate.stencil")
  let rendered = try template.render(context)

  if let outputFileName = outputFileName {
    var outputFile = URL(fileURLWithPath: currentPath)
    outputFile.appendPathComponent(outputFileName)
    try rendered.write(to: outputFile, atomically: true, encoding: .utf8)
    print("Success!")
  } else {
    print(rendered)
  }
} catch {
  returnWithError("Failed to render template \(error)")
}