//
//  PersistanceController.swift
//  DayRecorder
//
//  Created by USER on 2022/01/16.
//

import Foundation
import CoreData
import UIKit

class PersistanceController {
    
    static let shared = PersistanceController()
    
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext { container.viewContext }
    var coordinator: NSPersistentStoreCoordinator { container.persistentStoreCoordinator }
    
    static var preview: PersistanceController = {
        let controller = PersistanceController(inMemory: true)
        
        for idx in 1..<11 {
            let record = DayRecord(context: controller.container.viewContext)
            let item1 = DayItem(context: controller.container.viewContext)
            let item2 = DayItem(context: controller.container.viewContext)
            item1.title = "How was today?"
            item1.content =  "IT WAS GOOD." as NSObject
            item2.title = "What did you eat today?"
            item2.content = Array(repeating: UIImage(named: "iu"), count: 2) as NSObject
            
            record.title = "Day \(idx)..."
            record.date = Calendar.current.date(byAdding: .day, value: idx, to: Date())
            record.items = NSOrderedSet(array: [item1, item2])
        }
        
        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DayRecord")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
            }
        }
    }
    
    func fetch(isEditing: Bool) throws -> [DayRecord] {
        let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()
        request.predicate = NSPredicate(format: "isEditing == %@", NSNumber(value: isEditing))
        
        return try context.fetch(request)
    }
    
    func delete(_ record: DayRecord) {
        context.delete(record)
    }
    
    func makeItem(title: String, content: Any) -> DayItem {
        let item = DayItem(context: context)
        item.title = title
        item.content = content as? NSObject
        
        return item
    }
    
    func makeRecord(title: String, date: Date, items: [DayItem], isEditing: Bool) -> DayRecord {
        let record = DayRecord(context: context)
        record.title = title
        record.date = date
        record.items = NSOrderedSet(array: items)
        record.isEditing = isEditing
        
        return record
    }
}
