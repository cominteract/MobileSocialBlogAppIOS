//
//  CallRecords.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 22/03/2020.
//  Copyright © 2020 Andre Insigne. All rights reserved.
//

import UIKit

class CallRecords: NSObject {
    var id : String? 
    var callerId : String?
    var callerName : String?
    var calledId : String?
    var calledName : String?
    var conferenceName : String?
    var timestampStarted : String?
    var timestampEnded : String?
    var callstate : String?
    var endedId : String?
    static func convertToKeyVal(call : CallRecords) -> [String : Any]
    {
        var map = [String : Any]()
        if let id = call.id
        {
            map["id"] = id
        }
        if let callerId = call.callerId
        {
            map["callerId"] = callerId
        }
        if let callerName = call.callerName
        {
            map["callerName"] = callerName
        }
        if let calledId = call.calledId
        {
            map["calledId"] = calledId
        }
        if let calledName = call.calledName
        {
            map["calledName"] = calledName
        }
        if let conferenceName = call.conferenceName
        {
            map["conferenceName"] = conferenceName
        }
        if let callstate = call.callstate
        {
            map["callstate"] = callstate
        }
        if let timestampStarted = call.timestampStarted
        {
            map["timestampStarted"] = timestampStarted
        }
        if let timestampEnded = call.timestampEnded
        {
            map["timestampEnded"] = timestampEnded
        }
        if let endedId = call.endedId
        {
            map["endedId"] = endedId
        }
        return map
    }
}
