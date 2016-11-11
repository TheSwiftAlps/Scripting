#!/usr/bin/swift -target x86_64-macosx10.12 -F /Library/Frameworks -F Rome

import Cocoa
import Foundation
import CoreGraphics

var arguments = CommandLine.arguments
arguments.remove(at: 0)
//print(arguments)

let searchTerm = arguments.joined(separator: "+")

let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=album&limit=24"
let url =  URL(string: urlString)

//print(urlString)
var request = NSURLRequest(url: url!)

let task = URLSession.shared.dataTask(with: url!) { data, response, error in
	guard error == nil else {
		print(error as! String)
		return
	}
	guard let data = data else {
		print("Data is empty")
		return
	}
	
	if let json = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary  {
		if let results = json["results"] as? NSArray {
			let currentPath = FileManager.default.currentDirectoryPath
			
			var images = [String]()
			for album in results {
				if let a = album as? NSDictionary	{
					if let name = a["collectionName"] as? String {
						if let artwork = a["artworkUrl100"] as? String {
							print(artwork)
							let imageURL = URL(string: artwork)
							let imageData = NSData(contentsOf: imageURL!)!
							let filePath = currentPath + "/artwork/\(name).jpg"
							//print(filePath)
							images.append(filePath)
							imageData.write(toFile:filePath , atomically: true)
						}
					}
				}
			}
			let rect = CGRect(x: 0, y: 0, width: 400, height:400)
			let rep = NSBitmapImageRep(
					bitmapDataPlanes: nil,
					pixelsWide: Int(rect.size.width),
					pixelsHigh: Int(rect.size.height),
					bitsPerSample: 8,
					samplesPerPixel: 4,
					hasAlpha: true,
					isPlanar: false,
					colorSpaceName: NSCalibratedRGBColorSpace,
					bytesPerRow: 0,
					bitsPerPixel: 0)
				
			let context = NSGraphicsContext(bitmapImageRep: rep!)
				
			NSGraphicsContext.saveGraphicsState()
			NSGraphicsContext.setCurrent(context)
				
			//
			NSColor.yellow.setFill()
			NSRectFill(rect)
			var index = 0	
			var indextries = 0	

			repeat {
				let filePath = images[indextries % images.count]
				if let imgA = NSImage(byReferencingFile: filePath) {
					if imgA.representations.count != 0 {
						if let bitmap = imgA.representations[0] as? NSBitmapImageRep {
							let rectSub = CGRect(x: (index % 4) * 100, y: Int(index / 4) * 100, width: 100, height:100)

							imgA.draw(in: rectSub, from: CGRect(x: 0, y: 0, width: bitmap.size.width, height:bitmap.size.height), operation: .sourceOver, fraction: 1.0)
						
							index = index + 1
						}
					}
					
				}
				indextries = indextries + 1
				print(indextries)
			} while (index < 16 && indextries < 50)
			
			NSGraphicsContext.restoreGraphicsState()
				
			let image = NSImage(size: rect.size)
			image.addRepresentation(rep!)
			  
			if let bits = image.representations.first as? NSBitmapImageRep {
				let data = bits.representation(using:.JPEG, properties: [:])

				do {
					let documentDirectoryURL = URL(fileURLWithPath:currentPath)
					let fileDestinationUrl = documentDirectoryURL.appendingPathComponent("collage.jpg")
					try data?.write(to: fileDestinationUrl, options: .atomic)
				} catch {
					print(error)
				}
			}

		}
	}
}

task.resume()
RunLoop.main.run()
