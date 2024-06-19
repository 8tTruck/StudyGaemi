//
//  SettingTiemrVC.swift
//  StudyGaemi
//
//  Created by 김준철 on 6/14/24.
//

import UIKit

class SettingTimerVC: UIViewController {
    
//    private let repeatingSecondsTimer: RepeatingSecondsTimer = RepeatingSecondsTimerImpl()
    
    private lazy var countDownDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        return picker
    }()
    
    private lazy var confirmButton: CustomButton = {
        let button = CustomButton(x: 50, y: 50, width: 334, height: 53, radius: 10, title: "확인")
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .highlighted)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        //Users/;kimjuncheol/Documents/GitHub/StudyGaemi/StudyGaemi/Views/BottomSheetViewController.swift
        super.viewDidLoad()
        
        setupViews()
        addSubviews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(countDownDatePicker)
        view.addSubview(confirmButton)
    }
    
    private func setupLayout() {
        countDownDatePicker.translatesAutoresizingMaskIntoConstraints = false
        countDownDatePicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        countDownDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: countDownDatePicker.bottomAnchor, constant: 56).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    /*
    init(repeatingSecondsTimer: RepeatingSecondsTimer) {
        self.repeatingSecondsTimer = repeatingSecondsTimer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    */
    
    @objc private func didTapConfirmButton() {
        startTimer()
        
        let circularTimerVC = CircularTimerVC(startDate: Date(), countDownDurationSeconds: countDownDatePicker.countDownDuration)
        navigationController?.pushViewController(circularTimerVC, animated: true)
    }
    
    private func startTimer() {
//        repeatingSecondsTimer.start(durationSeconds: countDownDatePicker.countDownDuration, repeatingExecution: nil) {
//            print("완료")
//        }
    }
}

