//
//  AuthenticationManager.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/11/24.
//

import FirebaseAuth
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
                print("회원가입 실패 에러: \(error.localizedDescription)")
                return
            }
            // 로그인
            self.signIn(email: email, password: password)
            
            // 이메일 인증 코드 전송
            self.sendEmail(authResult: authResult)
        }
    }
    
    
    // 이스케이핑 불리언
    // return false or true ?
    // MPVC에서 createUesr 호출
    // 반환값 true일때만 넘어갈 수 있도록
    
//    func createUser(email: String, password: String) {
//        // Firebase Authentication을 이용하여 신규 사용자 등록
//        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
//            if let error = error as NSError? {
//                // 사용자가 이미 가입된 경우
//                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
//                    // 이메일이 이미 사용 중임을 사용자에게 알림
//                    print("이미 사용 중인 이메일입니다. 다른 이메일을 시도하세요.")
//                    self.showAlert(message: "이미 사용중인 이메일입니다.")
//                    return
//                } else {
//                    // 기타 오류 처리
//                    print("오류 발생: \(error.localizedDescription)")
//                    return
//                }
//            } else {
//                // 가입이 성공한 경우
//                print("가입 성공!")
//                self.signIn(email: email, password: password)
//                self.sendEmail(authResult: authResult)
//            }
//        }
//    }
    
    // MARK: - 로그인
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("로그인 실패 에러: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                print("로그인 성공: \(user.email ?? "")")
            }
        }
    }
    
    // MARK: - ID찾기 & 중복 검사 : 입력된 이메일을 통해 서버에 해당 Email이 존재하는지 확인 후 Bool 리턴
    // IsEmailExists
    func checkIfEmailExists(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                // Firebase에서 오류가 발생한 경우
                print("Firebase 오류: \(error.localizedDescription)")
                completion(false) // 오류가 발생했으므로 계정이 존재하지 않는 것으로 간주
                return
            }
            
            // signInMethods : 해당 이메일로 가입된 사용자의 식별자 배열을 반환하며, 이 배열이 비어 있으면 해당 이메일로 가입된 계정이 없음
            if let signInMethods = signInMethods, !signInMethods.isEmpty {
                // signInMethods 배열이 비어 있지 않으면 해당 이메일로 이미 가입된 계정이 존재함
                print("AuthManager : 가입된 계정 있음")
                completion(true)
            } else {
                // signInMethods 배열이 비어 있으면 해당 이메일로 가입된 계정이 존재하지 않음
                print("AuthManager : 가입된 계정 없음")
                completion(false)
            }
        }
    }
    
    
    
    // 이미 가입된 회원인지 조회하는 메서드
    func checkIfUserExists(email: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                // Firebase에서 오류가 발생한 경우
                print("Firebase 오류: \(error.localizedDescription)")
                completion(false) // 오류가 발생했으므로 계정이 존재하지 않는 것으로 간주
            }
            
            if let signInMethods = signInMethods, !signInMethods.isEmpty {
                // signInMethods 배열이 비어 있지 않으면 해당 이메일로 이미 가입된 계정이 존재함
                print("이미 가입된 계정이 존재합니다.")
                completion(true)
            } else {
                // signInMethods 배열이 비어 있으면 해당 이메일로 가입된 계정이 존재하지 않음
                print("가입된 계정이 없습니다.")
                completion(false)
            }
        }
    }




    
    // MARK: - 이메일 인증 전송
    func sendEmail(authResult: AuthDataResult?) {
        authResult?.user.sendEmailVerification { error in
            if let error = error {
                // 이메일 인증 코드 전송 실패 처리
                print("인증메일 전송 실패 에러: \(error.localizedDescription)")
                return
            }
            
            // 이메일 인증 코드 전송 성공 처리
            print("인증메일 전송 성공")
        }
    }
    
    // MARK: - 회원가입 시 이메일 인증 확인
    func checkEmailVerified(timer: Timer?, navigationController: UINavigationController?) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                // 이메일 인증 완료 처리
                print("이메일 인증 완료")
                user.reload()
                if user.isEmailVerified {
                    let moveVC = CreateAccountSuccessViewController()
                    moveVC.modalPresentationStyle = .fullScreen
                    navigationController?.pushViewController(moveVC, animated: true)
                    timer?.invalidate()
                }
            } else {
                // 이메일 인증 실패 처리
                print("이메일 인증 실패")
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
            print("로그아웃 완료")
        } catch let signOutError as NSError {
            print("로그아웃 실패 에러: \(signOutError.localizedDescription)")
        }
    }
    
    // MARK: - 회원탈퇴
    func deleteUser() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    // 회원탈퇴 실패 처리
                    print("회원탈퇴 실패 에러: \(error.localizedDescription)")
                } else {
                    // 회원탈퇴 성공 처리
                    print("회원탈퇴 성공")
                }
            }
        } else {
            print("가입된 계정이 아닙니다.")
        }
    }
}
