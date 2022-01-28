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
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DayRecord")

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
    
    func makeItem(title: String, content: Any) -> DayRecordItem {
        let item = DayRecordItem(context: context)
        item.title = title
        item.content = content as? NSObject
        
        return item
    }
    
    func makeRecord(title: String, date: Date, items: [DayRecordItem], isEditing: Bool) -> DayRecord {
        let record = DayRecord(context: context)
        record.title = title
        record.date = date
        record.items = NSOrderedSet(array: items)
        record.isEditing = isEditing
        
        return record
    }
    
    func fetchEditingRecord() -> DayRecord {
        if let records = try? fetch(isEditing: true), records.count == 1 {
            return records[0]
        }
        
        (try? fetch(isEditing: true))?.forEach(delete)
        
        return makeRecord(title: "", date: Date(), items: [
            makeItem(title: "new.text.item".localized, content: ""),
            makeItem(title: "new.photo.item".localized, content: [UIImage]())
        ], isEditing: true)
    }
    
    func copyRecord(from record: DayRecord) {
        let items: [DayRecordItem] = record._items.compactMap { item in
            guard let title = item.title else {
                return nil
            }
            if item.content is String {
                return makeItem(title: title, content: "")
            }
            if item.content is [UIImage] {
                return makeItem(title: title, content: [UIImage]())
            }
            return nil
        }
        
        _ = makeRecord(title: "", date: Date(), items: items, isEditing: true)
    }
    
    func rollback() {
        context.rollback()
    }
}
