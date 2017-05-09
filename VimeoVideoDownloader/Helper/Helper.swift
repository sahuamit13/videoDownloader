//
//  Helper.swift
//  VimeoVideoDownloader
//
//  Created by TPCG II on 08/05/17.
//  Copyright © 2017 TPCG II. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import SwiftyJSON

struct DownloadFilePath {
    static let path = MZUtility.baseFilePath + "/video"
}

class Helper {
    
    class func InsertDataInPlist(pathForThePlistFile: String, data: [String: String] ) -> Void{
        
        let parseJSON = JSON(data)
        let videoData = parseJSON.rawString(String.Encoding.utf8)
        // Save note to plist
        
        //        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        let pathForThePlistFile = appDelegate.downloadingPlistPath
        
        // Extract the content of the file as NSData
        let data:Data =  FileManager.default.contents(atPath: pathForThePlistFile)!
        // Convert the NSData to mutable array
        do{
            let notesArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
            notesArray.add(videoData!)
            // Save to plist
            notesArray.write(toFile: pathForThePlistFile, atomically: true)
        }catch{
            print("An error occurred while writing to plist")
        }
        
    }
    
    class func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = hexString.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
