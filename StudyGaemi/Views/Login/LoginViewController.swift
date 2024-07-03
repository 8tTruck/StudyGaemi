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

    // MARK: - Properties
    
    var firestore: Firestore!
    let db = Firestore.firestore()
    
    let offImage = UIImage(named: "checkboxOff")
    let onImage = UIImage(named: "checkboxOn")
    
    let loginImage = UIImageView()
    let emailTextField = CustomTextField(text: "E-mail")
    let passwordTextField = CustomTextField(text: "Password")
    let loginButton = CustomButton(title: "Login")
    let findIDButton = UIButton()
    let findPWButton = UIButton()
    let separatorView = UIView()
    let orLabel = UILabel()
    let appleLoginButton = UIButton()
    let kakaoLoginButton = UIButton()
    let signupLabel = UILabel()
    let createAccountButton = UIButton()
    let passwordSecureButton = UIButton(type: .custom)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigateToLoginScreen()
        hideKeyboardWhenTappedAround()
        setupPasswordSecureButton()
        addPasswordSecureButtonToTextField()
        emailTextField.keyboardType = .emailAddress
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - Setup Methods
    
    func setupPasswordSecureButton() {
        let eyeImage = UIImage(systemName: "eye.slash")
        let orangeEyeImage = eyeImage?.withTintColor(UIColor(named: "pointOrange") ?? .orange, renderingMode: .alwaysOriginal)
        passwordSecureButton.setImage(orangeEyeImage, for: .normal)
        passwordSecureButton.addTarget(self, action: #selector(passwordSecureButtonTapped), for: .touchUpInside)
    }
    
    func addPasswordSecureButtonToTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: passwordTextField.frame.height))
        passwordSecureButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        passwordSecureButton.center = CGPoint(x: paddingView.frame.width / 2, y: paddingView.frame.height / 2)
        
        paddingView.addSubview(passwordSecureButton)
        passwordTextField.rightView = paddingView
        passwordTextField.rightViewMode = .always
    }
    
    func navigateToLoginScreen() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        loginImage.image = UIImage(named: "heartAnt")
        
        view.addSubview(loginImage)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(separatorView)
        view.addSubview(orLabel)
        view.addSubview(appleLoginButton)
        view.addSubview(kakaoLoginButton)
        
        loginImage.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(loginImage.snp.width).multipliedBy(1 / 1.6)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        
        emailTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        passwordTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        emailTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(loginImage.snp.bottom).offset(28)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(52)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(52)
        }
        
        loginButton.addTouchAnimation()
        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(12)
            make.leading.equalTo(emailTextField.snp.leading)
            make.trailing.equalTo(emailTextField.snp.trailing)
            make.height.equalTo(52)
        }
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        findAccountSetting()
        createAccountSetting()
        
        separatorView.backgroundColor = UIColor.lightGray
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(signupLabel.snp.bottom).offset(20.5)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
        
        orLabel.text = "or"
        orLabel.textColor = .lightGray
        orLabel.backgroundColor = UIColor(named: "viewBackgroundColor")
        orLabel.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        orLabel.textAlignment = .center
        orLabel.snp.makeConstraints { make in
            make.centerY.equalTo(separatorView.snp.centerY)
            make.centerX.equalToSuperview()
            make.width.equalTo(30)
        }
        
        setupThirdPartyLoginButtons()
    }
    
    func setupThirdPartyLoginButtons() {
        appleLoginButton.snp.makeConstraints { make in
            make.top.equalTo(orLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(45)
        }
        appleLoginButton.addTouchAnimation()
        appleLoginButton.layer.cornerRadius = 10
        let appleLoginImage = UIImage(named: "apple")
        appleLoginButton.setBackgroundImage(appleLoginImage, for: .normal)
        appleLoginButton.layer.borderWidth = 1
        applyCommonSettings(to: appleLoginButton)
        
        appleLoginButton.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        
        kakaoLoginButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(45)
            make.top.equalTo(appleLoginButton.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        kakaoLoginButton.addTouchAnimation()
        kakaoLoginButton.layer.cornerRadius = 10
        let kakaoLoginImage = UIImage(named: "kakao")
        kakaoLoginButton.setBackgroundImage(kakaoLoginImage, for: .normal)
        applyCommonSettings(to: kakaoLoginButton)

        kakaoLoginButton.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
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
    
    func createAccountSetting() {
        let createAccountStackView = UIStackView(arrangedSubviews: [signupLabel, createAccountButton])
        createAccountStackView.axis = .horizontal
        createAccountStackView.spacing = 8
        createAccountStackView.alignment = .center
        view.addSubview(createAccountStackView)
        
        signupLabel.text = "계정이 없으신가요?"
        signupLabel.textColor = .gray
        signupLabel.font = UIFont(name: CustomFontType.light.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        
        createAccountButton.setTitle("회원가입", for: .normal)
        createAccountButton.setTitleColor(UIColor(named: "pointOrange"), for: .normal)
        createAccountButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        let createAccountAttributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .underlineColor: UIColor(named: "pointOrange") ?? .orange
        ]
        let createAccountAttributedTitle = NSAttributedString(string: "회원가입", attributes: createAccountAttributes)
        createAccountButton.setAttributedTitle(createAccountAttributedTitle, for: .normal)
        createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
        
        createAccountStackView.snp.makeConstraints { make in
            make.top.equalTo(findIDButton.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
    }
    
    func applyCommonSettings(to button: UIButton) {
        button.layer.masksToBounds = true
        button.contentMode = .scaleAspectFit
        button.layer.borderColor = UIColor.lightGray.cgColor
    }

    // MARK: - Button Actions

    @objc func passwordSecureButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeImageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        let eyeImage = UIImage(systemName: eyeImageName)
        let orangeEyeImage = eyeImage?.withTintColor(UIColor(named: "pointOrange") ?? .orange, renderingMode: .alwaysOriginal)
        passwordSecureButton.setImage(orangeEyeImage, for: .normal)
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            emailTextField.shake()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordTextField.shake()
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
    
    @objc func appleLoginButtonTapped() {
        handleAppleLogin()
    }

    @objc func kakaoLoginButtonTapped() {
        handleKakaoLogin()
    }
    
    @objc func findIDButtonTapped() {
        let alert = UIAlertController(title: "ID 찾기", message: "이메일을 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "E-mail"
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self?.showAlert(message: "이메일 주소를 입력해 주세요.")
                return
            }
            
            guard self?.isValidEmail(email) == true else {
                self?.showAlert(message: "이메일 형식이 올바르지 않습니다.")
                return
            }

            self?.emailCheck(email: email) { isAvailable in
                DispatchQueue.main.async {
                    if isAvailable {
                        let alertController = UIAlertController(title: "알림", message: "해당 이메일(\(email))로 가입된 계정이 없습니다.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self?.present(alertController, animated: true, completion: nil)
                    } else {
                        let alertController = UIAlertController(title: "알림", message: "해당 이메일(\(email))로 가입된 이메일 계정 혹은 카카오 계정이 존재합니다.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }



    @objc func findPWButtonTapped() {
        let alert = UIAlertController(title: "비밀번호 찾기", message: "입력하신 이메일로 비밀번호 재설정 메일을 전송합니다.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "E-mail"
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            guard let email = alert.textFields?.first?.text, !email.isEmpty else {
                self?.showAlert(message: "이메일 주소를 입력해 주세요.")
                return
            }

            guard self?.isValidEmail(email) == true else {
                self?.showAlert(message: "이메일 형식이 올바르지 않습니다.")
                return
            }
            
            self?.emailCheck(email: email) { isAvailable in
                if isAvailable {
                    self?.showAlert(message: "해당 이메일로 가입된 계정이 없습니다.")
                } else {
                    AuthenticationManager.shared.resetPassword(email: email) { success, error in
                        if success {
                            self?.showAlert(message: "비밀번호 재설정 이메일을 보냈습니다.")
                        } else {
                            self?.showAlert(message: "비밀번호 재설정 이메일을 보내지 못했습니다. \(error ?? "")")
                        }
                    }
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }


    @objc func createAccountButtonTapped() {
        print("계정 생성버튼 누름")
        let nextVC = MakePasswordViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    
    // MARK: - Authentication Methods
    
    func handleAppleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
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
                            self.moveToBottomTabBarController()
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
    
    func handleKakaoLogin() {
        AuthenticationManager.shared.kakaoAuthSignIn { result in
             switch result {
             case .success(_):
                 print("카카오 로그인 성공")
                 self.moveToBottomTabBarController()
             case .failure(let error):
                 print("카카오 로그인 에러: \(error)")
             }
         }
    }
    
    // MARK: - Utility Methods
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 보여지는 화면을 지정하는 데 사용. 일반적으로는 현재 앱의 뷰를 반환하여 ASAuthorizationController가 해당하는 창에 맞게 보여지도록 함.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    // ASAuthorizationController에서 인증 작업 중 에러가 발생했을 때 호출
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showAlert(message: "\(error)")
        return
    }
    
    func showAlert(message: String) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
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
    
    func moveToBottomTabBarController() {
        let bottomTabBarVC = BottomTabBarViewController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
    }
    
    func showEmailVerificationAlert() {
        let alert = UIAlertController(title: "이메일 인증 필요", message: "이메일 인증이 필요합니다. 이메일을 확인해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
