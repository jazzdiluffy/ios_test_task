//
//  MainCoordinator.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 12.01.2022.
//

import Foundation
import UIKit


class MainCoordinator {
    
    let tabBarController = UITabBarController()
    
    var currentNavigationController: UINavigationController {
        tabBarController.viewControllers?[tabBarController.selectedIndex] as! UINavigationController
    }
    
    func start(in window: UIWindow) {
        let homeVC = HomeCollectionViewController()
        homeVC.coordinator = HomeCoordinator(mainCoordinator: self)
        let controllers = [
            homeVC,
            FavoritePhotosViewController()
        ]
            .map { UINavigationController(rootViewController: $0) }
        
        tabBarController.setViewControllers(controllers, animated: false)
        window.rootViewController = tabBarController
    }
    

}

