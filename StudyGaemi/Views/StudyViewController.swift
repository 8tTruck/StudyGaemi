//
//  StudyViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit
import SnapKit
import Then

class StudyViewController: BaseViewController {
    private var circularTimerView: CircularTimerView?
    private let startButton = UIButton(type: .system)
    private let datePicker = UIDatePicker()
    
    private let titleLabel = UILabel().then {
        $0.text = "공부하개미"
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
        
        super.viewDidLoad() // 호출되는 순서에 대해 생각해
        
        
        // CircularTimerView 추가
        let circularTimerView = CircularTimerView(progressColors: .init(), duration: .zero, startDate: Date())
        view.addSubview(circularTimerView)
        
        circularTimerView.translatesAutoresizingMaskIntoConstraints = false
        circularTimerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        circularTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        circularTimerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        circularTimerView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true

        
        // UI 구성 및 제약 조건 설정
        self.configureUI()
        self.constraintLayout()
        
        
    }
    
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.navigationItem.titleView = titleView
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().then {
                $0.configureWithOpaqueBackground()
                $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
                $0.shadowColor = UIColor(named: "navigationBarLine")
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
    }
}
