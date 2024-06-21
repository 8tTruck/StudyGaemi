//
//  AlertModel.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/20.
//

import Foundation
import FirebaseFirestore

struct AlertModel: Codable {
    let state: Int
    var userRef: DocumentReference
    let date: Timestamp
}
