//
//  DayView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

struct DayView: View {
    @State var isPresented = false
    @ObservedObject var record: DayRecord
    
    var body: some View {
        List {
            ForEach(record._items) { item in
                Section(item.title ?? "-") {
                    if !item.photos.isEmpty {
                        PhotoView(images: item.photos)
                            .frame(height: 160)
                    }
                    if !item.text.isEmpty {
                        Text(item.text)
                            .frame(height: 160)
                    }
                }
            }
        }
        .navigationBarTitle(record.title ?? "-")
        .toolbar {
            Button("Update") {
                isPresented.toggle()
            }
        }
        .sheet(isPresented: $isPresented) {
            PersistanceController.shared.rollback()
        } content: {
            EditView(record: record, isPresented: $isPresented)
        }
    }
}

extension DayRecord {
    var _items: [DayRecordItem] {
        items?.array as? [DayRecordItem] ?? []
    }
}
