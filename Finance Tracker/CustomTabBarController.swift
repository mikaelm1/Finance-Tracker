//
//  CustomTabBarController.swift
//  Finance Tracker
//
//  Created by Mikael Mukhsikaroyan on 7/3/16.
//  Copyright © 2016 MSquaredmm. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = Constants.purpleBarColor
        tabBar.tintColor = UIColor.whiteColor()
        
        let statsController = createController(StatsVC(), title: "Stats", imageName: "stats")
        let addItemsController = createController(AddItemVC(), title: "New", imageName: "income_expense")
        
        viewControllers = [statsController, addItemsController]
    }
    
    private func createController(viewController: UIViewController, title: String, imageName: String) -> UINavigationController {
        let vc = viewController
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.barTintColor = Constants.purpleBarColor
        navVC.navigationBar.tintColor = UIColor.whiteColor()
        navVC.navigationBar.barStyle = .Black
        navVC.tabBarItem.title = title
        navVC.tabBarItem.image = UIImage(named: imageName)
        return navVC
    }

}
