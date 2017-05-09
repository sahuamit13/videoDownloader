//
//  PlayerViewController.swift
//  VimeoVideoDownloader
//
//  Created by TPCG II on 08/05/17.
//  Copyright © 2017 TPCG II. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    var availableDownloadsArray: [String] = []
    let myDownloadPath = DownloadFilePath.path
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        debugPrint("custom download path: \(myDownloadPath)")
        
        availableDownloadsArray.append("https://player.vimeo.com/play/442574939?s=146371736_1494354092_a03fea8c8971618b718c05d22e2d9718&loc=external&context=Vimeo%5CController%5CApi%5CResources%5CUser%5CVideoController.&download=1&filename=Untitled113.mp4")
        
        //self.mzDownloadingViewObj = DownloadingTableViewController()
        //self.setUpDownloadingViewController()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func StartDownloadButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "viewDownloads", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewDownloads" {
            updatePlist()
            
            let fileURL  : NSString = availableDownloadsArray[0] as NSString
            var fileName : NSString = fileURL.lastPathComponent as NSString
            fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(fileName as String) as NSString)
            //
            let vc = segue.destination as! DownloadsViewController
            //
            vc.initiateDownloading(fileName: fileName as String, fileURL: fileURL as String, destinationPath: myDownloadPath)
            //vc.downloadManager.addDownloadTask(fileName as String, fileURL: fileURL as String, destinationPath: myDownloadPath)
        }
        
        
        if segue.identifier == "downloaded" {
            //let vc = segue.destination as! MZDownloadedViewController
        }
    }
    
    func updatePlist(){
        
        let fileURL  : NSString = availableDownloadsArray[0] as NSString
        var fileName : NSString = fileURL.lastPathComponent as NSString
        fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(fileName as String) as NSString)
        
        let array: [String : String] = [
            "filepath" : fileName as String,
            "Title" : "episode 2",
            "Genre" : "Action"
            
        ]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let pathForThePlistFile = appDelegate.downloadingPlistPath
        
        Helper.InsertDataInPlist(pathForThePlistFile: pathForThePlistFile, data: array)
        
    }
    
}
