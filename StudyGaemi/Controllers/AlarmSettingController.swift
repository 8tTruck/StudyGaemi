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
    
    // UIDatePicker에서 선택한 시간을 한국 시간대로 변환하는 함수
    func getKoreanTime(from datePicker: UIDatePicker) -> Date {
        let selectedDate = datePicker.date
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        let seconds = TimeInterval(timeZone.secondsFromGMT(for: selectedDate))
        return Date(timeInterval: seconds, since: selectedDate)
    }
    
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
        let content = UNMutableNotificationContent()
        content.title = "일어날 시간이에요!"
        content.body = "설정한 시간입니다."
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).wav"))
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        if repeatEnabled, let repeatInterval = repeatInterval, let repeatCount = repeatCount {
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
            
            let repeatTrigger = UNTimeIntervalNotificationTrigger(timeInterval: repeatTimeInterval, repeats: true)
            for _ in 0..<Int(repeatCount.replacingOccurrences(of: "회 반복", with: "") )! {
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: repeatTrigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if let error = error {
                        print("알림 추가 오류: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("알림 추가 오류: \(error.localizedDescription)")
                }
            }
        }
        
        print("알람이 설정되었습니다.")
    }
}
