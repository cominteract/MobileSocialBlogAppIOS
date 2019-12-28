//
//  Constants.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class Constants: NSObject {
    static let users = "users"
    static let posts = "posts"
    static let chats = "chats"
    static let comments = "comments"
    static let sessions = "sessions"
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    static let defaultposturl = "https://blog.us.playstation.com/tachyon/2019/11/49118747543_df228ca2dd_k.jpg?w=1280"
    
    static let defaultuserurl = "https://alumni.crg.eu/sites/default/files/default_images/default-picture_0_0.png"
    
    static let firebaseurl = "https://firebasestorage.googleapis.com/"
}
