//
//  ProfileViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// ProfileViewController as ProfileView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class ProfileViewController : BaseViewController, ProfileView, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let count = allPosts?.count, isPost {
            return 400
        }
        else if let count = allUsers?.count, !isPost {
            return 120
        }
        return 120
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = allPosts?.count, isPost {
            return count
        }
        else if let count = allUsers?.count, !isPost {
            return count
        }
        return 0
    }
    
//    @IBAction func viewProfile(_ sender: Any) {
//
//        if let recog = sender as? UITapGestureRecognizer, let lbl = recog.view as? UILabel, let user = allUsers?[lbl.tag], let username = user.username, !isPost{
//            let story = UIStoryboard.init(name: "Main", bundle: nil)
//            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
//            vc.selectedUser = self.presenter.getUserFrom(username: username)
//            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
//        }
//        if let recog = sender as? UITapGestureRecognizer, let img = recog.view as? UIImageView, let user = allUsers?[img.tag], let username = user.username, !isPost{
//            let story = UIStoryboard.init(name: "Main", bundle: nil)
//            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
//            vc.selectedUser = self.presenter.getUserFrom(username: username)
//            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
//        }
//        
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isPost{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.selectedUser = self.allUsers?[indexPath.row]
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isPost{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
            cell.feedTitleLabel.text = allPosts?[indexPath.row].title
            cell.feedBodyLabel.text = allPosts?[indexPath.row].body
            if let link = allPosts?[indexPath.row].url, (link.contains(Constants.firebaseurl) || link.contains(Constants.defaultuserurl)){
                cell.feedImageView?.downloadedFrom(link: link)
            }
            if let postId = allPosts?[indexPath.row].id, let comments = presenter.commentsFromPost(postId: postId){
                cell.feedCommentLabel.text = "\(comments.count)"
            }
            cell.feedUsernameLabel.text = allPosts?[indexPath.row].author
            cell.feedTimestampLabel.text = allPosts?[indexPath.row].timestamp?.toDate()?.fromNow()
            if let upvotes = allPosts?[indexPath.row].upvotes{
                cell.feedUpvoteLabel.text = "\(upvotes)"
            }
            if let downvotes = allPosts?[indexPath.row].downvotes{
                cell.feedDownvoteLabel.text = "\(downvotes)"
            }
            if let link = user?.photoUrl{
                cell.feedUserImageView.downloadedFrom(link: link)
            }
            cell.feedUpvoteImageView.addTapGesture(selector: #selector(FeedViewController.upvoteClicked(_:)), target: self)
            cell.feedUpvoteImageView.tag = indexPath.row
            cell.feedDownvoteImageView.addTapGesture(selector: #selector(FeedViewController.downvoteClicked(_:)), target: self)
            cell.feedDownvoteImageView.tag = indexPath.row
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsTableViewCell") as! FriendsTableViewCell
            if let user = allUsers?[indexPath.row],  let link = user.photoUrl{
                cell.friendImageView.downloadedFrom(link: link)
                cell.friendOnlineButton.setTitle("Online", for: .normal)
                if user.online == nil || user.online == false{
                    cell.friendOnlineButton.setTitle("Offline", for: .normal)
                }
            }
            cell.friendLocationLabel.text = allUsers?[indexPath.row].location
            cell.friendUserLabel.text = allUsers?[indexPath.row].fullname
            
            return cell
        }
    }
    
  
  
    
    func uploadedImageUpdateView() {
        
    }
    /// presenter as ProfilePresenter injected automatically to call implementations
    var presenter: ProfilePresenter!
    
    /// injector as ProfileInjector injects the presenter with the services and data needed for the implementation
    var injector = ProfileInjectorImplementation()
    
    var selectedUser : Users?
    
    var user : Users?
    
    var isUpdating = true
    
    var isPost = true
    
    var isLoading = false
    
    @IBAction func postClicked(_ sender: Any) {
        isPost = true
        
        profileTableView.reloadData()
    }
    
    @IBAction func friendsClicked(_ sender: Any) {
        isPost = false
        profileTableView.reloadData()
        
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        Config.updateUser(value: "")
        if let user = user{
            user.online = false
            presenter.updateUser(user: user, toUpload: false)
        }
        
    }
    
    var imagePicker: ImagePicker!
    
    var selectedPhoto : String?
    
    var selectedData : Data?
    
    var allPosts : [Posts]?
    
    var allUsers : [Users]?
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBAction func browseClicked(_ sender: Any) {
        self.imagePicker.present(from: sender as! UIView)
    }
    
    @IBOutlet weak var profileLabelStack: UIStackView!
    
    @IBOutlet weak var profileTextFieldStack: UIStackView!
    
    @IBOutlet weak var profileEditButton: UIButton!
    
    @IBAction func updateClicked(_ sender: Any) {
        isUpdating = !isUpdating
        profileTextFieldStack.isHidden = isUpdating
        profileLabelStack.isHidden = !isUpdating
        if let user = user, isUpdating, let data = selectedData{
            user.firstname = profileFirstNameTextField.text
            user.lastname = profileLastNameTextField.text
            user.birthday = profileBirthdayTextField.text
            user.location = profileLocationTextField.text
            presenter.updateUser(user: user, toUpload: selectedPhoto != nil)
            presenter.uploadImage(data: data)
        }
    }
    
    @IBOutlet weak var profileFirstNameLabel: UILabel!
    
    @IBOutlet weak var profileLastNameLabel: UILabel!
    
    @IBOutlet weak var profileBirthdayLabel: UILabel!
    
    @IBOutlet weak var profileLocationLabel: UILabel!
    
    @IBOutlet weak var profileFirstNameTextField: UITextField!
    
    @IBOutlet weak var profileLastNameTextField: UITextField!
    
    @IBOutlet weak var profileBirthdayTextField: UITextField!
    
    @IBOutlet weak var profileLocationTextField: UITextField!
    
    @IBOutlet weak var profileTableView: UITableView!
    
    
    @IBAction func profileChatClicked(_ sender: Any) {
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = story.instantiateViewController(withIdentifier: "ChatSession") as! ChatSessionViewController
        vc.selectedUser = self.selectedUser
        vc.user = self.user
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBOutlet weak var profileChatButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        injector.inject(viewController: self)
        presenter.retrieveAll()
        isLoading = true
        profileTextFieldStack.isHidden = true
        profileLabelStack.isHidden = false
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UINib.init(nibName: "FriendsTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendsTableViewCell")
        profileTableView.register(UINib.init(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        self.navigationController?.navigationBar.isHidden = true
        profileChatButton.isHidden = true
        if selectedUser != nil{
            self.navigationController?.navigationBar.isHidden = false
            profileChatButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if selectedUser != nil{
            self.navigationController?.navigationBar.isHidden = false
        }
        if !isLoading, let refreshed = Config.getRefreshProfile(), !refreshed{
            presenter.retrieveAll()
            isLoading = true
        }
    }

    func retrievedAllUpdateView() {
        Config.updateRefreshProfile(value: true)
        isLoading = false
        if let username = Config.getUser(){
            user = presenter.getUserFrom(username: username)
            presenter.downloadImage(username: username)
            if let selectedUser = selectedUser, let selectedId = selectedUser.id{
                allUsers = presenter.allUsers()?.filter({ $0.friendsId != nil && $0.friendsId!.contains(selectedId) })
                allPosts = presenter.allPosts()?.filter({ $0.userId == selectedUser.id })
            }
            else if let id = user?.id{
                allUsers = presenter.allUsers()?.filter({ $0.friendsId != nil && $0.friendsId!.contains(id)  })
                allPosts = presenter.allPosts()?.filter({ $0.userId == user?.id })
            }
            DispatchQueue.main.async { [weak self] in
                var currentUser : Users?
                currentUser = self?.user
                if self?.selectedUser != nil{
                    currentUser = self?.selectedUser
                }
                self?.profileFirstNameLabel.text = currentUser?.firstname
                self?.profileLastNameLabel.text = currentUser?.lastname
                self?.profileBirthdayLabel.text = currentUser?.birthday
                self?.profileLocationLabel.text = currentUser?.location
                self?.profileFirstNameTextField.text = currentUser?.firstname
                self?.profileLastNameTextField.text = currentUser?.lastname
                self?.profileBirthdayTextField.text = currentUser?.birthday
                self?.profileLocationTextField.text = currentUser?.location
                self?.profileTableView.reloadData()
            }
        }
    }
    
    func addedUserUpdateView() {
        Config.updateRefreshFeed(value: false)
        Config.updateRefreshDiscover(value: false)
        Config.updateRefreshChat(value: false)
        if Config.getUser() == ""
        {
            self.tabBarController?.navigationController?.popViewController(animated: true)
        }
    }
    
    func downloadedImageUpdateView(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.profileImageView.image = image
        }
    }
    
    
}
extension ProfileViewController : ImagePickerDelegate {
    
    func didSelect(image: UIImage?, url : String, data : Data) {
        selectedPhoto = url
        print(" Selected Photo \(selectedPhoto) \(image)")
        profileImageView.image = image
        selectedData = data
    }
}

