//
//  ChatServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation





/// ChatServices class for implementing the services needed for the presenter
class ChatServices: NSObject {

    /// delegate for the implementation of the template generated ChatServices
    weak var delegate : ChatDelegate?
    
    /// apiManager used in consuming the api related to data whether mock or from aws to be initialized
    var apiManager : APIManager
    
    /// authManager used in consuming the authentication api whether mock or from aws to be initialized
    var authManager : AuthManager
    
    var retrievedSessions = false
    
    var retrievedUsers = false
    
    var allChats : [ChatSession]?
    
    var allUsers : [Users]?
    
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
    
    func retrievedAll()
    {
        if retrievedUsers, retrievedSessions{
            self.delegate?.retrievedAll()
        }
    }
    
    func retrieveAllChatSessions()
    {
        let sessionsRetrieved = ChatSessionRetrieved()
        sessionsRetrieved.didRetrieveChatSession = { [weak self] (chatSessions : [ChatSession]? ,errorMessage : String?) in
                self?.allChats = chatSessions
                self?.retrievedSessions = true
                self?.retrievedAll()
        }
        apiManager.retrieveAllChatSession(chatsRetrieved: sessionsRetrieved)
    }
    
    func retrieveAllUsers()
    {
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers =  { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
            self?.retrievedUsers = true
            self?.retrievedAll()
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
}
