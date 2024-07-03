//
//  AlarmController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/3/24.
//

import UIKit

class AlarmController {
    
    weak var delegate: AlarmDelegate?
    
    var alarmModel: AlarmModel = AlarmCoreDataManager.shared.getAlarmData()
    
    func goAheadView(_ navigationController: UINavigationController?) {
        let alarmSettingView = AlarmSettingView()
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(alarmSettingView, animated: true)
    }
    
    func setAlarmTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm"
        let timeString = dateFormatter.string(from: alarmModel.time)
        return timeString
    }
    
    func setAlarmInterval() -> String {
        return alarmModel.repeatIntervalValue
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
            if AlarmSettingController.shared.isAlarmTimeValid() {
                enableAlarm(isOn: isOn)
            } else {
                delegate?.showAlert(message: "알람 시간을 재설정해 주세요.")
            }
        } else {
            AlarmSettingController.shared.removeScheduleAlarm {
                UserDefaults.standard.set(isOn, forKey: "toggleButtonState")
            }
        }
    }

    private func enableAlarm(isOn: Bool) {
        print("알림 켜기")
        AlarmSettingController.shared.setAlarm()
        UserDefaults.standard.set(isOn, forKey: "toggleButtonState")
    }
}

