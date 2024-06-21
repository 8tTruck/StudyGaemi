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

    private let settingItems = ["비밀번호 변경", "개인정보 처리 및 방침", "오류 및 버그 신고", "공지사항", "로그아웃", "회원탈퇴"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchUserDetails()
        setupNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getStudyData()
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
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(nicknameDidUpdate(notification:)), name: .nicknameDidUpdate, object: nil)
    }

    @objc private func nicknameDidUpdate(notification: Notification) {
        if let nickname = notification.userInfo?["nickname"] as? String {
            settingView.userLabel.text = nickname
            AuthenticationManager.shared.saveNickname(nickname) { success, error in
                if success {
                    print("닉네임 저장 성공")
                } else {
                    print("닉네임 저장 실패: \(error?.localizedDescription ?? "")")
                }
            }
        }
    }

    private func fetchUserDetails() {
        guard let email = Auth.auth().currentUser?.email else { return }

        firestoreManager.readUserData { [weak self] result in
            switch result {
            case .success(let userData):
                self?.settingView.userLabel.text = userData?.nickName ?? "User"
                if userData?.loginMethod == "Firebase" {
                    self?.settingView.emailLabel.text = email
                } else if userData?.loginMethod == "apple" {
                    self?.settingView.emailLabel.text = "Apple Login"
                } else if userData?.loginMethod == "kakao" {
                    self?.settingView.emailLabel.text = "Kakao Login"
                }
            case .failure(let error):
                print("사용자 정보 불러오기 실패: \(error)")
            }
        }
    }

    private func getStudyData() {
        firestoreManager.readStudyData { result in
            switch result {
            case .success(let datas):
                let accumulatedDays = datas.count
                self.settingView.accumulatedLabel.text = "\(accumulatedDays)일 누적"
            case .failure(let error):
                print("Study 데이터 불러오기 에러: \(error)")
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

        switch pageIndex {
        case 0:
            pageViewController = MemberInfoViewController()
            pageViewController.hidesBottomBarWhenPushed = true
            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        case 1:
            pageViewController = PrivacyPolicyViewController()
            pageViewController.hidesBottomBarWhenPushed = true
            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        case 2:
            pageViewController = BugReportViewController()
            pageViewController.hidesBottomBarWhenPushed = true
            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        case 3:
            pageViewController = AnnouncementViewController()
            pageViewController.hidesBottomBarWhenPushed = true
            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        case 4:
            showLogoutAlert()
        case 5:
            showDeleteAlert()

        default:
            return
        }
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
                        AuthenticationManager.shared.signOut()
                        let loginVC = UINavigationController(rootViewController: LoginViewController())
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = loginVC
                            window.makeKeyAndVisible()
                        }
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
