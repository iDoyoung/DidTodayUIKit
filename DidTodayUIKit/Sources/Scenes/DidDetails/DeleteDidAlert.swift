//
//  DeleteDidAlert.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/13.
//

import UIKit

protocol DeleteDidAlert{
    ///Delete action handler of alert
    func deleteHandler()
}

extension DeleteDidAlert {
    
    func deleteAlert() -> UIAlertController {
        let alert = UIAlertController(title: CustomText.deleteAlertTitle,
                                      message: CustomText.deleteAlertMessage,
                                      preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: CustomText.deleteDid, style: .destructive) { _ in
            deleteHandler()
        }
        let cancelAction = UIAlertAction(title: CustomText.cancel, style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        return alert
    }
}
