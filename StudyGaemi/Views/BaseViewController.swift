//
//  BaseViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        self.hideKeyboardWhenTappedAround()
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        // UIButton이나 UILabel 등과 같은 부분 초기 설정 함수
    }
    
    func constraintLayout() {
        // UIButton이나 UILabel 등과 같은 부분 제약조건 설정 함수
    }

}

// 빈 화면 터치 시 키보드 내려가는 기능 추가
extension BaseViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(BaseViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIButton {
    
    func addTouchAnimation() {
        self.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(buttonTouchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    @objc private func buttonTouchDown(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        }
        sender.isHighlighted = false
    }
    
    @objc private func buttonTouchUp(sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = .identity
        }
        sender.isHighlighted = false
    }
}
