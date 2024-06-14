//
//  AudioController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/11/24.
//

import AVFoundation
import Foundation
import MediaPlayer

class AudioController {
    
    static let shared = AudioController()
    
    var audioPlayer: AVAudioPlayer?
    var soundName: String?
    
    private init() { }
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("오디오세션 추가 실패: \(error)")
        }
    }
    
    func playAlarmSound() {
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else { 
            print("사운드 파일이 존재 하지 않음")
            return
        }
        
        self.setSystemVolume(to: 1.0)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.setVolume(1.0, fadeDuration: 0.0)
            audioPlayer?.play()
            print("오디오플레이어 볼륨 설정 값: \(String(describing: audioPlayer?.volume))")
        } catch {
            print("사운드 파일 재생 실패 에러: \(error)")
        }
    }
    
    func stopAlarmSound() {
        audioPlayer?.stop()
        audioPlayer = nil
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("오디오 세션 비활설화 실패 에러: \(error)")
        }
    }
    
    private func setSystemVolume(to volume: Float) {
        let volumeView = MPVolumeView(frame: .zero)
        if let volumeSlider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            volumeSlider.value = volume
            print("시스템 볼륨 설정 값: \(volume)")
        } else {
            print("볼륨 슬라이드를 찾을 수 없는 에러")
        }
    }
    
    func scheduleAlarm(at date: Date, sound: String) {
        let timeInterval = date.timeIntervalSinceNow
        if timeInterval > 0 {
            Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] timer in
                self?.playAlarmSound()
            }
        } else {
            print("같은 알람이 이전에 설정됨.")
        }
    }
}
