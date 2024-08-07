//
//  CircularTimerVC.swift
//  StudyGaemi
//
//  Created by 김준철 on 6/14/24.
//

import UIKit
import Then
import SnapKit

class CircularTimerVC: BaseViewController, CircularTimerViewDelegate {
    
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
    
    func showTimerResult(goalTime: TimeInterval, elapsedTime: TimeInterval) {
        print("showTimerResult")
        let timerResultVC = TimerResultViewController()
        timerResultVC.modalPresentationStyle = .fullScreen
        timerResultVC.bind(goalT: goalTime, elapsedT: elapsedTime)
        //self.navigationController?.popViewController(animated: true)
        self.present(timerResultVC, animated: true)
    }
    
    func didFinishTimer() {
        print("didFinishTimer")
    }
  
    private let countDownDurationSeconds: TimeInterval
    private let startDate: Date
    
    private var isPaused = false
    private var pauseButton: UIButton!
    private var stopButton: UIButton!
    
    
    private lazy var circularTimerView: CircularTimerView = {
        let progressColors = ProgressColors(trackLayerStrokeColor: UIColor(hex: "#FFE3D8").cgColor,
                                            barLayerStrokeColor: UIColor.orange.cgColor)
        let view = CircularTimerView(progressColors: progressColors,
                                     duration: countDownDurationSeconds, startDate: startDate )
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        constraintLayout()
        
        circularTimerView.delegate = self
        
        setupViews()
        addSubviews()
        makeConstraints()
        
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
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
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
