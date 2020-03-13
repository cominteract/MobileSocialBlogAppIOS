//
//  BaseViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 25/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//



import UIKit

/// common class implementation for view controllers.



class BaseViewController: UIViewController {
    
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
        hideKeyboardWhenTappedAround()
        
        
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
        self.navigationController?.pushViewController(UINavigation.viewControllerFrom(key: key), animated: true)
    }
    
    /// convenience method for popping viewcontrollers
    func pop()
    {
        self.navigationController?.popViewController(animated: true)
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
                if #available(iOS 10, *) {
                    UIApplication.shared.open(settingsUrl, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    let success = UIApplication.shared.openURL(settingsUrl)
                   
                }
                
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

// MARK: - extension to hide keyboard when tapped
extension BaseViewController : UITextFieldDelegate{
    
    /// adds the tap gesture recognizer for the view controller
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    /// dismisses the keyboard by ending the editing for the view
    @objc func dismissKeyboard() {
        if isVisible
        {
            view.endEditing(true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    /// number of visible lines for the label Note : this exceeds by 1 but it is working
    ///
    /// - Returns: as Int the number of visible lines depending on the lineheight and the max size
    func numberOfVisibleLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
