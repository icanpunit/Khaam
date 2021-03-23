//
//  ProjrctList_Cell.swift
//  ViteHR
//
//  Created by i can infotech on 29/12/17.
//  Copyright © 2017 i can infotech. All rights reserved.
//

import UIKit

class ProjrctList_Cell: UITableViewCell {

    @IBOutlet var lblname: UILabel!
    @IBOutlet var imgRedio:UIImageView!
    
    var DataDic:NSDictionary!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
