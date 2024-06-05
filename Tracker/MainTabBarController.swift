
import UIKit

class MainTabBarController: UITabBarController {
   
    private let colors = Colors()
    
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
        viewControllers = [
            createController(title: trackersTabBarItemTitle,
            imageName: "trackers",
            vc: trackersVC),
            createController(title:
            statisticsTabBarItemTitle,
            imageName: "stats",
            vc: statsVC)
        ]
        
      //  tabBar.barTintColor = .white
       // tabBar.layer.borderWidth = 1
       // tabBar.layer.borderColor = UIColor.systemGray5.cgColor
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        separator.backgroundColor = colors.viewColor
        tabBar.addSubview(separator)
    }
    
    private func createController(title: String, imageName: String, vc: UIViewController) -> UINavigationController {
        let recentVC = UINavigationController(rootViewController: vc)
        recentVC.tabBarItem.title = title
        recentVC.tabBarItem.image = UIImage(named: imageName)
        return recentVC
    }
    
}
