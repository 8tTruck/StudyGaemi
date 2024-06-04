//
//  AlarmSettingView.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/3/24.
//

import SnapKit
import Then
import UIKit

class AlarmSettingView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "몇시에 일어날개미"
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
    
    private let timekPicker = UIDatePicker().then {
        $0.datePickerMode = .time
        $0.locale = Locale(identifier: "ko_KR")
        if #available(iOS 13.4, *) {
            $0.preferredDatePickerStyle = .wheels
        }
    }
    
    private let questionLabel = UILabel().then {
        $0.text = "문제 난이도"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private let segmentButton = UISegmentedControl().then {
        let items = ["하", "중", "상"]
        $0.insertSegment(withTitle: items[0], at: 0, animated: false)
        $0.insertSegment(withTitle: items[1], at: 1, animated: false)
        $0.insertSegment(withTitle: items[2], at: 2, animated: false)
        $0.selectedSegmentIndex = 1
        $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
        $0.selectedSegmentTintColor = UIColor(named: "pointDarkgray") ?? .systemGray
        // 선택된 세그먼트의 폰트 설정
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: CustomFontType.medium.name, size: 18) ?? UIFont.systemFont(ofSize: 18)
        ]
        $0.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        // 선택되지 않은 세그먼트의 폰트 설정
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(named: "fontBlack") ?? UIColor.black,
            .font: UIFont(name: CustomFontType.medium.name, size: 18) ?? UIFont.systemFont(ofSize: 18)
        ]
        $0.setTitleTextAttributes(normalAttributes, for: .normal)
    }
    
    private lazy var questionStackView = UIStackView(arrangedSubviews: [questionLabel, segmentButton]).then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let notificationLabel = UILabel().then {
        $0.text = "알림음"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private let dropDownButton = UIButton().then {
        $0.setTitle("알림음 1", for: .normal)
        $0.titleLabel?.font = UIFont(name: CustomFontType.medium.name, size: 18) ?? UIFont.systemFont(ofSize: 18)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor(named: "pointDarkgray") ?? UIColor.systemGray
        $0.layer.cornerRadius = 8
        $0.tintColor = UIColor.systemBlue
        $0.showsMenuAsPrimaryAction = true
    }

    private lazy var notificationStatckView = UIStackView(arrangedSubviews: [notificationLabel, dropDownButton]).then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    
    private let repeatLabel = UILabel().then {
        $0.text = "반복"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private var toggleState = false
    private lazy var toggleButton = UISwitch().then {
        $0.onTintColor = UIColor(named: "pointOrange")
        self.toggleState = $0.isOn
    }
    
    private lazy var repeatStackView = UIStackView(arrangedSubviews: [repeatLabel, toggleButton]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .top
    }
    
    private let intervalLabel = UILabel().then {
        $0.text = "간격"
        $0.font = UIFont(name: CustomFontType.medium.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor.systemGray
    }

    private let numberLabel = UILabel().then {
        $0.text = "횟수"
        $0.font = UIFont(name: CustomFontType.medium.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        $0.textColor = UIColor.systemGray
    }
    
    private lazy var labelStackView = UIStackView(arrangedSubviews: [intervalLabel, numberLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        $0.isHidden = !self.toggleState
    }
    
    private let intervalButton = UIButton().then {
        $0.setTitle("3분마다", for: .normal)
        $0.titleLabel?.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        $0.setTitleColor(UIColor(named: "fontBlack") ?? .white, for: .normal)
        $0.backgroundColor = UIColor(named: "navigationBarLine") ?? UIColor.systemGray
        $0.layer.cornerRadius = 10
        $0.tintColor = UIColor.systemBlue
        $0.showsMenuAsPrimaryAction = true
    }
    
    private let numberButton = UIButton().then {
        $0.setTitle("1회반복", for: .normal)
        $0.titleLabel?.font = UIFont(name: CustomFontType.regular.name, size: 16) ?? UIFont.systemFont(ofSize: 16)
        $0.setTitleColor(UIColor(named: "fontBlack") ?? .white, for: .normal)
        $0.backgroundColor = UIColor(named: "navigationBarLine") ?? UIColor.systemGray
        $0.layer.cornerRadius = 10
        $0.tintColor = UIColor.systemBlue
        $0.showsMenuAsPrimaryAction = true
    }
    
    private lazy var buttonStatckView = UIStackView(arrangedSubviews: [intervalButton, numberButton]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 10
        $0.isHidden = !self.toggleState
    }
    
    private lazy var bottomStackView = UIStackView(arrangedSubviews: [repeatStackView, labelStackView, buttonStatckView]).then {
        $0.axis = .vertical
        $0.spacing = 10
    }

    private let saveButton = CustomButton().then {
        $0.setTitle("저장", for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
        self.navigationItem.titleView = titleView
        view.addSubview(timekPicker)
        view.addSubview(questionStackView)
        view.addSubview(notificationStatckView)
        view.addSubview(bottomStackView)
        view.addSubview(saveButton)
        
        segmentButton.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        toggleButton.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveValues()), for: .touchUpInside)
        
        dropDownButton.menu = UIMenu(children: [
            UIAction(title: "알림음 1", handler: { [weak self] _ in
                self?.buttonSetTitle("알림음 1", for: self?.dropDownButton)
            }),
            UIAction(title: "알림음 2", handler: { [weak self] _ in
                self?.buttonSetTitle("알림음 2", for: self?.dropDownButton)
            }),
            UIAction(title: "알림음 3", handler: { [weak self] _ in
                self?.buttonSetTitle("알림음 3", for: self?.dropDownButton)
            })
        ])
        
        intervalButton.menu = UIMenu(children: [
            UIAction(title: "3분마다", handler: { [weak self] _ in
                self?.buttonSetTitle("3분마다", for: self?.intervalButton)
            }),
            UIAction(title: "5분마다", handler: { [weak self] _ in
                self?.buttonSetTitle("5분마다", for: self?.intervalButton)
            }),
            UIAction(title: "8분마다", handler: { [weak self] _ in
                self?.buttonSetTitle("8분마다", for: self?.intervalButton)
            })
        ])
        
        numberButton.menu = UIMenu(children: [
            UIAction(title: "1회반복", handler: { [weak self] _ in
                self?.buttonSetTitle("1회 반복", for: self?.numberButton)
            }),
            UIAction(title: "2회반복", handler: { [weak self] _ in
                self?.buttonSetTitle("2회 반복", for: self?.numberButton)
            }),
            UIAction(title: "3회반복", handler: { [weak self] _ in
                self?.buttonSetTitle("3회 반복", for: self?.numberButton)
            })
        ])
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        timekPicker.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(29)
            make.height.equalTo(178)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(18)
        }
        
        segmentButton.snp.makeConstraints { make in
            make.height.equalTo(41)
        }
        
        questionStackView.snp.makeConstraints { make in
            make.top.equalTo(timekPicker.snp.bottom).offset(30)
            make.height.equalTo(71)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        dropDownButton.snp.makeConstraints { make in
            make.height.equalTo(41)
        }
        
        notificationStatckView.snp.makeConstraints { make in
            make.top.equalTo(questionStackView.snp.bottom).offset(17)
            make.height.equalTo(71)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(notificationStatckView.snp.bottom).offset(15)
            make.height.equalTo(98)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-36)
            make.height.equalTo(53)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("하 선택됨")
        case 1:
            print("중 선택됨")
        case 2:
            print("상 선택됨")
        default:
            break
        }
    }
    
    @objc private func toggleSwitchChanged(_ sender: UISwitch) {
        self.toggleState = sender.isOn
        labelStackView.isHidden = !self.toggleState
        buttonStatckView.isHidden = !self.toggleState
    }
    
    @objc private func saveValues() {
        
    }

    func buttonSetTitle(_ title: String, for button: UIButton?) {
        guard let button = button else { return }
        button.setTitle(title, for: .normal)
    }
}
