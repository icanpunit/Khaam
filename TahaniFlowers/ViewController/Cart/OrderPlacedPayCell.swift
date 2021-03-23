//
//  OrderPlacedPayCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 01/01/19.
//  Copyright © 2019 Mandip Kanjiya. All rights reserved.
//

import UIKit

class OrderPlacedPayCell: UITableViewCell {

    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var viewCouponCode: UIView!
    @IBOutlet weak var txtCouponCode: UITextField!
    @IBOutlet weak var btnApply: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtCouponCode.textAlignment = .left
        }
        else {
            self.txtCouponCode.textAlignment = .right
        }
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
