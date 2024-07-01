//
//  AlarmViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import SnapKit
import Then
import UIKit

class AlarmViewController: BaseViewController {
    
    private let alarmController = AlarmController()
    
    private let titleLabel = UILabel().then {
        $0.text = "기상하개미"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "mainAnt")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleView = UIStackView(arrangedSubviews: [imageView, titleLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let alarmLabel = UILabel().then {
        $0.text = "몇시에 일어날 개미?"
        $0.font = UIFont(name: CustomFontType.regular.name, size: 18) ?? UIFont.systemFont(ofSize: 18)
        $0.textColor = UIColor(named: "fontBlack")
        $0.textAlignment = .center
    }
    
    private var toggleState = UserDefaults.standard.bool(forKey: "toggleButtonState") {
        didSet {
            alarmController.updateNotificationSettings(isOn: toggleState)
        }
    }
    lazy var toggleButton = UISwitch().then {
        $0.onTintColor = UIColor(named: "pointOrange")
        $0.isOn = self.toggleState
        $0.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [alarmLabel, toggleButton]).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
    }
    
    private var alarmButton = AlarmButton().then {
        $0.setImage(UIImage(named: "alarmButton"),for: .normal)
    }
    
    private let alarmView = UIView().then {
        $0.backgroundColor = UIColor(named: "alertBackgroundColor")
        $0.layer.cornerRadius = 23
        $0.layer.shadowColor = UIColor(named: "pointBlack")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOpacity = 0.15
    }
    
    private let notificationStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 10
    }
    
    private let notificationImageView = UIImageView().then {
        $0.image = UIImage(named: "sleepAnt")
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }
    
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private let horizontalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalCentering
    }
    
    private var timeLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.semiBold.name, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
        $0.textAlignment = .left
    }
    
    private var repeatLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.regular.name, size: 13) ?? UIFont.systemFont(ofSize: 13)
        $0.textColor = UIColor(named: "fontBlack")
        $0.textAlignment = .right
    }
    
    private var difficultyLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.regular.name, size: 13) ?? UIFont.systemFont(ofSize: 13)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        
        // 앱 설치 후 처음 실행 시에만 튜토리얼 보여주기
        if !UserDefaults.standard.bool(forKey: "hasCompletedTutorial") {
            let tutorialVC = TutorialPageViewController()
            tutorialVC.modalPresentationStyle = .fullScreen
            self.present(tutorialVC, animated: true, completion: nil)
            UserDefaults.standard.set(true, forKey: "hasCompletedTutorial")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setAlarm()
    }
    
    // UIButton이나 UILabel 등과 같은 부분 초기 설정 함수
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
        self.navigationItem.titleView = titleView
        view.addSubview(stackView)
        view.addSubview(alarmButton)
        view.addSubview(alarmView)
        alarmView.addSubview(notificationStackView)
        notificationStackView.addArrangedSubview(notificationImageView)
        notificationStackView.addArrangedSubview(verticalStackView)
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(difficultyLabel)
        horizontalStackView.addArrangedSubview(timeLabel)
        horizontalStackView.addArrangedSubview(repeatLabel)
        
        alarmButton.addTouchAnimation()
        alarmButton.addTarget(self, action: #selector(tappedAlarmButton), for: .touchUpInside)
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().then {
                $0.configureWithOpaqueBackground()
                $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
                $0.shadowColor = UIColor(named: "navigationBarLine")
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
    }
    
    // UIButton이나 UILabel 등과 같은 부분 제약조건 설정 함수
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(73)
            make.height.equalTo(47)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(72)
        }
        
        alarmButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(312)
            make.height.equalTo(312)
        }
        
        alarmView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(121)
            make.centerX.equalToSuperview()
            // 승섭 width 지우고 좌우 여백 24로 통일
//            make.width.equalTo(312)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(66)
            
        }
        
        notificationStackView.snp.makeConstraints { make in
            make.top.equalTo(alarmView.snp.top).inset(14)
            make.bottom.equalTo(alarmView.snp.bottom).inset(14)
            make.leading.equalTo(alarmView.snp.leading).inset(18)
            make.trailing.equalTo(alarmView.snp.trailing).inset(18)
        }
        
        notificationImageView.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.height.equalTo(38)
        }
    }
    
    func setAlarm() {
        alarmController.alarmModel = AlarmCoreDataManager.shared.getAlarmData()
        alarmButton.setTitle(alarmController.setAlarmTime())
        alarmButton.setAmPmLabel(alarmController.setAmPm())
        timeLabel.text = "\(alarmController.setAlarmTime()) \(alarmController.setAmPm())"
        repeatLabel.text = alarmController.setAlarmInterval()
        difficultyLabel.text = "문제 난이도 : \(alarmController.setAlarmDifficulty())"
    }
    
    @objc private func tappedAlarmButton() {
        alarmController.goAheadView(navigationController)
    }
    
    @objc private func toggleChanged(_ sender: UISwitch) {
        self.toggleState = sender.isOn
    }
}

