//
//  CircularTimerVIrew.swift
//  StudyGaemi
//
//  Created by 김준철 on 6/14/24.

// 바에니메이션 수정
// starttimer 너무 많이 호출풀 된다.

import UIKit
import Foundation

protocol TimeResulteDelegate: AnyObject {
    func showTimerResult(goalTime: TimeInterval, elapsedTime: TimeInterval)
}

protocol CircularTimerViewDelegate: AnyObject {
    func didFinishTimer()
    func showTimerResult(goalTime: TimeInterval, elapsedTime: TimeInterval)
}

struct ProgressColors {
    var trackLayerStrokeColor: CGColor = UIColor(hex: "#FFE3D8").cgColor
    var barLayerStrokeColor: CGColor = UIColor.orange.cgColor
    var circleColor: UIColor = .orange
    var cutecircleColor: UIColor = .white // 작은 동그라미 색상
}

class CircularTimerView: UIView {
    
    private let progressColors: ProgressColors
    private let startDate: Date
    private var leftSeconds: TimeInterval
    private var timer: Timer?
    private var endSeconds: Date?
    private var isRunning = false
    private var pausedTime: TimeInterval?
    weak var delegate: CircularTimerViewDelegate?
    
    
    private let fixedRadius: CGFloat = 150 //반지름 절대값
    private let fixedCenter: CGPoint = CGPoint(x: 196.5, y: 426) // bounds가 잡히기 전에 0,0으로 잡히는거 방지(15기준)
    
    private lazy var circularPath: UIBezierPath = {
        return UIBezierPath(arcCenter: fixedCenter,
                            radius: fixedRadius,
                            startAngle: CGFloat.pi / 2 ,
                            endAngle: CGFloat.pi / 2 + 2 * .pi,
                            clockwise: true)
    }()
    // 절대값 숫자로 위치 잡아줘야합니다.
    // 제약 조건을 잘 잡아줘합니다.
    private lazy var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressColors.trackLayerStrokeColor
        layer.lineWidth = 30
        return layer
    }()

    private lazy var barLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = circularPath.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressColors.barLayerStrokeColor
        layer.lineWidth = 30
        layer.strokeEnd = 0
        return layer
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: frame.midX - 50,
                                          y: frame.midY - 25,
                                          width: 178,
                                          height: 28))
        label.text = "00:00"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24) // 굵은 글씨체로 변경
        label.textColor = UIColor(hex: "#F68657") // 텍스트 색상 설정
        label.isUserInteractionEnabled = true
        
        return label
    }()
    
    private lazy var movingCircleLayer: CAShapeLayer = {
            let circleRadius: CGFloat = 20
            let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0),
                                    radius: circleRadius,
                                    startAngle: 0,
                                    endAngle: 2 * .pi,
                                    clockwise: true)
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = progressColors.circleColor.cgColor
            return layer
    }()
    
    private lazy var movingSmallCircleLayer: CAShapeLayer = {
            let circleRadius: CGFloat = 10
            let path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0),
                                    radius: circleRadius,
                                    startAngle: 0,
                                    endAngle: 2 * .pi,
                                    clockwise: true)
            let layer = CAShapeLayer()
            layer.path = path.cgPath
            layer.fillColor = progressColors.cutecircleColor.cgColor
            return layer
    }()
    
   
    
    private lazy var pauseButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(pauseOrResumeTimer), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 224, height: 70)
        
        return button
    }()
    
    private lazy var stopButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        
        button.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
        return button
    }()
    
    init(progressColors: ProgressColors, duration: TimeInterval, startDate: Date) {
        self.progressColors = progressColors
        self.leftSeconds = duration
        self.startDate = startDate
        super.init(frame: .zero)
        startTimer()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //자신의 뷰들을 레이아웃 잡힌 시점 여기부분 수정해야함
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setupViews()
        
    }
    private func addSubviews() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(barLayer)
        layer.addSublayer(movingCircleLayer)
        layer.addSublayer(movingSmallCircleLayer)
        
        
        addSubview(timeLabel)
        addSubview(pauseButton)
        addSubview(stopButton)
       
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 50) .isActive = true
        pauseButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -100) .isActive = true
        pauseButton.widthAnchor.constraint(equalToConstant: 224).isActive = true
        pauseButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.trailingAnchor.constraint(equalTo: pauseButton.leadingAnchor, constant: -20).isActive = true
        stopButton.centerYAnchor.constraint(equalTo: pauseButton.centerYAnchor).isActive = true
        stopButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        stopButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
      
    }
    
    private func setupViews() {
            timeLabel.frame = CGRect(x: bounds.midX - 50, y: bounds.midY - 25, width: 100, height: 50)
            animateToBarLayer()
        }
    
    private func animateToBarLayer() {
            let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimation.fromValue = 0
            strokeAnimation.toValue = 1 //애니메이션 얼만큼 왔는지 저장하고 그 애니메이션 위치 저장 숫자에서 출발하도록
            strokeAnimation.duration = leftSeconds
            strokeAnimation.isRemovedOnCompletion = false
            strokeAnimation.fillMode = .forwards
            //strokeAnimation.repeatCount = .infinity
            
        
            barLayer.add(strokeAnimation, forKey: nil)
            
            let pathAnimation = CAKeyframeAnimation(keyPath: "position")
            pathAnimation.path = circularPath.cgPath
            pathAnimation.duration = leftSeconds
            pathAnimation.calculationMode = .paced
            pathAnimation.repeatCount = .infinity
            pathAnimation.isRemovedOnCompletion = false
            pathAnimation.fillMode = .forwards
            
            movingCircleLayer.add(pathAnimation, forKey: nil)
            movingSmallCircleLayer.add(pathAnimation, forKey: nil)
            
        }
    
    @objc func stopButtonTapped(){
        print("멈췄음")
        pauseTimer()
        timer?.invalidate()
        timer = nil
        
        //목표시간
        let goalTime = leftSeconds
        //남은 시간
        let remainingTime = endSeconds?.timeIntervalSinceNow ?? 0
        // 실제로 타이머가 돌아간 시간
        let elapsedTime = goalTime - remainingTime
        
        delegate?.showTimerResult(goalTime: remainingTime, elapsedTime: elapsedTime)
        
        resetTimer()
    }
    
    private func resetLayer(layer: CALayer) {
        layer.speed = 0.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        //layer.strokeEnd = 0.0 // reset strokeEnd for barLayer
    }
    
    func startTimer() {
        guard !isRunning else { return }
        
        endSeconds = Date().addingTimeInterval(leftSeconds)
        
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
        
        isRunning = true
    }
    
    func pauseTimer() {
        guard isRunning else { return }
        
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
        
        pausedTime = endSeconds?.timeIntervalSinceNow
        pauseLayer(layer: barLayer)
        pauseLayer(layer: movingCircleLayer)
        pauseLayer(layer: movingSmallCircleLayer)
        if let pausedTime = pausedTime {
            leftSeconds = pausedTime
            timeLabel.text = leftSeconds.time
        }
        isRunning = false
    }

    
    func resumeTimer() {
        guard pausedTime != nil else { return }
        
        endSeconds = Date().addingTimeInterval(leftSeconds)
        startTimer()
        resumeLayer(layer: barLayer)
        resumeLayer(layer: movingCircleLayer)
        resumeLayer(layer: movingSmallCircleLayer)
        timeLabel.text = leftSeconds.time
    }
    
    func resetTimer() {
        timer?.invalidate()
        leftSeconds = 0
        isRunning = false
        timeLabel.text = "00:00"
        delegate?.didFinishTimer()
    }
     
    
        
    @objc private func updateTime() {
        if let endSeconds = endSeconds, leftSeconds > 0 {
            leftSeconds = endSeconds.timeIntervalSinceNow
            timeLabel.text = leftSeconds.time
        } else {
            timer?.invalidate()
            timer = nil
            timeLabel.text = "00:00"
            delegate?.didFinishTimer()
        }
        /*deinit {
            timer?.invalidate()
        }*/
    }

    @objc private func pauseOrResumeTimer() {
        if isRunning {
            pauseTimer()
            pauseButton.setTitle("Resume", for: .normal)
        } else {
            resumeTimer()
            pauseButton.setTitle("Pause", for: .normal)
        }
    }
   
   

    private func pauseLayer(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    private func resumeLayer(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
}


extension Int {
    var degreesToRadians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
extension TimeInterval {
    /// %02d: 빈자리를 0으로 채우고, 2자리 정수로 표현
    var time: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
        
        
    }
    
    var formattedTime: String {
            let hours = Int(self) / 3600
            let minutes = Int(self) / 60 % 60
            let seconds = Int(self) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
}
