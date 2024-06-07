//
//  AlarmQuestionController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/7/24.
//

import UIKit

class AlarmQuestionController {
    
    func checkAnswer(_ text: String?, navigation: UINavigationController?, timer: Timer?) {
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
                // 정답 틀렸을때 버튼 흔들리는 효과 넣기
            }
        } else {
            // 정답 틀렸을떄 버튼 흔들리는 효과 넣기
        }
    }
    
    func questionAlgorithm() {
        
    }
}
