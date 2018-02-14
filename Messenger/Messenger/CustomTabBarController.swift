//
//  CustomTabBarController.swift
//  messenger
//
//  Created by Siddique on 12/02/18.
//  Copyright © 2018 Siddique. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Recent"
        let layout = UICollectionViewFlowLayout()
        let friendController = FriendViewController(collectionViewLayout: layout)
        let recentViewController = UINavigationController(rootViewController: friendController)
        recentViewController.tabBarItem.title = "Recent"
        recentViewController.tabBarItem.image = UIImage(named: "recent")
        viewControllers = [recentViewController, createDummyNavControllerWithTitle("Calls", imageName: "calls"), createDummyNavControllerWithTitle("Groups", imageName: "groups"), createDummyNavControllerWithTitle("People", imageName: "people"), createDummyNavControllerWithTitle("Settings", imageName: "settings")]
    }
    
    private func createDummyNavControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
}
