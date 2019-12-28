//
//  Users.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class Users: NSObject {
    var id : String?
    var username : String?
    var password : String?
    var fullname : String?
    var firstname : String?
    var lastname : String?
    var friendsId : [String]?

    var photoUrl : String?
    var friends : [Users]?
    var location : String?
    var birthday : String?
    var timestampCreated : String?
    var online : Bool?
    var friendsInviteId : [String]?
    var friendsRequestedId : [String]?
    
    static func users() -> [Users]
    {
        var users = [Users]()
        for _ in 0..<5{
            let user = Users()
            user.id = Constants.randomString(length: 22)
            user.friendsId = [String]()
            user.friendsId?.append(Constants.randomString(length: 22))
            user.friendsInviteId = [String]()
            user.friendsInviteId?.append(Constants.randomString(length: 22))
            user.friendsRequestedId = [String]()
            user.friendsRequestedId?.append(Constants.randomString(length: 22))
            user.lastname = Constants.randomString(length: 6)
            user.firstname = Constants.randomString(length: 6)
            user.fullname = "${user.firstname} ${user.lastname}"
            user.password = Constants.randomString(length: 22)
            user.birthday = "August 31 1986"
            user.location = "Dasma"
            user.photoUrl = Constants.defaultuserurl
            user.username = Constants.randomString(length: 22)
            users.append(user)
        }
        return users
    }
    
    static func convertToKeyVal(users : Users) -> [String : Any]
    {
        var map = [String : Any]()
        if let id = users.id
        {
            map["id"] = id
        }
        if let user = users.username
        {
            map["username"] = user
        }
        if let pass = users.password
        {
            map["password"] = pass
        }
        if let full = users.fullname
        {
            map["full"] = full
        }
        if let first = users.firstname
        {
            map["first"] = first
        }
        if let last = users.lastname
        {
            map["last"] = last
        }
        if let timestampCreated = users.timestampCreated
        {
            map["timestampCreated"] = timestampCreated
        }
        if let friendsId = users.friendsId
        {
            map["friendsId"] = friendsId
        }
        if let photoUrl = users.photoUrl
        {
            map["photoUrl"] = photoUrl
        }
        if let birthday = users.birthday
        {
            map["birthday"] = birthday
        }
        if let location = users.location
        {
            map["location"] = location
        }
        if let friendsInviteId = users.friendsInviteId
        {
            map["friendsInviteId"] = friendsInviteId
        }
        if let friendsRequestedId = users.friendsRequestedId
        {
            map["friendsRequestedId"] = friendsRequestedId
        }
        if let online = users.online{
            map["online"] = online
        }
        return map
    }
}
