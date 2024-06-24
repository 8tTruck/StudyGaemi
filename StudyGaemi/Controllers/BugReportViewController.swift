//
//  BugReportViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/20/24.
//

import SnapKit
import Then
import UIKit
import MessageUI

class BugReportViewController: BaseViewController, MFMailComposeViewControllerDelegate {
    
    private let bugReportView = BugReportView()
    
    override func loadView() {
        view = bugReportView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotifications()
        bugReportView.textView.delegate = self
    }

    @objc func submitButtonTapped() {
        if bugReportView.textView.text.isEmpty || bugReportView.textView.textColor == UIColor(named: "fontGray") {
            let alertController = UIAlertController(title: "경고", message: "내용을 입력해주개미", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            
            let backgroundView = alertController.view.subviews.first?.subviews.first?.subviews.first
            backgroundView?.backgroundColor = UIColor(named: "viewBackgroundColor")
            
            present(alertController, animated: true, completion: nil)
        } else {
            sendEmail(withContent: bugReportView.textView.text)
        }
    }
    
    private func sendEmail(withContent content: String) {
        guard MFMailComposeViewController.canSendMail() else {
            let alertController = UIAlertController(title: "이메일 설정 오류", message: "이메일 계정이 설정되어 있지 않습니다. 설정 후 다시 시도해주세요.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients(["taengdev@gmail.com"])
        mailComposeViewController.setSubject("오류 및 버그 신고")
        mailComposeViewController.setMessageBody(content, isHTML: false)
        
        present(mailComposeViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) {
            if result == .sent {
                let alertController = UIAlertController(title: "오류 및 버그 신고", message: "성공적으로 제출되었습니다.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                    self.clearTextView()
                })
                confirmAction.setValue(UIColor.orange, forKey: "titleTextColor")
                alertController.addAction(confirmAction)
                
                let backgroundView = alertController.view.subviews.first?.subviews.first?.subviews.first
                backgroundView?.backgroundColor = UIColor(named: "viewBackgroundColor")
                
                self.present(alertController, animated: true, completion: nil)
            } else if result == .failed {
                let alertController = UIAlertController(title: "오류 및 버그 신고 실패", message: "이메일 전송에 실패하였습니다. 다시 시도해주세요.", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                confirmAction.setValue(UIColor.orange, forKey: "titleTextColor")
                alertController.addAction(confirmAction)
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func clearTextView() {
        bugReportView.textView.text = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        bugReportView.textView.textColor = UIColor(named: "fontGray")
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            updateConstraintsForKeyboardAppearance(keyboardHeight: keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        updateConstraintsForKeyboardAppearance(keyboardHeight: 0)
    }
    
    private func updateConstraintsForKeyboardAppearance(keyboardHeight: CGFloat) {
        bugReportView.submitButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight - 30)
        }
        
        bugReportView.bugReportView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(bugReportView.submitButton.snp.top).offset(-28)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension BugReportViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "fontGray") {
            textView.text = nil
            textView.textColor = UIColor(named: "fontBlack")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor(named: "fontGray")
            textView.text = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        }
    }
}
