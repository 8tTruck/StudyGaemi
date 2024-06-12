//
//  Data.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/12.
//

import Foundation
import FirebaseFirestore

struct Study: Codable {
    //let email: String
    let success: Bool
    let date: Timestamp
}

struct Wakeup: Codable {
    //let email: String
    let success: Bool
    let date: Timestamp
}
