//
//  OrderPlacedAddressCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 01/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit

class OrderPlacedAddressCell: UITableViewCell {

    @IBOutlet weak var lblMobile: UILabel!
       @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblAddressDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
