//
//  ProfileInjector.swift
//  MobileSocialBlogApp
//
//  Created by Andre Insigne on 27/11/2019.
//  Copyright © 2019 Andre Insigne. All rights reserved.
//


import Foundation


/// injector protocol template for injection of the services and data
protocol ProfileInjector {
    func inject(viewController: ProfileViewController)
}
/// injector implementation of the protocol template for injection
class ProfileInjectorImplementation: ProfileInjector {

    /// injects the ProfileViewController generated with the services and the presenter used
    /// data
    /// - Parameter viewController: ProfileViewController generated by the mvp template
    func inject(viewController: ProfileViewController) {
     
 
        let data = DataInjector().getData()
        let services = ServicesInjector(data: data)
        let presenter = ProfilePresenterImplementation(view: viewController, apiManager : services.getAPI() , authManager : services.getAuth())
        
        viewController.presenter = presenter
    }
}
