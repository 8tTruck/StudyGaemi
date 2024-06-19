//
//  MemberInfoViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/9/24.
//

import SnapKit
import UIKit
import Firebase

class MemberInfoViewController: BaseViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let currentPasswordField = CustomTextField(text: "기존 비밀번호를 입력해주세요")
    private let newPasswordField = CustomTextField(text: "새로운 비밀번호를 입력해주세요")
    private let confirmPasswordField = CustomTextField(text: "새 비밀번호를 한 번 더 입력해주세요")
    private let confirmButton = UIButton()
    private let errorLabel = UILabel()
    private let currentPasswordLabel = UILabel()
    private let newPasswordLabel = UILabel()
    private let confirmPasswordLabel = UILabel()
    
    private var confirmButtonBottomConstraint: Constraint?
    private var originalConfirmButtonBottomOffset: CGFloat = -30

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardNotifications()
        setupTapGesture()
        setupBackButton()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        // 네비게이션 바 설정
        navigationItem.title = "비밀번호 변경"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(800) // 충분한 높이 설정
        }
        
        setupLabel(currentPasswordLabel, text: "영문 + 숫자 8자리 이상")
        setupLabel(newPasswordLabel, text: "영문 + 숫자 8자리 이상")
        setupLabel(confirmPasswordLabel, text: "영문 + 숫자 8자리 이상")
        
        errorLabel.textColor = UIColor(named: "fontRed")
        errorLabel.textAlignment = .center
        errorLabel.text = ""
        
        confirmButton.backgroundColor = UIColor(named: "pointOrange")
        confirmButton.layer.cornerRadius = 24
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 16)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(currentPasswordField)
        contentView.addSubview(currentPasswordLabel)
        contentView.addSubview(newPasswordField)
        contentView.addSubview(newPasswordLabel)
        contentView.addSubview(confirmPasswordField)
        contentView.addSubview(confirmPasswordLabel)
        contentView.addSubview(errorLabel)
        contentView.addSubview(confirmButton)
        
        currentPasswordField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        currentPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        newPasswordField.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        newPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(newPasswordField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            self.confirmButtonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(originalConfirmButtonBottomOffset).constraint
        }
        
        [currentPasswordField, newPasswordField, confirmPasswordField].forEach { textField in
            textField.isSecureTextEntry = true
            textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
    }
    
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(named: "fontGray")
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc internal override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            print("Keyboard frame not available")
            return
        }
        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom
        print("Keyboard will show with height: \(keyboardHeight)")
        UIView.animate(withDuration: 0.3) {
            self.confirmButtonBottomConstraint?.update(offset: -keyboardHeight - 10)
            self.scrollView.contentInset.bottom = keyboardHeight
            self.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        print("Keyboard will hide")
        UIView.animate(withDuration: 0.3) {
            self.confirmButtonBottomConstraint?.update(offset: self.originalConfirmButtonBottomOffset)
            self.scrollView.contentInset.bottom = 0
            self.scrollView.verticalScrollIndicatorInsets.bottom = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func confirmButtonTapped() {
        guard let currentPassword = currentPasswordField.text,
              let newPassword = newPasswordField.text,
              let confirmPassword = confirmPasswordField.text else { return }
        
        if newPassword != confirmPassword {
            confirmPasswordLabel.text = "비밀번호가 일치하지 않습니다."
            confirmPasswordLabel.textColor = UIColor(named: "fontRed")
        } else if !isPasswordValid(newPassword) {
            newPasswordLabel.text = "비밀번호는 영문 + 숫자 8자리 이상이어야 합니다."
            newPasswordLabel.textColor = UIColor(named: "fontRed")
        } else {
            confirmPasswordLabel.textColor = UIColor(named: "fontGray")
            errorLabel.text = ""
            
            AuthenticationManager.shared.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { success, error in
                if success {
                    let alertController = UIAlertController(title: "비밀번호 변경", message: "비밀번호가 성공적으로 변경되었습니다.", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    confirmAction.setValue(UIColor(named: "fontRed"), forKey: "titleTextColor")
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                } else if error == "비밀번호가 일치하지 않습니다." {
                    let alertController = UIAlertController(title: "비밀번호 변경 오류", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    confirmAction.setValue(UIColor(named: "fontRed"), forKey: "titleTextColor")
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.errorLabel.text = error
                    self.errorLabel.textColor = UIColor(named: "fontRed")
                }
            }
        }
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        // 현재 텍스트 필드가 currentPasswordField일 때는 newPasswordLabel의 색상을 변경하지 않음
        if textField == currentPasswordField {
            updatePasswordLabels(ignoreNewPasswordField: true)
        } else {
            updatePasswordLabels(ignoreNewPasswordField: false)
        }
    }
    
    private func updatePasswordLabels(ignoreNewPasswordField: Bool) {
        let currentPasswordValid = isPasswordValid(currentPasswordField.text ?? "")
        let newPasswordValid = isPasswordValid(newPasswordField.text ?? "")
        let confirmPasswordValid = newPasswordField.text == confirmPasswordField.text
        
        currentPasswordLabel.textColor = currentPasswordValid ? UIColor(named: "fontGray") : UIColor(named: "fontRed")
        if !ignoreNewPasswordField {
            newPasswordLabel.textColor = newPasswordValid ? UIColor(named: "fontGray") : UIColor(named: "fontRed")
        }
        confirmPasswordLabel.textColor = confirmPasswordValid ? UIColor(named: "fontGray") : UIColor(named: "fontRed")
        
        if !confirmPasswordValid {
            confirmPasswordLabel.text = "비밀번호가 일치하지 않습니다."
        } else {
            confirmPasswordLabel.text = "영문 + 숫자 8자리 이상"
        }
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d).{8,}$")
        return passwordPredicate.evaluate(with: password)
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 17)
        backButton.tintColor = UIColor(named: "fontBlack")
        backButton.setTitleColor(UIColor(named: "fontBlack"), for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MemberInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor(named: "fontBlack")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            textField.textColor = UIColor(named: "fontGray")
        }
    }
}
