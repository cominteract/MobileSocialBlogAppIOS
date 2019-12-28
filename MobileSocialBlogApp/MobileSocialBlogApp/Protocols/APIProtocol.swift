//
//  APIProtocol.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// api protocol which is the template used in consuming the api with the mock api manager or the api manager from the backend
protocol APIProtocol: class {
    
    func updateById(id : String, endpoint : String, keyval : [String : Any])
    
    func addUser(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    
    func addComments(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    
    func addPosts(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    
    func addChats(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    
    func addSession(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    
    func getUser(username : String, userConversion : UserConversion)
    
    func getPost(username : String, postConversion : PostsConversion)
    
    func getComments(username : String, commentsConversion : CommentsConversion)
    
    func userExists(username : String, userConversion : UserConversion)
    
    func postExists(id : String, postConversion : PostsConversion)
    
    func retrieveAllUsers(usersRetrieved : UsersRetrieved)
 
    func retrieveAllPosts(postsRetrieved : PostsRetrieved)
    
    func retrieveAllComments(commentsRetrieved : CommentsRetrieved)
    
    func retrieveAllChatMessages(chatsRetrieved : ChatMessagesRetrieved)
    
    func retrieveAllChatSession(chatsRetrieved : ChatSessionRetrieved)
    
    func uploadImage(data : Data, imageName : String, withCompletion : @escaping (_ err : Error?, _ msg : String?) -> Void)
    
    func downloadImage(imageName: String, withCompletion : @escaping (_ err : Error?, _ img : UIImage?) -> Void)
    
    func listImagesForUsers(users : [Users], referencesRetrieved : ReferencesRetrieved)
    
    func listImagesForPosts(posts : [Posts], referencesRetrieved : ReferencesRetrieved)
}
