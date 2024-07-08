
import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        if DetectLaunch.isFirst {
            window?.rootViewController = OnboardingViewController()
        } else {
            window?.rootViewController = MainTabBarController()
        }
        window?.makeKeyAndVisible()
     
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        DataStore.shared.saveContext()
        DetectLaunch.isFirst = false
    }
}

