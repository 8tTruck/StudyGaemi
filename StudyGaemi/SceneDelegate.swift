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

        // 로그인 상태 확인 및 적절한 ViewController 설정
        checkLogin()
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
            let time = AlarmCoreDataManager.shared.getAlarmData().time
            let calendar = Calendar.current
            let currentDate = Date()
            
            let components = calendar.dateComponents([.minute], from: time, to: currentDate)
            if let minuteDifference = components.minute, minuteDifference >= 2 {
                return LoginViewController()
            } else {
                return AlarmQuestionView()
            }
        default:
            return LoginViewController()
        }
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
                    print("자동 로그인 실패. else 시작")
                    FirestoreManager.shared.getLoginMethod { loginMethod in
                        if loginMethod == "kakao" {
                            if AuthApi.hasToken() {
                                print("카카오 자동 로그인 성공")
                                self.isLogined = true
                                self.navigateToMainScreen()
                            } else {
                                self.navigateToLoginScreen()
                            }
                            
                        } else {
                            print("카카오 계정 이외의 알 수 없는 무언가")
                            self.navigateToLoginScreen()
                        }
                    }
                }
            }
        } else {
            print("최종 else 진입")
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
        let bottomTabBarVC = LoginViewController()
        if let window = self.window {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
    }
}
