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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWebView()
        loadURL()
    }

    private func setupWebView() {
        webView = WKWebView().then {
            $0.navigationDelegate = self
        }
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func loadURL() {
        if let url = URL(string: "https://www.notion.so/teamsparta/4e4824eafb0c4db1aee9d2cc1dc0bfcf") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension AnnouncementViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("탐색 시작")
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("탐색 완료")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("탐색 실패: \(error.localizedDescription)")
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.host == "www.notion.so" {
                decisionHandler(.allow)
                return
            }
        }
        decisionHandler(.cancel)
    }
}

