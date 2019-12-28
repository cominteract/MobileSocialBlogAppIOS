//
//  FeedTableViewCell.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 28/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    
    @IBOutlet weak var feedTitleLabel: UILabel!
    
    @IBOutlet weak var feedUsernameLabel: UILabel!
    
    
    @IBOutlet weak var feedTimestampLabel: UILabel!
    
    
    @IBOutlet weak var feedBodyLabel: UILabel!
    
    
    @IBOutlet weak var feedUpvoteImageView: UIImageView!
    
    @IBOutlet weak var feedDownvoteImageView: UIImageView!
    
    @IBOutlet weak var feedUpvoteLabel: UILabel!
    
    @IBOutlet weak var feedDownvoteLabel: UILabel!
    
    @IBOutlet weak var feedCommentLabel: UILabel!
    
    @IBOutlet weak var feedUserImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
