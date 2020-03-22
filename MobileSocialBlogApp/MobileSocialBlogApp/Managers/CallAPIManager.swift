//
//  CallAPIManager.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 22/03/2020.
//  Copyright © 2020 Andre Insigne. All rights reserved.
//

import UIKit
import Firebase
class CallAPIManager: NSObject {
    var ref: DatabaseReference!
    override init() {
        ref = Database.database().reference()
    }
    func addCall(keyval : [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void){
        if keyval.keys.contains("callerName") && keyval.keys.contains("calledName"){

            ref.child(Constants.calls).child(keyval["conferenceName"] as! String).setValue(keyval){ (err, dref) in
                withCompletion(err,"Successfully called \(keyval["calledName"] ?? "")")
            }
        }
    }
    
    func retrieveIncomingCall(userId : String, callsRetrieved : CallsRetrieved){
        
        ref.child(Constants.calls).observe(DataEventType.value, with: { (snapshot) in
            if let values = snapshot.value as? NSDictionary{
                let callRecords = Conversions.convertToAllCalls(values: values)
                if !callRecords.isEmpty {
                    var callsForUser = callRecords.filter({ $0.calledId == userId && $0.callstate == Constants.CALLSTARTED})
                    var callsEnded = callRecords.filter({ $0.endedId == userId && $0.callstate == Constants.CALLENDED })
                    if !callsForUser.isEmpty{
                        print(" A call retrieval ")
                        callsRetrieved.retrievedCalls?(callsForUser.first)
                    }
                    if !callsEnded.isEmpty{
                        print(" A call ended ")
                        callsRetrieved.endedCalls?(callsEnded.first)
                    }
                }
            }
        })
        
    }
}
