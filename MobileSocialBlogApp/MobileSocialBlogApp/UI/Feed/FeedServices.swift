//
//  FeedServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation





/// FeedServices class for implementing the services needed for the presenter
class FeedServices: NSObject {

    /// delegate for the implementation of the template generated FeedServices
    weak var delegate : FeedDelegate?
    
    var allowedComments : Bool = false
    
    var allowedReply : Bool = false
    
    var allowedPosts : Bool = false
    
    
    var allowedFriendRequest : Bool = false

    var allUsers : [Users]? {
        didSet{
            allowedComments = allPosts != nil
            allowedPosts = true
            allowedFriendRequest = true
        }
    }
    
    var alreadyAllowed = false
    
    var allComments : [Comments]? {
        didSet{
            allowedReply = true
        }
    }
    
    var allPosts : [Posts]? {
        didSet{
            allowedComments = allUsers != nil
        }
    }
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
    
    func getUserFrom(username : String) -> Users?{
        if let filtered = allUsers?.filter({ $0.username == username }), filtered.count > 0{
            return filtered[0]
        }
        return nil
    }
    
    func retrievedAll(){
        if allowedPosts{
            if let allUsers = allUsers {
                self.delegate?.retrievedAll()
                
            }
        }
    }
    
   
    
    func retrieveAllPosts(){
        let postsRetrieved = PostsRetrieved()
        postsRetrieved.didRetrievePosts = { [weak self] (posts : [Posts]? ,errorMessage : String?) in
            self?.allPosts = posts
            self?.retrievedAll()
            self?.listAllImages()
        }
        apiManager.retrieveAllPosts(postsRetrieved: postsRetrieved)
    }
    
    func retrieveAllComments(){
        let commentsRetrieved = CommentsRetrieved()
        commentsRetrieved.didRetrieveComments = { [weak self] (comments : [Comments]? ,errorMessage : String?) in
            self?.allComments = comments
            self?.retrievedAll()
        }
        apiManager.retrieveAllComments(commentsRetrieved: commentsRetrieved)
    }
    
    func retrieveAllUsers(){
        alreadyAllowed = false
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
            self?.retrievedAll()
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
    
    
    
    func addCommentsToApi(comment : Comments){
        if comment.id == nil{
            comment.id = Constants.randomString(length: 22)
            if let filtered = allComments?.filter({ $0.id == comment.id }), filtered.count > 0{
                comment.id = Constants.randomString(length: 22)
            }
        }
        if comment.author == nil || comment.userId == nil || comment.commentedTo == nil || comment.message == nil{
            print(" Can't send comment missing fields ")
            return
        }
        apiManager.addComments(keyval: Comments.convertToKeyVal(comment: comment)) { [weak self] (err, message) in
            if err != nil{
                return
            }
            self?.delegate?.addedComments()
        }
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

        })
    }
    
    func addPostsToApi(posts : Posts, toUpload : Bool){
        if posts.id == nil{
            posts.id = Constants.randomString(length: 22)
            if let filtered = allPosts?.filter({ $0.id == posts.id }), filtered.count > 0{
                posts.id = Constants.randomString(length: 22)
            }
        }
        if posts.author == nil || posts.userId == nil || posts.title == nil{
            print(" Can't send post missing fields ")
            return
        }
        if let url = posts.url, !url.contains(Constants.firebaseurl),
            !url.contains(Constants.defaultposturl),toUpload{
            url.downloadImage(completion: { [weak self](data) in
                self?.apiManager.uploadImage(data: data, imageName: "img_\(posts.id!)"){ [weak self] (err, msg) in
                    if err != nil{
                        
                    }else{
                        self?.delegate?.uploadedImage()
                    }
                }
            })
        }
        apiManager.addPosts(keyval: Posts.convertToKeyVal(post: posts), withCompletion: { [weak self] (err, message) in
            if err != nil{
                return
            }
            self?.delegate?.addedPost()
        })
    }
    
    func commentsFromPost(postId : String) -> [Comments]?{
        if let allComments = allComments{
            let filtered = allComments.filter({ $0.commentedTo == postId })
            return filtered
        }
        return allComments
    }
    
    func uploadPostImage(data : Data, postId : String){
       apiManager.uploadImage(data: data, imageName: "img_\(postId)"){ [weak self] (err, msg) in
                if err != nil{
                    
                }else{
                    self?.delegate?.uploadedImage()
                }
        }
    }
    
    func uploadImage(data : Data, username : String){
        if let user = getUserFrom(username: username), let id = user.id{
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
    
    func listAllImages(){
        let referencesRetrieved = ReferencesRetrieved()
        if let allPosts = allPosts, postsNotUploaded(){
            let filteredPosts = allPosts.filter({ $0.url != nil
                && !$0.url!.contains(Constants.firebaseurl)
                && !$0.url!.contains(Constants.defaultposturl) })
            referencesRetrieved.didRetrievePostImages = { [weak self] (posts : [Posts]?) in
                if let posts = posts{
                    for post in posts{
                        self?.addPostsToApi(posts: post, toUpload: true)
                    }
                }
            }
            apiManager.listImagesForPosts(posts: filteredPosts, referencesRetrieved: referencesRetrieved)
        }
        if let allUsers = allUsers, usersNotUploaded(){
            let filteredUsers = allUsers.filter({ $0.photoUrl != nil
                && !$0.photoUrl!.contains(Constants.firebaseurl)
                && !$0.photoUrl!.contains(Constants.defaultuserurl) })
            referencesRetrieved.didRetrieveUserImages = { [weak self] (users : [Users]?) in
                if let users = users{
                    for user in users{
                        self?.addUserToApi(aUser: user, toUpload: true)
                    }
                }
            }
            apiManager.listImagesForUsers(users: filteredUsers, referencesRetrieved: referencesRetrieved)
        }
    }
    
    func usersNotUploaded() -> Bool{
        if let allUsers = allUsers, allUsers.filter({ $0.photoUrl != nil
            && !$0.photoUrl!.contains(Constants.firebaseurl)
            && !$0.photoUrl!.contains(Constants.defaultuserurl) }).count > 0{
            return true
        }
        return false
    }
    
    func postsNotUploaded() -> Bool{
        if let allPosts = allPosts, allPosts.filter({ $0.url != nil
            && !$0.url!.contains(Constants.firebaseurl)
            && !$0.url!.contains(Constants.defaultposturl) }).count > 0{
            return true
        }
        return false
    }
}
