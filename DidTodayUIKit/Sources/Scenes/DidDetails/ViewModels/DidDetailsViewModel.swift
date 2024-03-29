//
//  DidDetailsViewModel.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/03/11.
//

import UIKit
import Combine

protocol DidDetailsViewModelProtocol: DidDetailsViewModelInput, DidDetailsViewModelOutput { }

protocol DidDetailsViewModelInput {
    func delete() async throws
}

protocol DidDetailsViewModelOutput {
    var date: Just<String?> { get }
    var title: Just<String?> { get }
    var didTime: Just<String?> { get }
    var startedTime: Just<String?> { get }
    var finishedTime: Just<String?> { get }
    var color: Just<UIColor?> { get }
}

final class DidDetailsViewModel: DidDetailsViewModelProtocol {

    //MARK: - Properties
    
    var deleteDidUseCase: DeleteDidUseCase?
    private var selectedDid: Did?
    //MARK: Output
    var date: Just<String?>
    var title: Just<String?>
    var didTime: Just<String?>
    var startedTime: Just<String?>
    var finishedTime: Just<String?>
    ///Seted Color by user to display pie's color
    var color: Just<UIColor?>
    
    init(_ did: Did) {
        selectedDid = did
        let startDate = did.started.toString()
        let endedDate = did.finished.toString()
        var startedTime = did.started.currentTimeToString()
        if startDate != endedDate {
            startedTime = "(\(startDate)) " + startedTime
        }
        let finishedTime = did.finished.currentTimeToString()
        ///date components of  difference between started and finished.
        let components = Calendar.current.dateComponents([.hour, .minute], from: did.started, to: did.finished)
        ///RGB Color
        let red = CGFloat(did.pieColor.red)
        let green = CGFloat(did.pieColor.green)
        let blude = CGFloat(did.pieColor.blue)
        let alpha = CGFloat(did.pieColor.alpha)
        ///Output
        date = Just(startDate)
        title = Just(did.content)
        assert(components.hour != nil, "Hours should not be nil")
        assert(components.minute != nil, "Minutes should not be nil")
        didTime = Just(CustomText.timesRange(started: components.hour ?? 0, finished: components.minute ?? 0))
        self.startedTime = Just(startedTime)
        self.finishedTime = Just(finishedTime)
        color = Just(UIColor(red: red, green: green, blue: blude, alpha: alpha))
    }
    
    //MARK: - Method
    func delete() async throws {
        guard let selectedDid else { return }
        try await deleteDidUseCase?.execute(with: selectedDid)
    }
}
