//
//  BottomSheetView.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/20/24.
//

import SnapKit
import UIKit

class BottomSheetView: UIView {
    
    let containerView = UIView()
    let titleLabel = UILabel()
    let textField = CustomTextField()
    let confirmButton = CustomButton(title: "확인")
    let cancelButton = UIButton(type: .system)
    let dragBar = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        containerView.backgroundColor = UIColor(named: "viewBackgroundColor")
        containerView.layer.cornerRadius = 20
        containerView.clipsToBounds = true
        
        dragBar.backgroundColor = .lightGray
        dragBar.layer.cornerRadius = 2
        
        titleLabel.text = "닉네임 변경하개미?"
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 17)
        titleLabel.textColor = UIColor(named: "fontBlack")
        
        textField.placeholder = "변경할 닉네임을 입력해주개미"
        cancelButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        cancelButton.tintColor = .gray
        
        addSubview(containerView)
        containerView.addSubview(dragBar)
        containerView.addSubview(titleLabel)
        containerView.addSubview(textField)
        containerView.addSubview(confirmButton)
        containerView.addSubview(cancelButton)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(self).inset(10)
            make.height.equalTo(250)
        }
        
        dragBar.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(8)
            make.centerX.equalTo(containerView)
            make.width.equalTo(40)
            make.height.equalTo(4)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(20)
            make.trailing.equalTo(containerView).offset(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dragBar.snp.bottom).offset(10)
            make.centerX.equalTo(containerView)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(containerView).inset(20)
            make.height.equalTo(52)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(40)
            make.leading.trailing.equalTo(containerView).inset(20)
            // 승섭 버튼 높이 통일 48 -> 52
            make.height.equalTo(52)
        }
    }
}
