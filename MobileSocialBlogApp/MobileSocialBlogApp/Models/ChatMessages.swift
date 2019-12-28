//
//  ChatMessages.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 01/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class ChatMessages: NSObject {
    var id : String?
    var message : String?
    var author : String?
    var timestamp : String?
    var timestamp_from : String?
    var replyTo : String?
    var userId : String?
    var msgId : Int?
    
    static func chatMessages() -> [ChatMessages]{
        var chatMessages = [ChatMessages]()
        for i in 0..<5{
            let message = ChatMessages()
            message.id = Constants.randomString(length: 22)
            message.userId = Constants.randomString(length: 22)
            message.author = Constants.randomString(length: 7)
            message.msgId = 0
            message.replyTo = Constants.randomString(length: 22)
            message.timestamp =  Date().toStringDisplay()
            message.timestamp_from =  Date().toStringDisplay()
            message.message = Constants.randomString(length: 300)
            chatMessages.append(message)
        }
        return chatMessages
    }
    
    static func convertToKeyVal(chat : ChatMessages) -> [String : Any]
    {
        var map = [String : Any]()
        if let id = chat.id
        {
            map["id"] = id
        }
        if let author = chat.author
        {
            map["author"] = author
        }
        if let message = chat.message
        {
            map["message"] = message
        }
        
        if let timestamp = chat.timestamp
        {
            map["timestamp"] = timestamp
        }
        if let timestamp = chat.timestamp_from
        {
            map["timestamp_from"] = timestamp
        }
        if let userId = chat.userId
        {
            map["userId"] = userId
        }
        if let replyTo = chat.replyTo
        {
            map["replyTo"] = replyTo
        }
        if let msgId = chat.msgId{
            map["msgId"] = msgId
        }
        return map
    }
}
