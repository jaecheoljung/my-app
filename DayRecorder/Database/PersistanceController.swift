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
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
            }
        }
    }
    
    func fetchEditingRecord() throws -> [DayRecord] {
        let context = container.viewContext
        
        let request: NSFetchRequest<DayRecord> = DayRecord.fetchRequest()
        request.predicate = NSPredicate(format: "isEditing == TRUE")
        
        return try context.fetch(request)
    }
    
    func resetEditingRecord() throws {
        let context = container.viewContext
        let coordinator = container.persistentStoreCoordinator
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DayRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isEditing == TRUE")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        try coordinator.execute(deleteRequest, with: context)
    }
    
    func insertDefaultEditingRecord() -> DayRecord {
        let context = container.viewContext
        let record = DayRecord(context: context)
        let item1 = DayItem(context: context)
        let item2 = DayItem(context: context)
        item1.title = "How was today?"
        item1.content =  "IT WAS GOOD." as NSObject
        item2.title = "What did you eat today?"
        item2.content = Array(repeating: UIImage(named: "iu"), count: 2) as NSObject
        
        record.title = "Day..."
        record.items = NSOrderedSet(array: [item1, item2])
        record.isEditing = true
        
        return record
    }
}
