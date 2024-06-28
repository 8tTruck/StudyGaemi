//
//  TutorialPageView.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/28/24.
//

import SnapKit
import Then
import UIKit
import UserNotifications

class TutorialPageView: BaseViewController {
    
    var index: Int?
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.semiBold.name, size: 24)
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.regular.name, size: 16)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let exitButton = CustomButton(radius: 16, title: "확인").then {
        $0.setFontSize(name: CustomFontType.semiBold.name, 16)
        $0.isHidden = true
    }
    
    init(index: Int) {
        super.init(nibName: nil, bundle: nil)
        self.index = index
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateContent()
        configureUI()
        constraintLayout()
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("알림 권한이 수락되었습니다.")
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
        exitButton.addTarget(nil, action: #selector(dismissView), for: .touchUpInside)
    }

    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(80)
            make.centerX.equalToSuperview()
            make.width.equalTo(260)
            make.height.equalTo(410)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
        
        exitButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(32)
            make.trailing.equalToSuperview().offset(-32)
        }
    }
    
    private func updateContent() {
        guard let index = index else { return }
        
        switch index {
        case 0:
            imageView.image = UIImage(named: "tutorial0")
            titleLabel.text = "알림 권한 허용"
            descriptionLabel.text = "알림 권한을 허용하지 않으면, 알람 기능을 사용할 수 없으니 권한을 허용해주세요"
        case 1:
            imageView.image = UIImage(named: "tutorial1")
            titleLabel.text = "기상하개미"
            descriptionLabel.text = "알람음, 문제 난이도를 고르고 기상알람을 설정하세요"
        case 2:
            imageView.image = UIImage(named: "tutorial2")
            titleLabel.text = "문제풀개미"
            descriptionLabel.text = "문제를 풀고 기상개미를 획득하세요"
        case 3:
            imageView.image = UIImage(named: "tutorial3")
            titleLabel.text = "공부하개미"
            descriptionLabel.text = "목표시간을 설정하고 공부시간을 측정해보세요"
        case 4:
            imageView.image = UIImage(named: "tutorial4")
            titleLabel.text = "월간개미"
            descriptionLabel.text = "한달간의 기상개미와 공부개미 현황을 파악해보세요"
        case 5:
            imageView.image = UIImage(named: "tutorial5")
            titleLabel.text = "개ME"
            descriptionLabel.text = "총 공부시간과 프로필을 확인해보세요"
            exitButton.isHidden = false
        default:
            break
        }
    }
                             
    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

