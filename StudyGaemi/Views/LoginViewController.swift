//
//  ViewController.swift
//  finalTemp1
//
//  Created by Seungseop Lee on 5/29/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    // 버튼 생성
    let appleLoginButton = UIButton()
    let kakaoLoginButton = UIButton()
    let signupLabel = UILabel()
    let createAccountButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLoginUI()
    }
    
    func configureLoginUI() {
        // 버튼 추가 및 레이아웃 설정
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
            mainStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 29),
            mainStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -29),
            mainStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -209),
            
//            loginButtonStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 470) // 수정된 부분
        ])
        
        loginButtonAutoLayoutSetting()
        
        // 버튼 설정
        configureAppleLoginButton()
        configureKakaoLoginButton()
        configureSignupLabel()
        configureCreateAccountButton()
        
        // 버튼에 애니메이션 추가
        addAnimation(to: appleLoginButton)
        addAnimation(to: kakaoLoginButton)
    }

    
    func loginButtonAutoLayoutSetting() {
        NSLayoutConstraint.activate([
            appleLoginButton.widthAnchor.constraint(equalToConstant: 335),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 52),
            kakaoLoginButton.widthAnchor.constraint(equalToConstant: 335),
            kakaoLoginButton.heightAnchor.constraint(equalToConstant: 52),
            createAccountButton.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func configureAppleLoginButton() {
        // 이미지 설정
        if let image = UIImage(named: "apple") {
            let scaledImage = image.resized(to: CGSize(width: 20, height: 20))
            appleLoginButton.setImage(scaledImage, for: .normal)
        }
        appleLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        // 나머지 버튼 설정
        appleLoginButton.setTitle("Sign in with Apple", for: .normal)
        appleLoginButton.setTitleColor(.black, for: .normal)
        appleLoginButton.layer.cornerRadius = 22
        appleLoginButton.layer.borderColor = UIColor.lightGray.cgColor
        appleLoginButton.layer.borderWidth = 1
        appleLoginButton.backgroundColor = .white
        applyCommonSettings(to: appleLoginButton)
    }
    
    func configureKakaoLoginButton() {
        // 이미지 설정
        if let image = UIImage(named: "kakao") {
            let scaledImage = image.resized(to: CGSize(width: 20, height: 20))
            kakaoLoginButton.setImage(scaledImage, for: .normal)
        }
        kakaoLoginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        // 나머지 버튼 설정
        kakaoLoginButton.setTitle("카카오로 3초만에 시작하기", for: .normal)
        kakaoLoginButton.setTitleColor(.black, for: .normal)
        kakaoLoginButton.layer.cornerRadius = 22
        kakaoLoginButton.layer.borderColor = UIColor.lightGray.cgColor
        kakaoLoginButton.layer.borderWidth = 1
        kakaoLoginButton.backgroundColor = .yellow
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
        createAccountButton.setTitleColor(.orange, for: .normal) // 텍스트 색상 변경
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createAccountButton.contentHorizontalAlignment = .right
        
        // 텍스트에 밑줄 추가
        let attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.orange // 밑줄 색상 변경
        ]
        let attributedTitle = NSAttributedString(string: "계정 생성", attributes: attributes)
        createAccountButton.setAttributedTitle(attributedTitle, for: .normal)
        
        // Auto Layout 제약 추가
        createAccountButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    
    // 공통 설정 메서드
    func applyCommonSettings(to button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.tintColor = .secondaryLabel
        button.setTitleColor(.black, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
    // 버튼에 애니메이션 추가하는 메서드
    func addAnimation(to button: UIButton) {
        button.addTarget(self, action: #selector(buttonTouchDown(sender:)), for: .touchDown)
        button.addTarget(self, action: #selector(buttonTouchUp(sender:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc func buttonTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc func buttonTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
    }
}

extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let size = self.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // 이미지의 비율 유지
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
}
