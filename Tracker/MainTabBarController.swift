
import UIKit

class MainTabBarController: UITabBarController {
    
    private let trackersVC = TrackersViewController()
    private let statsVC = StatisticViewController()
    
    private let trackersTabBarItemTitle = NSLocalizedString(
        "trackersTabBarItemTitle",
        comment: "")
    private let statisticsTabBarItemTitle = NSLocalizedString(
        "statisticsTabBarItemTitle",
        comment: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeTabBar()
    }
    
    func makeTabBar() {
        viewControllers = [createController(title: trackersTabBarItemTitle, 
                                            imageName: "trackers", vc: trackersVC),
                           createController(title: statisticsTabBarItemTitle,
                                            imageName: "stats", vc: statsVC)]
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
