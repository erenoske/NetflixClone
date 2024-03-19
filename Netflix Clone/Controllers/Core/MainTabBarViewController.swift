//
//  ViewController.swift
//  Netflix Clone
//
//  Created by eren on 5.03.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: DownloadsViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.rectangle.on.rectangle")
        vc3.tabBarItem.image = UIImage(systemName: "person")
        
        vc1.title = "Home"
        vc2.title = "New And Populer"
        vc3.title = "My Netflix"
        
        tabBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3], animated: true)
    }


}

