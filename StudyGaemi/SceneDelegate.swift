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

        let launchScreenVC = LaunchScreenViewController()

        // Create a new UIWindow
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = launchScreenVC
        window.makeKeyAndVisible()
        self.window = window

        // 로그인 상태 확인 및 적절한 ViewController 설정
        checkLogin()
        
        func checkLogin() {
            print("로그인 유저인지 확인")
            if let user = Auth.auth().currentUser {
                print("currentUser임")
                AuthenticationManager.shared.checkEmailVerifiedForLogin { isEmailVerified in
                    if isEmailVerified {
                        self.isLogined = true
                        print("애플 또는 이메일 자동 로그인 성공: \(user.email ?? "")")
                        navigateToMainScreen()
                    } else {
                        print("자동 로그인 실패. else 시작")
                        FirestoreManager.shared.getLoginMethod { loginMethod in
                            if loginMethod == "kakao" {
                                print("카카오 계정임")
                                self.isLogined = true
                                navigateToMainScreen()
                            } else {
                                print("카카오 계정 이외의 알 수 없는 무언가")
                                navigateToLoginScreen()
                            }
                        }
                    }
                }
            } else {
                print("최종 else 진입")
                navigateToLoginScreen()
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

class LaunchScreenViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "launchScreenColor")
        
        // Logo ImageView
        let logo = UIImageView(image: UIImage(named: "logo")) // 이미지 이름을 넣어주세요
        view.addSubview(logo)
        
        // Label
        let label = UILabel()
        label.text = "공부하개미"
        label.font = UIFont(name: "Pretendard-Medium", size: 30) // 폰트 및 사이즈 설정
        label.textColor = UIColor(named: "launchScreenFontColor")
        label.textAlignment = .center
        view.addSubview(label)
        
        let company = UILabel()
        company.text = "Ⓒ 8tTruck"
        company.font = UIFont(name: "Pretendard-Medium", size: 16)
        company.textColor = UIColor(named: "launchScreenFontColor")
        company.textAlignment = .center
        view.addSubview(company)
        
        // SnapKit을 사용하여 Auto Layout 설정
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 화면 가운데에 위치
            make.centerY.equalToSuperview().offset(-50) // 세로 중앙에서 위로 50 포인트 이동
            make.width.equalTo(view.snp.width).multipliedBy(0.5) // 화면 너비의 50%
            make.height.equalTo(logo.snp.width).multipliedBy(1.0) // 가로세로 비율 1:1로 유지
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(10) // 로고 아래에서 20 포인트 떨어진 곳에 위치
        }
        
        company.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
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
