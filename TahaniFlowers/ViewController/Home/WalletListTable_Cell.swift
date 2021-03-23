//
//  WalletListTable_Cell.swift
//  TahaniFlowers
//
//  Created by baps on 31/08/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit

class WalletListTable_Cell: UITableViewCell {

    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblOrderNo: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    @IBOutlet weak var viewBack: UIViewX!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
