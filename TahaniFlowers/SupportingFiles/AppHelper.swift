//
//  AppHelper.swift
//  Deputize Americar
//
//  Created by Darshak Trivedi.
//  Copyright © 2017 Scorch Mobile. All rights reserved.
//

import UIKit

class AppHelper: NSObject
{
    struct Platform
    {
        static var isSimulator: Bool
        {
            return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
        }
    }
    
    class func showAlert(_ title:String, message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(defaultAction)
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController
        {
            while let presentedViewController = topController.presentedViewController
            {
                topController = presentedViewController
            }
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    class func isValidEmail(_ testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidMobileNumber(_ testStr:String) -> Bool {
        let mobileRegEx = "[0-9]+"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", mobileRegEx)
        print(mobileTest.evaluate(with: testStr))
        return mobileTest.evaluate(with: testStr)
    }
    
    class func isNull(_ testStr:String) -> Bool {
        let trimmed = testStr.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed == "" {
            return true
        }
        else {
            return false
        }
    }
    
    class func maxLength(_ testStr:String,_ length:Int) -> Bool {
        if testStr.count > length {
            return false
        }
        else {
            return true
        }
    }
    
    class func minLength(_ testStr:String,_ length:Int) -> Bool {
        if testStr.count < length {
            return false
        }
        else {
            return true
        }
    }
    
    class func showLoadingView()
    {
        if appDelegate.isLoadingViewVisible == false
        {

            let window = UIApplication.shared.keyWindow
            let loading = MBProgressHUD.showAdded(to: window, animated: true)
            loading?.mode = MBProgressHUDModeIndeterminate
            appDelegate.isLoadingViewVisible = true
        }
    }
    
    class func hideLoadingView()
    {
        let window = UIApplication.shared.keyWindow
        MBProgressHUD.hide(for: window, animated: true)
        appDelegate.isLoadingViewVisible = false
    }
    
    class func showMessage(view:UIView, message:String) {
        let tost = MBProgressHUD.showAdded(to: view, animated: true)
        tost?.mode = MBProgressHUDModeText
        tost?.labelText = message
        tost?.margin = 10;
        
//        tost?.yOffset = 200;
        let height = view.frame.size.height
        if height < 600 {
            tost?.yOffset = 150
        }
        else if height > 600 {
            tost?.yOffset = 200
        }
         //Float(view.frame.size.height - 150);
        tost?.isUserInteractionEnabled = false
        tost?.hide(true, afterDelay: 3)
    }
    
    class func convertToDictionary(text: String) -> Any? {
        
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? Any
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return nil
        
    }
    
    class func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    class func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    class func stringToDate(strDate:String, strFormate:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormate //Your date format
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        //according to date format your date string
        guard let date = dateFormatter.date(from: strDate) else {
            fatalError()
        }
        return date
    }
    
    class func dateToString(date:Date, strFormate:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en")
        dateFormatter.dateFormat = strFormate //Your New Date format as per requirement change it own
        let newDate = dateFormatter.string(from: date) //pass Date here
        
        return newDate
    }
    
    class func getDayOfWeek(today:String)->Int? {
        
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            return weekDay
        } else {
            return nil
        }
    }
    
    class func isEven(number:Int) -> Bool {
        if number % 2 == 0 {
            return true
        } else {
            return false
        }
    }
}
