//
//  CreateAccountSuccessViewController.swift
//  StudyGaemi
//
//  Created by Seungseop Lee on 6/4/24.
//

import UIKit
import SnapKit

class CreateAccountSuccessViewController: UIViewController {
    
    let mainImage = UIImageView()
    let mainLabel = UILabel()
    let goLoginButton = CustomButton(title: "로그인 하러가기")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        mainImageSetting()
        mainLabelSetting()
        goLoginButtonSetting()
    }
    
    func mainImageSetting() {
        mainImage.image = UIImage(named: "checker")
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImage)
        
        mainImage.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func mainLabelSetting() {
        mainLabel.text = "회원가입 완료!"
        mainLabel.font = UIFont(name: CustomFontType.bold.name, size: 24) ?? UIFont.systemFont(ofSize: 24)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImage.snp.bottom).offset(16)
        }
    }

    func goLoginButtonSetting() {
        view.addSubview(goLoginButton)
        goLoginButton.translatesAutoresizingMaskIntoConstraints = false
        goLoginButton.addTouchAnimation()
        goLoginButton.addTarget(self, action: #selector(goLoginButtonTapped), for: .touchUpInside)
        goLoginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-34)
            make.width.equalTo(342)
            make.height.equalTo(60)
        }
    }
    
    @objc func goLoginButtonTapped() {
        // 로그인 버튼이 탭되었을 때의 동작을 여기에 추가
        print("로그인 버튼이 탭되었습니다.")
        moveNextVC()
    }
    
    func moveNextVC() {
        let loginVC = LoginViewController()
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.modalPresentationStyle = .fullScreen

        // 현재 활성화된 씬을 통해 window를 가져와 rootViewController를 설정
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}
