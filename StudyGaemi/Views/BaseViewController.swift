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
    }
    
    func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        // UIButton이나 UILabel 등과 같은 부분 초기 설정 함수
    }
    
    func constraintLayout() {
        // UIButton이나 UILabel 등과 같은 부분 제약조건 설정 함수
    }

}
