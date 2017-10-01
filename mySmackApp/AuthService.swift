
//
//  AuthService.swift
//  mySmackApp
//
//  Created by Junaid Khan on 14/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class AuthService
{
    static let instance = AuthService()
    let defaults = UserDefaults.standard
    
    var isLoggedIn : Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            // return defaults.string(forKey: TOKEN_KEY) ?? "This is default Value"
            return defaults.object(forKey: TOKEN_KEY) as? String ?? "This is defaultValue"
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL) as? String ?? "IDK yar !!!!"
            //return defaults.value(forKey: USER_EMAIL) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL)
        }
    }
    
    
    // Functions
    func registerUser(email: String, password: String, completion: @escaping completionHandler)
    {
        let lowerCasedEmail = email.lowercased()
        let body = [
            "email": lowerCasedEmail,
            "password": password
        ]
        Alamofire.request(URL_REGISTERS, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { (response) in
            if response.result.error == nil
            {
                // calling our own completion
                completion(true)
            }
            else
            {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func loginUsers(email: String, password: String, completion: @escaping completionHandler)
    {
        let lowerCasedEmail = email.lowercased()
        let body = [
            "email": lowerCasedEmail,
            "password": password
        ]
        Alamofire.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseJSON { (response) in
            print("This is the Response \(response)")
            if response.result.error == nil
            {
                if let json = response.result.value as? Dictionary<String,Any>{
                    if let email = json["user"] as? String
                    {
                        self.userEmail = email
                    }
                    if let token = json["token"] as? String
                    {
                        self.authToken = token
                    }
                    /// swiftyJSON
                    
                    //                guard let data = response.data else {return}
                    //                let json = JSON(data: data)
                    //                self.userEmail = json["user"].stringValue
                    //                self.authToken = json["token"].stringValue
                    self.isLoggedIn = true
                    
                }
                completion(true)
            }
            else{
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    func createUSer(name : String, email: String, avatarName: String, avatarColor: String, complete: @escaping completionHandler)
    {
        let lowerCasedEmail = email.lowercased()
        let body = [
            "name": name,
            "email": lowerCasedEmail,
            "avatarName": avatarName,
            "avatarColor": avatarColor
        ]
     
        Alamofire.request(URL_USERS_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                if let json = response.result.value as? Dictionary<String,Any>
                {
                    guard let name = json["name"] as? String else {return}
                    guard let email = json["email"] as? String else {return}
                    guard let colr = json["avatarColor"] as? String else {return}
                    guard let avatarName = json["avatarName"] as? String else {return}
                    guard let id = json["_id"] as? String else {return}
                    UserDataService.instance.setUserData(id: id, avatarColour: colr, avatarName: avatarName, email: email, name: name)
                }
                complete(true)
            }
            else {
                complete(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func findUserByEmail(complete: @escaping completionHandler)
    {
        Alamofire.request("\(URL_USERS_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil
            {
                if let json = response.result.value as? Dictionary<String,Any>
                {
                    guard let name = json["name"] as? String else {return}
                    guard let email = json["email"] as? String else {return}
                    guard let colr = json["avatarColor"] as? String else {return}
                    guard let avatarName = json["avatarName"] as? String else {return}
                    guard let id = json["_id"] as? String else {return}
                    UserDataService.instance.setUserData(id: id, avatarColour: colr, avatarName: avatarName, email: email, name: name)
                }
                complete(true)
            }
            else {
                complete(false)
                debugPrint(response.result.error as Any)
            }
            
        }
    }
}
