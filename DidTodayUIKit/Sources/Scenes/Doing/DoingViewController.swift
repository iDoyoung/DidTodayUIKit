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
        createDismissKeyboardTapGesuture()
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
            .sink(receiveValue: { [weak self] ouput in
                guard let ouput = ouput else { return }
                let color = UIColor.init(red: CGFloat(ouput.red),
                                         green: CGFloat(ouput.green),
                                         blue: CGFloat(ouput.blue),
                                         alpha: CGFloat(ouput.alpha))
                self?.colorPickerButton.tintColor = color
                self?.timerLabel.textColor = color
            })
            .store(in: &cancellableBag)
    }
    
    private func createDismissKeyboardTapGesuture() {
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
