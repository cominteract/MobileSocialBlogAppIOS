//
//  SignupPresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

/// SignupView protocol for updating the view in the view controllers
protocol SignupView: class {
  func addedUserUpdateView()
}

/// SignupDelegate protocol for delegating implementations from the SignupServices
protocol SignupDelegate: class{
    func addedUser()
}

/// SignupPresenter protocol for implementing the SignupPresenter
protocol SignupPresenter {
    func signupUser(user : Users)
    func passwordCorrect(username : String, password : String) -> Bool
    func usernameExists(username : String) -> Bool
    func retrieveAll()
    func getUserFrom(username : String) -> Users?
}

/// SignupPresenter implementation based on the presenter protocol
class SignupPresenterImplementation : SignupPresenter, SignupDelegate {
 
   
    /// SignupView reference of the SignupViewController as SignupView type. Must be weak
    fileprivate weak var view: SignupView?
    
    /// SignupServices property to set the services used by the presenter
    var service : SignupServices!
    
    /// initializes with the SignupViewController as the SignupView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: SignupViewController as the SignupView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : SignupView,
         apiManager : APIManager, authManager : AuthManager) {
        service = SignupServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
    
    func signupUser(user: Users) {
        service.addUserToApi(aUser: user, toUpload: true)
    }
    
    func usernameExists(username: String) -> Bool {
        return service.usernameExists(username:username)
    }
    
    func passwordCorrect(username : String, password : String) -> Bool{
        return service.passwordCorrect(username: username, password: password)
    }
    
    func addedUser() {
        view?.addedUserUpdateView()
    }
    
    func retrieveAll() {
        service.retrieveAllUsers()
    }
    
    
    
    func getUserFrom(username : String) -> Users?
    {
        return service.getUserFrom(username: username)
    }
    
}
