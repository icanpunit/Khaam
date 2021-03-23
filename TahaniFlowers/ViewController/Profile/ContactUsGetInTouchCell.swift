//
//  ContactUsGetInTouchCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 24/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ContactUsGetInTouchCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var viewGetInTouch: UIView!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var lblLoationTitle: UILabel!
    @IBOutlet weak var lblLocationDesc: UILabel!
    @IBOutlet weak var viewEmailAddress: UIView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var lblEmailTitle: UILabel!
    @IBOutlet weak var lblEmailDesc: UILabel!
    @IBOutlet weak var viewContactNumber: UIView!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var lblContactNumber: UILabel!
    @IBOutlet weak var lblContactNumberDesc: UILabel!
    @IBOutlet weak var viewLocationHeight: NSLayoutConstraint!
    @IBOutlet weak var lblForSupportAndInq: UILabel!
    @IBOutlet weak var lblSupportAndInqContact: UILabel!
    @IBOutlet weak var lblForComplains: UILabel!
    @IBOutlet weak var lblForComplainsContact: UILabel!
    @IBOutlet weak var lblForOrderTrackingDelivery: UILabel!
    @IBOutlet weak var lblForOrderTrackingDeliveryContact: UILabel!
    @IBOutlet weak var lblForWhatsapp: UILabel!
    @IBOutlet weak var lblForWhatsappContact: UILabel!
    
    
    // MARK: - Variables
    
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
