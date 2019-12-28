//
//  Conversions.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit
import Firebase

class UserConversion{
    var didConvertUser : ((Users?) -> Void)?
}
class PostsConversion{
    var didConvertPosts : ((Posts?) -> Void)?
}
class CommentsConversion{
    var didConvertComments : ((Comments?) -> Void)?
}
class ChatMessagesConversion{
    var didConvertChatMessages : ((ChatMessages?) -> Void)?
}

class ChatSessionConversion{
    var didConvertChatSession : ((ChatSession?) -> Void)?
}

class Conversions: NSObject {
    
    static func convertToPosts(ref : DatabaseReference, conversion : PostsConversion)
    {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            let posts = Posts()
            let value = snapshot.value as? NSDictionary
            if !snapshot.exists()
            {
                conversion.didConvertPosts?(nil)
                return
            }
            if let id = value?["id"] as? String
            {
                posts.id = id
            }
            if let author = value?["author"] as? String
            {
                posts.author = author
            }
            if let title = value?["title"] as? String
            {
                posts.title = title
            }
            if let body = value?["body"] as? String
            {
                posts.body = body
            }
            if let url = value?["url"] as? String
            {
                posts.url = url
            }
            if let timestamp = value?["timestamp"] as? String
            {
                posts.timestamp = timestamp
            }
            if let timestamp = value?["timestamp_from"] as? String
            {
                posts.timestamp_from = timestamp
            }
            if let upvotes = value?["upvotes"] as? Int
            {
                posts.upvotes = upvotes
            }
            if let downvotes = value?["downvotes"] as? Int
            {
                posts.downvotes = downvotes
            }
            if let upvotedId = value?["upvotedId"] as? [String]
            {
                posts.upvotedId = upvotedId
            }
            if let downvotedId = value?["downvotedId"] as? [String]
            {
                posts.downvotedId = downvotedId
            }
            
            conversion.didConvertPosts?(posts)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func convertToAllPosts(values : NSDictionary) -> [Posts]
    {
        var posts = [Posts]()
        for key in values.allKeys
        {
            if let value = values[key] as? NSDictionary
            {
                let post = Posts()
                post.id = value["id"] as? String
                post.author = value["author"] as? String
                post.title = value["title"] as? String
                post.body = value["body"] as? String
                post.timestamp = value["timestamp"] as? String
                post.timestamp_from = value["timestamp_from"] as? String
                post.url = value["url"] as? String
                post.upvotedId = value["upvotedId"] as? [String]
                post.downvotedId = value["downvotedId"] as? [String]
                post.userId = value["userId"] as? String
                if let upvotes = value["upvotes"] as? Int{
                    post.upvotes = upvotes
                }
                if let downvotes = value["downvotes"] as? Int {
                    post.downvotes = downvotes
                }
                posts.append(post)
            }
        }
        return posts
    }
    
    
    
    static func convertToAllUsers(values : NSDictionary) -> [Users]
    {
        var users = [Users]()
        for key in values.allKeys
        {
            if let value = values[key] as? NSDictionary
            {
                let user = Users()
                user.id = value["id"] as? String
                user.firstname = value["first"] as? String
                user.lastname = value["last"] as? String
                user.fullname = value["full"] as? String
                user.username = value["username"] as? String
                user.password = value["password"] as? String
                user.photoUrl = value["photoUrl"] as? String
                user.birthday = value["birthday"] as? String
                user.location = value["location"] as? String
                user.timestampCreated = value["timestampCreated"] as? String
                user.friendsId = value["friendsId"] as? [String]
                user.online = value["online"] as? Bool
                user.friendsInviteId = value["friendsInviteId"] as? [String]
                user.friendsRequestedId = value["friendsRequestedId"] as? [String]
                
                users.append(user)
            }
        }
        return users
    }
    
    static func convertToAllComments(values : NSDictionary) -> [Comments]
    {
        var comments = [Comments]()
        for key in values.allKeys
        {
            if let value = values[key] as? NSDictionary
            {
                let comment = Comments()
                comment.id = value["id"] as? String
                comment.author = value["author"] as? String
                comment.message = value["message"] as? String
                comment.timestamp = value["timestamp"] as? String
                comment.timestamp_from = value["timestamp_from"] as? String
                comment.commentedTo = value["commentedTo"] as? String
                comment.replyTo = value["replyTo"] as? String
                comment.userId = value["userId"] as? String
                comment.upvotedId = value["upvotedId"] as? [String]
                comment.downvotedId = value["downvotedId"] as? [String]
                
                if let upvotes = value["upvotes"] as? Int{
                    comment.upvotes = upvotes
                }
                if let downvotes = value["downvotes"] as? Int {
                    comment.downvotes = downvotes
                }
                comments.append(comment)
            }
        }
        return comments
    }
    
    static func convertToComments(ref : DatabaseReference, conversion : CommentsConversion)
    {
    
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if !snapshot.exists()
            {
                conversion.didConvertComments?(nil)
                return
            }
            let comments = Comments()
            if let id = value?["id"] as? String
            {
                comments.id = id
            }
            if let author = value?["author"] as? String
            {
                comments.author = author
            }
            if let message = value?["message"] as? String
            {
                comments.message = message
            }
            if let timestamp = value?["timestamp"] as? String
            {
                comments.timestamp = timestamp
            }
            if let timestamp = value?["timestamp_from"] as? String
            {
                comments.timestamp_from = timestamp
            }
            if let commentedTo = value?["commentedTo"] as? String
            {
                comments.commentedTo = commentedTo
            }
            if let replyTo = value?["replyTo"] as? String
            {
                comments.replyTo = replyTo
            }
            if let upvotes = value?["upvotes"] as? Int
            {
                comments.upvotes = upvotes
            }
            if let downvotes = value?["downvotes"] as? Int
            {
                comments.downvotes = downvotes
            }
            if let upvotedId = value?["upvotedId"] as? [String]
            {
                comments.upvotedId = upvotedId
            }
            if let downvotedId = value?["downvotedId"] as? [String]
            {
                comments.downvotedId = downvotedId
            }
            
            conversion.didConvertComments?(comments)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    static func convertToAllChatMessages(values : NSDictionary) -> [ChatMessages]
    {
        var chats = [ChatMessages]()
        for key in values.allKeys
        {
            if let value = values[key] as? NSDictionary
            {
                let chat = ChatMessages()
                chat.id = value["id"] as? String
                chat.author = value["author"] as? String
                chat.message = value["message"] as? String
                chat.timestamp = value["timestamp"] as? String
                chat.timestamp_from = value["timestamp_from"] as? String
                chat.userId = value["userId"] as? String
                chat.replyTo = value["replyTo"] as? String
                chat.msgId = value["msgId"] as? Int
                chats.append(chat)
            }
        }
        return chats
    }
    
    static func convertToChats(ref : DatabaseReference, conversion : ChatMessagesConversion)
    {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if !snapshot.exists()
            {
                conversion.didConvertChatMessages?(nil)
                return
            }
            let chat = ChatMessages()
            if let id = value?["id"] as? String
            {
                chat.id = id
            }
            if let author = value?["author"] as? String
            {
                chat.author = author
            }
            if let message = value?["message"] as? String
            {
                chat.message = message
            }
            if let timestamp = value?["timestamp"] as? String
            {
                chat.timestamp = timestamp
            }
            if let timestamp = value?["timestamp_from"] as? String
            {
                chat.timestamp_from = timestamp
            }
            if let replyTo = value?["replyTo"] as? String
            {
                chat.replyTo = replyTo
            }
            if let userId = value?["userId"] as? String
            {
                chat.userId = userId
            }
            if let msgId = value?["msgId"] as? Int
            {
                chat.msgId = msgId
            }
            
            conversion.didConvertChatMessages?(chat)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func convertToAllChatSession(values : NSDictionary) -> [ChatSession]
    {
        var chats = [ChatSession]()
        for key in values.allKeys
        {
            if let value = values[key] as? NSDictionary
            {
                let chat = ChatSession()
                chat.author = value["author"] as? String
                chat.id = value["id"] as? String
                chat.message = value["message"] as? String
                chat.timestamp = value["timestamp"] as? String
                chat.userIds = value["userIds"] as? [String]
                
                chats.append(chat)
            }
        }
        return chats
    }
    
    static func convertToChatSession(ref : DatabaseReference, conversion : ChatSessionConversion)
    {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            if !snapshot.exists()
            {
                conversion.didConvertChatSession?(nil)
                return
            }
            let chat = ChatSession()
            if let id = value?["id"] as? String
            {
                chat.id = id
            }
            if let author = value?["author"] as? String
            {
                chat.author = author
            }
            if let message = value?["message"] as? String
            {
                chat.message = message
            }
            if let timestamp = value?["timestamp"] as? String
            {
                chat.timestamp = timestamp
            }
            if let userIds = value?["userIds"] as? [String]
            {
                chat.userIds = userIds
            }

            conversion.didConvertChatSession?(chat)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func convertToUsers(ref : DatabaseReference, conversion : UserConversion)
    {
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if !snapshot.exists()
            {
                conversion.didConvertUser?(nil)
                return
            }
            let value = snapshot.value as? NSDictionary
            let users = Users()
            if   let id = value?["id"] as? String
            {
                users.id = id
            }
            if let user = value?["username"] as? String
            {
                users.username = user
            }
            if let pass = value?["password"] as? String
            {
                users.password = pass
            }
            if let full = value?["full"] as? String
            {
                users.fullname = full
            }
            if let first = value?["first"] as? String
            {
                users.firstname = first
            }
            if let last = value?["last"] as? String
            {
                users.lastname = last
            }
            if let friendsId = value?["friendsId"] as? [String]
            {
                users.friendsId = friendsId
            }
            
            if let photoUrl = value?["photoUrl"] as? String
            {
                users.photoUrl = photoUrl
            }
            if let location = value?["location"] as? String
            {
                users.location = location
            }
            if let birthday = value?["birthday"] as? String
            {
                users.birthday = birthday
            }
            if let online = value?["online"] as? Bool
            {
                users.online = online
            }
            if let friendsInviteId = value?["friendsInviteId"] as? [String]
            {
                users.friendsInviteId = friendsInviteId
            }
            if let friendsRequestedId = value?["friendsRequestedId"] as? [String]
            {
                users.friendsRequestedId = friendsRequestedId
            }
            conversion.didConvertUser?(users)
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}
