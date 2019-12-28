//
//  BaseNavigationViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//



import UIKit

/// common class implementation for view controllers.



class BaseNavigationViewController: UINavigationController {
    
    var isVisible = false
    
    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
    
    fileprivate var listenersActivated = false
    
    
    func iniListeners() {
        if (!listenersActivated) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(applicationWillResignActive),
                                                   name: UIApplication.willResignActiveNotification,
                                                   object: nil)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(applicationDidBecomeActive),
                                                   name: UIApplication.didBecomeActiveNotification,
                                                   object: nil)
            listenersActivated = true
        } else {
            
        }
    }
    
    @objc func applicationWillResignActive(notification : NSNotification) {
        
    }
    
    @objc func applicationDidBecomeActive(notification : NSNotification) {
        
    }
    
    func startShowing() {
        NotificationCenter.default.addObserver(self, selector: #selector(didShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidLoad() {
        startShowing()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func didShow(){
        isVisible = true
    }
    
    @objc func didHide(){
        isVisible = false
    }
    
    /// convenience method for presenting viewcontrollers
    func present(key : String){
        self.present(UINavigation.viewControllerFrom(key: key), animated: true)
    }
    
    /// convenience method for pushing viewcontrollers
    func push(key : String)
    {
        self.pushViewController(UINavigation.viewControllerFrom(key: key), animated: true)
    }
    
    /// convenience method for popping viewcontrollers
    func pop()
    {
        self.popViewController(animated: true)
    }
    
    func loggedOut(needsOnboard : Bool)
    {
        
    }
    
    func showGoToSettingsAlert(popUpTitle:String, popUpMessage: String) {
        
        // initialise a pop up for using later
        let alertController = UIAlertController(title: popUpTitle, message: popUpMessage, preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl){
                UIApplication.shared.open(settingsUrl, options:[:], completionHandler: { (success) in
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
            //  Updated 23/11/2018 -  Raji
            //self.navigationController?.popViewController(animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
}
