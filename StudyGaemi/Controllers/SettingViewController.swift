//
//  SettingViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Photos
import AVFoundation

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private let firestoreManager = FirestoreManager.shared
    private let settingView = SettingView()
  
    //private var moreItems = [ 친구초대 ]//추후에 랭킹도 추가하면 될듯
    //private var moreItemsIcons = ["paperplane", "info.circle"]
    private let imagePicker = UIImagePickerController()
    private var settingItems = ["친구초대","공지사항","도움말","오류 및 버그 신고", "앱 정보", "개인정보 처리 및 방침"]
    private var settingItemIcons = ["paperplane", "megaphone", "questionmark.circle",  "exclamationmark.triangle","info.circle", "lock.shield" ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
        setupTableView()
        fetchUserDetails()
        setupNotifications()
        getTotalStudyTime()
        loadProfileImage()

        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(userImageTapped))
        settingView.userImageView.addGestureRecognizer(imageTapGesture)
        settingView.userImageView.isUserInteractionEnabled = true

        imagePicker.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        settingView.tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        settingView.tableView.isScrollEnabled = false
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(nicknameDidUpdate(notification:)), name: .nicknameDidUpdate, object: nil)
    }

    @objc private func nicknameDidUpdate(notification: Notification) {
        if let nickname = notification.userInfo?["nickname"] as? String {
            settingView.userLabel.text = "\(nickname) \(AuthenticationManager.shared.generateNickNameCode())"
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
                let nickname = "\(data?["nickName"] ?? "User") \(AuthenticationManager.shared.generateNickNameCode())"
                let email = data?["email"] as? String ?? "Unknown"
                self?.settingView.userLabel.text = nickname
                
                if data?["loginMethod"] as? String == "Firebase" {
                    self?.settingItems.insert("비밀번호 변경", at: 0)
                    self?.settingItemIcons.insert("key.fill", at: 0)
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
                
                var dateSet = Set<Date>()
                
                for study in studyData {
                    let studyDate = study.date.dateValue()
                    let components = calendar.dateComponents([.year, .month, .day], from: studyDate)
                    if let dateOnly = calendar.date(from: components) {
                        dateSet.insert(dateOnly)
                    }
                }
                
                print("uniqueDates: \(dateSet)")
                self.settingView.accumulatedLabel.text = "\(dateSet.count)일 누적"
            case .failure(let error):
                print("Failed to fetch study data with error: \(error)")
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

    @objc private func logoutButtonTapped() {
        showLogoutAlert()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    @objc private func userImageTapped() {
        showImageSourceActionSheet()
    }

    private func showImageSourceActionSheet() {
        let alertController = UIAlertController(title: "프로필 사진", message: "프로필 사진을 선택하세요", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "카메라", style: .default) { _ in
            self.cameraAuth()
        }
        let libraryAction = UIAlertAction(title: "사진 앨범", style: .default) { _ in
            self.albumAuth()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func cameraAuth() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                if granted {
                    self.openCamera()
                } else {
                    self.showAlertAuth("카메라")
                }
            }
        }
    }

    private func albumAuth() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .denied:
            self.showAlertAuth("앨범")
        case .authorized:
            self.openPhotoLibrary()
        case .notDetermined, .restricted:
            PHPhotoLibrary.requestAuthorization { state in
                DispatchQueue.main.async {
                    if state == .authorized {
                        self.openPhotoLibrary()
                    } else {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }

    private func showAlertAuth(_ type: String) {
        if let appName = Bundle.main.infoDictionary!["CFBundleDisplayName"] as? String {
            let alertVC = UIAlertController(
                title: "설정",
                message: "\(appName)이(가) \(type) 접근 허용되어 있지 않습니다. 설정화면으로 가시겠습니까?",
                preferredStyle: .alert
            )
            let cancelAction = UIAlertAction(
                title: "취소",
                style: .cancel,
                handler: nil
            )
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alertVC.addAction(cancelAction)
            alertVC.addAction(confirmAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }

    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.modalPresentationStyle = .currentContext
            self.present(self.imagePicker, animated: true, completion: nil)
            self.tabBarController?.tabBar.isHidden = true
        } else {
            print("앨범에 접근할 수 없습니다.")
        }
    }

    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
            self.imagePicker.modalPresentationStyle = .currentContext
            self.present(self.imagePicker, animated: true, completion: nil)
            self.tabBarController?.tabBar.isHidden = true
        } else {
            print("카메라에 접근할 수 없습니다.")
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            picker.dismiss(animated: true, completion: nil)
            return
        }
        settingView.userImageView.image = selectedImage
        saveProfileImage(image: selectedImage)
        picker.dismiss(animated: true, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) {
                self.tabBarController?.tabBar.isHidden = false
            }
        }

    private func saveProfileImage(image: UIImage) {
        let fileName = UUID().uuidString
        if let imagePath = ImageHelper.saveImageToDocumentsDirectory(image: image, fileName: fileName) {
            UserDefaults.standard.setValue(imagePath, forKey: "profileImagePath")
        }
    }

    private func loadProfileImage() {
        if let imagePath = UserDefaults.standard.string(forKey: "profileImagePath") {
            if let profileImage = ImageHelper.loadImageFromDocumentsDirectory(fileName: imagePath) {
                settingView.userImageView.image = profileImage
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return moreItems.count
//        case 1:
//            return settingItems.count
//        default:
//            return 0
//        }
        return settingItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as? SettingTableViewCell else {
            return UITableViewCell()
        }
        
//        switch indexPath.section {
//        case 0:
//            cell.titleLabel.text = moreItems[indexPath.row]
//            cell.iconImageView.image = UIImage(systemName: moreItemsIcons[indexPath.row])
//            cell.iconImageView.tintColor = UIColor(named: "fontGray")
//        case 1:
//            cell.titleLabel.text = settingItems[indexPath.row]
//            cell.iconImageView.image = UIImage(systemName: settingItemIcons[indexPath.row])
//            cell.iconImageView.tintColor = UIColor(named: "fontGray")
//        default:
//            break
//        }
        cell.titleLabel.text = settingItems[indexPath.row]
        cell.iconImageView.image = UIImage(systemName: settingItemIcons[indexPath.row])
        cell.iconImageView.tintColor = UIColor(named: "fontGray")
        cell.titleLabel.font = UIFont(name: "Pretendard-Regular", size: 17)
        cell.backgroundColor = UIColor(named: "viewBackgroundColor")
        cell.titleLabel.textColor = UIColor(named: "fontBlack")
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
        
//        if section == 0 {
//            headerLabel.text = "더보기"
//        } else {
//            headerLabel.text = "설정"
//        }
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
//        if section == 0 {
//            return 30
//        } else {
//            return 30
//        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageIndex = indexPath.row
        let pageViewController: UIViewController
        
//        if indexPath.section == 0 {
//            switch moreItems[indexPath.row] {
//            case "친구초대":
//                let objectsToShare = ["https://apps.apple.com/kr/app/공부하개미/id6503416980"]
//                let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//                activityVC.popoverPresentationController?.sourceView = self.view
//                self.present(activityVC, animated: true, completion: nil)
//            case "앱 정보":
//                pageViewController = TeamInfoViewController()
//                pageViewController.hidesBottomBarWhenPushed = true
//                pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
//                pageViewController.title = moreItems[pageIndex]
//                navigationController?.pushViewController(pageViewController, animated: true)
//            default:
//                return
//            }
//        } else {
//            if settingItems[pageIndex] == "비밀번호 변경" {
//                pageViewController = MemberInfoViewController()
//            } else {
//                switch settingItems[pageIndex] {
//                case "개인정보 처리 및 방침":
//                    pageViewController = PrivacyPolicyViewController()
//                case "오류 및 버그 신고":
//                    pageViewController = BugReportViewController()
//                case "공지사항":
//                    pageViewController = AnnouncementViewController()
//                case "도움말":
//                    pageViewController = TutorialPageViewController()
//                default:
//                    return
//                }
//            }
//            pageViewController.hidesBottomBarWhenPushed = true
//            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
//            pageViewController.title = settingItems[pageIndex]
//            navigationController?.pushViewController(pageViewController, animated: true)
//        }
        
        if settingItems[pageIndex] == "비밀번호 변경" {
            pageViewController = MemberInfoViewController()
            pageViewController.hidesBottomBarWhenPushed = true
            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        } else if settingItems[pageIndex] == "친구초대" {
            let objectsToShare = ["https://apps.apple.com/kr/app/공부하개미/id6503416980"]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        } else {
            switch settingItems[pageIndex] {
            case "앱 정보":
                pageViewController = TeamInfoViewController()
            case "개인정보 처리 및 방침":
                pageViewController = PrivacyPolicyViewController()
            case "오류 및 버그 신고":
                pageViewController = BugReportViewController()
            case "공지사항":
                pageViewController = AnnouncementViewController()
            case "도움말":
                pageViewController = TutorialPageViewController()
            default:
                return
            }
            pageViewController.hidesBottomBarWhenPushed = true
            pageViewController.view.backgroundColor = UIColor(named: "viewBackgroundColor")
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
