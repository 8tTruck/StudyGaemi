//
//  FirestoreManager.swift
//  StudyGaemi
//
//  Created by 신지연 on 2024/06/12.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

final class FirestoreManager {
    static let shared = FirestoreManager()
    private init() { }
    
    private let db = Firestore.firestore()
    
    // study 정보 가져오기
    func fetchStudyData() async throws -> [Study] {
        let querySnapshot = try await db.collection("Study").getDocuments()
        var studies: [Study] = []
        
        for document in querySnapshot.documents {
            do {
                if let study = try? document.data(as: Study.self) {
                    studies.append(study)
                }
            } catch {
                print("Error decoding study: \(error)")
            }
        }
        return studies
    }
    
    func createWakeUpData(success: Bool) {
            if let email = Auth.auth().currentUser?.email {
                let wakeUp = Wakeup(
                    //email: email,
                    success: success, 
                    date: Timestamp(date: Date())
                )
                do {
                  try db.collection("WakeUp").document("Data").setData(from: wakeUp)
                } catch let error {
                  print("Firestore 데이터 생성 에러: \(error)")
                }
            }
        }
}
