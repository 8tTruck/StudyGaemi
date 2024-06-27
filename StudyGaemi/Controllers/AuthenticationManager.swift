//
//  AuthenticationManager.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/11/24.
//

import FirebaseAuth
import Firebase
import Foundation
import KakaoSDKUser
import KakaoSDKAuth
import KakaoSDKCommon

class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() { }
    
    private let db = Firestore.firestore()
    
    // MARK: - 회원가입
    func createUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // 회원가입 실패 처리
                print("회원가입 실패 에러: \(error.localizedDescription)")
                return
            }
            // 로그인
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    print("로그인 실패 에러: \(error.localizedDescription)")
                } else if let user = authResult?.user {
                    print("로그인 성공: \(user.email ?? "")")
                    FirestoreManager.shared.createUserData(email: email, nickName: email, loginMethod: "Firebase")
                }
            }
            
            // 이메일 인증 코드 전송
            self.sendEmail(authResult: authResult)
        }
    }
    
    // MARK: - 로그인
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("로그인 실패 에러: \(error.localizedDescription)")
            } else if let user = authResult?.user {
                self.checkEmailVerifiedForLogin { isEmailVerified in
                    if isEmailVerified {
                        print("로그인 성공: \(user.email ?? "")")
                        // 인증이 완료된 사용자를 위한 추가 로직
                    } else {
                        print("이메일 인증이 필요합니다. 이메일을 확인해주세요.")
                        // 로그아웃 처리
                        do {
                            try Auth.auth().signOut()
                        } catch let signOutError as NSError {
                            print("Error signing out: \(signOutError.localizedDescription)")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Apple 로그인
    func signInWithApple(credential: OAuthCredential, email: String, nickName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error as NSError? {
                print("Firebase 로그인 에러: \(error.localizedDescription)")
                print("오류 코드: \(error.code)")
                
                // 만약 사용자가 없다면 새로운 사용자 생성
                if error.code == AuthErrorCode.userNotFound.rawValue {
                    Auth.auth().createUser(withEmail: email, password: "some_secure_password") { authResult, error in
                        if let error = error {
                            print("Firebase 가입 에러: \(error.localizedDescription)")
                            completion(.failure(error))
                        } else {
                            // 새로 생성된 사용자 로그인
                            Auth.auth().signIn(with: credential) { (authResult, error) in
                                if let error = error {
                                    print("Firebase 로그인 에러: \(error.localizedDescription)")
                                    completion(.failure(error))
                                } else {
                                    
                                    print("애플 로그인 성공")
                                    FirestoreManager.shared.createUserData(email: email, nickName: nickName, loginMethod: "apple")
                                    completion(.success(()))
                                }
                            }
                        }
                    }
                } else {
                    print("다른 에러 발생: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            } else {
                print("애플 로그인 성공")
                FirestoreManager.shared.createUserData(email: email, nickName: nickName, loginMethod: "apple")
                completion(.success(()))
            }
        }
    }
    
    // MARK: - 카카오 로그인
    func kakaoAuthSignIn(completion: @escaping (Result<Void, Error>) -> Void) {
        if AuthApi.hasToken() {
            UserApi.shared.accessTokenInfo { _, error in
                if let error = error {
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        self.openKakaoService(completion: completion)                    }
                    else {
                        completion(.failure(error))
                    }
                } else {
                    self.loadingInfoDidKakaoAuth(completion: completion)
                }
            }
        } else {
            self.openKakaoService(completion: completion)
        }
    }

    // MARK: - 카카오 서비스 이동
    func openKakaoService(completion: @escaping (Result<Void, Error>) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    _ = oauthToken // 로그인 성공
                    self.loadingInfoDidKakaoAuth(completion: completion) // 사용자 정보 불러와서 Firebase Auth 로그인하기
                }
            }
        } else { // 카카오톡 앱 이용 불가능한 사람
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                if let error = error {
                    completion(.failure(error))
                } else {
                    _ = oauthToken // 로그인 성공
                    self.loadingInfoDidKakaoAuth(completion: completion) // 사용자 정보 불러와서 Firebase Auth 로그인하기
                }
            }
        }
    }

    // MARK: - 카카오 정보로 Firebase 회원가입 및 로그인
    func loadingInfoDidKakaoAuth(completion: @escaping (Result<Void, Error>) -> Void) {
        func login(_ email: String, _ password: String, completion: @escaping (Result<Void, Error>) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { _, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
        
        UserApi.shared.me { kakaoUser, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let email = kakaoUser?.kakaoAccount?.email else {
                completion(.failure(NSError(domain: "KakaoAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "카카오 계정에서 이메일을 가져올 수 없습니다."])))
                return
            }
            guard let password = kakaoUser?.id else {
                completion(.failure(NSError(domain: "KakaoAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "카카오 계정에서 ID를 가져올 수 없습니다."])))
                return
            }
            guard let nickName = kakaoUser?.kakaoAccount?.profile?.nickname else {
                completion(.failure(NSError(domain: "KakaoAuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "카카오 계정에서 닉네임을 가져올 수 없습니다."])))
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: String(password)) { authResult, error in
                if let error = error {
                    print("회원가입 실패 에러: \(error.localizedDescription)")
                    login(email, String(password)) { result in
                        switch result {
                        case .success:
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    login(email, String(password)) { result in
                        switch result {
                        case .success:
                            FirestoreManager.shared.createUserData(email: email, nickName: nickName, loginMethod: "kakao")
                            completion(.success(()))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                }
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
    
    func checkEmailVerifiedForLogin(completion: @escaping (Bool) -> Void) {
        if let user = Auth.auth().currentUser {
            user.reload { error in
                if let error = error {
                    print("Error reloading user: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(user.isEmailVerified)
            }
        } else {
            completion(false)
        }
    }
    
    func checkEmailVerifiedForSignIn(timer: Timer?, navigationController: UINavigationController?, completion: @escaping (Bool) -> Void) {
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                user.reload { error in
                    if let error = error {
                        print("이메일 인증 실패: \(error.localizedDescription)")
                        completion(false)
                        return
                    }

                    if user.isEmailVerified {
                        print("이메일 인증 완료")
                        timer?.invalidate()
                        completion(true)
                    } else {
                        print("이메일 인증 실패")
                        completion(false)
                    }
                }
            } else {
                print("이메일 인증 실패")
                completion(false)
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
            print("로그아웃 에러: \(signOutError.localizedDescription)")
        }
    }
    
    // MARK: - 회원탈퇴
    func deleteUser() {
        if let user = Auth.auth().currentUser {
            user.delete { error in
                if let error = error {
                    // 회원탈퇴 실패 처리
                    print("회원탈퇴 에러: \(error.localizedDescription)")
                } else {
                    // 회원탈퇴 성공 처리
                    print("회원탈퇴 성공")
                }
            }
        } else {
            print("가입된 계정이 아닙니다.")
        }
    }
    
    // MARK: - 카카오 로그아웃
    func kakaoAuthSignOut() {
        UserApi.shared.logout { error in
            if let error = error {
                print("카카오 로그아웃 실패: \(error.localizedDescription)")
                return
            } else {
                print("카카오 로그아웃 성공")
                return
            }
        }
    }
    
    // MARK: - 카카오 탈퇴(연결끊기)
    func kakaoUnlinkAndSignOut() {
        UserApi.shared.unlink { error in
            if let error = error {
                print("카카오 연결 끊기 실패: \(error.localizedDescription)")
                return
            } else {
                print("카카오 연결 끊기 성공")
                return
            }
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
    
    // MARK: - 닉네임 저장
    func saveNickname(_ nickname: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            completion(false, NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        let userData: [String: Any] = ["nickName": nickname]
        
        db.collection("User").document(UID).setData(userData, merge: true) { error in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // MARK: - 닉네임 불러오기
    func fetchNickname(completion: @escaping (String?, Error?) -> Void) {
        guard let UID = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
            return
        }
        
        db.collection("User").document(UID).getDocument { document, error in
            if let document = document, document.exists {
                let nickname = document.data()?["nickName"] as? String
                completion(nickname, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    func readUserNickName(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let usersRef = db.collection("User")
        let query = usersRef.whereField("email", isEqualTo: email)
        
        query.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(error))
                return
            }
            
            if let document = querySnapshot?.documents.first, document.exists {
                if let nickName = document.data()["nickName"] as? String {
                    completion(.success(nickName))
                } else {
                    completion(.success("Unknown")) // 닉네임이 없을 경우 기본값 "Unknown" 반환
                }
            } else {
                completion(.success("Unknown")) // 해당 이메일에 대한 사용자 정보가 없을 경우 기본값 "Unknown" 반환
            }
        }
    }

}


