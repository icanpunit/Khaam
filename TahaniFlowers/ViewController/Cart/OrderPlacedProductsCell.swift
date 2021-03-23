//
//  OrderPlacedProductsCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 01/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit

class OrderPlacedProductsCell: UITableViewCell {

    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblQtyTitle: UILabel!
    @IBOutlet weak var lblQtyCount: UILabel!
    @IBOutlet weak var lblPriceTitle: UILabel!
    @IBOutlet weak var lblPriceData: UILabel!
    @IBOutlet weak var lblSubTotalTitle: UILabel!
    @IBOutlet weak var lblSubtotalData: UILabel!
    var nCartType = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
