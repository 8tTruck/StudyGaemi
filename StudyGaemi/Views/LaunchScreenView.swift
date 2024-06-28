//
//  LaunchScreenView.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/27/24.
//

import SnapKit
import Then
import UIKit

class LaunchScreenView: UIViewController {

    // Logo ImageView
    let logo = UIImageView(image: UIImage(named: "logo")) // 이미지 이름을 넣어주세요

    
    // Label
    let label = UILabel().then {
        $0.text = "공부하개미"
        $0.font = UIFont(name: "Pretendard-Medium", size: 30) // 폰트 및 사이즈 설정
        $0.textColor = UIColor(named: "launchScreenFontColor")
        $0.textAlignment = .center
    }
    
    let company = UILabel().then {
        $0.text = "Ⓒ 8tTruck"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.textColor = UIColor(named: "launchScreenFontColor")
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        constraintLayout()
    }

    func configureUI() {
        view.backgroundColor = UIColor(named: "launchScreenColor")
        view.addSubview(logo)
        view.addSubview(label)
        view.addSubview(company)
    }
    
    func constraintLayout() {
        // SnapKit을 사용하여 Auto Layout 설정
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 화면 가운데에 위치
            make.centerY.equalToSuperview().offset(-50) // 세로 중앙에서 위로 50 포인트 이동
            make.width.equalTo(view.snp.width).multipliedBy(0.5) // 화면 너비의 50%
            make.height.equalTo(logo.snp.width).multipliedBy(1.0) // 가로세로 비율 1:1로 유지
        }
        
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logo.snp.bottom).offset(10) // 로고 아래에서 20 포인트 떨어진 곳에 위치
        }
        
        company.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
