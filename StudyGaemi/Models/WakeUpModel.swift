//
//  WakeUpModel.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/13/24.
//

import Foundation
import FirebaseFirestore

struct WakeUpModel: Codable {
    let userRef: DocumentReference
    let success: Bool
    let date: Timestamp
}
