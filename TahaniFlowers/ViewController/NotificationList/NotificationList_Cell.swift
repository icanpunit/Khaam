//
//  NotificationList_Cell.swift
//  HeyFlyer
//
//  Created by baps on 30/08/1940 Saka.
//  Copyright © 1940 nikunj. All rights reserved.
//

import UIKit

class NotificationList_Cell: UITableViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        imgUser.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        imgUser.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        imgUser.layer.shadowOpacity = 1.0
//        imgUser.layer.shadowRadius = 2.0
//        imgUser.layer.masksToBounds = false
//        imgUser.layer.cornerRadius = 25
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
