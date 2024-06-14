//
//  SettingViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import SnapKit
import Then
import UIKit

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    private let titleLabel = UILabel().then {
        $0.text = "개Me"
        $0.font = UIFont(name: CustomFontType.bold.name, size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.textColor = UIColor(named: "fontBlack")
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "mainAnt")
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var titleView = UIStackView(arrangedSubviews: [imageView, titleLabel]).then {
        $0.axis = .horizontal
        $0.spacing = 8
    }
    
    private let userView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 23
        $0.layer.shadowColor = UIColor(named: "pointBlack")?.cgColor
        $0.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        $0.layer.shadowRadius = 5.0
        $0.layer.shadowOpacity = 0.3
    }
    
    private let userImageView = UIImageView().then {
        $0.image = UIImage(named: "heartAnt")
        $0.contentMode = .scaleAspectFit
    }
    
    private let userLabel = UILabel().then {
        $0.text = "User Name"
        $0.font = UIFont.systemFont(ofSize: 17)
        $0.backgroundColor = .clear
    }
    
    private let emailLabel = UILabel().then {
        $0.text = "example123@naver.com"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
    }
    
    private let editButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "pencil.line"), for: .normal)
        $0.tintColor = .gray
        $0.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private let totalStudyLabel = UILabel().then {
        $0.text = "총 공부개미"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightGray
    }
    
    private let totalTimeLabel = UILabel().then {
        $0.text = "33시간 51분"
        $0.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        $0.textColor = .black
    }
    
    private let tableView = UITableView().then {
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        $0.separatorStyle = .none
    }
    let settingItems = ["비밀번호 변경", "개인정보 처리 및 방침", "오류 및 버그 신고", "공지사항", "로그아웃", "회원탈퇴"]
    
    private let accumulatedLabel = UILabel().then {
        $0.text = "10일 누적"
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .white
        $0.backgroundColor = .orange
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.masksToBounds = true
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.constraintLayout()
        self.setupTableView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func configureUI() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
        self.navigationItem.titleView = titleView
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance().then {
                $0.configureWithOpaqueBackground()
                $0.backgroundColor = UIColor(named: "viewBackgroundColor") ?? .systemBackground
                $0.shadowColor = UIColor(named: "navigationBarLine")
            }
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        view.addSubview(userView)
        userView.addSubview(userImageView)
        userView.addSubview(userLabel)
        userView.addSubview(emailLabel)
        userView.addSubview(editButton)
        userView.addSubview(separatorView)
        userView.addSubview(totalStudyLabel)
        userView.addSubview(totalTimeLabel)
        userView.addSubview(accumulatedLabel)
        view.addSubview(tableView)
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
        
        userView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(17)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(17)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(17)
            make.height.equalTo(169)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.top).offset(22)
            make.leading.equalTo(userView.snp.leading).offset(22)
            make.width.height.equalTo(46) // 이미지뷰의 크기를 설정합니다.
        }
        
        userLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(10)
            make.centerY.equalTo(userImageView.snp.centerY)
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(userLabel.snp.bottom).offset(4)
            make.leading.equalTo(userLabel)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(userView.snp.trailing).offset(-15)
            make.centerY.equalTo(userImageView.snp.centerY)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(userView).inset(5)
            make.top.equalTo(userImageView.snp.bottom).offset(15)
            make.height.equalTo(1) // 두께 조절
        }
        
        totalStudyLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorView.snp.bottom).offset(16)
            make.leading.equalTo(userView.snp.leading).offset(22)
        }
        
        totalTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(totalStudyLabel.snp.bottom).offset(4)
            make.leading.equalTo(totalStudyLabel)
        }
        
        accumulatedLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalTimeLabel)
            make.trailing.equalTo(userView.snp.trailing).offset(-22)
            make.height.equalTo(30)
            make.width.equalTo(80) // 적절한 크기로 조절
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(userView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
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
        if settingItems[indexPath.row] == "회원탈퇴" {
            cell.textLabel?.textColor = .red
        } else {
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let titleString = NSAttributedString(string: "설정", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .regular)
        ])
        return titleString.string
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pageIndex = indexPath.row
        let pageViewController: UIViewController
        
        switch pageIndex {
        case 0:
            pageViewController = MemberInfoViewController()
            pageViewController.view.backgroundColor = .white
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        case 1:
            pageViewController = PrivacyPolicyViewController()
            pageViewController.view.backgroundColor = .white
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        case 2:
            pageViewController = BugReportViewController()
            pageViewController.view.backgroundColor = .white
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
        case 3:
            pageViewController = AnnouncementViewController()
            pageViewController.view.backgroundColor = .white
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
    
    @objc private func editButtonTapped() {
        showBottomSheet()
    }
    
    private func showBottomSheet() {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        present(bottomSheetVC, animated: true, completion: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let bottomSheetVC = self.presentedViewController as? BottomSheetViewController {
            bottomSheetVC.adjustForKeyboard(notification: notification)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        if let bottomSheetVC = self.presentedViewController as? BottomSheetViewController {
            bottomSheetVC.resetForKeyboard()
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
            DispatchQueue.main.async {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
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
            AuthenticationManager.shared.deleteUser()
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "회원탈퇴 처리되었습니다.", message: nil, preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                    let loginVC = LoginViewController()
                    loginVC.modalPresentationStyle = .fullScreen
                    self.present(loginVC, animated: true, completion: nil)
                }
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            }

        })
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
