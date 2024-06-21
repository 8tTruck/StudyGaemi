//
//  AppDelegate.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import AVFoundation
import BackgroundTasks
import FirebaseCore
import UserNotifications
import UIKit
import CoreData
import FirebaseAppCheck
import KakaoSDKCommon
import KakaoSDKAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Firebase 공유 인스턴스 구성 하는 부분과 등록 토큰 수신을 위해 메시지 delegate를 설정
        FirebaseApp.configure()
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "86a4ac0a6c62845182e5b5745722c617")
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("알림 권한이 수락되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }

        AlarmSettingController.shared.removeNotification()
        AlarmCoreDataManager.shared.fetchAlarm()
        AudioController.shared.setupAudioSession()
        
        UINavigationBar.appearance().tintColor = .pointOrange
        
        //Appcheck 인증제공자 설정
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)

        return true
    }
    
    // URL 스킴을 통해 앱이 열릴 때 호출되는 메소드
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "kakao86a4ac0a6c62845182e5b5745722c617" {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                return AuthController.handleOpenUrl(url: url)
            }
        }
        return false
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // 로컬 알림 내용 설정
        let content = UNMutableNotificationContent()
        content.title = "⏰ 공부하개미를 다시 켜 주세요 ⏰"
        content.body = "공부하개미를 종료하면 공부타이머와 알람이 정상적으로 동작하지 않습니다."
        content.sound = .default

        // 트리거 시간 설정 (예: 1초 후)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: "terminateNotification", content: content, trigger: trigger)

        // 알림 센터에 추가
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "StudyGaemi")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // MARK: - 포그라운드에서도 알림을 받게하는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("포그라운드 알림 수신: \(notification.request.content.body)")
        let userInfo = notification.request.content.userInfo
        if let viewControllerIdentifier = userInfo["viewControllerIdentifier"] as? String {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.navigateToViewController(withIdentifier: viewControllerIdentifier)
            }
        }
        if let messageID = userInfo["viewControllerIdentifier"] {
            print("MessageId: \(messageID)")
        }
    }
    
    // MARK: - 알림을 터치했을 때 호출되는 메소드
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let viewControllerIdentifier = userInfo["viewControllerIdentifier"] as? String {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.navigateToViewController(withIdentifier: viewControllerIdentifier)
            }
        }
        completionHandler()
    }
}

