//
//  EditProfile.swift
//  TahaniFlowers
//
//  Created by Mandip Kanjiya on 24/12/18.
//  Copyright © 2018 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class EditProfile: UIViewController, UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource,HttpWrapperDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var tblEditProfile: UITableView!
    
    // MARK: - Variables
    
    @IBOutlet weak var lblTitle: UILabel!
    var strFirstName = ""
    var strLastName = ""
    var strEmail = ""
    var strContactNo = ""
    var strBio = ""
    var strImgURL = "http://54.93.252.80/tahanifloweradmin/SuperAdmin/Logo/2018101864555.gif"
    var objEditProfile = HttpWrapper()
    var objCustomerDetails  = HttpWrapper()
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    var imageData = NSData ()
    var imagePicker = UIImagePickerController()
    var userImage:UIImage!
    var isImageSelected:Bool = false
    var isVerify:Bool = false
    var cellHeight:CGFloat = 0.0
    // MARK: - Viewcontroller Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentScrren = "EditProfile"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(refreshScreen),
                                               name: NSNotification.Name(rawValue: currentScrren),
                                               object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - IBActions
    
    // MARK: - @objc Actions
    
    @objc func onTapImage(sender:MyEditGesture) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("lbl_Camera".setlocalized(), comment: ""), style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("lbl_GALLERY".setlocalized(), comment: ""), style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: NSLocalizedString("CANCEL".setlocalized(), comment: ""), style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func onClickSave(sender:MyEditGesture) {
        let cell = sender.cell
        
        self.strFirstName = cell.txtUserName.text!
        self.strLastName = cell.txtLastName.text!
        self.strEmail = cell.txtEmail.text!
        self.strContactNo = cell.txtContact.text!
        self.strBio = cell.txtViewAbout.text!
        
        var flag = true
        var fieldCount = 0
        
        if AppHelper.isNull(strFirstName) == true {
            fieldCount = fieldCount + 1
            cell.bottomSpaceFirstName.constant = 30
            cell.lblRequiredFirstName.isHidden = false
            cell.lblRequiredFirstName.text = "required".setlocalized()
            cell.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(strFirstName, 20) == false {
            fieldCount = fieldCount + 1
            cell.bottomSpaceFirstName.constant = 30
            cell.lblRequiredFirstName.isHidden = false
            cell.lblRequiredFirstName.text = "lbl_signup_max_two_zero_characters_allowed".setlocalized()
            cell.viewUserName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.bottomSpaceFirstName.constant = 10
            cell.lblRequiredFirstName.isHidden = true
            cell.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        
//        if AppHelper.isNull(strLastName) == true {
//            fieldCount = fieldCount + 1
//            cell.bottomSpaceLastName.constant = 30
//            cell.lblRequiredLastName.isHidden = false
//            cell.lblRequiredLastName.text = "required".setlocalized()
//            cell.viewLastName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else if AppHelper.maxLength(strLastName, 20) == false {
//            fieldCount = fieldCount + 1
//            cell.bottomSpaceLastName.constant = 30
//            cell.lblRequiredLastName.isHidden = false
//            cell.lblRequiredLastName.text = "signup_max_two_zero_characters_allowed".setlocalized()
//            cell.viewLastName.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
//            flag = false
//        }
//        else {
//            cell.bottomSpaceLastName.constant = 10
//            cell.lblRequiredLastName.isHidden = true
//            cell.viewLastName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
//        }
//
        if AppHelper.isNull(strContactNo) == true {
            fieldCount = fieldCount + 1
            cell.bottomSpaceContact.constant = 30
            cell.lblRequiredContact.isHidden = false
            cell.lblRequiredContact.text = "required".setlocalized()
            cell.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.isValidMobileNumber(strContactNo) == false {
            fieldCount = fieldCount + 1
            cell.bottomSpaceContact.constant = 30
            cell.lblRequiredContact.isHidden = false
            cell.lblRequiredContact.text = "lbl_signup_only_digits_allowed".setlocalized()
            cell.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else if AppHelper.maxLength(strContactNo, 10) == false {
            fieldCount = fieldCount + 1
            cell.bottomSpaceContact.constant = 30
            cell.lblRequiredContact.isHidden = false
            cell.lblRequiredContact.text = "lbl_signup_max_one_zero_characters_allowed".setlocalized()
            cell.viewContact.layer.borderColor = UIColor(hexString: "#FF0000").cgColor
            flag = false
        }
        else {
            cell.bottomSpaceContact.constant = 10
            cell.lblRequiredContact.isHidden = true
            cell.viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
        }
        
        
        if flag == false {
            cellHeight = CGFloat(fieldCount * 20)
            self.tblEditProfile.reloadData()
            self.view.layoutIfNeeded()
        }
        else {
            if net.isReachable == false {
                let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                if isImageSelected == true {
                    var nLanguageId = ""
                    
                    if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                        nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                    }
                    
                    let resizeData1 = UIImageJPEGRepresentation(self.userImage, 0.5)
                    
                    let dictPera:[String:AnyObject] = ["File" : resizeData1 as AnyObject,
                                                       "nUserId" : "1" as AnyObject,
                                                       "FileType" :"Customer" as AnyObject,
                                                       "nLanguageId" : nLanguageId as AnyObject,
                                                       "cToken" : KbasecToken as AnyObject]
                    
                    requestWith(endUrl: kUploadFile, imageData: resizeData1 as! Data, parameters: dictPera, onCompletion: { (true) in
                        self.updateUserData()
                    }) { (true) in
                        
                    }
                }
                else {
                    self.updateUserData()
                }
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeLanguage () {
        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProducList") as! ProducList
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    
    
    // MARK: - Custom Method
    
    @objc func refreshScreen() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
                self.getUserDetails()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getUserDetails() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
            let nCustomerId = UserDefaults.standard.value(forKey: knCustomerId) as! Int
            let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            
            var param:String = ""
            
            param = String(format: "%@?nUserId=%@&nCustomerId=%@&cToken=%@", kUserDetails,"\(nUserId)","\(nCustomerId)",cToken)
            print("Catlog: \(param)")
            AppHelper.showLoadingView()
            self.objCustomerDetails = HttpWrapper.init()
            self.objCustomerDetails.delegate = self
            self.objCustomerDetails.requestWithparamdictParamPostMethodwithHeaderGet(url: param, headers: nil)
        }
    }
    
    func updateUserData() {
        if net.isReachable == false {
            let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            var nCustomerId = 0
            if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                nCustomerId = UserDefaults.standard.object(forKey: knCustomerId) as! Int
            }
            
            var param:String = ""
            
            param = String(format: "%@?cCustomerFirstName=%@&cCustomerLastName=%@&cCustomerContactNo=%@&cCustomerEmailId=%@&nUserId=%@&cGender=%@&cBio=%@&cToken=%@&cCustomerImage=%@&nCustomerId=%@", kUpdateProfile,self.strFirstName,self.strLastName,self.strContactNo,self.strEmail,"1","NA",self.strBio,KbasecToken,self.strImgURL,"\(nCustomerId)")
            
            let updatedUrl = param.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
            
            AppHelper.showLoadingView()
            self.objEditProfile = HttpWrapper.init()
            self.objEditProfile.delegate = self
            self.objEditProfile.requestWithparamdictParamPostMethodwithHeaderGet(url: updatedUrl!, headers: nil)
        }
    }
    
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
        lblTitle.text = "lbl_edit_profile_title".setlocalized()
        lbNavTitle.textColor = UIColor.black
        
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        
        let titleDict: NSDictionary = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedStringKey : Any]
        
        let buttonBack = UIButton.init(type: .custom)
        let currentLanguage = UserDefaults.standard.object(forKey: kLanguageCode) as! String
        if currentLanguage == "en" {
            buttonBack.setImage(UIImage.init(named: "ic_back"), for: UIControlState.normal)
        }
        else{
            buttonBack.setImage(UIImage.init(named: "ic_back_ar"), for: UIControlState.normal)
        }
        buttonBack.addTarget(self, action:#selector(back), for: UIControlEvents.touchUpInside)
        buttonBack.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        let barButtonBack = UIBarButtonItem.init(customView: buttonBack)
        self.navigationItem.leftBarButtonItem = barButtonBack
        
        let buttonLanguage = UIButton.init(type: .custom)
        buttonLanguage.setImage(UIImage.init(named: "ic_language"), for: UIControlState.normal)
        buttonLanguage.addTarget(self, action:#selector(changeLanguage), for: UIControlEvents.touchUpInside)
        buttonLanguage.frame = CGRect.init(x: self.view.frame.size.width-30, y: 0, width: 25, height: 25)
        
        let barButtonLanguage = UIBarButtonItem.init(customView: buttonLanguage)
        self.navigationItem.rightBarButtonItems = []
    }
    
    //MARK: - Open the camera
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose image from camera roll
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //If you dont want to edit the photo then you can set allowsEditing to false
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        AppHelper.showLoadingView()
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "File", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: endUrl, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded",response.result.value)
                    
                    if let dic = response.result.value as? NSArray
                    {
                        
                        
                        if let status = (dic[0] as! NSDictionary).value(forKey: "Success") as? String
                        {
                            if status == "1"
                            {
                                if let imgpath = (dic[0] as! NSDictionary).value(forKey: "FileName") as? String
                                {
                                    self.strImgURL = imgpath
                                }
                            }
                            else
                            {
                                print("Not calling ")
                            }
                            
                        }
                    }
                    
                    
                    AppHelper.hideLoadingView()
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                AppHelper.hideLoadingView()
                onError?(error)
            }
        }
    }
    
    // MARK: - UITableview Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditProfileCell") as! EditProfileCell
        
        if isVerify == false {
            cell.viewUserName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            cell.viewLastName.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            cell.viewEmail.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            cell.viewContact.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            cell.viewAbout.layer.borderColor = UIColor(hexString: "#D7D8D9").cgColor
            
            if UserDefaults.standard.object(forKey: kcEmail) != nil {
                let editProfileEmailID = UserDefaults.standard.object(forKey: kcEmail) as! String
                if AppHelper.isValidEmail(editProfileEmailID) {
                    cell.txtEmail.text = editProfileEmailID
                }
                else {
                    cell.txtEmail.text = "nil"
                }
            }
            else {
                cell.txtEmail.placeholder = "lbl_edit_profile_email_id".setlocalized()
            }
            
            if UserDefaults.standard.object(forKey: kcContactNo) != nil {
                cell.txtContact.text = UserDefaults.standard.object(forKey: kcContactNo) as! String
            }
            else {
                cell.txtContact.placeholder = "lbl_edit_profile_contact".setlocalized()
            }

            
            if UserDefaults.standard.object(forKey: kcFirstName) != nil {
                cell.txtUserName.text = UserDefaults.standard.object(forKey: kcFirstName) as! String
            }
            else {
                cell.txtUserName.placeholder = "lbl_edit_profile_user_name".setlocalized()
            }
            
            if UserDefaults.standard.object(forKey: kcLastName) != nil {
                cell.txtLastName.text = UserDefaults.standard.object(forKey: kcLastName) as! String
            }
            else {
                cell.txtLastName.placeholder = "edit_profile_user_name".setlocalized()
            }
            
            if UserDefaults.standard.object(forKey: kcBio) != nil {
                cell.txtViewAbout.text = UserDefaults.standard.object(forKey: kcBio) as! String
            }
            
            isVerify = true
        }

//        cell.viewUserName.layer.cornerRadius = 20
//        cell.viewUserName.layer.borderWidth = 1
        cell.viewUserName.clipsToBounds = true
        cell.txtUserName.placeholder = "lbl_edit_profile_first_name_placeholder".setlocalized()
        
//        cell.viewLastName.layer.cornerRadius = 20
//        cell.viewLastName.layer.borderWidth = 1
        cell.viewLastName.clipsToBounds = true
        cell.txtLastName.placeholder = "lbl_edit_profile_last_name_placeholder".setlocalized()
        
//        cell.viewEmail.layer.cornerRadius = 20
//        cell.viewEmail.layer.borderWidth = 1
        cell.viewEmail.clipsToBounds = true
        cell.txtEmail.placeholder = "lbl_edit_profile_email_id_placeholder".setlocalized()
        
//        cell.viewContact.layer.cornerRadius = 20
//        cell.viewContact.layer.borderWidth = 1
        cell.viewContact.clipsToBounds = true
        cell.txtContact.placeholder = "lbl_edit_profile_contact_placeholder".setlocalized()
        
        cell.viewAbout.layer.cornerRadius = 20
        cell.viewAbout.layer.borderWidth = 1
        cell.viewAbout.clipsToBounds = true

        cell.btnSave.layer.cornerRadius = btnRadius
        cell.btnSave.clipsToBounds = true
        cell.btnSave.setTitle("lbl_edit_profile_save_placeholder".setlocalized(), for: .normal)
        let saveTap = MyEditGesture(target: self, action: #selector(onClickSave))
        saveTap.numberOfTapsRequired = 1
        saveTap.cell = cell
        cell.btnSave.isUserInteractionEnabled = true
        cell.btnSave.tag = indexPath.row
        cell.btnSave.addGestureRecognizer(saveTap)
        cell.btnSave.backgroundColor = btnBackgroundColor
        cell.btnSave.setTitleColor(btnTitleColor, for: .normal)
        cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.height/2
        cell.imgProfile.clipsToBounds = true
        let profileTap = MyEditGesture(target: self, action: #selector(onTapImage))
        profileTap.numberOfTapsRequired = 1
        cell.imgProfile.isUserInteractionEnabled = true
        cell.imgProfile.tag = indexPath.row
        cell.imgProfile.addGestureRecognizer(profileTap)
        
        if isImageSelected == true {
            cell.imgProfile.image = self.userImage
        }
        else if UserDefaults.standard.object(forKey: kcCustomerImage) != nil {
            self.strImgURL = UserDefaults.standard.object(forKey: kcCustomerImage) as! String
            cell.imgProfile.cacheImage(urlString: self.strImgURL)
        }
        
        cell.lblChangeImage.text = "lbl_edit_profile_change_image".setlocalized()
        
        cell.btnSave.setTitle("lbl_edit_profile_save".setlocalized(), for: .normal)
        cell.btnSave.backgroundColor = btnBackgroundColor
        cell.btnSave.setTitleColor(btnTitleColor, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 540 + cellHeight
    }
    
    // MARK: - TextFiled Delegate
    
    
    
    // MARK: - HttpWrapper Delegate
    
    func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
        if wrapper == objEditProfile {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                print(dicsResponse)
                
                self.getUserDetails()
                
                if let message = dicsResponse.value(forKey: "Message") as? String {
                    UserDefaults.standard.set(message, forKey: kisMessage)
                }
            }
        }
        else if wrapper == objCustomerDetails {
            AppHelper.hideLoadingView()
            if dicsResponse.value(forKey: "Success") as! String == "1" {
                let userDefaults = UserDefaults.standard
                let customerDetails = (dicsResponse.value(forKey: "Result") as! NSArray).object(at: 0) as! NSDictionary
                
                if let cCustomerFirstName  = customerDetails.value(forKey: "cCustomerFirstName") as? String {
                    if let cCustomerLastName  = customerDetails.value(forKey: "cCustomerLastName") as? String {
                        userDefaults.set(cCustomerFirstName, forKey: kcFirstName)
                        userDefaults.set(cCustomerLastName, forKey: kcLastName)
                        userDefaults.set("\(cCustomerFirstName) \(cCustomerLastName)", forKey: kcCustomerName)
                    }
                    else {
                        userDefaults.set("\(cCustomerFirstName)", forKey: kcCustomerName)
                    }
                }
                
                if let cCustomerContactNo  = customerDetails.value(forKey: "cCustomerContactNo") as? String {
                    userDefaults.set(cCustomerContactNo, forKey: kcContactNo)
                }
                
                if let cCustomerEmailId  = customerDetails.value(forKey: "cCustomerEmailId") as? String {
                    userDefaults.set(cCustomerEmailId, forKey: kcEmail)
                    userDefaults.set(cCustomerEmailId, forKey: kcUserName)
                }
                
                if let cCustomerImage = customerDetails.value(forKey: "cCustomerImage") as? String {
                    userDefaults.set(cCustomerImage, forKey: kcCustomerImage)
                }
                
                if let cBio  = customerDetails.value(forKey: "cBio") as? String {
                    userDefaults.set(cBio, forKey: kcBio)
                }
                userDefaults.synchronize()
                self.navigationController?.popViewController(animated: true)
            }
            else {
                AppHelper.hideLoadingView()
                AppHelper.showMessage(view: self.view, message: dicsResponse.value(forKey: "Message") as! String)
            }
        }
    }
    
    func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
class MyEditGesture: UITapGestureRecognizer {
    var cell = EditProfileCell()
}
//MARK: - UIImagePickerControllerDelegate
extension EditProfile:  UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var imgData:Data = Data()
        /*
         Get the image from the info dictionary.
         If no need to edit the photo, use `UIImagePickerControllerOriginalImage`
         instead of `UIImagePickerControllerEditedImage`
         */
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.userImage = editedImage
            self.isImageSelected = true
            self.tblEditProfile.reloadData()
            imgData = UIImageJPEGRepresentation(editedImage, 0.5)!
            let resizeData = UIImageJPEGRepresentation(editedImage, 0.5)
            self.imageData = resizeData! as NSData
            
        }
        
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true) {
            
        }
    }
    
    func uploadImage(){
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
