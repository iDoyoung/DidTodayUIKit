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
    
    @IBOutlet weak var pieView: PieView!
    @IBOutlet weak var addButtonItem: UIBarButtonItem!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBAction func showColorPicker(_ sender: UIButton) {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        present(colorPickerViewController, animated: true)
    }
    @IBAction func setStartedTime(_ sender: UIDatePicker) {
        viewModel?.startedTime = sender.date
        #if DEBUG
        print("START TIME IS CHANGED")
        #endif
    }
    @IBAction func setEndedTime(_ sender: UIDatePicker) {
        viewModel?.endedTime = sender.date
        #if DEBUG
        print("END TIME IS CHANGED")
        #endif
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
        viewModel?.titlePublisher
            .sink { [weak self] title in
                if let title = title,
                   title.trimmingCharacters(in: .whitespaces).isEmpty == false {
                    self?.addButtonItem.isEnabled = true
                } else {
                    self?.addButtonItem.isEnabled = false
                }
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
