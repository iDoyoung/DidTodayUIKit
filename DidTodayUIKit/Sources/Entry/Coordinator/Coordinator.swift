//
//  Coordinator.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/20.
//

import UIKit

protocol Coordinator {
    var children: [Coordinator] { get set }
    
    func start()
}
