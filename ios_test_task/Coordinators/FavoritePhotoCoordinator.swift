//
//  FavoritePhotoCoordinator.swift
//  ios_test_task
//
//  Created by Ilya Buldin on 13.01.2022.
//

import UIKit

class FavoritePhotoCoordinator: MainCoordinator {
    weak var mainCoordinator: MainCoordinator?
    
    override var currentNavigationController: UINavigationController {
        mainCoordinator!.currentNavigationController
    }
    
    init(mainCoordinator: MainCoordinator) {
        self.mainCoordinator = mainCoordinator
    }
    
    func showAdditionalInfo(with photoInfo: AdditionalPhotoInfo) {
        DispatchQueue.main.async {
            let vc = PhotoAdditionalInfoViewController(with: photoInfo)
            self.currentNavigationController.pushViewController(vc, animated: true)
        }
        
    }
}
