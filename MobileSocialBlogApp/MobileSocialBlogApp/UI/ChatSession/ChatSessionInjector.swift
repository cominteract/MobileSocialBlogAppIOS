//
//  ChatSessionInjector.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 01/12/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation


/// injector protocol template for injection of the services and data
protocol ChatSessionInjector {
    func inject(viewController: ChatSessionViewController)
}
/// injector implementation of the protocol template for injection
class ChatSessionInjectorImplementation: ChatSessionInjector {

    /// injects the ChatSessionViewController generated with the services and the presenter used
    /// data
    /// - Parameter viewController: ChatSessionViewController generated by the mvp template
    func inject(viewController: ChatSessionViewController) {
     
 
        let data = DataInjector().getData()
        let services = ServicesInjector(data: data)
        let presenter = ChatSessionPresenterImplementation(view: viewController, apiManager : services.getAPI() , authManager : services.getAuth())
        
        viewController.presenter = presenter
    }
}