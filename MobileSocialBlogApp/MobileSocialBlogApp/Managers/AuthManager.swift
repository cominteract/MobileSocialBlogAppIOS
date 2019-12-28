//
//  AuthManager.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

/// ErrorAuth which is the parent class to return the error from the auth through closure callback
class ErrorAuth{
    var didEncounterError : ((Error, Bool) -> ())?
}
class AuthManager: AuthProtocol {
    

    /// isLogged checks whether the user is logged or not
    ///
    /// - Returns: as Bool to identify if user is logged
    func isLogged() -> Bool
    {
        return false
    }
}
