//
//  SideMenuProfile_Cell.swift
//  Staycurity
//
//  Created by Mandip Kanjiya on 21/08/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class SideMenuProfile_Cell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageViewX!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
