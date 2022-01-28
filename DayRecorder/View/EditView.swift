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
    var isDisabled: Bool { record._title.count < 3 || record._items.isEmpty }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("edit.title".localized, text: $record._title) {
                        keyboardDismiss()
                    }
                    DatePicker("edit.date".localized, selection: $record._date)
                }
                
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
            }
            .onTapGesture {
                keyboardDismiss()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("save.button".localized) {
                        PersistanceController.shared.copyRecord(from: record)
                        record.isEditing = false
                        PersistanceController.shared.save()
                        isPresented.toggle()
                    }
                    .disabled(isDisabled)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("exit.button".localized) {
                        isPresented.toggle()
                    }
                    .foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        OrderView(record: record)
                    } label: {
                        Text("edit.button".localized)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            if record.isEditing {
                record.date = Date()
            }
        }
    }
    
    func keyboardDismiss() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
    
    var _title: String {
        get { title ?? "" }
        set { title = newValue }
    }
}

extension DayRecord {
    var _title: String {
        get { title ?? "" }
        set { title = newValue }
    }
    
    var _date: Date {
        get { date ?? Date() }
        set { date = newValue }
    }
}
