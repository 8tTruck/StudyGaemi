//
//  SettingTiemrVC.swift
//  StudyGaemi
//
//  Created by 김준철 on 6/14/24.
//

import UIKit
import Then
import SnapKit


class SettingTimerVC: BaseViewController {
    
    static let repeatingSecondsTimer: RepeatingSecondsTimer = RepeatingSecondsTimerImpl()

    
    private lazy var countDownDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        return picker
    }()

    private let titleLabel = UILabel().then {
        $0.text = "공부하개미"
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
    
    private lazy var confirmButton: CustomButton = {
        let button = CustomButton(x: 50, y: 50, width: 334, height: 52, radius: 10, title: "공부 시작하기")
        button.addTouchAnimation()
        button.setTitleColor(UIColor(named: "fontWhite"), for: .normal)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        
        return button
    }()

    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = UIColor(hex: "#F68657")
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTimeLabel))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor(hex: "#FFE3D8").cgColor
        layer.lineWidth = 30
        return layer
    }()
    private var circularPath: UIBezierPath {
        let center = view.center
        let radius: CGFloat = 150
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
    }
    
    private var selectedDuration: TimeInterval = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        constraintLayout()
        setupViews()
        addSubviews()
        setupLayout()
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
    }
    
    override func constraintLayout() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(22)
        }
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(named: "viewBackgroundColor")
    }
    
    private func addSubviews() {
        
        view.addSubview(confirmButton)
        view.layer.addSublayer(trackLayer)
        view.addSubview(timeLabel)
    }
    
    private func setupLayout() {
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -36),
            confirmButton.heightAnchor.constraint(equalToConstant: 52),
            confirmButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 24),
            confirmButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),

            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func didTapConfirmButton() {
        guard selectedDuration > 0 else {
            // 선택된 시간이 없을 경우 경고 메시지를 표시할 수 있습니다.
            let alert = UIAlertController(title: "경고", message: "시간을 선택해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        startTimer(with: selectedDuration)
        let circularTimerVC = CircularTimerVC(startDate: Date(), countDownDurationSeconds: selectedDuration)
        navigationController?.pushViewController(circularTimerVC, animated: true)
    }
    
    @objc private func didTapTimeLabel() {
        let datePickerModalVC = DatePickerModalVC()
        datePickerModalVC.onDatePicked = { [weak self] duration in
            let hours = Int(duration) / 3600
            let minutes = (Int(duration) % 3600) / 60
            self?.timeLabel.text = String(format: "%02d:%02d", hours, minutes)
            self?.selectedDuration = duration
        }
        datePickerModalVC.modalPresentationStyle = .overFullScreen
        present(datePickerModalVC, animated: true, completion: nil)
    }
    
    private func startTimer(with duration: TimeInterval) {
        SettingTimerVC.repeatingSecondsTimer.start(durationSeconds: duration, repeatingExecution: nil) {
            print("완료")
        }
    }
}
