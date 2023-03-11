//
//  DidDetailsViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/11.
//

import UIKit

class DidDetailsViewController: UIViewController {

    let didDetailView = DidDetailsView()
    
    override func loadView() {
        view = didDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
