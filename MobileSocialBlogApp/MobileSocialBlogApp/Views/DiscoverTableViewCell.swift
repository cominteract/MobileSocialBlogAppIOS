//
//  DiscoverTableViewCell.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var discoverImageView: UIImageView!
    
    @IBOutlet weak var discoverUserLabel: UILabel!
    
    @IBOutlet weak var discoverLocationLabel: UILabel!
    
    
    @IBOutlet weak var discoverAddFriendButton: UIButton!
    
    @IBOutlet weak var discoverRemoveFriendButton: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
