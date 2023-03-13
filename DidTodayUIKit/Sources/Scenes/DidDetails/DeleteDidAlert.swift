//
//  DeleteDidAlert.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/13.
//

import UIKit

protocol DeleteDidAlert{
    func delete()
    func cancel()
}

extension DeleteDidAlert {
    
    func alert() -> UIAlertController {
        let alert = UIAlertController(title: "이 기록을 삭제하시겠습니까?",
                                      message: "삭제하면 다시 되돌릴 수 없어요.",
                                      preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete Did", style: .destructive) { _ in
            delete()
        }
        let cancelAction = UIAlertAction(title: CustomText.cancel, style: .cancel)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        return alert
    }
}