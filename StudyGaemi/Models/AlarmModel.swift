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
    
    var isRepeatEnabled: Bool {
        return repeatEnabled ?? false
    }
    
    var repeatIntervalValue: String {
        return repeatInterval ?? ""
    }
    
    var repeatIntervalMinutes: Int {
        switch repeatInterval {
        case "3분마다":
            return 3
        case "5분마다":
            return 5
        case "8분마다":
            return 8
        default:
            return 0
        }
    }
    
    var repeatCountValue: String {
        return repeatCount ?? ""
    }
    
    var repeatCountInt: Int {
        guard let repeatCount = repeatCount else { return 0 }
        return Int(repeatCount.replacingOccurrences(of: "회 반복", with: "")) ?? 1
    }
}
