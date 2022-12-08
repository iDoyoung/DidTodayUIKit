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
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var colorPickerButton: UIButton!
    @IBOutlet weak var informationBoardLabel: BoardLabel!
    
    @IBAction func done(_ sender: UIButton) {
        present(doneTimerAlert(), animated: true)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
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
        setupTimerView()
        setupInformationLabel()
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
    
    private func setupTimerView() {
        timerView.layer.masksToBounds = true
        timerView.cornerRadius = timerView.bounds.height / 2
        timerShadowEffectView.cornerRadius = timerShadowEffectView.bounds.height / 2
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
        ///Bind With Done Button
        viewModel?.doneIsEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in }
            .store(in: &cancellableBag)
        ///Bind Pie Color
        viewModel?.colorOfPie
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] output in
                guard let output = output else { return }
                let color = UIColor.init(red: CGFloat(output.red),
                                         green: CGFloat(output.green),
                                         blue: CGFloat(output.blue),
                                         alpha: CGFloat(output.alpha))
                self?.colorPickerButton.tintColor = color
                self?.timerLabel.textColor = color
            })
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
        
    }
}

extension DoingViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        guard let colorComponents = color.cgColor.components else { return }
        viewModel?.setColorOfPie(red: Float(colorComponents[0]), green: Float(colorComponents[1]), blue: Float(colorComponents[2]))
    }
}

extension DoingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text , text != "" else { return }
        viewModel?.setTitle(text)
    }
}
