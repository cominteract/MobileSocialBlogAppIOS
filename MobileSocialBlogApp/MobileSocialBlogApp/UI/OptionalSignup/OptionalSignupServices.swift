//
//  OptionalSignupServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation

/// OptionalSignupServices class for implementing the services needed for the presenter
class OptionalSignupServices: NSObject {

    /// delegate for the implementation of the template generated OptionalSignupServices
    weak var delegate : OptionalSignupDelegate?
    
    var allUsers : [Users]?
    
    var allowedToUpdate = false
    /// apiManager used in consuming the api related to data whether mock or from aws to be initialized
    var apiManager : APIManager
    
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
    
    func retrieveAllUsers(){
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
            self?.allowedToUpdate = true
            self?.delegate?.retrievedAll()
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
    
    func usernameExists(username : String) -> Bool{
        if let allUsers = allUsers?.filter({ $0.username == username }), allUsers.count > 0{
            return true
        }
        return false
    }
    
    func updateUser(aUser : Users, toUpload : Bool)
    {
        addUserToApi(aUser: aUser, toUpload: toUpload)
    }
    
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
        if let url = aUser.photoUrl, let id = aUser.id, !url.contains(Constants.firebaseurl),
            !url.contains(Constants.defaultuserurl), toUpload{
            url.downloadImage(completion: { [weak self](data) in
                self?.apiManager.uploadImage(data: data, imageName: "img_\(id)") { [weak self] (err, msg) in
                    if err != nil{
                        
                    }else{
                        self?.delegate?.uploadedImage()
                    }
                }
            })
        }
        apiManager.addUser( keyval: Users.convertToKeyVal(users: aUser), withCompletion: {
            [weak self] (err, message) in
            if err != nil{
                return
            }
            self?.delegate?.updatedUser()
        })
    }
    
    func uploadImage(data : Data){
        if let username = Config.getUser(), let user = getUserFrom(username: username), let id = user.id{
            apiManager.uploadImage(data: data, imageName: "img_\(id)") { [weak self] (err, msg) in
                if err != nil{
                    
                }else{
                    self?.delegate?.uploadedImage()
                }
            }
        }
    }
    
    func getUserFrom(username : String) -> Users?
    {
        if let filtered = allUsers?.filter({ $0.username == username }), filtered.count > 0{
            return filtered[0]
        }
        return nil
    }
}
