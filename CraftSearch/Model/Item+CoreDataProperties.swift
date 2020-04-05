//
//  Item+CoreDataProperties.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var url: String?
    @NSManaged public var height: Int16
    @NSManaged public var width: Int16
    @NSManaged public var thumbnailHeight: Int16
    @NSManaged public var thumbnailWidth: Int16
    @NSManaged public var thumbnail: String?
    @NSManaged public var name: String?
    @NSManaged public var title: String?
    @NSManaged public var imageWebSearchUrl: String?

}
