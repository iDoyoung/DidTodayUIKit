//
//  CreateDidViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/18.
//

import UIKit
import Combine

final class CreateDidViewController: ParentUIViewController, StoryboardInstantiable {
    
    //MARK: - Properties
    var viewModel: (CreateDidViewModelInput & CreateDidViewModelOutput)?
    private var cancellableBag = Set<AnyCancellable>()
    
    private var feedbackGenerator: UIFeedbackGenerator?
    
    //Interface Builder
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pieView: PieView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startedTimePicker: UIDatePicker!
    @IBOutlet weak var endedTimePicker: UIDatePicker!
    @IBOutlet weak var addButton: UIButton!
    
    //MARK: - Methods
    
    //MARK: Interface Builder
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
    
    @IBAction func tryToCreateAdd(_ sender: UIButton) {
        configureFeedbackGenerator()
    }
    
    @IBAction func createDid(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        if viewModel.titleIsEmpty.value {
            titleTextField.animateToShake()
            occurFeedback()
        } else {
            present(completeToCreateDidAlert(), animated: true)
        }
    }
    
    @IBAction func skipCreateDid(_ sender: UIButton) {
        feedbackGenerator = nil
    }
    
    ///For Feedback Generator
    private func configureFeedbackGenerator() {
        feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    private func occurFeedback() {
        (feedbackGenerator as? UINotificationFeedbackGenerator)?.notificationOccurred(.error)
        feedbackGenerator = nil
    }
   
    //MARK: Life cycle
    static func create(with viewModel: CreateDidViewModelProtocol) -> CreateDidViewController {
        let viewController = CreateDidViewController.instantiateViewController(storyboardName: StoryboardName.createDid)
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIObjects()
        createDismissKeyboardTapGesture()
        bindViewModel()
    }
    
    //MARK: Setup
    private func setupUIObjects() {
        titleTextField.delegate = self
        setupNavigationBar()
        scrollView.keyboardDismissMode = .onDrag
        setupDatePickers()
    }
   
    private func setupNavigationBar() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .black, scale: .default)
        let xmarkImage = UIImage(systemName: "xmark", withConfiguration: imageConfiguration)
        let rightBarButton = UIBarButtonItem(image: xmarkImage, style: .plain, target: self, action: #selector(closeView))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupDatePickers() {
        guard let viewModel = viewModel else { return }
        startedTimePicker.date = viewModel.initialStartedTime()
        endedTimePicker.date = viewModel.initialEndedTime()
        endedTimePicker.minimumDate = startedTimePicker.date
        endedTimePicker.maximumDate = Date()
        startedTimePicker.maximumDate = endedTimePicker.date
        //FIXME: -
        viewModel.startedTime.send(startedTimePicker.date)
        viewModel.endedTime.send(endedTimePicker.date)
    }
    
    private func bindViewModel() {
        viewModel?.title
            .sink { [weak self] output in
                self?.title = output
            }
            .store(in: &cancellableBag)
        viewModel?.timePickerEnable
            .sink { [weak self] output in
                self?.startedTimePicker.isEnabled = output
                self?.endedTimePicker.isEnabled = output
            }
            .store(in: &cancellableBag)
        
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
        
        viewModel?.isCompleted
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isCompleted in
                if isCompleted {
                    self?.dismiss(animated: true)
                }
            }
            .store(in: &cancellableBag)
        
        viewModel?.creatingError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] output in
                guard let self = self else { return }
                if output != nil {
                    //TODO: Understanding Core Data Error
                    self.present(self.errorAlert(), animated: true)
                }
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
    
    @objc func closeView() {
        present(discardToCreateDidAlert(), animated: true)
    }
}

//MARK: - Scroll View
extension UIScrollView {
    func scrollToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
}

//MARK: - Color Picker
extension CreateDidViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        viewModel?.setColorOfPie(color)
    }
}

//MARK: - Text Field
extension CreateDidViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.scrollsToTop = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if !text.trimmingCharacters(in: .whitespaces).isEmpty {
            viewModel?.setTitle(text)
        } else {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

//MARK: - Alert
extension CreateDidViewController: CreateDidAlert {
    
    func completeToCreateDid() {
        Task {
            await viewModel?.createDid()
        }
    }
    
    func discardToCreateDid() {
        dismiss(animated: true)
    }
}
