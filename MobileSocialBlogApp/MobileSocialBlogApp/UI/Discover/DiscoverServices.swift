//
//  DiscoverServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation





/// DiscoverServices class for implementing the services needed for the presenter
class DiscoverServices: NSObject {

    /// delegate for the implementation of the template generated DiscoverServices
    weak var delegate : DiscoverDelegate?
    
    /// apiManager used in consuming the api related to data whether mock or from aws to be initialized
    var apiManager : APIManager
    
    var allUsers : [Users]? 
    
    /// authManager used in consuming the authentication api whether mock or from aws to be initialized
    var authManager : AuthManager
    /// initializes with the apiManager used in consuming the api related to data whether mock or from aws and authManager used in consuming the authentication api whether mock or from aws
    ///
    /// - Parameters:
    ///   - apiManager: apiManager:  apiManager used in consuming the api related to data whether mock or from aws
    ///   - authManager: authManager:  authManager used in consuming the authentication api whether mock or from aws
    init(apiManager : APIManager, authManager : AuthManager) {
        self.apiManager = apiManager
        self.authManager = authManager
    }
    
    func getUserFrom(username : String) -> Users?{
        if let filtered = allUsers?.filter({ $0.username == username }), filtered.count > 0{
            return filtered[0]
        }
        return nil
    }
    
    func retrievedAll(){
        if let allUsers = allUsers {
            self.delegate?.retrievedAll()
        }
    }
    
    func retrieveAllUsers(){
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
            
            self?.retrievedAll()
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
    
    var userCount = 0
    
    func addUserToApi(aUser : Users, toUpload : Bool){
        if aUser.id == nil{
            aUser.id = Constants.randomString(length: 22)
            if let filtered = allUsers?.filter({ $0.id == aUser.id }), filtered.count > 0{
                aUser.id = Constants.randomString(length: 22)
            }
        }
        if aUser.username == nil || aUser.fullname == nil || aUser.password == nil{
            print(" Can't signup user missing fields ")
            return
        }
        if let url = aUser.photoUrl, !url.contains(Constants.firebaseurl),
            !url.contains(Constants.defaultuserurl), toUpload{
            url.downloadImage { [weak self](data) in
                self?.apiManager.uploadImage(data: data, imageName: "img_\(aUser.id!)", withCompletion: { (err, msg) in
                    
                })
            }
        }
        apiManager.addUser( keyval: Users.convertToKeyVal(users: aUser), withCompletion: {
            [weak self] (err, message) in
            if err != nil{
                return
            }
            self?.userCount += 1
            if self?.userCount == 2{
                self?.delegate?.updatedUsers()
                self?.userCount = 0
            }
        })
    }
    
    func addUser(photoUrl : String?, friendsId : String?, userId : String?){
        var aUser = Users()
        if let allUsers = self.allUsers, let userId = userId, let friendsId = friendsId, allUsers.filter({ $0.id == userId }).count > 0{
            aUser = allUsers.filter({ $0.id == userId })[0]
            if allUsers.filter({ $0.id == friendsId }).count > 0{
                let bUser = allUsers.filter({ $0.id == friendsId })[0]
                if aUser.friendsId == nil{
                    aUser.friendsId = [String]()
                }
                if bUser.friendsId == nil{
                    bUser.friendsId = [String]()
                }
                aUser.friendsId?.append(bUser.id!)
                bUser.friendsId?.append(aUser.id!)
                self.addUserToApi(aUser: aUser, toUpload : false)
                self.addUserToApi(aUser: bUser, toUpload : false)
            }
        }
    }
}
