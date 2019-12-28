//
//  SignupViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// SignupViewController as SignupView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class SignupViewController : BaseViewController, SignupView {
    
    /// presenter as SignupPresenter injected automatically to call implementations
    var presenter: SignupPresenter!
    
    /// injector as SignupInjector injects the presenter with the services and data needed for the implementation
    var injector = SignupInjectorImplementation()
    
    @IBOutlet weak var signupUsernameTextField: UITextField!
    
    @IBOutlet weak var signupFirstnameTextField: UITextField!
    
    @IBOutlet weak var signupLastnameTextField: UITextField!
    
    @IBOutlet weak var signupPasswordTextField: UITextField!
    
    @IBOutlet weak var signupConfirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var loginUsernameTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    
    @IBAction func loginClicked(_ sender: Any) {
        if let username = loginUsernameTextField.text, let password = loginPasswordTextField.text, presenter.usernameExists(username: username), presenter.passwordCorrect(username: username, password: password){
            Config.updateUser(value: username)
            user = presenter.getUserFrom(username: username)
            
            if let online = user?.online, !online, (user?.birthday == nil || user?.photoUrl == Constants.defaultuserurl || user?.location == nil)
            {
                DispatchQueue.main.async { [weak self] in
                    let story = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "Optional") as! OptionalSignupViewController
                    vc.user = self?.user
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else if user?.online == nil{
                user?.online = true
                DispatchQueue.main.async { [weak self] in
                    let story = UIStoryboard.init(name: "Main", bundle: nil)
                    let vc = story.instantiateViewController(withIdentifier: "Optional") as! OptionalSignupViewController
                    vc.user = self?.user
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            }
            else
            {
                if let user = user{
                    user.online = true
                    presenter.signupUser(user: user)
                }
            }
        }
    }
    
    
    var user : Users? = Users()
    
    @IBAction func signupClicked(_ sender: Any) {
        if let username = signupUsernameTextField.text, !presenter.usernameExists(username: username),
            isSame(), let user = user{
            user.id = Constants.randomString(length: 22)
            user.firstname = signupFirstnameTextField.text
            user.lastname = signupLastnameTextField.text
            if let first = user.firstname, let last = user.lastname{
                user.fullname = "\(first) \(last)"
            }
            
            user.username = signupUsernameTextField.text
            user.password = signupPasswordTextField.text
            if let username = signupUsernameTextField.text{
                Config.updateUser(value: username)
            }
            presenter.signupUser(user: user)
        }
    }
    
    func isSame() -> Bool
    {
        return signupPasswordTextField.text == signupConfirmPasswordTextField.text
    }
    
    var viewDidLoaded = false
    override func viewDidAppear(_ animated: Bool) {
        if viewDidLoaded, (Config.getUser() == nil || Config.getUser() == "") {
            presenter.retrieveAll()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        injector.inject(viewController: self)
        if Config.getUser() != nil && Config.getUser() != ""{
            viewDidLoaded = true
            DispatchQueue.main.async { [weak self] in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }else{
            presenter.retrieveAll()
        }
    }
    
    func addedUserUpdateView() {
        if let online = user?.online, online{
            DispatchQueue.main.async { [weak self] in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else{
            DispatchQueue.main.async { [weak self] in
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                let vc = story.instantiateViewController(withIdentifier: "Optional") as! OptionalSignupViewController
                self?.user?.online = true
                vc.user = self?.user
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
