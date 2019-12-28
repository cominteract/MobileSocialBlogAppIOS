//
//  chatFriendTableViewCell.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class ChatSessionReplyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
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
