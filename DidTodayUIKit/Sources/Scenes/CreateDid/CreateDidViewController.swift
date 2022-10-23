//
//  CreateDidViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/18.
//

import UIKit
import Combine

final class CreateDidViewController: UIViewController {
    var viewModel: (CreateDidViewModelInput & CreateDidViewModelOutput)?
    var cancellableBag = Set<AnyCancellable>()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pieView: PieView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startedTimePicker: UIDatePicker!
    @IBOutlet weak var endedTimePicker: UIDatePicker!
    
    @IBAction func showColorPicker(_ sender: UIButton) {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true)
    }
    @IBAction func setStartedTime(_ sender: UIDatePicker) {
        endedTimePicker.minimumDate = sender.date
        viewModel?.startedTime = sender.date
    }
    @IBAction func setEndedTime(_ sender: UIDatePicker) {
        startedTimePicker.maximumDate = sender.date
        viewModel?.endedTime = sender.date
    }
//    @IBAction func addDid(_ sender: UIBarButtonItem) {
//        viewModel?.createDid { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success:
//                    self.present(self.successAddingAlert(), animated: true)
//                case .failure(let error):
//                    switch error {
//                    case .coreDataError:
//                        self.present(self.errorAlert(), animated: true)
//                    case .startedTimeError:
//                        self.present(self.failedAddingAlert(), animated: true)
//                    }
//                }
//            }
//        }
//    }
    //MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel = CreateDidViewModel(didCoreDataStorage: DidCoreDataStorage.shared)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = CreateDidViewModel(didCoreDataStorage: DidCoreDataStorage.shared)
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
        setupTextFieldAction()
        setupDatePicker()
    }
    private func setupTextFieldAction() {
        titleTextField.addAction(textFieldAction(), for: .editingChanged)
    }
    private func setupDatePicker() {
        endedTimePicker.minimumDate = startedTimePicker.date
        endedTimePicker.maximumDate = Date()
        startedTimePicker.maximumDate = endedTimePicker.date
    }
    private func textFieldAction() -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else {
                #if DEBUG
                print("\(String(describing: self)) IS NIL")
                #endif
                return
            }
            self.viewModel?.title = self.titleTextField.text
        }
    }
    private func bindViewModel() {
        viewModel?.titlePublisher
            .sink { [weak self] title in
//                if let title = title,
//                   title.trimmingCharacters(in: .whitespaces).isEmpty == false {
//                    self?.addButtonItem.isEnabled = true
//                } else {
//                    self?.addButtonItem.isEnabled = false
//                }
            }
            .store(in: &cancellableBag)
        viewModel?.startedTimePublished
            .compactMap {
                $0?.timesCalculateToMinutes()
            }
            .map {
                Double($0) * 0.25
            }
            .sink { [weak self] time in
                self?.pieView.start = time
                #if DEBUG
                print("SET STARTED TIME \(time)")
                #endif
            }
            .store(in: &cancellableBag)
        viewModel?.endedTimePublished
            .compactMap {
                $0?.timesCalculateToMinutes()
            }
            .map {
                Double($0) * 0.25
            }
            .sink { [weak self] time in
                self?.pieView.end = time
                #if DEBUG
                print("SET ENDED TIME: \(time)")
                #endif
            }
            .store(in: &cancellableBag)
        viewModel?.colorPublished
            .compactMap { $0 }
            .sink { [weak self] color in
                self?.pieView.color = color
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
            self?.dismiss(animated: true)
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
        viewModel?.color = color
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
