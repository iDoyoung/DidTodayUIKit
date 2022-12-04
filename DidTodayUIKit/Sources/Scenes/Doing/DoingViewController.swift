//
//  DoingViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/02.
//

import UIKit

class DoingViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: DoingViewModelProtocol?
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerShadowEffectView: UIView!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimerView()
    }
    
    static func create(with viewModel: DoingViewModelProtocol) -> DoingViewController {
        let viewControlelr = DoingViewController.instantiateViewController(storyboardName: "Doing")
        viewControlelr.viewModel = viewModel
        return viewControlelr
    }
    
    private func setupTimerView() {
        timerView.layer.masksToBounds = true
        timerView.cornerRadius = timerView.bounds.height / 2
        timerShadowEffectView.cornerRadius = timerShadowEffectView.bounds.height / 2
    }
}
