//
//  ChatSessionPresenter.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 01/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

/// ChatSessionView protocol for updating the view in the view controllers
protocol ChatSessionView: class {
    func addedChatMessageUpdateView()
    func addedChatSessionUpdateView()
    func retrievedAllUpdateView()
    func receivedCallFromUpdateView(callRecords: CallRecords)
    func endedCallUpdateView(callRecords: CallRecords)
}

/// ChatSessionDelegate protocol for delegating implementations from the ChatSessionServices
protocol ChatSessionDelegate: class{
    func addedChatSession()
    func addedChatMessage()
    func retrievedAll()
    func receivedCallFrom(callRecords: CallRecords)
    func endedCall(callRecords: CallRecords)
}

/// ChatSessionPresenter protocol for implementing the ChatSessionPresenter
protocol ChatSessionPresenter {
    func startCall(callRecords: CallRecords)
    func allChats() -> [ChatMessages]?
    func allSessions() -> [ChatSession]?
    func sendChat(chat : ChatMessages)
    func sendSession(chat : ChatSession)
    func retrieveAll()
    func retrieveCalls(userId : String)
    func getUserFrom(username : String) -> Users?
}

/// ChatSessionPresenter implementation based on the presenter protocol
class ChatSessionPresenterImplementation : ChatSessionPresenter, ChatSessionDelegate {
    
    func retrieveCalls(userId: String) {
        service.retrieveCalls(userId: userId)
    }
    
    func startCall(callRecords: CallRecords) {
        service.startCall(callRecords: callRecords)
    }
    
    func endedCall(callRecords: CallRecords) {
        view?.endedCallUpdateView(callRecords: callRecords)
    }
    
    func receivedCallFrom(callRecords: CallRecords) {
        view?.receivedCallFromUpdateView(callRecords: callRecords)
    }
    
    
    func allSessions() -> [ChatSession]? {
        return service.allSessions
    }
    
    func getUserFrom(username: String) -> Users? {
        return service.getUserFrom(username: username)
    }
    
    func retrieveAll() {
        service.retrieveAllChatMessages()
        service.retrieveAllUsers()
        service.retrieveAllChatSessions()
    }
    
    func allChats() -> [ChatMessages]? {
        return service.allChats
    }
    
    func retrievedAll() {
        view?.retrievedAllUpdateView()
    }
    
    func sendSession(chat: ChatSession) {
        service.updateSession(chatSession: chat)
    }
    
    func addedChatSession() {
        view?.addedChatSessionUpdateView()
    }
    
    func addedChatMessage() {
        view?.addedChatMessageUpdateView()
    }
    func sendChat(chat: ChatMessages) {
        service.sendChat(chatMessage: chat)
    }
    /// ChatSessionView reference of the ChatSessionViewController as ChatSessionView type. Must be weak
    fileprivate weak var view: ChatSessionView?
    
    /// ChatSessionServices property to set the services used by the presenter
    var service : ChatSessionServices!
    
    /// initializes with the ChatSessionViewController as the ChatSessionView for updating the view and authManager for consuming the authentication api and apiManager for consuming the api related to data
    ///
    /// - Parameters:
    ///   - view: ChatSessionViewController as the ChatSessionView for updating the view
    ///   - apiManager: for consuming the api related to data
    ///   - authManager: for consuming the authentication api
    init(view : ChatSessionView,
         apiManager : APIManager, authManager : AuthManager) {
        service = ChatSessionServices(apiManager : apiManager,
                                                    authManager : authManager)
        service.delegate = self
        self.view = view
    }
}
