//
//  ButtomTabBarViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit
import SnapKit

class BottomTabBarViewController: UITabBarController {
    
    let customTabBarView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.configureUI()
        self.constraintLayout()
        self.configureTabBarItemFonts()
    }
    
    func setupTabBar() {
        // 탭바의 배경을 투명하게 만듦
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.isTranslucent = true
        
        customTabBarView.backgroundColor = UIColor(named: "tabBarBackground")
        customTabBarView.layer.cornerRadius = 16
        customTabBarView.layer.shadowColor = UIColor(named: "pointDarkgray")?.cgColor
        customTabBarView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        customTabBarView.layer.shadowRadius = 2.0
        customTabBarView.layer.shadowOpacity = 0.5
        
        // 탭바에 customTabBarView 추가
        self.tabBar.addSubview(customTabBarView)
        
        // 탭바 아이템의 위치 설정
        self.tabBar.itemWidth = 80
        self.tabBar.itemSpacing = 6
        self.tabBar.itemPositioning = .centered
        
        // 틴트 컬러 설정
        self.tabBar.tintColor = UIColor(named: "pointYellow")
    }
    
    func configureUI() {
        let alarmViewController = AlarmViewController()
        alarmViewController.tabBarItem.image = UIImage(systemName: "alarm")
        alarmViewController.tabBarItem.title = "기상하개미"
        
        let studyViewController = StudyViewController()
        studyViewController.tabBarItem.image = UIImage(systemName: "timer")
        studyViewController.tabBarItem.title = "공부하개미"
        
        let calendarViewController = CalendarViewController()
        calendarViewController.tabBarItem.image = UIImage(systemName: "calendar")
        calendarViewController.tabBarItem.title = "월간개미"
        
        let settingViewController = SettingViewController()
        settingViewController.tabBarItem.image = UIImage(systemName: "person")
        settingViewController.tabBarItem.title = "개Me"
        
        viewControllers = [alarmViewController, studyViewController, calendarViewController, settingViewController]
        
    }
    
    func constraintLayout() {
        customTabBarView.snp.makeConstraints { make in
            make.leading.equalTo(tabBar.snp.leading).offset(17)
            make.trailing.equalTo(tabBar.snp.trailing).offset(-17)
            make.height.equalTo(71)
            make.top.equalTo(self.tabBar.snp.top).offset(-11)
        }
    }
    
    func configureTabBarItemFonts() {
        let font = UIFont(name: CustomFontType.bold.name, size: 12) ?? UIFont.systemFont(ofSize: 12)
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(named: "tabBarItemColor") ?? UIColor.gray
        ]
        
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor(named: "pointYellow") ?? UIColor.yellow
        ]
        
        UITabBarItem.appearance().setTitleTextAttributes(normalAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedAttributes, for: .selected)
    }
}


