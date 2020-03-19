//
//  ChatSessionViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 01/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// ChatSessionViewController as ChatSessionView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class ChatSessionViewController : BaseTabComponentViewController, ChatSessionView, UITableViewDelegate, UITableViewDataSource {
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let username = chatMessagesSession()?[indexPath.row].author, let user = presenter.getUserFrom(username: username), user.username == Config.getUser(){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSessionTableViewCell") as! ChatSessionTableViewCell
            
            cell.chatFriendTimestampLabel.text = chatMessagesSession()?[indexPath.row].timestamp?.toDate()?.fromNow()
            cell.chatFriendUserLabel.text = chatMessagesSession()?[indexPath.row].author
            cell.chatFriendMessageLabel.text = chatMessagesSession()?[indexPath.row].message
            cell.chatFriendMessageLabel.layer.borderWidth = 2
            cell.chatFriendMessageLabel.layer.cornerRadius = 15
            
            if let link = user.photoUrl{
                cell.chatFriendImageView.downloadedFrom(link: link)
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSessionReplyTableViewCell") as! ChatSessionReplyTableViewCell
         
            cell.chatFriendTimestampLabel.text = chatMessagesSession()?[indexPath.row].timestamp?.toDate()?.fromNow()
            cell.chatFriendUserLabel.text = chatMessagesSession()?[indexPath.row].author
            cell.chatFriendMessageLabel.text = chatMessagesSession()?[indexPath.row].message
            if let username = chatMessagesSession()?[indexPath.row].author, let user = presenter.getUserFrom(username: username), let link = user.photoUrl{
                cell.chatFriendImageView.downloadedFrom(link: link)
            }
            cell.chatFriendMessageLabel.layer.borderWidth = 2
            cell.chatFriendMessageLabel.layer.cornerRadius = 15
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = chatMessagesSession()?.count{
            return count
        }
        return 0
    }
    
    func chatMessagesSession() -> [ChatMessages]?
    {
        return presenter.allChats()?.filter({ ($0.userId == user?.id && $0.replyTo == chatId) || ($0.userId == chatId && $0.replyTo == user?.id)})
    }
    
    /// presenter as ChatSessionPresenter injected automatically to call implementations
    var presenter: ChatSessionPresenter!
    
    /// injector as ChatSessionInjector injects the presenter with the services and data needed for the implementation
    var injector = ChatSessionInjectorImplementation()
    
    @IBAction func sendChatClicked(_ sender: Any) {
        let chat = ChatMessages()
        chat.id = Constants.randomString(length: 22)
        chat.author = user?.username
        chat.userId = user?.id
        chat.timestamp = Date().toString()
        chat.message = chatSessionTextField.text
        chat.replyTo = chatId
        chat.timestamp_from = Date().fromNow()
        chat.msgId = 0
        if let count = presenter.allChats()?.count{
            chat.msgId = count
        }
        presenter.sendChat(chat: chat)
        var session = ChatSession()
        if let userId = user?.id, let selectedId = chatId{
            if let sessions = presenter.allSessions(), sessions.filter({ $0.userIds != nil && $0.userIds!.contains(userId) && $0.userIds!.contains(selectedId) }).count > 0{
                session = sessions.filter({ $0.userIds != nil && $0.userIds!.contains(userId) && $0.userIds!.contains(selectedId) })[0]
            }
            else{
                session.id = Constants.randomString(length: 22)
                session.userIds = [String]()
                session.userIds?.append(userId)
                session.userIds?.append(selectedId)
            }
        }
        session.message = chatSessionTextField.text
        session.author = user?.username
        session.timestamp = Date().fromNow()
        presenter.sendSession(chat: session)
    }
    

    @IBOutlet weak var chatSessionTextField: UITextField!
    
    @IBOutlet weak var chatSessionTableView: UITableView!
    
    var chatId : String?
    
    var user : Users?
    
    override func viewDidAppear(_ animated: Bool) {
        isBackNeeded = true
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        injector.inject(viewController: self)
        chatSessionTableView.delegate = self
        chatSessionTableView.dataSource = self
        self.chatSessionTableView.register(UINib.init(nibName: "ChatSessionTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSessionTableViewCell")
        self.chatSessionTableView.register(UINib.init(nibName: "ChatSessionReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatSessionReplyTableViewCell")
        self.presenter?.retrieveAll()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func retrievedAllUpdateView() {
        DispatchQueue.main.async { [weak self] in
            self?.chatSessionTableView.reloadData()
        }
    }
    
    func addedChatMessageUpdateView() {
        
    }
    func addedChatSessionUpdateView() {
        presenter.retrieveAll()
        
    }
    
}
