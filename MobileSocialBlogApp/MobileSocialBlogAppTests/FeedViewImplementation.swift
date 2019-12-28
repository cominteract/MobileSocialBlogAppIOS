//
//  FeedViewImplementation.swift
//  MobileSocialBlogAppTests
//
//  Created by Andre Insigne on 28/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class FeedViewImplementation: FeedView {
    var addedPost = false
    var addedComments = false
    var retrievedAll = false
    func addedPostUpdateView() {
        addedPost = true
    }
    
    func addedCommentsUpdateView() {
        addedComments = true
    }
    
    func retrievedAllUpdateView() {
        retrievedAll = true
    }
    
    func downloadedImageUpdateView(image: UIImage) {
        
    }
    
    func uploadedImageUpdateView() {
        
    }
    
    
}
