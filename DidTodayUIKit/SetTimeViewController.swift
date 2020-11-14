//
//  SetTimeViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/04.
//

import UIKit

class SetTimeViewController: UIViewController {

    
    @IBOutlet weak var startTimePicker: UIDatePicker!
    @IBOutlet weak var endTimePickser: UIDatePicker!
   
    var viewModel = DidViewModel()
    var startTime = "00:00"
    var endTime = "00:00"
    var delegate: ChangeStartAndEnd?
    
    var stardardTime: Date {
        viewModel.stringToDate(date: "0:00")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimePicker.date = stardardTime
        startTimePicker.addTarget(self, action: #selector(changed), for: .valueChanged)
        endTimePickser.date = stardardTime
        endTimePickser.addTarget(self, action: #selector(changed), for: .valueChanged)
    }
    
    @objc func changed(_ picker: UIDatePicker) {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .none
        dateformatter.timeStyle = .short
        dateformatter.dateFormat = "HH:mm"
        endTime = dateformatter.string(from: endTimePickser.date)
        let date = dateformatter.string(from: picker.date)
        if picker == startTimePicker {
            startTime = date
        } else {
            endTime = date
        }
    }


    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func change(_ sender: Any) {
        delegate?.change(start: startTime, end: endTime)
        dismiss(animated: true, completion: nil)
    }
    
}

protocol ChangeStartAndEnd {
    func change(start: String, end: String)
}

