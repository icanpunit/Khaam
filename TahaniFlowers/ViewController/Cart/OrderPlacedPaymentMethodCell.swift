//
//  OrderPlacedPaymentMethodCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 01/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit

class OrderPlacedPaymentMethodCell: UITableViewCell {

    @IBOutlet weak var lblPaymentMethodTitle: UILabel!
    @IBOutlet weak var lblPaymentCOD: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
