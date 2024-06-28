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
    
    private var moreItems = ["친구초대", "앱 정보"] //추후에 랭킹도 추가하면 될듯
    private var settingItems = ["개인정보 처리 및 방침", "오류 및 버그 신고", "공지사항"]
    
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
        settingView.logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
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
        _ = firestoreManager.getDatabase().collection("User").document(userID)
        
        firestoreManager.readStudyData { result in
            switch result {
            case .success(let studyData):
                let calendar = Calendar.current
                
                // 날짜 단위로 비교하기 위해 studyData의 date를 추출하여 Set에 추가
                var dateSet = Set<Date>()
                
                for study in studyData {
                    
                    let studyDate = study.date.dateValue()
                    // 날짜 단위로만 비교하여 Set에 추가
                    let components = calendar.dateComponents([.year, .month, .day], from: studyDate)
                    if let dateOnly = calendar.date(from: components) {
                        dateSet.insert(dateOnly)
                    }
                    
                }
                
                // 유효한 날짜들 (중복되지 않은 날짜들) 출력 및 갯수 설정
                print("uniqueDates: \(dateSet)")
                self.settingView.accumulatedLabel.text = "\(dateSet.count)일 누적"
            case .failure(let error):
                // 데이터를 받아오는 데 실패했을 때의 처리
                print("Failed to fetch study data with error: \(error)")
                // 여기서 적절한 UI 처리를 추가할 수 있습니다. 예를 들어, 에러를 사용자에게 알리는 경고창을 띄우거나 다른 작업을 수행할 수 있습니다.
            }
        }
        
        //        firestoreManager.getDatabase().collection("Study").whereField("userRef", isEqualTo: userRef).getDocuments { querySnapshot, error in
        //            if let querySnapshot = querySnapshot {
        //                let accumulatedDays = querySnapshot.documents.count
        //                self.settingView.accumulatedLabel.text = "\(accumulatedDays)일 누적"
        //            } else if let error = error {
        //                print("Study 데이터 불러오기 에러: \(error)")
        //            }
        //        }
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
    
    @objc private func logoutButtonTapped() {
        showLogoutAlert()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return moreItems.count
        case 1:
            return settingItems.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = moreItems[indexPath.row]
        case 1:
            cell.textLabel?.text = settingItems[indexPath.row]
        default:
            break
        }
        cell.textLabel?.font = UIFont(name: "Pretendard-Regular", size: 17)
        cell.backgroundColor = UIColor(named: "viewBackgroundColor")
        cell.textLabel?.textColor = UIColor(named: "fontBlack")
        cell.backgroundColor = UIColor(named: "viewBackgroundColor")
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
        
        if section == 0 {
            headerLabel.text = "더보기"
        } else {
            headerLabel.text = "설정"
        }

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
        if section == 0 {
            return 30
        } else {
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageIndex = indexPath.row
        let pageViewController: UIViewController
        
        if indexPath.section == 0 {
            switch moreItems[indexPath.row] {
            case "친구초대":
                let objectsToShare = ["https://apps.apple.com/kr/app/공부하개미/id6503416980"]
                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true, completion: nil)
            case "앱 정보":
                pageViewController = TeamInfoViewController()
                pageViewController.hidesBottomBarWhenPushed = true
                pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
                pageViewController.title = moreItems[pageIndex]
                navigationController?.pushViewController(pageViewController, animated: true)
            default:
                return
            }
        } else {
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
                default:
                    return
                }
            }
            pageViewController.hidesBottomBarWhenPushed = true
            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
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
            FirestoreManager.shared.getLoginMethod { loginMethod in
                if loginMethod == "kakao" {
                    AuthenticationManager.shared.kakaoAuthSignOut()
                    AuthenticationManager.shared.signOut()
                    self.completeLogout()
                } else {
                    AuthenticationManager.shared.signOut()
                    self.completeLogout()
                }
            }
        })
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func completeLogout() {
        AlarmCoreDataManager.shared.deleteAlarm()
        DispatchQueue.main.async {
            let loginVC = UINavigationController(rootViewController: LoginViewController())
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = loginVC
                window.makeKeyAndVisible()
            }
        }
    }
}
