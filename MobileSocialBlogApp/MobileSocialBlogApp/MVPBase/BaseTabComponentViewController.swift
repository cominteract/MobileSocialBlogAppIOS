//
//  BaseTabComponentViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 3/13/20.
//  Copyright © 2020 Andre Insigne. All rights reserved.
//

import UIKit

class BaseTabComponentViewController: BaseViewController {

    var isBackNeeded = false
    
    @objc func showSettings() {
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Logout", style: .default) { [weak self] _ in
            Config.updateUser(value: "")
            Config.updateRefreshFeed(value: false)
            Config.updateRefreshDiscover(value: false)
            Config.updateRefreshChat(value: false)
            if Config.getUser() == ""
            {
                self?.tabBarController?.navigationController?.popViewController(animated: true)
            }
        }
        alertController.addAction(action)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isBackNeeded{
            self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: ":", style: .plain, target: self, action: #selector(showSettings))
            self.tabBarController?.navigationItem.setHidesBackButton(true, animated: true);
            self.navigationController?.navigationBar.isHidden = false
        }else{
            
            self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: ":", style: .plain, target: self, action: #selector(showSettings))
            self.navigationController?.navigationBar.isHidden = false
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
