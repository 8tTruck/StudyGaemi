//
//  AlarmQuestionController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/7/24.
//

import UIKit

class AlarmQuestionController {
    
    func checkAnswer(_ text: String?, navigation: UINavigationController?, timer: Timer?, textField: UITextField) {
        if let answer = text {
            if answer == "361" {
                let alarmResultView = AlarmResultView()
                guard let navigation = navigation else {
                    return
                }
                timer?.invalidate()
                alarmResultView.status = .success
                navigation.pushViewController(alarmResultView, animated: true)
            } else {
                textField.shake()
                textField.layer.borderWidth = 1
                textField.layer.borderColor = UIColor(named: "failureColor")?.cgColor
                textField.becomeFirstResponder()
            }
        } else {
            textField.shake()
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(named: "failureColor")?.cgColor
            textField.becomeFirstResponder()
        }
    }
    
    func questionAlgorithm() {
        
    }
}
