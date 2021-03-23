//
//  ProfileDetailsCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 19/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ProfileDetailsCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var switchNotificaiton: UISwitch!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    // MARK: - Variables
    
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func onChangeNotification(_ sender: UISwitch) {
        if sender.isOn
        {
            UserDefaults.standard.set("1", forKey: knotificaiton)
           
             UIApplication.shared.registerForRemoteNotifications()
        }
        else
        {
             UIApplication.shared.unregisterForRemoteNotifications()
            UserDefaults.standard.set("0", forKey: knotificaiton)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
