//
//  CommentsTableViewCell.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 29/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentUserImageView: UIImageView!
    
    @IBOutlet weak var commentUserLabel: UILabel!
    
    
    @IBOutlet weak var commentReplyToLabel: UILabel!
    
    @IBOutlet weak var commentMessageLabel: UILabel!
    
    @IBOutlet weak var commentTimestampLabel: UILabel!
    
    @IBOutlet weak var commentReplyImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
