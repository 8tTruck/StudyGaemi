//
//  AlarmController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/3/24.
//

import UIKit

class AlarmController {
    
    var alarmModel: AlarmModel?
    
    func goAheadView(_ navigationController: UINavigationController?) {
        let alarmSettingView = AlarmSettingView()
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(alarmSettingView, animated: true)
    }
    
    func getTextAlarm(_ alarmModel: AlarmModel) {
        self.alarmModel = alarmModel
    }
    
    func setAlarmTime() -> String {
        if let alarmModel = self.alarmModel {
            print("변환전: \(alarmModel.time)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH : mm"
            let timeString = dateFormatter.string(from: alarmModel.time)
            print("변환후: \(timeString)")
            return timeString
        }
        return "09 : 00"
    }
    
    func setAlarmInterval() -> String {
        if let alarmModel = self.alarmModel {
            return alarmModel.setRepeatInterval()
        }
        return "3분 마다"
    }
    
    func setAlarmDifficulty() -> String {
        if let alarmModel = self.alarmModel {
            return alarmModel.difficulty
        }
        return "중"
    }
    
    func setAmPm() -> String {
        if let alarmModel = self.alarmModel {
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
        return "AM"
    }
}
