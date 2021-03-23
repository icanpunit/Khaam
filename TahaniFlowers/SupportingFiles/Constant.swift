//
//  Constant.swift
//  Deputize America
//
//  Created by Darshak Trivedi.
//  Copyright © 2017 Scorch Mobile. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

let appDelegate = UIApplication.shared.delegate as! AppDelegate
//MARK:- Font
let RalewayRegular = "Dubai-Regular"
let RalewayLight  = "Dubai-light"
let RalewaySemiBold = "Dubai-Medium"
let RalewayBold = "Dubai-Bold"

let btnRadius:CGFloat = 5
//MARK:- Color
let navigationbarColor = UIColor.init(hexString: "f4f4f4")
let ColorLightgray = UIColor(hexString: "9b9b9b")
let ColorDarkblack = UIColor(hexString: "4a4a4a")
let Colorblack = UIColor(hexString: "000000")
let Colorblack2 = UIColor(hexString: "484848")
let ColorOrange = UIColor(hexString: "f39019")
let colorGreen =  UIColor(hexString: "539E66")
let colorlight =  UIColor(hexString: "f4f4f4")
let ColorStarEmpty = UIColor(hexString: "f8f8f8")
let ColorBgNavigation =  UIColor(hexString: "fbfbfb")
let ColorLightGray = UIColor(hexString: "4a4a4a")
let colorRed =  UIColor(hexString: "d0021b")
let colorLine =  UIColor(hexString: "d8d8d8")
let colorBlue =  UIColor(hexString: "00BDF4")
let btnBackgroundColor =  UIColor(hexString: "EC155E")
let btnTitleColor =  UIColor.white

//MARK:- Storyboards Objects
let objLaunchScreenSB = UIStoryboard(name: "LaunchScreenSB", bundle: nil)
let objMain = UIStoryboard(name: "Main", bundle: nil)
let objHomeSB = UIStoryboard.init(name: "HomeSB", bundle: nil)
let objCart = UIStoryboard.init(name: "CartSB", bundle: nil)
let objProfile = UIStoryboard.init(name: "ProfileSB", bundle: nil)


//Instance Create




//MARK:- General Constant
let kisLogin       = "Login"
let kisMessage     = "Message"
let kCartData      = "myCartData"
//var isBackRequired:Bool = false
let kCurrency      = "currency"
let kLanguageId = "LangaugeId"
let kFirstTime = "FirstTime"
let kGlobalCartCount = "GlobalCartCount"

let kLanguageCode = "LanguageCode"
let knotificaiton = "notificaiton"

//Signup Success
let knLoginId        = "nLoginId"
let knUserId        = "nUserId"
let kcUserName = "kcUserName"
let knCustomerId        = "nCustomerId"
let kcCustomerName       = "cCustomerName"
let kcFirstName = "cFirstName"
let kcLastName = "cLastName"
let kcEmail   = "cEmail"
let kcPassword = "cPassword"
let kcContactNo = "cContactNo"
let kcGender = "Gender"
let kcCustomerType = "cCustomerType"
let kcCustomerImage    = "cCustomerImage"
let kcToken        = "cToken"
let kcBio        = "cBio"


let SignOutKey   = "isSignOut"

//

let kUserName = "sUserName"
let kProfile_pic = "img_user2"

let kcBillingAddress = ""

let kcSocialLogin = "SocialLogin"

let kSupportEmail = "SupportEmail"

var currentScrren = ""

let kDaysLimit = "DaysLimit"
