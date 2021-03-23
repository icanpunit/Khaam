//
//  LocalizationTextFromURL.swift
//  TahaniFlowers
//
//  Created by baps on 24/04/20.
//  Copyright © 2020 Mandip Kanjiya. All rights reserved.
//

import Foundation
import SwiftyJSON
import SQLite3
import SQLite

enum UserDefaultsKeys : String {
    case isLoggedIn
    case labelUpdatedTime
    case labellanguage
}

extension UserDefaults{
    
    //MARK: Check Login
    func setLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        //synchronize()
    }
    
    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
    
    
    //MARK: Save User Data
    func setlanguage(value: String){
        set(value, forKey: UserDefaultsKeys.labellanguage.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getlanguage() -> String?{
        return string(forKey: UserDefaultsKeys.labellanguage.rawValue)
    }
    
    //MARK: Save User Data
    func setlanguageUpdateDate(value: String){
        set(value, forKey: UserDefaultsKeys.labelUpdatedTime.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getlanguageUpdateDate() -> String?{
        return string(forKey: UserDefaultsKeys.labelUpdatedTime.rawValue)
    }
    
    
}


class localizationDataModel {
    
    
    
    func requestData(completion: @escaping ((_ data: Bool) -> Void)) {
        // the data was received and parsed to String
        
        //  Created by Punit tunwar
       // var request = URLRequest(url: URL(string: "http://mashatelkuwait.com/v4/html/admin/api/v1/lang_label.php")!)
        var request = URLRequest(url: URL(string: "\(kbaseURL)LabelData.asmx/GetAllLabel?nUserId=1&cUpdatedDateTime=")!)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
               // print(response.)
              

                if data == nil
                {
                    return
                }
               let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                
                let swiftyJsonVar = JSON(json)
                if let resData = swiftyJsonVar.arrayObject {
                
            if let data = resData[0] as? NSDictionary{

                // print(dics)
                var updateDate = Date()
                var previousDate = Date()
                var isload = Bool()
                
                if let status = data.value(forKey: "Success") as? String
                {
                    if status == "1"
                    {
                        if let arr:NSArray = data.value(forKey: "result") as? NSArray
                       {
                        let dics:NSDictionary = arr.object(at: 0) as! NSDictionary
                        
                        
                        if let date = data.value(forKey: "cUpdatedDateTime") as? String
                                                    {
                                                        
                                                        if date.count > 18
                                                        {
                                                            let dateFormatter = DateFormatter()
                                                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                                            dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
                                                            updateDate = dateFormatter.date(from: date)!
                                                        }
                                                        
                                                        // UserDefaults.standard.setlanguageUpdateDate(value: date)
                                                    }
                        
                                                    if let date = UserDefaults.standard.getlanguageUpdateDate()
                                                    {
                                                        isload = false
                                                        let dateFormatter = DateFormatter()
                                                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                                        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
                                                        previousDate = dateFormatter.date(from: date)!
                        
                                                        if updateDate > previousDate
                                                        {
                                                            isload = true
                        
                        
                                                            //return self.deleteDatabase()
                                                            if let date = data.value(forKey: "cUpdatedDateTime") as? String
                                                            {
                                                                let dateFormatter = DateFormatter()
                                                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                                                dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
                                                                updateDate = dateFormatter.date(from: date)!
                                                                UserDefaults.standard.setlanguageUpdateDate(value: date)
                                                            }
                                                        }
                                                        else
                                                        {
                                                            isload = false
                                                        }
                        
                                                    }
                                                    else
                                                    {
                                                        isload = true
                                                        if let date = data.value(forKey: "cUpdatedDateTime") as? String
                                                        {
                                                            let dateFormatter = DateFormatter()
                                                            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                                            dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
                                                            updateDate = dateFormatter.date(from: date)!
                                                            UserDefaults.standard.setlanguageUpdateDate(value: date)
                                                        }
                                                    }
                        
                                         // isload  = true
                                                    if isload == true
                                                    {
                                                        if let data = dics.value(forKey: "English") as? [[String: AnyObject]]
                                                        {
                                                            // print(data)
                        
                                                            for enlish in data[0].keys
                                                            {
                        
                                                                let key = enlish
                                                                let value = data[0]["\(enlish)"]!
                        
                                                                
                                                                if "\(key)".setlocalized2().count > 0
                                                                {
                                                                    
                                                                    let queryString = "UPDATE tblLanguageFields SET field_EN='\(value)' WHERE field_name='\(key)'"
                                                                    
                                                                    
                                                                                                            var statement: OpaquePointer? = nil
                                                                    
                                                                    
                                                                    
                                                                                                            if sqlite3_prepare_v2(appDelegate.db, queryString, -1, &statement, nil) == SQLITE_OK {
                                                                    
                                                                    
                                                                                                                if sqlite3_step(statement) == SQLITE_DONE {
                                                                                                                    
                                                                                                                  print("Successfully Updated row.")
                                                                                                                } else {
                                                                                                                    print("Could not Update row.")
                                                                                                                }
                                                                                                            } else {
                                                                    
                                                                                                                // forces SQLite to send error message
                                                                                                                let errorMessage = String.init(validatingUTF8: sqlite3_errmsg(appDelegate.db))!
                                                                                                                print("update failed! \(errorMessage)")
                                                                    
                                                                                                            }
                                                                    
                                                                                                            sqlite3_finalize(statement)
                                                                }
                                                                else
                                                                {
                                                                    let queryString = "INSERT INTO tblLanguageFields (field_name, field_EN) VALUES ('\(key)','\(value)')"
                                                                    
                                                                    
                                                                                                            var statement: OpaquePointer? = nil
                                                                    
                                                                    
                                                                    
                                                                                                            if sqlite3_prepare_v2(appDelegate.db, queryString, -1, &statement, nil) == SQLITE_OK {
                                                                    
                                                                    
                                                                                                                if sqlite3_step(statement) == SQLITE_DONE {
                                                                                                                    
                                                                                                                  print("Successfully inserted row.")
                                                                                                                } else {
                                                                                                                    print("Could not Update row.")
                                                                                                                }
                                                                                                            } else {
                                                                    
                                                                                                                // forces SQLite to send error message
                                                                                                                let errorMessage = String.init(validatingUTF8: sqlite3_errmsg(appDelegate.db))!
                                                                                                                print("update failed! \(errorMessage)")
                                                                    
                                                                                                            }
                                                                    
                                                                                                            sqlite3_finalize(statement)
                                                                }
                                                                
                        
                                                            }
                                                        }
                        
                                                        if let data = dics.value(forKey: "arabic") as? [[String: AnyObject]]
                                                        {
                                                            // print(data)
                        
                                                            for enlish in data[0].keys
                                                            {
                        
                        
                                                                let key = enlish
                                                                let value = data[0]["\(enlish)"]!
                        
                                                                let queryString = "UPDATE tblLanguageFields SET field_AR='\(value)' WHERE field_name='\(key)'"
                        
                        
                                                                var statement: OpaquePointer? = nil
                        
                                                                if sqlite3_prepare_v2(appDelegate.db, queryString, -1, &statement, nil) == SQLITE_OK {
                        
                                                                    if sqlite3_step(statement) == SQLITE_DONE {
                                                                        // print("Successfully inserted row.")
                                                                    } else {
                                                                        // print("Could not Update row.")
                                                                    }
                                                                } else {
                        
                                                                    // forces SQLite to send error message
                                                                    let errorMessage = String.init(validatingUTF8: sqlite3_errmsg(appDelegate.db))!
                                                                    print("update failed! \(errorMessage)")
                        
                                                                }
                        
                                                                sqlite3_finalize(statement)
                        
                        
                                                            }
                                                        }
                        
                                                        completion(true)
                                                        let imageDataDict:[String: String] = ["image": "Done"]
                                                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
                        
                                                    }
                                                    else
                                                    {
                                                      completion(true)
                                                     }
                        appDelegate.isDownloadDone = true
                        }
                    }
                    else
                    {
                       completion(true)
                    }
                    
                }
                
            }
                                    }
               print(swiftyJsonVar)
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
        
//        let url = URL(string: "http://mashatelkuwait.com/v4/html/admin/api/v1/lang_label.php")!
//
//        request(url, method: .get, encoding: JSONEncoding.default, headers:nil ).responseJSON { (responseData) in
//
//            // print(responseData)
//            if((responseData.result.value) != nil) {
//                if(responseData.response?.statusCode == 200){
//                    let swiftyJsonVar = JSON(responseData.result.value!)
//                    if let resData = swiftyJsonVar.arrayObject {
//
//                        if let dics = resData[0] as? NSDictionary{
//
//                            // print(dics)
//                            var updateDate = Date()
//                            var previousDate = Date()
//                            var isload = Bool()
//                            if let date = dics.value(forKey: "updated_datetime") as? String
//                            {
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
//                                updateDate = dateFormatter.date(from: date)!
//                                // UserDefaults.standard.setlanguageUpdateDate(value: date)
//                            }
//                            if let date = UserDefaults.standard.getlanguageUpdateDate()
//                            {
//                                isload = false
//                                let dateFormatter = DateFormatter()
//                                dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
//                                previousDate = dateFormatter.date(from: date)!
//
//                                if updateDate > previousDate
//                                {
//                                    isload = true
//
//
//                                    //return self.deleteDatabase()
//                                    if let date = dics.value(forKey: "updated_datetime") as? String
//                                    {
//                                        let dateFormatter = DateFormatter()
//                                        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
//                                        updateDate = dateFormatter.date(from: date)!
//                                        UserDefaults.standard.setlanguageUpdateDate(value: date)
//                                    }
//                                }
//                                else
//                                {
//                                    isload = false
//                                }
//
//                            }
//                            else
//                            {
//                                isload = true
//                                if let date = dics.value(forKey: "updated_datetime") as? String
//                                {
//                                    let dateFormatter = DateFormatter()
//                                    dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
//                                    updateDate = dateFormatter.date(from: date)!
//                                    UserDefaults.standard.setlanguageUpdateDate(value: date)
//                                }
//                            }
//
//
//                            if isload == true
//                            {
//                                if let data = dics.value(forKey: "english") as? [[String: AnyObject]]
//                                {
//                                    // print(data)
//
//                                    for enlish in data[0].keys
//                                    {
//
//                                        let key = enlish
//                                        let value = data[0]["\(enlish)"]!
//
//                                        let queryString = "INSERT INTO tblLanguageFields (field_name, field_EN) VALUES ('\(key)','\(value)')"
//
//
//                                        var statement: OpaquePointer? = nil
//
//
//
//                                        if sqlite3_prepare_v2(appDelegate.db, queryString, -1, &statement, nil) == SQLITE_OK {
//
//
//                                            if sqlite3_step(statement) == SQLITE_DONE {
//                                                // print("Successfully inserted row.")
//                                            } else {
//                                                // print("Could not Update row.")
//                                            }
//                                        } else {
//
//                                            // forces SQLite to send error message
//                                            let errorMessage = String.init(validatingUTF8: sqlite3_errmsg(appDelegate.db))!
//                                            print("update failed! \(errorMessage)")
//
//                                        }
//
//                                        sqlite3_finalize(statement)
//
//                                    }
//                                }
//
//                                if let data = dics.value(forKey: "arabic") as? [[String: AnyObject]]
//                                {
//                                    // print(data)
//
//                                    for enlish in data[0].keys
//                                    {
//
//
//                                        let key = enlish
//                                        let value = data[0]["\(enlish)"]!
//
//                                        let queryString = "UPDATE tblLanguageFields SET field_AR='\(value)' WHERE field_name='\(key)'"
//
//
//                                        var statement: OpaquePointer? = nil
//
//                                        if sqlite3_prepare_v2(appDelegate.db, queryString, -1, &statement, nil) == SQLITE_OK {
//
//                                            if sqlite3_step(statement) == SQLITE_DONE {
//                                                // print("Successfully inserted row.")
//                                            } else {
//                                                // print("Could not Update row.")
//                                            }
//                                        } else {
//
//                                            // forces SQLite to send error message
//                                            let errorMessage = String.init(validatingUTF8: sqlite3_errmsg(appDelegate.db))!
//                                            print("update failed! \(errorMessage)")
//
//                                        }
//
//                                        sqlite3_finalize(statement)
//
//
//                                    }
//                                }
//
//                                completion(true)
//                                let imageDataDict:[String: String] = ["image": "Done"]
//                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "notificationName"), object: nil, userInfo: imageDataDict)
//
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
     completion(false)
    }
    
    func RemoveDataBase(completion: ((_ isRemove: Bool) -> Void)) {
        // the data was received and parsed to bool
        
        
//        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            .appendingPathComponent("HeroesDatabase.sqlite")
//
//        let filemManager = FileManager.default
//        do {
//            let fileURL = NSURL(fileURLWithPath: fileURL.path)
//             try appDelegate.db.run(users.delete())
//            print("Database Deleted!")
//            appDelegate.createSqlDatabase()
//            completion(true)
//        } catch {
//            print("Error on Delete Database!!!")
//            completion(false)
//        }
        
       completion(false)
    }
    
}
