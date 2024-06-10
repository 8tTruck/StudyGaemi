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
        $0.addTarget(SettingViewController.self, action: #selector(editButtonTapped), for: .touchUpInside)
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
    let settingItems = ["회원정보 수정", "개인정보 처리 및 방침", "오류 및 버그 신고", "로그아웃", "공지사항"]
    
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
        
        let accessoryButton = UIButton(type: .system).then {
            $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            $0.tintColor = .gray
            $0.addTarget(self, action: #selector(accessoryButtonTapped(_:)), for: .touchUpInside)
            $0.tag = indexPath.row
        }
        
        cell.contentView.addSubview(accessoryButton)
        accessoryButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "설정"
    }
    @objc private func editButtonTapped() {
        let alertController = UIAlertController(title: "닉네임변경하개미?", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "새 닉네임을 입력하세요"
            alertController.becomeFirstResponder()
        }
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let newName = alertController.textFields?.first?.text {
                self.userLabel.text = newName
            }
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if let confirmButton = alertController.actions.first {
            confirmButton.setValue(UIColor(named: "pointOrange"), forKey: "titleTextColor")
        }
        
        present(alertController, animated: true) {
            // UIAlertController가 표시된 후에 배경색 변경
            alertController.view.superview?.subviews.first?.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
    }
    
    @objc private func accessoryButtonTapped(_ sender: UIButton) {
        let pageIndex = sender.tag
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
            showLogoutAlert()
        case 4:
            pageViewController = AnnouncementViewController()
            pageViewController.view.backgroundColor = .white
            pageViewController.title = settingItems[pageIndex]
            navigationController?.pushViewController(pageViewController, animated: true)
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
            // 로그아웃 처리
        })
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

class MemberInfoViewController: UIViewController {
    private let currentPasswordField = UITextField()
    private let newPasswordField = UITextField()
    private let confirmPasswordField = UITextField()
    private let confirmButton = UIButton()
    private let errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let fixedHeaderView = UIView()
        view.addSubview(fixedHeaderView)
        fixedHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = "비밀번호 변경"
        titleLabel.textAlignment = .center
        fixedHeaderView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let antImageView = UIImageView(image: UIImage(named: "antImage")) // 적절한 이미지 이름 사용
        view.addSubview(antImageView)
        antImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(titleLabel)
            make.width.height.equalTo(24)
        }
        
        currentPasswordField.placeholder = "기존 비밀번호를 입력해주세요"
        currentPasswordField.textColor = .gray
        currentPasswordField.borderStyle = .roundedRect
        currentPasswordField.delegate = self
        currentPasswordField.isSecureTextEntry = true
        
        newPasswordField.placeholder = "새로운 비밀번호를 입력해주세요"
        newPasswordField.textColor = .gray
        newPasswordField.borderStyle = .roundedRect
        newPasswordField.delegate = self
        newPasswordField.isSecureTextEntry = true
        
        confirmPasswordField.placeholder = "새 비밀번호를 한 번 더 입력해주세요"
        confirmPasswordField.textColor = .gray
        confirmPasswordField.borderStyle = .roundedRect
        confirmPasswordField.delegate = self
        confirmPasswordField.isSecureTextEntry = true
        
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.text = ""
        
        let currentPasswordLabel = UILabel()
        currentPasswordLabel.text = "최소 2자리 최대 8자리"
        currentPasswordLabel.font = UIFont.systemFont(ofSize: 12)
        currentPasswordLabel.textColor = .gray
        
        let newPasswordLabel = UILabel()
        newPasswordLabel.text = "영문 + 숫자 6자리 이상"
        newPasswordLabel.font = UIFont.systemFont(ofSize: 12)
        newPasswordLabel.textColor = .gray
        
        let confirmPasswordLabel = UILabel()
        confirmPasswordLabel.text = "영문 + 숫자 6자리 이상"
        confirmPasswordLabel.font = UIFont.systemFont(ofSize: 12)
        confirmPasswordLabel.textColor = .gray
        
        confirmButton.backgroundColor = UIColor(named: "pointOrange")
        confirmButton.layer.cornerRadius = 24
        confirmButton.setTitle("확인", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [currentPasswordField, currentPasswordLabel, newPasswordField, newPasswordLabel, confirmPasswordField, confirmPasswordLabel, errorLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(fixedHeaderView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        view.addSubview(confirmButton)
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(44)
            make.height.equalTo(48)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let confirmButtonFrame = confirmButton.convert(confirmButton.bounds, to: view)
            let overlap = confirmButtonFrame.maxY - (view.frame.height - keyboardHeight)
            if overlap > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.y = -overlap - 20
                }
            }
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    private func adjustLayoutForKeyboard(show: Bool, keyboardHeight: CGFloat) {
        let buttonBottomOffset: CGFloat = show ? -keyboardHeight - 20 : -30
        
        confirmButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(buttonBottomOffset)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func confirmButtonTapped() {
        guard let newPassword = newPasswordField.text, let confirmPassword = confirmPasswordField.text else { return }
        
        if newPassword != confirmPassword {
            errorLabel.text = "입력한 비밀번호가 일치하지 않습니다."
        } else {
            errorLabel.text = ""
            let alertController = UIAlertController(title: "비밀번호 변경", message: "비밀번호가 변경되었습니다.", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: "확인", style: .destructive, handler: nil)
            confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            alertController.addAction(confirmAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class PrivacyPolicyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScrollView()
    }
    
    private func configureScrollView() {
        let scrollView = UIScrollView()
        let contentView = UIView()
        let textView = UILabel().then {
            $0.text = """
                개인정보 처리방침 내용입니다.
                여기에 원하는 내용을 입력하세요.
                """
            $0.numberOfLines = 0
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(29)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        textView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
}

class BugReportViewController: BaseViewController {
    private let bugReportView = UIView()
    private let textField = UITextField()
    private let fixedHeaderView = UIView()
    private let submitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFixedHeaderView()
        configureBugReportView()
        configureTextField()
        configureSubmitButton()
        setupKeyboardNotifications()
    }
    
    private func setupFixedHeaderView() {
        view.addSubview(fixedHeaderView)
        fixedHeaderView.backgroundColor = .white
        fixedHeaderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(44) // 고정된 높이 설정
        }
        
        // submitButton을 fixedHeaderView에 추가합니다.
        fixedHeaderView.addSubview(submitButton)
        submitButton.backgroundColor = UIColor(named: "pointOrange")
        submitButton.layer.cornerRadius = 24
        submitButton.setTitle("제출", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        
        submitButton.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(48)
            make.centerX.equalToSuperview() // 가운데 정렬
            make.bottom.equalToSuperview().offset(-10) // fixedHeaderView에 대해 bottom에 추가
        }
    }
    
    private func configureBugReportView() {
        view.addSubview(bugReportView)
        bugReportView.backgroundColor = .white
        bugReportView.layer.cornerRadius = 10
        bugReportView.layer.shadowColor = UIColor.black.cgColor
        bugReportView.layer.shadowOpacity = 0.1
        bugReportView.layer.shadowOffset = CGSize(width: 0, height: 2)
        bugReportView.layer.shadowRadius = 4
        
        bugReportView.snp.makeConstraints { make in
            make.top.equalTo(fixedHeaderView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(submitButton.snp.top).offset(-28) // submitButton과의 간격 설정
        }
    }
    
    private func configureTextField() {
        textField.placeholder = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        textField.textColor = .gray
        textField.borderStyle = .none
        textField.delegate = self
        
        bugReportView.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func configureSubmitButton() {
        view.addSubview(submitButton)
        submitButton.backgroundColor = UIColor(named: "pointOrange")
        submitButton.layer.cornerRadius = 24
        submitButton.setTitle("제출", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        
        submitButton.snp.makeConstraints { make in
            make.width.equalTo(342)
            make.height.equalTo(48)
            make.leading.trailing.equalToSuperview().inset(44)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
        }
    }
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            updateConstraintsForKeyboardAppearance(keyboardHeight: keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        updateConstraintsForKeyboardAppearance(keyboardHeight: 0)
    }
    
    private func updateConstraintsForKeyboardAppearance(keyboardHeight: CGFloat) {
        submitButton.snp.updateConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-keyboardHeight - 30)
        }
        
        bugReportView.snp.updateConstraints { make in
            make.bottom.equalTo(submitButton.snp.top).offset(-28)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class AnnouncementViewController: UIViewController {
    
}

extension BugReportViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.textColor == .gray {
            textField.text = nil
            textField.textColor = .black
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            textField.textColor = .gray
            textField.text = "오류 및 버그를 작성 후 제출버튼을 눌러주세요."
        }
    }
}
extension MemberInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.isEmpty == true {
            textField.textColor = .gray
        }
    }
}
