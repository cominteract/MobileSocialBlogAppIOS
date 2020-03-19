//
//  FeedDetailsPresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 29/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

/// FeedDetailsView protocol for updating the view in the view controllers
protocol FeedDetailsView: class {
    func updatedPostUpdateView()
    func addedCommentsUpdateView()
    func retrievedAllUpdateView()
}

/// FeedDetailsDelegate protocol for delegating implementations from the FeedDetailsServices
protocol FeedDetailsDelegate: class{
    func updatedPost()
    func addedComments()
    func retrievedAll()
}

/// FeedDetailsPresenter protocol for implementing the FeedDetailsPresenter
protocol FeedDetailsPresenter {
    func upvotePost(post: Posts, id : String)
    func downvotePost(post : Posts, id : String)
    func allComments() -> [Comments]?
    func allUsers() -> [Users]?
    func replyToComment(comment : Comments)
    func retrieveAll()
    func allowedToReply() -> Bool
    func sendComment(comment : Comments)
    func commentsFromPost(postId : String) -> [Comments]?
    func getUserFrom(username : String) -> Users?
}

/// FeedDetailsPresenter implementation based on the presenter protocol
class FeedDetailsPresenterImplementation : FeedDetailsPresenter, FeedDetailsDelegate {
    
    func replyToComment(comment: Comments) {
        sendComment(comment: comment)
    }
    
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
    
    func getUserFrom(username: String) -> Users? {
        return service.getUserFrom(username: username)
    }
    
    func commentsFromPost(postId : String) -> [Comments]?
    {
        return service.commentsFromPost(postId: postId)
    }
    
    func allComments() -> [Comments]? {
        return service.allComments
    }
    
    func allUsers() -> [Users]? {
        return service.allUsers
    }
    
    func retrieveAll() {
        service.retrieveAllUsers()
        service.retrieveAllComments()
        service.retrieveAllPosts()
    }
    
    func allowedToReply() -> Bool {
        return service.allowedReply
    }
    
    func sendComment(comment: Comments) {
        service.addCommentsToApi(comment: comment)
    }
    
    func addedComments() {
        view?.addedCommentsUpdateView()
    }
    
    func retrievedAll() {
        view?.retrievedAllUpdateView()
    }
    
    


    /// FeedDetailsView reference of the FeedDetailsViewController as FeedDetailsView type. Must be weak
    fileprivate weak var view: FeedDetailsView?
    
    /// FeedDetailsServices property to set the services used by the presenter
    var service : FeedDetailsServices!
    
    /// initializes with the FeedDetailsViewController as the FeedDetailsView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: FeedDetailsViewController as the FeedDetailsView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : FeedDetailsView,
         apiManager : APIManager, authManager : AuthManager) {
        service = FeedDetailsServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
}
