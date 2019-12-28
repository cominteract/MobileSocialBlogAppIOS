//
//  SamplePresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

/// SampleView protocol for updating the view in the view controllers
protocol SampleView: class {
    func addedUserUpdateView()
    func addedPostUpdateView()
    func addedCommentsUpdateView()
}

/// SampleDelegate protocol for delegating implementations from the SampleServices
protocol SampleDelegate: class{
    func addedUser()
    func addedPost()
    func addedComments()
}

/// SamplePresenter protocol for implementing the SamplePresenter
protocol SamplePresenter {
    func addUser(friendsId : String? , userId : String?, photoUrl : String?)
    func addPost(userId : String?, url : String?)
    func addComment(replyTo : String?)
    
    func signupUser(user : Users)
    func sendPost(posts : Posts)
    func sendComment(comment : Comments)
    
    func usernameExists(username : String) -> Bool
    
    func retrieveAll()
    func allowedToPost() -> Bool
    func allowedToComment() -> Bool
    func allowedToFriend() -> Bool
    func isAlreadyFriend(friendsId : String? , userId : String?) -> Bool
}

/// SamplePresenter implementation based on the presenter protocol
class SamplePresenterImplementation : SamplePresenter, SampleDelegate {

    

    /// SampleView reference of the SampleViewController as SampleView type. Must be weak
    fileprivate weak var view: SampleView?
    
    /// SampleServices property to set the services used by the presenter
    var service : SampleServices!
    
    /// initializes with the SampleViewController as the SampleView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: SampleViewController as the SampleView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : SampleView,
         apiManager : APIManager, authManager : AuthManager) {
        service = SampleServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
    
    func addUser(friendsId : String? , userId : String?, photoUrl : String?) {
        service.addUser(photoUrl: photoUrl, friendsId: friendsId, userId: userId)
    }
    
    func addedUser() {
        view?.addedUserUpdateView()
    }
    
    func signupUser(user: Users) {
        service.addUserToApi(aUser: user, toUpload: true)
    }
    
    func sendComment(comment: Comments) {
        service.addCommentsToApi(comment: comment)
    }
    
    func sendPost(posts: Posts) {
        service.addPostsToApi(posts: posts, toUpload: true)
    }
    
    func addedComments() {
        view?.addedCommentsUpdateView()
    }
    
    func addComment(replyTo : String?) {
        service.addComments(replyTo: replyTo)
    }
    
    func addedPost() {
        view?.addedPostUpdateView()
    }
    
    func addPost(userId : String?, url : String?) {
        service.addPosts(userId : userId, url : url)
    }
    
    func retrieveAll() {
        service.retrieveAllPosts()
        service.retrieveAllUsers()
        service.retrieveAllComments()
    }
    
    func allowedToPost() -> Bool
    {
        return service.allowedPosts
    }
    func allowedToComment() -> Bool
    {
        return service.allowedComments
    }
    
    func allowedToFriend() -> Bool {
        return service.allowedFriendRequest
    }
    
    func isAlreadyFriend(friendsId : String? , userId : String?) -> Bool {
        return service.isAlreadyFriend(friendsId: friendsId, userId: userId)
    }
    
    func usernameExists(username: String) -> Bool {
        return service.usernameExists(username:username)
    }
}
