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
}
