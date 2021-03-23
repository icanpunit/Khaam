//
//  CheckoutAddNewAddressCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 17/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class CheckoutAddNewAddressCell: UITableViewCell,UITextFieldDelegate {

    // MARK: - IBOutlets
    
    @IBOutlet weak var btnOpen2: UIButton!
    @IBOutlet weak var viewAddNewAddress: UIView!
    @IBOutlet weak var btnAddAddress: UIButton!
    @IBOutlet weak var switchUseBillingAddress: UISwitch!
    @IBOutlet weak var lblUseBillingAddress: UILabel!
    @IBOutlet weak var viewShippingMethod: UIView!
    @IBOutlet weak var lblShippingMethod: UILabel!
    @IBOutlet weak var viewRoundCircle: UIView!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblSavedAddress: UILabel!
    @IBOutlet weak var viewDateTime: UIView!
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var heightDatTimeSelected: NSLayoutConstraint!
    @IBOutlet weak var lblDeliveryOption: UILabel!
    @IBOutlet weak var lblDateTitle: UILabel!
    @IBOutlet weak var lblDateDesc: UILabel!
    @IBOutlet weak var lblBetweenTitle: UILabel!
    @IBOutlet weak var lblBetweenDesc: UILabel!
    @IBOutlet weak var viewUnderLine: UIView!
    
    
    // MARK: - TableviewCell Method
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDateTitle.text = "lbl_DeliveryAddress_SelectedDate_Title".setlocalized()
        lblBetweenTitle.text = "lbl_DeliveryAddress_SelectedBetween_Title".setlocalized()
    }

    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
