//
//  CreateDidViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/18.
//

import UIKit
import Combine

final class CreateDidViewController: UIViewController, StoryboardInstantiable {
    var viewModel: (CreateDidViewModelInput & CreateDidViewModelOutput)?
    private var cancellableBag = Set<AnyCancellable>()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pieView: PieView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startedTimePicker: UIDatePicker!
    @IBOutlet weak var endedTimePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func showColorPicker(_ sender: UIButton) {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true)
    }
    
    @IBAction func setStartedTime(_ sender: UIDatePicker) {
        endedTimePicker.minimumDate = sender.date
        viewModel?.startedTime.send(sender.date)
    }
    
    @IBAction func setEndedTime(_ sender: UIDatePicker) {
        startedTimePicker.maximumDate = sender.date
        viewModel?.endedTime.send(sender.date)
    }
    
    @IBAction func addDid(_ sender: UIButton) {
        viewModel?.createDid()
    }
    
    static func create(with viewModel: CreateDidViewModelProtocol) -> CreateDidViewController {
        let viewController = CreateDidViewController.instantiateViewController(storyboardName: StoryboardName.createDid)
        viewController.viewModel = viewModel
        return viewController
    }
    
    //MARK: - Life cycle
    static func create(with viewModel: CreateDidViewModel) -> CreateDidViewController {
        let viewController = CreateDidViewController.instantiateViewController(storyboardName: "CreateDid")
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIObjects()
        bindViewModel()
    }
    
    //MARK: - Setup
    private func setupUIObjects() {
        titleTextField.delegate = self
        scrollView.keyboardDismissMode = .onDrag
        setupDatePicker()
    }
   
    private func setupDatePicker() {
        endedTimePicker.minimumDate = startedTimePicker.date
        endedTimePicker.maximumDate = Date()
        startedTimePicker.maximumDate = endedTimePicker.date
    }
    
    private func bindViewModel() {
        viewModel?.degreeOfStartedTime
            .sink { [weak self] output in
                guard let output = output else { return }
                self?.pieView.start = output
            }
            .store(in: &cancellableBag)
        viewModel?.degreeOfEndedTime
            .sink { [weak self] output in
                guard let output = output else { return }
                self?.pieView.end = output
            }
            .store(in: &cancellableBag)
        viewModel?.colorOfPie
            .sink { [weak self] output in
                self?.pieView.color = output
            }
            .store(in: &cancellableBag)
    }
}

//MARK: - Alert Action
extension CreateDidViewController {
    //TODO: - Add Message When Compleate UI
    func successAddingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Succeeded adding",
                                      message: "",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(confirmAction)
        return alert
    }
    
    func failedAddingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Failed adding",
                                      message: "",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(confirmAction)
        return alert
    }
    
    func errorAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Error",
                                      message: "",
                                      preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(confirmAction)
        return alert
    }
}

extension CreateDidViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        viewModel?.setColorOfPie(color)
    }
}

extension CreateDidViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scrollToBottom()
    }
}

extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}
