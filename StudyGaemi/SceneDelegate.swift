//
//  SceneDelegate.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import BackgroundTasks
import UIKit
import KakaoSDKAuth
import FirebaseAuth
import SnapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var isLogined = false

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let launchScreenView = LaunchScreenView()

        // Create a new UIWindow
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = launchScreenView
        window.makeKeyAndVisible()
        self.window = window

        if connectionOptions.notificationResponse == nil {
            // 로그인 상태 확인 및 적절한 ViewController 설정
            checkLogin()
        }
    }


    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {

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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
            if let url = URLContexts.first?.url {
                if url.scheme == "kakao\(apiKey)" {
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
            }
        }
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
            if isLogined == false {
                let bottomTabBarVC = BottomTabBarViewController()
                window.rootViewController = bottomTabBarVC
                isLogined = true
            }
            if let alarmQuestionView = self.createViewController(withIdentifier: identifier) {
                let navigationController = UINavigationController(rootViewController: alarmQuestionView)
                navigationController.modalPresentationStyle = .fullScreen
                window.rootViewController?.present(navigationController, animated: true, completion: nil)
            }
        } else {
            if let alarmQuestionView = self.createViewController(withIdentifier: identifier) {
                let navigationController = UINavigationController(rootViewController: alarmQuestionView)
                navigationController.modalPresentationStyle = .fullScreen
                window.rootViewController?.present(navigationController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - 특정 ViewController를 생성하는 메소드
    func createViewController(withIdentifier identifier: String) -> UIViewController? {
        if identifier == "AlarmQuestionView" {
            let data = AlarmCoreDataManager.shared.getAlarmData()
            let time = data.time
            let calendar = Calendar.current
            let currentDate = Date()
            
            let components = calendar.dateComponents([.minute], from: time, to: currentDate)
            if let minuteDifference = components.minute {
                if data.isRepeatEnabled {
                    for i in 0..<data.repeatCountInt {
                        let intervalTime = time.addingTimeInterval(TimeInterval(data.repeatIntervalMinutes * i * 60))
                        let intervalComponents = calendar.dateComponents([.minute], from: intervalTime, to: currentDate)
                        if let intervalMinuteDifference = intervalComponents.minute, intervalMinuteDifference >= 0, intervalMinuteDifference <= data.repeatIntervalMinutes + 2 {
                            return AlarmQuestionView()
                        }
                    }
                } else if minuteDifference >= 0, minuteDifference <= 2 {
                    return AlarmQuestionView()
                }
            }
        }
        return nil
    }
}

extension SceneDelegate {
    
    func checkLogin() {
        print("로그인 유저인지 확인")
        if let user = Auth.auth().currentUser {
            print("currentUser임")
            AuthenticationManager.shared.checkEmailVerifiedForLogin { isEmailVerified in
                if isEmailVerified {
                    self.isLogined = true
                    print("애플 또는 이메일 자동 로그인 성공: \(user.email ?? "")")
                    self.navigateToMainScreen()
                } else {
                    FirestoreManager.shared.getLoginMethod { loginMethod in
                        if loginMethod == "kakao" {
                            print("카카오 계정 로그인 성공")
                            self.isLogined = true
                            self.navigateToMainScreen()
                        } else {
                            print("카카오 계정 로그인 실패")
                            self.navigateToLoginScreen()
                        }
                    }
                }
            }
        } else {
            print("로그인 되어 있지 않음")
            self.navigateToLoginScreen()
        }
    }
    
    
    func navigateToMainScreen() {
        let bottomTabBarVC = BottomTabBarViewController()
        if let window = self.window {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
    }
    
    func navigateToLoginScreen() {
        let loginvC = LoginViewController()
        // LoginViewController가 rootViewController에 속해있지 않아서 화면 전환이 안되었던 것.
        // 아래처럼 포함시켜준 이후로는 잘 넘어가는 모습.
        let navController = UINavigationController(rootViewController: loginvC)
        if let window = self.window {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}
