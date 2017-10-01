//
//  AvatarCell.swift
//  mySmackApp
//
//  Created by Junaid Khan on 20/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit
enum AvatarType{
    case dark
    case light
}
class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    func setupView()
    {
        self.layer.backgroundColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    func configureCell(index :  Int, type : AvatarType)
    {
        if type == AvatarType.dark
        {
            avatarImg.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        else {
            avatarImg.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.darkGray.cgColor
        }
    }
}
