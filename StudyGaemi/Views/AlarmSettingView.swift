//
//  AlarmSettingView.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/3/24.
//

import SnapKit
import Then
import UIKit

class AlarmSettingView: BaseViewController {
    
    private let titleLabel = UILabel().then {
        $0.text = "몇시에 일어날개미"
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
        self.navigationItem.titleView = titleView
    }
    
    override func constraintLayout() {
        
    }

}
