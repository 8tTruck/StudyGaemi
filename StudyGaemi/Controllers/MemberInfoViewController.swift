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
        setupBackButton()
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
        guard let currentPassword = memberInfoView.currentPasswordField.text,
              let newPassword = memberInfoView.newPasswordField.text,
              let confirmPassword = memberInfoView.confirmPasswordField.text else { return }
        
        if newPassword != confirmPassword {
            let alertController = UIAlertController(title: "비밀번호 변경 오류", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            self.present(alertController, animated: true, completion: nil)
            return
        } else if !isPasswordValid(newPassword) {
            memberInfoView.newPasswordLabel.text = "비밀번호는 영문 + 숫자 + 특수문자 8자리 이상이어야 합니다."
            memberInfoView.newPasswordLabel.textColor = UIColor(named: "fontRed")
        } else {
            memberInfoView.confirmPasswordLabel.textColor = UIColor(named: "fontGray")
            memberInfoView.errorLabel.text = ""
            
            AuthenticationManager.shared.updatePassword(currentPassword: currentPassword, newPassword: newPassword) { success, error in
                if success {
                    let alertController = UIAlertController(title: "비밀번호 변경", message: "비밀번호가 성공적으로 변경되었습니다.", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "비밀번호 변경 오류", message: "현재 비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
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
        memberInfoView.currentPasswordLabel.text = "영문 + 숫자 + 특수문자 8자리 이상"
        
        memberInfoView.newPasswordLabel.textColor = UIColor(named: "fontGray")
        memberInfoView.newPasswordLabel.text = "영문 + 숫자 + 특수문자 8자리 이상"
        
        memberInfoView.confirmPasswordLabel.textColor = UIColor(named: "fontGray")
        memberInfoView.confirmPasswordLabel.text = "영문 + 숫자 + 특수문자 8자리 이상"
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
            memberInfoView.confirmPasswordLabel.text = "영문 + 숫자 + 특수문자 8자리 이상"
        }
    }
    
    private func isPasswordValid(_ password: String) -> Bool {
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]?)(?=.*[A-Za-z0-9!@#$%^&*(),.?\":{}|<>]).{8,}$")
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
            resetLabelsToDefaultState()
        }
    }
}
