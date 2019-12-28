//
//  FeedViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// FeedViewController as FeedView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class FeedViewController : BaseViewController, FeedView, UITableViewDelegate, UITableViewDataSource {
    func uploadedImageUpdateView() {
        if let posts = posts, let url = selectedPhoto{
            posts.url = url
            presenter.sendPost(posts: posts)
        }
        selectedData = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.allPosts()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
        cell.feedTitleLabel.text = presenter.allPosts()?[indexPath.row].title
        cell.feedBodyLabel.text = presenter.allPosts()?[indexPath.row].body
        if let link = presenter.allPosts()?[indexPath.row].url, (link.contains(Constants.firebaseurl) || link.contains(Constants.defaultuserurl)){
            cell.feedImageView?.downloadedFrom(link: link)
        }
        if let postId = presenter.allPosts()?[indexPath.row].id, let comments = presenter.commentsFromPost(postId: postId){
            cell.feedCommentLabel.text = "\(comments.count)"
        }
        cell.feedUsernameLabel.text = presenter.allPosts()?[indexPath.row].author
        
        cell.feedUsernameLabel.addTapGesture(selector: #selector(FeedViewController.viewProfile(_:)), target: self)
        cell.feedUsernameLabel.tag = indexPath.row
        
        cell.feedUserImageView.addTapGesture(selector: #selector(FeedViewController.viewProfile(_:)), target: self)
        cell.feedUserImageView.tag = indexPath.row
        
        cell.feedTimestampLabel.text = presenter.allPosts()?[indexPath.row].timestamp?.toDate()?.fromNow()
        if let upvotes = presenter.allPosts()?[indexPath.row].upvotes{
            cell.feedUpvoteLabel.text = "\(upvotes)"
        }
        if let downvotes = presenter.allPosts()?[indexPath.row].downvotes{
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
    
    @IBAction func viewProfile(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let lbl = recog.view as? UILabel, let post = presenter.allPosts()?[lbl.tag], let username = post.author{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.selectedUser = self.presenter.getUserFrom(username: username)
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
        if let recog = sender as? UITapGestureRecognizer, let img = recog.view as? UIImageView, let post = presenter.allPosts()?[img.tag], let username = post.author{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.selectedUser = self.presenter.getUserFrom(username: username)
            self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func upvoteClicked(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let img = recog.view as? UIImageView, let post = presenter.allPosts()?[img.tag]{
            if let id = user?.id{
                if let upvotesId = post.upvotedId, upvotesId.contains(id){
                    post.upvotedId = upvotesId.filter({ $0 != id })
                    post.upvotes = post.upvotes - 1
                }
                else{
                    post.upvotes = post.upvotes + 1
                    if let downvotesId = post.downvotedId, downvotesId.contains(id){
                        post.downvotes = post.downvotes - 1
                        post.downvotedId = downvotesId.filter({ $0 != id  })
                    }
                    if post.upvotedId == nil{
                        post.upvotedId = [String]()
                    }
                    post.upvotedId?.append(id)
                }
            }
            self.presenter?.sendPost(posts: post)
        }
    }
    @IBAction func downvoteClicked(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let img = recog.view as? UIImageView, let post = presenter.allPosts()?[img.tag]{
            if let id = user?.id{
                if let downvotesId = post.downvotedId, downvotesId.contains(id){
                    post.downvotedId = downvotesId.filter({ $0 != id })
                    post.downvotes = post.downvotes - 1
                }
                else{
                    post.downvotes = post.downvotes + 1
                    if let upvotesId = post.upvotedId, upvotesId.contains(id){
                        post.upvotes = post.upvotes - 1
                        post.upvotedId = upvotesId.filter({ $0 != id  })
                    }
                    if post.downvotedId == nil{
                        post.downvotedId = [String]()
                    }
                    post.downvotedId?.append(id)
                }
            }
            self.presenter?.sendPost(posts: post)
        }
    }

    
    
    /// presenter as FeedPresenter injected automatically to call implementations
    var presenter: FeedPresenter!
    
    /// injector as FeedInjector injects the presenter with the services and data needed for the implementation
    var injector = FeedInjectorImplementation()
    
    var imagePicker: ImagePicker!
    
    var user : Users?
    
    @IBOutlet weak var feedMessageTextView: UITextView!
    
    @IBOutlet weak var feedTitleTextField: UITextField!
    
    @IBOutlet weak var feedTableView: UITableView!
    
    @IBOutlet weak var feedUsernameLabel: UILabel!
    
    @IBOutlet weak var feedShareThoughtsButton: UIButton!
    
    @IBOutlet weak var feedProfileImageView: UIImageView!
    
    @IBOutlet weak var feedPostButton: UIButton!
    
    var selectedPhoto : String?
    
    var selectedData : Data?
    
    @IBAction func shareThoughtsClicked(_ sender: Any) {
        isPosting = !isPosting
        feedTitleTextField.isHidden = isPosting
        feedMessageTextView.isHidden = isPosting
        feedPostButton.isHidden = isPosting
        if isPosting{
            feedShareThoughtsButton.setTitle("Share your thoughts", for: .normal)
        }else{
            feedShareThoughtsButton.setTitle("Close", for: .normal)
        }
    }
    
    var isLoading = false
    
    var isPosting = true
    
    var posts : Posts?
    
    @IBAction func postClicked(_ sender: Any) {
        
        posts = Posts()
        posts?.id = Constants.randomString(length: 22)
        if let user = user{
            posts?.author = user.username
            posts?.userId = user.id
        }
        posts?.body = feedMessageTextView.text
        posts?.downvotes = 0
        posts?.upvotes = 0
        posts?.timestamp = Date().toString()
        posts?.timestamp_from = Date().fromNow()
        posts?.title = feedTitleTextField.text
        if let data = selectedData, let id = posts?.id{
            presenter.uploadPostImage(data: data, postId: id)
        }else if let posts = posts{
            posts.url = Constants.defaultposturl
            presenter.sendPost(posts: posts)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "FeedDetails") as! FeedDetailsViewController
            vc.user = self?.user
            if let post = self?.presenter?.allPosts()?[indexPath.row], let postId = self?.presenter?.allPosts()?[indexPath.row].id{
                vc.comments = self?.presenter.commentsFromPost(postId: postId)
                vc.posts = post
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        injector.inject(viewController: self)
        presenter.retrieveAll()
        isLoading = true
        feedTableView.delegate = self
        feedTableView.dataSource = self
        self.feedTableView.register(UINib.init(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        feedTitleTextField.isHidden = isPosting
        feedMessageTextView.isHidden = isPosting
        feedPostButton.isHidden = isPosting
        feedUploadedImageView.addTapGesture(selector: #selector(FeedViewController.browseClicked), target: self)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
         
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if !isLoading, let refreshed = Config.getRefreshFeed(), !refreshed{
            presenter.retrieveAll()
            isLoading = true
        }
    }

    @objc func browseClicked()
    {
        self.imagePicker.present(from: feedUploadedImageView as! UIImageView)
    }
    
    func retrievedAllUpdateView() {
        isLoading = false
        Config.updateRefreshFeed(value: true)
        DispatchQueue.main.async { [weak self] in
            self?.feedTableView.reloadData()
            if let username = Config.getUser(){
                self?.user = self?.presenter.getUserFrom(username: username)
                self?.feedUsernameLabel.text = self?.user?.firstname
                if let userPic = self?.user?.photoUrl,
                    (userPic.contains(Constants.firebaseurl) || userPic.contains(Constants.defaultuserurl)){
                    self?.feedProfileImageView.downloadedFrom(link: userPic)
                }
                //self?.presenter.downloadImage(username: username)
            }
            print(" Successful retrieval in feed ")
        }
    }
    
    func downloadedImageUpdateView(image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.feedProfileImageView.image = image
        }
    }

    @IBOutlet weak var feedUploadedImageView: UIImageView!
    func addedCommentsUpdateView() {
        
    }
    
    func addedPostUpdateView() {
        Config.updateRefreshProfile(value: false)
        Config.updateRefreshDiscover(value: false)
        Config.updateRefreshChat(value: false)
        posts = nil
    }
    
}
extension FeedViewController : ImagePickerDelegate {
    
    func didSelect(image: UIImage?, url : String, data : Data) {
        selectedPhoto = url
        print(" Selected Photo \(selectedPhoto) \(image)")
        feedUploadedImageView.image = image
        selectedData = data
    }
}


