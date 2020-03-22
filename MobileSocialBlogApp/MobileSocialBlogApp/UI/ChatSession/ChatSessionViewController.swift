//
//  ChatSessionViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 01/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit
import JitsiMeet

/// ChatSessionViewController as ChatSessionView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class ChatSessionViewController : BaseTabComponentViewController, ChatSessionView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var meetView : JitsiMeetView?
    
    @IBOutlet weak var sendButton : UIButton?
    
    @IBOutlet weak var callButton : UIButton?
    
    fileprivate var pipViewCoordinator: PiPViewCoordinator?
    
    var conferenceName = ""
    
    var serverName = "https://meet.jit.si/"
    
    var ongoingCall : CallRecords?
    
    func receivedCallFromUpdateView(callRecords: CallRecords) {
        if let it = callRecords.conferenceName {
            self.conferenceName = it
            self.ongoingCall = callRecords
        }
        if !conferenceName.isEmpty && callRecords.callstate == Constants.CALLSTARTED{
            callRecords.callstate = Constants.CALLONGOING
            presenter?.startCall(callRecords: callRecords)
            ongoingCallView()
        }
    }
    
    func endedCallUpdateView(callRecords: CallRecords) {
        
        
        ongoingCall = nil
        callRecords.endedId = nil
        presenter?.startCall(callRecords: callRecords)
        meetView?.isHidden = true
        meetView?.load(nil)
        callEndedView()
    }
    
   
    
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
        initializeCalls()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func startCall(_ sender: Any) {
        
        
        ongoingCall = CallRecords()
        ongoingCall?.id = Constants.randomString(length: 19)
        ongoingCall?.callerId = user?.id
        ongoingCall?.callerName = user?.username
        ongoingCall?.calledId = chatId
        if let id = self.user?.id, let chatId = self.chatId{
            self.conferenceName = "\(id)_\(chatId)"
        }
        if let chats = chatMessagesSession(), chats.first?.author == self.user?.username{
            ongoingCall?.calledName = chats.first?.replyTo
        }else if let chats = chatMessagesSession(){
            ongoingCall?.calledName = chats.first?.author
        }
        ongoingCall?.conferenceName = conferenceName
        ongoingCall?.timestampStarted = Date().toString()
        ongoingCall?.callstate = Constants.CALLSTARTED
        presenter.startCall(callRecords: ongoingCall!)
        if !conferenceName.isEmpty{
            ongoingCallView()
        }
        
    }
    
    
    func initializeCalls(){
        meetView?.isHidden = true
        meetView?.delegate = self
        if let userId = user?.id {
            presenter?.retrieveCalls(userId: userId)
        }
    }
    
    func retrievedAllUpdateView() {
        DispatchQueue.main.async { [weak self] in
            self?.chatSessionTableView.reloadData()
        }
        initializeCalls()
    }
    
    
    
    func addedChatMessageUpdateView() {
        
    }
    func addedChatSessionUpdateView() {
        presenter.retrieveAll()
        
    }
    
    fileprivate func ongoingCallView(){
        DispatchQueue.main.async { [weak self] in
            self?.chatSessionTableView.isHidden = true
            self?.chatSessionTextField.isHidden = true
            self?.sendButton?.isHidden = true
            self?.callButton?.isHidden = true
            self?.meetView?.isHidden = false
//            self?.meetView?.load(URL.init(string: "\(self?.serverName)\(self?.conferenceName)"))

            
            var object = [AnyHashable : Any]()
            if let server = self?.serverName, let conference = self?.conferenceName{
                object["url"] = "\(server)\(conference)"
            }
            
            if let username = self?.user?.username{
                object["displayName"] = username
            }
            if let avatar = self?.user?.photoUrl{
                object["avatar"] = avatar
            }
            self?.meetView?.loadURLObject(object)
        }
    }
    
    fileprivate func callEndedView()
    {
        DispatchQueue.main.async { [weak self] in
            self?.chatSessionTableView.isHidden = false
            self?.chatSessionTextField.isHidden = false
            self?.sendButton?.isHidden = false
            self?.callButton?.isHidden = false
            self?.meetView?.isHidden = true
            
        }
    }
    
    fileprivate func terminateConference() {
        if let it = ongoingCall{
            it.callstate = Constants.CALLENDED
            it.timestampEnded = Date().toString()
            it.endedId = chatId
            presenter?.startCall(callRecords: it)
            callEndedView()
        }
    }
    
}
extension ChatSessionViewController : JitsiMeetViewDelegate {
    
    func conferenceLeft(_ data: [AnyHashable : Any]!) {
        terminateConference()
    }
    
    func conferenceWillLeave(_ data: [AnyHashable : Any]!) {
        
    }
    
    func conferenceTerminated(_ data: [AnyHashable : Any]!) {
        terminateConference()
    }
    
    func conferenceJoined(_ data: [AnyHashable : Any]!) {
        
    }
    
    func conferenceFailed(_ data: [AnyHashable : Any]!) {
        callEndedView()
    }
    
    func enterPicture(inPicture data: [AnyHashable : Any]!) {
        
    }
}
