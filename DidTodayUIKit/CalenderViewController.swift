//
//  CalenderViewController.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/11/06.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    var viewModel = DidViewModel()
    var selectYear = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.select(Date())
        self.view.backgroundColor = UIColor.init(named: "CustomBackColor")
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        selectYear = dateFormatter.string(from: calendar.currentPage)
        self.navigationItem.title = selectYear
        calendar.appearance.headerDateFormat = "MMMM"
    }
}

extension CalenderViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dids.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DidTableCell", for: indexPath) as? DidTableCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.3)
        cell.startToEndTime.textColor = .label
        cell.didThing.text = viewModel.dids[indexPath.row].did
        cell.colourView.backgroundColor = viewModel.dids[indexPath.row].colour
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
    @IBOutlet weak var colourView: UIView!
}

extension CalenderViewController: FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        if self.viewModel.savedDays.contains(date){
            return 1
        }
        return 0
    }
}

extension CalenderViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: date)
        viewModel.loadLastDate(date: dateString)
        tableView.reloadData()
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let dateString = dateFormatter.string(from: calendar.currentPage)
        if dateString != self.selectYear {
            self.selectYear = dateString
            self.navigationItem.title = dateString
        }
    }
}

