//
//  FeedPresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//
import UIKit
/// FeedView protocol for updating the view in the view controllers
protocol FeedView: class {
    func addedPostUpdateView()
    func addedCommentsUpdateView()
    func retrievedAllUpdateView()
    func downloadedImageUpdateView(image : UIImage)
    func uploadedImageUpdateView()
}

/// FeedDelegate protocol for delegating implementations from the FeedServices
protocol FeedDelegate: class{
    func addedPost()
    func addedComments()
    func retrievedAll()
    func downloadedImage(image : UIImage)
    func uploadedImage()
}

/// FeedPresenter protocol for implementing the FeedPresenter
protocol FeedPresenter {
    func retrieveAll()
    func allowedToPost() -> Bool
    func allowedToComment() -> Bool
    func allowedToReply() -> Bool
    func downloadImage(username : String)
    func allPosts() -> [Posts]?
    func allUsers() -> [Users]?
    func allComments() -> [Comments]?
    func getUserFrom(username : String) -> Users?
    func sendPost(posts : Posts)
  
    func uploadImage(data : Data, username : String)
    func uploadPostImage(data : Data, postId : String)
    func commentsFromPost(postId : String) -> [Comments]?
}

/// FeedPresenter implementation based on the presenter protocol
class FeedPresenterImplementation : FeedPresenter, FeedDelegate {
    
    func commentsFromPost(postId: String) -> [Comments]? {
        return service.commentsFromPost(postId: postId)
    }
    
    func uploadedImage() {
        view?.uploadedImageUpdateView()
    }
    
    func uploadPostImage(data : Data, postId : String){
        service.uploadPostImage(data: data, postId: postId)
    }
    
    func uploadImage(data: Data, username : String) {
        service.uploadImage(data: data, username: username)
    }
    
    func downloadImage(username: String) {
        service.downloadImage(username: username)
    }
    
    func downloadedImage(image: UIImage) {
        view?.downloadedImageUpdateView(image: image)
    }
    
    func retrievedAll() {
        view?.retrievedAllUpdateView()
    }
    
    
    func sendPost(posts: Posts) {
        service.addPostsToApi(posts: posts, toUpload: true)
    }
    
    func retrieveAll() {
        service.retrieveAllUsers()
        service.retrieveAllPosts()
        service.retrieveAllComments()
    }
    
    func allowedToPost() -> Bool {
        return service.allowedPosts
    }
    
    func allowedToComment() -> Bool {
        return service.allowedComments
    }
    
    func allowedToReply() -> Bool {
        return service.allowedReply
    }
    
    func addedPost() {
        view?.addedPostUpdateView()
    }
    
    func addedComments() {
        view?.addedCommentsUpdateView()
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


    /// FeedView reference of the FeedViewController as FeedView type. Must be weak
    fileprivate weak var view: FeedView?
    
    /// FeedServices property to set the services used by the presenter
    var service : FeedServices!
    
    /// initializes with the FeedViewController as the FeedView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: FeedViewController as the FeedView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : FeedView,
         apiManager : APIManager, authManager : AuthManager) {
        service = FeedServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
    
    func getUserFrom(username : String) -> Users?
    {
        return service.getUserFrom(username: username)
    }
}
