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
    
    init() {
        setEditingRecord()
    }
    
    func setEditingRecord() {
        let controller = PersistanceController.shared
        let records = (try? controller.fetchEditingRecord()) ?? []
        
        if records.count != 1 {
            try? controller.resetEditingRecord()
            editingRecord = controller.insertDefaultEditingRecord()
        } else {
            editingRecord = records.first
        }
    }
}
