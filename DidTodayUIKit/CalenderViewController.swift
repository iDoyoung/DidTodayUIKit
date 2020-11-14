//
//  CalenderViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/06.
//

import UIKit

class CalenderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = DidViewModel()
    var date = ""

    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadLastDate(date: date)
        navigationItem.titleView = datePicker
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        datePicker.maximumDate = yesterdayDate
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        tableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        drawPie()
    }
    
    func drawPie() {
            self.viewModel.loadPies(navigationController: self.navigationController, mainView: self.view)
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
        viewModel.loadLastDate(date: dateKey)
        self.view.viewWithTag(314)?.removeFromSuperview()
        self.viewWillAppear(true)
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
