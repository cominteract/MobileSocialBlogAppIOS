//
//  ButtonPadding.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 19/03/2020.
//  Copyright © 2020 Andre Insigne. All rights reserved.
//

import UIKit

class ButtonPadding: UIButton {
    
    let padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    
    
}
