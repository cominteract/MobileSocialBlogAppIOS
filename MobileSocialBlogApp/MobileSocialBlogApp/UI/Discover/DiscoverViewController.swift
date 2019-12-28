//
//  DiscoverViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// DiscoverViewController as DiscoverView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class DiscoverViewController : BaseViewController, DiscoverView, UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    @IBOutlet weak var discoverTableView: UITableView!
    
    var user : Users?
    
    var allUsers : [Users]?
    
    func updatedUsersUpdateView() {
        Config.updateRefreshProfile(value: false)
        Config.updateRefreshFeed(value: false)
        Config.updateRefreshChat(value: false)
    }
    
    func retrievedAllUpdateView() {
        isLoading = false
        Config.updateRefreshDiscover(value: true)
        if let username = Config.getUser(){
            user = presenter.getUserFrom(username: username)
            allUsers = presenter.allUsers()?.filter({ $0.username != username })
        }
        
        DispatchQueue.main.async { [weak self] in
           self?.discoverTableView.reloadData()
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = allUsers?.count{
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DiscoverTableViewCell") as! DiscoverTableViewCell
        if let name = allUsers?[indexPath.row].username {
            cell.discoverUserLabel.text = name
        }
        cell.discoverLocationLabel.text = allUsers?[indexPath.row].location
        cell.discoverRemoveFriendButton.isHidden = true
        cell.discoverAddFriendButton.tag = indexPath.row
        cell.discoverRemoveFriendButton.tag = indexPath.row
        if let url = allUsers?[indexPath.row].photoUrl {
            cell.discoverImageView.downloadedFrom(link: url)
        }
        if let bUser = allUsers?[indexPath.row], isAlreadyFriend(bUser: bUser){
            cell.discoverAddFriendButton.setTitle("Friends", for: .normal)
        }
        else if let bUser = allUsers?[indexPath.row], isAlreadyInvited(bUser: bUser) {
            cell.discoverAddFriendButton.setTitle("Accept", for: .normal)
            cell.discoverAddFriendButton.addTapGesture(selector: #selector(DiscoverViewController.acceptFriendClicked(_:)), target: self)
            cell.discoverRemoveFriendButton.addTapGesture(selector: #selector(DiscoverViewController.cancelFriendClicked(_:)), target: self)
            cell.discoverRemoveFriendButton.isHidden = false
        }
        else if let bUser = allUsers?[indexPath.row], isAlreadyRequested(bUser: bUser) {
            cell.discoverAddFriendButton.setTitle("Cancel", for: .normal)
            cell.discoverAddFriendButton.addTapGesture(selector: #selector(DiscoverViewController.cancelFriendClicked(_:)), target: self)
        }else{
            cell.discoverAddFriendButton.setTitle("Add Friend", for: .normal)
            cell.discoverAddFriendButton.addTapGesture(selector: #selector(DiscoverViewController.addFriendClicked(_:)), target: self)
        }
        return cell
    }
    
    @IBAction func addFriendClicked(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let btn = recog.view as? UIButton{
            if let aUser = user, let bUser = allUsers?[btn.tag], let aId = aUser.id, let bId = bUser.id{
                if aUser.friendsRequestedId != nil{
                    aUser.friendsRequestedId?.append(bId)
                }
                if bUser.friendsInviteId != nil{
                    bUser.friendsInviteId?.append(aId)
                }
                if aUser.friendsRequestedId == nil{
                    aUser.friendsRequestedId = [String]()
                    aUser.friendsRequestedId?.append(bId)
                }
                if bUser.friendsInviteId == nil{
                    bUser.friendsInviteId = [String]()
                    bUser.friendsInviteId?.append(aId)
                }
                presenter.updateUsers(aUser: aUser, bUser: bUser)
            }
        }
    }
    
    @IBAction func acceptFriendClicked(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let btn = recog.view as? UIButton{
            if let aUser = user, let bUser = allUsers?[btn.tag]{
                aUser.friendsInviteId = aUser.friendsInviteId?.filter( { $0 != bUser.id } )
                aUser.friendsRequestedId = aUser.friendsRequestedId?.filter( { $0 != bUser.id } )
                bUser.friendsInviteId = bUser.friendsInviteId?.filter( { $0 != aUser.id } )
                bUser.friendsRequestedId = bUser.friendsRequestedId?.filter( { $0 != aUser.id } )
                if aUser.friendsId == nil{
                    aUser.friendsId = [String]()
                }
                if bUser.friendsId == nil{
                    bUser.friendsId = [String]()
                }
                if let aId = aUser.id, let bId = bUser.id{
                    aUser.friendsId?.append(bId)
                    bUser.friendsId?.append(aId)
                    presenter.updateUsers(aUser: aUser, bUser: bUser)
                }
            }
        }
    }
    
    @IBAction func cancelFriendClicked(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let btn = recog.view as? UIButton{
            if let aUser = user, let bUser = allUsers?[btn.tag]{
                aUser.friendsInviteId = aUser.friendsInviteId?.filter( { $0 != bUser.id } )
                aUser.friendsRequestedId = aUser.friendsRequestedId?.filter( { $0 != bUser.id } )
                bUser.friendsInviteId = bUser.friendsInviteId?.filter( { $0 != aUser.id } )
                bUser.friendsRequestedId = bUser.friendsRequestedId?.filter( { $0 != aUser.id } )
                presenter.updateUsers(aUser: aUser, bUser: bUser)
            }
        }
    }
    
    func isAlreadyFriend(bUser : Users) -> Bool{
        if let friendsId = user?.friendsId, let id = bUser.id, friendsId.contains(id){
            return true
        }
        return false
    }
    
    func isAlreadyRequested(bUser : Users) -> Bool{
        if let friendsId = user?.friendsRequestedId, let id = bUser.id, friendsId.contains(id){
            return true
        }
        return false
    }
    
    func isAlreadyInvited(bUser : Users) -> Bool{
        if let friendsId = user?.friendsInviteId, let id = bUser.id, friendsId.contains(id){
            return true
        }
        return false
    }
    
    /// presenter as DiscoverPresenter injected automatically to call implementations
    var presenter: DiscoverPresenter!
    
    /// injector as DiscoverInjector injects the presenter with the services and data needed for the implementation
    var injector = DiscoverInjectorImplementation()
    
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        injector.inject(viewController: self)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        self.discoverTableView.register(UINib.init(nibName: "DiscoverTableViewCell", bundle: nil), forCellReuseIdentifier: "DiscoverTableViewCell")
        self.presenter.retrieveAll()
        isLoading = true
    }

    override func viewDidAppear(_ animated: Bool) {
        if !isLoading, let refreshed = Config.getRefreshFeed(), !refreshed{
            presenter.retrieveAll()
            isLoading = true
        }
    }
    
}
