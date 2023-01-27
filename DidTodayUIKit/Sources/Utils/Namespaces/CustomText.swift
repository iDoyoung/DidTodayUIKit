//
//  CustomText.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/16.
//

import Foundation

///Namespaces for UI of String like Text
enum CustomText {
    ///In Main
    static let recently = "Recently".localized
    ///In Main
    static let muchTime = "Much time".localized
    ///In Main
    static let firstTipInMain = "Tap to start".localized
    ///In Main
    static let secondTipInMain = "Tap and start anything".localized
    
    ///In Doing
    static let firstTipInDoing = "Keep going!".localized
    ///In Doing
    static let secondTipInDoing = "Couldn't add within 5 minutes".localized
    ///In Doing
    static func started(time: String) -> String {
        return String(format: "Started Time: %@".localized, time)
    }
    ///In Doing Notification
    static let dayIsChangedNotificationTitle = "Day is changed!".localized
    ///In Doing Notification
    static let dayIsChangedNotificationSubTitle = "Are you working now? If you are not, please cancel or finish a work.".localized
    ///In Timer Alert
    static let cancelTimerTitle = "Are you sure to cancel?".localized
    ///In Timer Alert
    static let doneTimerTitle = "Are you sure to finish?".localized
    ///In Timer Alert
    static let cancelTimerMessage = "You cannot undo.".localized
    ///In Timer Alert
    static let doneTimerMessage = "You cannot undo.".localized
    ///in Create Did
    static let finishingTouches = "Finishing touches".localized
    ///in Create Did
    static let createDid = "Create Did".localized
    
    ///In Create Did Alert
    static let discardToCreateDidTitle = "Discard your Creation?".localized
    ///In Create Did Alert
    static let discardToCreateDidMessage = "You cannot undo.".localized
    ///In Create Did Alert
    static let errorAlertOfCreateTitle = ""
    ///In Create Did Alert
    static let completeToCreateTitle = "Complete your Creation?".localized
    ///In Create Did Alert
    static let completeToCreateMessage = "Error".localized
    ///In Create Did Alert
    static let errorMessageOfCreateDid = ""
    ///In Create Did Alert
    static let discard = "Discard".localized
    ///In Create Did Alert
    static let create = "Create".localized
    
    ///In Calendar
    static let selectDay = "Select Day".localized
    ///In Calendar
    static func selectedItems(count: Int) -> String {
        return String(format: "Did %d Things".localized, count)
    }
    ///In Calendar
    static let showDetail = "Show detail".localized
    
    ///In About
    static let about = "About".localized
    ///In About
    static let recommendDid = "Recommend Did".localized
    ///In About
    static let writeAReview = "Write a review".localized
    ///In About
    static let privacyPolicy = "Privacy Policy".localized
    
    ///Total of Dids Item
    static let didNothing = "Did nothing".localized
    ///Total of Dids Item
    static func didThing(count: Int) -> String {
        return count == 0 ? "Did nothing".localized : String(format:"Did %d things!".localized, count)
    }
    
    static let cancel = "Cancel".localized
    static let okay = "OK".localized
}
