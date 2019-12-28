//
//  friendTableViewCell.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var friendImageView: UIImageView!
    
    @IBOutlet weak var friendUserLabel: UILabel!
    
    @IBOutlet weak var friendLocationLabel: UILabel!
    
    
    @IBOutlet weak var friendOnlineButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
