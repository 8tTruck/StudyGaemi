//
//  StudyViewController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/29/24.
//

import UIKit
import SnapKit
import Then

class StudyViewController: BaseViewController {
    private var circularTimerView: CircularTimerView?
    private let startButton = UIButton(type: .system)
    private let datePicker = UIDatePicker()

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

    override func viewDidLoad() {
        self.view.addSubview(startButton)
        self.view.addSubview(datePicker)
        super.viewDidLoad() // 호출되는 순서에 대해 생각해
        self.configureUI()
        self.constraintLayout()
        setupUI()
        
        
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
        view.addSubview(datePicker)
        // 추가된 요소들의 constraint 설정
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 200)
        ])
    }

    private func setupUI() {
        // 배경 설정
        view.backgroundColor = .white

        // 시간 입력 DatePicker 추가
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 1
        view.addSubview(datePicker)
        
        
        startButton.frame = CGRect(x: 0, y: 0, width: 334, height: 53)
        startButton.setTitle("공부 시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        startButton.backgroundColor = UIColor(red: 255/255, green: 128/255, blue: 0/255, alpha: 1.0)
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        view.addSubview(startButton)
    }

    @objc private func startTimer() {
        let totalTime = datePicker.countDownDuration
        circularTimerView = CircularTimerView(frame: view.bounds, totalTime: totalTime)
        view.addSubview(circularTimerView!)
        circularTimerView?.startTimer(with: TimeInterval())
    }
    
}

extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

class ViewController: UIViewController {
    private let container = UIView()
    private let timeSetupButton = UIButton(type: .system)
    private let startButton = UIButton(type: .system)
    private var timeSetupButtonConstraints: [NSLayoutConstraint] = []
    private var startButtonConstraints: [NSLayoutConstraint] = []
    private var circularTimerView: CircularTimerView?
    private var totalTime: TimeInterval = 0 // totalTime을 private으로 선언

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(container)
        container.addSubview(timeSetupButton)
        container.addSubview(startButton)

        timeSetupButton.setTitle("Set Time", for: .normal)
        timeSetupButton.addTarget(self, action: #selector(showTimeSetupModal), for: .touchUpInside)

        startButton.setTitle("Start", for: .normal)
        startButton.addTarget(self, action: #selector(startTimer), for: .touchUpInside)

        container.translatesAutoresizingMaskIntoConstraints = false
        timeSetupButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        timeSetupButtonConstraints = [
            timeSetupButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            timeSetupButton.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -100)
        ]

        startButtonConstraints = [
            startButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            startButton.topAnchor.constraint(equalTo: timeSetupButton.bottomAnchor, constant: 50)
        ]

        NSLayoutConstraint.activate(timeSetupButtonConstraints + startButtonConstraints)
    }

    @objc private func showTimeSetupModal() {
        let timeSetupViewController = TimeSetupViewController(delegate: self)
        present(timeSetupViewController, animated: true, completion: nil)
    }

    @objc private func startTimer() {
        
            circularTimerView = CircularTimerView(frame: container.bounds, totalTime: totalTime)
            if let circularTimerView = circularTimerView {
                container.addSubview(circularTimerView)
                circularTimerView.startTimer(with: totalTime)
            
        }
    }

    public func setTotalTime(_ time: TimeInterval) {
        totalTime = time
    }
}

class TimeSetupViewController: UIViewController {
    private let datePicker = UIDatePicker()
    private let doneButton = UIButton(type: .system)
    private let container = UIView()

    private weak var delegate: ViewController?

    init(delegate: ViewController) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    private func setupUI() {
        view.addSubview(container)
        view.backgroundColor = .white

        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 1
        container.addSubview(datePicker)

        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(dismissModal), for: .touchUpInside)
        container.addSubview(doneButton)
    }

    private func setupConstraints() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -100),
            doneButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            doneButton.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 16)
        ])
    }

    @objc private func dismissModal() {
        delegate?.setTotalTime(datePicker.countDownDuration)
        dismiss(animated: true, completion: nil)
    }
}

class CircularTimerView: UIView {
    private var totalTime: TimeInterval
    private var timeRemaining: TimeInterval
    private var timer: Timer?

    init(frame: CGRect, totalTime: TimeInterval) {
        self.totalTime = totalTime
        self.timeRemaining = totalTime
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startTimer(with totalTime: TimeInterval) {
        self.totalTime = totalTime
        self.timeRemaining = totalTime
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 0.1
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.timer = nil
                
                // 타이머 종료 시 StudyEndViewController로 이동
                
            }
        }
        
    }
     
}
