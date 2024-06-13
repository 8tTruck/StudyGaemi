//
//  AlarmQuestionController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/7/24.
//

import UIKit

class AlarmQuestionController {
    
    var correctNumber: Int = 0
    
    func checkAnswer(_ text: String?, navigation: UINavigationController?, timer: Timer?, textField: UITextField) {
        if let answer = text {
            if answer == String(correctNumber) {
                let alarmResultView = AlarmResultView()
                guard let navigation = navigation else {
                    return
                }
                timer?.invalidate()
                alarmResultView.status = .success
                alarmResultView.correctNumber = correctNumber
                navigation.pushViewController(alarmResultView, animated: true)
                AudioController.shared.stopAlarmSound()
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
    
    func getQuestionAlgorithm(difficulty: String) -> String {
        switch difficulty {
        case "하":
            return generateEasyQuestion()
        case "중":
            return generateMediumQuestion()
        case "상":
            return generateHardQuestion()
        default:
            return generateMediumQuestion()
        }
    }
    
    private func generateEasyQuestion() -> String {
        let num1 = Int.random(in: 1...99)
        let num2 = Int.random(in: 1...99)
        let operations = ["+", "-"]
        let operation = operations.randomElement()!
        var question: String = ""
        
        switch operation {
        case "+":
            correctNumber = num1 + num2
        case "-":
            if num1 < num2 {
                correctNumber = num2 - num1
                question = "\(num2) \(operation) \(num1) = ?"
                return question
            }
            correctNumber = num1 - num2
        default:
            break
        }
        
        question = "\(num1) \(operation) \(num2) = ?"
        return question
    }
    
    private func generateMediumQuestion() -> String {
        let num1 = Int.random(in: 10...999)
        let num2 = Int.random(in: 10...999)
        let operations = ["+", "-"]
        let operation = operations.randomElement()!
        var question: String = ""
        
        switch operation {
        case "+":
            correctNumber = num1 + num2
        case "-":
            if num1 < num2 {
                correctNumber = num2 - num1
                question = "\(num2) \(operation) \(num1) = ?"
                return question
            }
            correctNumber = num1 - num2
        default:
            break
        }
        
        question = "\(num1) \(operation) \(num2) = ?"
        return question
    }
    
    private func generateHardQuestion() -> String {
        let num1 = Int.random(in: 10...99)
        let num2 = Int.random(in: 1...9)
        let operations = ["*", "/"]
        let operation = operations.randomElement()!
        var question: String = ""
        
        switch operation {
        case "*":
            correctNumber = num1 * num2
        case "/":
            correctNumber = num1 / num2
            correctNumber *= num2
            question = "\(correctNumber) \(operation) \(num2) = ?"
            return question
        default:
            break
        }
        
        question = "\(num1) \(operation) \(num2) = ?"
        return question
    }
}
