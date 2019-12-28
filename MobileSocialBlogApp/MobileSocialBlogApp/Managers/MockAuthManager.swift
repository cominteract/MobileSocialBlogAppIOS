//
//  MockAuthManager.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class MockAuthManager: AuthManager {

    
    /// isLogged checks whether the user is logged or not
    ///
    /// - Returns: as Bool to identify if user is logged
    override func isLogged() -> Bool
    {
        return false
    }
    
}
