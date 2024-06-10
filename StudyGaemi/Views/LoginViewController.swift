//
//  ViewController.swift
//  finalTemp1
//
//  Created by Seungseop Lee on 5/29/24.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    let loginImage = UIImageView()
    let emailTextField = CustomTextField(text: "E-mail")
    let passwordTextField = CustomTextField(text: "Password")
    let loginButton = CustomButton(title: "Login")
    let separatorView = UIView()
    let orLabel = UILabel()
    let appleLoginButton = UIButton()
    let kakaoLoginButton = UIButton()
    let signupLabel = UILabel()
    let createAccountButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        loginImageSetting()
        loginTextFieldSetting()
        loginButtonSetting()
        separatorViewSetting()
        orLabelSetting()
        socialLoginUI()
    }
    
    func orLabelSetting() {
        orLabel.text = "or"
        orLabel.textColor = .lightGray
        orLabel.backgroundColor = UIColor(named: "viewBackgroundColor")
        orLabel.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        orLabel.textAlignment = .center
        view.addSubview(orLabel)
        
        orLabel.snp.makeConstraints { make in
            make.centerY.equalTo(separatorView)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
        }
    }
    
    func separatorViewSetting() {
        separatorView.backgroundColor = UIColor.lightGray
        view.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(20.5)
            make.centerX.equalToSuperview()
            make.width.equalTo(335)
            make.height.equalTo(1)
        }
    }
    
    func loginImageSetting() {
        loginImage.image = UIImage(named: "heartAnt")
        view.addSubview(loginImage)
        
        loginImage.snp.makeConstraints { make in
            make.width.equalTo(208)
            make.height.equalTo(124)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(36)
        }
    }
    
    func socialLoginUI() {
        let loginButtonStackView = UIStackView(arrangedSubviews: [appleLoginButton, kakaoLoginButton])
        loginButtonStackView.axis = .vertical
        loginButtonStackView.spacing = 10
        loginButtonStackView.alignment = .center
        loginButtonStackView.distribution = .equalSpacing
        view.addSubview(loginButtonStackView)
        
        let signupStackView = UIStackView(arrangedSubviews: [signupLabel, createAccountButton])
        signupStackView.axis = .horizontal
        signupStackView.spacing = 10
        signupStackView.alignment = .center
        
        let mainStackView = UIStackView(arrangedSubviews: [loginButtonStackView, signupStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        view.addSubview(mainStackView)
        
        loginButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(41)
            make.centerX.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(41)
            make.centerX.equalToSuperview()
        }
        
        socialLoginButtonSetting()
        
        configureAppleLoginButton()
        configureKakaoLoginButton()
        configureSignupLabel()
        configureCreateAccountButton()
        
        // 애니메이션 추가
        appleLoginButton.addTouchAnimation()
        kakaoLoginButton.addTouchAnimation()
    }

    func loginTextFieldSetting() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        emailTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        passwordTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginImage.snp.bottom).offset(58)
            make.width.equalTo(342)
            make.height.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.width.equalTo(342)
            make.height.equalTo(60)
        }
    }
    
    func loginButtonSetting() {
        view.addSubview(loginButton)
        // 애니메이션 추가
        loginButton.addTouchAnimation()
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.width.equalTo(342)
            make.height.equalTo(60)
        }
        
        // 로그인 버튼에 액션 추가
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func socialLoginButtonSetting() {
        appleLoginButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.height.equalTo(14)
        }
    }
    
    func configureAppleLoginButton() {
        appleLoginButton.layer.cornerRadius = 12
        let backgroundImage = UIImage(named: "apple")
        appleLoginButton.setBackgroundImage(backgroundImage, for: .normal)
        appleLoginButton.layer.borderWidth = 1
        applyCommonSettings(to: appleLoginButton)
    }
    
    func configureKakaoLoginButton() {
        kakaoLoginButton.layer.cornerRadius = 12
        let backgroundImage = UIImage(named: "kakao")
        kakaoLoginButton.setBackgroundImage(backgroundImage, for: .normal)
        applyCommonSettings(to: kakaoLoginButton)
    }
    
    func configureSignupLabel() {
        signupLabel.text = "아직 회원이 아니신가요?"
        signupLabel.font = UIFont.systemFont(ofSize: 14)
        signupLabel.textColor = .black
        signupLabel.textAlignment = .right
    }
    
    func configureCreateAccountButton() {
        createAccountButton.setTitle("계정 생성", for: .normal)
        createAccountButton.setTitleColor(.orange, for: .normal)
        createAccountButton.titleLabel?.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        createAccountButton.contentHorizontalAlignment = .right
        
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.orange
        ]
        let attributedTitle = NSAttributedString(string: "계정 생성", attributes: attributes)
        createAccountButton.setAttributedTitle(attributedTitle, for: .normal)
        
        createAccountButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        // 버튼에 액션 추가
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
    }

    func applyCommonSettings(to button: UIButton) {
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.tintColor = .secondaryLabel
        button.setTitleColor(.black, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
    @objc func loginButtonTapped() {
        let bottomTabBarVC = BottomTabBarViewController()
//        let navigationController = UINavigationController(rootViewController: bottomTabBarVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.navigationController?.pushViewController(bottomTabBarVC, animated: true)

        // 현재 활성화된 씬을 통해 window를 가져와 rootViewController를 설정
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
    }
    
    @objc func createAccountButtonTapped() {
        moveNextVC()
    }
    
    func moveNextVC() {
        let createAccountVC = CreateAccountViewController()
        createAccountVC.modalPresentationStyle = .fullScreen
//        self.present(createAccountVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(createAccountVC, animated: true)
    }
}
