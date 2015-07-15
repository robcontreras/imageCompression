#!/usr/bin/env xcrun swift -O

import Foundation
import AppKit

struct ConvertionFile {
    var image:NSImage?
    var name:String?
}

let filesFolder = Process.arguments[1]

var convertionFiles = [ConvertionFile]()
var totalImages = 0
var convertedImages = 0

let fileManager = NSFileManager.defaultManager()
let fileTypes = NSOrderedSet(objects: "jpg", "jpeg", "png", "bmp")


func compressImageFromFile(file:ConvertionFile!) -> String{
    
    //Create a Bitmap representation from the original image to modify
    let image = file.image!
    var imgRep = image.representations[0] as! NSBitmapImageRep
    
    //create the dir to drop compressed images in (this will be inside the folder where the original images are)
    fileManager.createDirectoryAtPath("\(fileManager.currentDirectoryPath)/\(filesFolder)/Compressed", withIntermediateDirectories: true, attributes: nil, error: nil)
    
    //create data from the modified image representation
    var data: NSData = imgRep.representationUsingType( NSBitmapImageFileType.NSJPEGFileType , properties: [NSImageCompressionFactor:0.3])!
    
    //write data to folder
    data.writeToFile("\(fileManager.currentDirectoryPath)/\(filesFolder)/Compressed/\(file.name!)", atomically: false)
    
    //update the compress images count
    convertedImages += 1
    
    return "done with \(file.name!) - \(convertedImages)/\(totalImages) compressed"
}

//Check if the file extension
func isImageFile(file:String) -> Bool{
    
    let pathExtention = file.pathExtension
    if fileTypes.containsObject(pathExtention){
        return true
    }
    return false
}


let imagesEnumerator = fileManager.enumeratorAtPath("\(filesFolder)/")


while let fileName = imagesEnumerator!.nextObject() as? String{
   	
   	if isImageFile(fileName) == true{
        var file = ConvertionFile()
        file.image = NSImage(contentsOfFile: "\(fileManager.currentDirectoryPath)/\(filesFolder)/\(fileName)")
        file.name = fileName
        convertionFiles.append(file)
        totalImages += 1
    }
}

println("Found a total of \(totalImages) images")
println("Hamsters are running...")

//Iterate through each image file found
for file in convertionFiles{
    let message = compressImageFromFile(file)
    println(message)
}