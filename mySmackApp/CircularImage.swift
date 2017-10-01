//
//  CircularImage.swift
//  mySmackApp
//
//  Created by Junaid Khan on 21/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
@IBDesignable
class CircularImage: UIImageView {
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
        // this make this imageView circular if it is perfect square
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
}
