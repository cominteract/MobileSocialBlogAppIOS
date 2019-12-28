//
//  Posts.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class Posts: NSObject {
    var id : String?
    var title : String?
    var body : String?
    var author : String?
    var userId : String?
    var users : [Users]?
    var timestamp : String?
    var timestamp_from : String?
    var url : String?
    var upvotes : Int = 0
    var downvotes : Int = 0
    var upvotedId : [String]?
    var downvotedId : [String]?
    
    static func posts() -> [Posts]
    {
        var posts = [Posts]()
        for _ in 0..<5{
            let post = Posts()
            post.author = Constants.randomString(length: 22)
            post.body = Constants.randomString(length: 300)
            post.downvotedId = [String]()
            post.downvotedId?.append(Constants.randomString(length: 22))
            post.upvotedId = [String]()
            post.upvotedId?.append(Constants.randomString(length: 22))
            post.downvotes = 5
            post.upvotes = 5
            post.id = Constants.randomString(length: 22)
            post.timestamp = Date().toStringDisplay()
            post.timestamp_from = Date().toStringDisplay()
            post.url = Constants.defaultposturl
            post.title = Constants.randomString(length: 100)
            post.userId = Constants.randomString(length: 22)
            posts.append(post)
        }
        return posts
    }
    
    
    static func convertToKeyVal(post : Posts) -> [String : Any]
    {
        var map = [String : Any]()
        if let id = post.id
        {
            map["id"] = id
        }
        if let userId = post.userId
        {
            map["userId"] = userId
        }
        if let author = post.author
        {
            map["author"] = author
        }
        if let title = post.title
        {
            map["title"] = title
        }
        if let body = post.body
        {
            map["body"] = body
        }
        if let url = post.url
        {
            map["url"] = url
        }
        if let timestamp = post.timestamp
        {
            map["timestamp"] = timestamp
        }
        if let timestamp = post.timestamp_from
        {
            map["timestamp_from"] = timestamp
        }
        if let upvotedId = post.upvotedId
        {
            map["upvotedId"] = upvotedId
        }
        if let downvotedId = post.downvotedId
        {
            map["downvotedId"] = downvotedId
        }
        map["upvotes"] = post.upvotes
        map["downvotes"] = post.downvotes
        return map
    }
}
