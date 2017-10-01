//
//  Constants.swift
//  mySmackApp
//
//  Created by Junaid Khan on 12/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import Foundation

typealias completionHandler = (_ success: Bool) -> ()

// URLS 
let BASE_URLS = "https://chittychatchatjunaid.herokuapp.com/v1/"
let URL_REGISTERS = "\(BASE_URLS)account/register"
let URL_LOGIN = "\(BASE_URLS)account/login"
let URL_USERS_ADD = "\(BASE_URLS)user/add"
let URL_USERS_BY_EMAIL = "\(BASE_URLS)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URLS)channel/"
let URL_GET_Messages = "\(BASE_URLS)message/byChannel/"


// SEGUES
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "toChannelVC"
let TO_AVATAR_PICKER = "toAvatarPicker"


// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// HEADERS
let HEADER = [
    "Content-Type": "application/json; charset=utf-8"
]
let BEARER_HEADER = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type": "application/json; charset=utf-8"
]
//  Notifications Constants
let NOTIF_USER_DID_CHANGE = Notification.Name("notidDidChange")
let NOTIF_CHANNELS_DID_LOADED  = Notification.Name("notifChannelsLoaded")
let NOTIF_CHANNELS_DID_SELECTED  = Notification.Name("notifChannelSelected")

