//
//  AddressCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {

    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    // MARK: - IBOutlets
    @IBOutlet weak var viewAddress: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblAddressDetails: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewNoAddressFound: UIView!
    @IBOutlet weak var lblNoAddressFound: UILabel!
    
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
