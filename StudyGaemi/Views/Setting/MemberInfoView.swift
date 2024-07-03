//
//  MemberInfoView.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/20/24.
//

import SnapKit
import UIKit

class MemberInfoView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let currentPasswordField = CustomTextField(text: "기존 비밀번호를 입력해주세요")
    let newPasswordField = CustomTextField(text: "새로운 비밀번호를 입력해주세요")
    let confirmPasswordField = CustomTextField(text: "새 비밀번호를 한 번 더 입력해주세요")
    let confirmButton = CustomButton(title: "확인")
    let errorLabel = UILabel()
    let currentPasswordLabel = UILabel()
    let newPasswordLabel = UILabel()
    let confirmPasswordLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(named: "viewBackgroundColor")
        
        // 네비게이션 바 설정
        _ = UINavigationItem(title: "비밀번호 변경")
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(800) // 충분한 높이 설정
        }
        
        setupLabel(currentPasswordLabel, text: "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다.")
        setupLabel(newPasswordLabel, text: "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다.")
        setupLabel(confirmPasswordLabel, text: "비밀번호는 영문, 숫자를 포함한 8자리 이상이어야 합니다.")
        
        errorLabel.textColor = UIColor(named: "fontRed")
        errorLabel.textAlignment = .center
        errorLabel.text = ""
        
        confirmButton.backgroundColor = UIColor(named: "pointOrange")
        confirmButton.layer.cornerRadius = 24
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Pretendard-Semibold", size: 16)
        confirmButton.setTitleColor(.white, for: .normal)
        
        contentView.addSubview(currentPasswordField)
        contentView.addSubview(currentPasswordLabel)
        contentView.addSubview(newPasswordField)
        contentView.addSubview(newPasswordLabel)
        contentView.addSubview(confirmPasswordField)
        contentView.addSubview(confirmPasswordLabel)
        contentView.addSubview(errorLabel)
        contentView.addSubview(confirmButton)
        
        currentPasswordField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        currentPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        newPasswordField.snp.makeConstraints { make in
            make.top.equalTo(currentPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        newPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(newPasswordField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(newPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
        }
        
        confirmPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        errorLabel.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(52)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
        }
        
        [currentPasswordField, newPasswordField, confirmPasswordField].forEach { textField in
            textField.isSecureTextEntry = true
        }
    }
    
    private func setupLabel(_ label: UILabel, text: String) {
        label.text = text
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textColor = UIColor(named: "fontGray")
    }
}
