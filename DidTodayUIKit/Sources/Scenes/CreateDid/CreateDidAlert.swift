//
//  CreateDidAlert.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/16.
//

import UIKit

protocol CreateDidAlert {
    func completeToCreateDid()
    func discardToCreateDid()
}

extension CreateDidAlert {
    
    func completeToCreateDidAlert() -> UIAlertController {
        let alert = UIAlertController(title: CreateDidViewText.completeToCreateAlertTitle,
                                      message: CreateDidViewText.completeToCreateAlertMessage,
                                      preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: CreateDidViewText.cancelActionTitle, style: .cancel)
        let completeAction = UIAlertAction(title: CreateDidViewText.createActionTitle, style: .default) { _ in
            completeToCreateDid()
        }
        alert.addAction(cancelAction)
        alert.addAction(completeAction)
        return alert
    }
    
    func discardToCreateDidAlert() -> UIAlertController {
        let alert = UIAlertController(title: CreateDidViewText.discardToCreateDidAlertTitle,
                                      message: CreateDidViewText.discardToCreateDidAlertMessage,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: CreateDidViewText.cancelActionTitle, style: .cancel)
        let disCardAction = UIAlertAction(title: CreateDidViewText.discardActionTitle, style: .default) { _ in
            discardToCreateDid()
        }
        alert.addAction(cancelAction)
        alert.addAction(disCardAction)
        return alert
    }
    
    //TODO: Understanding Core Data Error
    func errorAlert() -> UIAlertController {
        let alert = UIAlertController(title: CreateDidViewText.errorAlertTitle,
                                      message: CreateDidViewText.errorMessage,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: CreateDidViewText.okActionTitle, style: .default)
        alert.addAction(okAction)
        return alert
    }
}
