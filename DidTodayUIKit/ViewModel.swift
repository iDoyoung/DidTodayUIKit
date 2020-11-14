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
    
    var model = Model.shared
    var quickModel = Quick.shared
    
    
    var dids: [Model.Did] {
        model.dids
    }
    
    var hours: Int {
        model.hour
    }

    var minutes: Int {
        model.minute
    }
    
    var currentTime: Int {
        model.currentTime
    }
    
    func undo() {
        model.undoPie()
    }
    
    func timeFormat(saved about: String) -> Double {
        let hour: Int = model.formatTimeHours(time: about)
        let minute: Int = model.formatTimeMinutes(time: about)
        
        return Double(hour + minute)
    }
    
    func stringToDate(date: String) -> Date {
        let time = model.formatTime(time: date)
        return time
    }
    
    func loadToday() {
        model.loadToday()
    }
    
    func loadLastDate(date: String) {
        model.loadLastDate(date: date)
    }
    func save(did thing: String, at start: String, to finish: String, look colour: UIColor) {
        model.setData(thing: thing, start: start, finish: finish, colour: colour)
    }
    
    var dailys: [Quick.Daily] {
        quickModel.dailys
    }
    
    func addDaily(daily: Quick.Daily) {
        quickModel.addDaily(add: daily)
    }
    
    func removeDaily(id: Int) {
        quickModel.deleteDaily(index: id)
    }
    func saveMyButton() {
        quickModel.setQuick()
    }
    
    func resetButton(about: Int, new: Quick.Daily) {
        quickModel.resetDaily(index: about, daily: new)
    }
    
    func loadMyButton() {
        quickModel.loadQuick()
    }
    
    var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    func drawPie(navigationController: UINavigationController?, mainView: UIView) {
        
        let navigationBarHeight: CGFloat
        if navigationController == nil {
            navigationBarHeight = 0
        } else {
            navigationBarHeight = navigationController!.navigationBar.frame.height
        }
        
        let pie = DrawPie(frame: CGRect(x: 20, y: 20 + navigationBarHeight + statusBarHeight, width: mainView.frame.width - 40, height: mainView.frame.width - 40))
        
        pie.center = CGPoint(x: mainView.frame.width / 2, y: ((mainView.frame.width / 2) + navigationBarHeight + statusBarHeight))
        
        pie.backgroundColor = .clear
        mainView.insertSubview(pie, at: 3)
        
//        pie.layer.shadowColor = UIColor.black.cgColor
//        pie.layer.shadowOpacity = 0.8
//        pie.layer.shadowRadius = 5.0
//        pie.layer.shadowOffset = .zero
//        pie.layer.animationKeys()
        pie.tag = 300
        
    }
    
    func addPie(navigationController: UINavigationController?, mainView: UIView) {
        
        let navigationBarHeight: CGFloat
        if navigationController == nil {
            navigationBarHeight = 0
        } else {
            navigationBarHeight = navigationController!.navigationBar.frame.height
        }
        
        let pie = Pie(frame: CGRect(x: 20, y: 20 + navigationBarHeight + statusBarHeight, width: mainView.frame.width - 40, height: mainView.frame.width - 40))
        
        pie.center = CGPoint(x: mainView.frame.width / 2, y: ((mainView.frame.width / 2) + navigationBarHeight + statusBarHeight))
        
        pie.backgroundColor = .clear
        mainView.insertSubview(pie, at: 3)
        
//        pie.layer.shadowColor = UIColor.black.cgColor
//        pie.layer.shadowOpacity = 0.8
//        pie.layer.shadowRadius = 5.0
//        pie.layer.shadowOffset = .zero
//        pie.layer.animationKeys()
        pie.tag = 365
        print(pie.tag)
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
        
        mainView.insertSubview(pie, at: 2)
        
//        pie.layer.shadowColor = UIColor.black.cgColor
//        pie.layer.shadowOpacity = 0.8
//        pie.layer.shadowRadius = 5.0
//        pie.layer.shadowOffset = .zero
//        pie.layer.animationKeys()
        pie.tag = 314
    }

    func addCircle(navigationController: UINavigationController?, mainView: UIView) {
        
        let navigationBarHeight: CGFloat
        if navigationController == nil {
            navigationBarHeight = 0
        } else {
            navigationBarHeight =  navigationController!.navigationBar.frame.height
        }
        
        let circle = UIView(frame: CGRect(x: 20, y: 20 + navigationBarHeight + statusBarHeight, width: mainView.frame.width - 40, height: mainView.frame.width - 40))
        circle.backgroundColor = .systemBackground
        
        circle.layer.shadowOpacity = 0.3
        circle.layer.shadowColor = UIColor.black.cgColor
        circle.layer.shadowRadius = 7.0
        circle.layer.opacity = 0.3
        
        circle.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        circle.layer.cornerRadius = circle.frame.size.width / 2
        mainView.insertSubview(circle, at: 1)
        
    }
    
    func applyRadius(view: UIView) {
        view.layer.cornerRadius = view.frame.height * 0.25
        view.clipsToBounds = true
    }
    
    func bgView(mainView: UIView) {
        let graident = Gradient()
        if currentTime <= 300 {
            graident.midnight(view: mainView)
        } else if currentTime > 300, currentTime <= 420 {
            graident.dawn(view: mainView)
        } else if currentTime > 420, currentTime <= 1080 {
            graident.afternoon(view: mainView)
        } else if currentTime > 1080, currentTime <= 1140{
            graident.evening(view: mainView)
        } else {
            graident.night(view: mainView)
        }
    }
}
