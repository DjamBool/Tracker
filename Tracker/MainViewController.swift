//
//  ViewController.swift
//  Tracker
//
//  Created by Игорь Мунгалов on 27.11.2023.
//

import UIKit

class MainViewController: UIViewController {

    let trackerViewController = TrackersViewController()
    let statisticViewController = StatisticViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        setupControllers()
    }
    func setupControllers() {
        let trackerVC = UINavigationController(rootViewController: trackerViewController)
        trackerVC.tabBarItem.title = "Трекеры"
        trackerVC.tabBarItem.image = UIImage(named: "trackers")
        
        let statsVC = UINavigationController(rootViewController: statisticViewController)
        trackerVC.tabBarItem.title = "Статистика"
        trackerVC.tabBarItem.image = UIImage(named: "stats")
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [trackerVC, statsVC]
    }
}

