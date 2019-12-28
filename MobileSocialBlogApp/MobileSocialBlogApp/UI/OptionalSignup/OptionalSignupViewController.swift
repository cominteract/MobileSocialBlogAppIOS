//
//  OptionalSignupViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// OptionalSignupViewController as OptionalSignupView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class OptionalSignupViewController : BaseViewController, OptionalSignupView {
    
    /// presenter as OptionalSignupPresenter injected automatically to call implementations
    var presenter: OptionalSignupPresenter!
    
    /// injector as OptionalSignupInjector injects the presenter with the services and data needed for the implementation
    var injector =  OptionalSignupInjectorImplementation()
    
    var imagePicker: ImagePicker!
    
    var user : Users?
    
    var selectedPhoto : String?
    
    var selectedData : Data?
    
    var allowedUpdate = false
    
    @IBOutlet weak var signupBirthdayTextField: UITextField!
    
    @IBOutlet weak var signupLocationTextField: UITextField!
    
    @IBOutlet weak var signupPhotoImageView: UIImageView!
    
    @IBAction func browseImageClicked(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    
    @IBAction func updateClicked(_ sender: Any) {
        if allowedUpdate{
            if let selectedPhoto = selectedPhoto{
                user?.photoUrl = selectedPhoto
            }
            user?.birthday = signupBirthdayTextField.text
            user?.location = signupLocationTextField.text
            if let data = selectedData{
                presenter.uploadImage(data: data)
            }
            if let user = user{
                presenter.updateUser(user: user, toUpload: false)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        injector.inject(viewController: self)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        presenter.retrieveAll()
    }
    
    func retrievedAllUpdateView() {
        allowedUpdate = true
    }

    func updatedUserUpdateView() {
        if selectedData == nil{
            allowedUpdate = false
            DispatchQueue.main.async { [weak self] in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func uploadedImageUpdateView() {
        selectedData = nil
        allowedUpdate = false
        DispatchQueue.main.async { [weak self] in
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension OptionalSignupViewController : ImagePickerDelegate {
    
    func didSelect(image: UIImage?, url : String, data : Data) {
        selectedPhoto = url
        print(" Selected Photo \(selectedPhoto) \(image)")
        signupPhotoImageView.image = image
        selectedData = data
    }
}


