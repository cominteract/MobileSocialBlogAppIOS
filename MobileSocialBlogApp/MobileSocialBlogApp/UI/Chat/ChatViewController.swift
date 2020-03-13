//
//  ChatViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// ChatViewController as ChatView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class ChatViewController : BaseViewController, ChatView, UITableViewDelegate, UITableViewDataSource {
    
    /// presenter as ChatPresenter injected automatically to call implementations
    var presenter: ChatPresenter!
    
    /// injector as ChatInjector injects the presenter with the services and data needed for the implementation
    var injector = ChatInjectorImplementation()
    
    var isLoading = false
    
    @IBOutlet weak var chatTableView: UITableView!
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sessions = presenter.allSessions(){
            return sessions.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatFriendTableViewCell") as! ChatFriendTableViewCell
        cell.chatFriendTimestampLabel.text = presenter.allSessions()?[indexPath.row].timestamp?.toDate()?.fromNow()
        cell.chatFriendUserLabel.text = presenter.allSessions()?[indexPath.row].author
    
        cell.chatFriendUserLabel.addTapGesture(selector: #selector(ChatViewController.viewProfile(_:)), target: self)
        cell.chatFriendUserLabel.tag = indexPath.row
        
        cell.chatFriendImageView.addTapGesture(selector: #selector(ChatViewController.viewProfile(_:)), target: self)
        cell.chatFriendImageView.tag = indexPath.row
        
        cell.addTapGesture(selector: #selector(ChatViewController.viewSession(_:)), target: self)
        cell.tag = indexPath.row
        cell.chatFriendMessageLabel.text = presenter.allSessions()?[indexPath.row].message
        if let username = presenter.allSessions()?[indexPath.row].author, let user = presenter.getUserFrom(username: username), let link = user.photoUrl{
            cell.chatFriendImageView.downloadedFrom(link: link)
            cell.chatFriendOnlineButton.setTitle("Online", for: .normal)
            if user.online == nil || user.online == false{
                cell.chatFriendOnlineButton.setTitle("Offline", for: .normal)
            }
            
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        injector.inject(viewController: self)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        self.chatTableView.register(UINib.init(nibName: "ChatFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatFriendTableViewCell")
        presenter.retrieveAll()
        isLoading = true
        self.navigationController?.navigationBar.isHidden = true
    }

    
    @IBAction func viewSession(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let cell = recog.view as? UITableViewCell, let username = presenter.allSessions()?[cell.tag].author, let currentUser = Config.getUser(){
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "ChatSession") as! ChatSessionViewController
            vc.selectedUser = self.presenter.getUserFrom(username: username)
            vc.user = self.presenter.getUserFrom(username: currentUser)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func viewProfile(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let lbl = recog.view as? UILabel, let username = presenter.allSessions()?[lbl.tag].author{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.selectedUser = self.presenter.getUserFrom(username: username)
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
        if let recog = sender as? UITapGestureRecognizer, let img = recog.view as? UIImageView, let username = presenter.allSessions()?[img.tag].author{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.selectedUser = self.presenter.getUserFrom(username: username)
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isLoading, let refreshed = Config.getRefreshChat(), !refreshed{
            presenter.retrieveAll()
            isLoading = true
        }
        
    }
    
    func retrievedAllUpdateView() {

        DispatchQueue.main.async { [weak self] in
            self?.chatTableView.reloadData()
        }
        Config.updateRefreshChat(value: true)
        isLoading = false
    }
}
