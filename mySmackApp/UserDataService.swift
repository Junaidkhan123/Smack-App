
//
//  UserDataService.swift
//  mySmackApp
//
//  Created by Junaid Khan on 20/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
class UserDataService
{
   static  let instance = UserDataService()
    public private(set) var  id = ""
    public private (set) var avatarColour = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    
    func setUserData(id: String, avatarColour: String, avatarName : String,email: String,name: String)
    {
        self.id = id
        self.avatarColour = avatarColour
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    
    func setAvatarName(avatarName : String)
    {
        self.avatarName = avatarName
    }
    
    
    func returnUIColor(components: String) -> UIColor {
        let scanner = Scanner(string: components)
        let skippedElemnts = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skippedElemnts
        
        
        var red, green, blue , alpha : NSString?
        scanner.scanUpToCharacters(from:comma, into: &red)
        scanner.scanUpToCharacters(from:comma, into: &green)
        scanner.scanUpToCharacters(from:comma, into: &blue)
        scanner.scanUpToCharacters(from:comma, into: &alpha)
        
        
        let defaultColr = UIColor.lightGray
        guard let rUnWrapped = red else {return defaultColr}
        guard let gUnWrapped = green else {return defaultColr}
        guard let bUnWrapped = blue else {return defaultColr}
        guard let aUnWrapped = alpha else {return defaultColr}
        
        
        // converitng value from string to Double then to float b/c there is no direct way to convert string to float
        let rFloat = CGFloat(rUnWrapped.doubleValue)
        let gFloat = CGFloat(gUnWrapped.doubleValue)
        let bFloat = CGFloat(bUnWrapped.doubleValue)
        let aFloat = CGFloat(aUnWrapped.doubleValue)
        
        let newUIColr = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
        return newUIColr
    }
    
    func userLogOut()
    {
        id = ""
        avatarColour = ""
        avatarName = ""
        email = ""
        name = ""
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        MessageServices.instance.clearAllChannels()
        MessageServices.instance.clearAllMessages()
        
    }
}
