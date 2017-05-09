//
//  DownloadedCell.swift
//  VimeoVideoDownloader
//
//  Created by TPCG II on 08/05/17.
//  Copyright © 2017 TPCG II. All rights reserved.
//

import UIKit

class DownloadedCell: UITableViewCell {
    
    @IBOutlet weak var videoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
