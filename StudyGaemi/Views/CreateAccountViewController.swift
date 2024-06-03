//
//  CreateAccountViewController.swift
//  StudyGaemi
//
//  Created by Seungseop Lee on 6/3/24.
//

import UIKit

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
        view.backgroundColor = .white
        confirmButtonSetting()
        ageSetting()
        useAgreeSetting()
        agreementSetting()
    }
    
    func confirmButtonSetting() {
        
        
        view.addSubview(confirmButton)
        confirmButton.addTouchAnimation()
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.widthAnchor.constraint(equalToConstant: 335),
            confirmButton.heightAnchor.constraint(equalToConstant: 52),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        
        // useAgree와 overAge가 모두 true일 때만 버튼 활성화
        confirmButton.isEnabled = useAgree && overAge
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    func ageSetting() {
        
        ageLabel.text = "[필수] 만 14세 이상의 사용자입니다"
        ageLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        ageButton.setImage(offImage, for: .normal)
        
        ageButton.addTarget(self, action: #selector(ageButtonTapped), for: .touchUpInside)
        ageButton.addTouchAnimation()
        
        ageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        ageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let ageStackView = UIStackView(arrangedSubviews: [ageButton, ageLabel])
        ageStackView.axis = .horizontal
        ageStackView.spacing = 8
        
        view.addSubview(ageStackView)
        
        ageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ageStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30), // 좌측 safe area로부터 30만큼 떨어지도록 설정
            ageStackView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -20)
        ])
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
        useAgreeLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        useAgreeButton.setImage(offImage, for: .normal)
        
        useAgreeButton.addTarget(self, action: #selector(useAgreeButtonTapped), for: .touchUpInside)
        useAgreeButton.addTouchAnimation()
        
        useAgreeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        useAgreeButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let ageStackView = UIStackView(arrangedSubviews: [useAgreeButton, useAgreeLabel])
        ageStackView.axis = .horizontal
        ageStackView.spacing = 8
        
        view.addSubview(ageStackView)
        
        ageStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ageStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30), // 좌측 safe area로부터 30만큼 떨어지도록 설정
            ageStackView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -60)
        ])
    }
    

    
    func agreementSetting() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = UIColor.lightGray
        
        // 스크롤 뷰를 뷰에 추가
        view.addSubview(scrollView)
        
        // 레이블 생성
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "I'm like some kind of Supernova Watch out Look at me go 재미 좀 볼 빛의 Core So hot hot 문이 열려 서로의 존재를 느껴 마치 Discord 날 닮은 너 너 누구야 (Drop) 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay That tick that tick tick bomb That tick that tick tick bomb 감히 건드리지 못할 걸 (누구도 말이야) 지금 내 안에선 Su su su Supernova Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova Ah Body bang Make it feel too right 휩쓸린 에너지 It's so special 잔인한 Queen 이며 Scene 이자 종결 이토록 거대한 내 안의 Explosion 내 모든 세포 별로부터 만들어져 (Under my control Ah) 질문은 계속돼 Ah Oh Ay 우린 어디서 왔나 Oh Ay 느껴 내 안에선 Su su su Supernova Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova 보이지 않는 힘으로 네게 손 내밀어 볼까 가능한 모든 가능성 무한 속의 너를 만나 It's about to bang bang Don't forget my name Su su su Supernova 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay 우린 어디서 왔나 Oh Ay 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay Tell me, tell me, tell me Oh Ay 우린 어디서 왔나 Oh Ay 우린 어디서 왔나 Oh Ay Nova Can't stop hyperstellar 원초 그걸 찾아 Bring the light of a dying star 불러낸 내 우주를 봐 봐 Supernova 사건은 다가와 Ah Oh Ay (Nu star) 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay (Nova) 우린 어디서 왔나 Oh Ay 사건은 다가와 Ah Oh Ay 거세게 커져가 Ah Oh Ay 질문은 계속돼 Ah Oh Ay (Nova) Bring the light of a dying star Supernova"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // 레이블을 스크롤 뷰에 추가
        scrollView.addSubview(label)
        
        // Auto Layout 설정
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.bottomAnchor.constraint(equalTo: useAgreeLabel.topAnchor, constant: -20),
            scrollView.widthAnchor.constraint(equalToConstant: 370),
            scrollView.heightAnchor.constraint(equalToConstant: 500),
            
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10),
            label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -20),
        ])
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
    }
    
    func updateConfirmButtonState() {
        // useAgree와 overAge가 모두 true일 때만 버튼 활성화
        let isButtonEnabled = useAgree && overAge
        confirmButton.isEnabled = isButtonEnabled
        
        // overAge와 useAgree가 모두 true일 경우 confirmButton의 색상을 .black으로 변경
        if isButtonEnabled {
            confirmButton.gradient.colors = [UIColor(named: "pointOrange")?.cgColor ?? UIColor.orange.cgColor,
                                             UIColor(named: "pointYellow")?.cgColor ?? UIColor.yellow.cgColor]
        } else {
            // 그 외의 경우에는 기존의 offColor를 사용
            let offColor = UIColor(red: 209/255, green: 211/255, blue: 217/255, alpha: 1.0)
            confirmButton.gradient.colors = [offColor.cgColor, offColor.cgColor]
        }
    }

}

