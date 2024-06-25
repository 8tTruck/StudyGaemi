//
//  DatePickerModalVC.swift
//  StudyGaemi
//
//  Created by 김준철 on 6/21/24.
//

import UIKit

class DatePickerModalVC: UIViewController {
    
    var onDatePicked: ((TimeInterval) -> Void)?
    
    private lazy var countDownDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        return picker
    }()
    
    private lazy var confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("확인", for: .normal)
        button.titleLabel?.textColor = UIColor(hex: "#F68657")
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        addSubviews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
    }
    
    private func addSubviews() {
        view.addSubview(countDownDatePicker)
        view.addSubview(confirmButton)
    }
    
    private func setupLayout() {
        countDownDatePicker.translatesAutoresizingMaskIntoConstraints = false
        countDownDatePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        countDownDatePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.topAnchor.constraint(equalTo: countDownDatePicker.bottomAnchor, constant: 20).isActive = true
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc private func didTapConfirmButton() {
        onDatePicked?(countDownDatePicker.countDownDuration)
        dismiss(animated: true, completion: nil)
    }
}
