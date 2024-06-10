//
//  EmailVerificationChecker.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/10/24.
//

import FirebaseAuth
import UIKit

class EmailVerificationChecker {
    var isConfirmUser = false
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    // 이메일 인증 상태를 확인하고 최신화하는 함수
    func checkEmailVerification(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            isConfirmUser = false
            completion(isConfirmUser)
            return
        }
        // 사용자 정보를 다시 로드
        user.reload { error in
            if let error = error {
                print("Error reloading user: \(error.localizedDescription)")
                self.isConfirmUser = false
                completion(self.isConfirmUser)
                return
            }
            // 이메일이 인증되었는지 여부를 확인
            self.isConfirmUser = user.isEmailVerified
            completion(self.isConfirmUser)
        }
    }
    // 인증 상태 변화 리스너 시작
    func startListeningForAuthChanges(completion: @escaping (Bool) -> Void) {
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            self?.checkEmailVerification(completion: completion)
        }
    }
    // 인증 상태 변화 리스너 해제
    func stopListeningForAuthChanges() {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
