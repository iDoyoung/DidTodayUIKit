//
//  DidDetailsViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/11.
//

import UIKit
import Combine

protocol DidDetailsViewModelProtocol: DidDetailsViewModelInput, DidDetailsViewModelOutput { }

protocol DidDetailsViewModelInput { }

protocol DidDetailsViewModelOutput {
    var date: Just<String> { get }
    var title: Just<String> { get }
    var didTime: Just<String> { get }
    var timeRange: Just<String> { get }
    var color: Just<UIColor> { get }
}

final class DidDetailsViewModel: DidDetailsViewModelProtocol {

    //MARK: Output
    var date: Just<String>
    var title: Just<String>
    var didTime: Just<String>
    var timeRange: Just<String>
    ///Setted Color by user to display pie's color
    var color: Just<UIColor>
    
    init(_ did: Did) {
        let startDate = did.started.toString()
        let startedTime = did.started.currentTimeToString()
        let finishedTime = did.finished.currentTimeToString()
        ///date components of  difference between started and finished.
        let components = Calendar.current.dateComponents([.hour, .minute], from: did.finished, to: did.started)
        ///RGB Color
        let red = CGFloat(did.pieColor.red)
        let green = CGFloat(did.pieColor.green)
        let blude = CGFloat(did.pieColor.blue)
        let alpha = CGFloat(did.pieColor.alpha)
        ///Output
        date = Just(startDate)
        title = Just(did.content)
        didTime = Just("Did \(components.hour ?? 0): \(components.minute ?? 0)")
        timeRange = Just("\(startedTime) - \(finishedTime)")
        color = Just(UIColor(red: red, green: green, blue: blude, alpha: alpha))
    }
}
