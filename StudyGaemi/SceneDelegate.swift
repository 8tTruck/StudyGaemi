//
//  SceneDelegate.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let bottomTabBarController = BottomTabBarViewController()
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = bottomTabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

extension SceneDelegate {
    
    
    
    // MARK: - 특정 ViewController로 이동하는 메소드
    func navigateToViewController(withIdentifier identifier: String) {
        guard let window = window else {
            print("window없음")
            return
        }
        
        let rootViewController = window.rootViewController as? UINavigationController
        
        if rootViewController == nil {
            // 네비게이션 컨트롤러가 없는 경우, 새로운 네비게이션 컨트롤러를 생성하여 설정
            let navController = UINavigationController(rootViewController: createViewController(withIdentifier: identifier))
            window.rootViewController = navController
        } else {
            // 네비게이션 컨트롤러가 있는 경우, 해당 네비게이션 컨트롤러를 통해 푸시
            rootViewController?.pushViewController(createViewController(withIdentifier: identifier), animated: true)
        }
    }
    
    // MARK: - 특정 ViewController를 생성하는 메소드
    private func createViewController(withIdentifier identifier: String) -> UIViewController {
        switch identifier {
        case "AlarmQuestionView":
            return AlarmQuestionView()
        default:
            return AlarmViewController()
        }
    }
}
