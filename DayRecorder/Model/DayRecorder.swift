//
//  DayRecorder.swift
//  DayRecorder
//
//  Created by USER on 2022/01/16.
//

import Foundation
import SwiftUI

class DayRecorder: ObservableObject {
    
    @Published var editingRecord: DayRecord?
    
    var controller: PersistanceController { PersistanceController.shared }
    
    init() {
        try? setEditingRecord()
    }
    
    func setEditingRecord() throws {
        let records = try controller.fetch(isEditing: true)
        
        if records.count == 1 {
            editingRecord = records.first
        } else if records.count > 1 {
            records.forEach { controller.delete($0) }
        } else {
            makeEditingRecord()
        }
    }
    
    func makeEditingRecord() {
        let items = [
            controller.makeItem(title: "My Sample Item 1", content: "My Sample Item 1"),
            controller.makeItem(title: "My Sample Item 2", content: [UIImage]())
        ]
        
        editingRecord = controller.makeRecord(title: "My Sample Record", date: Date(), items: items, isEditing: true)
    }
}
