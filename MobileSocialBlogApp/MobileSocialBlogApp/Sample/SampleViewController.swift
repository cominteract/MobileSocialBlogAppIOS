//
//  SampleViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// SampleViewController as SampleView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class SampleViewController : BaseViewController, SampleView {
    
    /// presenter as SamplePresenter injected automatically to call implementations
    var presenter: SamplePresenter!
    
    /// injector as SampleInjector injects the presenter with the services and data needed for the implementation
    var injector: SampleInjector = SampleInjectorImplementation()
    
    var selectedPhoto : String?
    
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        injector.inject(viewController: self)
        presenter.retrieveAll()
        // presenter.addUser()
        // presenter.addPost()
        // presenter.addComment()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    func addedCommentsUpdateView() {
        print(" Successfully added comment")
    }

    func addedUserUpdateView() {
        print(" Successfully added user")
    }
    
    func addedPostUpdateView() {
        print(" Successfully added post")
    }
    
    @IBAction func addUserClicked(_ sender: Any) {
        // presenter.addUser(friendsId: nil, userId: nil)
//        if !presenter.isAlreadyFriend(friendsId: "HYscOe9v", userId: "WD1 UTxu")
//        {
//            presenter.addUser(friendsId: "HYscOe9v", userId: "WD1 UTxu")
//        }
        presenter.addUser(friendsId: nil, userId: nil, photoUrl: nil)
    }
    
    @IBAction func addPostClicked(_ sender: Any) {
        
        if presenter.allowedToPost(){
            presenter.addPost(userId: "WD1 UTxu", url: selectedPhoto)
        }
    }
    
    @IBAction func addCommentClicked(_ sender: Any) {
        if presenter.allowedToComment(){
            //presenter.addComment(replyTo: "1yLkGqhfPR abqqfPHi7y8")
            presenter.addComment(replyTo: nil)
        }
    }
    
    @IBAction func browsePhotosClicked(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
        
    }
}

extension SampleViewController: ImagePickerDelegate {
    
    func didSelect(image: UIImage?, url : String, data : Data) {
        selectedPhoto = url
        print(" Selected Photo \(selectedPhoto) \(image)")
    }
}

