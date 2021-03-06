//
//  FeedInjector.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation


/// injector protocol template for injection of the services and data
protocol FeedInjector {
    func inject(viewController: FeedViewController)
}
/// injector implementation of the protocol template for injection
class FeedInjectorImplementation: FeedInjector {

    /// injects the FeedViewController generated with the services and the presenter used
    /// data
    /// - Parameter viewController: FeedViewController generated by the mvp template
    func inject(viewController: FeedViewController) {
     
 
        let data = DataInjector().getData()
        let services = ServicesInjector(data: data)
        let presenter = FeedPresenterImplementation(view: viewController, apiManager : services.getAPI() , authManager : services.getAuth())
        
        viewController.presenter = presenter
    }
}
