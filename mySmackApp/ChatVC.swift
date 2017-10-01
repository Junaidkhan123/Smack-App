//
//  ChatVC.swift
//  mySmackApp
//
//  Created by Junaid Khan on 12/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
class ChatVC: UIViewController {
    // outlests
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var messageTable: UITableView!
    @IBOutlet weak var messageTyingBox: UITextField!
    @IBOutlet weak var channelLAbel: UILabel!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var typingUsersLabel: UILabel!
    // variables
    var isTyping = false
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTable.delegate = self
        messageTable.dataSource = self
        messageTable.estimatedRowHeight = 80
        messageTable.rowHeight = UITableViewAutomaticDimension
        messageTyingBox.delegate = self
        sendButton.isHidden = true
        menuBtn.addTarget(self.revealViewController(), action:#selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        let tap = UIGestureRecognizer(target: self, action: #selector(ChatVC.handleTapGesture(_:)))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userSelectedChannel(_:)), name: NOTIF_CHANNELS_DID_SELECTED, object: nil)
        
        SocketService.instance.getAllMessagesTrhoughSocket { (newMessages) in
            if newMessages.channelID == (MessageServices.instance.selectedChannel?.id)! && AuthService.instance.isLoggedIn
            {
                MessageServices.instance.messages.append(newMessages)
                self.messageTable.reloadData()
                if  MessageServices.instance.messages.count > 0
                {
                    let endIndex = IndexPath(row: MessageServices.instance.messages.count - 1, section: 0)
                    self.messageTable.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
//        SocketService.instance.getAllMessagesTrhoughSocket { (success) in
//            if success{
//                self.messageTable.reloadData()
//                if MessageServices.instance.messages.count > 0
//                {
//                    let endIndex = IndexPath(row: MessageServices.instance.messages.count - 1, section: 0)
//                    self.messageTable.scrollToRow(at: endIndex, at: .bottom, animated: false)
//                }
//            }
//        }
        
        
        SocketService.instance.getTypingUSersThroughSocket { (typingUSers) in
            guard let channelId = MessageServices.instance.selectedChannel?.id else {return}
            var names = ""
            var numberOfTypers = 0
            for (typingUser, channel) in typingUSers
            {
                if typingUser != UserDataService.instance.name && channel == channelId
                {
                    if names == ""
                    {
                        names = typingUser
                    }
                    else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            if numberOfTypers > 0 && AuthService.instance.isLoggedIn
            {
                var verb = "is"
                if numberOfTypers > 1
                {
                    verb = "are"
                }
                self.typingUsersLabel.text = "\(names) \(verb) typing a message"
            }
            else {
                self.typingUsersLabel.text = ""
            }
        }
        
        
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail(complete: { (success) in
                if success
                {
                    NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGE, object: nil)
                }
            })
        }
        // Do any additional setup after loading the view.
        
    }
    func userDataDidChange(_ notif: Notification)
    {
        if AuthService.instance.isLoggedIn{
            onLogin()
        }
        else {
            channelLAbel.text = "Please Log In "
            self.messageTable.reloadData()
        }
    }
    func userSelectedChannel(_ notif: Notification)
    {
        updateWithChannel()
    }
    
    
    func onLogin()
    {
        MessageServices.instance.getAllChannels { (success) in
            if success
            {
                // do channel stuffs
                if MessageServices.instance.channels.count > 0
                {
                    MessageServices.instance.selectedChannel = MessageServices.instance.channels[0]
                    self.updateWithChannel()
                }
                else {
                    self.channelLAbel.text = "No channels Yet !! "
                }
            }
        }
    }
    
    func updateWithChannel()
    {
        let channelTitle = MessageServices.instance.selectedChannel?.channelTitle ?? ""
        channelLAbel.text = "#\(channelTitle)"
        getMessages()
        
    }
    func getMessages()
    {
        guard let channelId = MessageServices.instance.selectedChannel?.id else {return}
        MessageServices.instance.getAllMessagesForChannels(channelId: channelId) { (success) in
            if success
            {
                self.messageTable.reloadData()
            }
        }
    }
    func handleTapGesture(_ tap: UITapGestureRecognizer)
    {
        view.endEditing(true)
    }
    // @IBactions
    @IBAction func messageSendBtnWasPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn
        {
            guard let channelID = MessageServices.instance.selectedChannel?.id else {return}
            guard let message = messageTyingBox.text else {return}
            SocketService.instance.addMessage(messageBody: message, channelID: channelID, userID: UserDataService.instance.id, complete: { (success) in
                if success
                {
                    
                    self.messageTyingBox.text = ""
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name ,channelID)
                }
                else {
                }
            })
        }
    }
    
    @IBAction func MessageBoxEditChanged(_ sender: Any) {
        guard let channelId = MessageServices.instance.selectedChannel?.id else {return}
        if messageTyingBox.text == ""
        {
            isTyping = false
            sendButton.isHidden = true
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name,channelId)
        }
        else
        {
            if isTyping == false
            {
                sendButton.isHidden = false
                SocketService.instance.socket.emit("startType",UserDataService.instance.name,channelId)
            }
            isTyping = true
        }
    }
    
    
}

extension ChatVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageServices.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = messageTable.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell
        {
            let message = MessageServices.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        }
        else {
            return UITableViewCell()
        }
    }
}
extension ChatVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        messageTyingBox.text = ""
        
    }
    
}
