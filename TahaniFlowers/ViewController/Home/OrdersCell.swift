//
//  OrdersCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 18/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class OrdersCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var viewOrders: UIView!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblProductPlacedName: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btnStatus: UIButton!
    @IBOutlet weak var btnOrderAgain: UIButton!
    
    // MARK: - Variables
    
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
       imgArrow.image =  imgArrow.image?.withRenderingMode(.alwaysTemplate).imageFlippedForRightToLeftLayoutDirection()
        imgArrow.tintColor = lblProductName.textColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
