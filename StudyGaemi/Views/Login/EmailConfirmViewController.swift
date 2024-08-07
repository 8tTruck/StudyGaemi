//
//  EmailConfirmViewController.swift
//  StudyGaemi
//
//  Created by Seungseop Lee on 6/4/24.
//

import Firebase
import UIKit
import SnapKit

class EmailConfirmViewController: UIViewController, UITextFieldDelegate {
    
    let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
     
    let mainImage = UIImageView()
    let mainLabel = UILabel()
    let subLabel = UILabel()
    
//    let correctAuthenticationCode = false
    
//    let textField = CustomTextField(text: "인증코드를 입력하세요")
//    let confirmButton = CustomButton(title: "인증")
    
    private var timer: Timer?
    private let totalTime: TimeInterval = 60
    private var elapsedTime: TimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        mainImageSetting()
        mainLabelSetting()
        subLabelSetting()
//        textFieldSetting()
//        confirmButtonSetting()
        
//        textField.delegate = self
//        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
//        updateConfirmButtonState()
        startTimer()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        textField.becomeFirstResponder()
//    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgress() {
        elapsedTime += 1
        print("\(elapsedTime)초 째 이메일 인증 감지 중")
//        AuthenticationManager.shared.checkEmailVerified(timer: self.timer, navigationController: navigationController)
        
        AuthenticationManager.shared.checkEmailVerifiedForSignIn(timer: self.timer, navigationController: navigationController) { isVerified in
            if isVerified {
                print("이메일 인증에 성공했습니다.")
                let moveVC = CreateAccountSuccessViewController()
                moveVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(moveVC, animated: true)
                moveVC.navigationItem.hidesBackButton = true
            } else {
                print("이메일 인증에 실패했습니다.")
            }
        }
        
        if elapsedTime > totalTime {
            timer?.invalidate()
            timer = nil
            // 시간 초과 시 데이터베이스에서 계정 삭제 및 데이터 삭제
            FirestoreManager.shared.deleteUserData { result in
                switch result {
                case .success:
                    print("User 데이터베이스 삭제 완료")
                case .failure(let error):
                    print("User 데이터베이스 삭제 에러: \(error)")
                }
            }
            // 시간 초과 시 로그아웃 하는 메소드 추가
//            AuthenticationManager.shared.signOut()
//            print("로그아웃 시도")
//            // 시간 초과 시 계정 탈퇴 하는 메소드 추가
//            AuthenticationManager.shared.deleteUser()
//            print("계정 탈퇴 시도")
            AuthenticationManager.shared.deleteUser()
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "인증 시간이 만료되었습니다.\n입력하신 정보를 모두 삭제합니다.", message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                    AuthenticationManager.shared.signOut()
                    let loginVC = UINavigationController(rootViewController: LoginViewController())
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = loginVC
                        window.makeKeyAndVisible()
                    }
                }
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func mainImageSetting() {
        mainImage.image = UIImage(named: "mainAnt")
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImage)
        
        mainImage.snp.makeConstraints { make in
            make.width.equalTo(208)
            make.height.equalTo(124)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
        }
    }
    
    func mainLabelSetting() {
        view.addSubview(mainLabel)
        mainLabel.text = "이메일 인증 대기 중"
        mainLabel.textColor = UIColor(named: "fontBlack")
        mainLabel.font = UIFont(name: CustomFontType.bold.name, size: 24) ?? UIFont.systemFont(ofSize: 24)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.leading.equalToSuperview().offset(20)
//            make.leading.equalTo(mainImage.snp.leading).offset(-65)
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImage.snp.bottom).offset(40)
        }
    }
    
    func subLabelSetting() {
        view.addSubview(subLabel)
        subLabel.text = "앱의 원활한 사용을 위해\n이메일 인증이 필요합니다."
        subLabel.textColor = UIColor(named: "fontGray")
        subLabel.font = UIFont(name: CustomFontType.regular.name, size: 16)
        subLabel.numberOfLines = 0
        subLabel.lineBreakMode = .byWordWrapping
        subLabel.textAlignment = .center
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        
        subLabel.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(208)
        }
    }
    
//    func textFieldSetting() {
//        view.addSubview(textField)
//        textField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
//        textField.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(mainLabel.snp.bottom).offset(14)
//            make.width.equalTo(342)
//            make.height.equalTo(60)
//        }
//    }
    
//    func confirmButtonSetting() {
//        view.addSubview(confirmButton)
//        confirmButton.addTouchAnimation()
//        
//        confirmButton.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.top.equalTo(textField.snp.bottom).offset(12)
//            make.top.equalToSuperview().offset(405)
//            make.width.equalTo(342)
//            make.height.equalTo(60)
//        }
//        confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
//        confirmButton.isEnabled = isValidCode(code: textField.text ?? "")
//        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
//    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        updateConfirmButtonState()
//    }
    
//    func updateConfirmButtonState() {
//        let isValidCode = isValidCode(code: textField.text ?? "")
//        confirmButton.isEnabled = isValidCode
//        if isValidCode {
//            confirmButton.gradient.colors = [UIColor(named: "pointOrange")?.cgColor ?? UIColor.orange.cgColor,
//                                             UIColor(named: "pointYellow")?.cgColor ?? UIColor.yellow.cgColor]
//        } else {
//            confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
//        }
//    }
    
//    func isValidCode(code: String) -> Bool {
//        // 임시로 6자리 숫자인지만 판독하도록 작성
//        guard code.count == 6 else { return false }
//        
//        return Int(code) != nil
//    }
    
    @objc func confirmButtonTapped() {
        print("인증되었습니다")
        moveNextVC()
    }
    
    func moveNextVC() {
        let createAccountSuccessVC = CreateAccountSuccessViewController()
        createAccountSuccessVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(createAccountSuccessVC, animated: true)
        createAccountSuccessVC.navigationItem.hidesBackButton = true

//        let makePasswordVC = MakePasswordViewController()
//        makePasswordVC.modalPresentationStyle = .fullScreen
////        present(makePasswordVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(makePasswordVC, animated: true)

    }
    
    // UITextFieldDelegate 메서드 추가
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = textField.text ?? ""
//        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
//        return prospectiveText.count <= 6
//    }
}
