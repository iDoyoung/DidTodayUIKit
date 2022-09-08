//
//  ManagedDidItem+CoreDataClass.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/08.
//
//

import CoreData

@objc(ManagedDidItem)
public class ManagedDidItem: NSManagedObject {
    func toDidItem() -> DidItem {
        return DidItem(id: identifier,
                       started: started,
                       finished: finished,
                       content: content,
                       red: red,
                       green: green,
                       blue: blue,
                       alpha: alpha)
    }
    func fromDidItem(_ item: DidItem, context: NSManagedObjectContext) {
        identifier = item.id
        started = item.started
        finished = item.finished
        content = item.content
        red = item.pieColor.red
        green = item.pieColor.green
        blue = item.pieColor.blue
        alpha = item.pieColor.alpha
    }
}
