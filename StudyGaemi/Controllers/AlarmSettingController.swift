//
//  AlarmSettingController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/4/24.
//

import UserNotifications
import UIKit

class AlarmSettingController {
    
    weak var delegate: AlarmDelegate?
    
    static let shared = AlarmSettingController()
    
    private init() { }
    
    private var alarmModel: AlarmModel = AlarmCoreDataManager.shared.getAlarmData()
    
    func setAlarm() {
        
        self.alarmModel = AlarmCoreDataManager.shared.getAlarmData()
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                self.scheduleAlarm(alarm: self.alarmModel)
            } else {
                DispatchQueue.main.async {
                    self.delegate?.showAlert(message: "알림 권한이 거부되어\n 알람 기능을 사용할 수 없습니다.")
                }
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
    
    private func scheduleAlarm(alarm: AlarmModel) {
        guard let time = setSecondsToZero(date: alarm.time) else {
            self.delegate?.showAlert(message: "시간 설정 오류")
            return
        }
        
        let identifier = "기상하개미"
        let content = UNMutableNotificationContent()
        content.title = "일어나개미!"
        content.body = "기상시간입니다. 일어나개미!"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(alarm.sound).wav"))
        content.userInfo = ["viewControllerIdentifier": "AlarmQuestionView"]
        
        let calendar = Calendar.current
        let interval: TimeInterval = 5
        let dateComponents = calendar.dateComponents([.hour, .minute], from: time)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        self.removeScheduleAlarm {
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    self.delegate?.showAlert(message: "알림 추가 오류: \(error.localizedDescription)")
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
                        self.delegate?.showAlert(message: "알림 추가 오류: \(error.localizedDescription)")
                    }
                }
            }
            
            // 반복 알림 설정
            if alarm.isRepeatEnabled {
                let repeatTimeInterval: TimeInterval
                switch alarm.repeatIntervalMinutes {
                case 3:
                    repeatTimeInterval = 180
                case 5:
                    repeatTimeInterval = 300
                case 8:
                    repeatTimeInterval = 480
                default:
                    repeatTimeInterval = 180
                }
                
                for i in 1...alarm.repeatCountInt {
                    let repeatTime = time.addingTimeInterval(Double(i) * repeatTimeInterval)
                    let repeatComponents = calendar.dateComponents([.hour, .minute], from: repeatTime)
                    let repeatTrigger = UNCalendarNotificationTrigger(dateMatching: repeatComponents, repeats: true)
                    
                    let repeatRequest = UNNotificationRequest(identifier: identifier + "_repeat_\(i)", content: content, trigger: repeatTrigger)
                    UNUserNotificationCenter.current().add(repeatRequest) { (error) in
                        if let error = error {
                            self.delegate?.showAlert(message: "알림 추가 오류: \(error.localizedDescription)")
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
                                self.delegate?.showAlert(message: "반복 알림 추가 오류: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            }
            print("알람이 설정되었습니다.")
        }
    }
    
    // MARK: - 알람 저장 전에 시간 비교해서 반환해주는 메소드
    func checkAlarmTimeSettings(_ navigationController: UINavigationController?) {
        if self.isAlarmTimeValid() {
            self.setAlarm()
            self.getBackView(navigationController)
            delegate?.showAlert(message: "알람이 설정되었습니다.\n원활한 알람을 위해 무음모드를 해제해 주세요.")
        } else {
            delegate?.showAlert(message: "알람 시간을 재설정해 주세요.")
        }
    }
    
    // MARK: - 현재 설정된 모든 기상 알람을 제거
    func removeScheduleAlarm(completion: @escaping () -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let identifier = "기상하개미"
            let identifiers = requests.filter { $0.identifier.hasPrefix(identifier) }.map { $0.identifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    // MARK: - 현재 표시중인 알림창을 모두 제거
    func removeNotification() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            let identifiers = notifications.map { $0.request.identifier }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        }
    }
    
    // MARK: - 알람 재 설정 => 정답을 맞춘 후에 알람을 재 설정 하도록 해야함
    func resetAlarm() {
        let data = AlarmCoreDataManager.shared.getAlarmData()
        var adding: TimeInterval = 60
        
        if data.isRepeatEnabled {
            adding += TimeInterval(data.repeatIntervalMinutes * data.repeatCountInt * 60)
        }
        
        let dispatchTime = DispatchTime.now() + adding
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
                self.ensureAlarmExists()
            }
        }
    }
    
    // MARK: - 알람이 설정되어 있지 않을 때, 재 설정 시키는 메소드
    func ensureAlarmExists() {
        self.alarmModel = AlarmCoreDataManager.shared.getAlarmData()
        
        let identifier = "기상하개미"

        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let existingIdentifiers = requests.map { $0.identifier }
            
            if !existingIdentifiers.contains(identifier) {
                self.scheduleAlarm(alarm: self.alarmModel)
            }
        }
    }
    
    // MARK: - 알람 시간의 예외처리를 해주는 메소드
    func isAlarmTimeValid() -> Bool {
        let data = AlarmCoreDataManager.shared.getAlarmData()
        let alarmTime = data.time
        let currentTime = Date()
        
        let calendar = Calendar.current
        let alarmComponents = calendar.dateComponents([.hour, .minute], from: alarmTime)
        let currentComponents = calendar.dateComponents([.hour, .minute], from: currentTime)
        
        guard let alarmHour = alarmComponents.hour,
              let alarmMinute = alarmComponents.minute,
              let currentHour = currentComponents.hour,
              let currentMinute = currentComponents.minute else {
            return false
        }
        
        if (alarmHour > currentHour) || (alarmHour == currentHour && alarmMinute > currentMinute) {
            if data.isRepeatEnabled {
                let intervalTime = alarmTime.addingTimeInterval(TimeInterval(data.repeatIntervalMinutes * data.repeatCountInt * 60 + 60))
                let intervalComponents = calendar.dateComponents([.hour, .minute], from: intervalTime)
                
                guard let intervalHour = intervalComponents.hour,
                      let intervalMinute = intervalComponents.minute else {
                    return false
                }
                
                if (intervalHour > currentHour) || (intervalHour == currentHour && intervalMinute > currentMinute) {
                    if intervalTime <= currentTime.addingTimeInterval(TimeInterval(data.repeatIntervalMinutes * 60)) {
                        return false
                    }
                }
            }
            return true
        } else if (alarmHour < currentHour) || (alarmHour == currentHour && alarmMinute < currentMinute) {
            if data.isRepeatEnabled {
                let intervalTime = alarmTime.addingTimeInterval(TimeInterval(data.repeatIntervalMinutes * data.repeatCountInt * 60 + 60))
                let intervalComponents = calendar.dateComponents([.hour, .minute], from: intervalTime)
                
                guard let intervalHour = intervalComponents.hour,
                      let intervalMinute = intervalComponents.minute else {
                    return false
                }
                
                if (intervalHour > currentHour) || (intervalHour == currentHour && intervalMinute > currentMinute) {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}
