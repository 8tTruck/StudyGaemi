//
//  MakePasswordViewController.swift
//  StudyGaemi
//
//  Created by Seungseop Lee on 6/4/24.
//

import Firebase
import FirebaseAuth
import UIKit
import SnapKit

class MakePasswordViewController: UIViewController {
    
    let mainImage = UIImageView()
    var nicknameDescriptionLabel = UILabel()
    let nicknameTextField = CustomTextField(text: "사용할 닉네임을 입력하세요")
    var passwordDescriptionLabel = UILabel()
    let passwordTextField = CustomTextField(text: "사용할 비밀번호를 입력하세요")
    var passwordCheckDescriptionLabel = UILabel()
    let passwordCheckTextField = CustomTextField(text: "비밀번호를 다시 한 번 입력해주세요")
    let confirmButton = CustomButton(title: "계정 생성")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        mainImageSetting()
        nicknameDescriptionLabelSetting()
        nicknameTextFieldSetting()
        passwordDescriptionLabelSetting()
        passwordTextFieldSetting()
        passwordCheckDescriptionLabelSetting()
        passwordCheckTextFieldSetting()
        confirmButtonSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }
    
    func mainImageSetting() {
        mainImage.image = UIImage(named: "mainAnt")
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImage)
        
        mainImage.snp.makeConstraints { make in
            make.width.equalTo(120)
            make.height.equalTo(74)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(14)
        }
    }
    
    func nicknameDescriptionLabelSetting() {
        view.addSubview(nicknameDescriptionLabel)
        nicknameDescriptionLabel.text = "개미 이름을 입력해주세요 (2~8자)"
        nicknameDescriptionLabel.textColor = .lightGray
        nicknameDescriptionLabel.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        nicknameDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nicknameDescriptionLabel.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(25)
            make.leading.equalTo(mainImage.snp.leading).offset(-110)
            make.top.equalTo(mainImage.snp.bottom).offset(20)
        }
    }
    
    func nicknameTextFieldSetting() {
        view.addSubview(nicknameTextField)
        nicknameTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        nicknameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nicknameDescriptionLabel.snp.bottom).offset(4)
            make.width.equalTo(342)
            make.height.equalTo(50)
        }
    }

    func passwordDescriptionLabelSetting() {
        view.addSubview(passwordDescriptionLabel)
        passwordDescriptionLabel.text = "비밀번호를 입력해주세요 (영문,숫자 포함 8자리 이상)"
        passwordDescriptionLabel.textColor = .lightGray
        passwordDescriptionLabel.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        passwordDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameDescriptionLabel.snp.leading)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
        }
    }
    
    func passwordTextFieldSetting() {
        view.addSubview(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordDescriptionLabel.snp.bottom).offset(4)
            make.width.equalTo(342)
            make.height.equalTo(50)
        }
    }
    
    func passwordCheckDescriptionLabelSetting() {
        view.addSubview(passwordCheckDescriptionLabel)
        passwordCheckDescriptionLabel.text = "비밀번호를 다시 한 번 입력해주세요"
        passwordCheckDescriptionLabel.textColor = .lightGray
        passwordCheckDescriptionLabel.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        passwordCheckDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordCheckDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameDescriptionLabel.snp.leading)
            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
        }
    }
    
    func passwordCheckTextFieldSetting() {
        view.addSubview(passwordCheckTextField)
        passwordCheckTextField.isSecureTextEntry = true
        passwordCheckTextField.textContentType = .oneTimeCode
        passwordCheckTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordCheckDescriptionLabel.snp.bottom).offset(4)
            make.width.equalTo(342)
            make.height.equalTo(50)
        }
    }
    
    func confirmButtonSetting() {
        view.addSubview(confirmButton)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordCheckTextField.snp.bottom).offset(16)
            make.width.equalTo(342)
            make.height.equalTo(60)
        }
    }

    @objc func confirmButtonTapped() {
                
        confirmButton.addTouchAnimation()
        
        var isValid = true
        
        // 닉네임이 비어있거나, 2자 미만, 8자 초과일 경우.
        if let nickname = nicknameTextField.text, nickname.count >= 2, nickname.count <= 100 {
            // 닉네임 조건을 만족하는 경우
            setCorrect(for: nicknameTextField, label: nicknameDescriptionLabel)
        } else {
            // 닉네임 조건을 만족하지 않는 경우
            setFailed(for: nicknameTextField, label: nicknameDescriptionLabel)
            isValid = false
        }
        
        // 비밀번호가 비어있는 경우
        if let password = passwordTextField.text, password.isEmpty {
            // 비밀번호가 비어있는 경우의 처리
            setFailed(for: passwordTextField, label: passwordDescriptionLabel)
            setFailed(for: passwordCheckTextField, label: passwordCheckDescriptionLabel)
            isValid = false
        } else {
            // 비밀번호가 비어있지 않은 경우의 처리
            setCorrect(for: passwordTextField, label: passwordDescriptionLabel)
        }
        
        // 비밀번호 확인이 비어있는 경우
        if let confirmPassword = passwordCheckTextField.text, confirmPassword.isEmpty {
            // 확인 비밀번호가 비어있는 경우의 처리
            setFailed(for: passwordCheckTextField, label: passwordCheckDescriptionLabel)
            isValid = false
        } else {
            // 확인 비밀번호가 비어있지 않은 경우의 처리
            setCorrect(for: passwordCheckTextField, label: passwordCheckDescriptionLabel)
        }
        
        guard let password = passwordTextField.text else {
            setFailed(for: passwordTextField, label: passwordDescriptionLabel)
            isValid = false
            return
        }
        
        guard let confirmPassword = passwordCheckTextField.text else {
            setFailed(for: passwordCheckTextField, label: passwordCheckDescriptionLabel)
            isValid = false
            return
        }
        
        guard isValidPassword(password) else {
            // 비밀번호가 유효하지 않은 경우
            setFailed(for: passwordTextField, label: passwordDescriptionLabel)
            isValid = false
            return
        }
        
        guard password == confirmPassword else {
            // 비밀번호와 확인 비밀번호가 일치하지 않는 경우
            setFailed(for: passwordCheckTextField, label: passwordCheckDescriptionLabel)
            isValid = false
            return
        }
        
        if isValid {
            // 모든 조건을 만족하여 유효한 경우
            moveNextVC()
        }
    }

    func setCorrect(for textField: UITextField, label: UILabel) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(named: "navigationBarLine")?.cgColor ?? UIColor.gray.cgColor
        label.textColor = .lightGray // 성공 시 텍스트 색상 변경
    }

    func setFailed(for textField: UITextField, label: UILabel) {
        textField.shake()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.red.cgColor
        label.textColor = .red // 실패 시 텍스트 색상 변경
    }

    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func moveNextVC() {
        let emailConfirmVC = EmailConfirmViewController()
        emailConfirmVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(emailConfirmVC, animated: true)
//        let createAccountSuccessVC = CreateAccountSuccessViewController()
//        createAccountSuccessVC.modalPresentationStyle = .fullScreen
////        present(createAccountSuccessVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(createAccountSuccessVC, animated: true)
        guard let email = nicknameTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // 입력 필드가 비어있는 경우 처리
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // 회원가입 실패 처리
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    print("Login failed: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    print("Login successful: \(user.email ?? "")")
                }
            }
            
            // 이메일 인증 코드 전송
            authResult?.user.sendEmailVerification { error in
                if let error = error {
                    // 이메일 인증 코드 전송 실패 처리
                    print("Error sending email verification: \(error.localizedDescription)")
                    return
                }
                
                // 이메일 인증 코드 전송 성공 처리
                print("Email verification code sent")
            }
        }
    }
    
}
