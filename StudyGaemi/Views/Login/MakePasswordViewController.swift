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

class MakePasswordViewController: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore()
    // 입력 부분
    let mainImage = UIImageView()
    var nicknameDescriptionLabel = UILabel()
    let nicknameTextField = CustomTextField(text: "사용할 이메일을 입력하세요")
    var passwordDescriptionLabel = UILabel()
    let passwordTextField = CustomTextField(text: "사용할 비밀번호를 입력하세요")
    var passwordCheckDescriptionLabel = UILabel()
    let passwordCheckTextField = CustomTextField(text: "비밀번호를 다시 한 번 입력해주세요")
    let confirmButton = CustomButton(title: "인증메일 전송")
    
    let pointOrange = UIColor(named: "pointOrange") ?? .orange
    
    // 사용자 동의 부분
    let personalInfoButton = UIButton()
    let personalInfoMust = UILabel()
    let personalInfoLabel = UILabel()
    var personalInfoAgree = false
    let yakgwanButton = UIButton()
    let yakgwanMust = UILabel()
    let yakgwanLabel = UILabel()
    var yakgwanAgree = false
    let ageButton = UIButton()
    let ageMust = UILabel()
    let ageLabel = UILabel()
    var ageAgree = false
    var separatorView = UIView()
    let allAgreeButton = UIButton()
    let allAgreeLabel = UILabel()
    var allAgree = false
//    let offImage = UIImage(named: "checkboxOff")
//    let onImage = UIImage(named: "checkboxOn")
    let offImage = UIImage(systemName: "square")?.withTintColor(.pointOrange, renderingMode: .alwaysOriginal)
    let onImage = UIImage(systemName: "checkmark.square.fill")?.withTintColor(.pointOrange, renderingMode: .alwaysOriginal)
    let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
    let passwordSecureButton = UIButton(type: .custom)
    
    lazy var personalInfoDescriptionButton = createDescriptionButton(tag: 1)
    lazy var yakgwanDescriptionButton = createDescriptionButton(tag: 2)
//    lazy var ageDescriptionButton = createDescriptionButton(tag: 3)
    
    func setupPasswordSecureButton(for textField: UITextField, withPadding padding: CGFloat = 8.0) -> UIButton {
        let eyeImage = UIImage(systemName: "eye.slash")
        let orangeEyeImage = eyeImage?.withTintColor(UIColor(named: "pointOrange") ?? .orange, renderingMode: .alwaysOriginal)
        let secureButton = UIButton(type: .custom)
        secureButton.setImage(orangeEyeImage, for: .normal)
        secureButton.addTarget(self, action: #selector(passwordSecureButtonTapped(_:)), for: .touchUpInside)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: textField.frame.height))
        secureButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        secureButton.center = CGPoint(x: paddingView.frame.width / 2, y: paddingView.frame.height / 2)
        paddingView.addSubview(secureButton)
        
        textField.rightView = paddingView
        textField.rightViewMode = .always
        return secureButton
    }

    func addPasswordSecureButtonToTextField() {
        let passwordSecureButton = setupPasswordSecureButton(for: passwordTextField)
        let passwordCheckSecureButton = setupPasswordSecureButton(for: passwordCheckTextField)
    }

    @objc func passwordSecureButtonTapped(_ sender: UIButton) {
        guard let textField = sender.superview?.superview as? UITextField else { return }
        textField.isSecureTextEntry.toggle()
        let eyeImage = textField.isSecureTextEntry ? UIImage(systemName: "eye.slash") : UIImage(systemName: "eye")
        let orangeEyeImage = eyeImage?.withTintColor(UIColor(named: "pointOrange") ?? .orange, renderingMode: .alwaysOriginal)
        sender.setImage(orangeEyeImage, for: .normal)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        nicknameTextField.returnKeyType = .next
        passwordTextField.returnKeyType = .next
        passwordCheckTextField.returnKeyType = .done
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        nicknameTextField.keyboardType = .emailAddress
        
        // 입력 부분
        mainImageSetting()
        nicknameTextFieldSetting()
        nicknameDescriptionLabelSetting()
        passwordTextFieldSetting()
        passwordDescriptionLabelSetting()
        passwordCheckTextFieldSetting()
        passwordCheckDescriptionLabelSetting()
        
        addPasswordSecureButtonToTextField()
        
        confirmButtonSetting()
        
        // 사용자 동의 부분
        
        personalInfoSetting()
        yakgwanSetting()
        ageSetting()
        allAgreeSetting()
        separatorViewSetting()
        descriptionButtonSetting()
        
        //        agreementSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }
    
    func descriptionButtonSetting() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        let chevronRightImage = UIImage(systemName: "chevron.right", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        personalInfoDescriptionButton.setImage(chevronRightImage, for: .normal)
        personalInfoDescriptionButton.tintColor = .orange
        
        yakgwanDescriptionButton.setImage(chevronRightImage, for: .normal)
        yakgwanDescriptionButton.tintColor = .orange
        
//        ageDescriptionButton.setImage(chevronRightImage, for: .normal)
//        ageDescriptionButton.tintColor = .orange
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nicknameTextField {
            // nicknameTextField에서 리턴 키를 눌렀을 때 passwordTextField로 이동
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            // passwordTextField에서 리턴 키를 눌렀을 때 passwordCheckTextField로 이동
            passwordCheckTextField.becomeFirstResponder()
        } else if textField == passwordCheckTextField {
            // passwordCheckTextField에서 리턴 키를 눌렀을 때 키보드 숨기기
            passwordCheckTextField.resignFirstResponder()
        }
        return true
    }
    
    func nicknameTextFieldSetting() {
        view.addSubview(nicknameTextField)
        nicknameTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        nicknameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainImage.snp.bottom).offset(20)
//            make.width.equalTo(342)
            make.height.equalTo(52)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }
    
    func nicknameDescriptionLabelSetting() {
        view.addSubview(nicknameDescriptionLabel)
        nicknameDescriptionLabel.text = "이메일 형식에 맞게 입력하세요"
        nicknameDescriptionLabel.textColor = .lightGray
        nicknameDescriptionLabel.font = UIFont(name: CustomFontType.regular.name, size: 10) ?? UIFont.systemFont(ofSize: 10)
        nicknameDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nicknameDescriptionLabel.snp.makeConstraints { make in
            //            make.leading.equalToSuperview().offset(25)
            make.leading.equalTo(nicknameTextField.snp.leading)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4)
        }
    }
    
    func passwordTextFieldSetting() {
        view.addSubview(passwordTextField)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(nicknameDescriptionLabel.snp.bottom).offset(10)
//            make.width.equalTo(342)
            make.height.equalTo(52)
            make.leading.equalTo(nicknameTextField.snp.leading)
            make.trailing.equalTo(nicknameTextField.snp.trailing)
        }
    }
    
    func passwordDescriptionLabelSetting() {
        view.addSubview(passwordDescriptionLabel)
        passwordDescriptionLabel.text = "영문,숫자 포함 8자리 이상의 비밀번호를 입력하세요"
        passwordDescriptionLabel.textColor = .lightGray
        passwordDescriptionLabel.font = UIFont(name: CustomFontType.regular.name, size: 10) ?? UIFont.systemFont(ofSize: 10)
        passwordDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameDescriptionLabel.snp.leading)
            make.top.equalTo(passwordTextField.snp.bottom).offset(4)
        }
    }
    
    func passwordCheckTextFieldSetting() {
        view.addSubview(passwordCheckTextField)
        passwordCheckTextField.isSecureTextEntry = true
        passwordCheckTextField.textContentType = .oneTimeCode
        passwordCheckTextField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        passwordCheckTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordDescriptionLabel.snp.bottom).offset(10)
//            make.width.equalTo(342)
            make.height.equalTo(52)
            make.leading.equalTo(nicknameTextField.snp.leading)
            make.trailing.equalTo(nicknameTextField.snp.trailing)
        }
    }
    
    func passwordCheckDescriptionLabelSetting() {
        view.addSubview(passwordCheckDescriptionLabel)
        passwordCheckDescriptionLabel.text = "비밀번호를 동일하게 입력해주세요"
        passwordCheckDescriptionLabel.textColor = .lightGray
        passwordCheckDescriptionLabel.font = UIFont(name: CustomFontType.regular.name, size: 10) ?? UIFont.systemFont(ofSize: 10)
        passwordCheckDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        passwordCheckDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(nicknameDescriptionLabel.snp.leading)
            make.top.equalTo(passwordCheckTextField.snp.bottom).offset(4)
        }
    }
    
    func personalInfoSetting() {
        view.addSubview(personalInfoLabel)
        view.addSubview(personalInfoButton)
        view.addSubview(personalInfoDescriptionButton)
        view.addSubview(personalInfoMust)
        
        personalInfoMust.text = "필수"
        personalInfoMust.font = UIFont(name: CustomFontType.bold.name, size: 12) ?? UIFont.systemFont(ofSize: 12)
        personalInfoMust.textAlignment = .center
        personalInfoMust.textColor = UIColor(named: "pointOrange")
        personalInfoMust.layer.borderWidth = 1
        personalInfoMust.layer.borderColor = UIColor.lightGray.cgColor
        personalInfoMust.layer.cornerRadius = 9
        
        personalInfoLabel.text = "개인정보 처리 방침에 동의합니다"
        personalInfoLabel.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        personalInfoLabel.textAlignment = .right  // 텍스트 좌측 정렬 설정
        
        personalInfoButton.setImage(offImage, for: .normal)
        personalInfoButton.addTarget(self, action: #selector(personalInfoButtonTapped), for: .touchUpInside)
        
        personalInfoDescriptionButton.snp.makeConstraints { make in
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.centerY.equalTo(personalInfoButton.snp.centerY)
            make.leading.equalTo(personalInfoLabel.snp.trailing).offset(10)
            make.height.equalTo(16)
        }
        
        // 버튼 제약 조건
        personalInfoButton.snp.makeConstraints { make in
//            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
//            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
//            make.width.equalTo(40)
//            make.height.equalTo(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // 필수 제약 조건
        personalInfoMust.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.centerY.equalTo(personalInfoButton.snp.centerY)
            make.height.equalTo(18)
            make.width.equalTo(40)
        }
        
        // 레이블 제약 조건
        personalInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personalInfoButton.snp.centerY)
            make.leading.equalTo(personalInfoMust.snp.trailing).offset(10)
        }
    }
    
    @objc func personalInfoButtonTapped() {
        if personalInfoButton.imageView?.image == offImage {
            personalInfoButton.setImage(onImage, for: .normal)
            personalInfoAgree = true
        } else {
            personalInfoButton.setImage(offImage, for: .normal)
            personalInfoAgree = false
        }
        
        updateConfirmButtonState()
    }
    
    func yakgwanSetting() {
        view.addSubview(yakgwanButton)
        view.addSubview(yakgwanLabel)
        view.addSubview(yakgwanDescriptionButton)
        view.addSubview(yakgwanMust)
        
        yakgwanMust.text = "필수"
        yakgwanMust.font = UIFont(name: CustomFontType.bold.name, size: 12) ?? UIFont.systemFont(ofSize: 12)
        yakgwanMust.textAlignment = .center
        yakgwanMust.textColor = UIColor(named: "pointOrange")
        yakgwanMust.layer.borderWidth = 1
        yakgwanMust.layer.borderColor = UIColor.lightGray.cgColor
        yakgwanMust.layer.cornerRadius = 9
        
        yakgwanLabel.text = "이용 약관에 동의합니다"
        yakgwanLabel.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        yakgwanLabel.textAlignment = .right  // 텍스트 좌측 정렬 설정
        
        yakgwanButton.setImage(offImage, for: .normal)
        yakgwanButton.imageView?.contentMode = .scaleAspectFit
        yakgwanButton.addTarget(self, action: #selector(yakgwanButtonTapped), for: .touchUpInside)
        
        yakgwanDescriptionButton.snp.makeConstraints { make in
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.centerY.equalTo(yakgwanButton.snp.centerY)
            make.leading.equalTo(yakgwanLabel.snp.trailing).offset(10)
            make.height.equalTo(16)
        }
        
        // 버튼 제약 조건
        yakgwanButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.bottom.equalTo(personalInfoButton.snp.top).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // 필수 제약 조건
        yakgwanMust.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.centerY.equalTo(yakgwanButton.snp.centerY)
            make.height.equalTo(18)
            make.width.equalTo(40)
        }
        
        // 레이블 제약 조건
        yakgwanLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yakgwanMust.snp.centerY)
            make.leading.equalTo(yakgwanMust.snp.trailing).offset(10) // 버튼 옆에 딱 붙도록 설정
        }
    }
    
    @objc func yakgwanButtonTapped() {
        if yakgwanButton.imageView?.image == offImage {
            yakgwanButton.setImage(onImage, for: .normal)
            yakgwanAgree = true
        } else {
            yakgwanButton.setImage(offImage, for: .normal)
            yakgwanAgree = false
        }
        
        updateConfirmButtonState()
    }
    
    func ageSetting() {
        view.addSubview(ageButton)
        view.addSubview(ageLabel)
        view.addSubview(ageMust)
//        view.addSubview(ageDescriptionButton)
        
        ageMust.text = "필수"
        ageMust.font = UIFont(name: CustomFontType.bold.name, size: 12) ?? UIFont.systemFont(ofSize: 12)
        ageMust.textAlignment = .center
        ageMust.textColor = UIColor(named: "pointOrange")
        ageMust.layer.borderWidth = 1
        ageMust.layer.borderColor = UIColor.lightGray.cgColor
        ageMust.layer.cornerRadius = 9
        
        ageLabel.text = "만 13세 이상입니다"
        ageLabel.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        ageLabel.textAlignment = .left  // 텍스트 좌측 정렬 설정
        
        ageButton.setImage(offImage, for: .normal)
        ageButton.addTarget(self, action: #selector(ageButtonTapped), for: .touchUpInside)
        
//        ageDescriptionButton.snp.makeConstraints { make in
//            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
//            make.centerY.equalTo(ageButton.snp.centerY)
//        }
        
        // 버튼 제약 조건
        ageButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.bottom.equalTo(yakgwanButton.snp.top).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        ageMust.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.centerY.equalTo(ageButton.snp.centerY)
            make.height.equalTo(18)
            make.width.equalTo(40)
        }
        
        // 레이블 제약 조건
        ageLabel.snp.makeConstraints { make in
//            make.centerY.equalTo(ageButton.snp.centerY)
//            make.leading.equalTo(ageButton.snp.trailing).offset(0) // 버튼 옆에 딱 붙도록 설정
            make.centerY.equalTo(ageMust.snp.centerY)
            make.leading.equalTo(ageMust.snp.trailing).offset(10) // 버튼 옆에 딱 붙도록 설정
        }
    }
    
    @objc func ageButtonTapped() {
        if ageButton.imageView?.image == offImage {
            ageButton.setImage(onImage, for: .normal)
            ageAgree = true
        } else {
            ageButton.setImage(offImage, for: .normal)
            ageAgree = false
        }
        
        updateConfirmButtonState()
    }
    
    func allAgreeSetting() {
        view.addSubview(allAgreeButton)
        view.addSubview(allAgreeLabel)
        
        allAgreeLabel.text = "전체 동의"
        allAgreeLabel.font = UIFont(name: CustomFontType.bold.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        allAgreeLabel.textAlignment = .right  // 텍스트 좌측 정렬 설정
        
        allAgreeButton.setImage(offImage, for: .normal)
        allAgreeButton.addTarget(self, action: #selector(allAgreeButtonTapped), for: .touchUpInside)
        
        // 버튼 제약 조건
        allAgreeButton.snp.makeConstraints { make in
//            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
//            make.bottom.equalTo(ageButton.snp.top).offset(0)
//            make.width.equalTo(40)
//            make.height.equalTo(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.bottom.equalTo(ageButton.snp.top).offset(-15)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // 레이블 제약 조건
        allAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allAgreeButton.snp.centerY)
//            make.trailing.equalTo(allAgreeButton.snp.leading).offset(-10) // 버튼 옆에 딱 붙도록 설정
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
        }
    }
    
    @objc func allAgreeButtonTapped() {
        if allAgreeButton.imageView?.image == offImage {
            allAgreeButton.setImage(onImage, for: .normal)
            ageButton.setImage(onImage, for: .normal)
            yakgwanButton.setImage(onImage, for: .normal)
            personalInfoButton.setImage(onImage, for: .normal)
            ageAgree = true
            yakgwanAgree = true
            personalInfoAgree = true
        } else {
            allAgreeButton.setImage(offImage, for: .normal)
            ageButton.setImage(offImage, for: .normal)
            yakgwanButton.setImage(offImage, for: .normal)
            personalInfoButton.setImage(offImage, for: .normal)
            ageAgree = false
            yakgwanAgree = false
            personalInfoAgree = false
        }
        updateConfirmButtonState()
    }
    
    func separatorViewSetting() {
        separatorView.backgroundColor = UIColor.lightGray
        view.addSubview(separatorView)
        
        separatorView.snp.makeConstraints { make in
            make.top.equalTo(allAgreeButton.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
//            make.width.equalTo(335)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(1)
        }
    }
    
    func updateConfirmButtonState() {
        
        let isButtonEnabled = ageAgree && yakgwanAgree && personalInfoAgree
        confirmButton.isEnabled = ageAgree && yakgwanAgree && personalInfoAgree
        
        if isButtonEnabled {
            allAgreeButton.setImage(onImage, for: .normal)
            confirmButton.gradient.colors = [UIColor(named: "pointOrange")?.cgColor ?? UIColor.orange.cgColor,
                                             UIColor(named: "pointYellow")?.cgColor ?? UIColor.yellow.cgColor]
        } else {
            allAgreeButton.setImage(offImage, for: .normal)
            let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
            confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        }
    }
    
    func confirmButtonSetting() {
        view.addSubview(confirmButton)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        confirmButton.isEnabled = ageAgree && yakgwanAgree && personalInfoAgree
        
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-17)
//            make.width.equalTo(342)
            make.leading.equalTo(nicknameTextField.snp.leading)
            make.trailing.equalTo(nicknameTextField.snp.trailing)
            make.height.equalTo(52)
        }
    }
    
    @objc func confirmButtonTapped() {
        confirmButton.addTouchAnimation()
        print("버튼 누름")
        
        var isValid = true

        // 이메일 텍스트 필드의 값을 가져옴
        let emailText = nicknameTextField.text ?? ""

        // 이메일 유효성 검사
        if isValidEmail(email: emailText) {
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
        
        // 이메일 중복 검사 전에 유효성 상태 확인
//        if !isValid {
//            self.showAlert(message: "입력한 정보를 다시 확인해주세요.")
//            return
//        }
        
        let dispatchGroup = DispatchGroup()

        // 이메일 중복 검사
        if isValid {
            dispatchGroup.enter()
            emailCheck(email: emailText) { isEmailValid in
                if !isEmailValid {
                    isValid = false
                    self.setFailed(for: self.nicknameTextField, label: self.nicknameDescriptionLabel)
                }
                dispatchGroup.leave()
            }
            
            // 모든 비동기 작업이 완료된 후 호출
            dispatchGroup.notify(queue: .main) {
                // 이메일 존재 여부 확인이 끝난 후 isValid 상태를 검사하여 다음 단계를 진행
                if isValid {
                    // 추가적인 유효성 검사나 다음 단계로의 전환 등을 여기에 추가할 수 있습니다
                    self.moveNextVC()
                } else {
                    // 실패 메시지를 출력
                    self.showAlert(message: "이미 가입된 이메일입니다.")
                }
            }
        }
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


        
//        if isValid, let email = nicknameTextField.text {
//            Auth.auth().fetchSignInMethods(forEmail: email) { signInMethods, error in
//                if let error = error {
//                    print("이메일 확인 오류: \(error.localizedDescription)")
//                    self.presentAlert(title: "오류", message: error.localizedDescription)
//                    return
//                }
//                
//                if let signInMethods = signInMethods, !signInMethods.isEmpty {
//                    // 이미 가입된 이메일인 경우
//                    self.setFailed(for: self.nicknameTextField, label: self.nicknameDescriptionLabel)
//                    self.presentAlert(title: "이메일 중복", message: "이미 가입된 이메일 주소입니다.")
//                    isValid = false
//                } else {
//                    isValid = true
//                }
//            }
//            
//            if isValid == true {
//                self.moveNextVC()
//            }
//        }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(email: String) -> Bool {
        // 이메일 주소를 확인하기 위한 정규식 패턴
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        // NSPredicate를 사용하여 이메일 주소가 패턴에 일치하는지 확인
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func createDescriptionButton(tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.tag = tag
        button.addTarget(self, action: #selector(descriptionButtonTapped(_:)), for: .touchUpInside)
        
        // 꺾쇠 이미지를 시스템 아이콘으로 설정하고, 색상을 검정색으로 변경
        if let chevronImage = UIImage(systemName: "chevron.black")?.withTintColor(.black, renderingMode: .alwaysOriginal) {
            button.setImage(chevronImage, for: .normal)
        }
        
        return button
    }
    
    @objc func descriptionButtonTapped(_ sender: UIButton) {
        let createAccountVC = CreateAccountViewController()
        createAccountVC.selectedLabelText = getLabelText(forTag: sender.tag)
        navigationController?.pushViewController(createAccountVC, animated: true)
    }
    
    func getLabelText(forTag tag: Int) -> String {
        switch tag {
        case 1:
            return """
            개인정보 보호 담당부서
            
            개인정보 보호 담당자 : 강태영

            공부하개미 개인정보처리방침

            본 개인정보 처리방침은 2024년 6월 25일부터 적용됩니다.

            팀 핸들이 멀쩡한 8톤트럭(이하 “운영팀”)은 정보주체의 자유와 권리 보호를 위해 「개인정보 보호법」 및 관계 법령이 정한 바를 준수하여, 적법하게 개인정보를 처리하고 안전하게 관리하고 있습니다. 이에 「개인정보 보호법」 제30조에 따라 정보주체에게 개인정보의 처리와 보호에 관한 절차 및 기준을 안내하고, 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립・공개합니다.

            **제1조 (개인정보의 처리 목적 및 항목)**

            운영팀은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 「개인정보 보호법」 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다.

            1. 회원 가입 및 관리
                - 회원 가입 의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지, 각종 고지·통지, 고충처리 목적으로 개인정보를 처리합니다.
            2. 운영팀은 다음의 개인정보 항목을 정보주체의 동의를 받아 처리하고 있습니다.
                1. 회원 서비스 운영 (필수)
                    - 법적 근거: 개인정보 보호법 제15조 제1항 제4조
                    - 수집·이용 항목: 이메일주소, 비밀번호, 닉네임
                    - 보유 및 이용 기간: 회원 탈퇴시까지
                2. 서비스/업데이트 정보 제공, 맞춤형 서비스 제공, 이벤트 안내 (선택)
                    - 수집·이용 항목: 이메일주소, 서비스 이용기록
                    - 보유 및 이용 기간: 동의 철회 또는 회원 탈퇴시까지
            3. 서비스 이용 과정에서 단말기정보, IP주소, 쿠키, 서비스 이용 내역* 아래와 같은 정보들이 자동으로 생성되어 수집될 수 있습니다.
                
                * 서비스 이용 내역이란 서비스 이용 과정에서 자동화된 방법으로 생성되거나 이용자가 입력한 정보가 송수신되면서 서버에 자동으로 기록 및 수집될 수 있는 정보를 의미합니다. 이와 같은 정보는 다른 정보와의 결합 여부, 처리하는 방식 등에 따라 개인정보에 해당할 수 있고 개인정보에 해당하지 않을 수도 있습니다.
                
            4. 유료 서비스
            재화의 구매 및 결제, 콘텐츠 제공, 요금결제·정산
            결제 기록
            서비스 해지시까지(단, 관련법령에 따라 보관되는 정보는 예외)

            ※ 카카오, 네이버, 페이스북, 구글, Apple계정으로 가입하는 SNS회원가입의 경우, 운영팀은 해당 서비스 제공자가 보내는 비식별화되고 추적이 불가능한 고유 Key값을 통해서만 계정을 생성하며, 개인정보에 해당하는 정보는 수집하지 않습니다.

            운영팀은 회원이 탈퇴하거나, 처리·보유목적이 달성되거나 보유기간이 종료한 경우 해당 개인정보를 지체 없이 파기합니다. 단 아래와 같이 관계법령에 의거하여 보존할 필요가 있는 경우에는 일정 기간 동안 개인정보를 보관할 수 있습니다.

            **제2조(처리하는 개인정보의 보관기간 및 이용기간)**

            1. 운영팀은 법령에 따른 개인정보 보유・이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유・이용기간 내에서 개인정보를 처리・보유합니다.
            2. 개인정보의 내용은 다음과 같습니다.
                1. 이메일
                2. 비밀번호
                3. 닉네임
            3. 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.
                1. 회원 가입 및 관리: 회원 탈퇴 시까지
            4. 다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지
                1. 관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지
                2. 관계법령에 따라 보관 의무가 주어진 경우 (단, 아래에 한정되지 않음)
                    - 계약 또는 청약철회 등에 관한 기록: 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
                    - 대금결제 및 재화의 공급에 관한 기록: 5년 (전자상거래 등에서의 소비자보호에 관한 법률)
                    - 소비자의 불만 또는 분쟁처리에 관한 기록: 3년 (전자상거래 등에서의 소비자보호에 관한 법률)
                    - 웹사이트 방문기록: 3개월 (통신비밀보호법)
                3. 내부 방침에 의해 보관하는 경우 (아래에 한정됨)
                    - 서비스 부정이용 기록: 탈퇴일로부터 최대 1년
            5. 운영팀은 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.
            6. 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 불구하고 다른 법령에 따라 개인정보를 계속 보존하여야 하는 경우에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.

            **제3조 (개인정보의 안전성 확보조치)**

            1. 운영팀은 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.
                1. 관리적 조치 : 내부관리계획 수립・시행, 전담조직 운영, 정기적 직원 교육
                2. 기술적 조치 : 개인정보처리시스템 등의 접근권한 관리, 접근통제시스템 설치, 개인정보의 암호화
                3. 물리적 조치 : 전산실, 자료보관실 등의 접근통제

            **제 4조 (정보주체의 권리와 그 행사방법)**

            1. 회원은 언제든지 개인정보 열람・정정・삭제・처리정지 및 철회 요구, 자동화된 결정에 대한 거부 또는 설명 요구 등의 권리를 행사(이하 “권리 행사”라 함)할 수 있습니다.
            2. 권리 행사는 「개인정보 보호법」 시행령 제41조 제1항에 따라 전자우편 등을 통해 요청할 수 있으며, 운영팀은 이에 대해 지체없이 조치하겠습니다.
                - 회원은 언제든지 ‘마이페이지’에서 개인정보를 직접 조회・수정・삭제하거나 ‘문의하기’를 통해 열람을 요청할 수 있습니다.
                - 회원은 언제든지 ‘회원탈퇴’를 통해 개인정보의 수집 및 이용 동의 철회가 가능합니다.
            3. 권리 행사는 정보주체의 법정대리인이나 위임을 받는 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 “ 개인정보 처리 방법에 관한 고시” 별지 제 11호 서식에 따른 위임장을 제출하셔야합니다.
            4. 정보주체가 개인정보 열람 및 처리 정지를 요구할 권리는 「개인정보 보호법」 제35조 제4항 및 제37조 제2항에 의하여 제한될 수 있습니다.
            5. 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 해당 개인정보의 삭제를 요구할 수 없습니다.
            6. 자동화된 결정이 이루어진다는 사실에 대해 정보주체의 동의를 받았거나, 계약 등을 통해 미리 알린 경우, 법률에 명확히 규정이 있는 경우에는 자동화된 결정에 대한 거부는 인정되지 않으며 설명 및 검토 요구만 가능합니다.
                - 또한 자동화된 결정에 대한 거부・설명 요구는 다른 사람의 생명・신체・재산과 그 밖의 이익을 부당하게 침해할 우려가 있는 등 정당한 사유가 있는 경우에는 그 요구가 거절될 수 있습니다.
            7. 운영팀은 권리 행사를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.
            8. 운영팀은 권리 행사를 아래의 부서에 할 수 있습니다. 운영팀은 정보주체의 권리 행사가 신속하게 처리되도록 노력하겠습니다.
                - 개인정보 열람 등 청구 접수・처리 부서
                    - 부서명: 개인정보보호팀
                    - 이메일: [taengdev@gmail.com](mailto:taengdev@gmail.com)

            - 개인정보 보호책임자
                - 성명 : 강태영
                - 소속 : 개인정보보호팀
                - 이메일 : [taengdev@gmail.com](mailto:taengdev@gmail.com)

            **제 5조 (개인정보보호책임자 및 담당자)**

            1. 운영팀은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.
                1. 개인정보 보호책임자
                    - 성명 : 강태영
                    - 소속 : 개인정보보호팀
                    - 이메일 : [taengdev@gmail.com](mailto:taengdev@gmail.com)
            2. 회원은 공부하개미 서비스를 이용하면서 발생한 모든 개인정보보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의할 수 있습니다. 운영팀은 회원의 문의에 대해 지체없이 답변 및 처리해드릴 것입니다.

            **제 6조(개인정보 처리방법 변경)**

            운영팀은 관련 법령이나 내부 정책 대응을 위하여 개인정보처리방침을 수정할 수 있습니다. 개인정보처리방침이 변경되는 경우 회사는 변경 사항을 공지사항 등을 통해 게시하며, 변경된 개인정보처리방침은 게시한 날로부터 7일후부터 효력이 발생합니다.

            공고일자 : 2024년 6월 25일

            시행일자 : 2024년 7월 2일
            """
        case 2:
            return """
            표준약관
            
            제1조(목적) 이 약관은 8tTruck이 운영하는 공부하개미(이하 “앱”이라 한다)에서 제공하는 인터넷 관련 서비스(이하 “서비스”라 한다)를 이용함에 있어 앱과 이용자의 권리․의무 및 책임사항을 규정함을 목적으로 합니다.
            ※「PC통신, 무선 등을 이용하는 전자상거래에 대해서도 그 성질에 반하지 않는 한 이 약관을 준용합니다.」
            제2조(정의)
            ① “앱”이란 8tTruck이 서비스를 이용자에게 제공하기 위하여 컴퓨터 등 정보통신설비를 이용하여 조성한 가상의 공간을 말하며, 아울러 앱을 운영하는 사업자의 의미로도 사용합니다.
            ② “이용자”란 “앱”에 접속하여 이 약관에 따라 “앱”이 제공하는 서비스를 받는 회원 및 비회원을 말합니다.
            ③ ‘회원’이라 함은 “앱”에 회원등록을 한 자로서, 계속적으로 “앱”이 제공하는 서비스를 이용할 수 있는 자를 말합니다.
            ④ ‘비회원’이라 함은 회원에 가입하지 않고 “앱”이 제공하는 서비스를 이용할 수 없는 자를 말합니다.
            제3조 (약관 등의 명시와 설명 및 개정)
            ① “앱”은 이 약관의 내용과 소비자의 불만을 처리할 수 있는 곳의 주소를 포함, 앱의 초기 서비스화면(전면)에 게시합니다. 다만, 약관의 내용은 이용자가 연결화면을 통하여 볼 수 있도록 할 수 있습니다.
            ② “앱”은 「전자상거래 등에서의 소비자보호에 관한 법률」, 「약관의 규제에 관한 법률」, 「전자문서 및 전자거래기본법」, 「전자금융거래법」, 「전자서명법」, 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」, 「방문판매 등에 관한 법률」, 「소비자기본법」 등 관련 법을 위배하지 않는 범위에서 이 약관을 개정할 수 있습니다.
            ③ “앱”이 약관을 개정할 경우에는 적용일자 및 개정사유를 명시하여 현행약관과 함께 몰의 초기화면에 그 적용일자 7일 이전부터 적용일자 전일까지 공지합니다. 다만, 이용자에게 불리하게 약관내용을 변경하는 경우에는 최소한 30일 이상의 사전 유예기간을 두고 공지합니다. 이 경우 "앱“은 개정 전 내용과 개정 후 내용을 명확하게 비교하여 이용자가 알기 쉽도록 표시합니다.
            ④ “앱”이 약관을 개정할 경우에는 그 개정약관은 그 적용일자 이후에 체결되는 계약에만 적용되고 그 이전에 이미 체결된 계약에 대해서는 개정 전의 약관조항이 그대로 적용됩니다. 다만 이미 계약을 체결한 이용자가 개정약관 조항의 적용을 받기를 원하는 뜻을 제3항에 의한 개정약관의 공지기간 내에 “앱”에 송신하여 “앱”의 동의를 받은 경우에는 개정약관 조항이 적용됩니다.
            ⑤ 이 약관에서 정하지 아니한 사항과 이 약관의 해석에 관하여는 전자상거래 등에서의 소비자보호에 관한 법률, 약관의 규제 등에 관한 법률, 공정거래위원회가 정하는 전자상거래 등에서의 소비자 보호지침 및 관계법령 또는 상관례에 따릅니다.
            제4조(서비스의 제공 및 변경)
            ① “앱”은 다음과 같은 업무를 수행합니다.
            1. 사용자에게 설정된 시간에 기상 알림 전송
            2. 사용자가 앱을 이용하여 공부에 활용한 시간의 측정
            3. 기타 “앱”이 제공하는 서비스
            ② “몰”이 제공하기로 이용자와 계약을 체결한 서비스의 기술적 사양의 변경 등의 사유로 변경할 경우에는 그 사유를 이용자에게 통지 가능한 주소로 즉시 통지합니다.
            ③ 전항의 경우 “앱”은 이로 인하여 이용자가 입은 손해를 배상합니다. 다만, “앱”이 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.
            제5조(서비스의 중단)
            ① “앱”은 컴퓨터 등 정보통신설비의 보수점검․교체 및 고장, 통신의 두절 등의 사유가 발생한 경우에는 서비스의 제공을 일시적으로 중단할 수 있습니다.
            ② “앱”은 제1항의 사유로 서비스의 제공이 일시적으로 중단됨으로 인하여 이용자 또는 제3자가 입은 손해에 대하여 배상합니다. 단, “앱”이 고의 또는 과실이 없음을 입증하는 경우에는 그러하지 아니합니다.
            ③ 사업종목의 전환, 사업의 포기, 업체 간의 통합 등의 이유로 서비스를 제공할 수 없게 되는 경우에는 “앱”은 제8조에 정한 방법으로 이용자에게 통지하고 당초 “앱”에서 제시한 조건에 따라 소비자에게 보상합니다.
            제6조(회원가입)
            ① 이용자는 “앱”이 정한 가입 양식에 따라 회원정보를 기입한 후 이 약관에 동의한다는 의사표시를 함으로서 회원가입을 신청합니다.
            ② “앱”은 제1항과 같이 회원으로 가입할 것을 신청한 이용자 중 다음 각 호에 해당하지 않는 한 회원으로 등록합니다.
            1. 가입신청자가 이 약관 제7조제3항에 의하여 이전에 회원자격을 상실한 적이 있는 경우, 다만 제7조제3항에 의한 회원자격 상실 후 3년이 경과한 자로서 “앱”의 회원재가입 승낙을 얻은 경우에는 예외로 한다.
            2. 등록 내용에 허위, 기재누락, 오기가 있는 경우
            3. 기타 회원으로 등록하는 것이 “앱”의 기술상 현저히 지장이 있다고 판단되는 경우
            ③ 회원가입계약의 성립 시기는 “앱”의 승낙이 회원에게 도달한 시점으로 합니다.
            ④ 회원은 회원가입 시 등록한 사항에 변경이 있는 경우, 상당한 기간 이내에 “앱”에 대하여 회원정보 수정 등의 방법으로 그 변경사항을 알려야 합니다.
            제7조(회원 탈퇴 및 자격 상실 등)
            ① 회원은 “앱”에 언제든지 탈퇴를 요청할 수 있으며 “앱”은 즉시 회원탈퇴를 처리합니다.
            ② 회원이 다음 각 호의 사유에 해당하는 경우, “앱”은 회원자격을 제한 및 정지시킬 수 있습니다.
            1. 가입 신청 시에 허위 내용을 등록한 경우
            2. 다른 사람의 “앱” 이용을 방해하거나 그 정보를 도용하는 등 질서를 위협하는 경우
            3. “앱”을 이용하여 법령 또는 이 약관이 금지하거나 공서양속에 반하는 행위를 하는 경우
            ③ “앱”이 회원 자격을 제한․정지 시킨 후, 동일한 행위가 2회 이상 반복되거나 30일 이내에 그 사유가 시정되지 아니하는 경우 “앱”은 회원자격을 상실시킬 수 있습니다.
            ④ “앱”이 회원자격을 상실시키는 경우에는 회원등록을 말소합니다. 이 경우 회원에게 이를 통지하고, 회원등록 말소 전에 최소한 30일 이상의 기간을 정하여 소명할 기회를 부여합니다.
            제8조(회원에 대한 통지)
            ① “앱”이 회원에 대한 통지를 하는 경우, 회원이 “앱”과 미리 약정하여 지정한 전자우편 주소로 할 수 있습니다.
            ② “앱”은 불특정다수 회원에 대한 통지의 경우 1주일이상 “앱” 게시판에 게시함으로서 개별 통지에 갈음할 수 있습니다. 다만, 회원 본인의 거래와 관련하여 중대한 영향을 미치는 사항에 대하여는 개별통지를 합니다.
            제9조(개인정보보호)
            ① “앱”은 이용자의 개인정보 수집시 서비스제공을 위하여 필요한 범위에서 최소한의 개인정보를 수집합니다.
            ② “앱”은 회원가입시 계약이행에 필요한 정보를 미리 수집하지 않습니다. 다만, 관련 법령상 의무이행을 위하여 구매계약 이전에 본인확인이 필요한 경우로서 최소한의 특정 개인정보를 수집하는 경우에는 그러하지 아니합니다.
            ③ “앱”은 이용자의 개인정보를 수집·이용하는 때에는 당해 이용자에게 그 목적을 고지하고 동의를 받습니다.
            ④ “앱”은 수집된 개인정보를 목적외의 용도로 이용할 수 없으며, 새로운 이용목적이 발생한 경우 또는 제3자에게 제공하는 경우에는 이용·제공단계에서 당해 이용자에게 그 목적을 고지하고 동의를 받습니다. 다만, 관련 법령에 달리 정함이 있는 경우에는 예외로 합니다.
            ⑤ “앱”이 제2항과 제3항에 의해 이용자의 동의를 받아야 하는 경우에는 개인정보관리 책임자의 신원(소속, 성명 및 전화번호, 기타 연락처), 정보의 수집목적 및 이용목적, 제3자에 대한 정보제공 관련사항(제공받은자, 제공목적 및 제공할 정보의 내용) 등 「정보통신망 이용촉진 및 정보보호 등에 관한 법률」 제22조제2항이 규정한 사항을 미리 명시하거나 고지해야 하며 이용자는 언제든지 이 동의를 철회할 수 있습니다.
            ⑥ 이용자는 언제든지 “앱”이 가지고 있는 자신의 개인정보에 대해 열람 및 오류정정을 요구할 수 있으며 “앱”은 이에 대해 지체 없이 필요한 조치를 취할 의무를 집니다. 이용자가 오류의 정정을 요구한 경우에는 “앱”은 그 오류를 정정할 때까지 당해 개인정보를 이용하지 않습니다.
            ⑦ “앱”은 개인정보 보호를 위하여 이용자의 개인정보를 취급하는 자를 최소한으로 제한하여야 하며 이용자의 개인정보의 분실, 도난, 유출, 동의 없는 제3자 제공, 변조 등으로 인한 이용자의 손해에 대하여 모든 책임을 집니다.
            ⑧ “앱” 또는 그로부터 개인정보를 제공받은 제3자는 개인정보의 수집목적 또는 제공받은 목적을 달성한 때에는 당해 개인정보를 지체 없이 파기합니다.
            ⑨ “앱”은 개인정보의 수집·이용·제공에 관한 동의 란을 미리 선택한 것으로 설정해두지 않습니다. 또한 개인정보의 수집·이용·제공에 관한 이용자의 동의거절시 제한되는 서비스를 구체적으로 명시하고, 필수수집항목이 아닌 개인정보의 수집·이용·제공에 관한 이용자의 동의 거절을 이유로 회원가입 등 서비스 제공을 제한하거나 거절하지 않습니다.
            제10조(“앱“의 의무)
            ① “앱”은 법령과 이 약관이 금지하거나 공서양속에 반하는 행위를 하지 않으며 이 약관이 정하는 바에 따라 지속적이고, 안정적으로 재화․용역을 제공하는데 최선을 다하여야 합니다.
            ② “앱”은 이용자가 안전하게 인터넷 서비스를 이용할 수 있도록 이용자의 개인정보(신용정보 포함)보호를 위한 보안 시스템을 갖추어야 합니다.
            ③ “앱”이 상품이나 용역에 대하여 「표시․광고의 공정화에 관한 법률」 제3조 소정의 부당한 표시․광고행위를 함으로써 이용자가 손해를 입은 때에는 이를 배상할 책임을 집니다.
            ④ “앱”은 이용자가 원하지 않는 영리목적의 광고성 전자우편을 발송하지 않습니다.
            제11조(회원의 ID 및 비밀번호에 대한 의무)
            ① 제17조의 경우를 제외한 ID와 비밀번호에 관한 관리책임은 회원에게 있습니다.
            ② 회원은 자신의 ID 및 비밀번호를 제3자에게 이용하게 해서는 안됩니다.
            ③ 회원이 자신의 ID 및 비밀번호를 도난당하거나 제3자가 사용하고 있음을 인지한 경우에는 바로 “앱”에 통보하고 “앱”의 안내가 있는 경우에는 그에 따라야 합니다.
            제12조(이용자의 의무) 이용자는 다음 행위를 하여서는 안 됩니다.
            1. 신청 또는 변경시 허위 내용의 등록
            2. 타인의 정보 도용
            3. “앱”에 게시된 정보의 변경
            4. “앱”이 정한 정보 이외의 정보(컴퓨터 프로그램 등) 등의 송신 또는 게시
            5. “앱” 기타 제3자의 저작권 등 지적재산권에 대한 침해
            6. “앱” 기타 제3자의 명예를 손상시키거나 업무를 방해하는 행위
            7. 외설 또는 폭력적인 메시지, 화상, 음성, 기타 공서양속에 반하는 정보를 몰에 공개 또는 게시하는 행위
            제13조(연결“앱”과 피연결“앱” 간의 관계)
            ① 상위 “앱”과 하위 “앱”이 하이퍼링크(예: 하이퍼링크의 대상에는 문자, 그림 및 동화상 등이 포함됨)방식 등으로 연결된 경우, 전자를 연결 “앱”(어플리케이션)이라고 하고 후자를 피연결 “앱”(웹사이트)이라고 합니다.
            ② 연결“앱”은 피연결“앱”이 독자적으로 제공하는 재화 등에 의하여 이용자와 행하는 거래에 대해서 보증 책임을 지지 않는다는 뜻을 연결“앱”의 초기화면 또는 연결되는 시점의 팝업화면으로 명시한 경우에는 그 거래에 대한 보증 책임을 지지 않습니다.
            제14조(저작권의 귀속 및 이용제한)
            ① “앱“이 작성한 저작물에 대한 저작권 기타 지적재산권은 ”앱“에 귀속합니다.
            ② 이용자는 “앱”을 이용함으로써 얻은 정보 중 “앱”에게 지적재산권이 귀속된 정보를 “앱”의 사전 승낙 없이 복제, 송신, 출판, 배포, 방송 기타 방법에 의하여 영리목적으로 이용하거나 제3자에게 이용하게 하여서는 안됩니다.
            ③ “앱”은 약정에 따라 이용자에게 귀속된 저작권을 사용하는 경우 당해 이용자에게 통보하여야 합니다.
            제15조(분쟁해결)
            ① “앱”은 이용자가 제기하는 정당한 의견이나 불만을 반영하고 그 피해를 보상처리하기 위하여 피해보상처리기구를 설치․운영합니다.
            ② “앱”은 이용자로부터 제출되는 불만사항 및 의견은 우선적으로 그 사항을 처리합니다. 다만, 신속한 처리가 곤란한 경우에는 이용자에게 그 사유와 처리일정을 즉시 통보해 드립니다.
            ③ “앱”과 이용자 간에 발생한 전자상거래 분쟁과 관련하여 이용자의 피해구제신청이 있는 경우에는 공정거래위원회 또는 시·도지사가 의뢰하는 분쟁조정기관의 조정에 따를 수 있습니다.
            제16조(재판권 및 준거법)
            ① “앱”과 이용자 간에 발생한 전자상거래 분쟁에 관한 소송은 제소 당시의 이용자의 주소에 의하고, 주소가 없는 경우에는 거소를 관할하는 지방법원의 전속관할로 합니다. 다만, 제소 당시 이용자의 주소 또는 거소가 분명하지 않거나 외국 거주자의 경우에는 민사소송법상의 관할법원에 제기합니다.
            """
        case 3:
            return "This is Easter Eggs!"
        default:
            return "기본값"
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
        // 비밀번호 유효성 검사를 위한 정규식 패턴
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }

    
    func moveNextVC() {
        guard let email = nicknameTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            // 입력 필드가 비어있는 경우 처리
            return
        }
        
        AuthenticationManager.shared.createUser(email: email, password: password)
        
        let nextVC = EmailConfirmViewController()
        nextVC.modalPresentationStyle = .fullScreen
        
        // 뷰 컨트롤러가 나타날 때 뒤로가기 버튼을 숨깁니다.
        navigationController?.pushViewController(nextVC, animated: true)
        nextVC.navigationItem.hidesBackButton = true
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension MakePasswordViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
