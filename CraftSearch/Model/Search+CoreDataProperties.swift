//
//  Search+CoreDataProperties.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension Search {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Search> {
        return NSFetchRequest<Search>(entityName: "Search")
    }

    @NSManaged public var type: String?
    @NSManaged public var totalCount: Int32
    @NSManaged public var values: NSSet?

}

// MARK: Generated accessors for values
extension Search {

    @objc(addValuesObject:)
    @NSManaged public func addToValues(_ value: Item)

    @objc(removeValuesObject:)
    @NSManaged public func removeFromValues(_ value: Item)

    @objc(addValues:)
    @NSManaged public func addToValues(_ values: NSSet)

    @objc(removeValues:)
    @NSManaged public func removeFromValues(_ values: NSSet)

}
