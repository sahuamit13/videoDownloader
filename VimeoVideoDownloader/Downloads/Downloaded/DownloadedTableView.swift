//
//  DownloadedTableView.swift
//  VimeoVideoDownloader
//
//  Created by TPCG II on 08/05/17.
//  Copyright © 2017 TPCG II. All rights reserved.
//

import UIKit
import SwiftyJSON

class DownloadedTableView: UITableView {
    
    var downloadedFilesArray : [String] = []
    var selectedIndexPath    : IndexPath?
    var fileManger           : FileManager = FileManager.default
    
    var downloadedArray:NSMutableArray!
    var plistPath:String!
    var PlistData: [JSON] = []
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var downloadedViewDelegate: DownloadsViewDelegate?
    
    override func awakeFromNib() {
        super.delegate = self
        super.dataSource = self
        
        
        do {
            let contentOfDir: [String] = try FileManager.default.contentsOfDirectory(atPath: DownloadFilePath.path as String)
            downloadedFilesArray.append(contentsOf: contentOfDir)
            
            let index = downloadedFilesArray.index(of: ".DS_Store")
            if let index = index {
                downloadedFilesArray.remove(at: index)
            }
            
        } catch let error as NSError {
            print("Error while getting directory content \(error)")
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: NSSelectorFromString("downloadFinishedNotification:"), name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif as String), object: nil)
        
        super.awakeFromNib()
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
    }
    
    func updatedDownloadedTable()  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        plistPath = appDelegate.downloadedPlistPath
        // Extract the content of the file as NSData
        let data:Data =  FileManager.default.contents(atPath: plistPath)!
        do{
            downloadedArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("Error occured while reading from the plist file")
        }
        self.reloadData()
    }
    
    // MARK: - NSNotification Methods -
    
    func downloadFinishedNotification(_ notification : Notification) {
        let fileName : NSString = notification.object as! NSString
        downloadedFilesArray.append(fileName.lastPathComponent)
        self.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.fade)
        
        self.reloadData()
    }
}

extension DownloadedTableView: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.downloadedViewDelegate?.downloadVideoPlayButtonAction(id: "1")
    }
}

extension DownloadedTableView: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return downloadedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier : NSString = "DownloadedFileCell"
        let cell = self.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! DownloadedCell
        
        
        let array = downloadedArray.object(at: indexPath.row)
        let dict = Helper.convertToDictionary(text: array as! String)
        
        cell.titleLabel.text = dict!["Title"] as? String
        let image: UIImage = UIImage(named: "video")!
        cell.videoImage = UIImageView(image: image)
        
        cell.deleteButton.addTarget(self, action: #selector(self.fileDelecteButtonAction(_:)), for: .touchUpInside)
        cell.deleteButton.tag = indexPath.row
        
        //print(dict!["Title"] as! String)
        
        return cell
        
    }
}

extension DownloadedTableView {
    
    func fileDelecteButtonAction(_ sender: UIButton) -> Void {
        
        let index = sender.tag
        
        //print(index)
        //print(self.downloadedFilesArray)
        
        // Both downloadedPlist and file array are differen so need to sync with index value
        let array = downloadedArray.object(at: index)
        let dict = Helper.convertToDictionary(text: array as! String)
        
        
        var indexfile = 0
        for i in 0..<self.downloadedFilesArray.count{
            
            if self.downloadedFilesArray[i] == dict!["filepath"] as? String {
                
                indexfile = i
                print("index: \(i)")
                break
                
            }
            
        }
        
        
        let cancelAction = UIAlertAction.init(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        let okAction = UIAlertAction.init(title: "Delete", style: UIAlertActionStyle.destructive) { (action) in
            
            let fileName : NSString = self.downloadedFilesArray[indexfile] as NSString
            let fileURL  : URL = URL(fileURLWithPath: (DownloadFilePath.path as NSString).appendingPathComponent(fileName as String))
            
            do {
                //MARK: Removeing data from downloaded list
                self.downloadedArray.removeObject(at: index)
                self.downloadedArray.write(toFile: self.appDelegate.downloadedPlistPath, atomically: true)
                //file array with indexfile
                try self.fileManger.removeItem(at: fileURL)
                self.downloadedFilesArray.remove(at: indexfile)
                //self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                self.reloadData()
                
                
            } catch let error as NSError {
                debugPrint("Error while deleting file: \(error)")
            }
            
            
            
        }
        let actions = [cancelAction,okAction]
        self.downloadedViewDelegate?.showAlert(title: "Delete Video?", message: "Are you sure you want Delete the video?", actions: actions)
        //self.showAlert(with: "Delete Video?", message: "Are you sure you want Delete the video?", actions: actions)
        
        
    }
    
    
    
    
    
}
