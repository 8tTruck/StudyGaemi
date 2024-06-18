//
//  BottomSheetViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/11/24.
//

import SnapKit
import UIKit

class BottomSheetViewController: UIViewController {
    
    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let textField = UITextField()
    private let confirmButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let dragBar = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        setupViews()
        setupConstraints()
        setupGestures()
        
        textField.delegate = self
    }
    
    private func setupViews() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        dragBar.backgroundColor = .lightGray
        dragBar.layer.cornerRadius = 2
        
        titleLabel.text = "닉네임 변경하개미?"
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        
        textField.placeholder = "변경할 닉네임을 입력해주개미"
        textField.borderStyle = .roundedRect
        
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.backgroundColor = UIColor(named: "pointOrange")
        confirmButton.tintColor = .white
        confirmButton.layer.cornerRadius = 10
        confirmButton.clipsToBounds = true
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = .gray
        cancelButton.addTarget(self, action: #selector(dismissBottomSheet), for: .touchUpInside)
        
        view.addSubview(containerView)
        containerView.addSubview(dragBar)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(confirmButton)
        containerView.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.height.equalTo(200)
        }
        
        dragBar.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(8)
            make.centerX.equalTo(containerView)
            make.width.equalTo(40)
            make.height.equalTo(4)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dragBar.snp.bottom).offset(10)
            make.centerX.equalTo(containerView)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.height.equalTo(44)
        }
    }
    
    private func setupGestures() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        dragBar.addGestureRecognizer(panGesture)
        textField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
    }
    
    @objc private func confirmButtonTapped() {
        if let nickname = textField.text, !nickname.isEmpty {
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
            textField.becomeFirstResponder()
        }
    }
    
    @objc private func textFieldDidBeginEditing() {
        textField.becomeFirstResponder()
    }
    
    func adjustForKeyboard(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardFrame.height
        
        containerView.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(-keyboardHeight)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func resetForKeyboard() {
        containerView.snp.updateConstraints { make in
            make.bottom.equalTo(view).offset(0)
        }
        
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
