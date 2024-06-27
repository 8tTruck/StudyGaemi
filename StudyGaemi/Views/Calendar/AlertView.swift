//
//  AlertView.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/07.
//

import Foundation
import UIKit

class AlertView: UIViewController {
    
    private let alertView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let customButton = CustomButton(x: 24, y: 218, width: 233, height: 46, title: "확인")
    
    private var logoImage: UIImage?
    private var titleText: String?
    private var doneButtonTitle: String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) { [weak self] in
            // 확대된 효과를 처음 크기로 되돌리기
            self?.alertView.transform = .identity
        }
    }

    private func setupUI() {
        // 이전 VC 배경이 살짝 어두워지는 효과
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        
        // 처음 생성 될 때, 살짝 커지는 효과(viewWillAppear, viewWillDisappear에서 애니메이션 효과를 만들어 줌)
        self.alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        alertView.backgroundColor = UIColor(named: "viewBackgroundColor")
        alertView.layer.cornerRadius = 15
        alertView.clipsToBounds = true
        
        view.addSubview(alertView)
        alertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.height.equalTo(280)
        }
        
        alertView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        titleLabel.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        
        alertView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(125)
            $0.width.equalTo(210)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
        }

        alertView.addSubview(customButton)
        customButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(25)
            $0.height.equalTo(45)
        }
        customButton.addTarget(self, action: #selector(customBtnDidTapped), for: .touchUpInside)
    }
}

extension AlertView {
    // 생성 시, 각각의 Label 및 이지미를 설정 할 있게 만듬
    convenience init(logImage: UIImage, titleText: String, doneButtonTitle: String) {
        self.init()
        
        imageView.image = logImage
        titleLabel.text = titleText
        customButton.setTitle(doneButtonTitle, for: .normal)
        customButton.setFontColor(.fontBlack, for: .normal)

        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overFullScreen
    }
}

extension AlertView {
    @objc func customBtnDidTapped(_ sender: UIButton) {
        //doneButtonCompletoin?()
        self.dismiss(animated: true)
        print("customBtnDidTapped")
    }
}
