//
//  SettingViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    private let firestoreManager = FirestoreManager.shared
    private let settingView = SettingView()

    private var settingItems = ["개인정보 처리 및 방침", "오류 및 버그 신고", "공지사항", "로그아웃", "회원탈퇴"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupTableView()
        fetchUserDetails()
        setupNotifications()
        getTotalStudyTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStudyData()
    }

    private func setupNavigationBar() {
            navigationItem.titleView = settingView.titleView
            
            if #available(iOS 13.0, *) {
                let appearance = UINavigationBarAppearance().then {
                    $0.configureWithOpaqueBackground()
                    $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
                    $0.shadowColor = UIColor(named: "navigationBarLine")
                }
                
                navigationController?.navigationBar.standardAppearance = appearance
                navigationController?.navigationBar.scrollEdgeAppearance = appearance
            }
        }

    private func setupView() {
        view.addSubview(settingView)
        settingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        settingView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    private func setupTableView() {
        settingView.tableView.delegate = self
        settingView.tableView.dataSource = self
        settingView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingView.tableView.isScrollEnabled = false
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(nicknameDidUpdate(notification:)), name: .nicknameDidUpdate, object: nil)
    }

    @objc private func nicknameDidUpdate(notification: Notification) {
        if let nickname = notification.userInfo?["nickname"] as? String {
            settingView.userLabel.text = nickname
            saveNicknameToFirestore(nickname)
        }
    }

    private func saveNicknameToFirestore(_ nickname: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userRef = firestoreManager.getDatabase().collection("User").document(userID)

        userRef.updateData(["nickName": nickname]) { error in
            if let error = error {
                print("닉네임 저장 실패: \(error.localizedDescription)")
            } else {
                print("닉네임 저장 성공")
            }
        }
    }

    private func fetchUserDetails() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userRef = firestoreManager.getDatabase().collection("User").document(userID)

        userRef.getDocument { [weak self] document, error in
            if let document = document, document.exists {
                let data = document.data()
                let nickname = data?["nickName"] as? String ?? "Unknown"
                let email = data?["email"] as? String ?? "Unknown"
                self?.settingView.userLabel.text = nickname

                if data?["loginMethod"] as? String == "Firebase" {
                    self?.settingItems.insert("비밀번호 변경", at: 0)
                    self?.settingView.emailLabel.text = email
                } else if data?["loginMethod"] as? String == "apple" {
                    self?.settingView.emailLabel.text = "Apple Login"
                } else if data?["loginMethod"] as? String == "kakao" {
                    self?.settingView.emailLabel.text = "Kakao Login"
                }
                self?.settingView.tableView.reloadData()
            } else {
                if let error = error {
                    print("사용자 정보 불러오기 실패: \(error)")
                }
            }
        }
    }

    private func getStudyData() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userRef = firestoreManager.getDatabase().collection("User").document(userID)

        firestoreManager.getDatabase().collection("Study").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let accumulatedDays = querySnapshot.documents.count
                self.settingView.accumulatedLabel.text = "\(accumulatedDays)일 누적"
            } else if let error = error {
                print("Study 데이터 불러오기 에러: \(error)")
            }
        }
    }

    private func getTotalStudyTime() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userRef = firestoreManager.getDatabase().collection("User").document(userID)

        firestoreManager.getDatabase().collection("Study").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
            if let querySnapshot = querySnapshot {
                let totalDuring = querySnapshot.documents.reduce(0) { $0 + ($1.data()["during"] as? Int ?? 0) }
                let hours = totalDuring / 3600
                let minutes = (totalDuring % 3600) / 60
                self.settingView.totalTimeLabel.text = "\(hours)시간 \(minutes)분"
            } else if let error = error {
                print("총 공부 시간 불러오기 에러: \(error)")
            }
        }
    }

    @objc private func editButtonTapped() {
        showBottomSheet()
    }

    private func showBottomSheet() {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        present(bottomSheetVC, animated: true, completion: nil)
    }

    // MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingItems[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Pretendard-Regular", size: 17)
        cell.backgroundColor = UIColor(named: "viewBackgroundColor")
        if settingItems[indexPath.row] == "회원탈퇴" {
            cell.textLabel?.textColor = UIColor(named: "fontRed")
            cell.backgroundColor = UIColor(named: "viewBackgroundColor")
        } else {
            cell.textLabel?.textColor = UIColor(named: "fontBlack")
            cell.backgroundColor = UIColor(named: "viewBackgroundColor")
        }
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(named: "viewBackgroundColor")

        let headerLabel = UILabel()
        headerLabel.text = "설정"
        headerLabel.font = UIFont(name: "Pretendard-Regular", size: 12)
        headerLabel.textColor = UIColor(named: "fontBlack")

        headerView.addSubview(headerLabel)
        headerLabel.snp.makeConstraints { make in
            make.leading.equalTo(headerView).offset(22)
            make.bottom.equalTo(headerView).offset(-8)
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageIndex = indexPath.row
        let pageViewController: UIViewController

        if settingItems[pageIndex] == "비밀번호 변경" {
            pageViewController = MemberInfoViewController()
        } else {
            switch settingItems[pageIndex] {
            case "개인정보 처리 및 방침":
                pageViewController = PrivacyPolicyViewController()
            case "오류 및 버그 신고":
                pageViewController = BugReportViewController()
            case "공지사항":
                pageViewController = AnnouncementViewController()
            case "로그아웃":
                showLogoutAlert()
                return
            case "회원탈퇴":
                showDeleteAlert()
                return
            default:
                return
            }
        }

        pageViewController.hidesBottomBarWhenPushed = true
        pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
        pageViewController.title = settingItems[pageIndex]
        navigationController?.pushViewController(pageViewController, animated: true)
    }

    private func showLogoutAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        let titleString = NSAttributedString(string: "로그아웃", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ])

        let messageString = NSAttributedString(string: "정말 로그아웃하시겠습니까?", attributes: [
            .font: UIFont.systemFont(ofSize: 14)
        ])

        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")

        let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")

        let confirmAction = UIAlertAction(title: "예", style: .destructive, handler: { _ in
            AuthenticationManager.shared.kakaoAuthSignOut()
            AuthenticationManager.shared.signOut()
            UserDefaults.standard.removeObject(forKey: "toggleButtonState")
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = loginVC
                    window.makeKeyAndVisible()
                }
            }
        })
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }

    private func showDeleteAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)

        let titleString = NSAttributedString(string: "회원탈퇴", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 17)
        ])

        let messageString = NSAttributedString(string: """
        회원탈퇴시 모든 정보가 삭제됩니다.
        정말 회원탈퇴하시겠습니까?
        """, attributes: [
            .font: UIFont.systemFont(ofSize: 14)
        ])

        alertController.setValue(titleString, forKey: "attributedTitle")
        alertController.setValue(messageString, forKey: "attributedMessage")

        let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        cancelAction.setValue(UIColor.gray, forKey: "titleTextColor")

        let confirmAction = UIAlertAction(title: "예", style: .destructive, handler: { _ in
            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            UserDefaults.standard.removeObject(forKey: "toggleButtonState")
            FirestoreManager.shared.deleteStudyData { result in
                switch result {
                case .success:
                    print("Study 데이터가 삭제되었습니다.")
                case .failure(let error):
                    print("Study 데이터 삭제 에러: \(error)")
                }
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            FirestoreManager.shared.deleteWakeUpData { result in
                switch result {
                case .success:
                    print("WakeUp 데이터가 삭제되었습니다.")
                case .failure(let error):
                    print("WakeUp 데이터 삭제 에러: \(error)")
                }
                dispatchGroup.leave()
            }

            dispatchGroup.enter()
            FirestoreManager.shared.deleteUserData { result in
                switch result {
                case .success:
                    print("회원탈퇴가 완료되었습니다.")
                case .failure(let error):
                    print("회원탈퇴 에러: \(error)")
                }
                dispatchGroup.leave()
            }

            dispatchGroup.notify(queue: .main) {
                print("모든 데이터 삭제 작업이 완료되었습니다.")
                AuthenticationManager.shared.deleteUser()
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "회원탈퇴 처리되었습니다.", message: nil, preferredStyle: .alert)
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                        AuthenticationManager.shared.kakaoUnlinkAndSignOut()
                        AuthenticationManager.shared.signOut()
                        self.completeLogout()
                    }
                    alertController.addAction(confirmAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        })
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)

        present(alertController, animated: true, completion: nil)
    }
}
