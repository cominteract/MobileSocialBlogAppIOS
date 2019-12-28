//
//  MockAPIManager.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

class MockAPIManager: APIManager {
    override func updateById(id : String, endpoint : String, keyval : [String : Any])
    {
        
    }
    
    override func getUser(username : String, userConversion : UserConversion)
    {
        
    }
    
    override func getPost(username : String, postConversion : PostsConversion)
    {
        
    }
    
    override func getComments(username : String, commentsConversion : CommentsConversion)
    {
        
    }
    
    override func retrieveAllUsers(usersRetrieved: UsersRetrieved) {
        usersRetrieved.didRetrieveUsers?(Users.users(), "success")
        //usersRetrieved.didRetrieveUsers()
    }
    
    override func retrieveAllPosts(postsRetrieved: PostsRetrieved) {
        postsRetrieved.didRetrievePosts?(Posts.posts(), "success")
    }
    
    override func retrieveAllComments(commentsRetrieved : CommentsRetrieved)
    {
        commentsRetrieved.didRetrieveComments?(Comments.comments(), "success")
    }
    
    override func userExists(username : String, userConversion : UserConversion)
    {
        
    }
    
    override func postExists(id : String, postConversion : PostsConversion)
    {
        
    }
    override func addUser( keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)  {
        withCompletion(nil,"Success")
    }
    
    override func addComments(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    {
        withCompletion(nil,"Success")
    }
    override func addPosts(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    {
        withCompletion(nil,"Success")
    }
    
    override func addChats(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    {
        withCompletion(nil,"Success")
    }
    
    override func uploadImage(data : Data, imageName : String, withCompletion : @escaping (_ err : Error?, _ msg : String?) -> Void)
    {
        withCompletion(nil,"Success")
    }
    override func downloadImage(imageName: String, withCompletion: @escaping (Error?, UIImage?) -> Void) {
        
    }
    
    override func listImagesForUsers(users : [Users], referencesRetrieved : ReferencesRetrieved)
    {
        
    }
    
    override func listImagesForPosts(posts : [Posts], referencesRetrieved : ReferencesRetrieved)
    {
        
    }
    
    override func retrieveAllChatMessages(chatsRetrieved : ChatMessagesRetrieved) {
        chatsRetrieved.didRetrieveChatMessages?(ChatMessages.chatMessages(),"success")
    }
    
    override func retrieveAllChatSession(chatsRetrieved: ChatSessionRetrieved) {
        chatsRetrieved.didRetrieveChatSession?(ChatSession.chatSessions(),"success")
    }
    
    override func addSession(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void){
        
    }
    
}
