//
//  ChatSessionServices.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 01/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation





/// ChatSessionServices class for implementing the services needed for the presenter
class ChatSessionServices: NSObject {

    /// delegate for the implementation of the template generated ChatSessionServices
    weak var delegate : ChatSessionDelegate?
    
    /// apiManager used in consuming the api related to data whether mock or from aws to be initialized
    var apiManager : APIManager
    
    var allChats : [ChatMessages]?
    
    var allSessions : [ChatSession]?
    
    var allUsers : [Users]?
    
    var retrievedChats = false
    var retrievedUsers = false
    var retrievedSessions = false
    
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
 
    func sendChat(chatMessage : ChatMessages){
        apiManager.addChats(keyval: ChatMessages.convertToKeyVal(chat: chatMessage)) { [weak self] (err, message) in
            self?.delegate?.addedChatMessage()
        }
    }
    
    func retrieveAllChatSessions()
    {
        let sessionsRetrieved = ChatSessionRetrieved()
        sessionsRetrieved.didRetrieveChatSession = { [weak self] (chatSessions : [ChatSession]? ,errorMessage : String?) in
            self?.allSessions = chatSessions
            self?.retrievedSessions = true
            if let retrievedChats = self?.retrievedChats, let retrievedUsers = self?.retrievedUsers, retrievedChats,retrievedUsers {
                self?.delegate?.retrievedAll()
            }
        }
        apiManager.retrieveAllChatSession(chatsRetrieved: sessionsRetrieved)
    }
    
    func updateSession(chatSession : ChatSession){
        apiManager.addSession(keyval: ChatSession.convertToKeyVal(chat: chatSession)) { [weak self] (err, message) in
            self?.delegate?.addedChatSession()
        }
    }
    
    func getUserFrom(username : String) -> Users?{
        if let filtered = allUsers?.filter({ $0.username == username }), filtered.count > 0{
            return filtered[0]
        }
        return nil
    }
    
    func retrieveAllUsers()
    {
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers =  { [weak self] (users : [Users]? ,errorMessage : String?) in
            self?.allUsers = users
            self?.retrievedUsers = true
            if let retrievedChats = self?.retrievedChats, let retrievedSessions = self?.retrievedSessions, retrievedChats,retrievedSessions {
                self?.delegate?.retrievedAll()
            }
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
    
    func retrieveAllChatMessages()
    {
        let chatsRetrieved = ChatMessagesRetrieved()
        chatsRetrieved.didRetrieveChatMessages =  { [weak self] (chatMessages : [ChatMessages]? ,errorMessage : String?) in
            self?.allChats = chatMessages
            self?.retrievedChats = true
            if let retrievedUsers = self?.retrievedUsers, let retrievedSessions = self?.retrievedSessions, retrievedUsers,retrievedSessions {
                self?.delegate?.retrievedAll()
            }
            
        }
        apiManager.retrieveAllChatMessages(chatsRetrieved: chatsRetrieved)
    }
    
}
