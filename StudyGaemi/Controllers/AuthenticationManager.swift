//
//  AuthenticationManager.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/11/24.
//

import Firebase
import Foundation

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() { }
    
    // MARK: - 회원가입
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // 회원가입 실패 처리
                print("Error creating user: \(error.localizedDescription)")
                return
            }
            // 로그인
            self.signIn(email: email, password: password)
            
            // 이메일 인증 코드 전송
            self.sendEmail(authResult: authResult)
        }
    }
    
    // MARK: - 로그인
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                print("Login successful: \(user.email ?? "")")
            }
        }
    }
    
    // MARK: - 이메일 인증 전송
    func sendEmail(authResult: AuthDataResult?) {
        authResult?.user.sendEmailVerification { error in
            if let error = error {
                // 이메일 인증 코드 전송 실패 처리
                print("Error sending email verification: \(error.localizedDescription)")
                return
            }
            
            // 이메일 인증 코드 전송 성공 처리
            print("Email verification code sent")
        }
    }
    
    // MARK: - 이메일 인증 확인
    func checkEmailVerified(timer: Timer?, navigationController: UINavigationController?) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // 이메일 인증 완료 처리
                print("Email verified successfully")
                user.reload()
                if user.isEmailVerified {
                    let moveVC = CreateAccountSuccessViewController()
                    moveVC.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(moveVC, animated: true)
                    timer?.invalidate()
                }
            } else {
                // 이메일 인증 실패 처리
                print("Email verification failed")
            }
        }
    }
    
    // MARK: - 로그아웃
    func signOut() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError.localizedDescription)")
        }
    }
    
    // MARK: - 회원탈퇴
    func deleteUser() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    // 회원탈퇴 실패 처리
                    print("Error deleting user: \(error.localizedDescription)")
                } else {
                    // 회원탈퇴 성공 처리
                    print("User deleted successfully")
                }
            }
        } else {
            print("No user is currently signed in")
        }
    }
}
