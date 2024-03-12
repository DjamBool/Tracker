//
//  MainTabBarViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 28.11.2023.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    private let trackersVC = TrackersViewController()
    private let statsVC = StatisticViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeTabBar()
    }
    
    func makeTabBar() {
        viewControllers = [createController(title: "Трекеры", imageName: "trackers", vc: trackersVC), createController(title: "Cтатистика", imageName: "stats", vc: statsVC)]
        tabBar.barTintColor = .white
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    private func createController(title: String, imageName: String, vc: UIViewController) -> UINavigationController {
        let recentVC = UINavigationController(rootViewController: vc)
        recentVC.tabBarItem.title = title
        recentVC.tabBarItem.image = UIImage(named: imageName)
        return recentVC
    }
    
}
