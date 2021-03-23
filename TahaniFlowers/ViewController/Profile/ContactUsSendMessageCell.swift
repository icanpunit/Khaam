//
//  ContactUsSendMessage swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 24/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class ContactUsSendMessageCell: UITableViewCell ,UITextFieldDelegate{

    @IBOutlet weak var viewMsgHeightConstant: NSLayoutConstraint!
    // MARK: - IBOutlets
    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var imgMessage: UIImageView!
    @IBOutlet weak var txtMessage: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    @IBOutlet weak var bottomSpaceName: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredName: UILabel!
    @IBOutlet weak var bottomSapceEmail: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredEmail: UILabel!
    @IBOutlet weak var bottomSpaceContact: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredContact: UILabel!
    @IBOutlet weak var lblRequiredMessage: UILabel!
    
    // MARK: - Variables
    
    // MARK: - TableviewCell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtEmailAddress.delegate = self
        txtMessage.delegate = self
        txtContact.delegate = self
        txtUserName.delegate = self
        
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtUserName.textAlignment = .left
            self.txtEmailAddress.textAlignment = .left
            self.txtMessage.textAlignment = .left
            self.txtContact.textAlignment = .left
        }
        else {
            self.txtUserName.textAlignment = .right
            self.txtEmailAddress.textAlignment = .right
            self.txtMessage.textAlignment = .right
            self.txtContact.textAlignment = .right
        }
    }

    
    // MARK: - textfield Delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField)  {
        if textField == txtUserName
        {
             lblRequiredName.isHidden = true
             bottomSpaceName.constant = 10
             viewName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == txtContact
        {
             bottomSpaceContact.constant = 10
             lblRequiredContact.isHidden = true
             viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == txtMessage
        {
            lblRequiredMessage.isHidden = true
            viewMessage.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == txtEmailAddress
        {
            
            
            bottomSapceEmail.constant = 10
            lblRequiredEmail.isHidden = true
            viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if textField == self.txtUserName{
            if str.count >= 0 && str.count <= 30 {
                return true
            }
            else {
                return false
            }
        }
        else if textField == self.txtMessage{
            if str.count >= 0 && str.count <= 100 {
                return true
            }
            else {
                return false
            }
        }
        else if textField == self.txtContact{
            if str.count >= 0 && str.count <= 8 {
                return true
            }
            else {
                return false
            }
        }
        else {
            return true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
