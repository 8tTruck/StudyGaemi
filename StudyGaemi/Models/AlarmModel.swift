//
//  AlarmModel.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/4/24.
//

import Foundation

struct AlarmModel {
    var time: Date
    var difficulty: String
    var sound: String
    var repeatEnabled: Bool? = nil
    var repeatInterval: String? = nil
    var repeatCount: String? = nil
    
    func setRepeatEnabled() -> Bool {
        if let repeatEnabled = self.repeatEnabled {
            return repeatEnabled
        }
        return false
    }
    
    func setRepeatInterval() -> String {
        if let repeatInterval = self.repeatInterval {
            return repeatInterval
        }
        return ""
    }
    
    func setRepeatCount() -> String {
        if let repeatCount = self.repeatCount {
            return repeatCount
        }
        return ""
    }
}
