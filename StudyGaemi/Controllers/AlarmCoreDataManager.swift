//
//  AlarmCoreDataManager.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/12/24.
//

import Foundation
import CoreData
import UIKit

class AlarmCoreDataManager {
    static let shared = AlarmCoreDataManager()
    var coreData: AlarmModel?
    private init() {}
    
    // MARK: - 코어데이터 context
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - 알람 저장 메소드
    func saveAlarm(alarm: AlarmModel) {
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        
        do {
            let alarms = try context.fetch(fetchRequest)
            
            for alarm in alarms {
                context.delete(alarm)
            }
            
            let newAlarm = Alarm(context: context)
            newAlarm.time = alarm.time
            newAlarm.difficulty = alarm.difficulty
            newAlarm.sound = alarm.sound
            newAlarm.repeatEnabled = alarm.repeatEnabled ?? false
            newAlarm.repeatInterval = alarm.repeatInterval
            newAlarm.repeatCount = alarm.repeatCount
            
            try context.save()
            
            self.fetchAlarm()
        } catch {
            print("알람 저장 실패 에러: \(error)")
        }
    }
    
    // MARK: - 알람 불러오기 메소드
    func fetchAlarm() {
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        
        do {
            let alarms = try context.fetch(fetchRequest)
            
            if let alarm = alarms.first {
                self.coreData = AlarmModel(
                    time: alarm.time ?? Date(),
                    difficulty: alarm.difficulty ?? "",
                    sound: alarm.sound ?? "",
                    repeatEnabled: alarm.repeatEnabled,
                    repeatInterval: alarm.repeatInterval,
                    repeatCount: alarm.repeatCount
                )
            }
        } catch {
            print("알람 불러오기 실패 에러: \(error)")
        }
    }
    
    // MARK: - 알람 삭제 메소드
    func deleteAlarm() {
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        
        do {
            let alarms = try context.fetch(fetchRequest)
            
            AlarmSettingController.shared.removeScheduleAlarm {
                UserDefaults.standard.removeObject(forKey: "toggleButtonState")
                
                for alarm in alarms {
                    self.context.delete(alarm)
                }
                
                do {
                    try self.context.save()
                    print("알람이 성공적으로 삭제되었습니다.")
                } catch {
                    print("알람 삭제 후 저장 실패: \(error)")
                }
            }
        } catch {
            print("알람 삭제 실패 에러: \(error)")
        }
    }
    
    // MARK: - 알람 데이터 반환 메소드
    func getAlarmData() -> AlarmModel {
        self.fetchAlarm()
        guard let alarmData = self.coreData else {
            return AlarmModel(time: Date(), difficulty: "중", sound: "알림음 1")
        }
        return alarmData
    }
}
