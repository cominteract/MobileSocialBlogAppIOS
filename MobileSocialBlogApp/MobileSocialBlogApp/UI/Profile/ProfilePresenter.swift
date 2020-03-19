//
//  ProfilePresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//
import UIKit
/// ProfileView protocol for updating the view in the view controllers
protocol ProfileView: class {
    func retrievedAllUpdateView()
    func addedUserUpdateView()
    func downloadedImageUpdateView(image : UIImage)
    func uploadedImageUpdateView()
    func updatedPostUpdateView()
}

/// ProfileDelegate protocol for delegating implementations from the ProfileServices
protocol ProfileDelegate: class{
    func retrievedAll()
    func addedUser()
    func downloadedImage(image : UIImage)
    func updatedPost()
    func uploadedImage()
}

/// ProfilePresenter protocol for implementing the ProfilePresenter
protocol ProfilePresenter {
    func upvotePost(post: Posts, id : String)
    func downvotePost(post : Posts, id : String)
    func getUserFrom(username : String) -> Users?
    func retrieveAll()
    func allPosts() -> [Posts]?
    func allUsers() -> [Users]?
    func allComments() -> [Comments]?
    func addFriend(photoUrl : String? , friendId : String?, userId : String?)
    func updateUser(user: Users, toUpload: Bool)
    func downloadImage(username : String)
    func uploadImage(data : Data)
    func commentsFromPost(postId : String) -> [Comments]?
}

/// ProfilePresenter implementation based on the presenter protocol
class ProfilePresenterImplementation : ProfilePresenter, ProfileDelegate {
  
    func updatedPost() {
        view?.updatedPostUpdateView()
    }
    
    func upvotePost(post: Posts, id: String) {
        if let upvotesId = post.upvotedId, upvotesId.contains(id){
            post.upvotedId = upvotesId.filter({ $0 != id })
            post.upvotes = post.upvotes - 1
        }
        else{
            post.upvotes = post.upvotes + 1
            if let downvotesId = post.downvotedId, downvotesId.contains(id){
                post.downvotes = post.downvotes - 1
                post.downvotedId = downvotesId.filter({ $0 != id  })
            }
            if post.upvotedId == nil{
                post.upvotedId = [String]()
            }
            post.upvotedId?.append(id)
        }
        self.sendPost(posts: post)
    }
    func downvotePost(post: Posts, id: String) {
        if let downvotesId = post.downvotedId, downvotesId.contains(id){
            post.downvotedId = downvotesId.filter({ $0 != id })
            post.downvotes = post.downvotes - 1
        }
        else{
            post.downvotes = post.downvotes + 1
            if let upvotesId = post.upvotedId, upvotesId.contains(id){
                post.upvotes = post.upvotes - 1
                post.upvotedId = upvotesId.filter({ $0 != id  })
            }
            if post.downvotedId == nil{
                post.downvotedId = [String]()
            }
            post.downvotedId?.append(id)
        }
        self.sendPost(posts: post)
    }
    
    func sendPost(posts: Posts) {
        service.addPostsToApi(posts: posts, toUpload: true)
    }
    
    func retrieveAll() {
        service.retrieveAllPosts()
        service.retrieveAllUsers()
        service.retrieveAllComments()
    }
    

    func retrievedAll() {
        view?.retrievedAllUpdateView()
    }
    
    func allPosts() -> [Posts]? {
        return service.allPosts
    }
    
    func allUsers() -> [Users]? {
        return service.allUsers
    }
    
    func allComments() -> [Comments]? {
        return service.allComments
    }
    
    func uploadedImage() {
        view?.uploadedImageUpdateView()
    }
    
    func uploadImage(data : Data) {
        service.uploadImage(data: data)
    }
    
    func downloadedImage(image: UIImage) {
        view?.downloadedImageUpdateView(image: image)
    }
    
    func downloadImage(username: String) {
        service.downloadImage(username: username)
    }
    
    func addedUser() {
        view?.addedUserUpdateView()
    }
    
    func getUserFrom(username: String) -> Users? {
        return service.getUserFrom(username: username)
    }
    
    func updateUser(user: Users, toUpload: Bool) {
        service.addUserToApi(aUser: user, toUpload: toUpload)
    }
    
    func addFriend(photoUrl : String? , friendId : String?, userId : String?) {
        service.addUser(photoUrl: photoUrl, friendsId: friendId, userId: userId)
    }
    
    func commentsFromPost(postId : String) -> [Comments]?
    {
        return service.commentsFromPost(postId: postId)
    }
 
    
    /// ProfileView reference of the ProfileViewController as ProfileView type. Must be weak
    fileprivate weak var view: ProfileView?
    
    /// ProfileServices property to set the services used by the presenter
    var service : ProfileServices!
    
    /// initializes with the ProfileViewController as the ProfileView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: ProfileViewController as the ProfileView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : ProfileView,
         apiManager : APIManager, authManager : AuthManager) {
        service = ProfileServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
}
