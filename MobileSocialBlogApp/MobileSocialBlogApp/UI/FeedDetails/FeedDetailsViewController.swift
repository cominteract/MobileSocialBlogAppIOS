//
//  FeedDetailsViewController.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 29/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import UIKit

/// FeedDetailsViewController as FeedDetailsView to be updated by the presenter after an implementation, BaseViewController for common methods and properties if ever (extensions etc)

class FeedDetailsViewController : BaseTabComponentViewController, FeedDetailsView, UITableViewDelegate, UITableViewDataSource {
    
    /// presenter as FeedDetailsPresenter injected automatically to call implementations
    var presenter: FeedDetailsPresenter!
    
    /// injector as FeedDetailsInjector injects the presenter with the services and data needed for the implementation
    var injector = FeedDetailsInjectorImplementation()
    
    @IBOutlet weak var feedDetailsTableView: UITableView!
    
    @IBOutlet weak var feedDetailsTextView: UITextView!
    
    @IBOutlet weak var feedDetailsPostButton: UIButton!
    
    
    var replyTo : String?
    
    var isCommenting = false
    
    @IBOutlet weak var feedDetailsCommentButton: UIButton!
    @IBAction func commentClicked(_ sender: Any) {
        isCommenting = !isCommenting
        feedDetailsCommentButton.setTitle("Comment on post", for: .normal)
        if isCommenting{
            feedDetailsCommentButton.setTitle("Close", for: .normal)
        }
        
        feedDetailsPostButton.isHidden = !isCommenting
        feedDetailsTextView.isHidden = !isCommenting
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let comments = comments{
            return comments.count + 1
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 325
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell") as! FeedTableViewCell
            cell.feedTitleLabel.text = posts?.title
            cell.feedBodyLabel.text = posts?.body
            if let link = posts?.url, (link.contains(Constants.firebaseurl) || link.contains(Constants.defaultuserurl)){
                cell.feedImageView?.downloadedFrom(link: link)
            }
            if let postId = posts?.id, let comments = presenter.commentsFromPost(postId: postId){
                cell.feedCommentLabel.text = "\(comments.count)"
            }
            cell.feedUsernameLabel.text = posts?.author
            cell.feedTimestampLabel.text = posts?.timestamp?.toDate()?.fromNow()
            if let upvotes = posts?.upvotes{
                cell.feedUpvoteLabel.text = "\(upvotes)"
            }
            if let downvotes = posts?.downvotes{
                cell.feedDownvoteLabel.text = "\(downvotes)"
            }
            if let link = user?.photoUrl{
                cell.feedUserImageView.downloadedFrom(link: link)
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell") as! CommentsTableViewCell
            cell.commentMessageLabel.text = comments?[indexPath.row - 1].message
            if let username = comments?[indexPath.row - 1].author, let user = presenter.getUserFrom(username: username), let link = user.photoUrl{
                cell.commentUserLabel.text = username
                cell.commentUserImageView.downloadedFrom(link: link)
            }
            
            
            cell.commentTimestampLabel.text = comments?[indexPath.row - 1].timestamp?.toDate()?.fromNow()
            if let author = comments?.filter({ $0.id == comments?[indexPath.row - 1].replyTo }).first?.author{
                cell.commentReplyToLabel.text = "@\(author)"
            }
            
            
            
            cell.commentUserLabel.addTapGesture(selector: #selector(FeedDetailsViewController.viewProfile(_:)), target: self)
            cell.commentUserLabel.tag = indexPath.row - 1
            cell.commentUserImageView.addTapGesture(selector: #selector(FeedDetailsViewController.viewProfile(_:)), target: self)
            cell.commentUserImageView.tag = indexPath.row - 1
            
            return cell
        }
    }
    
    @IBAction func viewProfile(_ sender: Any) {
        if let recog = sender as? UITapGestureRecognizer, let lbl = recog.view as? UILabel, let comment = comments?[lbl.tag], let username = comment.author{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.selectedUser = self.presenter.getUserFrom(username: username)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if let recog = sender as? UITapGestureRecognizer, let img = recog.view as? UIImageView, let comment = comments?[img.tag], let username = comment.author{
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "Profile") as! ProfileViewController
            vc.selectedUser = self.presenter.getUserFrom(username: username)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func postClicked(_ sender: Any) {
        let comment = Comments()
        comment.id = Constants.randomString(length: 22)
        comment.author = user?.username
        comment.userId = user?.id
        comment.commentedTo = posts?.id
        comment.commentedToPost = posts
        comment.downvotes = 0
        comment.upvotes = 0
        comment.timestamp = Date().toString()
        comment.message = feedDetailsTextView.text
        if let replyTo = replyTo{
            comment.replyTo = replyTo
        }
        presenter?.sendComment(comment: comment)
    }
    
    var posts : Posts?
    
    var user : Users?
    
    var comments : [Comments]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        injector.inject(viewController: self)
        feedDetailsTableView.delegate = self
        feedDetailsTableView.dataSource = self
        self.feedDetailsTableView.register(UINib.init(nibName: "CommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentsTableViewCell")
        self.feedDetailsTableView.register(UINib.init(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedTableViewCell")
        self.presenter.retrieveAll()
        
        self.feedDetailsTextView.isHidden = !isCommenting
        self.feedDetailsPostButton.isHidden = !isCommenting
    }

    
    override func viewDidAppear(_ animated: Bool) {
        isBackNeeded = true
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func addedCommentsUpdateView() {
        replyTo = nil
    }
  
    func retrievedAllUpdateView() {
        if let postId = posts?.id{
            comments = presenter.commentsFromPost(postId: postId)
            DispatchQueue.main.async { [weak self] in
                self?.feedDetailsTableView.reloadData()
            }
        }
        
        
    }
    
}
