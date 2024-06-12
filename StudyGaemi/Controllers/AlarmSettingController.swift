//
//  AlarmSettingController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/4/24.
//

import UserNotifications
import UIKit

class AlarmSettingController {
    
    private var alarmModel: AlarmModel?
    
    func setAlarm(_ alarmModel: AlarmModel) {
        self.alarmModel = alarmModel
        print(alarmModel.time)
        AlarmViewController.alarmController.getTextAlarm(alarmModel)
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                guard let alarmModel = self.alarmModel else { return }
                self.scheduleAlarm(time: alarmModel.time, sound: alarmModel.sound, repeatEnabled: alarmModel.setRepeatEnabled(), repeatInterval: alarmModel.setRepeatInterval(), repeatCount: alarmModel.setRepeatCount())
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
    func getBackView(_ navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    private func scheduleAlarm(time: Date, sound: String, repeatEnabled: Bool, repeatInterval: String?, repeatCount: String?) {
        let identifier = "기상하개미"
        let content = UNMutableNotificationContent()
        content.title = "일어나개미!"
        content.body = "기상시간입니다. 일어나개미!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).wav"))
        content.userInfo = ["viewControllerIdentifier": "AlarmQuestionView"]
        
        let calendar = Calendar.current
        let interval: TimeInterval = 5
        
        for i in 0...11 {
            let triggerTime = time.addingTimeInterval(interval * Double(i))
            let triggerComponents = calendar.dateComponents([.hour, .minute, .second], from: triggerTime)
            let intervalTrigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: false)
            
            let intervalRequest = UNNotificationRequest(identifier: identifier + "_\(i)", content: content, trigger: intervalTrigger)
            
            UNUserNotificationCenter.current().add(intervalRequest) { (error) in
                if let error = error {
                    print("알림 추가 오류: \(error.localizedDescription)")
                }
            }
        }
        
        if repeatEnabled, let repeatInterval = repeatInterval, let repeatCount = repeatCount, let repeatCountInt = Int(repeatCount.replacingOccurrences(of: "회 반복", with: "")) {
            let repeatTimeInterval: TimeInterval
            switch repeatInterval {
            case "3분마다":
                repeatTimeInterval = 180
            case "5분마다":
                repeatTimeInterval = 300
            case "8분마다":
                repeatTimeInterval = 480
            default:
                repeatTimeInterval = 180
            }
            
            for i in 1...repeatCountInt {
                let repeatTime = time.addingTimeInterval(Double(i) * repeatTimeInterval)
                for j in 0...11 {
                    let triggerTime = repeatTime.addingTimeInterval(interval * Double(i))
                    let repeatComponents = calendar.dateComponents([.hour, .minute, .second], from: triggerTime)
                    let repeatTrigger = UNCalendarNotificationTrigger(dateMatching: repeatComponents, repeats: false)
                    
                    let repeatRequest = UNNotificationRequest(identifier: identifier + "_repeat_\(i)_\(j)", content: content, trigger: repeatTrigger)
                    UNUserNotificationCenter.current().add(repeatRequest) { (error) in
                        if let error = error {
                            print("반복 알림 추가 오류: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }
        
        print("알람이 설정되었습니다.")
    }
}
