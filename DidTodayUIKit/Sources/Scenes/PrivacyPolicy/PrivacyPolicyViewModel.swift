//
//  PrivacyPolicyViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/17.
//

import Foundation

protocol PrivacyPolicyViewModelProtocol: PrivacyPolicyViewModelOutput { }

protocol PrivacyPolicyViewModelInput { }

protocol PrivacyPolicyViewModelOutput {
    var urlRequest: URLRequest? { get }
}

final class PrivacyPolicyViewModel: PrivacyPolicyViewModelProtocol {
    
    var privacyPolicyURL: URL? {
        let output: String
        if Locale.current.languageCode == "ko" {
            output = "https://hyper-stealer-69c.notion.site/44258efae17b4acb996c1d2744b20b3a"
        } else {
            output =  "https://hyper-stealer-69c.notion.site/Privacy-Policy-3ad36f3d669b4aa297a403b0f7a1ae28"
        }
        return URL(string: output) ?? nil
    }
    
    var urlRequest: URLRequest? {
        guard let url = privacyPolicyURL else { return nil }
        return URLRequest(url: url)
    }
    
    deinit {
        #if DEBUG
        print("Deinit Privacy Policy View Model")
        #endif
    }
}
