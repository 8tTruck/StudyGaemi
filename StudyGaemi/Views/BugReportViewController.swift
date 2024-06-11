//
//  BugReportViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/9/24.
//

import SnapKit
import Then
import UIKit

class BugReportViewController: BaseViewController {
    private let bugReportView = UIView()
    private let textView = UITextView()
    private let fixedHeaderView = UIView()
    private let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFixedHeaderView()
        configureBugReportView()
        configureTextView()
        configureSubmitButton()
        setupKeyboardNotifications()
    }
    
    private func setupFixedHeaderView() {
        view.addSubview(fixedHeaderView)
        fixedHeaderView.backgroundColor = .white
        fixedHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44) // 고정된 높이 설정
        }
        
        // submitButton을 fixedHeaderView에 추가합니다.
        fixedHeaderView.addSubview(submitButton)
        submitButton.backgroundColor = UIColor(named: "pointOrange")
        submitButton.layer.cornerRadius = 24
        submitButton.setTitle("제출", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        
        submitButton.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(48)
            make.centerX.equalToSuperview() // 가운데 정렬
            make.bottom.equalToSuperview().offset(-10) // fixedHeaderView에 대해 bottom에 추가
        }
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
            make.top.equalTo(fixedHeaderView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(submitButton.snp.top).offset(-50) // submitButton과의 간격 설정
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
            make.width.equalTo(342)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(44)
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
            let alertController = UIAlertController(title: "오류 및 버그 신고", message: "성공적으로 제출되었습니다.", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.clearTextView()
            })
            confirmAction.setValue(UIColor.orange, forKey: "titleTextColor")
            
            alertController.addAction(confirmAction)
            
            // 뒷 배경을 하얗게 설정
            let backgroundView = alertController.view.subviews.first?.subviews.first?.subviews.first
            backgroundView?.backgroundColor = UIColor.white
            
            present(alertController, animated: true, completion: nil)
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
        
        bugReportView.snp.updateConstraints { make in
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
