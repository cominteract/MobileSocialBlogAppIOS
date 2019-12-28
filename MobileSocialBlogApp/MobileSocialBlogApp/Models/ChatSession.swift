//
//  ChatMessages.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 01/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class ChatSession: NSObject {
    var id : String?
    var message : String?
    var timestamp : String?
    var userIds : [String]?
    var author : String?
    
    static func chatSessions() -> [ChatSession]{
        var chatSessions = [ChatSession]()
        for i in 0..<5{
            let session = ChatSession()
            session.id = Constants.randomString(length: 22)
            session.userIds = [String]()
            session.userIds?.append(Constants.randomString(length: 22))
            session.userIds?.append(Constants.randomString(length: 22))
            session.author = Constants.randomString(length: 7)
            session.timestamp =  Date().toStringDisplay()
            session.message  = Constants.randomString(length: 300)
            chatSessions.append(session)
        }
        return chatSessions
    }
    
    static func convertToKeyVal(chat : ChatSession) -> [String : Any]
    {
        var map = [String : Any]()
        if let id = chat.id
        {
            map["id"] = id
        }
        if let message = chat.message
        {
            map["message"] = message
        }
        if let timestamp = chat.timestamp
        {
            map["timestamp"] = timestamp
        }
        if let userIds = chat.userIds
        {
            map["userIds"] = userIds
        }
        if let author = chat.author
        {
            map["author"] = author
        }
        return map
    }
}
