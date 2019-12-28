//
//  UINavigation.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//




import UIKit

/// Convenience class for referencing storyboards and viewcontrollers for navigation
final class UINavigation: NSObject {
    
    /// Login identifier key for the viewcontroller
    static let Login = "Login"
    /// Signup identifier key for the viewcontroller
    static let Signup = "Signup"
    /// Forgot identifier key for the viewcontroller
    static let Forgot = "Forgot"


    /// Home identifier key for the viewcontroller
    static let Home = "Home"
    /// Error identifier key for the viewcontroller
    static let Error = "Error"
    /// Settings identifier key for the viewcontroller
    
    
    /// Convenience method for returning the storyboard based on the identifier key
    ///
    /// - Parameter key: identifier key for identifying the view controller
    /// - Returns: the storyboard based on the identifier key
    static func storyBoard(key : String) -> UIStoryboard
    {
        var story : UIStoryboard
        switch key {
        case UINavigation.Login, UINavigation.Signup:
            story = UIStoryboard.init(name: "Login", bundle: nil)
        case UINavigation.Home:
            story = UIStoryboard.init(name: "Home", bundle: nil)
        default:
            story = UIStoryboard.init(name: "Error", bundle: nil)
        }
        return story
    }
    
    /// Convenience method for returning the view controller based on the identifier key
    ///
    /// - Parameter key: identifier key for identifying the view controller
    /// - Returns: the view controller based on the identifier key
    static func viewControllerFrom(key : String) -> UIViewController
    {
        //let story = UIStoryboard.init(name: <#T##String#>, bundle: <#T##Bundle?#>)
        let story = UINavigation.storyBoard(key: key)
        let vc = story.instantiateViewController(withIdentifier: key)
        return vc
    }
}
