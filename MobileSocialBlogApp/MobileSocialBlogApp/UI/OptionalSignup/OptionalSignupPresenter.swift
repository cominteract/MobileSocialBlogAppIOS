//
//  OptionalSignupPresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//
import UIKit
/// OptionalSignupView protocol for updating the view in the view controllers
protocol OptionalSignupView: class {
    func updatedUserUpdateView()
    func uploadedImageUpdateView()
    func retrievedAllUpdateView()
}

/// OptionalSignupDelegate protocol for delegating implementations from the OptionalSignupServices
protocol OptionalSignupDelegate: class{
    func updatedUser()
    func uploadedImage()
    func retrievedAll()
}

/// OptionalSignupPresenter protocol for implementing the OptionalSignupPresenter
protocol OptionalSignupPresenter {
    func updateUser(user : Users, toUpload : Bool)
    func uploadImage(data : Data)
    func retrieveAll()
}

/// OptionalSignupPresenter implementation based on the presenter protocol
class OptionalSignupPresenterImplementation : OptionalSignupPresenter, OptionalSignupDelegate {
    func retrievedAll() {
        view?.retrievedAllUpdateView()
    }
    
    func uploadedImage() {
        view?.uploadedImageUpdateView()
    }
    

    func uploadImage(data: Data) {
        service.uploadImage(data: data)
    }
    
    func updateUser(user: Users, toUpload: Bool) {
        service.addUserToApi(aUser: user, toUpload: toUpload)
    }

    func retrieveAll() {
        service.retrieveAllUsers()
    }
    
    func updatedUser() {
        view?.updatedUserUpdateView()
    }
    
    


    /// OptionalSignupView reference of the OptionalSignupViewController as OptionalSignupView type. Must be weak
    fileprivate weak var view: OptionalSignupView?
    
    /// OptionalSignupServices property to set the services used by the presenter
    var service : OptionalSignupServices!
    
    /// initializes with the OptionalSignupViewController as the OptionalSignupView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: OptionalSignupViewController as the OptionalSignupView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : OptionalSignupView,
         apiManager : APIManager, authManager : AuthManager) {
        service = OptionalSignupServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
}
