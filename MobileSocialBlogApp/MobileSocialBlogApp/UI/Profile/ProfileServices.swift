//
//  ProfileServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation

/// ProfileServices class for implementing the services needed for the presenter
class ProfileServices: NSObject {

    /// delegate for the implementation of the template generated ProfileServices
    weak var delegate : ProfileDelegate?
    
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
    
    var allowedFriendRequest = false
    
    var allUsers : [Users]? {
        didSet{
            allowedFriendRequest = true
        }
    }
    
    var allComments : [Comments]?
    
    var allPosts : [Posts]?
    
    var isPostsAllowed  = false
    
    var isCommentsAllowed  = false
    
    func retrievedAll(){
        if allowedFriendRequest{
            if allUsers != nil, isCommentsAllowed, isPostsAllowed  {
                self.delegate?.retrievedAll()
            }
        }
    }
    
    func retrieveAllPosts(){
        let postsRetrieved = PostsRetrieved()
        postsRetrieved.didRetrievePosts = { [weak self] (posts : [Posts]? ,errorMessage : String?) in
            self?.allPosts = posts
            self?.isPostsAllowed = true
            self?.retrievedAll()

        }
        apiManager.retrieveAllPosts(postsRetrieved: postsRetrieved)
    }
    
    func retrieveAllComments(){
        let commentsRetrieved = CommentsRetrieved()
        commentsRetrieved.didRetrieveComments = { [weak self] (comments : [Comments]? ,errorMessage : String?) in
            self?.allComments = comments
            self?.isCommentsAllowed = true
            self?.retrievedAll()
        }
        apiManager.retrieveAllComments(commentsRetrieved: commentsRetrieved)
    }
    
    
    func retrieveAllUsers(){
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
            
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
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
        if let url = aUser.photoUrl, !url.contains(Constants.firebaseurl),
            !url.contains(Constants.defaultuserurl), toUpload{
            url.downloadImage(completion: { [weak self](data) in
                self?.apiManager.uploadImage(data: data, imageName: "img_\(aUser.id!)", withCompletion: { [weak self] (err, msg) in
                    if err != nil{
                        
                    }else{
                        self?.delegate?.uploadedImage()
                    }
                })  
            })
        }
        apiManager.addUser( keyval: Users.convertToKeyVal(users: aUser), withCompletion: {
            [weak self] (err, message) in
            if err != nil{
                return
            }
            self?.delegate?.addedUser()
        })
    }
    
    func commentsFromPost(postId : String) -> [Comments]?{
        if let allComments = allComments{
            let filtered = allComments.filter({ $0.commentedTo == postId })
            return filtered
        }
        return allComments
    }
    
    func getUserFrom(username : String) -> Users?{
        if let filtered = allUsers?.filter({ $0.username == username }), filtered.count > 0{
            return filtered[0]
        }
        return nil
    }
    
    func uploadImage(data : Data){
        if let username = Config.getUser(), let user = getUserFrom(username: username), let id = user.id{
            apiManager.uploadImage(data: data, imageName: "img_\(id)"){ [weak self] (err, msg) in
                if err != nil{
                    
                }else{
                    self?.delegate?.uploadedImage()
                }
            }
        }
    }
    
    func downloadImage(username : String){
        if let user = getUserFrom(username: username), let id = user.id{
            apiManager.downloadImage(imageName:  "img_\(id)") { [weak self] (err, img) in
                if let img = img{
                    self?.delegate?.downloadedImage(image: img)
                }
            }
        }
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
        else{
            if let userId = userId, let map = allUsers?.map({ $0.id }), map.contains(userId), allUsers?.filter({ $0.id == userId }) != nil, let filtered = allUsers?.filter({ $0.id == userId }), filtered.count > 0{
                aUser = filtered[0]
                aUser.photoUrl = "https://alumni.crg.eu/sites/default/files/default_images/default-picture_0_0.png"
                if let photoUrl = photoUrl{
                    aUser.photoUrl = photoUrl
                }
                self.addUserToApi(aUser: aUser, toUpload : true)
            }
            else{
                aUser.firstname = Constants.randomString(length: 6)
                aUser.lastname = Constants.randomString(length: 6)
                aUser.id = Constants.randomString(length: 22)
                aUser.fullname = "\(aUser.firstname!) \(aUser.lastname!)"
                aUser.password = Constants.randomString(length: 16)
                aUser.friendsId = [String]()
                aUser.photoUrl = "https://alumni.crg.eu/sites/default/files/default_images/default-picture_0_0.png"
                if let photoUrl = photoUrl{
                    aUser.photoUrl = photoUrl
                }
                aUser.username = Constants.randomString(length: 10)
                aUser.timestampCreated = Date().toString()
                let userConversion = UserConversion()
                userConversion.didConvertUser = { [weak self] (user : Users?) in
                    if user == nil{
                        self?.addUserToApi(aUser: aUser, toUpload : true)
                    }else{
                        aUser.id = Constants.randomString(length: 22)
                        self?.addUserToApi(aUser: aUser, toUpload : true)
                    }
                }
                apiManager.getUser(username: aUser.username!, userConversion: userConversion)
            }
        }
    }
}
