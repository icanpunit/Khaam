//
//  EditProfileCell.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 24/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit

class EditProfileCell: UITableViewCell ,UITextFieldDelegate, UITextViewDelegate{

    // MARK: - IBOutlets
    
    @IBOutlet weak var viewEditProfile: UIView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblChangeImage: UILabel!
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var imgUserName: UIImageView!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var viewContact: UIView!
    @IBOutlet weak var imgContact: UIImageView!
    @IBOutlet weak var txtContact: UITextField!
    @IBOutlet weak var viewAbout: UIView!
    @IBOutlet weak var imgAbout: UIImageView!
    @IBOutlet weak var txtViewAbout: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewLastName: UIView!
    @IBOutlet weak var imgLastName: UIImageView!
    @IBOutlet weak var txtLastName: UITextField!
    
    var strSpecialInstruction = "About Us"
    @IBOutlet weak var bottomSpaceFirstName: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredFirstName: UILabel!
    @IBOutlet weak var bottomSpaceLastName: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredLastName: UILabel!
    @IBOutlet weak var bottomSpaceEmailId: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredEmailId: UILabel!
    @IBOutlet weak var bottomSpaceContact: NSLayoutConstraint!
    @IBOutlet weak var lblRequiredContact: UILabel!
    @IBOutlet weak var lblRequiredBio: UILabel!
    // MARK: - Variables
    
    // MARK: - Tableview cell Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        txtUserName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtContact.delegate = self
        txtViewAbout.delegate = self
        txtViewAbout.text = strSpecialInstruction
                     txtViewAbout.textColor = UIColor.lightGray
                     txtViewAbout.delegate = self
        if UserDefaults.standard.object(forKey: kLanguageCode) as! String == "en" {
            self.txtUserName.textAlignment = .left
            self.txtLastName.textAlignment = .left
            self.txtEmail.textAlignment = .left
            self.txtContact.textAlignment = .left
            self.txtViewAbout.textAlignment = .left
        }
        else {
            self.txtUserName.textAlignment = .right
            self.txtLastName.textAlignment = .right
            self.txtEmail.textAlignment = .right
            self.txtContact.textAlignment = .right
            self.txtViewAbout.textAlignment = .right
        }
        
    }

    
    // MARK: - textfield Delegate
    
   func textFieldDidBeginEditing(_ textField: UITextField)  {
        if textField == txtUserName
        {
            bottomSpaceFirstName.constant = 10
            lblRequiredFirstName.isHidden = true
            viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == txtLastName
        {
            bottomSpaceLastName.constant = 10
            lblRequiredLastName.isHidden = true
            viewLastName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        else if textField == txtContact
        {
            bottomSpaceContact.constant = 10
            lblRequiredContact.isHidden = true
            viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
         }
        else if textField == txtEmail
        {
            bottomSpaceEmailId.constant = 10
            lblRequiredEmailId.isHidden = true
            viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
         }
        else if textField == txtViewAbout
        {
            lblRequiredBio.isHidden = true
            viewAbout.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
    
    }
    
    //MARK:- textview Delegate
         func textViewDidBeginEditing(_ textView: UITextView) {
             if textView.textColor == UIColor.lightGray {
                 textView.text = nil
                 textView.textColor = UIColor.black
             }
         }
         
         func textViewDidEndEditing(_ textView: UITextView) {
             if textView.text.isEmpty {
                 textView.text = strSpecialInstruction
                 textView.textColor = UIColor.lightGray
             }
         }
         
         func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
             let str = (textView.text! + text)
             if textView == txtViewAbout  {
                 if str.count >= 0 && str.count <= 200 {
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
    
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        
//        let currentText = textView.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
//        return changedText.count <= 100 // Pass your character count here
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let str = (textField.text! + string)
        if textField == self.txtUserName || textField == self.txtLastName{
            if str.count >= 0 && str.count <= 20 {
                return true
            }
            else {
                return false
            }
        }
        else if textField == self.txtViewAbout {
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
