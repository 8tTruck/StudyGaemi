//
//  BottomSheetViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/11/24.
//

import SnapKit
import UIKit

class BottomSheetViewController: UIViewController {
    
    private let bottomSheetView = BottomSheetView()
    private var containerBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        setupView()
        setupGestures()
        setupKeyboardNotifications()
        
        bottomSheetView.textField.delegate = self
        bottomSheetView.confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        bottomSheetView.cancelButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
    }
    
    private func setupView() {
        view.addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        bottomSheetView.containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.height.equalTo(200)
            self.containerBottomConstraint = make.bottom.equalTo(view).constraint // 초기 제약 조건 설정
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        bottomSheetView.dragBar.addGestureRecognizer(panGesture)
        bottomSheetView.textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func confirmButtonTapped() {
        if let nickname = bottomSheetView.textField.text, !nickname.isEmpty {
            NotificationCenter.default.post(name: .nicknameDidUpdate, object: nil, userInfo: ["nickname": nickname])
            AuthenticationManager.shared.saveNickname(nickname) { success, error in
                if let error = error {
                    print("닉네임 저장 실패: \(error.localizedDescription)")
                } else {
                    print("닉네임 저장 성공")
                }
            }
        }
        dismissBottomSheet()
    }
    
    @objc private func dismissBottomSheet() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if translation.y > 0 {
            dismissBottomSheet()
        } else if translation.y < 0 {
            bottomSheetView.textField.becomeFirstResponder()
        }
    }
    
    @objc private func textFieldDidBeginEditing() {
        bottomSheetView.textField.becomeFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        containerBottomConstraint?.update(offset: -keyboardHeight)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        containerBottomConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

extension BottomSheetViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension Notification.Name {
    static let nicknameDidUpdate = Notification.Name("nicknameDidUpdate")
}
