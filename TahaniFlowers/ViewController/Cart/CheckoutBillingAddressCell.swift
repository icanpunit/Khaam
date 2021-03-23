//
//  CheckoutBillingAddressCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class CheckoutBillingAddressCell: UITableViewCell {

    // MARK: - IBOUtlets
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var viewAddresses: UIView!
    @IBOutlet weak var btnAddressRadio: UIButton!
    @IBOutlet weak var lblAddressTitle: UILabel!
    @IBOutlet weak var lblAddressDetails: UILabel!
    @IBOutlet weak var lblType: UILabel!
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
