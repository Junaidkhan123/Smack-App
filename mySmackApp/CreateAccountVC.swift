//
//  CreateAccountVC.swift
//  mySmackApp
//
//  Created by Junaid Khan on 12/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
class CreateAccountVC: UIViewController {
    
    // outlets
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImag: UIImageView!
    // Variables
    var avatarName = "profileDefault"
    var avatarColr = "[0.5,0.5,0.5,1]"
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        let tap = UITapGestureRecognizer(target: self, action:#selector(CreateAccountVC.handleTappe))
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDataService.instance.avatarName != ""
        {
            userImag.image = UIImage(named: UserDataService.instance.avatarName)
            avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && userImag.backgroundColor == nil
            {
                userImag.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    // actions
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        // UNWIND is the name of identifier saved in constants
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    @IBAction func createAccountBtnWasPressed(_ sender: Any) {
        spinner.isHidden = false
        spinner.startAnimating()
        guard let name = userNameTxt.text, userNameTxt.text != nil
            else {return}

        guard let email = emailTxt.text, emailTxt.text != nil
        else {return}
        guard let password = passwordTxt.text, passwordTxt.text != nil
            else {return}
        AuthService.instance.registerUser(email: email, password: password) { (succes) in
            if succes
            {
                // registering and login in the user 
               AuthService.instance.loginUsers(email: email, password: password, completion: { (success) in
                if succes
                {
                    AuthService.instance.createUSer(name: name, email: email, avatarName: self.avatarName, avatarColor: self.avatarColr, complete: { (success) in
                        if success
                        {
                            self.spinner.isHidden = true
                            self.spinner.stopAnimating()
                            print(UserDataService.instance.name, UserDataService.instance.avatarName)
                            NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGE, object: nil)
                            self.performSegue(withIdentifier: UNWIND, sender: nil)
                        }
                    })
                }
               })
            }
        }
    }
    
    @IBAction func chooseAvatarBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }

    @IBAction func generateBackgrndImgBtnWaspressed(_ sender: Any) {
        let red = CGFloat(arc4random_uniform(255)) / 255
        let green = CGFloat(arc4random_uniform(255)) / 255
        let  blue = CGFloat(arc4random_uniform(255))/255
        avatarColr = "[\(red) , \(green), \(blue), 1]"
        UIView.animate(withDuration: 0.3) {
               self.userImag.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 0.9)
        }
    }
    func handleTappe()
    {
        view.endEditing(true)
    }
}
