//
//  AlarmResultView.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/7/24.
//

import SnapKit
import Then
import UIKit

enum Status {
    case success
    case failure
}

class AlarmResultView: BaseViewController {
    
    var status: Status = .failure
    
    private lazy var imageView = UIImageView().then {
        switch status {
        case .success:
            $0.image = UIImage(named: "heartAnt")
        case .failure:
            $0.image = UIImage(named: "failAnt")
        }
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleLabel = UILabel().then {
        switch status {
        case .success:
            $0.text = "기상개미 획득"
        case .failure:
            $0.text = "기상개미 획득 실패"
        }
        $0.font = UIFont(name: CustomFontType.bold.name, size: 24)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private lazy var textLabel = UILabel().then {
        switch status {
        case .success:
            $0.text = "축하드립니다! 기상개미를 획득하셨습니다!"
        case .failure:
            $0.text = "시간 초과로 기상개미 획득에 실패하셨습니다."
        }
        $0.font = UIFont(name: CustomFontType.regular.name, size: 18)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private lazy var answerLabel = UILabel().then {
        $0.text = "361"
        $0.textColor = UIColor(named: "fontBlack")
        $0.font = UIFont(name: CustomFontType.bold.name, size: 24)
        $0.textAlignment = .center
        $0.layer.backgroundColor = UIColor(named: "textFieldColor")?.cgColor
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1.0
        switch status {
        case .success:
            $0.layer.borderColor = UIColor(named: "successColor")?.cgColor
        case .failure:
            $0.layer.borderColor = UIColor(named: "failureColor")?.cgColor
        }
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, textLabel, answerLabel]).then {
        $0.axis = .vertical
        $0.spacing = 20
        $0.alignment = .center
    }
    
    private lazy var studyCustomButton = CustomButton(title: "공부하개미 이동").then {
        switch status {
        case .success:
            $0.setBackgroundColor(UIColor(named: "backgroundColor"))
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor(named: "pointOrange")?.cgColor
            $0.setFontColor(UIColor(named: "pointOrange"), for: .normal)
            $0.setFontSize(name: CustomFontType.medium.name, 18)
        case .failure:
            $0.setFontColor(UIColor(named: "fontWhite"), for: .normal)
            $0.setFontSize(name: CustomFontType.medium.name, 18)
        }
    }
    
    private let calendarCustomButton = CustomButton(title: "월간개미 이동").then {
        $0.setFontSize(name: CustomFontType.medium.name, 18)
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .fillEqually
        switch status {
        case .success:
            $0.addArrangedSubview(studyCustomButton)
            $0.addArrangedSubview(calendarCustomButton)
        case .failure:
            $0.addArrangedSubview(studyCustomButton)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
        
        view.addSubview(stackView)
        view.addSubview(buttonStackView)
        
        studyCustomButton.addTarget(self, action: #selector(moveToStudy), for: .touchUpInside)
        calendarCustomButton.addTarget(self, action: #selector(moveToCalendar), for: .touchUpInside)
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.equalTo(184)
            make.height.equalTo(131)
        }
        
        answerLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(342)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(71)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.height.equalTo(320)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
            make.height.equalTo(50)
        }
    }
    
    @objc func moveToStudy() {
        
    }
    
    @objc func moveToCalendar() {
        
    }
}
