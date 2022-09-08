//
//  ManagedDidItem+CoreDataProperties.swift
//  DidTodayUIKit
//
//  Created by Doyoung on 2022/09/08.
//
//

import CoreData

extension ManagedDidItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedDidItem> {
        return NSFetchRequest<ManagedDidItem>(entityName: "ManagedDidItem")
    }

    @NSManaged public var started: Date
    @NSManaged public var identifier: UUID
    @NSManaged public var finished: Date
    @NSManaged public var content: String
    @NSManaged public var red: Float
    @NSManaged public var green: Float
    @NSManaged public var blue: Float
    @NSManaged public var alpha: Float
}

extension ManagedDidItem : Identifiable {

}
