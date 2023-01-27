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
        let alert = UIAlertController(title: CustomText.completeToCreateTitle,
                                      message: CustomText.completeToCreateMessage,
                                      preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: CustomText.cancel, style: .cancel)
        let completeAction = UIAlertAction(title: CustomText.create, style: .default) { _ in
            completeToCreateDid()
        }
        alert.addAction(cancelAction)
        alert.addAction(completeAction)
        return alert
    }
    
    func discardToCreateDidAlert() -> UIAlertController {
        let alert = UIAlertController(title: CustomText.discardToCreateDidTitle,
                                      message: CustomText.discardToCreateDidMessage,
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: CustomText.cancel, style: .cancel)
        let disCardAction = UIAlertAction(title: CustomText.discard, style: .default) { _ in
            discardToCreateDid()
        }
        alert.addAction(cancelAction)
        alert.addAction(disCardAction)
        return alert
    }
    
    //TODO: Understanding Core Data Error
    func errorAlert() -> UIAlertController {
        let alert = UIAlertController(title: CustomText.errorAlertOfCreateTitle,
                                      message: CustomText.errorMessageOfCreateDid,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: CustomText.okay, style: .default)
        alert.addAction(okAction)
        return alert
    }
}
