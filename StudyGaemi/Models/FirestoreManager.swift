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
    
    // MARK: - User 데이터 생성하기
    func createUserData(email: String, nickName: String, userType: String) {
        let user = UserModel(
            email: email,
            nickName: nickName,
            loginMethod: userType
        )
        
        do {
            try db.collection("User").document(email).setData(from: user, merge: true)
        } catch let error {
            print("Firestore 데이터 생성 에러: \(error)")
        }
    }
    
    // MARK: - WakeUp 데이터 생성하기
    func createWakeUpData(success: Bool) {
        if let email = Auth.auth().currentUser?.email {
            let userRef = db.collection("User").document(email)
            let wakeUp = WakeUpModel(
                userRef: userRef,
                success: success,
                date: Timestamp(date: Date())
            )
            
            do {
                try db.collection("WakeUp").addDocument(from: wakeUp)
            } catch let error {
                print("Firestore 데이터 생성 에러: \(error)")
            }
        }
    }
    
    // MARK: - Study 데이터 생성하기
    func createStudyData(success: Bool, during: Int) {
        if let email = Auth.auth().currentUser?.email {
            let userRef = db.collection("User").document(email)
            let study = StudyModel(
                userRef: userRef,
                success: success,
                date: Timestamp(date: Date()),
                during: during
            )
            
            do {
                try db.collection("Study").addDocument(from: study)
            } catch let error {
                print("Firestore 데이터 생성 에러: \(error)")
            }
        }
    }
    
    // MARK: - User 데이터 받아오기
    func readUserData(completion: @escaping (Result<UserModel?, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let userRef = db.collection("User").document(email)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let user = try? document.data(as: UserModel.self)
                completion(.success(user))
            } else {
                print("WakeUp 데이터 받아오기 에러: ")
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - WakeUp 데이터 받아오기
    func readWakeUpData(completion: @escaping (Result<[WakeUpModel], Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let userRef = db.collection("User").document(email)
        
        db.collection("WakeUp").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let wakeUpData = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: WakeUpModel.self)
                }
                completion(.success(wakeUpData))
            } else {
                print("WakeUp 데이터 받아오기 에러: ")
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Study 데이터 받아오기
    func readStudyData(completion: @escaping (Result<[StudyModel], Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        let userRef = db.collection("User").document(email)
        
        db.collection("Study").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let studyData = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: StudyModel.self)
                }
                completion(.success(studyData))
            } else {
                print("Study 데이터 받아오기 에러: ")
                if let error = error {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - User 데이터 업데이트하기
    func updateUserData(email: String, nickName: String?, userType: String?) {
        var updateData: [String: Any] = [:]
        
        if let nickName = nickName {
            updateData["nickName"] = nickName
        }
        
        if let userType = userType {
            updateData["userType"] = userType
        }
        
        db.collection("User").document(email).updateData(updateData) { error in
            if let error = error {
                print("Firestore 데이터 업데이트 에러: \(error)")
            } else {
                print("User 데이터가 성공적으로 업데이트되었습니다.")
            }
        }
    }
    
    // MARK: - WakeUp 데이터 업데이트하기
    func updateWakeUpData(documentId: String, success: Bool) {
        let wakeUpData: [String: Any] = [
            "success": success,
            "date": Timestamp(date: Date())
        ]
        
        db.collection("WakeUp").document(documentId).updateData(wakeUpData) { error in
            if let error = error {
                print("Firestore 문서 업데이트 에러: \(error)")
            } else {
                print("WakeUp 데이터가 성공적으로 업데이트되었습니다.")
            }
        }
    }
    
    // MARK: - Study 데이터 업데이트하기
    func updateStudyData(documentId: String, success: Bool, during: Int) {
        let studyData: [String: Any] = [
            "success": success,
            "date": Timestamp(date: Date()),
            "during": during
        ]
        
        db.collection("Study").document(documentId).updateData(studyData) { error in
            if let error = error {
                print("Firestore 문서 업데이트 에러: \(error)")
            } else {
                print("Study 데이터가 성공적으로 업데이트되었습니다.")
            }
        }
    }
    
    // MARK: - User 데이터 삭제하기
    func deleteUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인이 되어있지 않습니다."])))
            return
        }

        let userRef = db.collection("User").document(email)
        
        userRef.delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - WakeUp 데이터 삭제하기
    func deleteWakeUpData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인이 되어있지 않습니다."])))
            return
        }

        let userRef = db.collection("User").document(email)
        
        db.collection("WakeUp").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "WakeUp 데이터를 찾을 수 없습니다."])))
                return
            }
            
            let batch = self.db.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    // MARK: - Study 데이터 삭제하기
    func deleteStudyData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인이 되어있지 않습니다."])))
            return
        }

        let userRef = db.collection("User").document(email)
        
        db.collection("Study").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Study 데이터를 찾을 수 없습니다."])))
                return
            }
            
            let batch = self.db.batch()
            
            for document in documents {
                batch.deleteDocument(document.reference)
            }
            
            batch.commit { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}
