//
//  AddChannelVC.swift
//  mySmackApp
//
//  Created by Junaid Khan on 26/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    // outlets
    @IBOutlet weak var backgoundView: UIView!
    @IBOutlet weak var channelDecTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTF.delegate = self
        
    }
    // Actions
    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func createChannelBtnWasPressed(_ sender: Any) {
        guard let name = nameTF.text , nameTF.text != "" else {return}
        guard let desc = channelDecTF.text else {return}
        SocketService.instance.addChannels(channelName: name, ChannelDescription: desc) { (success) in
            if success{
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    // custom Functions
    func setupView()
    {
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        backgoundView.addGestureRecognizer(closeTouch)
    }
    
    
    func closeTap(_ tap : UITapGestureRecognizer)
    {
        dismiss(animated: true, completion: nil)
    }
}

extension AddChannelVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nameTF.text = ""
        
    }
}
