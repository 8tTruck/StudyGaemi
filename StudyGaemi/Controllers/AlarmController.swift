//
//  AlarmController.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 6/3/24.
//

import UIKit

class AlarmController {
    
    @objc func tappedAlarmButton(_ navigationController: UINavigationController?) {
        let alarmSettingView = AlarmSettingView()
        guard let navigationController = navigationController else { return }
        navigationController.pushViewController(alarmSettingView, animated: true)
    }
}
