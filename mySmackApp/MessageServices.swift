//
//  MessageServices.swift
//  mySmackApp
//
//  Created by Junaid Khan on 25/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class MessageServices
{
    static  let instance = MessageServices()
    
    var channels = [Channel]()
    var messages = [Message]()
    var unReadChannels = [String]()
    var selectedChannel : Channel?
    
    func getAllChannels(complete: @escaping completionHandler)
    {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            print(response)
            if response.result.error == nil
            {
                guard let data = response.data else {return}
                if let json = JSON(data: data).array
                {
                    for item in json
                    {
                        let name = item["name"].stringValue
                        let id = item["_id"].stringValue
                        let description = item["description"].stringValue
                        let channel = Channel(channelTitle: name, channelDescription:description, id: id)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_DID_LOADED, object: nil)
                    complete(true)
                }
            }
            else {
                print("I in error ")
                complete(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    func clearAllChannels()
    {
        channels.removeAll()
    }
    
    func getAllMessagesForChannels(channelId : String, complete: @escaping completionHandler)
    {
        Alamofire.request("\(URL_GET_Messages)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            print("This is the Response of all Messages \(response)")
            if response.result.error == nil
            {
                self.clearAllMessages()
                guard let data = response.data else {return}
                if let json = JSON(data: data).array
                {
                    for item in json{
                        let messageBody = item["messageBody"].stringValue
                        let userName = item["userName"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let userAvatarName = item["userAvatar"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        let message = Message(message: messageBody, userName: userName, channelID: channelId, userAvatar: userAvatarName, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    print(self.messages)
                    complete(true)
                }
            }
            else {
                debugPrint(response.result.error as Any)
                complete(true)
            }
        }
    }
    func clearAllMessages()
    {
        messages.removeAll()
    }
}
