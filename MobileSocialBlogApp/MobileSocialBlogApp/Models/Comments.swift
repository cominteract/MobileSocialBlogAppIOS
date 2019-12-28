//
//  Comments.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class Comments: NSObject {
    var id : String?
    var message : String?
    var author : String?
    var timestamp : String?
    var timestamp_from : String?
    var upvotes : Int = 0
    var downvotes : Int = 0
    var commentedTo : String?
    var replyTo : String?
    var userId : String?
    var user : Users?
    var replyToComment : Comments?
    var commentedToPost : Posts?
    var upvotedId : [String]?
    var downvotedId : [String]?
    
    static func comments() -> [Comments]
    {
        var comments = [Comments]()
        for _ in 0..<5{
            let comment = Comments()
            comment.id = Constants.randomString(length: 22)
            comment.author = Constants.randomString(length: 6)
            comment.commentedTo = Constants.randomString(length: 22)
            comment.downvotedId = [String]()
            comment.downvotedId?.append(Constants.randomString(length: 22))
            comment.upvotedId = [String]()
            comment.upvotedId?.append(Constants.randomString(length: 22))
            comment.downvotes = 5
            comment.message = Constants.randomString(length: 300)
            comment.replyTo = Constants.randomString(length: 22)
            comment.timestamp = Date().toStringDisplay()
            comment.timestamp_from = Date().toStringDisplay()
            comment.upvotes = 5
            comment.userId = Constants.randomString(length: 22)
            comments.append(comment)
        }
        return comments
    }
    
    static func convertToKeyVal(comment : Comments) -> [String : Any]
    {
        var map = [String : Any]()
        if let id = comment.id
        {
            map["id"] = id
        }
        if let author = comment.author
        {
            map["author"] = author
        }
        if let message = comment.message
        {
            map["message"] = message
        }
        
        if let timestamp = comment.timestamp
        {
            map["timestamp"] = timestamp
        }
        if let timestamp = comment.timestamp_from
        {
            map["timestamp_from"] = timestamp
        }
        if let commentedTo = comment.commentedTo
        {
            map["commentedTo"] = commentedTo
        }
        if let replyTo = comment.replyTo
        {
            map["replyTo"] = replyTo
        }
        if let upvotedId = comment.upvotedId
        {
            map["upvotedId"] = upvotedId
        }
        if let downvotedId = comment.downvotedId
        {
            map["downvotedId"] = downvotedId
        }
        map["upvotes"] = comment.upvotes
        map["downvotes"] = comment.downvotes
        return map
    }
}
