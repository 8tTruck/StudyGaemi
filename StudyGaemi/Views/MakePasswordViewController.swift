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
    let confirmButton = CustomButton(title: "계정 생성")
    
    // 사용자 동의 부분
    let personalInfoButton = UIButton()
    let personalInfoLabel = UILabel()
    var personalInfoAgree = false
    let yakgwanButton = UIButton()
    let yakgwanLabel = UILabel()
    var yakgwanAgree = false
    let ageButton = UIButton()
    let ageLabel = UILabel()
    var ageAgree = false
    var separatorView = UIView()
    let allAgreeButton = UIButton()
    let allAgreeLabel = UILabel()
    var allAgree = false
    let offImage = UIImage(named: "checkboxOff")
    let onImage = UIImage(named: "checkboxOn")
    let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
    
    lazy var personalInfoDescriptionButton = createDescriptionButton(tag: 1)
    lazy var yakgwanDescriptionButton = createDescriptionButton(tag: 2)
    lazy var ageDescriptionButton = createDescriptionButton(tag: 3)
    
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
        
        // 입력 부분
        mainImageSetting()
        nicknameTextFieldSetting()
        nicknameDescriptionLabelSetting()
        passwordTextFieldSetting()
        passwordDescriptionLabelSetting()
        passwordCheckTextFieldSetting()
        passwordCheckDescriptionLabelSetting()
        
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
        
        ageDescriptionButton.setImage(chevronRightImage, for: .normal)
        ageDescriptionButton.tintColor = .orange
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
            make.height.equalTo(50)
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
            make.height.equalTo(50)
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
            make.height.equalTo(50)
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
        
        personalInfoLabel.text = "[해야] 개인정보 처리 방침에 동의합니다"
        personalInfoLabel.font = UIFont(name: CustomFontType.regular.name, size: 12) ?? UIFont.systemFont(ofSize: 12)
        personalInfoLabel.textAlignment = .left  // 텍스트 좌측 정렬 설정
        
        personalInfoButton.setImage(offImage, for: .normal)
        personalInfoButton.addTarget(self, action: #selector(personalInfoButtonTapped), for: .touchUpInside)
        personalInfoButton.addTouchAnimation()
        
        personalInfoDescriptionButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.centerY.equalTo(personalInfoButton.snp.centerY)
        }
        
        // 버튼 제약 조건
        personalInfoButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // 레이블 제약 조건
        personalInfoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(personalInfoButton.snp.centerY)
            make.leading.equalTo(personalInfoButton.snp.trailing).offset(0) // 버튼 옆에 딱 붙도록 설정
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
        
        yakgwanLabel.text = "[슈퍼노바] 이용 약관에 동의합니다"
        yakgwanLabel.font = UIFont(name: CustomFontType.regular.name, size: 12) ?? UIFont.systemFont(ofSize: 12)
        yakgwanLabel.textAlignment = .left  // 텍스트 좌측 정렬 설정
        
        yakgwanButton.setImage(offImage, for: .normal)
        yakgwanButton.addTarget(self, action: #selector(yakgwanButtonTapped), for: .touchUpInside)
        yakgwanButton.addTouchAnimation()
        
        yakgwanDescriptionButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.centerY.equalTo(yakgwanButton.snp.centerY)
        }
        
        // 버튼 제약 조건
        yakgwanButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.bottom.equalTo(personalInfoButton.snp.top).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // 레이블 제약 조건
        yakgwanLabel.snp.makeConstraints { make in
            make.centerY.equalTo(yakgwanButton.snp.centerY)
            make.leading.equalTo(yakgwanButton.snp.trailing).offset(0) // 버튼 옆에 딱 붙도록 설정
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
        view.addSubview(ageDescriptionButton)
        
        ageLabel.text = "[고민중독] 만 14세 이상입니다"
        ageLabel.font = UIFont(name: CustomFontType.regular.name, size: 12) ?? UIFont.systemFont(ofSize: 12)
        ageLabel.textAlignment = .left  // 텍스트 좌측 정렬 설정
        
        ageButton.setImage(offImage, for: .normal)
        ageButton.addTarget(self, action: #selector(ageButtonTapped), for: .touchUpInside)
        ageButton.addTouchAnimation()
        
        ageDescriptionButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.centerY.equalTo(ageButton.snp.centerY)
        }
        
        // 버튼 제약 조건
        ageButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.bottom.equalTo(yakgwanButton.snp.top).offset(0)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // 레이블 제약 조건
        ageLabel.snp.makeConstraints { make in
            make.centerY.equalTo(ageButton.snp.centerY)
            make.leading.equalTo(ageButton.snp.trailing).offset(0) // 버튼 옆에 딱 붙도록 설정
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
        allAgreeLabel.font = UIFont(name: CustomFontType.regular.name, size: 14) ?? UIFont.systemFont(ofSize: 14)
        allAgreeLabel.textAlignment = .left  // 텍스트 좌측 정렬 설정
        
        allAgreeButton.setImage(offImage, for: .normal)
        allAgreeButton.addTarget(self, action: #selector(allAgreeButtonTapped), for: .touchUpInside)
        allAgreeButton.addTouchAnimation()
        
        // 버튼 제약 조건
        allAgreeButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.bottom.equalTo(ageButton.snp.top).offset(0)
            make.width.equalTo(45)
            make.height.equalTo(45)
        }
        
        // 레이블 제약 조건
        allAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allAgreeButton.snp.centerY)
            make.leading.equalTo(allAgreeButton.snp.trailing).offset(0) // 버튼 옆에 딱 붙도록 설정
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
            make.top.equalTo(allAgreeButton.snp.bottom).offset(1)
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
            make.height.equalTo(60)
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
            return "Let's get it Look at it Pay attention 얼어붙은 맘 어디 깨볼까? 놀라버렸던 네 심장 말이야 맘에 들었어 넌 그냥 Say yes 내가 널 부르면 “얼음 땡” (Da da da dun dun) 널 노리는 내 두 눈 숨을 죽인 그다음 한 발 낮춘 attitude 때를 기다리는 pose 어둠 속 빛난 tiger eyes 날 감춘 채로 다가가 새빨간 말로 홀려 놔 방심한 순간 claw 우린 더 높이 하늘에 닿을 것처럼 외쳐 너를 깨워 올려 봐 노려봐 넌 내 거니까 다 자꾸 널 보면 탐이 탐이 나 해야 해야 해야 한입에 널 삼킬 때야 (탐이 탐이 나) 해야 해야 해야 이미 내가 이긴 패야 (널 보면 탐이 탐이 나) 해야 해야 해야 뜨겁게 떠오르는 해야 별안간 홀린 그 순간 Bite 단 한 번에 난 널 휘리휘리 Catch ya 더 높이 Keep it up Uh huh Happily ever after? Nope! (Da da da dun dun) 못 기다린대 못 돼버린 내 맘이 겁 따윈 없는 척하지 마 너 감히 멀어져 넌 가니 어차피 한 입 거리 (Hey) 옳지 착하지 더 이리이리 오렴 네 맘 나 주면 안 잡아먹지 Right now 내 발톱 아래 뭘 숨겼을지 Watch out 우린 더 높이 하늘에 닿을 것처럼 외쳐 너를 깨워 올려 봐 노려봐 넌 내 거니까 다 자꾸 널 보면 탐이 탐이 나 해야 해야 해야 한입에 널 삼킬 때야 (탐이 탐이 나) 해야 해야 해야 이미 내가 이긴 패야 (널 보면 탐이 탐이 나) 해야 해야 해야 뜨겁게 떠오르는 해야 별안간 홀린 그 순간 Bite 단 한 번에 난 널 휘리휘리 Catch ya 휘리휘리 휘리휘리 휘리휘리 휘리휘리 더 붉게 더 밝게 타올라 뜨거워도 좋으니 더 높게 더 높게 숨어도 넌 내 손바닥 안이니 깊은 어둠이 짙은 구름이 또 긴 밤 아래 널 감출 테니 Chew and swallow Get ready for it, baby (Listen when I say) 자꾸 널 보면 탐이 탐이 나 해야 해야 해야 한입에 널 삼킬 때야 (탐이 탐이 나) 해야 해야 해야 이미 내가 이긴 패야 (널 보면 탐이 탐이 나) 해야 해야 해야 뜨겁게 떠오르는 해야 별안간 홀린 그 순간 Bite Da da da dun dun dun"
        case 2:
            return "I'm like some kind of Supernova Watch out Look at me go 재미 좀 볼 빛의 Core So hot hot 문이 열려 서로의 존재를 느껴 마치 Discord 날 닮은 너 너 누구야 (Drop) 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay That tick that tick tick bomb That tick that tick tick bomb 감히 건드리지 못할 걸 (누구도 말이야) 지금 내 안에선 Su su su Supernova Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova Ah Body bang Make it feel too right 휩쓸린 에너지 It's so special 잔인한 Queen 이며 Scene 이자 종결 이토록 거대한 내 안의 Explosion 내 모든 세포 별로부터 만들어져 (Under my control Ah) 질문은 계속돼 Ah Oh Ay 우린 어디서 왔나 Oh Ay 느껴 내 안에선 Su su su Supernova Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova 보이지 않는 힘으로 네게 손 내밀어 볼까 가능한 모든 가능성 무한 속의 너를 만나 It's about to bang bang Don't forget my name Su su su Supernova 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay 우린 어디서 왔나 Oh Ay 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay Tell me, tell me, tell me Oh Ay 우린 어디서 왔나 Oh Ay 우린 어디서 왔나 Oh Ay Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova 사건은 다가와 Ah Oh Ay (Nu star) 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay (Nova) 우린 어디서 왔나 Oh Ay 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay (Nova) Bring the light of a dying star Supernova"
        case 3:
            return "One! Two! Q! W! E! R! 어떤 인사가 괜찮을까 천 번쯤 상상해 봤어 근데 오늘도 천 번 하고 한 번 더 고민 중 막상 네 앞에 서니 꽁꽁 얼어버렸다 숨겨왔던 나의 맘 절반의 반도 주지를 못했어 아, 아, 아직은 준비가 안됐다구요 소용돌이쳐 어지럽다구 쏟아지는 맘을 멈출 수가 없을까? 너의 작은 인사 한마디에 요란해져서 네 맘의 비밀번호 눌러 열고 싶지만 너를 고민고민해도 좋은 걸 어쩌니 거울 앞에서 새벽까지 연습한 인사가 손을 들고 웃는 얼굴을 하고서 고개를 숙였다 아, 아, 아직도 준비가 안됐나 봐요 소용돌이쳐 어지럽다구 쏟아지는 맘을 멈출 수가 없을까? 너의 작은 인사 한마디에 요란해져서 네 맘의 비밀번호 눌러 열고 싶지만 너를 고민고민해도 좋은 걸 이러지도 저러지도 못하는데 속이 왈칵 뒤집히고 이쯤 왔으면 눈치 챙겨야지 날 봐달라구요! 좋아한다 너를 좋아한다 좋아해 너를 많이 많이 좋아한단 말이야 벅차오르다 못해 내 맘이 쿡쿡 아려와 두 번은 말 못 해 너 지금 잘 들어봐 매일 고민하고 연습했던 말 좋아해"
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
