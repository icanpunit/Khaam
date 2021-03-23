//
//  BookAppointMentTimeVc.swift
//  TahaniFlowers
//
//  Created by baps on 25/09/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

class BookAppointMentTimeVc: UIViewController,HttpWrapperDelegate {

    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblNoTIme: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var lblAvailableTime: UILabel!
    @IBOutlet var viewHeader: UIView!
     var selectedAddressId = ""
    var fGrandTotal:Float = 0
     
    @IBOutlet weak var tblAddNewAddress: UITableView!
    @IBOutlet weak var collectionDateTime: UICollectionView!
    @IBOutlet weak var collectionTime: UICollectionView!
    let weekdays = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
      var dayCounter = -1
      var timeSlots = 0
      var completeAddress:NSMutableString = NSMutableString()
      var arrAllTimeSlot:NSArray = NSArray()
      var arrRelatedTimeSlots:NSMutableArray = NSMutableArray()
      var listOfDays:NSMutableArray = NSMutableArray()
     var arrDate:NSMutableArray = NSMutableArray()
    var selectedDateIndex = -1
    var selectedDate:Date = Date()
     var objTimeSlots = HttpWrapper()
    var selectedTimeSlotIndex = -1
    var isDateTimeSelected:Bool = false
    var selectedTimeSlot = ""
    var net:NetworkReachabilityManager = NetworkReachabilityManager()!
    override func viewDidLoad() {
        super.viewDidLoad()
      //  tblAddNewAddress.tableHeaderView = viewHeader
        lblAvailableTime.text = "lbl_Appoinment_AvailableTime".setlocalized()
        lblNoTIme.text = "lbl_Appoinment_NoData".setlocalized()
        
        btnNext.layer.cornerRadius = btnRadius
         btnNext.backgroundColor = btnBackgroundColor
        btnNext.setTitleColor(btnTitleColor, for: .normal)
        btnNext.setTitle(" \("lbl_Appoinment_btnNext".setlocalized())", for: .normal)
      
        
       // let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
let date = Date()
        lblMonth.text = Calendar.current.monthSymbols[date.get(.month)-1]
        
        let nib = UINib(nibName: "DateAppointMent_Cell", bundle: nil)
             collectionDateTime?.register(nib, forCellWithReuseIdentifier: "DateAppointMent_Cell")
        
      

        let nib2 = UINib(nibName: "TimeAppointMent_Cell", bundle: nil)
                    collectionTime?.register(nib2, forCellWithReuseIdentifier: "TimeAppointMent_Cell")
        
      

        self.arrDate.removeAllObjects()
               self.getDays()
               
               
               if UserDefaults.standard.object(forKey: knCustomerId) != nil
               {
                   
               }
              
               self.addNavigationBar()
               self.getTimeSlots()
        // Do any additional setup after loading the view.
    }

    
     @objc func back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func onClickbtnNext(_ sender: Any) {
        
        
        if  selectedTimeSlot == "" {
                AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_please_select_delivery_options".setlocalized());
            }
            else  if self.completeAddress == "" {
                AppHelper.showMessage(view: self.view, message: "lbl_DeliveryAddress_step_one_select_address".setlocalized());
            }
            else {
            
            let nextViewController = objProfile.instantiateViewController(withIdentifier: "ContactUs") as! ContactUs
           
                                          
                let dateFormatter = DateFormatter()
                                          //            dateFormatter.locale = Locale(identifier: "en")
                dateFormatter.dateFormat = "dd MMM yyyy"
                var date = Date()
                                                      
                if selectedDate != nil {
                    date = selectedDate
                    // datePickerView.date = selectedDate
                }
                                                     
                nextViewController.isAppointment = true
                nextViewController.selectedAddressId = self.selectedAddressId
                nextViewController.selectedDate = selectedDate
                nextViewController.selecedTime = selectedTimeSlot
                nextViewController.date = self.selectedDate
               nextViewController.completeAddress = completeAddress
            nextViewController.fGrandTotal = fGrandTotal
            nextViewController.fSubTotal = fGrandTotal
              //nextViewController.cardMessage = self.strCardMessage
                self.navigationController?.pushViewController(nextViewController, animated: true)
        }
        
//        let rootObj: MyAppointmentListVC = MyAppointmentListVC(nibName: "MyAppointmentListVC", bundle: nil)
//        
//        self.navigationController?.pushViewController(rootObj, animated: true)
        
        
    }
    func addNavigationBar(){
        self.navigationController?.isNavigationBarHidden = false
        let lbNavTitle = UILabel(frame: CGRect(x: CGFloat(35), y:self.view.bounds.size.width/2-235, width: CGFloat(200), height: CGFloat(40)))
        lbNavTitle.textAlignment = .center
      lbNavTitle.text = "Book An Appointment"
        lbNavTitle.textColor = UIColor.black
     //   lblTitle.text = "step_one_title".setlocalized()//appDelegate.setLocalizationstring(string: "lbl_cart")
        lbNavTitle.font = UIFont(name: RalewayLight, size: 20)
        self.navigationItem.titleView = lbNavTitle
        self.navigationController?.navigationBar.isTranslucent = false
         navigationController?.navigationBar.barTintColor = navigationbarColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
       
        self.view.backgroundColor  = navigationbarColor
        tblAddNewAddress.backgroundColor  = navigationbarColor
       // collectionDateTime.backgroundColor  = navigationbarColor
        collectionTime.backgroundColor  = navigationbarColor
        
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
        
       
    }
    
    
    func getTimeSlots() {
           if net.isReachable == false {
               let alert = UIAlertController(title: internetConnectedTitle, message: internetConnected, preferredStyle: UIAlertControllerStyle.alert)
               alert.addAction(UIAlertAction(title: "ok".setlocalized(), style: UIAlertActionStyle.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
           }
           else {
               let nUserId = UserDefaults.standard.value(forKey: knUserId) as! Int
               let cToken = UserDefaults.standard.value(forKey: kcToken) as! String
            
            var nCustomerId = "0"
                             var deviceid = ""
                                        if UserDefaults.standard.object(forKey: knCustomerId) != nil {
                                            nCustomerId = "\(UserDefaults.standard.object(forKey: knCustomerId) as! Int)"
                                        }
                             else
                                        {
                                      deviceid = "\(appDelegate.DeviceId)"
                             }
            
               var nLanguageId = ""
                                                             
                                                             if UserDefaults.standard.object(forKey: kLanguageId) != nil {
                                                                 nLanguageId = UserDefaults.standard.object(forKey: kLanguageId) as! String
                                                             }
               let param:NSMutableString = NSMutableString()
               
               param.append(String(format:"%@?", kTimeBookings))
               param.append(String(format:"nUserId=%@&", "\(nUserId)"))
              param.append(String(format:"nLanguageId=%@&", "\(nLanguageId)"))
            param.append(String(format:"nCustomerId=%@&", "\(nCustomerId)"))
               param.append(String(format:"cToken=%@", cToken))
               
               AppHelper.showLoadingView()
               self.objTimeSlots = HttpWrapper.init()
               self.objTimeSlots.delegate = self
               self.objTimeSlots.requestWithparamdictParamPostMethodwithHeaderGet(url: NSMutableString(string: param) as String, headers: nil)
           }
       }
       
    
     // MARK: - HttpWrapper Delegate
        
        func HttpWrapperfetchDataSuccess(wrapper: HttpWrapper, dicsResponse: NSMutableDictionary) {
          
           if wrapper == objTimeSlots {
                print(dicsResponse)
                AppHelper.hideLoadingView()
                if dicsResponse.value(forKey: "Success") as! String == "1" {
                    self.arrAllTimeSlot = dicsResponse.object(forKey: "Result") as! NSArray
                    fGrandTotal = 00
                   if let price1 = dicsResponse.value(forKey: "fAmount") as? NSNumber
                   {
                                              let st = Float(truncating: price1)
                                              fGrandTotal = st
                   }
                    else if  let price1 = dicsResponse.value(forKey: "fWalletAmount") as? Float
                    {
                        let st = price1
                                               fGrandTotal = st
                    }
                    else if  let price1 = dicsResponse.value(forKey: "fWalletAmount") as? NSString
                                       {
                                           let st = (price1 as NSString).floatValue
                                                                                        fGrandTotal = st
                                       }
                    
                    if let price1 = dicsResponse.value(forKey: "fWalletAmount") as? NSNumber
                                     {
                                                                let st = Float(truncating: price1)
                                        appDelegate.fWalletTotal = st
                                     }
                                      else if  let price1 = dicsResponse.value(forKey: "fAmount") as? Float
                                      {
                                          let st = price1
                                                                 appDelegate.fWalletTotal = st
                                      }
                                      else if  let price1 = dicsResponse.value(forKey: "fAmount") as? NSString
                                                         {
                                                             let st = (price1 as NSString).floatValue
                                                                                                          appDelegate.fWalletTotal = st
                                                         }
                    
                    
                    print(arrAllTimeSlot)
                }
            else
                {
                    fGrandTotal = 00
                                           if let price1 = dicsResponse.value(forKey: "fAmount") as? NSNumber
                                           {
                                                                      let st = Float(truncating: price1)
                                                                      fGrandTotal = st
                                           }
            }
            }
            
        }
        
        func HttpWrapperfetchDataFail(wrapper: HttpWrapper, error: NSError) {
            
        }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BookAppointMentTimeVc:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    // MARK: - Collectionview Delegate and datasource
       
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           if collectionView == collectionDateTime {
               var daysLimit:Int=0
               if UserDefaults.standard.object(forKey: kDaysLimit) != nil {
                   daysLimit = Int(UserDefaults.standard.object(forKey: kDaysLimit) as! String)!
               }
               
               return daysLimit
           }
           else {
               return self.arrRelatedTimeSlots.count
           }
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           if collectionView == collectionDateTime {
               
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateAppointMent_Cell", for: indexPath) as! DateAppointMent_Cell
//               cell.viewBack.layer.cornerRadius = 10
//               cell.viewBack.layer.borderWidth = 0.5
//               cell.viewBack.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
               let strDate = self.getOnlyDate(date: self.arrDate.object(at: indexPath.row) as! Date)
               cell.lblDate.text = strDate
               
            cell.lblDay.text = self.getWeekDay(date: self.arrDate.object(at: indexPath.row) as! Date).uppercased()
               
               if selectedDateIndex == indexPath.row {
                   selectedDate = self.arrDate.object(at: selectedDateIndex) as! Date
                   cell.lblLine.backgroundColor = btnBackgroundColor
//                   cell.lblDate.backgroundColor = btnBackgroundColor
//                   cell.lblDay.textColor = UIColor.white
//                   cell.lblDate.textColor = UIColor.white
               }
               else {
                cell.lblLine.backgroundColor = UIColor.clear
//                   cell.lblDay.backgroundColor = UIColor.white
//                   cell.lblDate.backgroundColor = UIColor.white
//                   cell.lblDay.textColor = UIColor.darkGray
//                   cell.lblDate.textColor = UIColor.darkGray
               }
               
               return cell
           }
           else {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TimeAppointMent_Cell", for: indexPath) as! TimeAppointMent_Cell
               let dicTime = self.arrRelatedTimeSlots[indexPath.row] as! NSDictionary
               cell.viewTimeSlot.layer.cornerRadius = 4
              // cell.viewTimeSlot.layer.borderWidth = 0.5
              // cell.viewTimeSlot.layer.borderColor = UIColor(hexString: "#DBDBEA").cgColor
              
               if selectedDateIndex != -1 {
                   
                   let strDate = AppHelper.dateToString(date: selectedDate, strFormate: "yyyy-MM-dd")
                   print(strDate)
                   let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
                   
                   cell.lblTime.text =  "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
                   
                   if isFutureDate(strTimeStamp: strTimeStamp) == true {
                       if selectedTimeSlotIndex == indexPath.row {
                           cell.viewTimeSlot.backgroundColor = btnBackgroundColor
                           cell.lblTime.backgroundColor = btnBackgroundColor
                           cell.viewSubTimeSlot.backgroundColor = btnBackgroundColor
                           cell.lblTime.textColor = UIColor.white
                       }
                       else {
                           cell.lblTime.backgroundColor = UIColor.white
                           cell.lblTime.textColor = UIColor.darkGray
                           cell.viewSubTimeSlot.backgroundColor = UIColor.white
                           cell.viewTimeSlot.backgroundColor = UIColor.white
                       }
                   }
                   else {
                       cell.lblTime.backgroundColor = UIColor.white
                       cell.viewTimeSlot.backgroundColor = UIColor.white
                       cell.viewSubTimeSlot.backgroundColor = UIColor.white
                       cell.lblTime.textColor = UIColor.gray
                   }

               }

               return cell
           }
       }
       
       func collectionView(_ collectionView: UICollectionView,
                           layout collectionViewLayout: UICollectionViewLayout,
                           sizeForItemAt indexPath: IndexPath) -> CGSize {
           if collectionView == collectionDateTime {
               return CGSize(width: 65, height: 80)
           }
           else {
               
            return CGSize(width: self.view.frame.size.width/2 - 20, height: 40)
            
              //  return CGSize(width: self.view.frame.size.width/2 - 20, height: 90)
//               if AppHelper.isEven(number: timeSlots) == true {
//                   return CGSize(width: self.view.frame.size.width/2 - 20, height: 30)
//               }
//               else {
//
//                   if indexPath.row < timeSlots - 1 {
//                       return CGSize(width: self.view.frame.size.width/2 - 20, height: 30)
//                   }
//                   else {
//                       return CGSize(width: self.view.frame.size.width - 30, height: 30)
//                   }
//               }
           }
       }
       
       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           if collectionView == collectionDateTime {
               self.selectedDateIndex = indexPath.row
               selectedDate = self.arrDate.object(at: indexPath.row) as! Date
               print(selectedDate)
               let selectedWeekDay = self.getWeekDay(date: self.arrDate.object(at: indexPath.row) as! Date)
               print(selectedWeekDay)
               self.arrRelatedTimeSlots.removeAllObjects()
               
               for day in 0..<self.arrAllTimeSlot.count {
                   let dicTime = self.arrAllTimeSlot.object(at: day) as! NSDictionary
                   print(dicTime.object(forKey: "cDay") as! String)
                   if (dicTime.object(forKey: "cDay") as! String).contains(selectedWeekDay) {
                       let strDate = AppHelper.dateToString(date: selectedDate, strFormate: "yyyy-MM-dd")
                       print(strDate)
                       let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
                       if isFutureDate(strTimeStamp: strTimeStamp) == true {
                           self.arrRelatedTimeSlots.add(dicTime)
                       }
                   }
               }
               print(self.arrRelatedTimeSlots)
               self.timeSlots = self.arrRelatedTimeSlots.count
               self.selectedTimeSlotIndex = -1
               self.collectionDateTime.reloadData()
               if timeSlots > 0 {
                   self.collectionTime.isHidden = false
                   self.collectionTime.reloadData()
               }
               else {
                   self.collectionTime.isHidden = true
                //   self.lblDeliveryTimeMessage.text = "lbl_DeliveryAddress_no_delivery_time_available".setlocalized()
               }
           }
           else {
               let dicTime = self.arrRelatedTimeSlots[indexPath.row] as! NSDictionary
               let strDate = AppHelper.dateToString(date: selectedDate, strFormate: "yyyy-MM-dd")
               let strTimeStamp = "\(strDate) \(dicTime.object(forKey: "cStartTime") as! String):00"
               self.selectedTimeSlot = "\(dicTime.object(forKey: "cStartTime") as! String) - \(dicTime.object(forKey: "cEndTime") as! String)"
               print(self.selectedTimeSlot)
               self.selectedTimeSlotIndex = indexPath.row
               if isFutureDate(strTimeStamp: strTimeStamp) == true {
                   self.collectionTime.reloadData()
               }
               
               self.isDateTimeSelected = true
                      
                    
           }
           
       }
    
     func getDays() {
            let date = Date()
            self.arrDate.add(date)
            for nDate in 1..<7 {
                let newDate =  Calendar.current.date(byAdding: .day, value: nDate, to: date)!
                arrDate.add(newDate)
            }
            print(self.arrDate)
        }
        
        func getOnlyDate(date:Date) -> String {
            let calender = Calendar.current
            let components = calender.dateComponents([.year, .month, .day], from: date)
            let day = components.day
            return "\(day as! Int)"
        }
        
        func getWeekDay(date:Date) -> String {
            let weekday = Calendar.current.component(.weekday, from: date)
            return self.weekdays[weekday - 1]
        }
        
        func isFutureDate(strTimeStamp:String) -> Bool {
            
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            let currentSystemDate = AppHelper.dateToString(date: date, strFormate: "yyyy-MM-dd")
            let strSystemDate = "\(currentSystemDate) \(hour):\(minutes):00"
            
            let timeDate = AppHelper.stringToDate(strDate: strTimeStamp, strFormate: "yyyy-MM-dd HH:mm:ss")
            let systemDate = AppHelper.stringToDate(strDate: strSystemDate, strFormate: "yyyy-MM-dd HH:mm:ss")
            
            let dateStamp:TimeInterval = timeDate.timeIntervalSince1970
            let dateSt:Int = Int(dateStamp)
            
            let currentStamp:TimeInterval = systemDate.timeIntervalSince1970
    //        print(Date())
    //        print(dateSt)
    //        print(currentStamp)
    //
            if Int(currentStamp) < dateSt {
                return true
            }
            else {
                return false
            }
        }
       
}
