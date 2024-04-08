//
//  MainAlert.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/02/27.
//

import UIKit

protocol MainAlert {
    func okay()
}

extension MainAlert {
    
    func recordedBeforeAlert() -> UIAlertController {
        let alert = UIAlertController(title: CustomText.recordedBeforeAlertTitle,
                                      message: CustomText.recordedBeforeAlertMessage,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: CustomText.okay, style: .default) {_ in
            okay()
        }
        alert.addAction(action)
        return alert
    }
}
