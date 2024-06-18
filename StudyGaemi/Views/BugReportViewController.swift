import SnapKit
import Then
import UIKit
import MessageUI

class BugReportViewController: BaseViewController, MFMailComposeViewControllerDelegate {
    private let bugReportView = UIView()
    private let textView = UITextView()
    private let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        configureBugReportView()
        configureTextView()
        configureSubmitButton()
        setupKeyboardNotifications()
    }
    
    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.tintColor = .black // 이미지 색상을 검은색으로 설정
        backButton.setTitleColor(.black, for: .normal) // 텍스트 색상을 검은색으로 설정
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc private func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureBugReportView() {
        view.addSubview(bugReportView)
        bugReportView.backgroundColor = .white
        bugReportView.layer.cornerRadius = 10
        bugReportView.layer.shadowColor = UIColor.black.cgColor
        bugReportView.layer.shadowOpacity = 0.1
        bugReportView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bugReportView.layer.shadowRadius = 4
        
        bugReportView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func configureTextView() {
        textView.text = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        textView.textColor = .gray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.delegate = self
        textView.isScrollEnabled = true // 스크롤 가능하게 설정
        
        bugReportView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(200) // 고정된 높이 설정
        }
    }
    
    private func configureSubmitButton() {
        view.addSubview(submitButton)
        submitButton.backgroundColor = UIColor(named: "pointOrange")
        submitButton.layer.cornerRadius = 24
        submitButton.setTitle("제출", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(bugReportView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    @objc private func submitButtonTapped() {
        if textView.text.isEmpty || textView.textColor == .gray {
            let alertController = UIAlertController(title: "경고", message: "내용을 입력해주개미.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            confirmAction.setValue(UIColor.orange, forKey: "titleTextColor")
            alertController.addAction(confirmAction)
            
            // 뒷 배경을 하얗게 설정
            let backgroundView = alertController.view.subviews.first?.subviews.first?.subviews.first
            backgroundView?.backgroundColor = UIColor.white
            
            present(alertController, animated: true, completion: nil)
        } else {
            sendEmail(withContent: textView.text)
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
                
                // 뒷 배경을 하얗게 설정
                let backgroundView = alertController.view.subviews.first?.subviews.first?.subviews.first
                backgroundView?.backgroundColor = UIColor.white
                
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
        textView.text = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        textView.textColor = .gray
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
        submitButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight - 30)
        }
        
        bugReportView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(submitButton.snp.top).offset(-28)
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
        if textView.textColor == .gray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .gray
            textView.text = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        }
    }
}
