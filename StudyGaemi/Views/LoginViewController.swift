//
//  ViewController.swift
//  finalTemp1
//
//  Created by Seungseop Lee on 5/29/24.
//

import UIKit
import SnapKit
import Firebase
import FirebaseFirestore
import AuthenticationServices
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, UITextFieldDelegate {
    
    var firestore: Firestore!
    let db = Firestore.firestore()
    
    let offImage = UIImage(named: "checkboxOff")
    let onImage = UIImage(named: "checkboxOn")
    
    let loginImage = UIImageView()
    let emailTextField = CustomTextField(text: "E-mail")
    let passwordTextField = CustomTextField(text: "Password")
//    let autoLoginButton = UIButton()
//    let autoLoginLabel = UILabel()
    let loginButton = CustomButton(title: "Login")
    let findIDButton = UIButton()
    let findPWButton = UIButton()
    let separatorView = UIView()
    let orLabel = UILabel()
//    let loginAppleButton = ASAuthorizationAppleIDButton(type: .default, style: .black)
    let appleLoginButton = UIButton()
    let kakaoLoginButton = UIButton()
    let signupLabel = UILabel()
    let createAccountButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autoLogin()
        hideKeyboardWhenTappedAround()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func autoLogin() {
        if let user = Auth.auth().currentUser {
            AuthenticationManager.shared.checkEmailVerifiedForLogin { isEmailVerified in
                if isEmailVerified {
                    print("자동 로그인 성공: \(user.email ?? "")")
                    self.navigateToMainScreen()
                } else {
                    FirestoreManager.shared.getLoginMethod { loginMethod in
                        if loginMethod == "kakao" {
                            self.navigateToMainScreen()
                        } else {
                            self.navigateToLoginScreen()
                        }
                    }
                }
            }
        } else {
            navigateToLoginScreen()
        }
    }
    
    func showEmailVerificationAlert() {
        let alert = UIAlertController(title: "이메일 인증 필요", message: "이메일 인증이 필요합니다. 이메일을 확인해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func navigateToMainScreen() {
        moveToBottomTabBarController()
    }
    
    func navigateToLoginScreen() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        loginImageSetting()
        loginTextFieldSetting()
//        autoLoginSetting()
        loginButtonSetting()
//        loginAppleButtonSetting()
        findAccountSetting()
        createAccountSetting()
        separatorViewSetting()
        orLabelSetting()
        appleLoginButtonSetting()
        kakaoLoginButtonSetting()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            // nicknameTextField에서 리턴 키를 눌렀을 때 passwordTextField로 이동
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            // passwordCheckTextField에서 리턴 키를 눌렀을 때 키보드 숨기기
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
//    FirestoreManager.shared.createUserData(email: email, nickName: email, loginMethod: "apple")
//    AuthenticationManager.shared.createUser(email: email, password: password)
    
    @objc func appleLoginButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }

    //    func loginAppleButtonSetting() {
    //        view.addSubview(loginAppleButton)
    //        loginAppleButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    //    }

    // MARK: - ASAuthorizationControllerDelegate Methods
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        print("인증 완료: \(authorization)")
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("애플 ID 자격 증명 수신")
            
            guard let identityTokenData = appleIDCredential.identityToken else {
                print("ID 토큰을 가져올 수 없음")
                return
            }
            
            guard let identityTokenString = String(data: identityTokenData, encoding: .utf8) else {
                print("ID 토큰을 문자열로 변환할 수 없음")
                return
            }
            
            // 사용자 고유 식별자
            let userIdentifier = appleIDCredential.user
            
            // 이메일
            let email = appleIDCredential.email ?? "\(userIdentifier)@example.com"
            
            // 이메일을 기반으로 닉네임 가져오기
            AuthenticationManager.shared.readUserNickName(email: email) { result in
                switch result {
                case .success(let nickName):
                    // Firebase로 애플 사용자 인증
                    let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: identityTokenString, rawNonce: nil)
                    
                    // Firestore에 사용자 데이터 생성
                    AuthenticationManager.shared.signInWithApple(credential: credential, email: email, nickName: nickName) { result in
                        switch result {
                        case .success(_):
                            self.navigateToMainScreen()
                        case .failure(let error):
                            print(error)
                        }
                    }
                    
                case .failure(let error):
                    // 에러 처리
                    print("Error retrieving nickname: \(error)")
                }
            }
            
        } else {
            print("인증 자격 증명이 ASAuthorizationAppleIDCredential 타입이 아님")
        }
    }


    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 오류 처리
        print("인증 실패: \(error.localizedDescription)")
    }

    // MARK: - ASAuthorizationControllerPresentationContextProviding Methods

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }


    
    func loginImageSetting() {
        loginImage.image = UIImage(named: "heartAnt")
        view.addSubview(loginImage)
        
        loginImage.snp.makeConstraints { make in
//            make.width.equalTo(208)
//            make.height.equalTo(124)
            make.width.equalToSuperview().multipliedBy(0.6) // 슈퍼뷰 너비의 80%
            make.height.equalTo(loginImage.snp.width).multipliedBy(1 / 1.6) // 가로세로 비율 1.8:1 유지
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
    }
    
    func loginTextFieldSetting() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        
        emailTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        passwordTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginImage.snp.bottom).offset(28)
//            make.width.equalTo(342)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(60)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
//            make.width.equalTo(342)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(60)
        }
    }
    
//    func autoLoginSetting() {
//        view.addSubview(autoLoginButton)
//        view.addSubview(autoLoginLabel)
//        
//        autoLoginButton.setImage(offImage, for: .normal)
//        autoLoginButton.addTarget(self, action: #selector(autoLoginButtonTapped), for: .touchUpInside)
//        autoLoginLabel.text = "자동 로그인"
//        autoLoginLabel.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
//        
//        autoLoginButton.snp.makeConstraints { make in
//            make.top.equalTo(passwordTextField.snp.bottom).offset(10)
//            make.leading.equalTo(passwordTextField.snp.leading)
//            make.height.equalTo(40)
//            make.width.equalTo(40)
//        }
//        
//        autoLoginLabel.snp.makeConstraints { make in
//            make.leading.equalTo(autoLoginButton.snp.trailing)
//            make.centerY.equalTo(autoLoginButton.snp.centerY)
//        }
//    }
    
    func loginButtonSetting() {
        view.addSubview(loginButton)
        // 애니메이션 추가
        loginButton.addTouchAnimation()
        
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
//            make.width.equalTo(342)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(60)
        }
        
        // 로그인 버튼에 액션 추가
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    func findAccountSetting() {
        let findAccountStackView = UIStackView(arrangedSubviews: [findIDButton, findPWButton])
        findAccountStackView.axis = .horizontal
        findAccountStackView.spacing = 16
        findAccountStackView.alignment = .center
        view.addSubview(findAccountStackView)

        findIDButton.setTitle("ID 찾기", for: .normal)
        findIDButton.setTitleColor(.gray, for: .normal)
        findIDButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        let findIDAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.gray
        ]
        let findIDAttributedTitle = NSAttributedString(string: "ID 찾기", attributes: findIDAttributes)
        findIDButton.setAttributedTitle(findIDAttributedTitle, for: .normal)
        findIDButton.addTarget(self, action: #selector(findIDButtonTapped), for: .touchUpInside)
        
        findPWButton.setTitle("비밀번호 찾기", for: .normal)
        findPWButton.setTitleColor(.gray, for: .normal)
        findPWButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        let findPWAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor.gray
        ]
        let findPWAttributedTitle = NSAttributedString(string: "비밀번호 찾기", attributes: findPWAttributes)
        findPWButton.setAttributedTitle(findPWAttributedTitle, for: .normal)
        findPWButton.addTarget(self, action: #selector(findPWButtonTapped), for: .touchUpInside)
        
        findAccountStackView.snp.makeConstraints { make in
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    
    @objc func findIDButtonTapped() {
        let alert = UIAlertController(title: "ID 찾기", message: "이메일 주소를 입력해 주세요.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "E-mail"
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self?.showAlert(message: "이메일 주소를 입력해 주세요.")
                return
            }
            
            self?.emailCheck(email: email) { isAvailable in
                if isAvailable {
                    self?.showAlert(message: "데이터 중복 안 됨, 가입 진행 가능")
                } else {
                    self?.showAlert(message: "데이터 중복 됨, 가입 진행 불가")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    
    func emailCheck(email: String, completion: @escaping (Bool) -> Void) {
        let userDB = db.collection("User")
        let query = userDB.whereField("email", isEqualTo: email)
        query.getDocuments { (qs, err) in
            if let error = err {
                print("Firebase 오류: \(error.localizedDescription)")
                completion(false)
            }
            
            if let documents = qs?.documents, documents.isEmpty {
                print("데이터 중복 안 됨, 가입 진행 가능")
                completion(true)
            } else {
                print("데이터 중복 됨, 가입 진행 불가")
                completion(false)
            }
        }
    }

    
//    @objc func findIDButtonTapped() {
//        let alert = UIAlertController(title: "ID 찾기", message: "이메일 주소를 입력해 주세요.", preferredStyle: .alert)
//        alert.addTextField { textField in
//            textField.placeholder = "E-mail"
//        }
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
//            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
//                self?.showAlert(message: "이메일 주소를 입력해 주세요.")
//                return
//            }
//            
//            // 이메일이 서버에 존재하는지 확인
//            AuthenticationManager.shared.checkIfUserExists(email: email) { [weak self] exists in
//                guard let self = self else { return }
//                
//                if exists {
//                    // 이미 가입된 계정이 있는 경우
//                    self.showAlert(message: "해당 이메일로 이미 가입된 계정이 존재합니다.")
//                    print("LoginVC : 해당 이메일로 가입된 계정이 있습니다.")
//                } else {
//                    // 가입된 계정이 없는 경우
//                    self.showAlert(message: "해당 이메일로 가입된 계정을 찾을 수 없습니다.")
//                    print("LoginVC : 해당 이메일로 가입된 계정이 없습니다.")
//                }
//            }
//        }))
//        present(alert, animated: true, completion: nil)
//    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }



    
    @objc func findPWButtonTapped() {
        let alert = UIAlertController(title: "비밀번호 찾기", message: "이메일 주소를 입력해 주세요.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "E-mail"
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self?.showAlert(message: "이메일 주소를 입력해 주세요.")
                return
            }
            AuthenticationManager.shared.resetPassword(email: email) { success, error in
                if success {
                    self?.showAlert(message: "비밀번호 재설정 이메일을 보냈습니다.")
                } else {
                    self?.showAlert(message: "비밀번호 재설정 이메일을 보내지 못했습니다. \(error ?? "")")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    
    func createAccountSetting() {
        // 스택뷰 생성 및 설정
        let createAccountStackView = UIStackView(arrangedSubviews: [signupLabel, createAccountButton])
        createAccountStackView.axis = .horizontal
        createAccountStackView.spacing = 10
        createAccountStackView.alignment = .center
        view.addSubview(createAccountStackView)
        
        // 스택뷰 제약 조건 설정
        createAccountStackView.snp.makeConstraints { make in
            make.top.equalTo(findIDButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        // signupLabel 설정
        signupLabel.text = "아직 회원이 아니신가요?"
        signupLabel.font = UIFont.systemFont(ofSize: 14)
        signupLabel.textColor = .fontGray
        signupLabel.textAlignment = .right
        
        // createAccountButton 설정
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
    
    func separatorViewSetting() {
        separatorView.backgroundColor = UIColor.lightGray
        view.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(signupLabel.snp.bottom).offset(20.5)
            make.centerX.equalToSuperview()
//            make.width.equalTo(335)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
    }
    
    func orLabelSetting() {
        orLabel.text = "or"
        orLabel.textColor = .lightGray
        orLabel.backgroundColor = UIColor(named: "viewBackgroundColor")
        orLabel.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        orLabel.textAlignment = .center
        view.addSubview(orLabel)
        
        orLabel.snp.makeConstraints { make in
            make.centerY.equalTo(separatorView.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
        }
    }
    
    func appleLoginButtonSetting() {
        view.addSubview(appleLoginButton)
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
        appleLoginButton.addTouchAnimation()
        appleLoginButton.layer.cornerRadius = 12
        let backgroundImage = UIImage(named: "apple")
        appleLoginButton.setBackgroundImage(backgroundImage, for: .normal)
        appleLoginButton.layer.borderWidth = 1
        applyCommonSettings(to: appleLoginButton)
        
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
    }
        
    func kakaoLoginButtonSetting() {
        view.addSubview(kakaoLoginButton)
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(45)
            make.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        kakaoLoginButton.addTouchAnimation()
        kakaoLoginButton.layer.cornerRadius = 12
        let backgroundImage = UIImage(named: "kakao")
        kakaoLoginButton.setBackgroundImage(backgroundImage, for: .normal)
        applyCommonSettings(to: kakaoLoginButton)

        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc func kakaoLoginButtonTapped() {
        AuthenticationManager.shared.kakaoAuthSignIn { result in
            switch result {
            case .success(_):
                print("카카오 로그인 성공")
                self.navigateToMainScreen()
            case .failure(let error):
                print("카카오 로그인 에러: \(error)")
            }
        }
    }

    func applyCommonSettings(to button: UIButton) {
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.tintColor = .secondaryLabel
        button.setTitleColor(.black, for: .normal)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
    }
    
//    @objc func autoLoginButtonTapped() {
//        
//        if autoLoginButton.imageView?.image == offImage {
//            autoLoginButton.setImage(onImage, for: .normal)
//        } else {
//            autoLoginButton.setImage(offImage, for: .normal)
//        }
//        
//    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "이메일과 비밀번호를 입력해 주세요.")
            return
        }
        
        // Firebase의 signIn 메서드를 사용하여 로그인 시도
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
            guard let self = self else { return }
            
            if let error = error {
                // 로그인 실패 시 에러 메시지 출력
                self.showAlert(message: "로그인에 실패했습니다. \(error.localizedDescription)")
            } else if let _ = authResult?.user {
                AuthenticationManager.shared.checkEmailVerifiedForLogin { isEmailVerified in
                    if isEmailVerified {
                        // 로그인 성공 시 BottomTabBarViewController로 이동
                        self.moveToBottomTabBarController()
                    } else {
                        // 이메일 인증이 필요하다는 알림 표시
                        self.showEmailVerificationAlert()
                        do {
                            try Auth.auth().signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: \(signOutError.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    @objc func createAccountButtonTapped() {
        moveNextVC()
    }
    
    func moveNextVC() {
        let nextVC = MakePasswordViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func moveToBottomTabBarController() {
        let bottomTabBarVC = BottomTabBarViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
    }
}

extension LoginViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
