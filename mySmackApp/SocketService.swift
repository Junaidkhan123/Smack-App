
//
//  SocketService.swift
//  mySmackApp
//
//  Created by Junaid Khan on 26/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
import SocketIO
class SocketService: NSObject {
    static let instance = SocketService()
    override init() {
        super.init()
    }
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: BASE_URLS)!)
    func establishConnection()
    {
        socket.connect()
    }
    func closeConnection()
    {
        socket.disconnect()
    }
    func addChannels(channelName: String, ChannelDescription: String, Complete: @escaping completionHandler)
    {
        socket.emit("newChannel",channelName,ChannelDescription)
        Complete(true)
    }
    func getChannels(Complete: @escaping completionHandler)
    {
        socket.on("channelCreated") { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else {return}
            guard let channelDesc = dataArray[1] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            let newChannel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageServices.instance.channels.append(newChannel)
            Complete(true)
        }
    }
    
    func addMessage(messageBody: String, channelID: String, userID: String, complete: @escaping completionHandler)
    {
        let user = UserDataService.instance
        socket.emit("newMessage", messageBody,userID,channelID,user.name,user.avatarName,user.avatarColour)
        complete(true)
    }
    
    func getAllMessagesTrhoughSocket(complete : @escaping (_ newMessage: Message) -> Void)
    {
        socket.on("messageCreated") { (dataArray, ack) in
            // msg.messageBody, msg.userId, msg.channelId, msg.userName, msg.userAvatar, msg.userAvatarColor, msg.id, msg.timeStamp
            guard let messageBody = dataArray[0] as? String else {return}
            guard let channelId = dataArray[2] as? String else {return}
            guard let userName = dataArray[3] as? String else {return}
            guard let userAvatar = dataArray[4] as? String else {return}
            guard let userAvatarColor = dataArray[5] as? String else {return}
            guard let id = dataArray[6] as? String else {return}
            guard let timeStamp = dataArray[7] as? String else {return}
            
             let message = Message(message: messageBody, userName: userName, channelID: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            complete(message)
         }
    }
    
    func getTypingUSersThroughSocket(_ complete: @escaping (_ typingUSers: [String: String]) -> Void)
    {
        socket.on("userTypingUpdate") { (dataArray, ack) in
            guard let userTypeDict = dataArray[0] as? [String: String] else {return}
            complete(userTypeDict)
        }
    }
}
