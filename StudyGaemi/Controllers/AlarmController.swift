//
//  AlarmController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/3/24.
//

import UIKit

class AlarmController {
    
    var alarmModel: AlarmModel = AlarmCoreDataManager.shared.getAlarmData()
    
    func goAheadView(_ navigationController: UINavigationController?) {
        let alarmSettingView = AlarmSettingView()
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(alarmSettingView, animated: true)
    }
    
    func setAlarmTime() -> String {
        print("변환전: \(alarmModel.time)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm"
        let timeString = dateFormatter.string(from: alarmModel.time)
        print("변환후: \(timeString)")
        return timeString
    }
    
    func setAlarmInterval() -> String {
        return alarmModel.setRepeatInterval()
    }
    
    func setAlarmDifficulty() -> String {
        return alarmModel.difficulty
    }
    
    func setAmPm() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        // 현재 시간의 AM/PM 확인
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: alarmModel.time)
        
        if hour < 12 {
            return "AM"
        } else {
            return "PM"
        }
    }
    
    func updateNotificationSettings(isOn: Bool) {
        if isOn {
            let time = AlarmCoreDataManager.shared.getAlarmData().time
            let calendar = Calendar.current
            let currentDate = Date()
            let components = calendar.dateComponents([.minute], from: time, to: currentDate)
            
            guard let count = Int(AlarmCoreDataManager.shared.getAlarmData().setRepeatCount().replacingOccurrences(of: "회 반복", with: "")),
                  let minute = Int(AlarmCoreDataManager.shared.getAlarmData().setRepeatInterval().replacingOccurrences(of: "분마다", with: "")) else {
                
                if let minuteDifference = components.minute, minuteDifference >= 2 {
                    print("알림 켜기")
                    AlarmSettingController.shared.setAlarm()
                    UserDefaults.standard.set(isOn, forKey: "toggleButtonState")
                } else {
                    print("정해진 시간이 다 지나지 않았습니다.")
                }
                return
            }
            
            if let minuteDifference = components.minute, minuteDifference >= (count * minute) {
                print("알림 켜기")
                AlarmSettingController.shared.setAlarm()
                UserDefaults.standard.set(isOn, forKey: "toggleButtonState")
            } else {
                print("정해진 시간이 다 지나지 않았습니다.")
            }
        } else {
            print("알림 끄기")
            AlarmSettingController.shared.removeScheduleAlarm()
            UserDefaults.standard.set(isOn, forKey: "toggleButtonState")
        }
    }
}
