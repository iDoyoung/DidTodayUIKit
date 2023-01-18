//
//  PrivacyPolicyViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/16.
//

import UIKit
import WebKit

final class PrivacyPolicyViewController: ParentUIViewController {

    var viewModel: PrivacyPolicyViewModelProtocol?
    
    var webView: WKWebView!
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return activityIndicator
    }()
    
    //MARK: - Life Cycle
    static func create(with viewModel: PrivacyPolicyViewModelProtocol) -> PrivacyPolicyViewController {
        let viewController = PrivacyPolicyViewController()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(activityIndicator)
        loadWebContents()
    }
    
    func loadWebContents() {
        guard let urlRequest = viewModel?.urlReqeust else { return }
        webView.load(urlRequest)
    }
    
    private func setupLayoutConstraint() {
    }
}

extension PrivacyPolicyViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}
