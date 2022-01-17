//
//  EditView.swift
//  DayRecorder
//
//  Created by JAECHEOL JUNG on 2022/01/14.
//

import SwiftUI

enum EditItemType {
    case photo, text
}

struct EditItem {
    var title: String
    var photos: [UIImage]
    var text: String
    var type: EditItemType
}


struct EditView: View {
    
    @EnvironmentObject var model: DayRecorder
    @State var items: [EditItem]
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            List {
                ForEach(items.indices) { idx in
                    Section(items[idx].title) {
                        if items[idx].type == .photo {
                            PhotoEditView(images: $items[idx].photos)
                                .frame(height: 160)
                        }
                        if items[idx].type == .text {
                            TextEditView(text: $items[idx].text)
                                .frame(height: 160)
                        }
                    }
                }
                
                Button("Save") {
                    
                    
                    isPresented.toggle()
                }
                
                Button("Cancel") {
                    zip(model.editingRecord!.itemArray, items).forEach {
                        if $1.type == .text {
                            $0.content = $1.text as NSObject
                        }
                        if $1.type == .photo {
                            $0.content = $1.photos as NSObject
                        }
                    }
                    isPresented.toggle()
                }
                .foregroundColor(.red)
            }
        }
    }
}
