//
//  SMNavigationController.swift
//  LNSideMenuEffect
//
//  Created by Luan Nguyen on 6/30/16.
//  Copyright © 2016 Luan Nguyen. All rights reserved.
//

import LNSideMenu

class SMNavigationController: LNSideMenuNavigationController {
  
  fileprivate var items:[String]?
   let userDefaults = UserDefaults.standard
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    // Using default side menu
    items = ["All","Hot Food","Sandwiches","Hot Pots","Hot Rolls", "Salads","Pies","Dessrts","Drinks","Breakfast","Cookies","Lunch fers","Lunch fers","Lunch fers","Lunch fers","Lunch fers","Lunch fers","Lunch fers","Lunch fers","Lunch fers"]
   //initialSideMenu(.left)
    // Custom side menu
    var currentLanguage = ""
           if UserDefaults.standard.value(forKey: kLanguageCode) == nil {
               currentLanguage = "en"
           }
           else {
               currentLanguage = UserDefaults.standard.value(forKey: kLanguageCode) as! String
           }
    UserDefaults.standard.set(currentLanguage, forKey: kLanguageCode)
    if currentLanguage == "en" {
       initialCustomMenu(pos: .left)
    }
    else {
        initialCustomMenu(pos: .right)
    }
    
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  fileprivate func initialSideMenu(_ position: Position) {
    menu = LNSideMenu(sourceView: view, menuPosition: position, items: items!)
    menu?.menuViewController?.menuBgColor = UIColor.black.withAlphaComponent(0.85)
    menu?.delegate = self
    menu?.underNavigationBar = false
    view.bringSubview(toFront: navigationBar)
  }
  
  fileprivate func initialCustomMenu(pos position: Position) {
    let vc = objHomeSB.instantiateViewController(withIdentifier: "SideMenu_Vc") as! SideMenu_Vc
    vc.delegate = self
    menu = LNSideMenu(navigation: self, menuPosition: position, customSideMenu: vc, size: .custom(UIScreen.main.bounds.width - UIScreen.main.bounds.width/4))
    menu?.delegate = self
    menu?.enableDynamic = false
    menu?.allowRightSwipe = false
    menu?.allowLeftSwipe = false
    menu?.underNavigationBar = true
    menu?.menuViewController?.menuBgColor = UIColor.red
    // Moving down the menu view under navigation bar
//    menu?.underNavigationBar = true
  }
  
  fileprivate func setContentVC(_ index: IndexPath) {
    print("Did select item at index: \(index)")
    var nViewController: UIViewController? = nil
    var  indexPath = index
    if indexPath.section == 0 {
   //            print("Hello this is linked area")
           }
           if indexPath.section == 1 {
               if indexPath.row == 0 {
                   
               }
               else if indexPath.row == 1 {
                   let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "ProductCategory") as! ProductCategory
                   nextViewController.isCategory = true
                   nextViewController.cCategoryName = "home_shop_by_category".setlocalized()
                 self.setContentViewController(nextViewController)
                  // self.navigationController?.pushViewController(nextViewController, animated: true)
               }
                else if indexPath.row == 2 {
                
                 let rootObj: BarcodeScanner_VC = BarcodeScanner_VC(nibName: "BarcodeScanner_VC", bundle: nil)
                self.setContentViewController(rootObj)
                //        rootObj.cBreakTypeName = strBreckName
                //        rootObj.nBreakTypeId = strBrackid
                //        rootObj.isbreck = true
                //        rootObj.isEndBreck = true
                //        rootObj.delegate = self
                     //   let navigate = UINavigationController(rootViewController: rootObj)
                      //  present(navigate, animated: true, completion: nil)
               }
               else if indexPath.row == 3 {
                
               
                if userDefaults.object(forKey: kisLogin) != nil {
                    let nextViewController = objProfile.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                                                                    nextViewController.strType = "1"
                                                                      self.setContentViewController(nextViewController)
                }
                else
                {
                    let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "SelectLanguage") as! SelectLanguage
                    self.setContentViewController(nextViewController)
                }
                 
               }
                else if indexPath.row == 4 {
                
                if userDefaults.object(forKey: kisLogin) != nil {
                    let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
                   // nextViewController.strType = "2"
                    self.setContentViewController(nextViewController)
                               }
                               else
                               {
                                   let nextViewController = objProfile.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
                                                                                  nextViewController.strType = "1"
                                                                                    self.setContentViewController(nextViewController)
                               }
                               
                
              
                              }
               else if indexPath.row == 5 {
                
                if userDefaults.object(forKey: kisLogin) != nil {
                                  let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
                                                    // nextViewController.strType = "2"
                                                     self.setContentViewController(nextViewController)
                                              }
                                              else
                                              {
                                                   let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
                                                                     // nextViewController.strType = "2"
                                                                      self.setContentViewController(nextViewController)
                                              }
                
                   
               }
               else {
                   let nextViewController = objMain.instantiateViewController(withIdentifier: "Login") as! Login
                   nextViewController.navigationItem.hidesBackButton = true
                  self.setContentViewController(nextViewController)
               }
              
           }
           else if indexPath.section == 2 {
                   if userDefaults.object(forKey: kisLogin) != nil {
                       if indexPath.row == 0 {
                           let nextViewController = objProfile.instantiateViewController(withIdentifier: "Profile") as! Profile
                        nextViewController.isBackRequired = true
                           self.setContentViewController(nextViewController)
                       }
                       else if indexPath.row == 1 {
                           let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Orders") as! Orders
                           self.setContentViewController(nextViewController)
                       }
                       else if indexPath.row == 2 {
                           let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Address") as! Address
                           self.setContentViewController(nextViewController)
                       }
                       else if indexPath.row == 3 {
                        let nextViewController = objHomeSB.instantiateViewController(withIdentifier: "Wishlist_Vc") as! Wishlist_Vc
                       
                           self.setContentViewController(nextViewController)
                       }
//                       else if indexPath.row == 4{
//                           let nextViewController = objCart.instantiateViewController(withIdentifier: "SampleCart") as! SampleCart
//                           self.setContentViewController(nextViewController)
//                       }
                       else if indexPath.row == 4{
                           let nextViewController = objMain.instantiateViewController(withIdentifier: "ResetPassword") as! ResetPassword
                           self.setContentViewController(nextViewController)
                       }
                       else {
                           
                           let logoutAlert = UIAlertController(title: "lbl_home_title".setlocalized(), message: "menu_do_you_want_to_logout".setlocalized(), preferredStyle: UIAlertControllerStyle.alert)
                           
                           logoutAlert.addAction(UIAlertAction(title: "menu_yes".setlocalized(), style: .default, handler: { (action: UIAlertAction!) in
                               UserDefaults.standard.removeObject(forKey: kisLogin)
                               UserDefaults.standard.removeObject(forKey: knLoginId)
                               UserDefaults.standard.removeObject(forKey: kcUserName)
                               UserDefaults.standard.removeObject(forKey: knCustomerId)
                               UserDefaults.standard.removeObject(forKey: kcCustomerName)
                               UserDefaults.standard.removeObject(forKey: kcEmail)
                               UserDefaults.standard.removeObject(forKey: kcPassword)
                               UserDefaults.standard.removeObject(forKey: kcContactNo)
                               UserDefaults.standard.removeObject(forKey: kcGender)
                               UserDefaults.standard.removeObject(forKey: kcCustomerType)
                               UserDefaults.standard.removeObject(forKey: kcCustomerImage)
                              // UserDefaults.standard.removeObject(forKey: kcToken)
                               UserDefaults.standard.removeObject(forKey: kcBio)
                               UserDefaults.standard.removeObject(forKey: kcSocialLogin)
                               self.userDefaults.synchronize()
                               
                               UserDefaults.standard.set("menu_logout_successfully".setlocalized(), forKey: kisMessage)
                               
                               appDelegate.SetTabBarItem(0)
                           }))
                           
                           logoutAlert.addAction(UIAlertAction(title: "menu_no".setlocalized(), style: .cancel, handler: { (action: UIAlertAction!) in
                               print("Handle Cancel Logic here")
                           }))
                           
                           present(logoutAlert, animated: true, completion: nil)
                       }
               }
               
           }
    
//     viewController = viewControllers.first , viewController is Information_Vc {
//      nViewController =  Home_Vc(nibName:"Home_Vc",bundle: nil) //objHomeSB.instantiateViewController(withIdentifier: "Home_Vc") as! Home_Vc
//    } else {
//      nViewController = Information_Vc(nibName:"Information_Vc",bundle: nil)
//    }
//    if let viewController = nViewController {
//      self.setContentViewController(viewController)
//    }
    // Test moving up/down the menu view
    if let sm = menu, sm.isCustomMenu {
      menu?.underNavigationBar = false
    }
  }
    
    func doShare() {
        let viewController = UIActivityViewController(activityItems: ["ScreenSort for iOS.", URL.init(string: "https://itunes.apple.com/app/id1170886809")!], applicationActivities: nil)
        viewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        self.present(viewController, animated: true, completion: nil)
    }

  
}

extension SMNavigationController: UIActivityItemSource {
      func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
          return ""
      }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
          return URL.init(string: "https://itunes.apple.com/app/id1170886809")!
      }

    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
          return "ScreenSort for iOS: https://itunes.apple.com/app/id1170886809"
      }

    func activityViewController(_ activityViewController: UIActivityViewController, thumbnailImageForActivityType activityType: UIActivity.ActivityType?, suggestedSize size: CGSize) -> UIImage? {
          return nil
      }
  }

extension SMNavigationController: LNSideMenuDelegate {
  func sideMenuWillOpen() {
    print("sideMenuWillOpen")
  }
  
  func sideMenuWillClose() {
    print("sideMenuWillClose")
  }
  
  func sideMenuDidClose() {
    print("sideMenuDidClose")
  }
  
  func sideMenuDidOpen() {
    print("sideMenuDidOpen")
  }
  
  func didSelectItemAtIndex(_ index: Int) {
    //setContentVC(index)
  }
}

extension SMNavigationController: LeftMenuDelegate {
    func didSelectItemAtIndex(indexPath idx: IndexPath) {
        menu?.toggleMenu() { [unowned self] in
          self.setContentVC(idx)
        }
    }
    
 
}

