//
//  CircularTimerVIrew.swift
//  StudyGaemi
//
//  Created by 김준철 on 6/14/24.
//
import UIKit
import Foundation


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
}
protocol CircularTimerViewDelegate: AnyObject {
    func didFinishTimer()
    func showModal()
}

struct ProgressColors {
    var trackLayerStrokeColor: CGColor = UIColor.lightGray.cgColor
    var barLayerStrokeColor: CGColor = UIColor.orange.cgColor
    var circleColor: UIColor = .orange // 작은 동그라미 색상
    var cutecircleColor: UIColor = .white
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
    
    private lazy var circularPath: UIBezierPath = {
        return UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                            radius: 100,
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
                                          width: 100,
                                          height: 50))
        label.textAlignment = .center
        label.textColor = .label
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showModal))
        label.addGestureRecognizer(tapGesture)
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
    
   
    
    private lazy var pauseButton: UIButton = {
        let button = UIButton(frame: CGRect(x: frame.midX - 50, y: frame.midY + 100, width: 100, height: 50))
        button.setTitle("Pause", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(pauseOrResumeTimer), for: .touchUpInside)
        return button
    }()
    
    init(progressColors: ProgressColors, duration: TimeInterval, startDate: Date) {
        self.progressColors = progressColors
        self.leftSeconds = duration
        self.startDate = startDate
        super.init(frame: .zero)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //자신의 뷰들을 레이아웃 잡힌 시점
    override func layoutSubviews() {
        super.layoutSubviews()
        addSubviews()
        setupViews()
        startTimer()
        
    }
    private func addSubviews() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(barLayer)
        layer.addSublayer(movingCircleLayer)
        
        addSubview(timeLabel)
        addSubview(pauseButton)
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.centerXAnchor.constraint(equalTo: self.centerXAnchor) .isActive = true
        pauseButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -50) .isActive = true
    }
    
    private func setupViews() {
            timeLabel.frame = CGRect(x: bounds.midX - 50, y: bounds.midY - 25, width: 100, height: 50)
            animateToBarLayer()
        }
    
    func startTimer() {
        guard !isRunning else { return }
        
        endSeconds = Date().addingTimeInterval(leftSeconds)
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil,
                                     repeats: true)
        animateToBarLayer()
        isRunning = true
    }
    
    func pauseTimer() {
        guard isRunning else { return }
        
        timer?.invalidate()
        pausedTime = leftSeconds
        pauseLayer(layer: barLayer)
        pauseLayer(layer: movingCircleLayer)
        timeLabel.text = leftSeconds.time

        isRunning = false
    }
    
    func resumeTimer() {
        guard let pausedTime = pausedTime else { return }
        
        leftSeconds = pausedTime
        startTimer()
        resumeLayer(layer: barLayer)
        resumeLayer(layer: movingCircleLayer)
        timeLabel.text = leftSeconds.time
    }
    
    func resetTimer() {
        timer?.invalidate()
        leftSeconds = 0
        isRunning = false
        timeLabel.text = "00:00"
        delegate?.didFinishTimer()
    }
    
    private func animateToBarLayer() {
            let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
            strokeAnimation.fromValue = 0
            strokeAnimation.toValue = 1
            strokeAnimation.duration = leftSeconds
            strokeAnimation.isRemovedOnCompletion = false
            strokeAnimation.fillMode = .forwards
            
            barLayer.add(strokeAnimation, forKey: nil)
            
            let pathAnimation = CAKeyframeAnimation(keyPath: "position")
            pathAnimation.path = circularPath.cgPath
            pathAnimation.duration = leftSeconds
            pathAnimation.calculationMode = .paced
            pathAnimation.repeatCount = 1
            pathAnimation.isRemovedOnCompletion = false
            pathAnimation.fillMode = .forwards
            
            movingCircleLayer.add(pathAnimation, forKey: nil)
            
            timer = Timer.scheduledTimer(timeInterval: 0.1,
                                         target: self,
                                         selector: #selector(updateTime),
                                         userInfo: nil,
                                         repeats: true)
        }
        
    @objc private func updateTime() {
            if leftSeconds > 0 {
                leftSeconds = endSeconds!.timeIntervalSinceNow
                timeLabel.text = leftSeconds.time
            } else {
                timer?.invalidate()
                timer = nil
                timeLabel.text = "00:00"
                delegate?.didFinishTimer()
            }
        }
        
        deinit {
            timer?.invalidate()
        }

    
    
    @objc private func showModal() {
        delegate?.showModal()
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


