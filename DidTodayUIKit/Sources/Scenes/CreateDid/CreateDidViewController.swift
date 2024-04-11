//
//  CreateDidViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/18.
//

import UIKit
import SwiftUI
import Combine

final class CreateDidViewController: ParentUIViewController {
    
    //MARK: - Components
    var updater: CreateDidViewUpdater?
    var hostingController: UIHostingController<CreateDidRootView>!
    
    //MARK: - Life cycle
    static func create(with updater: CreateDidViewUpdater) -> CreateDidViewController {
        let viewController = CreateDidViewController()
        viewController.updater = updater
        viewController.hostingController = UIHostingController(rootView: CreateDidRootView(
            updater: updater,
            presentColorPicker: viewController.showColorPicker)
        )
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(hostingController)
        hostingController.view.frame = view.frame
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func showColorPicker() {
        let colorPickerViewController = UIColorPickerViewController()
        colorPickerViewController.supportsAlpha = false
        colorPickerViewController.delegate = self
        present(colorPickerViewController, animated: true)
    }
}

extension CreateDidViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        updater?.viewModel.selectedColor = Color(uiColor: color)
    }
}
