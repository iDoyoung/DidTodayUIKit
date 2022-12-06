//
//  DoingViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/02.
//

import UIKit
import Combine

final class DoingViewController: UIViewController, StoryboardInstantiable {
    
    var viewModel: DoingViewModelProtocol?
    private var cancellableBag = Set<AnyCancellable>()
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerShadowEffectView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBAction func done(_ sender: UIButton) {
        present(doneTimerAlert(), animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        present(cancelTimerAlert(), animated: true)
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimerView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.startDoing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.stopDoing()
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
    
    private func bindViewModel() {
        viewModel?.timesOfTimer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                self?.timerLabel.text = output
            }
            .store(in: &cancellableBag)
    }
}

extension DoingViewController: TimerAlert {
    
    func cancelTimer() {
        dismiss(animated: true)
    }
    
    func doneTimer() {
        
    }
}
