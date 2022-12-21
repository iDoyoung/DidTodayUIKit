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
    
    private var feedbackGenerator: UIFeedbackGenerator?
    
    private func configureFeedBackGenerator() {
        feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    private func occurFeedback() {
        (feedbackGenerator as? UINotificationFeedbackGenerator)?.notificationOccurred(.error)
        feedbackGenerator = nil
    }
    
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerShadowEffectView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var informationBoardLabel: BoardLabel!
    @IBOutlet weak var startedTimeLabel: CircularLabel!
   
    @IBAction func touchDownDoneButton(_ sender: UIButton) {
        configureFeedBackGenerator()
    }
    
    @IBAction func done(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        if viewModel.isLessThanTime.value {
            occurFeedback()
            timerLabel.animateToShake()
        } else {
            present(doneTimerAlert(), animated: true)
        }
    }
    
    @IBAction func cancelDone(_ sender: UIButton) {
        feedbackGenerator = nil
    }
    
    @IBAction func cancelDoing(_ sender: UIButton) {
        present(cancelTimerAlert(), animated: true)
    }
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        createDismissKeyboardTapGesture()
        setupView()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.startDoing()
        informationBoardLabel.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.stopDoing()
        informationBoardLabel.stopAnimation()
    }
    
    static func create(with viewModel: DoingViewModelProtocol) -> DoingViewController {
        let viewController = DoingViewController.instantiateViewController(storyboardName: "Doing")
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.gradientEffect(colors: [.customBackground, .secondaryCustomBackground],
                                                      frame: view.bounds,
                                                      stratPoint: CGPoint(x: 0.5, y: 0),
                                                      endPoint: CGPoint(x: 0.5, y: 1.3))
        setupTimerView()
        setupTimerLabel()
        setupInformationLabel()
    }
    
    private func setupTimerView() {
        timerView.layer.masksToBounds = true
        timerView.cornerRadius = timerView.bounds.height / 2
        timerShadowEffectView.cornerRadius = timerShadowEffectView.bounds.height / 2
    }
    
    private func setupTimerLabel() {
        timerLabel.font = .monospacedDigitSystemFont(ofSize: 90, weight: .regular)
    }
    
    private func setupInformationLabel() {
        informationBoardLabel.texts = ["앱을 닫을 경우 앱이 중지됩니다.", "1분후부터 저장 가능합니다"]
        informationBoardLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private func bindViewModel() {
        ///Bind With Timer Label
        viewModel?.timesOfTimer
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in self?.timerLabel.text = output }
            .store(in: &cancellableBag)
        ///Bind StartedTime
        viewModel?.startedTime
            .sink { [weak self] output in
                self?.startedTimeLabel.text = output
            }
            .store(in: &cancellableBag)
    }
    
    private func createDismissKeyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
 
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension DoingViewController: TimerAlert {
    
    func cancelTimer() {
        dismiss(animated: true)
    }
    
    func doneTimer() {
        viewModel?.showCreateDid()
    }
}
