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
                        TextField("edit.title".localized, text: $record._items[idx]._title)
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
                        record._items.append(PersistanceController.shared.makeItem(title: "new.photo.item".localized, content: [UIImage]()))
                    } label: {
                        Label("new.photo.item", systemImage: "photo")
                    }
                    
                    Button {
                        record._items.append(PersistanceController.shared.makeItem(title: "new.text.item".localized, content: ""))
                    } label: {
                        Label("new.text.item".localized, systemImage: "text.alignleft")
                    }
                } label: {
                    Text("add.new.item".localized)
                        .disabled(record._items.count > 10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onDisappear {
            isDisabled ? PersistanceController.shared.rollback() : PersistanceController.shared.save()
        }
    }
}
