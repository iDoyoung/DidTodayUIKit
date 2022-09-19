//
//  CreateDidViewController.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/18.
//

import UIKit

final class CreateDidViewController: UIViewController {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
}
