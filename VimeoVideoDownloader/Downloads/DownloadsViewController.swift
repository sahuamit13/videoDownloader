//
//  DownloadsViewController.swift
//  VimeoVideoDownloader
//
//  Created by TPCG II on 08/05/17.
//  Copyright © 2017 TPCG II. All rights reserved.
//

import UIKit

protocol DownloadsViewDelegate: class {
    func downloadVideoPlayButtonAction(id: String) -> Void
    func showAlert(title : String ,message: String , actions : [UIAlertAction]) -> Void
}

class DownloadsViewController: UIViewController {
    
    @IBOutlet var DownloadingView: DownloadingTableView!
    
    @IBOutlet var DownlodedView: DownloadedTableView!
    fileprivate var selectedIndex: Int = 0
    var downloadedFilesArray: [String] = []
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var downloadedArray:NSMutableArray!
    
    
    lazy var segmentedPager : MXSegmentedPager = {
        
        let pager = MXSegmentedPager.init()
        pager.delegate = self
        pager.dataSource = self
        return pager
    }();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        debugPrint(MZUtility.baseFilePath)
        
        
        DownlodedView.downloadedViewDelegate = self
        self.view.addSubview(self.segmentedPager)
        self.segmentedPagerViewUpdates()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DownlodedView.updatedDownloadedTable()
        DownloadingView.updatedDownloadingTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DownlodedView.updatedDownloadedTable()
        DownloadingView.updatedDownloadingTable()
    }
    
    
    override func viewDidLayoutSubviews() {
        
        let height = (self.navigationController?.navigationBar.frame.size.height)! + 15
        self.segmentedPager.frame = CGRect.init(origin: CGPoint.init(x: 0, y: height), size: CGSize.init(width: self.view.frame.width, height: self.view.frame.height - height))
        
        
        super.viewWillLayoutSubviews()
    }
    
    
    func initiateDownloading(fileName: String, fileURL: String, destinationPath: String) -> Void {
        
        getDownloadedArray()
       
        self.DownloadingView.downloadManager.addDownloadTask(fileName, fileURL: fileURL, destinationPath: destinationPath)
        //DownloadingView.updatedDownloadingTable()
    }
    
    func getDownloadedArray(){
        
        
        let plistPath = appDelegate.downloadedPlistPath
        // Extract the content of the file as NSData
        let data:Data =  FileManager.default.contents(atPath: plistPath)!
        do{
            downloadedArray = try PropertyListSerialization.propertyList(from: data, options: PropertyListSerialization.MutabilityOptions.mutableContainersAndLeaves, format: nil) as! NSMutableArray
        }catch{
            print("Error occured while reading from the plist file")
        }
        
    }
    
    
    
}

extension DownloadsViewController : MXSegmentedPagerDataSource {
    
    //MARK:MXSegmentedPagerDataSource
    func numberOfPages(in segmentedPager: MXSegmentedPager) -> Int {
        return 2
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, viewForPageAt index: Int) -> UIView {
        
        return [DownloadingView , DownlodedView][index]
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Downloading","Downloaded"][index]
    }
}

extension DownloadsViewController : MXSegmentedPagerDelegate {
    
    //MARK:MXSegmentedPagerDelegate
    func segmentedPagerViewUpdates() {
        
        
        self.segmentedPager.segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        self.segmentedPager.segmentedControl.backgroundColor = UIColor.white
        self.segmentedPager.segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black,
                                                                    NSFontAttributeName : UIFont.systemFont(ofSize: 13)]
        self.segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.init(hexString: "#6068b0ff")!,
                                                                            NSFontAttributeName : UIFont.systemFont(ofSize: 13)]
        self.segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        self.segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.init(hexString: "#6068b0ff")
        self.segmentedPager.segmentedControl.borderWidth = 1.0
        self.segmentedPager.segmentedControl.selectionIndicatorHeight = 2.0
        
        self.segmentedPager.segmentedControl.isVerticalDividerEnabled = false
        
    }
    
    func segmentedPager(_ segmentedPager: MXSegmentedPager, didSelectViewWith index: Int) {
        
        if index == 1 {
            DownlodedView.updatedDownloadedTable()
        }
        
    }
    
}

extension DownloadsViewController: DownloadsViewDelegate{
    func downloadVideoPlayButtonAction(id: String) {
        print(id)
    }
    
    func showAlert(title : String ,message: String , actions : [UIAlertAction]){
        // create the alert
        let alert = UIAlertController(title: title, message: message , preferredStyle: UIAlertControllerStyle.alert)
        
        
        for action in actions {
            
            alert.addAction(action)
        }
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
