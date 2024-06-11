//
//  CreateAccountViewController.swift
//  StudyGaemi
//
//  Created by Seungseop Lee on 6/3/24.
//

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
        confirmButtonSetting()
        ageSetting()
        useAgreeSetting()
        agreementSetting()
    }
    
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
    
    func agreementSetting() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        
        let label = UILabel()
        
        label.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.text = "I'm like some kind of Supernova Watch out Look at me go 재미 좀 볼 빛의 Core So hot hot 문이 열려 서로의 존재를 느껴 마치 Discord 날 닮은 너 너 누구야 (Drop) 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay That tick that tick tick bomb That tick that tick tick bomb 감히 건드리지 못할 걸 (누구도 말이야) 지금 내 안에선 Su su su Supernova Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova Ah Body bang Make it feel too right 휩쓸린 에너지 It's so special 잔인한 Queen 이며 Scene 이자 종결 이토록 거대한 내 안의 Explosion 내 모든 세포 별로부터 만들어져 (Under my control Ah) 질문은 계속돼 Ah Oh Ay 우린 어디서 왔나 Oh Ay 느껴 내 안에선 Su su su Supernova Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova 보이지 않는 힘으로 네게 손 내밀어 볼까 가능한 모든 가능성 무한 속의 너를 만나 It's about to bang bang Don't forget my name Su su su Supernova 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay 우린 어디서 왔나 Oh Ay 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay Tell me, tell me, tell me Oh Ay 우린 어디서 왔나 Oh Ay 우린 어디서 왔나 Oh Ay Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova 사건은 다가와 Ah Oh Ay (Nu star) 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay (Nova) 우린 어디서 왔나 Oh Ay 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay (Nova) Bring the light of a dying star Supernova"
        label.textAlignment = .left
        
        scrollView.addSubview(label)
        
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(useAgreeLabel.snp.top).offset(-15)
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
