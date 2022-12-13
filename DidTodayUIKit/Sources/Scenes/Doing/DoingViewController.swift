//
//  DoingViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/12/02.
//

import UIKit
import Combine

final class DoingViewController: UIViewController, StoryboardInstantiable {
    
    enum EnableToComplete {
        case titleIsEmpty
        case lessThanOneMinutes
        case enable
    }
    
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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var informationBoardLabel: BoardLabel!
    @IBOutlet weak var startedTimeLabel: CircularLabel!
   
    @IBAction func touchDownDoneButton(_ sender: UIButton) {
        configureFeedBackGenerator()
    }
    
    @IBAction func done(_ sender: UIButton) {
        switch checkEnableDoneButtonAction() {
        case .enable:
            present(doneTimerAlert(), animated: true)
        case .titleIsEmpty:
            occurFeedback()
            titleTextField.animateToShake()
        case .lessThanOneMinutes:
            occurFeedback()
            timerLabel.animateToShake()
        case .none:
            #if DEBUG
            print("View Model Is Nil")
            #endif
            break
        }
    }
    
    @IBAction func cancelDone(_ sender: UIButton) {
        feedbackGenerator = nil
    }
    
    @IBAction func cancelDoing(_ sender: UIButton) {
        present(cancelTimerAlert(), animated: true)
    }
    
    @IBAction func setPieColor(_ sender: UIButton) {
        let colorPicker = UIColorPickerViewController()
        colorPicker.supportsAlpha = false
        colorPicker.delegate = self
        present(colorPicker, animated: true)
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
        ///Bind Pie Color
        viewModel?.colorOfPie
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] output in
                self?.colorPickerButton.tintColor = output
                self?.timerLabel.textColor = output
            })
            .store(in: &cancellableBag)
        ///Bind StartedTime
        viewModel?.startedTime
            .sink { [weak self] output in
                self?.startedTimeLabel.text = output
            }
            .store(in: &cancellableBag)
        ///Bind Result of Core Data
        viewModel?.isSucceededCreated
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                if result {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellableBag)
        viewModel?.error
            .sink { error in
                if error != nil {
                    #if DEBUG
                    print("Core Data Error: \(String(describing: error))")
                    #endif
                }
            }
            .store(in: &cancellableBag)
    }
    
    private func checkEnableDoneButtonAction() -> EnableToComplete? {
        guard let viewModel = viewModel else { return nil }
        if viewModel.titleIsEmpty.value {
            return .titleIsEmpty
        } else if viewModel.isLessThanTime.value {
            return .lessThanOneMinutes
        } else {
            return .enable
        }
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
        viewModel?.createDid()
    }
}

extension DoingViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        viewModel?.setColorOfPie(color)
    }
}

extension DoingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if !text.trimmingCharacters(in: .whitespaces).isEmpty {
            viewModel?.setTitle(text)
        } else {
            textField.text = ""
        }
    }
}
