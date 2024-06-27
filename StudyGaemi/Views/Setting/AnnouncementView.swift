//
//  AnnouncementView.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/20/24.
//

import SnapKit
import Then
import UIKit
import WebKit

class AnnouncementView: UIView {
    
    let webView: WKWebView
    let activityIndicator: UIActivityIndicatorView
    
    override init(frame: CGRect) {
        webView = WKWebView().then {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        activityIndicator = UIActivityIndicatorView(style: .large).then {
            $0.hidesWhenStopped = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(webView)
        addSubview(activityIndicator)
    }
    
    private func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(0)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
