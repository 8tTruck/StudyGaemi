//
//  AnnouncementViewController.swift
//  StudyGaemi
//
//  Created by 강태영 on 6/9/24.
//

import SnapKit
import Then
import UIKit
import WebKit

class AnnouncementViewController: UIViewController {

    var webView: WKWebView!
    var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        setupActivityIndicator()
        setupBackButton()
        loadURL()
    }

    private func setupWebView() {
        webView = WKWebView().then {
            $0.navigationDelegate = self
        }
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20) // 위에서 20포인트 아래로 내림
            make.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large).then {
            $0.hidesWhenStopped = true
        }
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        backButton.tintColor = .black
        backButton.setTitleColor(.black, for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
    }

    @objc private func goBack() {
        if webView.canGoBack {
            webView.goBack()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    private func loadURL() {
        if let url = URL(string: "https://shard-chips-957.notion.site/4228b5c554d24f0faf7c8b5b1c9e0233?pvs=4") {
            let request = URLRequest(url: url)
            webView.load(request)
        } else {
            showErrorAlert(message: "잘못된 URL입니다.")
        }
    }

    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension AnnouncementViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("탐색 시작")
        activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("탐색 완료")
        activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("탐색 실패: \(error.localizedDescription)")
        activityIndicator.stopAnimating()
        showErrorAlert(message: "페이지를 로드할 수 없습니다: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.host == "shard-chips-957.notion.site" {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
}
