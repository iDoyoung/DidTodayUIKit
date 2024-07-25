//
//  CustomText.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2023/01/16.
//

import Foundation

///Namespaces for UI of String like Text
enum CustomText {
    //MARK: - For Main
    static let recently = "Recently".localized
    static let muchTime = "Much time".localized
    static let firstTipInMain = "Tap to start".localized
    static let secondTipInMain = "Tap and start anything".localized
    //MARK: Alert
    static let recordedBeforeAlertTitle = "Deleted record".localized
    static let recordedBeforeAlertMessage = "Opps! You close app when recording, so deleted this record".localized
    
    //MARK: - For Doing
    static let firstTipInDoing = "Keep going!".localized
    static let secondTipInDoing = "Couldn't finish a work within 5 minutes".localized
    static func started(time: String) -> String {
        return String(format: "Started Time: %@".localized, time)
    }
    //MARK: Notification
    static let dayIsChangedNotificationTitle = "Day is changed!".localized
    static let dayIsChangedNotificationSubTitle = "Are you working now? If you are not, please cancel or finish a work.".localized
    //MARK: Alert
    static let cancelTimerTitle = "Are you sure to cancel?".localized
    static let doneTimerTitle = "Are you sure to finish?".localized
    static let cancelTimerMessage = "You cannot undo.".localized
    static let doneTimerMessage = "You cannot undo.".localized
    
    //MARK: - For Create Did
    static let finishingTouches = "Finishing touches".localized
    static let createDid = "Create Did".localized
    
    //MARK: Alert
    static let discardToCreateDidTitle = "Discard your Creation?".localized
    static let discardToCreateDidMessage = "You cannot undo.".localized
    static let errorAlertOfCreateTitle = ""
    static let completeToCreateTitle = "Complete your Creation?".localized
    static let completeToCreateMessage = "Error".localized
    static let errorMessageOfCreateDid = ""
    static let discard = "Discard".localized
    static let create = "Create".localized
    
    ///In Calendar
    //MARK: - For Calendar
    static let selectDay = "Select Day".localized
    static let whichDayDidYou = "Which day did you do?".localized
    static func selectedItems(count: Int) -> String {
        return String(format: "Did %d Things".localized, count)
    }
    
    static let showDetail = "Show detail".localized
    
    //MARK: - For About
    static let about = "About".localized
    static let recommendDid = "Recommend Did".localized
    static let writeAReview = "Write a review".localized
    static let privacyPolicy = "Privacy Policy".localized
    
    ///- Tag: Total of Dids Item
    static let didNothing = "Did nothing".localized
    static func didThing(count: Int) -> String {
        return count == 0 ? "Did nothing".localized : String(format:"Did %d things!".localized, count)
    }
    
    //MARK: - Did Details
    static func timesRange(started: Int, finished: Int) -> String {
        return String(format: "%d HOURS %d MINUTES".localized, started, finished)
    }
    //Alert
    static let deleteAlertTitle = "Delete your Did?".localized
    static let deleteAlertMessage = "This Did will be deleted. This action cannot be undone.".localized
    static let deleteDid = "Delete Did".localized
    
    //MARK: - For Global
    static let cancel = "Cancel".localized
    static let okay = "OK".localized
    static let did = "DID"
}
