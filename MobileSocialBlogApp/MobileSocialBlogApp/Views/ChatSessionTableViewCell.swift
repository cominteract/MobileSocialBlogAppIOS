//
//  chatFriendTableViewCell.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class ChatSessionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        chatFriendMessageLabel.layer.masksToBounds = true
        chatFriendMessageLabel.layer.borderWidth = 2
        chatFriendMessageLabel.layer.cornerRadius = 25
        //chatFriendMessageLabel.layer.borderColor = UIColor.gray as! CGColor
        // Initialization code
    }
    @IBOutlet weak var chatFriendImageView: UIImageView!
    
    @IBOutlet weak var chatFriendUserLabel: UILabel!
    
    @IBOutlet weak var chatFriendMessageLabel: UILabel!
    
    

    
    @IBOutlet weak var chatFriendTimestampLabel: UILabel!
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
