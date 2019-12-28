//
//  DiscoverPresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

/// DiscoverView protocol for updating the view in the view controllers
protocol DiscoverView: class {
    func updatedUsersUpdateView()
    func retrievedAllUpdateView()
}

/// DiscoverDelegate protocol for delegating implementations from the DiscoverServices
protocol DiscoverDelegate: class{

    func retrievedAll()
    func updatedUsers()
}

/// DiscoverPresenter protocol for implementing the DiscoverPresenter
protocol DiscoverPresenter {
    func updateUsers(aUser : Users, bUser : Users)
    func retrieveAll()
    func allUsers() -> [Users]?
    func getUserFrom(username : String) -> Users?
}

/// DiscoverPresenter implementation based on the presenter protocol
class DiscoverPresenterImplementation : DiscoverPresenter, DiscoverDelegate {
    func updateUsers(aUser: Users ,bUser: Users) {
        service.addUserToApi(aUser: aUser, toUpload: false)
        service.addUserToApi(aUser: bUser, toUpload: false)
    }
    
    func updatedUsers() {
        view?.updatedUsersUpdateView()
    }
    
    func retrievedAll() {
        view?.retrievedAllUpdateView()
    }
    
    func getUserFrom(username : String) -> Users?
    {
        return service.getUserFrom(username: username)
    }
    
    func allUsers() -> [Users]? {
        return service.allUsers
    }

    
    func retrieveAll() {
        service.retrieveAllUsers()
    }

    /// DiscoverView reference of the DiscoverViewController as DiscoverView type. Must be weak
    fileprivate weak var view: DiscoverView?
    
    /// DiscoverServices property to set the services used by the presenter
    var service : DiscoverServices!
    
    /// initializes with the DiscoverViewController as the DiscoverView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: DiscoverViewController as the DiscoverView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : DiscoverView,
         apiManager : APIManager, authManager : AuthManager) {
        service = DiscoverServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
}
