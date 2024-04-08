//
//  ParentViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/01.
//

import UIKit

class ParentUIViewController: UIViewController {
    deinit {
        #if DEBUG
        print("🗑 Deallocating instance of '\(type(of: self))'")
        #endif
    }
}

class ParentUITableViewController: UITableViewController {
    deinit {
        #if DEBUG
        print("Succeeded Down RC Of Table View Controller")
        #endif
    }
}
