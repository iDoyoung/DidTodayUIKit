//
//  CalenderViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/06.
//

import UIKit

class CalenderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyLabel: UILabel!
    var viewModel = DidViewModel()
    var date = ""

    let datePicker = UIDatePicker()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !viewModel.dids.isEmpty {
            tableViewHide()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !viewModel.dids.isEmpty {
            tableViewHide()
        }
    }
    
    func tableViewHide() {
        tableView.isHidden = !tableView.isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(named: "CustomBackColor")
        viewModel.loadLastDate(date: date)
        navigationItem.titleView = datePicker
        let yesterdayDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        datePicker.maximumDate = yesterdayDate
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(chooseDate), for: .valueChanged)
        
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.clear
    }

    func loadUI() {
        if !viewModel.dids.isEmpty {
            emptyLabel.isHidden = true
            tableView.isHidden = false
            drawPie()
        } else {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadUI()
    }
    
    func drawPie() {
        let navigation = self.navigationController
        let bgView = self.view
        self.viewModel.addCircle(navigationController: navigation, mainView: bgView!)
        self.viewModel.loadPies(navigationController: navigation, mainView: bgView!)
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
        self.view.viewWithTag(24)?.removeFromSuperview()
        self.viewWillAppear(true)
        tableView.reloadData()
        tableView.backgroundView?.backgroundColor = UIColor.clear
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
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        cell.startToEndTime.textColor = .white
        cell.didThing.text = viewModel.dids[indexPath.row].did
        cell.didThing.textColor = viewModel.dids[indexPath.row].colour
        cell.separatorInset = .zero
        tableView.separatorColor = UIColor.init(named: "CustomBackColor")
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
