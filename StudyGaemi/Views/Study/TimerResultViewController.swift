//
//  TimerResultViewController.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/19.
//

import Foundation
import SnapKit
import Then
import UIKit
import FSCalendar
import FirebaseFirestore
import FirebaseAuth

enum TimerResult{
    case success
    case fail
}

class TimerResultViewController: BaseViewController {
    
    // MARK: - properties
    private let firestoreManager = FirestoreManager.shared
    private var goalTime: TimeInterval = TimeInterval()  //목표 공부 시간
    private var elapsedTime: TimeInterval = TimeInterval()  //실제로 타이머가 돌아간 시간
    private var result: TimerResult = .fail
    private let titleLabel = UILabel().then {
        $0.text = "얼마나 공부했개미"
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
    
    private let antImageView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "failAnt")
    }
    
    private let resultLabel = UILabel().then {
        $0.text = "공부개미 획득 성공"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 24) ?? UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
        $0.textAlignment = .center
    }
    
    private let resultDescriptLabel = UILabel().then {
        $0.text = "축하드립니다 기상개미를 획득하셨습니다."
        $0.font = UIFont(name: CustomFontType.regular.name, size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textColor = UIColor(named: "fontBlack")
        $0.textAlignment = .center
    }
    
    private lazy var resultView = UIStackView(arrangedSubviews: [resultLabel, resultDescriptLabel]).then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let bottomBackView = UIView().then {
        $0.backgroundColor = UIColor(named: "viewBackgroundColor2")
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.25
        $0.layer.shadowOffset = CGSize(width: 0, height: 0)
        $0.layer.shadowRadius = 5
        $0.clipsToBounds = false
    }
    
    private let customButton = CustomButton(title: "확인")
    
    private let goalTimeBackView = UIView().then {
        $0.backgroundColor = UIColor.systemGray5
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = false
    }
    
    private let goalLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.medium.name, size: 14) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = UIColor.fontBlack
        $0.text = "목표 공부 시간"
    }
    
    private let goalTimeLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.bold.name, size: 14) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor =  UIColor.fontBlack
        $0.text = "09 : 30"
    }
    
    private lazy var goalView = UIStackView(arrangedSubviews: [goalLabel, goalTimeLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 5
    }
    
    private let todayStudyLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.medium.name, size: 14) ?? UIFont.systemFont(ofSize: 10, weight: .bold)
        $0.textColor = UIColor.fontBlack
        $0.text = "오늘의 공부 시간"
        $0.textAlignment = .center
    }
    
    private let todayTimeLabel = UILabel().then {
        $0.font = UIFont(name: CustomFontType.black.name, size: 36) ?? UIFont.systemFont(ofSize: 36, weight: .bold)
        $0.textColor = UIColor.fontBlack
        $0.text = "04 : 30"
        $0.textAlignment = .center
    }
    
    private lazy var todayView = UIStackView(arrangedSubviews: [todayStudyLabel, todayTimeLabel]).then {
        $0.axis = .vertical
        $0.spacing = 5
    }
    
    private lazy var bottomView = UIStackView(arrangedSubviews: [goalTimeBackView, todayView]).then {
        $0.axis = .vertical
        $0.spacing = 25
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        setTimeData()
    }
    
    // MARK: - method
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.navigationItem.titleView = titleView
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().then {
                $0.configureWithOpaqueBackground()
                $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
                $0.shadowColor = UIColor(named: "navigationBarLine")
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        self.view.addSubview(resultView)
        self.view.addSubview(antImageView)
        self.view.addSubview(customButton)
        self.view.addSubview(bottomBackView)
        //bottomBackView.addSubview(goalTimeBackView)
        bottomBackView.addSubview(bottomView)
        goalTimeBackView.addSubview(goalView)
        //bottomBackView.addSubview(todayView)
        
        
    }
    
    override func constraintLayout() {
        
        customButton.addTarget(self, action: #selector(didTappedCustomButton), for: .touchUpInside)
        
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        resultView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 50)
        }
        
        antImageView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width - 160)
            make.height.equalTo(antImageView.snp.width).multipliedBy(3.0 / 7.0)
            make.bottom.equalTo(resultView.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        customButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
            // 승섭 witdh 지우고 좌우 24로 통일
//            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            // 승섭 버튼 높이 52로 통일
            make.height.equalTo(52)
        }
        
        bottomBackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(customButton.snp.top).offset(-25)
            // 승섭 width 지우고 좌우 24로 통일
//            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(bottomBackView.snp.width).multipliedBy(5.0 / 9.0)
        }
        
        goalTimeBackView.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.width.equalTo(180)
            make.centerX.equalToSuperview()
            //            make.top.equalToSuperview().offset(30)
        }
        
        bottomView.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        goalView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        todayView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(62)
            make.width.equalToSuperview()
        }
        
        
    }
    
    @objc func didTappedCustomButton(){
        
        //self.dismiss(animated: true, completion: nil)
        
        
        let bottomTabBarVC = BottomTabBarViewController()
        bottomTabBarVC.selectedIndex = 2
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = bottomTabBarVC
            window.makeKeyAndVisible()
        }
        
        bottomTabBarVC.modalPresentationStyle = .fullScreen
        self.present(bottomTabBarVC, animated: true)
        
    }
    
    func bind(goalT: TimeInterval, elapsedT: TimeInterval){
        self.goalTime = goalT
        self.elapsedTime = elapsedT
    }
    
    private func setTimeData(){
        
        let elapsedTimeText = elapsedTime.time
        goalTimeLabel.text = "\(goalTime.time)"
        todayTimeLabel.text = "\(elapsedTimeText)"
        
        if goalTime <= elapsedTime {    //성공
            result = .success
        }
        saveTimeData()
        setData(for: result)
    }
    
    private func setData(for result: TimerResult) {
        switch result{
        case .fail:
            antImageView.image = UIImage(named: "failAnt")
            resultLabel.text = "공부개미 획득 실패"
            resultDescriptLabel.text = "수고하셨습니다."
            bottomBackView.layer.borderColor = UIColor.red.cgColor
            todayTimeLabel.textColor = UIColor.red
        case .success:
            antImageView.image = UIImage(named: "heartAnt")
            resultLabel.text = "공부개미 획득 성공"
            resultDescriptLabel.text = "축하드립니다. 공부개미를 획득하셨습니다."
            bottomBackView.layer.borderColor = UIColor.green.cgColor
            todayTimeLabel.textColor = UIColor.green
        }
        
    }
    
    private func saveTimeData(){
        if result == .success {
            firestoreManager.createStudyData(success: true, during: Int(elapsedTime))
        }
        
    }
    
}
