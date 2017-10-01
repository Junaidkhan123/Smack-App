//
//  TableViewCell.swift
//  mySmackApp
//
//  Created by Junaid Khan on 29/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var userImg: CircularImage!
    @IBOutlet weak var userNameLAbel: UILabel!
    @IBOutlet weak var messageTimeStampLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(message: Message)
    {
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        userNameLAbel.text = message.userName
        messageBodyLabel.text = message.message
       // messageTimeStampLabel.text = message.timeStamp
        guard var isoDate = message.timeStamp else {return}
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate
        {
           let finalDate = newFormatter.string(from: finalDate)
            messageTimeStampLabel.text = finalDate
        }
    }

}
