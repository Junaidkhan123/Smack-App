
//
//  LoginVC.swift
//  mySmackApp
//
//  Created by Junaid Khan on 12/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var actvitySpinneView: UIView!
    @IBOutlet weak var passwordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.isHidden = true
        actvitySpinneView.alpha = 0
    }
    
    
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    
    }

    @IBAction func createAccounntBtnWasPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    @IBAction func loginBtnWasPressed(_ sender: Any) {
        bgView.alpha = 0.9
        actvitySpinneView.alpha = 1.0
        spinner.isHidden = false
        spinner.startAnimating()
        guard let emailName = userNameTF.text,userNameTF.text != "" else {return}
        guard let password = passwordTF.text , userNameTF.text != "" else {return}
        AuthService.instance.loginUsers(email: emailName, password: password) { (success) in
            if success
            {
                AuthService.instance.findUserByEmail(complete: { (success) in
                    if success{
                        NotificationCenter.default.post(name: NOTIF_USER_DID_CHANGE, object: nil)
                        self.spinner.isHidden = true
                        self.spinner.stopAnimating()
                        self.actvitySpinneView.alpha = 0.0
                        self.bgView.alpha = 0.0
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.actvitySpinneView.layer.cornerRadius = 25
    }
    
}
