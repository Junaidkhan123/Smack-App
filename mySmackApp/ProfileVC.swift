//
//  ProfileVC.swift
//  mySmackApp
//
//  Created by Junaid Khan on 24/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    // Outlets
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(tappedBackgroundView(_:)))
        backgroundView.addGestureRecognizer(tapRec)
    }

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true,completion:nil )
    }
    @IBAction func logOutBtnWasPressed(_ sender: Any) {
        UserDataService.instance.userLogOut()
        NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    func  setupView()
    {
        profileImg.image = UIImage(named: UserDataService.instance.avatarName)
        profileImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColour)
        userName.text = UserDataService.instance.name
        userEmail.text = UserDataService.instance.email
        
    }
    func tappedBackgroundView(_ tap : UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
   
}
