//
//  BugReportView.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/20/24.
//

import SnapKit
import Then
import UIKit

class BugReportView: UIView {

    let bugReportView = UIView()
    let textView = UITextView()
    let submitButton = CustomButton(title: "제출")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor(named: "viewBackgroundColor")
        
        bugReportView.backgroundColor = UIColor(named: "viewBackgroundColor2")
        bugReportView.layer.cornerRadius = 10
        bugReportView.layer.shadowColor = UIColor.black.cgColor
        bugReportView.layer.shadowOpacity = 0.3
        bugReportView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bugReportView.layer.shadowRadius = 4
        
        textView.text = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        textView.textColor = UIColor(named: "fontGray")
        textView.font = UIFont(name: "Pretendard-Regular", size: 16)
        textView.backgroundColor = UIColor(named: "viewBackgroundColor2")
        textView.isScrollEnabled = true
        
        submitButton.addTarget(nil, action: #selector(BugReportViewController.submitButtonTapped), for: .touchUpInside)
        
        addSubview(bugReportView)
        bugReportView.addSubview(textView)
        addSubview(submitButton)
    }
    
    private func setupConstraints() {
        bugReportView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(15)
            // 승섭 좌우여백 24로 통일
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        submitButton.snp.makeConstraints { make in
            make.top.equalTo(bugReportView.snp.bottom).offset(20)
            // 승섭 버튼 좌우여백 통일 20 -> 24
            make.leading.trailing.equalToSuperview().inset(24)
            // 승섭 제출 버튼 높이 통일 48 -> 52
            make.height.equalTo(52)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
        }
    }
}
