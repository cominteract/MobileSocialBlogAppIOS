//
//  AuthProtocol.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//



/// AuthProtocol which is the template used in authentication implementations with the mock auth manager or the auth manager from the backend
protocol AuthProtocol : class {
    

    /// isLogged checks whether the user is logged or not
    ///
    /// - Returns: as Bool to identify if user is logged
    func isLogged() -> Bool
}
