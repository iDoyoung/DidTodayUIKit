//
//  ParentViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/01.
//

import UIKit
import os

class ParentUIViewController: UIViewController {
    final var logger = Logger()
    
    deinit {
        logger.debug("🗑 Deallocating instance of '\(type(of: self))'")
    }
}

class ParentUITableViewController: UITableViewController {
    final var logger = Logger()
    
    deinit {
        #if DEBUG
        logger.debug("🗑 Deallocating instance of '\(type(of: self))'")
        #endif
    }
}
