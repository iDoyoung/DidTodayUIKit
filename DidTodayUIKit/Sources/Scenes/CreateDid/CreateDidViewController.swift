//
//  CreateDidViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/18.
//

import UIKit
import SwiftUI
import Combine
import os

final class CreateDidViewController: ParentUIViewController {
    
    typealias Action = CreateDidAction
    
    //MARK: - Properties
    
    var did: Did = Did(
        started: .init(),
        finished: .init(),
        content: "",
        color: .green
    )
    
    var error = CreateDidError()
    var action = Action()
    
    var createDidUseCase: CreateDidUseCase?
    private var cancellableBag = [AnyCancellable]()
    
    // UI
    private var feedbackGenerator: UIFeedbackGenerator?
    
    lazy var rootView: CreateDidRootView = {
        CreateDidRootView(
            creating: did, 
            error: error,
            action: action
        )
    }()
    
    lazy var hostingController: UIHostingController<CreateDidRootView>! = {
        UIHostingController(rootView: rootView)
    }()
    
    //MARK: - Methods
    
    
    //View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        buildFeedbackGenerator()
        buildCreateAction()
        buildColorPickerAction()
        buildClosing()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func buildCreateAction() {
        action.$isTapCreateButton
            .sink { [weak self] in
                guard let self else { return }
                
                if $0 {
                    logger.log("Text: \(did.content)")
                    logger.debug("Use Case \(String(describing: createDidUseCase))")
                    if did.content.isEmpty {
                        error.type = .textFieldIsEmpty
                        occurFeedback()
                        withAnimation(Animation.spring(
                            response: 0.1,
                            dampingFraction: 0.1,
                            blendDuration: 0.4
                        )) {
                            self.error.type = .none
                        }
                    } else {
                        Task {
                            try await self.createDidUseCase?.execute(self.did)
                            self.logger.log("Success Create Did")
                        }
                        dismiss(animated: true)
                        logger.log("Dismiss, Success Create Did")
                    }
                }
            }
            .store(in: &cancellableBag)
    }
    
    private func buildColorPickerAction() {
        action.$isTapColorPickerButton
            .sink { [weak self] in
                guard let self else { return }
                if $0 {
                    logger.log("Tap Color Picker")
                    showColorPicker()
                }
            }
            .store(in: &cancellableBag)
    }
    
    private func buildClosing() {
        action.$isClose
            .sink { [weak self] in
                guard let self else { return }
                if $0 {
                    self.dismiss(animated: true)
                }
            }
            .store(in: &cancellableBag)
    }
    
    private func showColorPicker() {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true)
    }
    
    private func buildFeedbackGenerator() {
        feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator?.prepare()
    }
    
    private func occurFeedback() {
        (feedbackGenerator as? UINotificationFeedbackGenerator)?.notificationOccurred(.error)
    }
}

extension CreateDidViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        did.uiColor = color
    }
}
