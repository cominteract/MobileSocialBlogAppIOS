//
//  APIManager.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import UIKit
/// error retrieved which is the parent class to return the error from the fetch query through closure callback
class ErrorRetrieved{
    var didRetrievedError : ((Error, Bool) -> Void)?
}

class UsersRetrieved{
    var didRetrieveUsers : (([Users]?, String?) -> Void)?
}

class PostsRetrieved{
    var didRetrievePosts : (([Posts]?, String?) -> Void)?
}

class CommentsRetrieved{
    var didRetrieveComments : (([Comments]?,  String?) -> Void)?
}

class ChatMessagesRetrieved{
    var didRetrieveChatMessages : (([ChatMessages]?,  String?) -> Void)?
}

class ChatSessionRetrieved{
    var didRetrieveChatSession : (([ChatSession]?,  String?) -> Void)?
}

class ReferencesRetrieved{
    var didRetrievePostImages : (([Posts]) -> Void)?
    var didRetrieveUserImages : (([Users]) -> Void)?
}

class APIManager: APIProtocol {
    func retrieveAllChatMessages(chatsRetrieved : ChatMessagesRetrieved) {
        
    }
    
    func listImagesForUsers(users : [Users], referencesRetrieved : ReferencesRetrieved)
    {
        
    }
    
    func listImagesForPosts(posts : [Posts], referencesRetrieved : ReferencesRetrieved)
    {
        
    }
    
    func retrieveAllPosts(postsRetrieved: PostsRetrieved) {
        
    }
    
    func retrieveAllUsers(usersRetrieved : UsersRetrieved)
    {
        
    }

    func retrieveAllComments(commentsRetrieved : CommentsRetrieved)
    {
        
    }
    
    func addUser( keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)  {
        
    }
    
    func addComments(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    {
        
    }
    func addPosts(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    {
        
    }
    
    func addChats(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    {
        
    }
    
    func updateById(id : String, endpoint : String, keyval : [String : Any])
    {
        
    }
    
    func getUser(username : String, userConversion : UserConversion)
    {
        
    }
    
    func getPost(username : String, postConversion : PostsConversion)
    {
        
    }
    
    func getComments(username : String, commentsConversion : CommentsConversion)
    {
        
    }
    
    func userExists(username : String, userConversion : UserConversion)
    {
        
    }
    
    func postExists(id : String, postConversion : PostsConversion)
    {
        
    }
    
    func uploadImage(data : Data, imageName : String, withCompletion : @escaping (_ err : Error?, _ msg : String?) -> Void)
    {
        
    }
    
    
    
    func downloadImage(imageName: String, withCompletion : @escaping (_ err : Error?, _ img : UIImage?) -> Void) {
        
    }
    
    func retrieveAllChatSession(chatsRetrieved: ChatSessionRetrieved) {
        
    }
    
    func addSession(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void){
        
    }
}
