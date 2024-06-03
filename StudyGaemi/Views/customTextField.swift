//
//  customTextField.swift
//  StudyGaemi
//
//  Created by t2023-m0056 on 5/31/24.
//

import UIKit

class customTextField: UITextField {

    init(x: Int = 0, y: Int = 0, width: Int = 342, height: Int = 60, text: String = "정답을 적어보개미") {
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        
        self.placeholder = text
        self.tintColor = UIColor.systemBackground
        self.textColor = UIColor(named: "pointDarkgray") ?? UIColor.gray
        self.layer.borderColor = UIColor(named: "navigationBarLine")?.cgColor ?? UIColor.gray.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 10
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
