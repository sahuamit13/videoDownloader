//
//  DownloadingTableView.swift
//  VimeoVideoDownloader
//
//  Created by TPCG II on 08/05/17.
//  Copyright © 2017 TPCG II. All rights reserved.
//

import UIKit

class DownloadingTableView: UITableView {
    
    var selectedIndexPath : IndexPath!
    
    var downloadingArray: NSMutableArray!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    lazy var downloadManager: MZDownloadManager = {
        [unowned self] in
        let sessionIdentifer: String = "com.iosDevelopment.MZDownloadManager.BackgroundSession"
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = MZDownloadManager(session: sessionIdentifer, delegate: self as MZDownloadManagerDelegate, completion: completion)
        return downloadmanager
        }()
    
    override func awakeFromNib() {
        super.delegate = self
        super.dataSource = self
        
        let aString: NSString = "temp" as NSString
        aString.appendingPathComponent("")
        
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
    
    func updatedDownloadingTable()  {
        
        
        // Extract the content of the file as NSData
        let data:Data =  FileManager.default.contents(atPath: appDelegate.downloadingPlistPath)!
        do{
            downloadingArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("Error occured while reading from the plist file")
        }
        
        //self.reloadData()
        
        
    }
    
    func refreshCellForIndex(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = self.cellForRow(at: indexPath)
        if let cell = cell {
            let downloadCell = cell as! MZDownloadingCell
            downloadCell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        }
    }
    
    
}

extension DownloadingTableView: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(downloadManager.downloadingArray)
        return downloadManager.downloadingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier : NSString = "MZDownloadingCell"
        let cell : MZDownloadingCell = self.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! MZDownloadingCell
        
        let downloadModel = downloadManager.downloadingArray[indexPath.row]
        
        let array = downloadingArray.object(at: indexPath.row)
        let dict = Helper.convertToDictionary(text: array as! String)
        
        cell.lblTitle?.text = dict!["Title"] as? String
        
        
        cell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        
        return cell
        
    }
    
}

extension DownloadingTableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        
        let downloadModel = downloadManager.downloadingArray[indexPath.row]
        self.showAppropriateActionController(downloadModel.status)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DownloadingTableView {
    
    func showAppropriateActionController(_ requestStatus: String) {
        
        //        if requestStatus == TaskStatus.downloading.description() {
        //            self.showAlertControllerForPause()
        //        } else if requestStatus == TaskStatus.failed.description() {
        //            self.showAlertControllerForRetry()
        //        } else if requestStatus == TaskStatus.paused.description() {
        //            self.showAlertControllerForStart()
        //        }
    }
    
    /*func showAlertControllerForPause() {
     
     let pauseAction = UIAlertAction(title: "Pause", style: .default) { (alertAction: UIAlertAction) in
     self.downloadManager.pauseDownloadTaskAtIndex(self.selectedIndexPath.row)
     }
     
     let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
     self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
     }
     
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     
     let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
     alertController.view.tag = alertControllerViewTag
     alertController.addAction(pauseAction)
     alertController.addAction(removeAction)
     alertController.addAction(cancelAction)
     self.present(alertController, animated: true, completion: nil)
     }
     
     func showAlertControllerForRetry() {
     
     let retryAction = UIAlertAction(title: "Retry", style: .default) { (alertAction: UIAlertAction) in
     self.downloadManager.retryDownloadTaskAtIndex(self.selectedIndexPath.row)
     }
     
     let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
     self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
     }
     
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     
     let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
     alertController.view.tag = alertControllerViewTag
     alertController.addAction(retryAction)
     alertController.addAction(removeAction)
     alertController.addAction(cancelAction)
     self.present(alertController, animated: true, completion: nil)
     }
     
     func showAlertControllerForStart() {
     
     let startAction = UIAlertAction(title: "Start", style: .default) { (alertAction: UIAlertAction) in
     self.downloadManager.resumeDownloadTaskAtIndex(self.selectedIndexPath.row)
     }
     
     let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
     self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
     }
     
     let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
     
     let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
     alertController.view.tag = alertControllerViewTag
     alertController.addAction(startAction)
     alertController.addAction(removeAction)
     alertController.addAction(cancelAction)
     self.present(alertController, animated: true, completion: nil)
     }*/
    
    func safelyDismissAlertController() {
        /***** Dismiss alert controller if and only if it exists and it belongs to MZDownloadManager *****/
        /***** E.g App will eventually crash if download is completed and user tap remove *****/
        /***** As it was already removed from the array *****/
        //        if let controller = self.presentedViewController {
        //            guard controller is UIAlertController && controller.view.tag == alertControllerViewTag else {
        //                return
        //            }
        //            controller.dismiss(animated: true, completion: nil)
        //        }
    }
}

extension DownloadingTableView : MZDownloadManagerDelegate{
    
    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        self.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
        self.reloadData()
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {
        
        self.safelyDismissAlertController()
        
        let indexPath = IndexPath.init(row: index, section: 0)
        self.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        self.removeDataFormDownloading(indexValue: index)
    }
    
    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {
        
        self.safelyDismissAlertController()
        
        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")
        
        let indexPath = IndexPath.init(row: index, section: 0)
        self.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        //MARK: Update downloaded list
        
        let array = downloadingArray.object(at: indexPath.row)
        let dict = Helper.convertToDictionary(text: array as! String)
        
        
        Helper.InsertDataInPlist(pathForThePlistFile: appDelegate.downloadedPlistPath, data: dict as! [String : String])
        //MARK: Removeing data from downloading list
        self.removeDataFormDownloading(indexValue: indexPath.row)
        
        //end
        
        let docDirectoryPath : NSString = (MZUtility.baseFilePath as NSString).appendingPathComponent(downloadModel.fileName) as NSString
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif as String), object: docDirectoryPath)
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
        self.safelyDismissAlertController()
        self.refreshCellForIndex(downloadModel, index: index)
        
        debugPrint("Error while downloading file: \(downloadModel.fileName)  Error: \(error)")
    }
    
    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
        let myDownloadPath = DownloadFilePath.path
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
        let path =  myDownloadPath + "/" + (fileName as String)
        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
        debugPrint("Default folder path: \(myDownloadPath)")
    }
    
    func removeDataFormDownloading(indexValue: Int) {
        
        downloadingArray.removeObject(at: indexValue)
        downloadingArray.write(toFile: appDelegate.downloadingPlistPath, atomically: true)
    }
}
