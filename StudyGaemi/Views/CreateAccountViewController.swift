//
//  CreateAccountViewController.swift
//  StudyGaemi
//
//  Created by Seungseop Lee on 6/3/24.
//

import UIKit
import SnapKit

class CreateAccountViewController: UIViewController {
    
    var selectedLabelText: String = "기본값"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        agreementSetting()
    }
    
    func agreementSetting() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        let label = UILabel()
        label.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = selectedLabelText
        label.textAlignment = .left
        
        scrollView.addSubview(label)
        
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-50)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(10)
            make.width.equalTo(scrollView).offset(-20)
        }
    }
}

/*
import UIKit
import SnapKit

class CreateAccountViewController: UIViewController {
    
    let confirmButton = CustomButton(title: "확인")
    let useAgreeButton = UIButton()
    let useAgreeLabel = UILabel()
    let ageButton = UIButton()
    let ageLabel = UILabel()
    let offImage = UIImage(named: "checkboxOff")
    let onImage = UIImage(named: "checkboxOn")
    let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
    var useAgree = false
    var overAge = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        //        confirmButtonSetting()
        //        ageSetting()
        //        useAgreeSetting()
        agreementSetting()
    }
    
    func agreementSetting() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        let label = UILabel()
        
        label.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "기본값"
        label.textAlignment = .left
        
        scrollView.addSubview(label)
        
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            //            make.bottom.equalTo(useAgreeLabel.snp.top).offset(-15)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-400)
            // 임시
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            //            make.width.equalTo(370)
            //            make.height.equalTo(500)
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalTo(scrollView).inset(10)
            make.width.equalTo(scrollView).offset(-20)
        }
    }
}
*/
    /*
    func confirmButtonSetting() {
        view.addSubview(confirmButton)
        confirmButton.addTouchAnimation()
        
        confirmButton.snp.makeConstraints { make in
            make.width.equalTo(335)
            make.height.equalTo(52)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.centerX.equalTo(view)
        }
        
        confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        
        confirmButton.isEnabled = useAgree && overAge
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func ageSetting() {
        ageLabel.text = "[필수] 만 14세 이상의 사용자입니다"
        
        ageLabel.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        ageButton.setImage(offImage, for: .normal)
        ageButton.addTarget(self, action: #selector(ageButtonTapped), for: .touchUpInside)
        ageButton.addTouchAnimation()
        
        let ageStackView = UIStackView(arrangedSubviews: [ageButton, ageLabel])
        ageStackView.axis = .horizontal
        ageStackView.spacing = 8
        
        view.addSubview(ageStackView)
        
        ageStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.bottom.equalTo(confirmButton.snp.top).offset(-15)
        }
        
        ageButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    @objc func ageButtonTapped() {
        if ageButton.imageView?.image == offImage {
            ageButton.setImage(onImage, for: .normal)
            overAge = true
        } else {
            ageButton.setImage(offImage, for: .normal)
            overAge = false
        }
        
        updateConfirmButtonState()
    }
    
    func useAgreeSetting() {
        useAgreeLabel.text = "[필수] 개인정보 처리 방침에 동의합니다"
        useAgreeLabel.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        
        useAgreeButton.setImage(offImage, for: .normal)
        useAgreeButton.addTarget(self, action: #selector(useAgreeButtonTapped), for: .touchUpInside)
        useAgreeButton.addTouchAnimation()
        
        let useAgreeStackView = UIStackView(arrangedSubviews: [useAgreeButton, useAgreeLabel])
        useAgreeStackView.axis = .horizontal
        useAgreeStackView.spacing = 8
        
        view.addSubview(useAgreeStackView)
        
        useAgreeStackView.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
            make.bottom.equalTo(confirmButton.snp.top).offset(-60)
        }
        
        useAgreeButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
    }
    
    @objc func useAgreeButtonTapped() {
        if useAgreeButton.imageView?.image == offImage {
            useAgreeButton.setImage(onImage, for: .normal)
            useAgree = true
        } else {
            useAgreeButton.setImage(offImage, for: .normal)
            useAgree = false
        }
        
        updateConfirmButtonState()
    }
    
    @objc func confirmButtonTapped() {
        print("버튼 누름")
        moveNextVC()
    }
    
    func updateConfirmButtonState() {
        let isButtonEnabled = useAgree && overAge
        confirmButton.isEnabled = isButtonEnabled
        
        if isButtonEnabled {
            confirmButton.gradient.colors = [UIColor(named: "pointOrange")?.cgColor ?? UIColor.orange.cgColor,
                                             UIColor(named: "pointYellow")?.cgColor ?? UIColor.yellow.cgColor]
        } else {
            let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
            confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        }
    }
    
    func moveNextVC() {
        let makePasswordVC = MakePasswordViewController()
        makePasswordVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(makePasswordVC, animated: true)
//        let emailInputVC = EmailInputViewController()
//        emailInputVC.modalPresentationStyle = .fullScreen
////        present(emailInputVC, animated: true, completion: nil)
//        self.navigationController?.pushViewController(emailInputVC, animated: true)

    }
}
*/
