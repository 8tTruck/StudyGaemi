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
    
    // 외부에서 Firestore 데이터베이스에 접근할 수 있도록 메서드 추가
        func getDatabase() -> Firestore {
            return db
        }
    
    // MARK: - User 데이터 생성하기
    func createUserData(email: String, nickName: String, loginMethod: String) {
        if let UID = Auth.auth().currentUser?.uid {
            let user = UserModel(
                UID: UID,
                email: email,
                nickName: nickName,
                loginMethod: loginMethod
            )
            
            do {
                try db.collection("User").document(UID).setData(from: user, merge: true)
            } catch let error {
                print("Firestore 데이터 생성 에러: \(error)")
            }
        }
    }
    
    // MARK: - WakeUp 데이터 생성하기
    func createWakeUpData(success: Bool) {
        if let UID = Auth.auth().currentUser?.uid {
            let userRef = db.collection("User").document(UID)
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
        if let UID = Auth.auth().currentUser?.uid {
            let userRef = db.collection("User").document(UID)
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
    
    // MARK: - Alert 데이터 생성하기
    func createAlertData(state: Int) {
        if let UID = Auth.auth().currentUser?.uid {
            let userRef = db.collection("User").document(UID)
            let alert = AlertModel(
                state: state,
                userRef: userRef,
                date: Timestamp(date: Date())
            )
            
            do {
                try db.collection("Alert").addDocument(from: alert)
            } catch let error {
                print("Firestore 데이터 생성 에러: \(error)")
            }
        }
    }
    
    // MARK: - User 데이터 받아오기
    func readUserData(completion: @escaping (Result<UserModel?, Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("User").document(UID)
        
        userRef.getDocument { document, error in
            if let document = document, document.exists {
                let user = try? document.data(as: UserModel.self)
                completion(.success(user))
            } else if let error = error {
                print("User 데이터 받아오기 에러: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - WakeUp 데이터 받아오기
    func readWakeUpData(completion: @escaping (Result<[WakeUpModel], Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("User").document(UID)
        
        db.collection("WakeUp").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let wakeUpData = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: WakeUpModel.self)
                }
                completion(.success(wakeUpData))
            } else if let error = error {
                print("WakeUp 데이터 받아오기 에러: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Study 데이터 받아오기
    func readStudyData(completion: @escaping (Result<[StudyModel], Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("User").document(UID)
        
        db.collection("Study").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let studyData = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: StudyModel.self)
                }
                completion(.success(studyData))
            } else if let error = error {
                print("Study 데이터 받아오기 에러: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Alert 데이터 받아오기
    func readAlertData(completion: @escaping (Result<[AlertModel], Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("User").document(UID)
        
        db.collection("Alert").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let alertData = querySnapshot.documents.compactMap { document in
                    return try? document.data(as: AlertModel.self)
                }
                completion(.success(alertData))
            } else if let error = error {
                print("Alert 데이터 받아오기 에러: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - User 데이터 업데이트하기
    func updateUserData(email: String, nickName: String?, loginMethod: String?) {
        var updateData: [String: Any] = [:]
        
        if let nickName = nickName {
            updateData["nickName"] = nickName
        }
        
        if let loginMethod = loginMethod {
            updateData["loginMethod"] = loginMethod
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
    
    // MARK: - Alert 데이터 업데이트하기
    func updateAlertData(state: Int) {
        guard let UID = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("User").document(UID)
        
        let alertData: [String: Any] = [
            "state": state,
            "date": Timestamp(date: Date())
        ]
        
        db.collection("Alert").whereField("userRef", isEqualTo: userRef).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Firestore 문서 조회 에러: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("조건에 맞는 문서가 없습니다.")
                return
            }
            
            for document in documents {
                self.db.collection("Alert").document(document.documentID).updateData(alertData) { error in
                    if let error = error {
                        print("Firestore 문서 업데이트 에러: \(error)")
                    } else {
                        print("Alert 데이터가 성공적으로 업데이트되었습니다.")
                    }
                }
            }
        }
    }
    
    // MARK: - User 데이터 삭제하기
    func deleteUserData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인이 되어있지 않습니다."])))
            return
        }

        let userRef = db.collection("User").document(UID)
        
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
        guard let UID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인이 되어있지 않습니다."])))
            return
        }

        let userRef = db.collection("User").document(UID)
        
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
        guard let UID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인이 되어있지 않습니다."])))
            return
        }

        let userRef = db.collection("User").document(UID)
        
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
    
    // MARK: - Alert 데이터 삭제하기
    func deleteAlertData(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "현재 로그인이 되어있지 않습니다."])))
            return
        }

        let userRef = db.collection("User").document(UID)
        
        db.collection("Alert").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Alert 데이터를 찾을 수 없습니다."])))
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
    
    // MARK: - 로그인방식 확인 메소드
    func getLoginMethod(completion: @escaping (String) -> Void) {
        self.readUserData { result in
            switch result {
            case .success(let data):
                let loginMethod = data?.loginMethod ?? "Firebase"
                completion(loginMethod)
            case .failure(let error):
                print("로그인방식 받아오기 에러: \(error)")
                completion("Firebase")
            }
        }
    }
}
