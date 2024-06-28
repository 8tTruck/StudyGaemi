//
//  SettingView.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/9/24.
//

import SnapKit
import Then
import UIKit

class SettingView: UIView {
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.bounces = false
    }
    
    let scrollContentView = UIView().then {
        $0.backgroundColor = .clear
    }

    let titleLabel = UILabel().then {
        $0.text = "개ME"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "mainAnt")
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var titleView = UIStackView(arrangedSubviews: [imageView, titleLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.alignment = .center
    }
    
    let userView = UIView().then {
        $0.backgroundColor = UIColor(named: "viewBackgroundColor2")
        $0.layer.cornerRadius = 23
        $0.layer.shadowColor = UIColor(named: "pointBlack")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOpacity = 0.15
    }
    
    let userImageView = UIImageView().then {
        $0.image = UIImage(named: "profileAnt")
        $0.contentMode = .center
        $0.layer.cornerRadius = 23
        $0.layer.masksToBounds = true
    }
    
    let userLabel = UILabel().then {
        $0.text = "User"
        $0.font = UIFont(name: "Pretendard-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17)
        $0.textColor = UIColor(named: "fontBlack")
        $0.backgroundColor = .clear
    }
    
    let emailLabel = UILabel().then {
        $0.text = "example123@naver.com"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
    }
    
    let editButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "editButton"), for: .normal)
        $0.tintColor = .lightGray
    }
    
    let separatorView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    let totalStudyLabel = UILabel().then {
        $0.text = "총 공부개미"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
    }
    
    let totalTimeLabel = UILabel().then {
        $0.text = "8시간 0분"
        $0.font = UIFont(name: "Pretendard-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = UIColor.clear
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
    }
    
    let logoutButton = UIButton(type: .system).then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(UIColor(named: "fontGray"), for: .normal)
        $0.backgroundColor = UIColor(named: "viewBackgroundColor2")
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 17)
        $0.layer.borderColor = UIColor(named: "textFieldColor")?.cgColor ?? UIColor.gray.cgColor
        $0.layer.borderWidth = 1.5
        $0.layer.cornerRadius = 10
    }
    
    let accumulatedLabel = UILabel().then {
        $0.text = "0일 누적"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .white
        $0.backgroundColor = .orange
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        constraintLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        backgroundColor = UIColor(named: "viewBackgroundColor")
        
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(titleView)
        scrollContentView.addSubview(userView)
        userView.addSubview(userImageView)
        userView.addSubview(userLabel)
        userView.addSubview(emailLabel)
        userView.addSubview(editButton)
        userView.addSubview(separatorView)
        userView.addSubview(totalStudyLabel)
        userView.addSubview(totalTimeLabel)
        userView.addSubview(accumulatedLabel)
        scrollContentView.addSubview(tableView)
        scrollContentView.addSubview(logoutButton)
    }
    
    func constraintLayout() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        titleView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        userView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(169)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.top).offset(22)
            make.leading.equalTo(userView.snp.leading).offset(22)
            make.width.height.equalTo(46)
        }
        
        userLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.top.equalTo(userImageView.snp.top).offset(5)
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(4)
            make.leading.equalTo(userLabel)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(userView.snp.trailing).offset(-15)
            make.centerY.equalTo(userImageView.snp.centerY)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(userView).inset(5)
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        
        totalStudyLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.leading.equalTo(userView.snp.leading).offset(22)
        }
        
        totalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(totalStudyLabel.snp.bottom).offset(4)
            make.leading.equalTo(totalStudyLabel)
        }
        
        accumulatedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalTimeLabel)
            make.trailing.equalTo(userView.snp.trailing).offset(-22)
            make.height.equalTo(30)
            make.width.equalTo(80)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(600)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
