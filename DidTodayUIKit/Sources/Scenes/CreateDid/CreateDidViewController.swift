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
    var cancellable: AnyCancellable?
    
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBAction func showColorPicker(_ sender: UIButton) {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        present(colorPickerViewController, animated: true)
    }
    @IBAction func setStartedTime(_ sender: UIDatePicker) {
    }
    @IBAction func setEndedTime(_ sender: UIDatePicker) {
    }
    @IBAction func addDid(_ sender: UIBarButtonItem) {
    }
    @IBAction func cancelAddDid(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    //MARK: - Life cycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        viewModel = CreateDidViewModel()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        viewModel = CreateDidViewModel()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFieldAction()
        bindViewModel()
    }
    
    //MARK: - Setup
    private func setupTextFieldAction() {
        titleTextField.addAction(textFieldAction(), for: .editingChanged)
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
        cancellable = viewModel?.titlePublisher
            .sink { [weak self] title in
            if title == nil || title == "" {
                self?.addButtonItem.isEnabled = false
            } else {
                self?.addButtonItem.isEnabled = true
            }
        }
    }
}
