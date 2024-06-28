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
    
    private var announcementView: AnnouncementView!

    override func loadView() {
        announcementView = AnnouncementView()
        view = announcementView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebView()
        loadURL()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor(named: "pointOrange")
    }

    private func setupWebView() {
        announcementView.webView.navigationDelegate = self
    }

    private func loadURL() {
        if let url = URL(string: "https://shard-chips-957.notion.site/4228b5c554d24f0faf7c8b5b1c9e0233?pvs=4") {
            let request = URLRequest(url: url)
            announcementView.webView.load(request)
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
        announcementView.activityIndicator.startAnimating()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("탐색 완료")
        announcementView.activityIndicator.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("탐색 실패: \(error.localizedDescription)")
        announcementView.activityIndicator.stopAnimating()
        showErrorAlert(message: "페이지를 로드할 수 없습니다: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
    }

    extension AnnouncementViewController: WKUIDelegate {
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            return nil
        }
    }
