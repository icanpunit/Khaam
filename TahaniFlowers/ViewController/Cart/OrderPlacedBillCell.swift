//
//  OrderPlacedBillCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 01/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit

class OrderPlacedBillCell: UITableViewCell {

    @IBOutlet weak var viewDelivery: UIView!
    @IBOutlet weak var viewCredit: UIView!
    @IBOutlet weak var lblCreditPrice: UILabel!
    @IBOutlet weak var lblCreditTitle: UILabel!
    @IBOutlet weak var lblSubtotalTitle: UILabel!
    @IBOutlet weak var lblDiscountTitle: UILabel!
    @IBOutlet weak var lblDeliveryTitle: UILabel!
    @IBOutlet weak var lblSubtotalPrice: UILabel!
    @IBOutlet weak var lblDiscountPrice: UILabel!
    @IBOutlet weak var lblDeliveryPrice: UILabel!
    @IBOutlet weak var lblTotalTitle: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
