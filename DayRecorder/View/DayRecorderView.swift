//
//  DayRecorderView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

struct DayRecorderView: View {
    @FetchRequest(
        entity: DayRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \DayRecord.date, ascending: false)],
        predicate: NSPredicate(format: "isEditing == %@", NSNumber(value: false)),
        animation: nil
    ) var records: FetchedResults<DayRecord>
    
    @State var isPresented = false
    @State var selectedRecord: DayRecord!
    @State var isDisplayingDialog = false
    @State var isEditing = false
    
    var body: some View {
        NavigationView {
            List {
                if records.isEmpty {
                    Section(Date().description) {
                        VStack(spacing: 20) {
                            Text("새로운 기록을 시작해 보세요.")
                            
                            PhotoView(images: (1...3).map { UIImage(named: "ex-\($0)")! })
                                .frame(height: 125)
                        }
                    }
                    .onTapGesture {
                        isPresented.toggle()
                    }
                }
                
                ForEach(records) { record in
                    Section(record.dateString ?? "-") {
                        VStack(spacing: 20) {
                            NavigationLink(destination: {
                                DayView(record: record)
                            }) {
                                Text(record.title ?? "-")
                            }
                            
                            if !record.images.isEmpty {
                                PhotoView(images: record.images)
                                    .frame(height: 125)
                            }
                        }
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            PersistanceController.shared.delete(record)
                            PersistanceController.shared.save()
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
            }
            .navigationTitle("DayRecorder")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "highlighter")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    
                }
            }
            .sheet(isPresented: $isPresented) {
                PersistanceController.shared.rollback()
            } content: {
                EditView(record: PersistanceController.shared.fetchEditingRecord(), isPresented: $isPresented)
            }
        }
    }
}


extension DayRecord {
    var dateString: String? {
        guard let date = date else {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    var images: [UIImage] {
        guard let items = items?.array as? [DayRecordItem] else {
            return []
        }
        return items.compactMap { $0.content as? [UIImage] }.reduce(into: []) { $0 += $1 }
    }
}
