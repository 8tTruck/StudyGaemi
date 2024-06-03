//
//  AlarmButton.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/3/24.
//

import SnapKit
import Then
import UIKit

class AlarmButton: UIButton {

    private let overlayLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "viewBackgroundColor")
        $0.font = UIFont(name: CustomFontType.black.name, size: 50)
    }
    
    private let amPmLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "viewBackgroundColor")
        $0.font = UIFont(name: CustomFontType.regular.name, size: 18)
    }
    
    private let overlayImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
        self.constraintLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureUI()
        self.constraintLayout()
    }
    
    private func configureUI() {
        addSubview(overlayImageView)
        addSubview(overlayLabel)
        addSubview(amPmLabel)
    }
    
    private func constraintLayout() {
        overlayImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        overlayLabel.snp.makeConstraints { make in
            make.center.equalTo(overlayImageView)
        }
        
        amPmLabel.snp.makeConstraints { make in
            make.top.equalTo(overlayImageView.snp.top).inset(108)
            make.bottom.equalTo(overlayLabel.snp.top).offset(-5)
            make.leading.equalTo(overlayImageView.snp.leading).inset(78)
            make.leading.equalTo(overlayImageView.snp.trailing).inset(206)
            
        }
    }
    
    func setImage(_ image: UIImage?) {
        overlayImageView.image = image
    }
    
    func setTitle(_ title: String?) {
        overlayLabel.text = title
    }
    
    func setAmPmLabel(_ text: String?) {
        amPmLabel.text = text
    }
}
