//
//  CircularTimerVC.swift
//  StudyGaemi
//
//  Created by 김준철 on 6/14/24.
//
import Foundation
import UIKit

class CircularTimerVC: UIViewController {
    
    private let countDownDurationSeconds: TimeInterval
    private let startDate: Date
    
    private lazy var circularTimerView: CircularTimerView = {
        let progressColors = ProgressColors(trackLayerStrokeColor: UIColor.lightGray.cgColor,
                                            barLayerStrokeColor: UIColor.orange.cgColor)
        let view = CircularTimerView(progressColors: progressColors,
                                     duration: countDownDurationSeconds, startDate: startDate )
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addSubviews()
        makeConstraints()
    }
    
    init(startDate: Date, countDownDurationSeconds: TimeInterval) {
        self.startDate = startDate
        self.countDownDurationSeconds = countDownDurationSeconds
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(circularTimerView)
    }
    
    private func makeConstraints() {
        circularTimerView.translatesAutoresizingMaskIntoConstraints = false
        circularTimerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        circularTimerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circularTimerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        circularTimerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        circularTimerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        circularTimerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true



    }
}
