//
//  EditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import CoreData
import SwiftUI

struct EditView: View {
    @ObservedObject var record: DayRecord
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            List {
                ForEach(record._items) { item in
                    Section(item.title ?? "-") {
                        if item.content is [UIImage] {
                            PhotoEditView(item: item)
                                .frame(height: 160)
                        }
                        if item.content is String {
                            TextEditView(item: item)
                                .frame(height: 160)
                        }
                    }
                }
                
                Button("Save") {
                    record.isEditing = false
                    PersistanceController.shared.save()
                    isPresented.toggle()
                }
                
                Button("Cancel") {
                    isPresented.toggle()
                }
                .foregroundColor(.red)
            }
        }
    }
}


extension DayRecordItem {
    var text: String {
        get { content as? String ?? "" }
        set { content = newValue as NSObject }
    }
    
    var photos: [UIImage] {
        get { content as? [UIImage] ?? [] }
        set { content = newValue as NSObject }
    }
}
