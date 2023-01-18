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
    var urlReqeust: URLRequest? { get }
}

final class PrivacyPolicyViewModel: PrivacyPolicyViewModelProtocol {
    
    var privacyPolicyURL: URL? {
        let output: String
        if Locale.current.languageCode == "ko" {
            output = "https://hyper-stealer-69c.notion.site/5515e1e37eb848d8812b876b45b3a0d9"
        } else {
            output =  "https://hyper-stealer-69c.notion.site/Privacy-Policy-3ad36f3d669b4aa297a403b0f7a1ae28"
        }
        return URL(string: output) ?? nil
    }
    
    var urlReqeust: URLRequest? {
        guard let url = privacyPolicyURL else { return nil }
        return URLRequest(url: url)
    }
}
