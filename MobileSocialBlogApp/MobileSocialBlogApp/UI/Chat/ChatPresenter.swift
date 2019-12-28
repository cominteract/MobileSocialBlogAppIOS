//
//  ChatPresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

/// ChatView protocol for updating the view in the view controllers
protocol ChatView: class {
    func retrievedAllUpdateView()
}

/// ChatDelegate protocol for delegating implementations from the ChatServices
protocol ChatDelegate: class{
    func retrievedAll()
    
}

/// ChatPresenter protocol for implementing the ChatPresenter
protocol ChatPresenter {
    func allUsers() -> [Users]?
    func allSessions() -> [ChatSession]?
    func retrieveAll()
    func getUserFrom(username : String) -> Users?
}

/// ChatPresenter implementation based on the presenter protocol
class ChatPresenterImplementation : ChatPresenter, ChatDelegate {
    func getUserFrom(username: String) -> Users? {
        return service.getUserFrom(username: username)
    }
    
    func allUsers() -> [Users]? {
        return service.allUsers
    }
    
  
    func allSessions() -> [ChatSession]? {
        return service.allChats
    }
    
    func retrieveAll() {
        service.retrieveAllUsers()
        service.retrieveAllChatSessions()
    }
    
    func retrievedAll() {
        view?.retrievedAllUpdateView()
    }
    
    


    /// ChatView reference of the ChatViewController as ChatView type. Must be weak
    fileprivate weak var view: ChatView?
    
    /// ChatServices property to set the services used by the presenter
    var service : ChatServices!
    
    /// initializes with the ChatViewController as the ChatView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: ChatViewController as the ChatView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : ChatView,
         apiManager : APIManager, authManager : AuthManager) {
        service = ChatServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
}
