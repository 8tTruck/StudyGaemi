//
//  customButton.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/31/24.
//

import SnapKit
import Then
import UIKit

class CustomButton: UIButton {

    let gradient = CAGradientLayer().then {
        $0.colors = [UIColor(named: "pointOrange")?.cgColor ?? UIColor.orange.cgColor,
                     UIColor(named: "pointYellow")?.cgColor ?? UIColor.yellow.cgColor]
        $0.startPoint = CGPoint(x: 0.0, y: 0.5)
        $0.endPoint = CGPoint(x: 1.0, y: 0.5)
    }
    
    init(x: Int = 0, y: Int = 0, width: Int = 334, height: Int = 52, radius: CGFloat = 10, title: String = "저장") {
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        
        self.layer.addSublayer(gradient)
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: CustomFontType.regular.name, size: 20) ?? UIFont.systemFont(ofSize: 20)
        self.setTitleColor(.white, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = self.bounds
    }
    
    func setFontColor(_ color: UIColor?, for uiColor: UIControl.State) {
        self.setTitleColor(color, for: uiColor)
    }
    
    func setBackgroundColor(_ color: UIColor?) {
        gradient.removeFromSuperlayer()
        self.backgroundColor = color
    }
    
    func setFontSize(name: String,_ size: CGFloat) {
        self.titleLabel?.font = UIFont(name: name, size: size)
    }
}
