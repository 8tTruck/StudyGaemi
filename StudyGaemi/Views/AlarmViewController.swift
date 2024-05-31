//
//  AlarmViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import SnapKit
import Then
import UIKit

class AlarmViewController: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "기상하개미"
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
    
    private var button = CustomButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        // Do any additional setup after loading the view.
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
        self.navigationItem.titleView = titleView
        view.addSubview(button)
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().then {
                $0.configureWithOpaqueBackground()
                $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
                $0.shadowColor = UIColor(named: "navigationBarLine")
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        // UIButton이나 UILabel 등과 같은 부분 초기 설정 함수
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(500)
            make.centerX.equalToSuperview()
            make.width.equalTo(334)
            make.height.equalTo(53)
        }
        // UIButton이나 UILabel 등과 같은 부분 제약조건 설정 함수
    }

}
