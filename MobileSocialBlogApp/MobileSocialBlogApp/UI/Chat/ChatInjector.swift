//
//  ChatInjector.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 30/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation


/// injector protocol template for injection of the services and data
protocol ChatInjector {
    func inject(viewController: ChatViewController)
}
/// injector implementation of the protocol template for injection
class ChatInjectorImplementation: ChatInjector {

    /// injects the ChatViewController generated with the services and the presenter used
    /// data
    /// - Parameter viewController: ChatViewController generated by the mvp template
    func inject(viewController: ChatViewController) {
     
 
        let data = DataInjector().getData()
        let services = ServicesInjector(data: data)
        let presenter = ChatPresenterImplementation(view: viewController, apiManager : services.getAPI() , authManager : services.getAuth())
        
        viewController.presenter = presenter
    }
}
