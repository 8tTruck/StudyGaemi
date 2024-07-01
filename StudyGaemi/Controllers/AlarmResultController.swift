//
//  AlarmResultController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/10/24.
//

import UIKit

class AlarmResultController: BaseViewController {
    
    func moveToStudy(_ viewController: UIViewController) {
        if let tabBarController = viewController.presentingViewController as? UITabBarController {
            print(tabBarController)
            tabBarController.selectedIndex = 1 // 두번째 탭으로 이동
        }
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func moveToCalendar(_ viewController: UIViewController) {
        if let tabBarController = viewController.presentingViewController as? UITabBarController {
            print(tabBarController)
            tabBarController.selectedIndex = 2 // 세번째 탭으로 이동
        }
        viewController.dismiss(animated: true, completion: nil)
        
    }
}
