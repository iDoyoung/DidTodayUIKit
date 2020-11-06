//
//  CalenderViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/06.
//

import UIKit

class CalenderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pieView: UIView!
    
    var viewModel = DidViewModel()
    var date = ""

    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = datePicker
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        tableView.dataSource = self
        drawPie()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        viewModel.loadLastDate(date: date)
    }
    
    func drawPie() {
        let pie = Pie(frame: pieView.frame)
        pie.center = pieView.center
        pie.backgroundColor = .clear
        pieView.addSubview(pie)
        pie.layer.shadowColor = UIColor.black.cgColor
        pie.layer.shadowOpacity = 1
        pie.layer.shadowRadius = 5.0
        pie.layer.shadowOffset = .zero
        pie.layer.animationKeys()
    }
    
    func update(day: String, title: Date) {
        date = day
        datePicker.date = title
    }
    
    @objc func chooseDate() {
        let dateformatter = DateFormatter()
        dateformatter.dateStyle = .long
        dateformatter.timeStyle = .none
        dateformatter.dateFormat = "yyyyMMdd"
        let dateKey = dateformatter.string(from: datePicker.date)
        print(dateKey)
        viewModel.loadLastDate(date: dateKey)
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

extension CalenderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DidTableCell", for: indexPath) as? DidTableCell else {
            return UITableViewCell()
        }
        cell.didThing.text = viewModel.dids[indexPath.row].did
        let startTime = viewModel.dids[indexPath.row].start
        let endTime = viewModel.dids[indexPath.row].finish
        cell.startToEndTime.text = "\(startTime) ~ \(endTime)"
        return cell
    }
}

class DidTableCell: UITableViewCell {
    @IBOutlet weak var startToEndTime: UILabel!
    @IBOutlet weak var didThing: UILabel!
    
}
