//
//  OrderView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/19.
//

import SwiftUI

struct OrderView: View {
    @ObservedObject var record: DayRecord
    var isDisabled: Bool { record._items.count < 1 || record._items.contains(where: { $0._title.isEmpty }) }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(record._items.indices, id: \.self) { idx in
                    HStack {
                        TextField("제목을 입력하세요.", text: $record._items[idx]._title)
                        Spacer()
                        Image(systemName: record._items[idx].content is [UIImage] ? "photo" : "text.alignleft")
                    }
                    .swipeActions(allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            record._items.remove(at: idx)
                            PersistanceController.shared.save()
                        } label: {
                            Image(systemName: "trash.fill")
                        }
                    }
                }
                .onMove { offset, index in
                    record._items.move(fromOffsets: offset, toOffset: index)
                }
                .onDelete { offset in
                    record._items.remove(atOffsets: offset)
                }
                
                Menu {
                    Button {
                        record._items.append(PersistanceController.shared.makeItem(title: "새 사진 아이템", content: [UIImage]()))
                    } label: {
                        Label("사진 아이템", systemImage: "photo")
                    }
                    
                    Button {
                        record._items.append(PersistanceController.shared.makeItem(title: "새 글 아이템", content: ""))
                    } label: {
                        Label("글 아이템", systemImage: "text.alignleft")
                    }
                } label: {
                    Text("새로운 아이템 추가하기")
                        .disabled(record._items.count > 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("")
        }
        .onDisappear {
            isDisabled ? PersistanceController.shared.rollback() : PersistanceController.shared.save()
        }
    }
}
