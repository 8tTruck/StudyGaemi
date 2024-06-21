//
//  AlarmResultController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/10/24.
//

import UIKit

class AlarmResultController {
    
    func moveToStudy() {
        let bottomTabBarVC = BottomTabBarViewController()
        bottomTabBarVC.selectedIndex = 1
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
    }
    
    func moveToCalendar() {
        let bottomTabBarVC = BottomTabBarViewController.shared
        bottomTabBarVC.selectedIndex = 2
 
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
 
        
    }
}
