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

    
    func isAlreadyFriend(bUser : Users) -> Bool
    func isAlreadyRequested(bUser : Users) -> Bool
    func isAlreadyInvited(bUser : Users) -> Bool
}

/// DiscoverDelegate protocol for delegating implementations from the DiscoverServices
protocol DiscoverDelegate: class{

    func retrievedAll()
    func updatedUsers()
}

/// DiscoverPresenter protocol for implementing the DiscoverPresenter
protocol DiscoverPresenter {
    func updateUsers(aUser : Users, bUser : Users)
    func cancelFriend(aUser : Users, bUser : Users)
    func acceptFriend(aUser : Users, bUser : Users)
    func addFriend(aUser : Users, bUser : Users)
    func retrieveAll()
    func allUsers() -> [Users]?
    func getUserFrom(username : String) -> Users?
}

/// DiscoverPresenter implementation based on the presenter protocol
class DiscoverPresenterImplementation : DiscoverPresenter, DiscoverDelegate {
    func cancelFriend(aUser: Users, bUser: Users) {
        aUser.friendsInviteId = aUser.friendsInviteId?.filter( { $0 != bUser.id } )
        aUser.friendsRequestedId = aUser.friendsRequestedId?.filter( { $0 != bUser.id } )
        bUser.friendsInviteId = bUser.friendsInviteId?.filter( { $0 != aUser.id } )
        bUser.friendsRequestedId = bUser.friendsRequestedId?.filter( { $0 != aUser.id } )
        updateUsers(aUser: aUser, bUser: bUser)
    }
    
    func acceptFriend(aUser: Users, bUser: Users) {
        aUser.friendsInviteId = aUser.friendsInviteId?.filter( { $0 != bUser.id } )
        aUser.friendsRequestedId = aUser.friendsRequestedId?.filter( { $0 != bUser.id } )
        bUser.friendsInviteId = bUser.friendsInviteId?.filter( { $0 != aUser.id } )
        bUser.friendsRequestedId = bUser.friendsRequestedId?.filter( { $0 != aUser.id } )
        if aUser.friendsId == nil{
            aUser.friendsId = [String]()
        }
        if bUser.friendsId == nil{
            bUser.friendsId = [String]()
        }
        if let aId = aUser.id, let bId = bUser.id{
            aUser.friendsId?.append(bId)
            bUser.friendsId?.append(aId)
            updateUsers(aUser: aUser, bUser: bUser)
        }
    }
    
    func addFriend(aUser: Users, bUser: Users) {
        if let aId = aUser.id, let bId = bUser.id{
            if aUser.friendsRequestedId != nil{
                aUser.friendsRequestedId?.append(bId)
            }
            if bUser.friendsInviteId != nil{
                bUser.friendsInviteId?.append(aId)
            }
            if aUser.friendsRequestedId == nil{
                aUser.friendsRequestedId = [String]()
                aUser.friendsRequestedId?.append(bId)
            }
            if bUser.friendsInviteId == nil{
                bUser.friendsInviteId = [String]()
                bUser.friendsInviteId?.append(aId)
            }
            updateUsers(aUser: aUser, bUser: bUser)
        }
    }
    
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
