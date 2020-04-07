//
//  CoreDataStorageManager.swift
//  CraftSearch
//
//  Created by mkadam on 4/5/20.
//  Copyright © 2020 Craft Digital. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataStorageManager: NSObject {
    
    static let sharedInstance = CoreDataStorageManager()
    private override init() {}
    lazy var persistentContainer: NSPersistentContainer = {
    /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
    */
    let container = NSPersistentContainer(name: "CraftSearch")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func createSearchEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        
        let context = CoreDataStorageManager.sharedInstance.persistentContainer.viewContext
        if let search = NSEntityDescription.insertNewObject(forEntityName: "Search", into: context) as? Search {
            search.totalCount = dictionary["totalCount"] as? Int32 ?? 0
            search.type = dictionary["_type"] as? String
            guard let list = dictionary["value"] as? [[String: AnyObject]] else { return nil }
            for valueItem in list {
                if let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context) as? Item {
                    item.url = valueItem["url"] as? String ?? ""
                    item.height = valueItem["height"] as? Int16 ?? 0
                    item.width = valueItem["width"] as? Int16 ?? 0
                    item.thumbnail = valueItem["thumbnail"] as? String ?? ""
                    item.thumbnailWidth = valueItem["thumbnailWidth"] as? Int16 ?? 0
                    item.thumbnailHeight = valueItem["thumbnailWidth"] as? Int16 ?? 0
                    item.title = valueItem["title"] as? String ?? ""
                    item.name = valueItem["name"] as? String ?? ""
                    item.imageWebSearchUrl = valueItem["imageWebSearchUrl"] as? String ?? ""
                    search.addToValues(item)
                }
            }
            return search
        }
        return nil
    }
    
    func saveInCoreDataWith(dictionary: [String: AnyObject]) -> Search? {
        if let search = createSearchEntityFrom(dictionary: dictionary) as? Search {
           do {
               try CoreDataStorageManager.sharedInstance.persistentContainer.viewContext.save()
               return search
           } catch let error {
               print(error)
           }
        }
        return nil
    }
    func clearData() {
        do {
            
            let context = CoreDataStorageManager.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Search.self))
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStorageManager.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}
extension CoreDataStorageManager {
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}
