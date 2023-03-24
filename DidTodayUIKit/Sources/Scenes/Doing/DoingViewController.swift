//
//  DoingViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/02.
//

import UIKit
import Combine

final class DoingViewController: ParentUIViewController, StoryboardInstantiable {
 
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
        guard let viewModel else { return }
        if viewModel.isLessThanTime.value {
            occurFeedback()
            timerLabel.animateToShake()
        } else {
            viewModel.showCreateDid()
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
        viewModel?.observeWillEnterForeground()
        viewModel?.observeDidEnterBackground()
        observeDayIsChanged()
        requestUserNotificationsAuthorization()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.startDoing()
        informationBoardLabel.startAnimation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        informationBoardLabel.stopAnimation()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        setupBackground()
        timerShadowEffectView.borderColor = .systemBackground
    }
    
    static func create(with viewModel: DoingViewModelProtocol) -> DoingViewController {
        let viewController = DoingViewController.instantiateViewController(storyboardName: "Doing")
        viewController.viewModel = viewModel
        return viewController
    }
    
    private func setupView() {
        setupBackground()
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
        informationBoardLabel.texts = [CustomText.firstTipInDoing, CustomText.secondTipInDoing]
        informationBoardLabel.font = .systemFont(ofSize: 18, weight: .bold)
    }
    
    private func setupBackground() {
        view.backgroundColor = UIColor.gradientEffect(colors: [.customBackground, .secondaryCustomBackground],
                                                      frame: view.bounds,
                                                      startPoint: CGPoint(x: 0.5, y: 0),
                                                      endPoint: CGPoint(x: 0.5, y: 1.3))
    }
    
    private func bindViewModel() {
        ///Bind With Timer Label
        viewModel?.timesOfTimer
            .receive(on: DispatchQueue.main)
            .assign(to: \.text, on: timerLabel)
            .store(in: &cancellableBag)
        ///Bind StartedTime
        viewModel?.startedTime
            .assign(to: \.text, on: startedTimeLabel)
            .store(in: &cancellableBag)
    }
    
    private func createDismissKeyboardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func requestUserNotificationsAuthorization() {
        AuthorizationManager.requestUserNotificationsAuthorization { result in
            switch result {
            case .success(let authorizationStatus):
                #if DEBUG
                print("Succeeded requesting user notifications authorization \(String(describing: authorizationStatus))")
                #endif
            case .failure(let error):
                #if DEBUG
                print("Failed requesting user notifications authorization \(String(describing: error))")
                #endif
            }
        }
    }
    
    private func observeDayIsChanged() {
        ///Notify day is changed
        NotificationCenter.default
            .publisher(for: Notification.Name.NSCalendarDayChanged)
            .sink { [weak self] _ in
                #if DEBUG
                print("Day is Changed")
                #endif
                self?.requestUserNotification(with: "day-is-changed")
            }
            .store(in: &cancellableBag)
    }
 
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension DoingViewController: TimerAlert {
    
    func cancelTimer() {
        viewModel?.cancelRecording()
        dismiss(animated: true)
    }
}

extension DoingViewController: DayIsChangedNotification {   }
