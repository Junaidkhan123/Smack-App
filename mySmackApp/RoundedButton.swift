
//
//  RoundedButton.swift
//  mySmackApp
//
//  Created by Junaid Khan on 15/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 3.0
        {
        didSet
        {
            self.layer.cornerRadius = cornerRadius
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    func setupView()
    {
        self.layer.cornerRadius = cornerRadius
    }
    
}
