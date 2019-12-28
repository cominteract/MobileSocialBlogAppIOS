//
//  FeedViewPresenterTest.swift
//  MobileSocialBlogAppTests
//
//  Created by Andre Insigne on 28/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//

import XCTest

class FeedViewPresenterTest: XCTestCase {

    var feedView : FeedViewImplementation!
    var presenter : FeedPresenterImplementation!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        feedView = FeedViewImplementation()
        let mockAPI = MockAPIManager()
        let mockAuth = MockAuthManager()
        presenter = FeedPresenterImplementation(view : feedView, apiManager : mockAPI, authManager : mockAuth)
        
    }
    
    func testRetrieveAll(){
        presenter.retrieveAll()
        XCTAssert(feedView.retrievedAll, "retrieved all called")
    }
    
    func testAddPost(){
        let post = Posts()
        post.id = Constants.randomString(length: 22)
        post.author = Constants.randomString(length: 6)
        post.body = Constants.randomString(length: 300)
        post.userId = Constants.randomString(length: 22)
        post.title = Constants.randomString(length: 22)
        
        presenter.sendPost(posts: post)
        XCTAssert(feedView.addedPost, "added post")
    }
    
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
