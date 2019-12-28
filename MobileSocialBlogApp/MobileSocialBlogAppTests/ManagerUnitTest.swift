//
//  ManagerUnitTest.swift
//  MobileSocialBlogAppTests
//
//  Created by Andre Insigne on 23/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import XCTest

class ManagerUnitTest: XCTestCase {

    let apiManager = MockAPIManager()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddChat() {
        let keyval = ChatMessages.convertToKeyVal(chat: ChatMessages.chatMessages()[0])
        apiManager.addChats(keyval: keyval) { (err, msg) in
            if err == nil
            {
                XCTAssert(true)
            }
        }
    }
    
    func testAddChatSession() {
        let keyval = ChatSession.convertToKeyVal(chat: ChatSession.chatSessions()[0])
        apiManager.addSession(keyval: keyval) { (err, msg) in
            if err == nil
            {
                XCTAssert(true)
            }
        }
    }
    
    func testAddUser()
    {
        let keyval = Users.convertToKeyVal(users : Users.users()[0])
        apiManager.addUser(keyval: keyval) { (err, msg) in
            if err == nil
            {
                XCTAssert(true)
            }
        }
    }
    
    func testAddPosts()
    {
        let keyval = Posts.convertToKeyVal(post : Posts.posts()[0])
        apiManager.addPosts(keyval: keyval) { (err, msg) in
            if err == nil
            {
                XCTAssert(true)
            }
        }
    }
    
    func testAddComments()
    {
        let keyval = Comments.convertToKeyVal(comment : Comments.comments()[0])
        apiManager.addComments(keyval: keyval) { (err, msg) in
            if err == nil
            {
                XCTAssert(true)
            }
        }
    }

    func testRetrieveComments()
    {
        let commentsRetrieved = CommentsRetrieved()
        commentsRetrieved.didRetrieveComments = { [weak self] (comments : [Comments]? ,errorMessage : String?) in
            XCTAssert(comments != nil)
        }
        apiManager.retrieveAllComments(commentsRetrieved: commentsRetrieved)
    }
    
    func testRetrieveUsers(){
        let usersRetrieved = UsersRetrieved()
        usersRetrieved.didRetrieveUsers = { [weak self] (users : [Users]? ,errorMessage : String?) in
            XCTAssert(users != nil)
        }
        apiManager.retrieveAllUsers(usersRetrieved: usersRetrieved)
    }
    
    func testRetrievePosts(){
        let postsRetrieved = PostsRetrieved()
        postsRetrieved.didRetrievePosts = { [weak self] (posts : [Posts]? ,errorMessage : String?) in
            XCTAssert(posts != nil)
        }
        apiManager.retrieveAllPosts(postsRetrieved: postsRetrieved)
    }
    
    func testRetrieveChatMessages()
    {
        let chatsRetrieved = ChatMessagesRetrieved()
        chatsRetrieved.didRetrieveChatMessages =  { [weak self] (chatMessages : [ChatMessages]? ,errorMessage : String?) in
            XCTAssert(chatMessages != nil)
        }
        apiManager.retrieveAllChatMessages(chatsRetrieved: chatsRetrieved)
    }
    
    func testRetrieveChatSessions()
    {
        let sessionsRetrieved = ChatSessionRetrieved()
        sessionsRetrieved.didRetrieveChatSession = { [weak self] (chatSessions : [ChatSession]? ,errorMessage : String?) in
            XCTAssert(chatSessions != nil)
        }
        apiManager.retrieveAllChatSession(chatsRetrieved: sessionsRetrieved)
    }

}
