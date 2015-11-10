 //
//  ImageManager.swift
//  DemoCloudKitParents
//
//  Created by Roman Rybachenko on 11/9/15.
//  Copyright © 2015 Roman Rybachenko. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    static let sharedInstanse = ImageManager()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let url = urls.first//urls[0]
        return urls[urls.count-1]
    }()
    
    lazy var pathToImagesFolder: NSURL = {
        var path = ImageManager.sharedInstanse.applicationDocumentsDirectory.URLByAppendingPathComponent("Images")
        
        var pathStr: String = path.absoluteString
        
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("\n\n---- \(error)")
            abort()
            
        }
        
        return path
    }()
    
    func saveImage(image: UIImage, imageName: String) -> Bool {
        let imageData: NSData = UIImageJPEGRepresentation(image, 1)!
        let imagePath = ImageManager.sharedInstanse.pathToImagesFolder.URLByAppendingPathComponent(imageName)
        
        if !imageData.writeToURL(imagePath, atomically: false) {
            print("---Error!! WriteToURL image == false")
            abort()
        }
    
        return true
    }
    
    func getImageWithName(imageName: String) -> UIImage? {
        let dirPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let imagePath = dirPath + "/Images/" + imageName
        
        let image = UIImage(contentsOfFile: imagePath)
        
        
        return image
    }
}
