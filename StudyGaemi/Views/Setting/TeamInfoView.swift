//
//  TeamInfoView.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/28.
//

import SnapKit
import Then
import UIKit

class TeamInfoView: UIView {
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.bounces = false
    }
    
    private let scrollContentView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let appLabel = UILabel().then {
        $0.text = "앱 정보"
        $0.font = UIFont(name: "Pretendard-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "fontGray")
        $0.backgroundColor = .clear
    }
    
    private let appInfoView = UILabel().then {
        $0.text = "앱 버전 1.0.1  \n제작 ©8tTruck\n문의 이메일 : taengdev@gmail.com"
        $0.font = UIFont(name: "Pretendard-Regular", size: 14) ?? UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "fontBlack")
        $0.backgroundColor = .clear
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    
    private let engineerLabel = UILabel().then {
        $0.text = "개발자 정보"
        $0.font = UIFont(name: "Pretendard-Regular", size: 12) ?? UIFont.systemFont(ofSize: 12)
        $0.textColor = UIColor(named: "fontGray")
        $0.backgroundColor = .clear
    }
    
    lazy var profileTableView = UITableView().then {
        $0.backgroundColor = UIColor.clear
        $0.register(TeamInfoCell.self, forCellReuseIdentifier: "TeamInfoCell")
        $0.separatorStyle = .singleLine
        $0.separatorColor = UIColor.lightGray
        //$0.showsVerticalScrollIndicator = false
        $0.bounces = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(appLabel)
        scrollContentView.addSubview(appInfoView)
        scrollContentView.addSubview(engineerLabel)
        scrollContentView.addSubview(profileTableView)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollContentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        appLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
        }
        appInfoView.snp.makeConstraints { make in
            make.top.equalTo(appLabel.snp.bottom)
            make.height.equalTo(60)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
        }
        engineerLabel.snp.makeConstraints { make in
            make.top.equalTo(appInfoView.snp.bottom).offset(16)
            make.height.equalTo(40)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(24)
        }
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(engineerLabel.snp.bottom)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(560)
            make.bottom.equalToSuperview().inset(10)
            
        }
    }
}

