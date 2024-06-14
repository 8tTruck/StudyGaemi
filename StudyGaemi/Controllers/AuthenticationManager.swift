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
    
    // MARK: - 이메일로 ID 확인
    func checkIfEmailExists(email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (providers, error) in
            if let error = error {
                // 오류 발생
                completion(false, error.localizedDescription)
                return
            }
            // providers에 값이 있는 경우 해당 이메일로 이미 가입된 계정이 존재함
            if let _ = providers {
                completion(true, nil)
            } else {
                // 해당 이메일로 가입된 계정이 존재하지 않음
                completion(false, "해당 이메일로 가입된 계정을 찾을 수 없습니다.")
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
    
    // MARK: - 회원가입 시 이메일 인증 확인
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
    
    // MARK: - 비밀번호 재설정
    func resetPassword(email: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
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
    
    // MARK: - 비밀번호 변경
    func updatePassword(currentPassword: String, newPassword: String, completion: @escaping (Bool, String?) -> Void) {
        let user = Auth.auth().currentUser
        let email = user?.email
        
        let credential = EmailAuthProvider.credential(withEmail: email!, password: currentPassword)
        
        user?.reauthenticate(with: credential, completion: { (authResult, error) in
            if let error = error {
                completion(false, "Current password is incorrect.")
                return
            }
            
            user?.updatePassword(to: newPassword, completion: { (error) in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else {
                    completion(true, nil)
                }
            })
        })
    }
}
