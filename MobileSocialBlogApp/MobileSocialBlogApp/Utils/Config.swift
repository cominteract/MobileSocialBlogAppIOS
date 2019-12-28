//
//  Config.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 28/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class Config: NSObject {
    public static let username_key = "username"
    public static let ref_feed_key = "reffeed"
    public static let ref_chat_key = "refchat"
    public static let ref_prof_key = "refprof"
    public static let ref_discover_key = "refdiscover"
    /// updates the new username
    ///
    /// - Parameters:
    ///   - value: new value to update as String
    ///   - key: the identifier from the Keys as String
    static func updateUser(value : String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: username_key)
    }
    
    /// returns the username when saved
    ///
    /// - Returns: username as String after saving
    static func getUser() -> String?
    {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: username_key)
    }
    
    static func updateRefreshFeed(value : Bool)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: ref_feed_key)
    }

    static func getRefreshFeed() -> Bool?
    {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: ref_feed_key)
    }
    
    static func updateRefreshChat(value : Bool)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: ref_chat_key)
    }
    
    static func getRefreshChat() -> Bool?
    {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: ref_chat_key)
    }
    
    static func updateRefreshProfile(value : Bool)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: ref_prof_key)
    }
    
    static func getRefreshProfile() -> Bool?
    {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: ref_prof_key)
    }
    
    static func updateRefreshDiscover(value : Bool)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: ref_discover_key)
    }
    
    static func getRefreshDiscover() -> Bool?
    {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: ref_prof_key)
    }
    
    
}
