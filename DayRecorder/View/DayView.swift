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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        List {
            ForEach(record._items) { item in
                if !item.photos.isEmpty {
                    Section(item.title ?? "") {
                        PhotoView(images: item.photos)
                            .frame(height: 200)
                    }
                }
                
                if !item.text.isEmpty {
                    Section(item.title ?? "") {
                        Text(item.text)
                    }
                }
            }
            
            Text(record.dateStringLong)
                .font(.footnote)
        }
        .navigationBarTitle(record.title ?? "-")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("수정") {
                    isPresented.toggle()
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("삭제") {
                    presentationMode.wrappedValue.dismiss()
                    PersistanceController.shared.delete(record)
                    PersistanceController.shared.save()
                }
                .foregroundColor(.red)
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
        get { items?.array as? [DayRecordItem] ?? [] }
        set { items = NSOrderedSet(array: newValue) }
    }
}

extension DayRecord {
    var dateStringLong: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분 작성한 글입니다."
        return formatter.string(from: _date)
    }
}
