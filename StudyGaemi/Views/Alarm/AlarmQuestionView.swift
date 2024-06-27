//
//  AlarmQuestionView.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/5/24.
//

import SnapKit
import Then
import UIKit
import MediaPlayer

class AlarmQuestionView: BaseViewController {
    
    private let alarmQuestionController = AlarmQuestionController()

    private let titleLabel = UILabel().then {
        $0.text = "문제 풀어보개미"
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
    
    private let progressView = UIProgressView().then {
        /// progress 배경 색상
        $0.trackTintColor = .systemGray
        /// progress 진행 색상
        $0.progressTintColor = .systemRed
        $0.progress = 0.1
    }
    
    private let questionLabel = UILabel().then {
        $0.text = "문제"
        $0.font = UIFont(name: CustomFontType.medium.name, size: 20) ?? UIFont.systemFont(ofSize: 20)
        $0.textColor = UIColor(named: "fontGray")
    }
    
    private lazy var expressionLabel = UILabel().then {
        AlarmCoreDataManager.shared.fetchAlarm()
        guard let difficulty = AlarmCoreDataManager.shared.coreData?.difficulty else {
            return
        }
        $0.text = alarmQuestionController.getQuestionAlgorithm(difficulty: difficulty)
        $0.font = UIFont(name: CustomFontType.bold.name, size: 40) ?? UIFont.systemFont(ofSize: 40)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private lazy var questionStackView = UIStackView(arrangedSubviews: [questionLabel, expressionLabel]).then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }
    
    private var timer: Timer?
    private let totalTime: TimeInterval = 180
    private var elapsedTime: TimeInterval = 0
    
    private let customTextField = CustomTextField(text: "정답을 적어보개미").then {
        $0.keyboardType = .numberPad
    }
    
    private let customButton = CustomButton(title: "제출")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        self.startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customTextField.becomeFirstResponder()
        AlarmSettingController.shared.removeScheduleAlarm()
        AlarmSettingController.shared.removeNotification()
        AlarmSettingController.shared.resetAlarm()
        AudioController.shared.playAlarmSound()
        self.setSystemVolume(to: 1.0)
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
        self.navigationItem.titleView = titleView
        
        view.addSubview(progressView)
        view.addSubview(questionStackView)
        view.addSubview(customTextField)
        view.addSubview(customButton)
        
        customButton.addTouchAnimation()
        customButton.addTarget(self, action: #selector(checkAnswer), for: .touchUpInside)
        customTextField.addTarget(self, action: #selector(textFieldEditingDidBegin), for: .editingDidBegin)
        
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
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.height.equalTo(8)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
        
        questionStackView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp.bottom).offset(39)
            make.height.equalTo(91)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
        
        customTextField.snp.makeConstraints { make in
            make.top.equalTo(questionStackView.snp.bottom).offset(58)
            make.height.equalTo(60)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
        
        customButton.snp.makeConstraints { make in
            make.top.equalTo(customTextField.snp.bottom).offset(17)
            make.height.equalTo(48)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func setSystemVolume(to value: Float) {
        let volumeView = MPVolumeView(frame: .zero)
        self.view.addSubview(volumeView)
        if let view = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            view.value = value
            print("볼륨값: \(value)")
        }
        volumeView.removeFromSuperview()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateProgress), userInfo: nil, repeats: true)
    }
    
    @objc private func updateProgress() {
        elapsedTime += 1
        let progress = Float(elapsedTime / totalTime)
        progressView.setProgress(progress, animated: true)
        
        if elapsedTime >= totalTime {
            timer?.invalidate()
            timer = nil
            
            let alarmResultView = AlarmResultView()
            guard let navigation = navigationController else {
                return
            }
            alarmResultView.correctNumber = alarmQuestionController.correctNumber
            navigation.pushViewController(alarmResultView, animated: true)
            AudioController.shared.stopAlarmSound()
            FirestoreManager.shared.createWakeUpData(success: false)
        }
    }
    
    @objc private func checkAnswer() {
        alarmQuestionController.checkAnswer(customTextField.text, navigation: navigationController, timer: timer, textField: customTextField)
    }
    
    @objc func textFieldEditingDidBegin(_ textField: UITextField) {
        textField.text = ""
    }
}
