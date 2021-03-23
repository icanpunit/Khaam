//
//  ManageFont.swift
//  Deputize America
//
//  Created by Darshak Trivedi.
//  Copyright © 2017 Scorch Mobile. All rights reserved.
//

import Foundation
import UIKit



//MARK:- UIImage

/*extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}

//MARK:- Random Name

extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}

//MARK:- Date

extension DateComponentsFormatter
{
    func difference(from fromDate: Date, to toDate: Date) -> String? {
        self.allowedUnits = [.year,.month,.weekOfMonth,.day]
        self.maximumUnitCount = 1
        self.unitsStyle = .full
        return self.string(from: fromDate, to: toDate)
    }
}

extension Date
{
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
}

//MARK:- UserDefaults save Image

extension UserDefaults {
    func set(image: UIImage?, forKey key: String) {
        guard let image = image else {
            set(nil, forKey: key)
            return
        }
        set(UIImageJPEGRepresentation(image, 1.0), forKey: key)
    }
    func image(forKey key:String) -> UIImage? {
        guard let data = data(forKey: key), let image = UIImage(data: data )
            else  { return nil }
        return image
    }
    func set(imageArray value: [UIImage]?, forKey key: String) {
        guard let value = value else {
            set(nil, forKey: key)
            return
        }
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }
    func imageArray(forKey key:String) -> [UIImage]? {
        guard  let data = data(forKey: key),
            let imageArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UIImage]
            else { return nil }
        return imageArray
    }
}

//MARK:- String

extension String
{
    func removingWhitespaces() -> String
    {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func removeSpecialCharsFromString(_ str: String) -> String
    {
        struct Constants {
            static let validChars = Set("1234567890")
        }
        return String(str.filter { Constants.validChars.contains($0) })
    }
}

// MARK: - UIImage

extension UIImage
{
    func fixOrientation1() -> UIImage
    {
        if self.imageOrientation == UIImageOrientation.up
        {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        }
        else
        {
            return self
        }
    }
}

// MARK: - URL

extension URL
{
    static var documentsDirectory: URL
    {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return try! documentsDirectory.asURL()
    }
    
    static func urlInDocumentsDirectory(with filename: String) -> URL {
        return documentsDirectory.appendingPathComponent(filename)
    }
}

// MARK: -  Page Control Round

extension UIImage
{
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage?
    {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else
        {
            return nil
        }
        
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - Back Navigation

extension UINavigationController
{
    func backToViewController(viewController: Swift.AnyClass)
    {
        for element in viewControllers as Array
        {
            if element.isKind(of: viewController)
            {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}

// MARK: - UIColor

//extension UIColor
//{
//    public convenience init?(hexString: String)
//    {
//        let r, g, b, a: CGFloat
//        
//        if hexString.hasPrefix("#")
//        {
//            let start = hexString.index(hexString.startIndex, offsetBy: 1)
//            let hexColor = String(hexString[start...])
//            
//            if hexColor.count == 8 {
//                let scanner = Scanner(string: hexColor)
//                var hexNumber: UInt64 = 0
//                
//                if scanner.scanHexInt64(&hexNumber) {
//                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
//                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
//                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
//                    a = CGFloat(hexNumber & 0x000000ff) / 255
//                    
//                    self.init(red: r, green: g, blue: b, alpha: a)
//                    return
//                }
//            }
//        }
//        
//        return nil
//    }
//}

// MARK: - UILableClass

class MyCustomLabel: UILabel
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        textColor = darkGrayColor
        layer.masksToBounds = true
        layer.cornerRadius = 5
        adjustsFontSizeToFitDevice()
    }
}

extension UILabel
{
    func underline()
    {
        if let textString = self.text
        {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    func adjustsFontSizeToFitDevice()
    {
        switch UIDevice().screenType
        {
        case .iPhone4, .iPhone5:
            //font = font.withSize(font.pointSize - 20)
            font = UIFont(name: Regular, size: font.pointSize - 2)
            
            //font = font.withSize(font.pointSize - 2)
            
            break
        case .iPhone6Plus, .iPhoneX:
            //font = font.withSize(font.pointSize + 2)
            
            font = UIFont(name: Regular, size: font.pointSize + 2)
            
            
            break
        default:
            //font = font.withSize(font.pointSize)
            font = UIFont(name: Regular, size: font.pointSize)
        }
    }
}


// MARK: - UITextFieldClass

class MyCustomTextField: UITextField
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        layer.cornerRadius = 5
        let font = UIFont(name: Regular, size: 16)!
        let attributes = [
            NSAttributedStringKey.foregroundColor: darkGrayColor,
            NSAttributedStringKey.font : font]
        
        if self.placeholder != nil
        {
            attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                       attributes:attributes)
        }
        
        textColor = darkGrayColor
        adjustsFontSizeToFitDeviceUITextField()
    }
}

extension UITextField: UITextFieldDelegate
{
    func setLeftPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat)
    {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func underlined()
    {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = darkGrayColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    
    func adjustsFontSizeToFitDeviceUITextField()
    {
        switch UIDevice().screenType
        {
        case .iPhone4, .iPhone5:
            //font = font?.withSize((font?.pointSize)! - 2)
            //font = font.withSize(font.pointSize - 20)
            font = UIFont(name: Regular, size: (font?.pointSize)! - 2)
            break
        case .iPhone6Plus, .iPhoneX:
            
            font = UIFont(name: Regular, size: (font?.pointSize)! + 2)
            
            //font = font?.withSize((font?.pointSize)! + 2)
            break
        default:
            
            font = UIFont(name: Regular, size: (font?.pointSize)!)
            //font = font?.withSize((font?.pointSize)!)
        }
        
        self.delegate = self
    }
}

// MARK: - UITextViewClass

class MyCustomTextView: UITextView
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        textColor = darkGrayColor
        layer.cornerRadius = 5
        adjustsFontSizeToFitDeviceUITextView()
    }
}

extension UITextView: UITextViewDelegate
{
    func adjustsFontSizeToFitDeviceUITextView()
    {
        switch UIDevice().screenType
        {
            case .iPhone4, .iPhone5:
                font = font?.withSize((font?.pointSize)! - 2)
                //font = font.withSize(font.pointSize - 20)
                //font = UIFont(name: "OpenSans", size: (font?.pointSize)! - 2)
                break
            case .iPhone6Plus, .iPhoneX:
                font = font?.withSize((font?.pointSize)! + 2)
                break
            default:
                font = font?.withSize((font?.pointSize)!)
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLbl = self.viewWithTag(50) as? UILabel {
                placeholderText = placeholderLbl.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
                placeholderLbl.text = newValue
                placeholderLbl.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView)
    {
        if let placeholderLbl = self.viewWithTag(50) as? UILabel
        {
            placeholderLbl.isHidden = self.text.count > 0
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
            let x = self.textContainer.lineFragmentPadding
            let y = self.textContainerInset.top - 2
            let width = self.frame.width - (x * 2)
            let height = placeholderLbl.frame.height
            
            placeholderLbl.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLbl = UILabel()
        
        placeholderLbl.text = placeholderText
        placeholderLbl.sizeToFit()
        
        placeholderLbl.font = self.font
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.tag = 50
        
        placeholderLbl.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLbl)
        self.resizePlaceholder()
        self.delegate = self
    }
}

// MARK: - UIButton Class

class MyCustomButton: UIButton
{
    override func awakeFromNib()
    {
        super.awakeFromNib()
        //tintColor = UIColor(hexString:grayColor)
        layer.cornerRadius = 5
        //backgroundColor = UIColor.white
        adjustsFontSizeToFitDeviceUIButton()
    }
    
}

extension UIButton
{
    func underline()
    {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func adjustsFontSizeToFitDeviceUIButton()
    {
        switch UIDevice().screenType
        {
            case .iPhone4, .iPhone5:
                
                titleLabel?.font = UIFont(name: FontSemibold, size: (titleLabel?.font.pointSize)! - 2)!
                break
            case .iPhone6Plus, .iPhoneX:
                
                titleLabel?.font = UIFont(name: FontSemibold, size: (titleLabel?.font.pointSize)! + 2)!
                
                break
            default:
            
                titleLabel?.font = UIFont(name: FontSemibold, size: (titleLabel?.font.pointSize)!)!
                //titleLabel?.font = titleLabel?.font.withSize((titleLabel?.font.pointSize)!)
        }
    }
}

// MARK: - UIDevice Class

public extension UIDevice
{
    var iPhone: Bool
    {
        return UIDevice().userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String
    {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhoneX
        case Unknown
    }
    
    var screenType: ScreenType
    {
        guard iPhone else { return .Unknown}
        switch UIScreen.main.nativeBounds.height
        {
            case 960:
                return .iPhone4
            case 1136:
                return .iPhone5
            case 1334:
                return .iPhone6
            case 2208:
                return .iPhone6Plus
            case 2436:
                return .iPhoneX
            default:
                return .Unknown
        }
    }
}*/
