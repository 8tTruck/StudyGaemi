//
//  AlarmSettingController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/4/24.
//

import UserNotifications
import UIKit

class AlarmSettingController {
    
    static let shared = AlarmSettingController()
    
    private init() { }
    
    private var alarmModel: AlarmModel = AlarmCoreDataManager.shared.getAlarmData()
    
    func setAlarm() {
        
        self.alarmModel = AlarmCoreDataManager.shared.getAlarmData()
        
        // 알림 권한 요청
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if granted {
                self.scheduleAlarm(time: self.alarmModel.time, sound: self.alarmModel.sound, repeatEnabled: self.alarmModel.setRepeatEnabled(), repeatInterval: self.alarmModel.setRepeatInterval(), repeatCount: self.alarmModel.setRepeatCount())
            } else {
                print("알림 권한이 거부되었습니다.")
            }
        }
    }
    
    func getBackView(_ navigationController: UINavigationController?) {
        guard let navigationController = navigationController else { return }
        for viewController in navigationController.viewControllers {
            if let alarmViewController = viewController as? AlarmViewController {
                alarmViewController.toggleButton.isOn = true
                UserDefaults.standard.set(true, forKey: "toggleButtonState")
                navigationController.popToViewController(alarmViewController, animated: true)
                return
            }
        }
    }
    
    func setSecondsToZero(date: Date) -> Date? {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        components.second = 0
        return calendar.date(from: components)
    }
    
    private func scheduleAlarm(time: Date, sound: String, repeatEnabled: Bool, repeatInterval: String?, repeatCount: String?) {
        guard let time = setSecondsToZero(date: time) else {
            print("시간 설정 오류")
            return
        }
        
        let identifier = "기상하개미"
        let content = UNMutableNotificationContent()
        content.title = "일어나개미!"
        content.body = "기상시간입니다. 일어나개미!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(sound).wav"))
        content.userInfo = ["viewControllerIdentifier": "AlarmQuestionView"]
        
        let calendar = Calendar.current
        let interval: TimeInterval = 5
        let dateComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("알림 추가 오류: \(error.localizedDescription)")
            } else {
                let delay = time.timeIntervalSinceNow
                let dispatchTime = DispatchTime.now() + delay + 90
                DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                    UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                        let identifiers = notifications.map { $0.request.identifier }
                        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
                    }
                }
            }
        }
        
        // 최초 알림 설정
        for i in 1...11 {
            let triggerTime = time.addingTimeInterval(interval * Double(i))
            let triggerComponents = calendar.dateComponents([.hour, .minute, .second], from: triggerTime)
            let intervalTrigger = UNCalendarNotificationTrigger(dateMatching: triggerComponents, repeats: true)
            
            let intervalRequest = UNNotificationRequest(identifier: identifier + "_\(i)", content: content, trigger: intervalTrigger)
            
            UNUserNotificationCenter.current().add(intervalRequest) { (error) in
                if let error = error {
                    print("알림 추가 오류: \(error.localizedDescription)")
                }
            }
        }
        
        // 반복 알림 설정
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
                let repeatComponents = calendar.dateComponents([.hour, .minute], from: repeatTime)
                let repeatTrigger = UNCalendarNotificationTrigger(dateMatching: repeatComponents, repeats: true)
                
                let repeatRequest = UNNotificationRequest(identifier: identifier + "_repeat_\(i)", content: content, trigger: repeatTrigger)
                UNUserNotificationCenter.current().add(repeatRequest) { (error) in
                    if let error = error {
                        print("반복 알림 추가 오류: \(error.localizedDescription)")
                    } else {
                        let delay = repeatTime.timeIntervalSinceNow
                        let dispatchTime = DispatchTime.now() + delay + 90
                        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
                            UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                                let identifiers = notifications.map { $0.request.identifier }
                                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
                            }
                        }
                    }
                }
                
                for j in 1...11 {
                    let repeatTime = time.addingTimeInterval(Double(i) * repeatTimeInterval + interval * Double(j))
                    let repeatComponents = calendar.dateComponents([.hour, .minute, .second], from: repeatTime)
                    let repeatTrigger = UNCalendarNotificationTrigger(dateMatching: repeatComponents, repeats: true)
                    
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
    
    func removeScheduleAlarm() {
        // 현재 표시 중인 모든 알림을 제거
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            let identifiers = notifications.map { $0.request.identifier }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        }
        // 예약된 모든 알림을 제거
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifier = "기상하개미"
            let identifiers = requests.filter { $0.identifier.hasPrefix(identifier) }.map { $0.identifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func resetAlarm() {
        let dispatchTime = DispatchTime.now() + 490
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                AlarmSettingController.shared.setAlarm()
            }
        }
    }
}
