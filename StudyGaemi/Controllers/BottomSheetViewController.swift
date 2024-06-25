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
        bottomSheetView.deleteAccountButton.addTarget(self, action: #selector(showDeleteAlert), for: .touchUpInside)

    }
    
    private func setupView() {
        view.addSubview(bottomSheetView)
        bottomSheetView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        bottomSheetView.containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view).inset(10)
            make.height.equalTo(250)
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
    
    @objc func showDeleteAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let titleString = NSAttributedString(string: "회원탈퇴", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ])
        
        let messageString = NSAttributedString(string: """
        회원탈퇴시 모든 정보가 삭제됩니다.
        정말 회원탈퇴하시겠습니까?
        """, attributes: [
            .font: UIFont.systemFont(ofSize: 14)
        ])
        
        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")
        
        let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")
        
        let confirmAction = UIAlertAction(title: "예", style: .destructive, handler: { _ in
            let dispatchGroup = DispatchGroup()
            
            AuthenticationManager.shared.kakaoUnlinkAndSignOut()
            
            dispatchGroup.enter()
            FirestoreManager.shared.deleteStudyData { result in
                switch result {
                case .success:
                    print("Study 데이터가 삭제되었습니다.")
                case .failure(let error):
                    print("Study 데이터 삭제 에러: \(error)")
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            FirestoreManager.shared.deleteWakeUpData { result in
                switch result {
                case .success:
                    print("WakeUp 데이터가 삭제되었습니다.")
                case .failure(let error):
                    print("WakeUp 데이터 삭제 에러: \(error)")
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            FirestoreManager.shared.deleteUserData { result in
                switch result {
                case .success:
                    print("User 데이터가 삭제되었습니다.")
                case .failure(let error):
                    print("User 데이터 삭제 에: \(error)")
                }
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                print("모든 데이터 삭제 작업이 완료되었습니다.")
                AuthenticationManager.shared.deleteUser()
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "회원탈퇴 처리되었습니다.", message: nil, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                        AuthenticationManager.shared.signOut()
                        AlarmCoreDataManager.shared.deleteAlarm()
                        self.completeLogout()
                    }
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func completeLogout() {
        AlarmCoreDataManager.shared.deleteAlarm()
        DispatchQueue.main.async {
            let loginVC = UINavigationController(rootViewController: LoginViewController())
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
            }
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
