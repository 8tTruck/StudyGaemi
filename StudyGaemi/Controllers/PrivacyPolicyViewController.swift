//
//  PrivacyPolicyViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/9/24.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {

    private let privacyPolicyView = PrivacyPolicyView()

    override func loadView() {
        view = privacyPolicyView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        navigationItem.title = "개인정보 처리 방침"
    }
}
