//
//  ViewModel.swift
//  DidTodayUIKit
//
//  Created by ido on 2020/10/21.
//
import UIKit
import Foundation
import QuartzCore

class DidViewModel {
    
    var model = PreviousVersionModel.shared

    var navRightButton: Bool = false
    
    var dids: [PreviousVersionModel.Did] {
        model.dids 
    }
    
    var today: String {
        model.today
    }
    
    var todayMonthDay: String {
        model.todayDate
    }
    
    var now: String {
        model.now
    }
    var hours: Int {
        model.hour
    }

    var minutes: Int {
        model.minute
    }
    
    var currentMinutes: Int {
        model.currentToMinutes
    }
    
    func undo() {
        model.undoPie()
    }
    
    func timeFormat(saved about: String) -> Double {
        let hour: Int = model.formatTimeHours(time: about)
        let minute: Int = model.formatTimeMinutes(time: about)
        
        return Double(hour + minute)
    }
    
    func dateToString(time: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: time)
        return time
    }
    
    func stringToDate(date: String) -> Date {
        let time = model.formatTime(time: date)
        return time
    }
    
    func loadSavedDate() {
        model.printKey()
    }
    
    var savedDays: [Date] {
        model.savedDays
    }
    
    func loadToday() {
        model.loadToday()
    }
    
    func loadLastDate(date: String) {
        model.loadLastDate(date: date)
    }
    
    func loadDoing() {
        model.loadDoing()
    }
    
    var startNow: [PreviousVersionModel.Doing] {
        model.startNow
    }
    
    func save(did thing: String, at start: String, to finish: String, look colour: UIColor, date: String) {
        model.setData(thing: thing, start: start, finish: finish, colour: colour, day: date)
    }
        
    func counting(time: String, doing: String, paint: UIColor) {
        model.saveDoing(when: time, what: doing, color: paint)
    }
    
    func update(date: String) {
        model.updateData(date: date)
        print("succes update.")
    }
    func done() {
        model.deleteDoing()
    }
    
    //MARK: - Pie Chart
    
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    func drawPie(navigationController: UINavigationController?, mainView: UIView, start: String, end: String, colour: UIColor) {
        
        let navigationBarHeight: CGFloat
        if navigationController == nil {
            navigationBarHeight = 0
        } else {
            navigationBarHeight = navigationController!.navigationBar.frame.height
        }
        let pie = DrawPie(startTime: start, endTime: end, extraY: navigationBarHeight + statusBarHeight, mainWidth: mainView.frame.width, color: colour)
        pie.center = CGPoint(x: mainView.frame.width / 2, y: ((mainView.frame.width / 2) + navigationBarHeight + statusBarHeight))
        
        pie.backgroundColor = .clear
        mainView.insertSubview(pie, at: 1)
        
        pie.tag = 300
    }
        
    func loadPies(navigationController: UINavigationController?, mainView: UIView) {
        
        let navigationBarHeight: CGFloat
        if navigationController == nil {
            navigationBarHeight = 0
        } else {
            navigationBarHeight =  navigationController!.navigationBar.frame.height
        }
        
        let pie = AllPie(frame: CGRect(x: 20, y: 20 + navigationBarHeight + statusBarHeight, width: mainView.frame.width - 40, height: mainView.frame.width - 40))
        pie.center = CGPoint(x: mainView.frame.width / 2, y: ((mainView.frame.width / 2) + navigationBarHeight + statusBarHeight))
        pie.backgroundColor = .clear
        mainView.insertSubview(pie, at: 0)
        pie.tag = 314
    }

    
    func applyRadius(view: UIView) {
        view.layer.cornerRadius = view.frame.height * 0.25
        view.clipsToBounds = true
    }
    

    let colours: [UIColor] = [#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1), #colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1), #colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1), #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1), #colorLiteral(red: 0.4513868093, green: 0.9930960536, blue: 1, alpha: 1), #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1), #colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1), #colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)]
    let colors: [UIColor] = [#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1), #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)]
    
    var colour: UIColor {
        return colors.randomElement() ?? UIColor.clear
    }

}
