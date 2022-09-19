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
    func toDidItem() -> Did {
        return Did(id: identifier,
                   enforced: enforced,
                   started: started,
                   finished: finished,
                   content: title,
                   red: red,
                   green: green,
                   blue: blue,
                   alpha: alpha)
    }
    func fromDidItem(_ item: Did, context: NSManagedObjectContext) {
        identifier = item.id
        enforced = item.enforced
        started = item.started
        finished = item.finished
        title = item.content
        red = item.pieColor.red
        green = item.pieColor.green
        blue = item.pieColor.blue
        alpha = item.pieColor.alpha
    }
}
