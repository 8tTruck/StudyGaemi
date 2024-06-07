//
//  EmailInputViewController.swift
//  StudyGaemi
//
//  Created by Seungseop Lee on 6/4/24.
//

import UIKit
import SnapKit

class EmailInputViewController: UIViewController {
    
    let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
    
    let mainImage = UIImageView()
    let mainLabel = UILabel()
    
    let textField = CustomTextField(text: "이메일을 입력하세요")
    let confirmButton = CustomButton(title: "인증코드 받기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        mainImageSetting()
        mainLabelSetting()
        textFieldSetting()
        confirmButtonSetting()
        
        confirmButton.isEnabled = isValidEmail(email: textField.text ?? "")

        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func mainImageSetting() {
        mainImage.image = UIImage(named: "mainAnt")
        mainImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainImage)
        
        mainImage.snp.makeConstraints { make in
            make.width.equalTo(208)
            make.height.equalTo(124)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
        }
    }
    
    func mainLabelSetting() {
        view.addSubview(mainLabel)
        mainLabel.text = "E-mail 인증하기"
        mainLabel.textColor = UIColor(named: "pointOrange")
        mainLabel.font = UIFont(name: CustomFontType.bold.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        mainLabel.snp.makeConstraints { make in
//            make.centerX.equalToSuperview()
//            make.leading.equalToSuperview().offset(20)
            make.leading.equalTo(mainImage.snp.leading).offset(-65)
            make.top.equalTo(mainImage.snp.bottom).offset(40)
        }
    }
    
    func textFieldSetting() {
        view.addSubview(textField)
        
        textField.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(14)
            make.width.equalTo(342)
            make.height.equalTo(60)
        }
    }
    
    func confirmButtonSetting() {
        view.addSubview(confirmButton)
        confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        confirmButton.addTouchAnimation()
        confirmButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
//            make.top.equalTo(textField.snp.bottom).offset(12)
            make.top.equalToSuperview().offset(405)
            make.width.equalTo(342)
            make.height.equalTo(60)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        updateConfirmButtonState()
    }
    
    @objc func confirmButtonTapped() {
        showAlert(with: textField.text ?? "")
    }
    
    func showAlert(with email: String) {
        let alertController = UIAlertController(title: email, message: "정말 이 이메일이 맞습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let sendAction = UIAlertAction(title: "전송", style: .default) { _ in
            self.sendConfirmEmail()
            self.moveNextVC()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateConfirmButtonState() {
        let isButtonEnabled = isValidEmail(email: textField.text ?? "")
        confirmButton.isEnabled = isButtonEnabled
    
        if isButtonEnabled {
            confirmButton.gradient.colors = [UIColor(named: "pointOrange")?.cgColor ?? UIColor.orange.cgColor,
                                             UIColor(named: "pointYellow")?.cgColor ?? UIColor.yellow.cgColor]
        } else {
            let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
            confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        }
    }
    
    func isValidEmail(email: String) -> Bool {
        // 이메일 주소를 확인하기 위한 정규식 패턴
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        // NSPredicate를 사용하여 이메일 주소가 패턴에 일치하는지 확인
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func sendConfirmEmail() {
        // 여기에 인증 이메일 보내는 코드 작성 필요
        print("인증 이메일이 전송되었습니다.")
    }
    
    func moveNextVC() {
        let emailConfirmVC = EmailConfirmViewController()
        emailConfirmVC.modalPresentationStyle = .fullScreen
//        present(emailConfirmVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(emailConfirmVC, animated: true)
    }
}
