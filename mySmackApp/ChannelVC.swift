//
//  ChannelVC.swift
//  mySmackApp
//
//  Created by Junaid Khan on 12/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {
    //Outlets
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var channelTable: UITableView!
    @IBOutlet weak var userImg: CircularImage!
    // This is used for directly coming back to the channelVC from accountVC and it is actually IBAction
    @IBAction func unwindSegue(segue: UIStoryboardSegue){}
    
    override func viewDidLoad() {
        channelTable.delegate = self
        channelTable.dataSource = self
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIF_USER_DID_CHANGE, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(channelsLaoded(_:)), name: NOTIF_CHANNELS_DID_LOADED, object: nil)
        
        
        SocketService.instance.getChannels { (success) in
            if success {
                self.channelTable.reloadData()
            }
        }
        
        SocketService.instance.getAllMessagesTrhoughSocket { (newMessage) in
            if newMessage.channelID != MessageServices.instance.selectedChannel?.id && AuthService.instance.isLoggedIn
            {
                MessageServices.instance.unReadChannels.append(newMessage.channelID)
                self.channelTable.reloadData()
            }
        }
        
        
        
        
    }
    // Actions
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let profileVC = ProfileVC()
            profileVC.modalPresentationStyle = .custom
            present(profileVC, animated: true, completion: nil)
        }
        else {
            performSegue(withIdentifier: "toLogin", sender: nil)
        }
    }
    
    @IBAction func addChannelBtnWaspressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn
        {
            let addchanelVC = AddChannelVC()
            addchanelVC.modalPresentationStyle = .custom
            present(addchanelVC, animated: true, completion: nil)
        }
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUserInfo()
    }
    func userDataDidChange(_ notif: Notification)
    {
        setupUserInfo()
    }
    
    func channelsLaoded(_ notif: Notification)
    {
        channelTable.reloadData()
    }
    func setupUserInfo()
    {
        if AuthService.instance.isLoggedIn
        {
            loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.instance.avatarName)
            userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColour)
        }
        else
        {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = UIColor.clear
            channelTable.reloadData()
        }
        
    }
}

extension ChannelVC : UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageServices.instance.channels.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = channelTable.dequeueReusableCell(withIdentifier: "ChannelCells", for: indexPath) as?  ChannelCells
        {
            let channel = MessageServices.instance.channels[indexPath.row]
            cell.confugureCell(channel: channel)
            return cell
        }
        else {
             return UITableViewCell()
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageServices.instance.channels[indexPath.row]
        MessageServices.instance.selectedChannel = channel
        
        if MessageServices.instance.unReadChannels.count > 0
        {
            MessageServices.instance.unReadChannels = MessageServices.instance.unReadChannels.filter{$0 != channel.id
        }
            let index = IndexPath(row: indexPath.row, section: 0)
            channelTable.reloadRows(at: [index], with: .none)
            channelTable.selectRow(at: index, animated: false, scrollPosition: .none)
        NotificationCenter.default.post(name: NOTIF_CHANNELS_DID_SELECTED, object: nil)
        // when channel is selected The menu slides :-D 
        self.revealViewController().revealToggle(animated: true)
    }
}
}
