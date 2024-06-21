//
//  ButtomTabBarViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit
import SnapKit

class BottomTabBarViewController: UITabBarController {
    
    private let customTabBarView = UIView()
    		
    private var originalImages: [UIImage?] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTabBar()
        self.configureUI()
        self.constraintLayout()
        self.configureTabBarItemFonts()
        self.setupTabBarItems()
    }
    
    private func setupTabBar() {
        // 탭바의 배경을 투명하게 만듦
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        self.tabBar.isTranslucent = true
        
        customTabBarView.backgroundColor = UIColor(named: "tabBarBackground")
        customTabBarView.layer.cornerRadius = 16
        
        // 탭바에 customTabBarView 추가
        self.tabBar.addSubview(customTabBarView)
        
        // 탭바 아이템의 위치 설정
        self.tabBar.itemWidth = 80
        self.tabBar.itemSpacing = 6
        self.tabBar.itemPositioning = .centered
        
        // 틴트 컬러 설정
        self.tabBar.tintColor = UIColor(named: "pointYellow")
    }
    
    private func configureUI() {
        let alarmImage = UIImage(systemName: "alarm")?.resized(to: CGSize(width: 30, height: 30)) // 초기 크기 설정
        let studyImage = UIImage(systemName: "timer")?.resized(to: CGSize(width: 30, height: 30)) // 초기 크기 설정
        let calendarImage = UIImage(systemName: "calendar")?.resized(to: CGSize(width: 30, height: 30)) // 초기 크기 설정
        let settingImage = UIImage(systemName: "person")?.resized(to: CGSize(width: 30, height: 30)) // 초기 크기 설정
        
        originalImages = [alarmImage, studyImage, calendarImage, settingImage]
        
        let alarmViewController = UINavigationController(rootViewController: AlarmViewController())
        alarmViewController.tabBarItem = UITabBarItem(title: "기상하개미", image: alarmImage, tag: 0)
        
        let studyViewController = UINavigationController(rootViewController: SettingTimerVC())
        studyViewController.tabBarItem = UITabBarItem(title: "공부하개미", image: studyImage, tag: 1)
        
        let calendarViewController = UINavigationController(rootViewController: CalendarViewController())
        calendarViewController.tabBarItem = UITabBarItem(title: "월간개미", image: calendarImage, tag: 2)
        
        let settingViewController = UINavigationController(rootViewController: SettingViewController())
        settingViewController.tabBarItem = UITabBarItem(title: "개Me", image: settingImage, tag: 3)
        
        viewControllers = [alarmViewController, studyViewController, calendarViewController, settingViewController]
    }
    
    private func constraintLayout() {
        customTabBarView.snp.makeConstraints { make in
            make.leading.equalTo(tabBar.snp.leading).offset(17)
            make.trailing.equalTo(tabBar.snp.trailing).offset(-17)
            make.height.equalTo(71)
            make.top.equalTo(self.tabBar.snp.top).offset(-11)
        }
    }
    
    private func configureTabBarItemFonts() {
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
    
    private func setupTabBarItems() {
        guard let tabBarItems = tabBar.items else { return }
        
        for (index, item) in tabBarItems.enumerated() {
            if let originalImage = originalImages[index] {
                item.image = originalImage
            }
        }
    }
    
    // 탭바 아이템 선택 시 처리
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item) else { return }
        
        if let originalImage = originalImages[index] {
            item.image = originalImage.highlightedImage(to: CGSize(width: 30, height: 30)) // 터치 시 크기 조정된 이미지 설정
            
            // 0.3초 뒤에 원래 이미지로 돌아오기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                item.image = originalImage
            }
        }
    }
}

extension UIImage {
    func resized(to newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func highlightedImage(to size: CGSize) -> UIImage? {
        let scaledSize = CGSize(width: size.width * 1.2, height: size.height * 1.2) // 1.2배 크기로 설정
        return resized(to: scaledSize)
    }
}
