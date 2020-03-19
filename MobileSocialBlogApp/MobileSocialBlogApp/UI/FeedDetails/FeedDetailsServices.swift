//
//  FeedDetailsServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 29/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation





/// FeedDetailsServices class for implementing the services needed for the presenter
class FeedDetailsServices: NSObject {

    /// delegate for the implementation of the template generated FeedDetailsServices
    weak var delegate : FeedDetailsDelegate?
    
    /// apiManager used in consuming the api related to data whether mock or from aws to be initialized
    var apiManager : APIManager
    
    /// authManager used in consuming the authentication api whether mock or from aws to be initialized
    var authManager : AuthManager
    
    
    
    var allowedReply : Bool = false
    
    var allowedComments : Bool = false
    
    var allPosts : [Posts]? {
        didSet{
            allowedComments = allPosts != nil
        }
    }
    
    var allUsers : [Users]? {
        didSet{
            allowedReply = allComments != nil
        }
    }
    
    var allComments : [Comments]? {
        didSet{
            allowedReply = true
        }
    }
    
    /// initializes with the apiManager used in consuming the api related to data whether mock or from aws and authManager used in consuming the authentication api whether mock or from aws
    ///
    /// - Parameters:
    ///   - apiManager: apiManager:  apiManager used in consuming the api related to data whether mock or from aws
    ///   - authManager: authManager:  authManager used in consuming the authentication api whether mock or from aws
    init(apiManager : APIManager, authManager : AuthManager) {
        self.apiManager = apiManager
        self.authManager = authManager
    }
    
    func commentsFromPost(postId : String) -> [Comments]?
    {
        if let allComments = allComments{
            let filtered = allComments.filter({ $0.commentedTo == postId })
            return filtered
        }
        return allComments
    }
    
    func retrievedAll(){
        if allowedReply{
            if let allUsers = allUsers {
                self.delegate?.retrievedAll()
            }
        }
    }
    
    
    func getUserFrom(username : String) -> Users?{
        if let filtered = allUsers?.filter({ $0.username == username }), filtered.count > 0{
            return filtered[0]
        }
        return nil
    }
    
    
    func retrieveAllUsers(){
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
            self?.retrievedAll()
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
    
    func retrieveAllPosts(){
        let postsRetrieved = PostsRetrieved()
        postsRetrieved.didRetrievePosts = { [weak self] (posts : [Posts]? ,errorMessage : String?) in
            self?.allPosts = posts
            self?.retrievedAll()
          
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

        apiManager.addPosts(keyval: Posts.convertToKeyVal(post: posts), withCompletion: { [weak self] (err, message) in
            if err != nil{
                return
            }
            self?.delegate?.updatedPost()
        })
    }
    
}
