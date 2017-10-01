//
//  ChannelCells.swift
//  mySmackApp
//
//  Created by Junaid Khan on 26/09/2017.
//  Copyright © 2017 mac. All rights reserved.
//

import UIKit

class ChannelCells: UITableViewCell {
    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected
        {
        self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }
        else
        {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    func confugureCell(channel: Channel)
    {
        let title = channel.channelTitle ?? ""
        channelName.text = "#\(title)"
        channelName.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageServices.instance.unReadChannels
        {
            if id == channel.id
            {
                 channelName.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
    }

}
