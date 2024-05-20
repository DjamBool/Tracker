
import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let onboardingViewController = OnboardingViewController()
        onboardingViewController.onboardingHandler = { [weak self ] in
            let tabBarController = MainTabBarController()
            self?.window?.rootViewController = tabBarController
        }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = onboardingViewController//MainTabBarController()
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        DataStore.shared.saveContext()
    }
}

