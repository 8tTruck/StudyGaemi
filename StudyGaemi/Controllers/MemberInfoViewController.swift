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
    let memberInfoView = MemberInfoView()
    
    private var confirmButtonBottomConstraint: Constraint?
    private var originalConfirmButtonBottomOffset: CGFloat = -30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardNotifications()
        setupTapGesture()
    }
    
    private func setupUI() {
        view.addSubview(memberInfoView)
        memberInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        memberInfoView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        [memberInfoView.currentPasswordField, memberInfoView.newPasswordField, memberInfoView.confirmPasswordField].forEach { textField in
            textField.delegate = self
            textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        }
        
        memberInfoView.confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            self.confirmButtonBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide).offset(originalConfirmButtonBottomOffset).constraint
        }
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
            self.memberInfoView.scrollView.contentInset.bottom = keyboardHeight
            self.memberInfoView.scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        print("Keyboard will hide")
        UIView.animate(withDuration: 0.3) {
            self.confirmButtonBottomConstraint?.update(offset: self.originalConfirmButtonBottomOffset)
            self.memberInfoView.scrollView.contentInset.bottom = 0
            self.memberInfoView.scrollView.verticalScrollIndicatorInsets.bottom = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func confirmButtonTapped() {
        // 키보드를 내림
        view.endEditing(true)
        
        // 비밀번호 변경 로직을 0.1초 지연시켜 키보드가 내려간 후에 실행
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard let currentPassword = self.memberInfoView.currentPasswordField.text,
                  let newPassword = self.memberInfoView.newPasswordField.text,
                  let confirmPassword = self.memberInfoView.confirmPasswordField.text else { return }
            
            if newPassword != confirmPassword {
                self.showAlert(title: "비밀번호 변경 오류", message: "비밀번호가 일치하지 않습니다.")
                return
            } else if newPassword == currentPassword {
                self.showAlert(title: "비밀번호 변경 오류", message: "기존 비밀번호와 동일합니다.")
                return
            } else if !self.isPasswordValid(newPassword) {
                self.memberInfoView.newPasswordLabel.text = "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다."
                self.memberInfoView.newPasswordLabel.textColor = UIColor(named: "fontRed")
            } else {
                self.memberInfoView.confirmPasswordLabel.textColor = UIColor(named: "fontGray")
                self.memberInfoView.errorLabel.text = ""
                
                AuthenticationManager.shared.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { success, error in
                    if success {
                        self.showAlert(title: "비밀번호 변경", message: "비밀번호가 성공적으로 변경되었습니다.") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.showAlert(title: "비밀번호 변경 오류", message: "현재 비밀번호가 일치하지 않습니다.")
                    }
                }
            }
        }
    }
    
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        }
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func textFieldEditingChanged(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            resetLabelsToDefaultState()
        } else {
            updatePasswordLabels(ignoreNewPasswordField: false)
            if textField == memberInfoView.currentPasswordField {
                memberInfoView.newPasswordLabel.textColor = UIColor(named: "fontGray")
            }
        }
    }
    
    private func resetLabelsToDefaultState() {
        memberInfoView.currentPasswordLabel.textColor = UIColor(named: "fontGray")
        memberInfoView.currentPasswordLabel.text = "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다."
        
        memberInfoView.newPasswordLabel.textColor = UIColor(named: "fontGray")
        memberInfoView.newPasswordLabel.text = "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다."
        
        memberInfoView.confirmPasswordLabel.textColor = UIColor(named: "fontGray")
        memberInfoView.confirmPasswordLabel.text = "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다."
    }
    
    private func updatePasswordLabels(ignoreNewPasswordField: Bool) {
        let currentPasswordValid = isPasswordValid(memberInfoView.currentPasswordField.text ?? "")
        let newPasswordValid = isPasswordValid(memberInfoView.newPasswordField.text ?? "")
        let confirmPasswordValid = memberInfoView.newPasswordField.text == memberInfoView.confirmPasswordField.text
        
        memberInfoView.currentPasswordLabel.textColor = currentPasswordValid ? UIColor(named: "fontGray") : UIColor(named: "fontRed")
        if !ignoreNewPasswordField {
            memberInfoView.newPasswordLabel.textColor = newPasswordValid ? UIColor(named: "fontGray") : UIColor(named: "fontRed")
        }
        memberInfoView.confirmPasswordLabel.textColor = confirmPasswordValid ? UIColor(named: "fontGray") : UIColor(named: "fontRed")
        
        if !confirmPasswordValid {
            memberInfoView.confirmPasswordLabel.text = "비밀번호가 일치하지 않습니다."
        } else {
            memberInfoView.confirmPasswordLabel.text = "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다."
        }
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]?)(?=.*[A-Za-z0-9!@#$%^&*(),.?\":{}|<>]).{8,}$")
        return passwordPredicate.evaluate(with: password)
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
            resetLabelsToDefaultState()
        }
    }
}
