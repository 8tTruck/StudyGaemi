//
//  ViewController.swift
//  finalTemp1
//
//  Created by Seungseop Lee on 5/29/24.
//

import UIKit

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
        view.backgroundColor = .white
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
        orLabel.backgroundColor = .white
        orLabel.font = .systemFont(ofSize: 16, weight: .regular)
        orLabel.textAlignment = .center
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(orLabel)
        
        NSLayoutConstraint.activate([
            orLabel.centerYAnchor.constraint(equalTo: separatorView.centerYAnchor),
            orLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            orLabel.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func separatorViewSetting() {
        separatorView.backgroundColor = UIColor.lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorView)

        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20.5),
            separatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorView.widthAnchor.constraint(equalToConstant: 335),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func loginImageSetting() {
        loginImage.image = UIImage(named: "heartAnt")
        loginImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginImage)
        
        NSLayoutConstraint.activate([
            loginImage.widthAnchor.constraint(equalToConstant: 208),
            loginImage.heightAnchor.constraint(equalToConstant: 124),
            loginImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 58)
        ])
    }
    
    func socialLoginUI() {
        let loginButtonStackView = UIStackView(arrangedSubviews: [appleLoginButton, kakaoLoginButton])
        loginButtonStackView.axis = .vertical
        loginButtonStackView.spacing = 10
        loginButtonStackView.alignment = .center
        loginButtonStackView.distribution = .equalSpacing
        loginButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let signupStackView = UIStackView(arrangedSubviews: [signupLabel, createAccountButton])
        signupStackView.axis = .horizontal
        signupStackView.spacing = 10
        signupStackView.alignment = .center
        
        let mainStackView = UIStackView(arrangedSubviews: [loginButtonStackView, signupStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.alignment = .center
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(mainStackView)
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 41),
            mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
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
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: loginImage.bottomAnchor, constant: 58),
            emailTextField.widthAnchor.constraint(equalToConstant: 342),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 12),
            passwordTextField.widthAnchor.constraint(equalToConstant: 342),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func loginButtonSetting() {
        view.addSubview(loginButton)
        // 애니메이션 추가
        loginButton.addTouchAnimation()
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12),
            loginButton.widthAnchor.constraint(equalToConstant: 342),
            loginButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func socialLoginButtonSetting() {
        NSLayoutConstraint.activate([
            appleLoginButton.widthAnchor.constraint(equalToConstant: 300),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 45),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 300),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 45),
            createAccountButton.heightAnchor.constraint(equalToConstant: 14)
        ])
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
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
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
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.tintColor = .secondaryLabel
        button.setTitleColor(.black, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
    @objc func createAccountButtonTapped() {
        let createAccountVC = CreateAccountViewController()
        createAccountVC.modalPresentationStyle = .fullScreen
        self.present(createAccountVC, animated: true, completion: nil)
    }
}
