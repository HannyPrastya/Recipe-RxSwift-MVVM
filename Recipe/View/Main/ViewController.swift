//
//  ViewController.swift
//  Recipe
//
//  Created by Hanny Prastya Hariyadi on 2021/07/31.
//

import UIKit

class ViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let homeViewController = HomeViewController()
        homeViewController.title = "Home"
        homeViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .mostRecent, tag: 0)
        
        let favoriteViewController = FavoriteViewController()
        favoriteViewController.title = "Favorites"
        favoriteViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let controllers = [homeViewController, favoriteViewController]
        self.viewControllers = controllers
    }
}

