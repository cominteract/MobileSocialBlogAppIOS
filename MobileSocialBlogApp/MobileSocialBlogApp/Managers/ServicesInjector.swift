//
//  ServicesInjector.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit


/// Injects the type of services depending on the target selected
class ServicesInjector: NSObject {
    #if DEV
    let auth = FirebaseAuthManager()
    #elseif PROD
    let auth = FirebaseAuthManager()
    #elseif MOCK
    let auth = MockAuthManager()
    #else
    let auth = MockAuthManager()
    #endif
    
    #if DEV
    let manager = FirebaseAPIManager()
    #elseif PROD
    let manager = FirebaseAPIManager()
    #elseif MOCK
    let manager = MockAPIManager()
    #else
    let manager = MockAPIManager()
    #endif
    
    var data : APIData?
    
    init(data : APIData) {
        self.data = data
        #if DEV
        print("Alive")
        #elseif MOCK
        print("Dead 1")
        #elseif DEBUG
        print("Debug")
        #else
        print("Dead 2")
        #endif
    }
    func getAPI() -> APIManager
    {
        return manager
    }
    
    func getAuth() -> AuthManager
    {
        return auth
    }
}
