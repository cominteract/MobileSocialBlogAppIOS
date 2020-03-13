//
//  FirebaseAPIManager.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import Firebase

class FirebaseAPIManager: APIManager {
    
    var ref: DatabaseReference!
    
    let storageRef = Storage.storage().reference()
    
    override init() {
        ref = Database.database().reference()
    }
    
    override func updateById(id : String, endpoint : String, keyval : [String : Any]){
        ref.child(endpoint).child(id).setValue(keyval)
    }
    
    override func getUser(username : String, userConversion : UserConversion){
        let userReference = ref.child(Constants.users).child(username)
        Conversions.convertToUsers(ref: userReference, conversion: userConversion)
    }
    
    override func getPost(username : String, postConversion : PostsConversion){
        let postReference = ref.child(Constants.posts).child(username)
        Conversions.convertToPosts(ref: postReference, conversion: postConversion)
    }
    
    override func getComments(username : String, commentsConversion : CommentsConversion){
        let commentReference = ref.child(Constants.comments).child(username)
        Conversions.convertToComments(ref: commentReference, conversion: commentsConversion)
    }
    
    override func userExists(username : String, userConversion : UserConversion){
        
    }
    
    override func postExists(id : String, postConversion : PostsConversion){
        
    }
    
    override func retrieveAllUsers(usersRetrieved: UsersRetrieved) {
        ref.child(Constants.users).observe(.value) { (snapshots) in
            if let values = snapshots.value as? NSDictionary{
                print(" User count = \(values.allKeys.count)")
                usersRetrieved.didRetrieveUsers?(Conversions.convertToAllUsers(values: values), nil)
            }else{
                usersRetrieved.didRetrieveUsers?(nil, "Missing objects")
            }
        }
    }
    
    override func retrieveAllPosts(postsRetrieved: PostsRetrieved) {
        ref.child(Constants.posts).observe(.value) { (snapshots) in
            if let values = snapshots.value as? NSDictionary{
                print(" Post count = \(values.allKeys.count)")
                postsRetrieved.didRetrievePosts?(Conversions.convertToAllPosts(values: values), nil)
            }
            else{
                postsRetrieved.didRetrievePosts?(nil , "Missing objects")
            }
        }
    }

    override func retrieveAllComments(commentsRetrieved : CommentsRetrieved){
        ref.child(Constants.comments).observe(.value) { (snapshots) in
            if let values = snapshots.value as? NSDictionary{
                print(" Comments count = \(values.allKeys.count)")
                commentsRetrieved.didRetrieveComments?(Conversions.convertToAllComments(values: values), nil)
            }else{
                commentsRetrieved.didRetrieveComments?(nil, "Missing objects")
            }
        }
    }
    
    override func addUser(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)  {
        if keyval.keys.contains("username"){
            ref.child(Constants.users).child(keyval["username"] as! String).setValue(keyval) { (err, dref) in
                withCompletion(err,"Successfully added user \(keyval["username"] ?? "")")
            }
        }
    }
    
    override func addComments(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void){
        if keyval.keys.contains("id"){
            ref.child(Constants.comments).child(keyval["id"] as! String).setValue(keyval) { (err, dref) in
                withCompletion(err,"Successfully added comment \(keyval["id"] ?? "")")
            }
        }
    }
    
    override func addPosts(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void){
        if keyval.keys.contains("id"){
            ref.child(Constants.posts).child(keyval["id"] as! String).setValue(keyval) { (err, dref) in
                withCompletion(err,"Successfully added post \(keyval["id"] ?? "")")
            }
        }
    }
    
    override func addSession(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void){
        if keyval.keys.contains("id"){
            ref.child(Constants.sessions).child(keyval["id"] as! String).setValue(keyval) { (err, dref) in
                withCompletion(err,"Successfully added session \(keyval["id"] ?? "")")
            }
        }
    }
    
    override func addChats(keyval: [String : Any], withCompletion : @escaping (_ err : Error?, _ message : String) -> Void)
    {
        if keyval.keys.contains("id"){
            ref.child(Constants.chats).child(keyval["id"] as! String).setValue(keyval) { (err, dref) in
                withCompletion(err,"Successfully added chat message \(keyval["id"] ?? "")")
            }
        }
    }
    
    override func downloadImage(imageName: String, withCompletion: @escaping (Error?, UIImage?) -> Void) {
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(imageName).jpg")
        imageRef.getData(maxSize: 1 * 1024 * 1542) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                withCompletion(error, nil)
            } else {
                // Data for "images/island.jpg" is returned
                let image = UIImage(data: data!)
                withCompletion(nil, image)
            }
        }
    }
    
    override func uploadImage(data : Data, imageName : String, withCompletion : @escaping (_ err : Error?, _ msg : String?) -> Void)
    {
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(imageName).jpg")
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imageRef.putData(data, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print(" Encountered upload error \(error?.localizedDescription)")
                withCompletion(error, nil)
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            print(" Image size \(size)")
            // You can also access to download URL after upload.
        }
        uploadTask.resume()
        
        uploadTask.observe(.success) { snapshot in
            withCompletion(nil, "Successful upload")
            print(" Upload complete ")
        }
        
        uploadTask.observe(.progress) { snapshot in
            // Upload reported progress
            let percent = 100.0 * Double(snapshot.progress!.completedUnitCount)
                / Double(snapshot.progress!.totalUnitCount)
            print(" Upload progress \(percent)")
        }
        
        uploadTask.observe(.failure) { snapshot in
            if let error = snapshot.error as? NSError {
                switch (StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    print(" Upload does not exist ")
                    // File doesn't exist
                    break
                case .unauthorized:
                    print(" Upload no permission to access ")
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    print(" Upload cancelled ")
                    // User canceled the upload
                    break
                    
                    /* ... */
                    
                case .unknown:
                    print(" Upload unknown ")
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    print(" Upload can retry ")
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
                withCompletion(error, nil)
            }
        }
    }
    
    override func listImagesForUsers(users : [Users], referencesRetrieved : ReferencesRetrieved)
    {
        let storageReference = storageRef.child("images")
        var imagedUsers = [Users]()
        storageReference.listAll { (result, error) in
            if let error = error {
                print(" Error listing user images ")
            }
            var count = 0
            for item in result.items{
                item.downloadURL(completion: { (url, err) in
                    count += 1
                    if let url = url,  users.filter({ $0.id != nil && url.absoluteString.contains($0.id!) }).count > 0{
                        let user = users.filter({ $0.id != nil && url.absoluteString.contains($0.id!) })[0]
                        
                        user.photoUrl = url.absoluteString
                        imagedUsers.append(user)
                    }
                    if let url = url{
                        print(" Users url \(url.absoluteString)")
                    }
                    if result.items.count == count{
                        referencesRetrieved.didRetrieveUserImages?(imagedUsers)
                    }
                })
            }
        }
    }
    
    override func listImagesForPosts(posts : [Posts], referencesRetrieved : ReferencesRetrieved)
    {
        let storageReference = storageRef.child("images")
        var imagedPosts = [Posts]()
        storageReference.listAll { (result, error) in
            if let error = error {
                print(" Error listing post images ")
            }
            var count = 0
            for item in result.items{
                item.downloadURL(completion: { (url, err) in
                    count += 1
                    if let url = url,  posts.filter({ $0.id != nil && url.absoluteString.contains($0.id!) }).count > 0{
                        let post = posts.filter({ $0.id != nil && url.absoluteString.contains($0.id!) })[0]
                        print(" Posts url \(url.absoluteString)")
                        post.url = url.absoluteString
                        imagedPosts.append(post)
                    }
                    if result.items.count == count{
                        referencesRetrieved.didRetrievePostImages?(imagedPosts)
                    }
                })
            }
        }
    }
    override func retrieveAllChatMessages(chatsRetrieved: ChatMessagesRetrieved) {
        ref.child(Constants.chats).observe(.value) { (snapshots) in
            if let values = snapshots.value as? NSDictionary{
                print(" Chat count = \(values.allKeys.count)")
                chatsRetrieved.didRetrieveChatMessages?(Conversions.convertToAllChatMessages(values: values),"")
            }else{
                chatsRetrieved.didRetrieveChatMessages?(nil, "")
            }
        }
    }
    
    override func retrieveAllChatSession(chatsRetrieved: ChatSessionRetrieved) {
        ref.child(Constants.sessions).observe(.value) { (snapshots) in
            if let values = snapshots.value as? NSDictionary{
                print(" Sessions count = \(values.allKeys.count)")
                chatsRetrieved.didRetrieveChatSession?(Conversions.convertToAllChatSession(values: values),"")
                
            }else{
                chatsRetrieved.didRetrieveChatSession?(nil,"")
            }
        }
    }
    
    
}
