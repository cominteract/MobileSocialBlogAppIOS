//
//  SampleServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation


/// SampleServices class for implementing the services needed for the presenter
class SampleServices: NSObject {

    /// delegate for the implementation of the template generated SampleServices
    weak var delegate : SampleDelegate?
    
    /// apiManager used in consuming the api related to data whether mock or from aws to be initialized
    var apiManager : APIManager
    
    var allowedComments : Bool = false
    
    var allowedPosts : Bool = false
    
    var allowedReply : Bool = false
    
    var allowedFriendRequest : Bool = false
    
    var allUsers : [Users]? {
        didSet{
            allowedComments = allPosts != nil
            allowedPosts = true
            allowedFriendRequest = true
        }
    }
    
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
    
    func randomString(length: Int) -> String {
        let letters = " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func isAlreadyFriend(friendsId : String?, userId : String?) -> Bool{
        if let allUsers = allUsers, let friendsId = friendsId, let userId = userId, allUsers.filter({ $0.id == userId}).count > 0, allUsers.filter({ $0.id == friendsId}).count > 0{
            let aUser = allUsers.filter({ $0.id == userId})[0]
            let bUser = allUsers.filter({ $0.id == friendsId})[0]
            let friended = aUser.friendsId != nil &&
                aUser.friendsId!.contains(friendsId) &&
                bUser.friendsId != nil &&
                bUser.friendsId!.contains(userId)
            return friended
        }
        return false
    }
    
    func addUserToApi(aUser : Users, toUpload : Bool){
        if aUser.id == nil{
            aUser.id = randomString(length: 22)
            if let filtered = allUsers?.filter({ $0.id == aUser.id }), filtered.count > 0{
                aUser.id = randomString(length: 22)
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
            self?.delegate?.addedUser()
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
                aUser.firstname = randomString(length: 6)
                aUser.lastname = randomString(length: 6)
                aUser.id = randomString(length: 22)
                aUser.fullname = "\(aUser.firstname!) \(aUser.lastname!)"
                aUser.password = randomString(length: 16)
                aUser.friendsId = [String]()
                aUser.photoUrl = "https://alumni.crg.eu/sites/default/files/default_images/default-picture_0_0.png"
                if let photoUrl = photoUrl{
                    aUser.photoUrl = photoUrl
                }
                aUser.username = randomString(length: 10)
                aUser.timestampCreated = Date().toString()
                let userConversion = UserConversion()
                userConversion.didConvertUser = { [weak self] (user : Users?) in
                    if user == nil{
                        self?.addUserToApi(aUser: aUser, toUpload : true)
                    }else{
                        aUser.id = self?.randomString(length: 22)
                        self?.addUserToApi(aUser: aUser, toUpload : true)
                    }
                }
                apiManager.getUser(username: aUser.username!, userConversion: userConversion)
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
    
    func retrieveAllUsers(){
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
    
    func retrieveAllPosts(){
        let postsRetrieved = PostsRetrieved()
        postsRetrieved.didRetrievePosts = { [weak self] (posts : [Posts]? ,errorMessage : String?) in
            self?.allPosts = posts
        }
        apiManager.retrieveAllPosts(postsRetrieved: postsRetrieved)
    }
    
    func retrieveAllComments(){
        let commentsRetrieved = CommentsRetrieved()
        commentsRetrieved.didRetrieveComments = { [weak self] (comments : [Comments]? ,errorMessage : String?) in
            self?.allComments = comments
        }
        apiManager.retrieveAllComments(commentsRetrieved: commentsRetrieved)
    }
    
    func addCommentsToApi(comment : Comments){
        if comment.id == nil{
            comment.id = randomString(length: 22)
            if let filtered = allComments?.filter({ $0.id == comment.id }), filtered.count > 0{
                comment.id = randomString(length: 22)
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
    
    func addComments(replyTo : String?){
        if allPosts == nil{
            let postsRetrieved = PostsRetrieved()
            postsRetrieved.didRetrievePosts = { [weak self] (posts : [Posts]? ,errorMessage : String?) in
                self?.allPosts = posts
                self?.addCommentsFromPosts(replyTo: replyTo)
            }
            apiManager.retrieveAllPosts(postsRetrieved: postsRetrieved)
        }
        else {
            self.addCommentsFromPosts(replyTo: replyTo)
        }
    }
    
    func addCommentsFromPosts(replyTo : String?)
    {
        if let allPosts = self.allPosts, let allUsers = self.allUsers,
            allPosts.count > 0, allUsers.count > 0, allowedComments{
            let rd = Int.random(in: 0..<allPosts.count)
            let r = Int.random(in: 0..<allUsers.count)
            let comment = Comments()
            comment.id = randomString(length: 22)
            if let filtered = allComments?.filter({ $0.id == comment.id }), filtered.count > 0{
                comment.id = randomString(length: 22)
            }
            comment.author = allUsers[r].username
            comment.commentedToPost = allPosts[rd]
            comment.commentedTo = allPosts[rd].id
            comment.timestamp = Date().toString()
            comment.timestamp_from = Date().fromNow()
            comment.downvotes = 0
            comment.upvotes = 0
            if let replyTo = replyTo, allowedReply, let allComments = self.allComments, allComments.filter({ $0.id == replyTo }).count > 0{
                comment.replyTo = replyTo
                comment.replyToComment = allComments.filter({ $0.id == replyTo })[0]
            }
        }
    }
    
    func addPostsToApi(posts : Posts, toUpload : Bool){
        if posts.id == nil{
            posts.id = randomString(length: 22)
            if let filtered = allPosts?.filter({ $0.id == posts.id }), filtered.count > 0{
                posts.id = randomString(length: 22)
            }
        }
        if posts.author == nil || posts.userId == nil || posts.title == nil{
            print(" Can't send post missing fields ")
            return
        }
        if let url = posts.url, !url.contains(Constants.firebaseurl),
            !url.contains(Constants.defaultposturl),toUpload{
            url.downloadImage { [weak self](data) in
                self?.apiManager.uploadImage(data: data, imageName: "img_\(posts.id!)", withCompletion: { (err, msg) in
                    
                })
            }
        }
        
        apiManager.addPosts(keyval: Posts.convertToKeyVal(post: posts), withCompletion: { [weak self] (err, message) in
            if err != nil{
                return
            }
            self?.delegate?.addedPost()
        })
    }
    
    func addPostsFromUsers(userId : String?, url : String?){
        if let allUsers = self.allUsers, allUsers.count > 0, allowedPosts{
            let rd = Int.random(in: 0..<allUsers.count)
            let posts = Posts()
            posts.id = randomString(length: 22)
            if let filtered = allPosts?.filter({ $0.id == posts.id }), filtered.count > 0{
                posts.id = randomString(length: 22)
            }
            if let userId = userId , allUsers.filter({ $0.id == userId }).count > 0{
                let user = allUsers.filter({ $0.id == userId })[0]
                posts.author = user.username
                posts.userId = user.id
            }
            else{
                posts.author = allUsers[rd].username
                posts.userId = allUsers[rd].id
            }
            posts.body = randomString(length: 250)
            posts.downvotes = 0
            posts.upvotes = 0
            posts.timestamp = Date().toString()
            posts.timestamp_from = Date().fromNow()
            posts.url = Constants.defaultposturl
            if let url = url{
                posts.url = url
            }
            addPostsToApi(posts: posts, toUpload: true)
        }
    }
    
    func addPosts(userId : String?, url : String?){
        if allUsers == nil{
            let usersRetrieved = UsersRetrieved()
            usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
                self?.allUsers = users
                self?.addPostsFromUsers(userId: userId, url: url)
            }
            apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
        }
        else {
            self.addPostsFromUsers(userId: userId, url: url)
        }
    }
    
    func usernameExists(username : String) -> Bool{
        if let allUsers = allUsers?.filter({ $0.username == username }), allUsers.count > 0{
            return true
        }
        return false
    }
}
